// `render`: the generated half of the workflow READMEs (ADR 0015). It writes
// named blocks between markers in docs/workflow/README.md (the journey) and in
// each docs/workflow/NN-<stage>/README.md (one stage), from the same model the
// check reads, and leaves every line outside the markers as it is: that text
// is hand-written (TASK-40).
//
//   <!-- generated:start steps -->
//   ...written by render, never by hand...
//   <!-- generated:end steps -->
//
// A README that does not exist yet is created with a placeholder heading and
// every block; a block missing from an existing README is added at its end; a
// block may be moved anywhere in the file and stays there. Render refuses (and
// writes nothing) when the model fails the check, a marker is malformed or a
// generated diagram is outside the Mermaid subset of src/mermaid.ts.
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { join, relative } from "node:path";
import { checkModel, modelDir, placeholderCap, repoRoot, type Indexed } from "./check";
import { formatIssue } from "./load";
import { label, mermaidBlocks, nodeId, validateFlowchart } from "./mermaid";
import type { Action, Loop, Stage, Step } from "./model";

/** The blocks each README holds, in the order a new README gets them. */
export const blockNames = {
  journey: ["stages", "journey", "handovers", "actors"],
  stage: ["summary", "diagram", "steps", "gates", "loops", "artifacts", "actions"],
} as const;

export const startMarker = (name: string) => `<!-- generated:start ${name} -->`;
export const endMarker = (name: string) => `<!-- generated:end ${name} -->`;
const markerLine = /^<!-- generated:(start|end) ([a-z][a-z0-9-]*) -->$/;

const intro =
  "<!-- Hand-written text goes outside the generated blocks. `bun run render` (tools/workflow) rewrites only the lines between a block's start and end markers, from catalog.yaml and the stage.yaml files; edit the YAML, not a block. -->";

export type Block = [name: string, content: string];
export class MarkerError extends Error {}

/**
 * Writes each block between its markers in `text` and returns the new text.
 * Lines outside the markers are kept as they are; a block with no markers yet
 * is added at the end of the file. Malformed, unknown, repeated, nested or
 * unclosed markers throw a MarkerError naming `file` and the line.
 */
export function applyBlocks(text: string, blocks: Block[], file: string): string {
  const lines = text.replace(/\r\n/g, "\n").split("\n");
  const known = new Map(blocks);
  const found = new Map<string, [number, number]>();
  let open: [string, number] | undefined;
  const fail = (i: number, reason: string) => {
    throw new MarkerError(`${file}:${i + 1}: ${reason}`);
  };
  lines.forEach((line, i) => {
    const m = markerLine.exec(line);
    if (!m) {
      // Only a line that starts like a marker can be a broken one; prose may mention markers.
      if (line.trimStart().startsWith("<!-- generated:")) {
        fail(i, `malformed marker; write ${startMarker("<name>")} or ${endMarker("<name>")} alone on its line`);
      }
      return;
    }
    const [, kind, name = ""] = m;
    if (!known.has(name)) fail(i, `unknown block "${name}"; this README's blocks are ${[...known.keys()].join(", ")}`);
    if (kind === "start") {
      if (open) fail(i, `block ${name} starts inside block ${open[0]}, which has not ended`);
      if (found.has(name)) fail(i, `block ${name} appears twice`);
      open = [name, i];
    } else {
      if (!open || open[0] !== name) fail(i, `${endMarker(name)} has no matching start`);
      found.set(name, [(open as [string, number])[1], i]);
      open = undefined;
    }
  });
  if (open) fail(open[1], `block ${open[0]} has no ${endMarker(open[0])}`);
  const out = [...lines];
  // Bottom up, so the line numbers of the blocks above still hold.
  for (const [name, [start, end]] of [...found].sort((a, b) => b[1][0] - a[1][0])) {
    out.splice(start, end - start + 1, ...blockLines(name, known.get(name) as string));
  }
  const missing = blocks.filter(([name]) => !found.has(name));
  if (missing.length > 0) {
    while (out.length > 0 && out[out.length - 1] === "") out.pop();
    for (const [name, content] of missing) out.push("", ...blockLines(name, content));
    out.push("");
  }
  return out.join("\n");
}

const blockLines = (name: string, content: string) => [startMarker(name), "", ...content.split("\n"), "", endMarker(name)];

// --- Markdown helpers.

const code = (id: string) => `\`${id}\``;
const codes = (ids: Iterable<string>) => [...ids].map(code).join(", ");
/** One table cell: on one line, pipes escaped. */
const cell = (text: string | undefined) => (text ?? "").replace(/\s+/g, " ").trim().replace(/\|/g, "\\|");
const table = (head: string[], rows: string[][]) =>
  [`| ${head.join(" | ")} |`, `|${head.map(() => "---").join("|")}|`, ...rows.map((r) => `| ${r.join(" | ")} |`)].join("\n");
const mermaid = (lines: string[]) => ["```mermaid", ...lines, "```"].join("\n");
const plural = (n: number, one: string, many = `${one}s`) => `${n} ${n === 1 ? one : many}`;

// --- The model, seen per stage.

type View = {
  ix: Indexed;
  stages: Stage[];
  folder: Map<string, string>; // stage ID -> folder
  stageOf: Map<string, string>; // step ID -> stage ID
  order: Map<string, number>; // stage ID -> position
  /** `from\0to` -> what one stage hands to another: artifacts it writes that the other reads, and gate or loop branches into it. */
  handovers: Map<string, { artifacts: Set<string>; branches: Set<string> }>;
};

function view(ix: Indexed): View {
  const stages = ix.model.stages.map((s) => s.data);
  const folder = new Map(ix.model.stages.map((s) => [s.data.id, s.folder]));
  const order = new Map(stages.map((s, i) => [s.id, i]));
  const stageOf = new Map<string, string>();
  for (const s of stages) for (const step of s.steps) stageOf.set(step.id, s.id);
  const handovers: View["handovers"] = new Map();
  const handover = (from: string, to: string) => {
    const key = `${from}\u0000${to}`;
    let h = handovers.get(key);
    if (!h) handovers.set(key, (h = { artifacts: new Set(), branches: new Set() }));
    return h;
  };
  for (const s of stages) {
    for (const step of s.steps) {
      for (const a of step.inputs) {
        for (const p of ix.graph.producers.get(a) ?? []) {
          const from = stageOf.get(p);
          if (from && from !== s.id) handover(from, s.id).artifacts.add(a);
        }
      }
    }
    for (const g of s.gates) {
      for (const [branch, to] of [["pass", g.pass], ["fail", g.fail]] as const) {
        const target = stageOf.get(to);
        if (target && target !== s.id) handover(s.id, target).branches.add(`${g.id} ${branch}`);
      }
    }
    for (const l of s.loops) {
      const target = stageOf.get(l.escalate);
      if (target && target !== s.id) handover(s.id, target).branches.add(`${l.id} cap`);
    }
  }
  return { ix, stages, folder, order, stageOf, handovers };
}

/** Handovers sorted by the stage order of their source, then their target. */
function sortedHandovers(v: View) {
  return [...v.handovers]
    .map(([key, h]) => {
      const [from = "", to = ""] = key.split("\u0000");
      return { from, to, ...h };
    })
    .sort((a, b) => (v.order.get(a.from) ?? 0) - (v.order.get(b.from) ?? 0) || (v.order.get(a.to) ?? 0) - (v.order.get(b.to) ?? 0));
}

const capText = (l: Loop) => `${l.cap.attended} attended${l.cap.unattended ? `, ${l.cap.unattended} unattended` : ""}`;
const number = (v: View, stage: string) => (v.folder.get(stage) ?? "").slice(0, 2);
const stageLink = (v: View, stage: string, from: "journey" | "stage") =>
  `[${stage}](${from === "journey" ? "" : "../"}${v.folder.get(stage)}/README.md)`;

// --- Diagram edges.

/** An edge in a diagram; `droppable` when a longer path may stand for it, `cut` when it goes back (a loop, or a later stage to an earlier one). */
type Edge = { from: string; to: string; text?: string; dotted?: boolean; droppable?: boolean; cut?: boolean };

const reduced = "An arrow implied by a longer path (not through an optional step) is left out; the tables list every input and handover.";

/**
 * Drops each droppable edge whose target its source also reaches by another
 * path. Edges that go back never count as a path, nor does a path through an
 * `optional` node (a step with `when`), which may not run.
 */
function reduce(edges: Edge[], optional = new Set<string>()): Edge[] {
  const reaches = (skip: Edge): boolean => {
    const seen = new Set([skip.from]);
    for (const queue = [skip.from]; queue.length > 0; ) {
      const node = queue.pop() as string;
      for (const e of edges) {
        if (e === skip || e.cut || e.from !== node || seen.has(e.to)) continue;
        if (e.to === skip.to) return true;
        seen.add(e.to);
        if (!optional.has(e.to)) queue.push(e.to);
      }
    }
    return false;
  };
  return edges.filter((e) => !e.droppable || !reaches(e));
}

const edgeLine = (e: Edge) => `  ${e.from} ${e.dotted ? "-.->" : "-->"}${e.text ? `|${label(e.text)}|` : ""} ${e.to}`;

// --- The journey README: docs/workflow/README.md.

function journeyBlocks(v: View): Block[] {
  const handovers = sortedHandovers(v);
  const from = (s: string) => handovers.filter((h) => h.to === s).map((h) => h.from);
  const to = (s: string) => handovers.filter((h) => h.from === s).map((h) => h.to);
  const links = (ids: string[]) => ids.map((s) => stageLink(v, s, "journey")).join(", ");

  const stages = table(
    ["#", "Stage", "Name", "Steps", "Gates", "Loops", "Reads from", "Hands to"],
    v.stages.map((s) => [
      number(v, s.id),
      stageLink(v, s.id, "journey"),
      cell(s.name),
      String(s.steps.length),
      String(s.gates.length),
      String(s.loops.length),
      links(from(s.id)),
      links(to(s.id)),
    ]),
  );

  // The stages in order, joined where one hands something to another: forward solid, back dotted.
  const journey = mermaid([
    "flowchart LR",
    ...v.stages.map((s) => `  ${nodeId("st", s.id)}[${label(`${number(v, s.id)} ${s.id}: ${s.name}`)}]`),
    `  %% ${reduced}`,
    ...reduce(
      handovers.map((h) => {
        const back = (v.order.get(h.to) ?? 0) < (v.order.get(h.from) ?? 0);
        const what = [h.artifacts.size ? plural(h.artifacts.size, "artifact") : "", h.branches.size ? plural(h.branches.size, "branch", "branches") : ""];
        return { from: nodeId("st", h.from), to: nodeId("st", h.to), text: what.filter(Boolean).join(", "), dotted: back, cut: back, droppable: !back };
      }),
    ).map(edgeLine),
  ]);

  const handoverTable = table(
    ["From", "To", "Artifacts", "Branches"],
    handovers.map((h) => [code(h.from), code(h.to), codes([...h.artifacts].sort()), codes([...h.branches].sort())]),
  );

  const actors = table(
    ["ID", "Kind", "Name", "Does"],
    [...v.ix.model.catalog.data.actors].sort((a, b) => a.id.localeCompare(b.id)).map((a) => [code(a.id), a.kind, cell(a.name), cell(a.does)]),
  );

  return [
    ["stages", stages],
    ["journey", journey],
    ["handovers", handoverTable],
    ["actors", actors],
  ];
}

// --- One stage's README: docs/workflow/NN-<stage>/README.md.

function stageBlocks(v: View, stage: Stage): Block[] {
  const { defs, graph } = v.ix;
  const inStage = new Set(stage.steps.map((s) => s.id));
  const handovers = sortedHandovers(v);
  const links = (ids: string[]) => (ids.length ? ids.map((s) => stageLink(v, s, "stage")).join(", ") : "none");
  const where = (step: string) => (inStage.has(step) ? code(step) : `${code(step)} (stage ${code(v.stageOf.get(step) ?? "?")})`);

  const summary = [
    `- **Stage:** ${number(v, stage.id)} ${code(stage.id)}, ${cell(stage.name)}. Facts: [\`stage.yaml\`](stage.yaml), ${plural(stage.steps.length, "step")}, ${plural(stage.gates.length, "gate")}, ${plural(stage.loops.length, "loop")}.`,
    `- **Purpose:** ${cell(stage.purpose)}`,
    `- **Entry:** ${cell(stage.entry)}`,
    `- **Exit:** ${cell(stage.exit)}`,
    `- **Reads from:** ${links(handovers.filter((h) => h.to === stage.id).map((h) => h.from))}. **Hands to:** ${links(handovers.filter((h) => h.from === stage.id).map((h) => h.to))}.`,
  ].join("\n");

  // Diagram: steps as boxes, gates as diamonds, steps of another stage a branch leads to as rounded boxes.
  const gates = new Map(stage.gates.map((g) => [g.id, g]));
  const loopsOn = (gate: string) => stage.loops.filter((l) => l.gate === gate);
  const outside = new Set<string>();
  for (const g of stage.gates) for (const t of [g.pass, g.fail]) if (!inStage.has(t)) outside.add(t);
  for (const l of stage.loops) if (!inStage.has(l.escalate)) outside.add(l.escalate);
  const edges: Edge[] = [];
  for (const s of stage.steps) {
    const gate = s.gate ? gates.get(s.gate) : undefined;
    for (const t of graph.next.get(s.id) ?? []) {
      // The edges to a gate's branches go through the gate's diamond instead.
      if (!inStage.has(t) || t === s.id || (gate && (t === gate.pass || t === gate.fail))) continue;
      edges.push({ from: nodeId("s", s.id), to: nodeId("s", t), droppable: true });
    }
  }
  const target = (step: string) => nodeId(inStage.has(step) ? "s" : "x", step);
  for (const s of stage.steps) {
    const gate = s.gate ? gates.get(s.gate) : undefined;
    if (!gate) continue;
    const g = nodeId("g", gate.id);
    const loops = loopsOn(gate.id);
    edges.push({ from: nodeId("s", s.id), to: g });
    edges.push({ from: g, to: target(gate.pass), text: "pass" });
    if (loops.length === 0) edges.push({ from: g, to: target(gate.fail), text: "fail" });
    else edges.push({ from: g, to: target(gate.fail), text: `fail, ${loops.map((l) => l.id).join(", ")}`, dotted: true, cut: true });
    for (const l of loops) {
      edges.push({ from: g, to: target(l.escalate), text: `cap ${capText(l)}${placeholderCap(l) ? " (placeholder)" : ""}`, dotted: true });
    }
  }
  const diagram = mermaid([
    "flowchart TD",
    `  %% ${reduced}`,
    ...stage.steps.map((s) => `  ${nodeId("s", s.id)}[${label(s.id)}]`),
    ...stage.gates.map((g) => `  ${nodeId("g", g.id)}{${label(g.id)}}`),
    ...[...outside].sort().map((s) => `  ${nodeId("x", s)}([${label(s)}])`),
    ...reduce(edges, new Set(stage.steps.filter((s) => s.when).map((s) => nodeId("s", s.id)))).map(edgeLine),
  ]);

  const steps = table(
    ["ID", "Name", "Actor", "Action", "Inputs", "Outputs", "Gate", "When"],
    stage.steps.map((s: Step) => [code(s.id), cell(s.name), code(s.actor), code(s.action), codes(s.inputs), codes(s.outputs), s.gate ? code(s.gate) : "", cell(s.when)]),
  );

  const checker = (gate: string) => graph.gateStep(gate);
  const gateTable = stage.gates.length
    ? table(
        ["ID", "Name", "Checked by", "Check", "Pass", "Fail"],
        stage.gates.map((g) => [code(g.id), cell(g.name), where(checker(g.id) ?? "?"), cell(g.check), where(g.pass), where(g.fail)]),
      )
    : "No gates in this stage.";

  const loopTable = stage.loops.length
    ? table(
        ["ID", "Name", "Gate", "Cap", "At the cap"],
        stage.loops.map((l) => [
          code(l.id),
          cell(l.name),
          code(l.gate),
          placeholderCap(l) ? `${capText(l)}, **placeholder** ([GAPS.md](../GAPS.md))` : capText(l),
          where(l.escalate),
        ]),
      )
    : "No loops in this stage.";

  const used = [...new Set(stage.steps.flatMap((s) => [...s.inputs, ...s.outputs]))].sort();
  const artifacts = table(
    ["ID", "Name", "Path", "Visibility", "Made by"],
    used.map((id) => {
      const a = defs.artifact.get(id)?.item;
      const made = a?.given ? "given" : codes(graph.producers.get(id) ?? []);
      return [code(id), cell(a?.name), a?.path ? code(a.path) : "", a?.visibility ?? "", made];
    }),
  );

  const runs = (a: Action) =>
    a.kind === "cmd" ? code(a.run) : a.kind === "skill" ? `skill ${code(a.skill)}` : a.kind === "agent" ? `agent ${code(a.agent)}` : cell(a.does);
  const actionIds = [...new Set(stage.steps.map((s) => s.action))].sort();
  const actions = table(
    ["ID", "Kind", "Name", "Runs"],
    actionIds.map((id) => {
      const a = defs.action.get(id)?.item;
      return a ? [code(id), a.kind, cell(a.name), runs(a)] : [code(id), "", "", ""];
    }),
  );

  return [
    ["summary", summary],
    ["diagram", diagram],
    ["steps", steps],
    ["gates", gateTable],
    ["loops", loopTable],
    ["artifacts", artifacts],
    ["actions", actions],
  ];
}

// --- The files.

/** One README: its absolute `path`, the `file` as printed (repository-relative), its new text, and whether that differs from the disk. */
export type Rendered = { path: string; file: string; text: string; changed: boolean };
export type RenderResult = { problems: string[]; files: Rendered[] };

/**
 * Renders every README of the model in `dir`. With `write`, writes the files
 * that change; without, only reports them (`--check`). Nothing is written when
 * there is any problem.
 */
export function render(dir = modelDir, root = repoRoot, { write }: { write: boolean } = { write: false }): RenderResult {
  const checked = checkModel(dir, root);
  if (!checked.indexed) {
    return { problems: ["the model must pass `bun run check` before it renders:", ...checked.issues.map(formatIssue)], files: [] };
  }
  const v = view(checked.indexed);
  const shown = (file: string) => relative(root, file).replaceAll("\\", "/");
  const targets: { file: string; heading: string; blocks: Block[] }[] = [
    { file: join(dir, "README.md"), heading: "# The client workflow", blocks: journeyBlocks(v) },
    ...v.stages.map((s) => ({
      file: join(dir, v.folder.get(s.id) as string, "README.md"),
      heading: `# ${number(v, s.id)} ${s.id}: ${s.name}`,
      blocks: stageBlocks(v, s),
    })),
  ];
  const problems: string[] = [];
  const files: Rendered[] = [];
  for (const { file, heading, blocks } of targets) {
    for (const [name, content] of blocks) {
      for (const { line, body } of mermaidBlocks(content)) {
        for (const p of validateFlowchart(body)) problems.push(`${shown(file)}: block ${name}, diagram at block line ${line}: ${p}`);
      }
    }
    const before = existsSync(file) ? readFileSync(file, "utf8") : undefined;
    try {
      const text = applyBlocks(before ?? `${heading}\n\n${intro}\n`, blocks, shown(file));
      files.push({ path: file, file: shown(file), text, changed: before?.replace(/\r\n/g, "\n") !== text });
    } catch (e) {
      if (!(e instanceof MarkerError)) throw e;
      problems.push(e.message);
    }
  }
  if (write && problems.length === 0) {
    for (const f of files) if (f.changed) writeFileSync(f.path, f.text);
  }
  return { problems, files };
}

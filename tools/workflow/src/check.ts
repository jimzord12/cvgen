// The model-wide check: the whole Workflow Model (docs/workflow/catalog.yaml
// and every NN-<stage>/stage.yaml) at levels 1 and 2 of the approved design
// (docs/proposals/workflow-model.md; levels in archive/work-records/workflow-model/handoff.md).
//
// Level 1, shape and references: every file matches its type, every ID is
// unique and resolves, and what the facts name exists: source anchors (file and
// line range), the repository files of given artifacts, skills, agents, and the
// subcommands of the Python scripts a `cmd` action runs (through `--help`).
// Level 2, flow: edges are derived (a step that reads another step's output
// follows it; a gate's step is followed by its pass and fail steps), every
// input is produced or given, every step is reached, and a cycle exists only
// where a declared loop breaks it.
//
// Every rule has an ID (`rules` below), printed with each problem, and a broken
// fixture under test/fixtures/<rule>/ that makes exactly that rule fire.
import { spawnSync } from "node:child_process";
import { existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { join, relative } from "node:path";
import { formatPath, loadFile, type Issue, type LineAt } from "./load";
import type { Action, Actor, Artifact, Catalog, Gate, Loop, Stage, Step } from "./model";

export const repoRoot = join(import.meta.dirname, "..", "..", "..");
export const modelDir = join(repoRoot, "docs", "workflow");

/** Every rule the check applies, with what it refuses. */
export const rules = {
  // Level 1: shape and references.
  shape: "a file is missing, is not valid YAML or does not match its type",
  "stage-folder": "a stage's folder is not NN-<stage id>",
  "duplicate-id": "an ID is defined twice in the model",
  "step-prefix": "a step's ID does not start with its stage's ID",
  unresolved: "a reference names no entity of its kind",
  scope: "an artifact or action defined in one stage is used outside it (shared ones belong in catalog.yaml)",
  unused: "an actor, action or artifact that nothing uses",
  "gate-step": "a gate that no step checks, or that more than one step checks",
  "gate-branches": "a gate whose pass and fail go to the same step",
  source: "a source anchor whose file does not exist or whose lines run past its end",
  "given-path": "a given artifact whose repository path does not exist",
  skill: "a skill action naming no .claude/skills/<name>/SKILL.md",
  agent: "an agent action naming no .claude/agents/<name>.md and no built-in agent",
  command: "a cmd action running a Python script outside scripts/, one that does not exist, or a subcommand its --help does not list",
  // Level 2: flow.
  "given-produced": "an artifact marked given: true that a step produces",
  unproduced: "a step input that no step produces and that is not given: true",
  unreachable: "a step that the given artifacts, gate branches and loop escalations never reach",
  cycle: "a cycle that no declared loop breaks",
  "loop-open": "a declared loop whose gate's fail branch never leads back to the gate's step",
  "dead-end": "a step with no outputs and no gate that is not an escalation step, a gate branch or optional (when)",
} as const;
export type Rule = keyof typeof rules;

/** Built-in Claude Code agents an `agent` action may name without a file. */
const builtInAgents = new Set(["general-purpose"]);

type Src = { file: string; lineAt: LineAt; stage?: string }; // no stage: catalog.yaml
type Def<T> = { item: T; src: Src; path: (string | number)[] };
type Kind = "actor" | "action" | "artifact" | "gate" | "step";

export type Model = {
  catalog: { data: Catalog; src: Src };
  stages: { data: Stage; src: Src; folder: string }[];
};

export type Result = { issues: Issue[]; notes: string[]; summary: string };

const show = (root: string, file: string) => relative(root, file).replaceAll("\\", "/");

/** Reads catalog.yaml and every NN-<stage>/stage.yaml in `dir`; any shape problem is returned instead of a model. */
export function loadModel(dir: string, root: string): { model?: Model; issues: Issue[] } {
  const issues: Issue[] = [];
  const shape = (file: string, message: string) => issues.push({ file, path: "(file)", message, rule: "shape" });
  const read = (file: string) => {
    const loaded = loadFile(file);
    for (const i of loaded.issues) issues.push({ ...i, file: show(root, file), rule: "shape" });
    return loaded;
  };
  const catalogFile = join(dir, "catalog.yaml");
  let catalog: Model["catalog"] | undefined;
  if (!existsSync(catalogFile)) shape(show(root, catalogFile), "catalog.yaml is missing");
  else {
    const loaded = read(catalogFile);
    if (loaded.kind === "catalog" && loaded.data) catalog = { data: loaded.data, src: { file: show(root, catalogFile), lineAt: loaded.lineAt } };
  }
  const stages: Model["stages"] = [];
  const folders = readdirSync(dir, { withFileTypes: true })
    .filter((d) => d.isDirectory() && /^\d{2}-/.test(d.name))
    .map((d) => d.name)
    .sort();
  for (const folder of folders) {
    const file = join(dir, folder, "stage.yaml");
    if (!existsSync(file)) {
      shape(show(root, file), `stage folder ${folder} has no stage.yaml`);
      continue;
    }
    const loaded = read(file);
    if (loaded.kind === "stage" && loaded.data) {
      stages.push({ data: loaded.data, folder, src: { file: show(root, file), lineAt: loaded.lineAt, stage: loaded.data.id } });
    }
  }
  if (folders.length === 0) shape(show(root, dir), "no stage folder (NN-<stage>/stage.yaml)");
  return issues.length > 0 || !catalog ? { issues } : { model: { catalog, stages }, issues };
}

/** Checks the model in `dir` (default docs/workflow) against the repository at `root`. */
export function checkModel(dir = modelDir, root = repoRoot): Result {
  const { model, issues } = loadModel(dir, root);
  if (!model) return { issues, notes: [], summary: "" };
  return new Checker(model, root).run();
}

class Checker {
  issues: Issue[] = [];
  notes: string[] = [];
  defs = {
    actor: new Map<string, Def<Actor>>(),
    action: new Map<string, Def<Action>>(),
    artifact: new Map<string, Def<Artifact>>(),
    gate: new Map<string, Def<Gate>>(),
    loop: new Map<string, Def<Loop>>(),
    step: new Map<string, Def<Step>>(),
  };
  used = new Set<string>();
  steps: Def<Step>[] = []; // model order: stage folders in order, steps in file order

  constructor(
    readonly model: Model,
    readonly root: string,
  ) {}

  report(rule: Rule, src: Src, path: (string | number)[], message: string) {
    this.issues.push({ file: src.file, line: src.lineAt(path), path: formatPath(path), message, rule });
  }

  run(): Result {
    this.index();
    this.references();
    this.existence();
    this.flow();
    const placeholders = [...this.defs.loop.values()].filter((d) => d.item.name.includes("(placeholder cap)"));
    if (placeholders.length > 0) {
      const list = placeholders.map((d) => `${d.item.id} (${d.item.cap.attended} attended${d.item.cap.unattended ? `, ${d.item.cap.unattended} unattended` : ""})`);
      this.notes.push(`NOTE ${placeholders.length} placeholder loop cap(s), not from a source (docs/workflow/GAPS.md): ${list.join(", ")}`);
    }
    const n = (m: Map<string, unknown>) => m.size;
    const summary = `${this.model.stages.length} stages, ${n(this.defs.step)} steps, ${n(this.defs.artifact)} artifacts, ${n(this.defs.gate)} gates, ${n(this.defs.loop)} loops`;
    const order = (i: Issue) => `${i.file}\u0000${String(i.line ?? 0).padStart(6, "0")}`;
    this.issues.sort((a, b) => (order(a) < order(b) ? -1 : order(a) > order(b) ? 1 : 0));
    return { issues: this.issues, notes: this.notes, summary };
  }

  // --- Level 1: IDs, references, scope, use.

  index() {
    const ids = new Map<string, { src: Src; path: (string | number)[] }>();
    const define = <T extends { id: string }>(kind: keyof Checker["defs"] | "stage", item: T, src: Src, path: (string | number)[]) => {
      const earlier = ids.get(item.id);
      if (earlier) {
        const at = `${earlier.src.file}:${earlier.src.lineAt(earlier.path) ?? "?"}`;
        this.report("duplicate-id", src, [...path, "id"], `${item.id} is already defined at ${at}`);
        return;
      }
      ids.set(item.id, { src, path });
      if (kind !== "stage") (this.defs[kind] as unknown as Map<string, Def<T>>).set(item.id, { item, src, path });
    };
    const { catalog, stages } = this.model;
    catalog.data.actors.forEach((a, i) => define("actor", a, catalog.src, ["actors", i]));
    catalog.data.actions.forEach((a, i) => define("action", a, catalog.src, ["actions", i]));
    catalog.data.artifacts.forEach((a, i) => define("artifact", a, catalog.src, ["artifacts", i]));
    for (const { data: stage, src, folder } of stages) {
      define("stage", stage, src, []);
      if (folder.replace(/^\d{2}-/, "") !== stage.id) {
        this.report("stage-folder", src, ["id"], `stage ${stage.id} lives in folder ${folder}; the folder must be NN-${stage.id}`);
      }
      stage.steps.forEach((s, i) => {
        define("step", s, src, ["steps", i]);
        if (!s.id.startsWith(`${stage.id}.`)) {
          this.report("step-prefix", src, ["steps", i, "id"], `step ${s.id} is in stage ${stage.id}, so its ID must start with "${stage.id}."`);
        }
      });
      stage.gates.forEach((g, i) => define("gate", g, src, ["gates", i]));
      stage.loops.forEach((l, i) => define("loop", l, src, ["loops", i]));
      stage.artifacts.forEach((a, i) => define("artifact", a, src, ["artifacts", i]));
      stage.actions.forEach((a, i) => define("action", a, src, ["actions", i]));
    }
    this.steps = [...this.defs.step.values()];
  }

  /** Resolves one reference; artifacts and actions defined in a stage may be used only there. */
  ref(kind: Kind, id: string, src: Src, path: (string | number)[]) {
    if (kind !== "gate") this.used.add(id);
    const def = (this.defs[kind] as Map<string, Def<{ id: string }>>).get(id);
    if (!def) {
      this.report("unresolved", src, path, `${id} names no ${kind} in the model`);
      return;
    }
    if ((kind === "artifact" || kind === "action") && def.src.stage && def.src.stage !== src.stage) {
      const where = src.stage ? `stage ${src.stage}` : "catalog.yaml";
      this.report("scope", src, path, `${id} is defined in stage ${def.src.stage} but used in ${where}; move it to catalog.yaml`);
    }
  }

  references() {
    for (const { item: s, src, path } of this.steps) {
      this.ref("actor", s.actor, src, [...path, "actor"]);
      this.ref("action", s.action, src, [...path, "action"]);
      s.inputs.forEach((a, j) => this.ref("artifact", a, src, [...path, "inputs", j]));
      s.outputs.forEach((a, j) => this.ref("artifact", a, src, [...path, "outputs", j]));
      if (s.gate) this.ref("gate", s.gate, src, [...path, "gate"]);
    }
    for (const { item: g, src, path } of this.defs.gate.values()) {
      this.ref("step", g.pass, src, [...path, "pass"]);
      this.ref("step", g.fail, src, [...path, "fail"]);
      if (g.pass === g.fail) this.report("gate-branches", src, [...path, "fail"], `${g.id} sends pass and fail to the same step ${g.pass}; a gate needs two different branches`);
      const checkers = this.steps.filter((d) => d.item.gate === g.id).map((d) => d.item.id);
      if (checkers.length === 0) this.report("gate-step", src, path, `no step checks ${g.id}; set gate: ${g.id} on the step that ends with this check`);
      if (checkers.length > 1) this.report("gate-step", src, path, `${g.id} is checked by ${checkers.length} steps (${checkers.join(", ")}); a gate belongs to one step`);
    }
    for (const { item: l, src, path } of this.defs.loop.values()) {
      this.ref("gate", l.gate, src, [...path, "gate"]);
      this.ref("step", l.escalate, src, [...path, "escalate"]);
    }
    for (const { item: a, src, path } of this.defs.artifact.values()) {
      if (a.schema) this.ref("artifact", a.schema, src, [...path, "schema"]);
    }
    for (const kind of ["actor", "action", "artifact"] as const) {
      for (const { item, src, path } of this.defs[kind].values()) {
        if (!this.used.has(item.id)) this.report("unused", src, [...path, "id"], `${item.id} is defined but nothing uses it`);
      }
    }
  }

  // --- Level 1: what the facts name exists.

  lineCounts = new Map<string, number | "folder">();
  helps = new Map<string, { subcommands?: string[]; error?: string }>();

  existence() {
    const all: { sources: string[]; src: Src; path: (string | number)[] }[] = [
      ...this.model.stages.map(({ data, src }) => ({ sources: data.sources, src, path: [] })),
      ...Object.values(this.defs).flatMap((m) => [...m.values()].map((d) => ({ sources: (d.item as { sources: string[] }).sources, src: d.src, path: d.path }))),
    ];
    for (const { sources, src, path } of all) {
      sources.forEach((s, j) => {
        const problem = this.anchorProblem(s);
        if (problem) this.report("source", src, [...path, "sources", j], problem);
      });
    }
    for (const { item: a, src, path } of this.defs.artifact.values()) {
      if (a.given && a.path && !/[<>]/.test(a.path) && !existsSync(join(this.root, a.path))) {
        this.report("given-path", src, [...path, "path"], `${a.id} is given, but its path ${a.path} does not exist`);
      }
    }
    for (const { item: a, src, path } of this.defs.action.values()) {
      if (a.kind === "skill" && !existsSync(join(this.root, ".claude", "skills", a.skill, "SKILL.md"))) {
        this.report("skill", src, [...path, "skill"], `skill ${a.skill} has no .claude/skills/${a.skill}/SKILL.md`);
      }
      if (a.kind === "agent" && !builtInAgents.has(a.agent) && !existsSync(join(this.root, ".claude", "agents", `${a.agent}.md`))) {
        this.report("agent", src, [...path, "agent"], `agent ${a.agent} has no .claude/agents/${a.agent}.md and is not a built-in (${[...builtInAgents].join(", ")})`);
      }
      if (a.kind === "cmd") {
        for (const problem of this.commandProblems(a.run)) this.report("command", src, [...path, "run"], problem);
      }
    }
  }

  /** `path`, `path:12` or `path:12-30`: the file exists and the lines are inside it. */
  anchorProblem(source: string): string | undefined {
    const colon = source.lastIndexOf(":");
    const file = colon < 0 ? source : source.slice(0, colon);
    const full = join(this.root, file);
    if (!existsSync(full)) return `${file} does not exist`;
    if (colon < 0) return undefined;
    const [first, last = first] = source.slice(colon + 1).split("-").map(Number) as [number, number?];
    let count = this.lineCounts.get(full);
    if (count === undefined) {
      count = statSync(full).isDirectory() ? "folder" : readFileSync(full, "utf8").replace(/\r?\n$/, "").split(/\r?\n/).length;
      this.lineCounts.set(full, count);
    }
    if (count === "folder") return `${file} is a folder; a line range needs a file`;
    if (first < 1 || last > count) return `lines ${first}-${last} run past the end of ${file} (${count} lines)`;
    return undefined;
  }

  /** Every `python <script>.py <subcommand>` in a run line: the script exists and its --help lists the subcommand. */
  commandProblems(run: string): string[] {
    const problems: string[] = [];
    for (const m of run.matchAll(/\bpython3?\s+([\w./-]+\.py)(?:\s+([a-z][\w-]*))?/g)) {
      const [, script = "", sub] = m;
      // Only the repository's own scripts are run (with --help): a path outside scripts/, or one with a ".."
      // segment, is reported and never executed.
      if (!script.startsWith("scripts/") || script.split("/").includes("..")) {
        problems.push(`${script} is not under scripts/; the check runs --help only for the repository's own scripts`);
        continue;
      }
      if (!existsSync(join(this.root, script))) {
        problems.push(`${script} does not exist`);
        continue;
      }
      const help = this.help(script);
      if (help.error) problems.push(help.error);
      else if (!help.subcommands) {
        if (sub) problems.push(`${script} --help lists no subcommands ({a,b}), so ${sub} cannot be checked`);
      } else if (!sub || !help.subcommands.includes(sub)) {
        problems.push(`${script} has no subcommand ${sub ?? "(none given)"}; its --help lists ${help.subcommands.join(", ")}`);
      }
    }
    return problems;
  }

  help(script: string) {
    let help = this.helps.get(script);
    if (!help) {
      const python = process.env.PYTHON || "python";
      const p = spawnSync(python, [script, "--help"], { cwd: this.root, encoding: "utf8" });
      if (p.status !== 0) help = { error: `${python} ${script} --help failed (${p.error?.message ?? `exit ${p.status}`}): ${(p.stderr ?? "").trim().split("\n").pop()}` };
      else help = { subcommands: /\{([\w,-]+)\}/.exec(p.stdout)?.[1]?.split(",") };
      this.helps.set(script, help);
    }
    return help;
  }

  // --- Level 2: flow over the derived edges.

  flow() {
    const artifacts = this.defs.artifact;
    const producers = new Map<string, string[]>();
    for (const { item: s } of this.steps) for (const a of s.outputs) producers.set(a, [...(producers.get(a) ?? []), s.id]);
    const given = (id: string) => artifacts.get(id)?.item.given === true;

    for (const { item: s, src, path } of this.steps) {
      s.outputs.forEach((a, j) => {
        if (given(a)) this.report("given-produced", src, [...path, "outputs", j], `${a} is given: true, but ${s.id} produces it; given means no step makes it`);
      });
      s.inputs.forEach((a, j) => {
        if (artifacts.has(a) && !given(a) && !producers.has(a)) {
          this.report("unproduced", src, [...path, "inputs", j], `no step produces ${a} and it is not given: true`);
        }
      });
    }

    // Edges: producer -> reader for every input, and a gate's step -> its pass and fail steps.
    const next = new Map<string, Set<string>>(this.steps.map((d) => [d.item.id, new Set<string>()]));
    for (const { item: s } of this.steps) {
      for (const a of s.inputs) for (const p of producers.get(a) ?? []) next.get(p)?.add(s.id);
      const g = s.gate ? this.defs.gate.get(s.gate)?.item : undefined;
      if (g) for (const t of [g.pass, g.fail]) if (next.has(t)) next.get(s.id)?.add(t);
    }
    const gateStep = (gate: string) => {
      const checkers = this.steps.filter((d) => d.item.gate === gate);
      return checkers.length === 1 ? checkers[0]?.item.id : undefined;
    };

    // Reach: from the given artifacts, a step runs once all its inputs exist (an input no step
    // produces counts as there: `unproduced` reports it); a gate's step leads to both branches, and a
    // loop's gate step to its escalation step.
    const available = new Set([...artifacts.values()].filter((d) => d.item.given || !producers.has(d.item.id)).map((d) => d.item.id));
    const ready = (a: string) => available.has(a) || !artifacts.has(a); // an unresolved input: `unresolved` reports it
    const entered = new Set<string>();
    const reached = new Set<string>();
    for (let changed = true; changed; ) {
      changed = false;
      for (const { item: s } of this.steps) {
        if (reached.has(s.id)) continue;
        if (!entered.has(s.id) && !(s.inputs.length > 0 && s.inputs.every(ready))) continue;
        reached.add(s.id);
        changed = true;
        for (const a of s.outputs) available.add(a);
        if (!s.gate) continue;
        const g = this.defs.gate.get(s.gate)?.item;
        if (g) entered.add(g.pass).add(g.fail);
        for (const { item: l } of this.defs.loop.values()) if (l.gate === s.gate) entered.add(l.escalate);
      }
    }
    for (const { item: s, src, path } of this.steps) {
      if (reached.has(s.id)) continue;
      const missing = s.inputs.filter((a) => !ready(a));
      const why = s.inputs.length === 0 ? "it has no inputs" : `its inputs ${missing.join(", ")} are never all available`;
      this.report("unreachable", src, path, `${s.id} is never reached: ${why}, and no gate branch or loop escalation leads to it`);
    }

    // Cycles: each declared loop breaks the edges from its gate's step to its fail step; any
    // cycle left is undeclared. A loop must also close a real cycle.
    const broken = new Set<string>();
    for (const { item: l, src, path } of this.defs.loop.values()) {
      const g = this.defs.gate.get(l.gate)?.item;
      const from = gateStep(l.gate);
      if (!g || !from) continue; // unresolved or gate-step reports it
      broken.add(`${from}\u0000${g.fail}`);
      if (!this.leadsTo(next, g.fail, from)) {
        this.report("loop-open", src, [...path, "gate"], `${l.gate}'s fail branch ${g.fail} never leads back to ${from}, so ${l.id} declares a cycle that does not exist`);
      }
    }
    const reduced = new Map([...next].map(([from, to]) => [from, new Set([...to].filter((t) => !broken.has(`${from}\u0000${t}`)))]));
    for (const component of cycles(reduced)) {
      const members = this.steps.filter((d) => component.has(d.item.id));
      const first = members[0];
      if (!first) continue;
      this.report(
        "cycle",
        first.src,
        first.path,
        `steps ${members.map((d) => d.item.id).join(", ")} form a cycle no declared loop breaks; declare a loop on the gate whose fail branch goes back, or give a rewritten file a new artifact ID`,
      );
    }

    // Endpoints: a step that produces nothing and checks no gate ends a path; that is allowed
    // only for an escalation step, a gate branch (an owner's decision such as intake.no-consent)
    // or an optional step.
    const escalations = new Set([...this.defs.loop.values()].map((d) => d.item.escalate));
    const branches = new Set([...this.defs.gate.values()].flatMap((d) => [d.item.pass, d.item.fail]));
    for (const { item: s, src, path } of this.steps) {
      if (s.outputs.length > 0 || s.gate || s.when || escalations.has(s.id) || branches.has(s.id)) continue;
      this.report(
        "dead-end",
        src,
        path,
        `${s.id} produces nothing and checks no gate; give it its outputs, or make it an endpoint: a loop's escalation step, a gate's branch or an optional step (when)`,
      );
    }
  }

  leadsTo(next: Map<string, Set<string>>, from: string, to: string): boolean {
    const seen = new Set([from]);
    for (const queue = [from]; queue.length > 0; ) {
      const s = queue.pop() as string;
      if (s === to) return true;
      for (const t of next.get(s) ?? []) if (!seen.has(t)) seen.add(t) && queue.push(t);
    }
    return false;
  }
}

/** The strongly connected components that hold a cycle (Tarjan), each as a set of step IDs. */
function cycles(next: Map<string, Set<string>>): Set<string>[] {
  let counter = 0;
  const index = new Map<string, number>();
  const low = new Map<string, number>();
  const stack: string[] = [];
  const onStack = new Set<string>();
  const found: Set<string>[] = [];
  const visit = (v: string) => {
    index.set(v, counter);
    low.set(v, counter++);
    stack.push(v);
    onStack.add(v);
    for (const w of next.get(v) ?? []) {
      if (!index.has(w)) {
        visit(w);
        low.set(v, Math.min(low.get(v) as number, low.get(w) as number));
      } else if (onStack.has(w)) low.set(v, Math.min(low.get(v) as number, index.get(w) as number));
    }
    if (low.get(v) !== index.get(v)) return;
    const component = new Set<string>();
    for (let w = ""; w !== v; ) {
      w = stack.pop() as string;
      onStack.delete(w);
      component.add(w);
    }
    if (component.size > 1 || next.get(v)?.has(v)) found.push(component);
  };
  for (const v of next.keys()) if (!index.has(v)) visit(v);
  return found;
}

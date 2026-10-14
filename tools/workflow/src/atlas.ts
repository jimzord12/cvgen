// `atlas`: the `Atlas` client-journey page generated from the Workflow Model
// (ADR 0015, TASK-41). It writes .atlas/src/pages/client-journey.json in the
// format the existing kit (.atlas/_kit/atlas.py) already builds, from the same
// checked model `render` reads: one phase per stage, one Atlas step per model
// step, in model order. The page is never edited by hand; `atlas --check`
// fails when it differs from what the model generates.
//
// Every Atlas step cites the model step's own source anchors, so the kit's
// staleness check (`atlas.py check`) keeps tracking the files the facts come
// from. Writing a changed page also stamps it (`atlas.py stamp`), because its
// facts come from a model that has just passed `check`.
import { spawnSync } from "node:child_process";
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { checkModel, modelDir, placeholderCap, repoRoot, type Indexed } from "./check";
import { formatIssue } from "./load";
import type { Action, Artifact, Gate, Loop, Step } from "./model";

export const pageId = "client-journey";
export const atlasPagePath = (root: string) => join(root, ".atlas", "src", "pages", `${pageId}.json`);
const sitePath = (root: string) => join(root, ".atlas", "src", "site.json");

/** What the generator reads from .atlas/src/site.json: the actors, by ID. */
type SiteActor = { kind?: string; file?: string };
type Site = { actors?: Record<string, SiteActor> };

type AtlasGate = { type: "owner" | "review" | "check" | "client"; label: string; cap?: string };
type AtlasLoop = { to: string; label: string; short: string; cap: string };
type AtlasBranch = { to: string; when: string; short: string; label: string };
type AtlasCmd = string | { cmd: string; who: "you" };
type AtlasStep = {
  id: string;
  title: string;
  actor: string;
  optional?: true;
  summary?: string;
  you?: string;
  gate?: AtlasGate;
  next?: string[];
  loop?: AtlasLoop;
  branch?: AtlasBranch[];
  does?: string[];
  in?: string[];
  out?: string[];
  cmd?: AtlasCmd[];
  uses?: string[];
  // Set last, so they come last in the JSON.
  note?: string;
  sources?: string[];
};

/** The Atlas actor of a model actor: its ID without the `actor.` prefix. */
const atlasActor = (id: string) => id.replace(/^actor\./, "");
const capText = (l: Loop) => `${l.cap.attended} attended${l.cap.unattended ? `, ${l.cap.unattended} unattended` : ""}${placeholderCap(l) ? " (placeholder, docs/workflow/GAPS.md)" : ""}`;
const shortCap = (l: Loop) => `max ${l.cap.attended}${l.cap.unattended ? ` · ${l.cap.unattended} unattended` : ""}${placeholderCap(l) ? " (placeholder)" : ""}`;
const artifactLine = (a: Artifact | undefined, id: string) => (a ? (a.path ? `${a.name}: \`${a.path}\`` : a.name) : `\`${id}\``);
const unique = <T>(xs: T[]) => [...new Set(xs)];

/** Builds the page object from a model that passed `check`; every model actor must have an Atlas actor in site.json. */
export function clientJourney(ix: Indexed, site: Site): { page?: object; problems: string[] } {
  const problems: string[] = [];
  const siteActors = site.actors ?? {};
  for (const a of ix.model.catalog.data.actors) {
    if (!siteActors[atlasActor(a.id)]) problems.push(`${a.id} has no actor "${atlasActor(a.id)}" in .atlas/src/site.json`);
  }
  if (problems.length > 0) return { problems };

  const stages = ix.model.stages.map((s) => s.data);
  const steps = stages.flatMap((s) => s.steps);
  const index = new Map(steps.map((s, i) => [s.id, i]));
  const at = (id: string) => index.get(id) ?? -1;
  const step = (id: string) => ix.defs.step.get(id)?.item as Step;
  const optional = (id: string) => step(id).when !== undefined;
  const gateOf = (s: Step): Gate | undefined => (s.gate ? ix.defs.gate.get(s.gate)?.item : undefined);
  const action = (s: Step) => ix.defs.action.get(s.action)?.item as Action;
  const folder = new Map(ix.model.stages.map((s) => [s.data.id, s.folder]));
  const stageOf = new Map(stages.flatMap((st) => st.steps.map((s) => [s.id, st.id] as const)));
  const loops = stages.flatMap((s) => s.loops);

  // Where each loop is drawn: on the step that goes back, pointing at the step it goes back to.
  // A gate whose fail branch is earlier goes back itself; otherwise its fail step (the revision)
  // goes back to the nearest step it feeds at or before the gate's step.
  const loopsOn = new Map<string, { loop: Loop; to: string }[]>();
  for (const l of loops) {
    const gate = ix.defs.gate.get(l.gate)?.item as Gate;
    const checker = ix.graph.gateStep(l.gate) as string;
    let host = checker;
    let to = gate.fail;
    if (at(gate.fail) > at(checker)) {
      host = gate.fail;
      const back = [...(ix.graph.next.get(gate.fail) ?? [])].filter((t) => at(t) <= at(checker)).sort((a, b) => at(b) - at(a));
      to = back[0] ?? checker;
    }
    loopsOn.set(host, [...(loopsOn.get(host) ?? []), { loop: l, to }]);
  }

  // The arrows: every step that follows from the data, forward only and never into an optional step
  // (the kit draws an optional step beside the main line), minus gate branches (drawn as branches),
  // and minus an arrow that a longer forward path through steps on the main line already implies.
  const forward = (id: string) => [...(ix.graph.next.get(id) ?? [])].filter((t) => at(t) > at(id) && !optional(t));
  const implied = (from: string, to: string) => {
    const seen = new Set<string>();
    for (const queue = forward(from).filter((t) => t !== to); queue.length > 0; ) {
      const n = queue.pop() as string;
      if (n === to) return true;
      if (seen.has(n)) continue;
      seen.add(n);
      queue.push(...forward(n));
    }
    return false;
  };
  const nextOf = (s: Step) => {
    const g = gateOf(s);
    const branches = new Set(g ? [g.pass, g.fail] : []);
    return forward(s.id)
      .filter((t) => !branches.has(t) && !implied(s.id, t))
      .sort((a, b) => at(a) - at(b));
  };

  const escalations = new Map<string, Loop[]>();
  for (const l of loops) escalations.set(l.escalate, [...(escalations.get(l.escalate) ?? []), l]);

  const usesOf = (s: Step, a: Action) => {
    const files: string[] = [];
    if (a.kind === "skill") files.push(`.claude/skills/${a.skill}/SKILL.md`);
    if (a.kind === "agent") files.push(`.claude/agents/${a.agent}.md`);
    for (const i of s.inputs) {
      const p = ix.defs.artifact.get(i)?.item.path;
      if (p) files.push(p);
    }
    const own = atlasActor(s.actor);
    return Object.entries(siteActors)
      .filter(([id, sa]) => {
        if (id === own) return false;
        if (a.kind === "skill" && id === a.skill) return true;
        if (!sa.file) return false;
        return files.includes(sa.file) || (a.kind === "cmd" && a.run.split(/\s+/).includes(sa.file));
      })
      .map(([id]) => id);
  };

  const atlasStep = (s: Step): AtlasStep => {
    const a = action(s);
    const owner = s.actor === "actor.owner";
    const text = "does" in a ? a.does : a.kind === "cmd" ? `${a.name}, with the command below.` : a.name;
    const g = gateOf(s);
    const gateLoops = g ? loops.filter((l) => l.gate === g.id) : [];
    const kind = ix.defs.actor.get(s.actor)?.item.kind;
    const out: AtlasStep = {
      id: s.id,
      title: s.name,
      actor: atlasActor(s.actor),
      optional: s.when ? true : undefined,
      summary: owner ? undefined : text,
      you: owner ? text : undefined,
    };
    if (g) {
      out.gate = {
        type: owner ? "owner" : s.actor === "actor.client" ? "client" : kind === "agent" ? "review" : "check",
        label: `${g.name}: ${g.check}`,
        cap: gateLoops.length ? gateLoops.map((l) => `${capText(l)}, then \`${l.escalate}\``).join("; ") : undefined,
      };
    }
    if (!s.when) out.next = nextOf(s);
    const hosted = loopsOn.get(s.id) ?? [];
    const [first, ...more] = hosted;
    if (first) {
      const same = hosted.filter((h) => h.to === first.to);
      out.loop = {
        to: first.to,
        label: same.map((h) => h.loop.name).join("; "),
        short: same.length === 1 ? shortCap(first.loop) : `${same.length} loops`,
        cap: same.map((h) => `${h.loop.name}: ${capText(h.loop)}, then \`${h.loop.escalate}\``).join("; "),
      };
    }
    if (g) {
      // The fail branch is drawn by the loop when the gate's own step goes back.
      const failByLoop = hosted.some((h) => h.to === g.fail);
      const branch = (to: string, when: string, short: string): AtlasBranch => ({
        to,
        when,
        short,
        label: stageOf.get(to) === stageOf.get(s.id) ? "Then" : `Then stage ${stageOf.get(to)}`,
      });
      out.branch = [branch(g.pass, "it passes", "pass"), ...(failByLoop ? [] : [branch(g.fail, "it fails", "fail")])];
    }
    const does = [
      ...(s.when ? [`Only when: ${s.when}`] : []),
      ...more.filter((h) => h.to !== first?.to).map((h) => `Also loops back to \`${h.to}\`: ${h.loop.name}, ${capText(h.loop)}.`),
      ...(escalations.has(s.id) ? [`Reached at the cap of: ${(escalations.get(s.id) as Loop[]).map((l) => l.name).join("; ")}.`] : []),
    ];
    if (does.length) out.does = does;
    if (s.inputs.length) out.in = s.inputs.map((i) => artifactLine(ix.defs.artifact.get(i)?.item, i));
    if (s.outputs.length) out.out = s.outputs.map((o) => artifactLine(ix.defs.artifact.get(o)?.item, o));
    if (a.kind === "cmd") out.cmd = [owner ? { cmd: a.run, who: "you" } : a.run];
    const uses = usesOf(s, a);
    if (uses.length) out.uses = uses;
    const stage = stageOf.get(s.id) as string;
    out.note = `Model step \`${s.id}\`, action \`${s.action}\`, in \`docs/workflow/${folder.get(stage)}/stage.yaml\`.`;
    out.sources = unique(s.sources);
    return out;
  };

  const n = (k: keyof Indexed["defs"]) => ix.defs[k].size;
  const page = {
    id: pageId,
    kind: "flow",
    nav: "New client",
    title: "A new client, start to finish",
    question: "I just got a new client. What do I do?",
    summary:
      `From the first message to deletion: ${steps.length} steps in ${stages.length} stages, with ${n("gate")} gates and ${n("loop")} loops. ` +
      "Generated from the `Workflow Model` (`docs/workflow/`) by `bun run atlas` in `tools/workflow`; change the model, never this page.",
    tldr: stages.map((s) => `**${s.name}.** ${s.purpose}`),
    sources: unique(stages.flatMap((s) => s.sources)),
    phases: stages.map((st) => ({ id: st.id, title: st.name, steps: st.steps.map(atlasStep) })),
  };
  return { page, problems };
}

/** The page's text, or the problems that stop it: a model that fails `check`, or an actor site.json lacks. */
export function generate(dir = modelDir, root = repoRoot): { text?: string; problems: string[] } {
  const checked = checkModel(dir, root);
  if (!checked.indexed) {
    return { problems: ["the model must pass `bun run check` before the Atlas page is generated:", ...checked.issues.map(formatIssue)] };
  }
  if (!existsSync(sitePath(root))) return { problems: [`${sitePath(root)} does not exist`] };
  const site = JSON.parse(readFileSync(sitePath(root), "utf8")) as Site;
  const { page, problems } = clientJourney(checked.indexed, site);
  return page ? { text: `${JSON.stringify(page, null, 2)}\n`, problems } : { problems };
}

export type AtlasResult = { problems: string[]; changed: boolean };

/**
 * Generates the page into `file` (by default the real one). With `write`,
 * writes it when it changed; without, only reports whether it would (`--check`).
 */
export function atlas(file: string, { write, dir = modelDir, root = repoRoot }: { write: boolean; dir?: string; root?: string }): AtlasResult {
  const { text, problems } = generate(dir, root);
  if (text === undefined) return { problems, changed: false };
  const before = existsSync(file) ? readFileSync(file, "utf8").replace(/\r\n/g, "\n") : undefined;
  const changed = before !== text;
  if (write && changed) writeFileSync(file, text);
  return { problems, changed };
}

/** `atlas.py stamp client-journey`: records the cited files' hashes in atlas.lock.json, then builds the Atlas. */
export function stamp(root = repoRoot): { ok: boolean; output: string } {
  const python = process.env.PYTHON || "python";
  const p = spawnSync(python, [join(".atlas", "_kit", "atlas.py"), "stamp", pageId], { cwd: root, encoding: "utf8" });
  return { ok: p.status === 0, output: `${p.stdout ?? ""}${p.stderr ?? ""}${p.error ? p.error.message : ""}`.trim() };
}

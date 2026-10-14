// Level 3 of the Workflow Model (docs/proposals/workflow-model.md; the levels are in
// archive/work-records/workflow-model/handoff.md, section 4, item 10): the model checked against a
// real run (TASK-42). It walks the same model the check reads (loadModel, entities in check.ts).
//
// `reality`: a fictional client walks the model in a temporary Envelope under builds/. A step runs
// once every input it reads exists (the level-2 reach rule), in waves, each wave in model order; a
// gate's branch waits for its gate. A `cmd` step runs its real command line (scripts/cv.py,
// scripts/outputs.py, typst, python -c); every other step is a labelled stand-in that writes the
// artifacts the step declares, fictional. Before a step, every input it declares with a path must
// exist; after it, every output it declares must exist at its declared path and validate: JSON
// parses, JSON with a `schema` validates against it, a PDF has its declared Meta File beside it,
// valid and current. The first problem stops the run and names the step.
//
// `envelope`: the same walk, read-only, over a real Envelope: which declared Envelope artifacts
// exist and which are missing, per step. It writes nothing, opens one file (envelope.json, for the
// Alias) and prints model paths and counts, never a file name or a file's content.
import { spawnSync } from "node:child_process";
import { createHash } from "node:crypto";
import { appendFileSync, copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { dirname, isAbsolute, join, relative, resolve } from "node:path";
import Ajv2020 from "ajv/dist/2020";
import { checkModel, entities, loadModel, repoRoot } from "./check";
import { formatIssue } from "./load";
import type { Artifact, Step } from "./model";

type Outcome = "pass" | "fail";
type CmdResult = { status: number | null; stdout: string; stderr: string };

/** One path through the model: what the people decide, which optional steps happen, and what is known up front. */
export type Scenario = {
  name: string;
  /** The Envelope's identity, written by the stand-in for open.envelope-json. */
  envelope: Record<"alias" | "domain" | "candidate" | "rank", string>;
  /** The optional steps (`when`) this run takes; every other optional step is left out. */
  when: string[];
  /** Each gate's outcome, or how to read it from the output of the `cmd` step that checks it. */
  gates: Record<string, Outcome | ((r: CmdResult) => Outcome)>;
  /** Placeholder values known before the run; the rest are bound from what the steps write. */
  bind: Record<string, string>;
  /** Steps the run must reach; stopping short of one is a failure. */
  end: string[];
};

/** The suite's run: everything goes right the first time, so no loop turns. */
export const happyPath: Scenario = {
  name: "a fictional marine engineer: consent given, no Deep Dive, the Text Draft signed off first time, the Flagship fits, every review passes",
  envelope: { alias: "client-2030-01-01", domain: "marine", candidate: "Alex Morgan", rank: "Second Engineer" },
  when: ["design.flagship-fit", "design.entry-point", "deliver.status", "after.stall-check", "after.delete-by-check"],
  gates: {
    "gate.consent": "pass",
    "gate.deep-dives-chosen": "fail", // the owner picks no Deep Dive: on to the follow-up
    "gate.sign-off": "pass",
    "gate.template-exists": "pass",
    "gate.template-fits": "pass",
    "gate.client-design-review": "pass",
    "gate.render-ok": "pass",
    "gate.example-wording": (r) => (r.stdout.trim() === "[]" ? "pass" : "fail"),
    "gate.owner-review": "pass",
  },
  bind: { NN: "01", N: "0", "new-folder": "page-png", timestamp: "fictional", name: "workflow reality run (stand-in for the owner)" },
  end: ["deliver.stamp-delivered", "deliver.report-delete-by", "after.delete-by-check"],
};

// --- Paths: model path patterns with <placeholders> and NN.

const placeholder = /<([^<>]+)>|\bNN\b/g;

/** Fills the bound placeholders; `strict` refuses an unbound one. */
export function substitute(text: string, bind: Record<string, string>, strict = false): string {
  return text.replace(placeholder, (whole, name: string | undefined) => {
    const key = name ?? "NN";
    const value = bind[key];
    if (value !== undefined) return value;
    if (strict) throw new Error(`placeholder ${whole} has no value in this run`);
    return whole;
  });
}

const isDir = (p: string) => existsSync(p) && statSync(p).isDirectory();
const isFile = (p: string) => existsSync(p) && statSync(p).isFile();
const posix = (p: string) => p.replaceAll("\\", "/");

/** Every file (or, for a pattern ending in /, folder) under `base` that a path pattern matches, with the placeholder values it gives. */
export function glob(base: string, pattern: string): { path: string; values: Record<string, string> }[] {
  const folder = pattern.endsWith("/");
  const segments = pattern.replace(/\/+$/, "").split("/");
  let found = [{ path: base, values: {} as Record<string, string> }];
  segments.forEach((segment, i) => {
    const names: string[] = [];
    const source = segment
      .split(/(<[^<>]+>|\bNN\b)/)
      .map((part, k) => {
        if (k % 2 === 0) return part.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
        names.push(part === "NN" ? "NN" : part.slice(1, -1));
        return part === "NN" ? "(\\d{2})" : "(.+?)";
      })
      .join("");
    const next: typeof found = [];
    for (const f of found) {
      if (names.length === 0) {
        if (existsSync(join(f.path, segment))) next.push({ path: join(f.path, segment), values: f.values });
        continue;
      }
      if (!isDir(f.path)) continue;
      const re = new RegExp(`^${source}$`);
      for (const entry of readdirSync(f.path).sort()) {
        const m = re.exec(entry);
        if (m) next.push({ path: join(f.path, entry), values: { ...f.values, ...Object.fromEntries(names.map((n, j) => [n, m[j + 1] as string])) } });
      }
    }
    const last = i === segments.length - 1;
    found = next.filter((f) => (!last || folder ? isDir(f.path) : isFile(f.path)));
  });
  return found;
}

// --- Commands: a `cmd` action's run line, made runnable.

/** Splits a command line into words the way a POSIX shell quotes them ('...' and "..."). */
export function tokenize(line: string): string[] {
  const words: string[] = [];
  let word = "";
  let quote = "";
  let quoted = false;
  for (const ch of line) {
    if (quote) {
      if (ch === quote) quote = "";
      else word += ch;
    } else if (ch === '"' || ch === "'") {
      quote = ch;
      quoted = true;
    } else if (/\s/.test(ch)) {
      if (word || quoted) words.push(word);
      word = "";
      quoted = false;
    } else word += ch;
  }
  if (quote) throw new Error(`unclosed ${quote} in: ${line}`);
  if (word || quoted) words.push(word);
  return words;
}

/**
 * The commands of a run line for this run: optional `[--...]` parts dropped, placeholders filled,
 * paths under private/ and builds/ moved into the run's copy of the repository (`sandbox`, relative
 * to the repository), split on `&&`.
 */
export function prepare(run: string, bind: Record<string, string>, sandbox: string): string[][] {
  const line = substitute(run.replace(/\s+\[--[^\]]*\]/g, ""), bind, true).replace(
    /(^|[\s'"])((?:private|builds)\/)/g,
    (_, before: string, top: string) => `${before}${sandbox}/${top}`,
  );
  const commands: string[][] = [[]];
  for (const word of tokenize(line)) {
    if (word === "&&") commands.push([]);
    else commands[commands.length - 1]?.push(word);
  }
  return commands.filter((c) => c.length > 0);
}

/**
 * What a fictional run changes in a real command, each said in the log: the owner's approval is a
 * stand-in (`--test-only`, which cv.py refuses under private/), and stamp finds the Envelope's home
 * in the run's copy of the repository (`--root`).
 */
export function adjust(argv: string[], sandbox: string): { argv: string[]; notes: string[] } {
  const [program, script, sub] = argv;
  const out = [...argv];
  const notes: string[] = [];
  if (/^python3?$/.test(program ?? "")) out[0] = process.env.PYTHON || "python";
  if (script === "scripts/cv.py" && sub === "approve") {
    out.push("--test-only");
    notes.push("stand-in approval: --test-only (cv.py refuses it under private/)");
  }
  if (script === "scripts/outputs.py" && sub === "stamp") {
    out.push("--root", sandbox);
    notes.push(`stamp reads the Envelope's home from the run's copy: --root ${sandbox}`);
  }
  return { argv: out, notes };
}

// --- Stand-ins: what a person, the lead or an agent would write, fictional and labelled.

const FLAGSHIP_ENTRY = `// Stand-in for design.entry-point (workflow reality run): the Flagship, fictional record.
#import "/packages/domains/marine/lib.typ": flagship
#import "/packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "/packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "/packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#let candidate = json("../candidate.json")
#show: flagship.with(candidate: candidate, theme: theme, artwork: artwork, layout: layout, show-vessel-durations: true,
  copy: (certificates-subtitle: "Certificates of competency and endorsements", brand: "ALEX MORGAN"))
`;
const PORTRAIT = "examples/candidates/fictional-engineer.png";

// --- The run.

type Line = (text: string) => void;
type Report = { step: string; how: string; wave: number; checked: number; noPath: number };

export function reality(opts: { dir: string; out: string; scenario?: Scenario; print?: Line }): number {
  const scenario = opts.scenario ?? happyPath;
  const print = opts.print ?? console.log;
  const out = resolve(opts.out);
  const level12 = checkModel(opts.dir, repoRoot);
  if (level12.issues.length > 0) {
    for (const i of level12.issues) print(formatIssue(i));
    print(`FAILED level 3 not run: the model fails levels 1 and 2 (${level12.issues.length} problem(s))`);
    return 1;
  }
  if (relative(repoRoot, out).startsWith("..") || isAbsolute(relative(repoRoot, out))) {
    print(`FAILED level 3 not run: ${out} is outside the repository; Typst compiles from its root`);
    return 1;
  }
  if (existsSync(out)) {
    print(`FAILED level 3 not run: ${out} exists; every run writes to a new folder`);
    return 1;
  }
  const { model } = loadModel(opts.dir, repoRoot);
  if (!model) return 1;
  const { steps, artifacts, actions, gates } = entities(model);
  const sandbox = join(out, "repo");
  const sandboxRel = posix(relative(repoRoot, sandbox));
  mkdirSync(sandbox, { recursive: true });
  const logFile = join(out, "reality.log");
  const log: Line = (text) => appendFileSync(logFile, `${text}\n`, "utf8");
  log(`Workflow Model level 3: ${scenario.name}`);
  log(`Model: ${posix(relative(repoRoot, resolve(opts.dir))) || "."}; the run's copy of the repository: ${sandboxRel}`);

  const bind: Record<string, string> = { ...scenario.bind, envelope: scenario.envelope.alias };
  const shown = (p: string) => posix(relative(repoRoot, p));
  const where = (a: Artifact) => (a.given ? repoRoot : sandbox); // what the run makes lives in its copy; given files are the repository's own
  const art = (id: string) => artifacts.get(id) as Artifact;
  const ajv = new Ajv2020({ allErrors: true, strict: false });
  const validators = new Map<string, ReturnType<typeof ajv.compile>>();
  const validator = (schemaId: string) => {
    const schema = art(schemaId);
    const file = join(where(schema), schema.path ?? "");
    let v = validators.get(file);
    if (!v) {
      v = ajv.compile(JSON.parse(readFileSync(file, "utf8")));
      validators.set(file, v);
    }
    return v;
  };
  const sha256 = (file: string) => createHash("sha256").update(readFileSync(file)).digest("hex");

  /** Problems with one declared artifact on disk; binds the placeholders its one match fixes. */
  const check = (a: Artifact, full: boolean): string[] => {
    if (!a.path) return [];
    const pattern = substitute(a.path, bind);
    const found = glob(where(a), pattern);
    if (found.length === 0) return [`${a.id}: ${a.path} is not there (looked for ${shown(join(where(a), pattern))})`];
    for (const name of new Set(found.flatMap((f) => Object.keys(f.values)))) {
      const values = new Set(found.map((f) => f.values[name]));
      if (values.size === 1 && bind[name] === undefined) bind[name] = [...values][0] as string;
    }
    if (!full) return [];
    const problems: string[] = [];
    for (const { path: file } of found.filter((f) => isFile(f.path))) {
      const at = `${a.id}: ${shown(file)}`;
      if (file.endsWith(".json")) {
        let data: unknown;
        try {
          data = JSON.parse(readFileSync(file, "utf8"));
        } catch (e) {
          problems.push(`${at} is not valid JSON (${(e as Error).message})`);
          continue;
        }
        if (a.schema) {
          const v = validator(a.schema);
          if (!v(data)) problems.push(`${at} does not match ${a.schema}: ${ajv.errorsText(v.errors)}`);
        }
      }
      if (file.endsWith(".pdf")) {
        const metaArt = [...artifacts.values()].find((m) => m.path === a.path?.replace(/\.pdf$/, ".meta.json"));
        const metaFile = file.replace(/\.pdf$/, ".meta.json");
        if (!metaArt?.schema) problems.push(`${at}: the model declares no Meta File with a schema beside this PDF`);
        else if (!isFile(metaFile)) problems.push(`${at} has no Meta File (${metaArt.id}) beside it`);
        else {
          const meta = JSON.parse(readFileSync(metaFile, "utf8")) as { sha256?: string };
          const v = validator(metaArt.schema);
          if (!v(meta)) problems.push(`${metaArt.id}: ${shown(metaFile)} does not match ${metaArt.schema}: ${ajv.errorsText(v.errors)}`);
          else if (meta.sha256 !== sha256(file)) problems.push(`${metaArt.id}: ${shown(metaFile)} is stale: its sha256 is not the PDF's`);
        }
      }
    }
    return problems;
  };

  /** Writes what a non-`cmd` step declares, fictional. */
  const standIn = (step: Step) => {
    for (const id of step.outputs) {
      const a = art(id);
      if (id === "art.reviewed-hash") {
        // The owner reads the hash off the PDF he reviewed; deliver.approve passes it to cv.py.
        const pdf = glob(sandbox, substitute(art("art.cv-pdf").path ?? "", bind))[0];
        if (pdf) bind["reviewed hash"] = sha256(pdf.path);
      }
      if (!a.path) continue;
      const target = join(sandbox, substitute(a.path, bind, true));
      if (a.path.endsWith("/")) {
        mkdirSync(target, { recursive: true });
        if (id === "art.portrait") copyFileSync(join(repoRoot, PORTRAIT), join(target, "portrait.png"));
        continue;
      }
      mkdirSync(dirname(target), { recursive: true });
      if (id === "art.envelope-json") writeFileSync(target, `${JSON.stringify(scenario.envelope, null, 2)}\n`);
      else if (id === "art.candidate-json") {
        // The example record, written as a client's would be (docs/guides/build-a-cv.md, section 2):
        // its own portrait, its own footer, and none of the example's wording.
        const text = readFileSync(join(repoRoot, "examples/candidates/engineer-example.json"), "utf8")
          .replace("EU citizen / fictional profile", "EU citizen")
          .replace("Illustrative education entry", "Graduated 2014");
        const record = JSON.parse(text);
        record.identity.portrait = "images/portrait/portrait.png";
        delete record.identity["portrait-alt"];
        record.disclosure = "CURRICULUM VITAE - JANUARY 2030";
        writeFileSync(target, `${JSON.stringify(record, null, 2)}\n`);
      } else if (id === "art.cv-typ") writeFileSync(target, FLAGSHIP_ENTRY);
      else if (id === "art.draft-typ") copyFileSync(join(repoRoot, "tests/fixtures/text-draft.typ"), target);
      else if (id === "art.sign-off-png") copyFileSync(join(repoRoot, PORTRAIT), target);
      else appendFileSync(target, `Stand-in for ${step.id} (${a.name}): fictional, written by the workflow reality run.\n`);
    }
  };

  const escalations = new Set([...model.stages.flatMap((s) => s.data.loops)].map((l) => l.escalate));
  const optionalOff = (s: Step) => s.when !== undefined && !scenario.when.includes(s.id);
  const gateStep = (gateId: string) => steps.find((s) => s.gate === gateId);
  const live = (gateId: string) => {
    const s = gateStep(gateId);
    return s !== undefined && !escalations.has(s.id) && !optionalOff(s);
  };
  // A gate's branch waits for the gate, except a loop's way back (a looped gate's fail branch): that
  // step is first reached by what it reads, and the gate only sends the run back to it.
  const looped = new Set(model.stages.flatMap((s) => s.data.loops).map((l) => l.gate));
  const branchOf = (stepId: string) => [...gates.values()].filter((g) => g.pass === stepId || (g.fail === stepId && !looped.has(g.id)));
  const available = new Set([...artifacts.values()].filter((a) => a.given).map((a) => a.id));
  const selected = new Set<string>();
  const done = new Set<string>();
  const held = (s: Step) => !selected.has(s.id) && branchOf(s.id).some((g) => live(g.id));
  const ready = (s: Step) =>
    !done.has(s.id) && !escalations.has(s.id) && !optionalOff(s) && s.inputs.length > 0 && s.inputs.every((a) => available.has(a)) && !held(s);

  const report: Report[] = [];
  const fail = (step: string, reason: string) => {
    log(`FAIL ${step}: ${reason}`);
    print(`FAIL ${step}: ${reason}`);
    print(`FAILED level 3 at ${step}: evidence ${shown(out)}`);
    writeFileSync(join(out, "report.json"), `${JSON.stringify({ scenario: scenario.name, passed: false, failed: { step, reason }, steps: report }, null, 2)}\n`);
    return 1;
  };

  for (let wave = 1; ; wave++) {
    const now = steps.filter(ready);
    if (now.length === 0) break;
    for (const step of now) {
      const action = actions.get(step.action);
      const kind = action?.kind ?? "?";
      const missing = step.inputs.flatMap((id) => check(art(id), false));
      if (missing.length > 0) return fail(step.id, `an input is missing before it runs: ${missing.join("; ")}`);
      let result: CmdResult | undefined;
      let how: string;
      log(`\n[wave ${wave}] ${step.id} (${step.action}, ${step.actor})`);
      if (action?.kind === "cmd") {
        how = step.actor === "actor.owner" ? "cmd (stand-in approver)" : "cmd";
        let commands: string[][];
        try {
          commands = prepare(action.run, bind, sandboxRel);
        } catch (e) {
          return fail(step.id, (e as Error).message);
        }
        for (const id of step.outputs) {
          const p = art(id).path;
          if (p?.startsWith("builds/") && !p.endsWith("/")) {
            mkdirSync(dirname(join(sandbox, substitute(p, bind, true))), { recursive: true });
            log(`  made the folder ${p.replace(/\/[^/]*$/, "/")} the command writes into (the lead's part)`);
          }
        }
        for (const command of commands) {
          const { argv, notes } = adjust(command, sandboxRel);
          for (const note of notes) log(`  adjusted: ${note}`);
          log(`  $ ${argv.map((w) => (/[\s"']/.test(w) ? JSON.stringify(w) : w)).join(" ")}`);
          const p = spawnSync(argv[0] as string, argv.slice(1), {
            cwd: repoRoot,
            encoding: "utf8",
            env: { ...process.env, PYTHONIOENCODING: "utf-8" },
          });
          result = { status: p.status, stdout: p.stdout ?? "", stderr: p.stderr ?? "" };
          log(`${result.stdout}${result.stderr}  [exit ${p.error ? p.error.message : p.status}]`);
          if (p.status !== 0) {
            const last = (result.stderr.trim() || result.stdout.trim() || p.error?.message || "").split("\n").pop();
            return fail(step.id, `${command.slice(0, 3).join(" ")} exited ${p.status ?? "without starting"}: ${last}`);
          }
        }
      } else {
        how = `stand-in (${kind})`;
        try {
          standIn(step);
        } catch (e) {
          return fail(step.id, `the stand-in could not write its outputs: ${(e as Error).message}`);
        }
      }
      const problems = step.outputs.flatMap((id) => check(art(id), true));
      if (problems.length > 0) return fail(step.id, problems.join("; "));
      done.add(step.id);
      for (const id of step.outputs) available.add(id);
      const withPath = step.outputs.filter((id) => art(id).path).length;
      report.push({ step: step.id, how, wave, checked: withPath, noPath: step.outputs.length - withPath });
      if (step.gate) {
        const rule = scenario.gates[step.gate];
        if (rule === undefined) return fail(step.id, `the scenario gives no outcome for ${step.gate}`);
        if (typeof rule === "function" && !result) return fail(step.id, `${step.gate} is read from a command, but ${step.id} runs none`);
        const outcome = typeof rule === "function" ? rule(result as CmdResult) : rule;
        const g = gates.get(step.gate);
        const target = outcome === "pass" ? g?.pass : g?.fail;
        if (!target) return fail(step.id, `${step.gate} names no ${outcome} step`);
        selected.add(target);
        const next = steps.find((s) => s.id === target);
        if (next && optionalOff(next)) {
          const said = result ? ` (the command printed ${result.stdout.trim() || "nothing"})` : "";
          return fail(step.id, `${step.gate} gave ${outcome}${said}, which leads to ${target}, off this run's path`);
        }
        log(`  ${step.gate}: ${outcome} -> ${target}`);
      }
      const line = `OK   ${step.id.padEnd(30)} ${how.padEnd(24)} ${withPath} output(s) checked on disk${step.outputs.length > withPath ? `, ${step.outputs.length - withPath} with no path` : ""}`;
      log(line);
      print(line);
    }
  }

  const why = (s: Step) =>
    escalations.has(s.id)
      ? "escalation at a loop's cap"
      : optionalOff(s)
        ? "optional, not in this run"
        : held(s)
          ? "a gate's branch not taken"
          : `its inputs were never all written (${s.inputs.filter((a) => !available.has(a)).join(", ")})`;
  const skipped = steps.filter((s) => !done.has(s.id)).map((s) => ({ step: s.id, why: why(s) }));
  for (const s of skipped) log(`not taken: ${s.step}: ${s.why}`);
  const short = scenario.end.filter((id) => !done.has(id));
  if (short.length > 0) {
    const s = steps.find((x) => x.id === short[0]);
    return fail(short[0] as string, `the run stopped before it: ${s ? why(s) : "no such step in the model"}`);
  }
  const counts = (list: string[]) => [...new Set(list)].map((k) => `${list.filter((x) => x === k).length} ${k}`).join(", ");
  const cmds = report.filter((r) => r.how.startsWith("cmd")).length;
  writeFileSync(join(out, "report.json"), `${JSON.stringify({ scenario: scenario.name, passed: true, steps: report, notTaken: skipped }, null, 2)}\n`);
  print(
    `OK level 3: ${report.length} steps taken: ${cmds} commands run, ${report.length - cmds} stand-ins (${counts(report.filter((r) => !r.how.startsWith("cmd")).map((r) => r.how.slice(10, -1)))}); ` +
      `${skipped.length} not taken (${counts(skipped.map((s) => s.why.replace(/ \(.*$/, "")))}); evidence ${shown(out)}`,
  );
  print("level 3 passes");
  return 0;
}

// --- Read-only: a real Envelope against the model.

export function envelopeWalk(opts: { dir: string; envelope: string; print?: Line }): number {
  const print = opts.print ?? console.log;
  const env = resolve(opts.envelope);
  if (!isDir(env)) {
    print("FAILED: the Envelope folder does not exist");
    return 2;
  }
  const { model, issues } = loadModel(opts.dir, repoRoot);
  if (!model) {
    for (const i of issues) print(formatIssue(i));
    return 1;
  }
  const { artifacts } = entities(model);
  let alias = "<envelope>";
  try {
    const found = (JSON.parse(readFileSync(join(env, "envelope.json"), "utf8")) as { alias?: unknown }).alias;
    if (typeof found === "string" && /^client-\d{4}-\d{2}-\d{2}(-\d+)?$/.test(found)) alias = found;
  } catch {
    // no envelope.json, or not JSON: the Alias stays unknown
  }
  const prefix = "private/<envelope>/";
  const present = new Map<string, number>();
  const count = (a: Artifact) => {
    if (!present.has(a.id)) present.set(a.id, glob(env, (a.path as string).slice(prefix.length) || "./").length);
    return present.get(a.id) as number;
  };
  print(`Envelope ${alias}, read-only: nothing is written; only envelope.json is opened, for the Alias`);
  const tally = { complete: 0, partial: 0, none: 0 };
  for (const { data: stage } of model.stages) {
    const rows: string[] = [];
    for (const step of stage.steps) {
      const declared = step.outputs.map((id) => artifacts.get(id) as Artifact).filter((a) => a.path?.startsWith(prefix));
      if (declared.length === 0) continue;
      const missing = declared.filter((a) => count(a) === 0);
      const here = declared.length - missing.length;
      tally[here === declared.length ? "complete" : here === 0 ? "none" : "partial"]++;
      const list = missing.map((a) => `${a.id} (${a.path})`).join(", ");
      rows.push(`  ${step.id.padEnd(30)} ${here}/${declared.length}${list ? `  missing ${list}` : ""}`);
    }
    if (rows.length > 0) print(`${stage.id}\n${rows.join("\n")}`);
  }
  const ids = [...present.keys()];
  const found = ids.filter((id) => (present.get(id) as number) > 0).length;
  const byPath = new Map<string, string[]>();
  for (const id of ids) {
    const p = artifacts.get(id)?.path as string;
    byPath.set(p, [...(byPath.get(p) ?? []), id]);
  }
  const shared = [...byPath].filter(([, list]) => list.length > 1).map(([p, list]) => `${p} (${list.join(", ")})`);
  if (shared.length > 0) print(`NOTE one file, several artifacts: ${shared.join("; ")}: a file that exists counts for each, its content is not read`);
  print(
    `SUMMARY ${alias}: ${tally.complete + tally.partial + tally.none} steps declare Envelope artifacts: ${tally.complete} complete, ${tally.partial} partial, ${tally.none} none; ` +
      `${ids.length} declared Envelope artifacts: ${found} present, ${ids.length - found} missing`,
  );
  return 0;
}

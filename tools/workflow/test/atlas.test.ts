// `atlas` on real files: the Atlas client-journey page generated from the real
// model in docs/workflow, checked against the committed page, against the
// model itself, and through the kit's own validation (.atlas/_kit/atlas.py).
import { afterEach, beforeEach, describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import { appendFileSync, copyFileSync, cpSync, existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, statSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { atlasPagePath, clientJourney, generate, stamp, staleSources, update } from "../src/atlas";
import { checkModel, modelDir, repoRoot } from "../src/check";
import { removeTmp } from "./tmp";

const tool = join(import.meta.dirname, "..");
const run = (...args: string[]) => {
  const p = spawnSync(process.execPath, ["src/cli.ts", ...args], { cwd: tool, encoding: "utf8" });
  return { code: p.status, out: p.stdout, err: p.stderr };
};

type Step = {
  id: string;
  actor: string;
  you?: string;
  optional?: boolean;
  next?: string[];
  gate?: { type: string; label: string; cap?: string };
  loop?: { to: string; label: string };
  branch?: { to: string; when: string }[];
  uses?: string[];
  cmd?: (string | { cmd: string; who: string })[];
  sources: string[];
};
type Page = { id: string; kind: string; tldr: string[]; phases: { id: string; title: string; steps: Step[] }[] };

const page = (): Page => JSON.parse(generate().text as string);
const steps = (p: Page) => p.phases.flatMap((ph) => ph.steps);
const byId = (p: Page, id: string) => steps(p).find((s) => s.id === id) as Step;

describe("the committed page", () => {
  test("is what the model generates: --check exits 0", () => {
    const r = run("atlas", "--check");
    expect(r).toMatchObject({ code: 0, err: "" });
    expect(r.out).toContain("OK .atlas/src/pages/client-journey.json matches the model");
  });

  test("passes the kit's own validation (atlas.py), links from the other pages included", () => {
    const script = [
      "import sys; sys.path.insert(0, '.atlas/_kit'); import atlas",
      "at, site, pages = atlas.load_atlas('.')",
      "errs, _ = atlas.validate('.', site, pages)",
      "print('\\n'.join(errs)); sys.exit(1 if errs else 0)",
    ].join("\n");
    const p = spawnSync(process.env.PYTHON || "python", ["-c", script], { cwd: repoRoot, encoding: "utf8" });
    expect({ code: p.status, out: p.stdout.trim(), err: p.stderr.trim() }).toEqual({ code: 0, out: "", err: "" });
  });
});

describe("a copy of the page edited by hand", () => {
  let dir = "";
  let file = "";
  beforeEach(() => {
    dir = mkdtempSync(join(tmpdir(), "workflow-atlas-"));
    file = join(dir, "client-journey.json");
    copyFileSync(atlasPagePath(repoRoot), file);
  });
  afterEach(() => removeTmp(dir));

  test("fails --check with exit 1 and names the file; a run rewrites it to the committed bytes", () => {
    const text = readFileSync(file, "utf8");
    writeFileSync(file, text.replace('"title": "Check consent (hard stop)"', '"title": "Check consent"'));
    const stale = run("atlas", "--check", file);
    expect(stale.code).toBe(1);
    expect(stale.err).toContain("STALE");
    expect(stale.err).toContain("client-journey.json");

    const fixed = run("atlas", file);
    expect(fixed.code).toBe(0);
    expect(fixed.out).toContain("wrote");
    expect(fixed.out).not.toContain("stamped"); // only the real page is stamped
    expect(readFileSync(file, "utf8")).toBe(readFileSync(atlasPagePath(repoRoot), "utf8"));
    expect(run("atlas", "--check", file).code).toBe(0);
  });
});

describe("the page follows the model", () => {
  const ix = checkModel(modelDir, repoRoot).indexed;
  if (!ix) throw new Error("the real model must pass check");
  const p = page();

  test("one phase per stage and one step per model step, in model order, each citing the model step's anchors", () => {
    expect(p).toMatchObject({ id: "client-journey", kind: "flow" });
    expect(p.phases.map((ph) => ph.id)).toEqual(ix.model.stages.map((s) => s.data.id));
    const modelSteps = ix.model.stages.flatMap((s) => s.data.steps);
    expect(steps(p).map((s) => s.id)).toEqual(modelSteps.map((s) => s.id));
    for (const s of modelSteps) {
      const a = byId(p, s.id);
      expect({ id: s.id, actor: a.actor, sources: a.sources, optional: a.optional ?? false }).toEqual({
        id: s.id,
        actor: s.actor.replace("actor.", ""),
        sources: [...new Set(s.sources)],
        optional: s.when !== undefined,
      });
    }
    expect(p.tldr).toHaveLength(ix.model.stages.length);
  });

  test("a gate's step carries its check and both branches; an owner's step says what he does", () => {
    const consent = byId(p, "intake.consent");
    expect(consent.gate).toMatchObject({ type: "check", label: 'Consent: The client\'s "I agree" is in intake/messages.md.' });
    expect(consent.branch?.map((b) => [b.when, b.to])).toEqual([
      ["it passes", "research.facts"],
      ["it fails", "intake.no-consent"],
    ]);
    expect(byId(p, "intake.relay-send").you).toContain("Viber, WhatsApp, email");
    expect(byId(p, "deliver.approve").cmd).toEqual([
      { cmd: 'python scripts/cv.py approve private/<envelope> <revision> --approver "<name>" --sha256 <reviewed hash>', who: "you" },
    ]);
    expect(byId(p, "deliver.render").uses).toEqual(["cv-py"]);
  });

  test("a loop is drawn on the step that goes back, with its cap and escalation", () => {
    // gate.deep-dive-review fails to research.dive-revise, whose revised text goes back to research.dive-save.
    expect(byId(p, "research.dive-revise").loop).toMatchObject({ to: "research.dive-save", label: "Deep Dive review rounds" });
    expect(byId(p, "research.dive-review").gate?.cap).toBe("5 attended, 10 unattended, then `research.cap-reached`");
    // gate.research-enough fails back to an earlier step: the gate's own step goes back, with no separate fail branch.
    const update = byId(p, "research.decisions-update");
    expect(update.loop?.to).toBe("research.pick-deep-dives");
    expect(update.branch?.map((b) => b.when)).toEqual(["it passes"]);
  });

  test("arrows come from the data, forward only: an escalation step and a dead end lead nowhere", () => {
    expect(byId(p, "research.cap-reached").next).toEqual([]);
    expect(byId(p, "intake.no-consent").next).toEqual([]);
    expect(byId(p, "open.arrives").next).toEqual(["open.envelope"]);
  });

  test("an actor site.json does not list stops the page", () => {
    const { page: none, problems } = clientJourney(ix, { actors: {} });
    expect(none).toBeUndefined();
    expect(problems).toContain('actor.owner has no actor "owner" in .atlas/src/site.json');
  });
});

// A temporary repository holding just what the model and the client-journey page need: docs/workflow,
// every file the model cites or names, the scripts its `cmd` actions run (with packages/cv-workflow for
// their --help), and the Atlas with this one page, stamped against the copies.
function scratchRepo(tmp: string) {
  const ix = checkModel(modelDir, repoRoot).indexed;
  if (!ix) throw new Error("the real model must pass check");
  const take = (path: string) => {
    const from = join(repoRoot, path);
    if (!existsSync(from)) return;
    const to = join(tmp, path);
    if (statSync(from).isDirectory()) mkdirSync(to, { recursive: true });
    else {
      mkdirSync(dirname(to), { recursive: true });
      copyFileSync(from, to);
    }
  };
  const anchor = (s: string) => s.replace(/:\d+(-\d+)?$/, "");
  const defs = [...ix.defs.actor.values(), ...ix.defs.action.values(), ...ix.defs.artifact.values(), ...ix.defs.gate.values(), ...ix.defs.loop.values(), ...ix.defs.step.values()];
  for (const d of defs) for (const s of d.item.sources) take(anchor(s));
  for (const s of ix.model.stages) for (const src of s.data.sources) take(anchor(src));
  for (const { item } of ix.defs.artifact.values()) if (item.path && !item.path.includes("<")) take(item.path);
  for (const { item } of ix.defs.action.values()) {
    if (item.kind === "skill") take(`.claude/skills/${item.skill}/SKILL.md`);
    if (item.kind === "agent") take(`.claude/agents/${item.agent}.md`);
  }
  for (const path of ["docs/workflow", "scripts", "packages/cv-workflow", ".atlas/_kit", ".atlas/src/pages"]) {
    cpSync(join(repoRoot, path), join(tmp, path), { recursive: true, filter: (p) => !p.includes("__pycache__") });
  }
  for (const file of [".atlas/README.md", ".atlas/atlas.lock.json", "AGENTS.md", "docs/glossary.md"]) take(file);
  for (const page of ["design-run", "change-review", "system-map", "roster"]) rmSync(join(tmp, ".atlas", "src", "pages", `${page}.json`));
  const site = JSON.parse(readFileSync(join(repoRoot, ".atlas", "src", "site.json"), "utf8"));
  writeFileSync(join(tmp, ".atlas", "src", "site.json"), JSON.stringify({ ...site, pages: ["client-journey"], moves: [] }, null, 2));
  const stamped = stamp(tmp);
  if (!stamped.ok) throw new Error(`stamping the scratch Atlas failed: ${stamped.output}`);
  expect(staleSources(tmp)).toEqual({ stale: [] });
}

describe("bun run atlas on a scratch copy of the repository: when it stamps", () => {
  let tmp: string | undefined;
  const after = () => join(tmp as string, "docs", "workflow", "07-after", "stage.yaml");
  const rename = () => writeFileSync(after(), readFileSync(after(), "utf8").replace("name: Close the client's task\n", "name: Close the client's task record\n"));
  const setUp = () => {
    tmp = mkdtempSync(join(tmpdir(), "workflow-atlas-repo-"));
    scratchRepo(tmp);
    return tmp;
  };
  afterEach(() => {
    // Only ever the temporary folder: never the working directory.
    if (tmp) removeTmp(tmp);
    tmp = undefined;
  });

  test("a model change with every cited file unchanged writes the page and stamps it, a newly cited file included", () => {
    const root = setUp();
    rename();
    writeFileSync(after(), readFileSync(after(), "utf8").replace(/(id: after\.close\n\s+name: [^\n]+\n\s+sources: \[)/, '$1".atlas/README.md", '));
    const r = update({ dir: join(root, "docs", "workflow"), root });
    expect({ problems: r.problems, changed: r.changed, stamped: r.stamped, stale: r.stale }).toEqual({ problems: [], changed: true, stamped: true, stale: [] });
    expect(readFileSync(atlasPagePath(root), "utf8")).toContain('".atlas/README.md"');
    expect(staleSources(root)).toEqual({ stale: [] });
    expect(readFileSync(join(root, ".atlas", "atlas.data.js"), "utf8")).toContain("Close the client's task record");
  }, 120_000);

  test("a model change while a cited file is already stale writes and builds the page but leaves it stale", () => {
    const root = setUp();
    appendFileSync(join(root, "docs", "guides", "client-workflow.md"), "\nA line added after the last stamp.\n");
    rename();
    const r = update({ dir: join(root, "docs", "workflow"), root });
    expect({ problems: r.problems, changed: r.changed, stamped: r.stamped, stale: r.stale }).toEqual({
      problems: [],
      changed: true,
      stamped: false,
      stale: ["docs/guides/client-workflow.md"],
    });
    expect(readFileSync(atlasPagePath(root), "utf8")).toContain("Close the client's task record");
    expect(readFileSync(join(root, ".atlas", "atlas.data.js"), "utf8")).toContain("Close the client's task record");
    expect(staleSources(root)).toEqual({ stale: ["docs/guides/client-workflow.md"] });
  }, 120_000);
});

// `atlas` on real files: the Atlas client-journey page generated from the real
// model in docs/workflow, checked against the committed page, against the
// model itself, and through the kit's own validation (.atlas/_kit/atlas.py).
import { afterEach, beforeEach, describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import { copyFileSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { atlasPagePath, clientJourney, generate } from "../src/atlas";
import { checkModel, modelDir, repoRoot } from "../src/check";

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
  afterEach(() => rmSync(dir, { recursive: true, force: true }));

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

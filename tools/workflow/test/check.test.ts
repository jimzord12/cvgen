// The model-wide check on real files: every rule against its broken fixture
// (test/fixtures/<rule>/, which must make exactly that rule fire, at the named
// place), a valid fixture that passes, and the real model in docs/workflow.
import { describe, expect, test } from "bun:test";
import { existsSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { checkModel, rules, type Rule } from "../src/check";

const fixtures = join(import.meta.dirname, "fixtures");

/** Where each broken fixture's first problem is reported: file (under the fixture) and path. */
const where: Record<Rule, [string, string]> = {
  shape: ["01-make/stage.yaml", "steps[0].actors"],
  "stage-folder": ["01-build/stage.yaml", "id"],
  "duplicate-id": ["01-make/stage.yaml", "artifacts[0].id"],
  "step-prefix": ["01-make/stage.yaml", "steps[0].id"],
  unresolved: ["01-make/stage.yaml", "steps[0].inputs[1]"],
  scope: ["02-use/stage.yaml", "steps[0].inputs[0]"],
  unused: ["catalog.yaml", "actors[1].id"],
  "gate-step": ["01-make/stage.yaml", "gates[0]"],
  "gate-branches": ["01-make/stage.yaml", "gates[0].fail"],
  source: ["01-make/stage.yaml", "steps[0].sources[0]"],
  "given-path": ["catalog.yaml", "artifacts[0].path"],
  skill: ["01-make/stage.yaml", "actions[0].skill"],
  agent: ["01-make/stage.yaml", "actions[0].agent"],
  command: ["01-make/stage.yaml", "actions[0].run"],
  "given-produced": ["01-make/stage.yaml", "steps[0].outputs[1]"],
  unproduced: ["01-make/stage.yaml", "steps[0].inputs[1]"],
  unreachable: ["01-make/stage.yaml", "steps[1]"],
  cycle: ["01-make/stage.yaml", "steps[1]"],
  "loop-open": ["01-make/stage.yaml", "loops[0].gate"],
  "dead-end": ["01-make/stage.yaml", "steps[1]"],
};

/** Further broken fixtures for one rule, each with what its message must say. */
const variants: Record<string, [Rule, string]> = {
  "command-no-list": ["command", "scripts/proposals.py --help lists no subcommands ({a,b}), so summary cannot be checked"],
  "command-outside-scripts": ["command", "tests/run.py is not under scripts/; the check runs --help only for the repository's own scripts"],
  "command-traversal": ["command", "scripts/../tests/run.py is not under scripts/; the check runs --help only for the repository's own scripts"],
};

describe("every rule has a broken fixture that fires exactly that rule", () => {
  test("one fixture folder per rule, plus the named variants, and no other", () => {
    const folders = readdirSync(fixtures).filter((f) => f !== "valid").sort();
    expect(folders).toEqual([...Object.keys(rules), ...Object.keys(variants)].sort());
  });

  for (const [folder, [rule, message]] of Object.entries(variants)) {
    test(`${rule}: ${folder}`, () => {
      const { issues } = checkModel(join(fixtures, folder));
      expect(issues.map((i) => [i.rule, i.message])).toEqual([[rule, message]]);
    });
  }

  for (const rule of Object.keys(rules) as Rule[]) {
    test(rule, () => {
      const { issues } = checkModel(join(fixtures, rule));
      expect(issues.length).toBeGreaterThan(0);
      expect([...new Set(issues.map((i) => i.rule))]).toEqual([rule]);
      const [file, path] = where[rule];
      expect(issues[0]).toMatchObject({ file: `tools/workflow/test/fixtures/${rule}/${file}`, path, line: expect.any(Number) });
    });
  }

  test("the messages name what is wrong", () => {
    const message = (rule: Rule) => checkModel(join(fixtures, rule)).issues.map((i) => i.message).join("\n");
    expect(message("command")).toContain("scripts/cv.py has no subcommand frobnicate; its --help lists render, approve, export, status");
    expect(message("command")).toContain("scripts/no-such.py does not exist");
    expect(message("source")).toContain("lines 1-99999 run past the end of AGENTS.md");
    expect(message("source")).toContain("no/such/file.md does not exist");
    expect(message("cycle")).toContain("steps make.two, make.three form a cycle");
    expect(message("unreachable")).toContain("make.two is never reached: it has no inputs");
    expect(message("scope")).toContain("art.out is defined in stage make but used in stage use");
  });
});

describe("models that pass", () => {
  test("the valid fixture: a loop, its escalation step and endpoints; its placeholder cap is a note", () => {
    const { issues, notes, summary } = checkModel(join(fixtures, "valid"));
    expect(issues).toEqual([]);
    expect(summary).toBe("1 stages, 6 steps, 5 artifacts, 1 gates, 1 loops");
    expect(notes).toEqual([expect.stringContaining("1 placeholder loop cap(s)")]);
    expect(notes[0]).toContain("loop.review (2 attended)");
  });

  test("the real model in docs/workflow passes levels 1 and 2", () => {
    expect(existsSync(join(fixtures, "..", "..", "..", "..", "docs", "workflow", "catalog.yaml"))).toBe(true);
    const { issues, notes } = checkModel();
    expect(issues).toEqual([]);
    // P-0018 decided every placeholder cap, so the real model has none left.
    expect(notes).toEqual([]);
  });
});

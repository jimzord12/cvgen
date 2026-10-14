// The workflow tool as a person runs it: real process, real files, exit codes.
import { describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import { mkdtempSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { schemaText, staleSchemas } from "../src/schema";
import { removeTmp } from "./tmp";

const root = join(import.meta.dirname, "..");
const run = (...args: string[]) => {
  const p = spawnSync(process.execPath, ["src/cli.ts", ...args], { cwd: root, encoding: "utf8" });
  return { code: p.status, out: p.stdout, err: p.stderr };
};

describe("check", () => {
  test("the sample passes with exit 0", () => {
    const r = run("check", "sample/stage.yaml");
    expect(r).toMatchObject({ code: 0, err: "" });
    expect(r.out).toContain("OK sample/stage.yaml (stage)");
  });

  test("a broken file fails with exit 1, file, line, path and reason", () => {
    const dir = mkdtempSync(join(tmpdir(), "workflow-cli-"));
    try {
      const file = join(dir, "stage.yaml");
      const sample = readFileSync(join(root, "sample", "stage.yaml"), "utf8").replace(/\r\n/g, "\n");
      writeFileSync(file, sample.replace("    actor: actor.client\n", "    actor: actor.client\n    actors: [actor.owner]\n"));
      const line = sample.split("\n").findIndex((l) => l.includes("actor: actor.client")) + 2;
      const r = run("check", file);
      expect(r.code).toBe(1);
      expect(r.err).toContain(`${file}:${line}: steps[2].actors: unknown key`);
      expect(r.err).toContain("FAILED");
    } finally {
      removeTmp(dir);
    }
  });

  test("a missing file fails; an unknown command or a bare anchors is a usage error", () => {
    expect(run("check", "no-such.yaml").code).toBe(1);
    expect(run("anchors").code).toBe(2);
    expect(run("frobnicate").code).toBe(2);
  });
});

describe("anchors through its package script", () => {
  test("bun run anchors with a ref that is not a commit exits 2", () => {
    const p = spawnSync(process.execPath, ["run", "anchors", "no-such-ref"], { cwd: root, encoding: "utf8" });
    expect(p.status).toBe(2);
    expect(p.stdout).toContain("no-such-ref is not a commit");
  });
});

describe("check over a whole model", () => {
  test("with no argument it checks docs/workflow: exit 0, the summary and the placeholder caps", () => {
    const r = run("check");
    expect(r).toMatchObject({ code: 0, err: "" });
    expect(r.out).toMatch(/^OK model docs\/workflow: 7 stages, \d+ steps, .*; levels 1 and 2 pass$/m);
    expect(r.out).toContain("placeholder loop cap(s)");
  });

  test("a folder argument checks that model: a broken one exits 1 with file, line, path, reason and rule", () => {
    const r = run("check", "test/fixtures/cycle");
    expect(r.code).toBe(1);
    expect(r.err).toContain("tools/workflow/test/fixtures/cycle/01-make/stage.yaml:17: steps[1]: steps make.two, make.three form a cycle");
    expect(r.err).toContain("[cycle]");
    expect(r.err).toContain("FAILED model tools/workflow/test/fixtures/cycle: 1 problem(s)");
  });
});

describe("schema", () => {
  test("the committed JSON Schema files match the types", () => {
    // Fails when model.ts changed without `bun run schema`.
    expect(staleSchemas()).toEqual([]);
    expect(run("schema", "--check").code).toBe(0);
  });

  test("the schema is strict: unknown keys are refused at every level", () => {
    const stage = JSON.parse(schemaText("stage.schema.json"));
    expect(stage.additionalProperties).toBe(false);
    expect(stage.properties.steps.items.additionalProperties).toBe(false);
  });

  test("the schema carries the readable ID messages VS Code shows", () => {
    const stage = JSON.parse(schemaText("stage.schema.json"));
    expect(stage.properties.id.patternErrorMessage).toContain("may not be one of the ID prefixes");
    expect(stage.properties.steps.items.properties.id.patternErrorMessage).toContain('must be "<stage>.<name>"');
  });
});

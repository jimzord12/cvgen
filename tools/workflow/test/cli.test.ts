// The workflow tool as a person runs it: real process, real files, exit codes.
import { describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { schemaText, staleSchemas } from "../src/schema";

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
      rmSync(dir, { recursive: true, force: true });
    }
  });

  test("a missing file fails, a missing argument is a usage error", () => {
    expect(run("check", "no-such.yaml").code).toBe(1);
    expect(run("check").code).toBe(2);
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
});

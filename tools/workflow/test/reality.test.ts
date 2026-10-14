// Level 3's parts that need no Typst or Python: run lines made runnable, path patterns matched, and the
// read-only Envelope walk through the real CLI. The fictional run itself is the suite's workflow-model-reality
// cases (tests/workflow.py, run_reality), which drive the real scripts.
import { describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import { mkdirSync, mkdtempSync, readdirSync, statSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { glob, prepare, substitute, tokenize } from "../src/reality";
import { removeTmp } from "./tmp";

const root = join(import.meta.dirname, "..");

describe("run lines", () => {
  test("words split as a shell quotes them; && separates commands", () => {
    expect(tokenize(`python -c "print('a b')" x && echo 'c d' ""`)).toEqual(["python", "-c", "print('a b')", "x", "&&", "echo", "c d", ""]);
    expect(() => tokenize(`echo "open`)).toThrow("unclosed");
  });

  test("placeholders filled, optional parts dropped, private/ and builds/ moved into the run's copy", () => {
    const bind = { envelope: "client-2030-01-01", revision: "r1", N: "0", "new-folder": "png" };
    const run = `python scripts/cv.py render private/<envelope> [--pages <N>] [--input <key>=<value> ...]`;
    expect(prepare(run, bind, "builds/x/repo")).toEqual([["python", "scripts/cv.py", "render", "builds/x/repo/private/client-2030-01-01"]]);
    const png = `python -c "doc = open('private/<envelope>/revisions/<revision>/cv.pdf'); doc[<N>].save('builds/<new-folder>/p.png')"`;
    expect(prepare(png, bind, "b")[0]?.[2]).toBe("doc = open('b/private/client-2030-01-01/revisions/r1/cv.pdf'); doc[0].save('b/builds/png/p.png')");
    expect(() => prepare("python scripts/cv.py export private/<envelope> <revision>", { envelope: "e" }, "b")).toThrow("<revision> has no value");
    expect(substitute("draft-NN.pdf and <topic>", { NN: "01" })).toBe("draft-01.pdf and <topic>");
  });
});

describe("path patterns", () => {
  test("a placeholder matches any name and gives its value; NN matches two digits; a folder pattern ends in /", () => {
    const dir = mkdtempSync(join(tmpdir(), "workflow-glob-"));
    try {
      mkdirSync(join(dir, "revisions", "r1"), { recursive: true });
      mkdirSync(join(dir, "draft"));
      writeFileSync(join(dir, "revisions", "r1", "cv.pdf"), "");
      writeFileSync(join(dir, "draft", "draft-01.pdf"), "");
      writeFileSync(join(dir, "draft", "draft-1.pdf"), "");
      expect(glob(dir, "revisions/<revision>/cv.pdf").map((f) => f.values)).toEqual([{ revision: "r1" }]);
      expect(glob(dir, "revisions/<revision>/render.json")).toEqual([]);
      expect(glob(dir, "draft/draft-NN.pdf").map((f) => f.values)).toEqual([{ NN: "01" }]);
      expect(glob(dir, "revisions/<revision>/").length).toBe(1);
      expect(glob(dir, "revisions/<revision>/cv.pdf/")).toEqual([]);
    } finally {
      removeTmp(dir);
    }
  });
});

describe("envelope (read-only)", () => {
  test("reports present and missing artifacts by model path and Alias, writes nothing, never names a file", () => {
    const dir = mkdtempSync(join(tmpdir(), "workflow-envelope-"));
    const env = join(dir, "someone-real-name");
    try {
      mkdirSync(join(env, "intake", "documents"), { recursive: true });
      mkdirSync(join(env, "revisions", "20300101-000000-abcdef"), { recursive: true });
      writeFileSync(join(env, "envelope.json"), JSON.stringify({ alias: "client-2030-01-02", candidate: "Secret Person" }));
      writeFileSync(join(env, "README.md"), "# client-2030-01-02\n");
      writeFileSync(join(env, "intake", "messages.md"), "private words");
      writeFileSync(join(env, "revisions", "20300101-000000-abcdef", "cv.pdf"), "");
      const before = readdirSync(env, { recursive: true }).map((f) => `${f}:${statSync(join(env, String(f))).mtimeMs}`).sort();
      const p = spawnSync(process.execPath, ["src/cli.ts", "envelope", env], { cwd: root, encoding: "utf8" });
      expect(p.status).toBe(0);
      expect(p.stdout).toContain("Envelope client-2030-01-02, read-only");
      expect(p.stdout).toMatch(/open\.alias\s+1\/1\n/);
      expect(p.stdout).toMatch(/intake\.capture\s+2\/2\n/);
      expect(p.stdout).toMatch(/deliver\.render\s+1\/6\s+missing art\.revision-inputs \(private\/<envelope>\/revisions\/<revision>\/inputs\/\), art\.render-log/);
      expect(p.stdout).toContain("NOTE one file, several artifacts: private/<envelope>/README.md (");
      expect(p.stdout).toMatch(/SUMMARY client-2030-01-02: \d+ steps declare Envelope artifacts/);
      for (const secret of ["someone-real-name", "Secret Person", "private words", "20300101-000000-abcdef"]) expect(p.stdout).not.toContain(secret);
      const after = readdirSync(env, { recursive: true }).map((f) => `${f}:${statSync(join(env, String(f))).mtimeMs}`).sort();
      expect(after).toEqual(before);
    } finally {
      removeTmp(dir);
    }
  });

  test("a missing folder is refused", () => {
    const p = spawnSync(process.execPath, ["src/cli.ts", "envelope", join(tmpdir(), "no-such-envelope-xyz")], { cwd: root, encoding: "utf8" });
    expect(p.status).toBe(2);
  });
});

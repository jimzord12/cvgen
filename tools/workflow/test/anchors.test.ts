// `anchors` in a throwaway Git repository: a cited file changes after a commit,
// and the anchors that only shifted are MOVED (rewritten by --fix), those whose
// lines changed are EDITED.
import { afterEach, beforeEach, describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import { cpSync, mkdtempSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { anchors } from "../src/anchors";
import { removeTmp } from "./tmp";

let root = "";
const stageFile = () => join(root, "model", "01-make", "stage.yaml");
const git = (...args: string[]) => {
  const p = spawnSync("git", ["-c", "user.name=test", "-c", "user.email=test@example.com", ...args], { cwd: root, encoding: "utf8" });
  expect(p.status).toBe(0);
};
const lines = (n: number) => Array.from({ length: n }, (_, i) => `line ${i + 1}`);
const run = (fix = false) => {
  const log: string[] = [];
  const code = anchors({ base: "HEAD", fix, dir: join(root, "model"), root, log: (l) => log.push(l) });
  return { code, log: log.join("\n") };
};

beforeEach(() => {
  root = mkdtempSync(join(tmpdir(), "workflow-anchors-"));
  cpSync(join(import.meta.dirname, "fixtures", "valid"), join(root, "model"), { recursive: true });
  const stage = readFileSync(stageFile(), "utf8").replace('sources: ["AGENTS.md:1-3", "docs/review.md"]', 'sources: ["notes.md:4-5", "notes.md:8", "notes.md:2-3"]');
  writeFileSync(stageFile(), stage);
  writeFileSync(join(root, "notes.md"), `${lines(10).join("\n")}\n`);
  git("init", "-q");
  git("add", ".");
  git("commit", "-q", "-m", "base");
});
afterEach(() => removeTmp(root));

describe("anchors", () => {
  test("nothing changed: exit 0", () => {
    expect(run()).toEqual({ code: 0, log: "OK anchors since HEAD: 6 with line numbers, 0 moved, 0 edited" }); // 3 here, 3 citing repo files absent in this repository
  });

  test("lines that shifted are MOVED, lines that changed are EDITED", () => {
    const now = lines(10);
    now[7] = "line 8, reworded";
    writeFileSync(join(root, "notes.md"), `new a\nnew b\n${now.join("\n")}\n`);
    const { code, log } = run();
    expect(code).toBe(1);
    expect(log).toContain("MOVED notes.md:4-5 -> notes.md:6-7 (model/01-make/stage.yaml:11)");
    expect(log).toContain("MOVED notes.md:2-3 -> notes.md:4-5");
    expect(log).toContain("EDITED notes.md:8:");
    expect(readFileSync(stageFile(), "utf8")).toContain('"notes.md:4-5", "notes.md:8", "notes.md:2-3"'); // untouched without --fix
  });

  test("--fix rewrites moved anchors in one pass; an edited one stays for a person", () => {
    const now = lines(10);
    now[7] = "line 8, reworded";
    writeFileSync(join(root, "notes.md"), `new a\nnew b\n${now.join("\n")}\n`);
    const { code, log } = run(true);
    expect(code).toBe(1);
    expect(log).toContain("FIXED notes.md:4-5 -> notes.md:6-7");
    // notes.md:2-3 becomes 4-5, the old value of the other anchor: rewritten once, not twice.
    expect(readFileSync(stageFile(), "utf8")).toContain('sources: ["notes.md:6-7", "notes.md:8", "notes.md:4-5"]');
  });

  test("a line inserted inside a cited range is EDITED, not moved", () => {
    const now = lines(10);
    now.splice(4, 0, "inserted between 4 and 5");
    writeFileSync(join(root, "notes.md"), `${now.join("\n")}\n`);
    const { log } = run();
    expect(log).toContain("EDITED notes.md:4-5:");
    expect(log).toContain("MOVED notes.md:8 -> notes.md:9");
  });

  test("an anchor written after the base already cites the file as it is now: not judged", () => {
    writeFileSync(join(root, "notes.md"), `new a\n${lines(10).join("\n")}\n`);
    writeFileSync(stageFile(), readFileSync(stageFile(), "utf8").replace('"notes.md:8"', '"notes.md:9", "notes.md:11"'));
    const { log } = run();
    expect(log).toContain("MOVED notes.md:4-5 -> notes.md:5-6");
    expect(log).not.toContain("notes.md:9 ->");
    expect(log).not.toContain("notes.md:11");
  });

  test("a base that is not a commit is a usage error", () => {
    const log: string[] = [];
    expect(anchors({ base: "no-such-ref", fix: false, dir: join(root, "model"), root, log: (l) => log.push(l) })).toBe(2);
  });
});

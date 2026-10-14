// `anchors <base> [--fix]`: source anchors whose cited lines moved or changed
// since commit <base>. `check` proves an anchor's lines exist; this proves they
// are still the lines the fact was written from. It compares each cited file
// with <base> through `git diff`: lines that only shifted are MOVED (and --fix
// rewrites the anchor in the YAML), lines that were edited, deleted or had
// lines inserted between them are EDITED and need a person to reread them.
// Exit 0 when nothing is left to do, 1 when anything moved (without --fix) or
// was edited, 2 when <base> is not a commit.
import { spawnSync } from "node:child_process";
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { join, relative } from "node:path";
import { loadModel } from "./check";
import { formatIssue } from "./load";

type Hunk = { oldStart: number; oldCount: number; newCount: number };
export type AnchorOptions = { base: string; fix: boolean; dir: string; root: string; log: (line: string) => void };

const git = (root: string, args: string[]) => spawnSync("git", args, { cwd: root, encoding: "utf8" });

/** Every value under a `sources` key in the parsed model. */
function sourcesOf(value: unknown, out = new Set<string>()): Set<string> {
  if (Array.isArray(value)) for (const v of value) sourcesOf(v, out);
  else if (value && typeof value === "object") {
    for (const [key, v] of Object.entries(value)) {
      if (key === "sources" && Array.isArray(v)) for (const s of v) out.add(String(s));
      else sourcesOf(v, out);
    }
  }
  return out;
}

/** The `-U0` hunks of a file between <base> and the working tree. */
function hunks(root: string, base: string, file: string): Hunk[] {
  const diff = git(root, ["diff", "-U0", "--no-color", "--no-ext-diff", base, "--", file]).stdout;
  return [...diff.matchAll(/^@@ -(\d+)(?:,(\d+))? \+\d+(?:,(\d+))? @@/gm)].map((m) => ({
    oldStart: Number(m[1]),
    oldCount: m[2] === undefined ? 1 : Number(m[2]),
    newCount: m[3] === undefined ? 1 : Number(m[3]),
  }));
}

/** Where a line of the <base> file is now, or undefined when it was edited or deleted. */
function mapLine(changes: Hunk[], line: number): number | undefined {
  let shift = 0;
  for (const h of changes) {
    if (h.oldCount > 0 && line >= h.oldStart && line < h.oldStart + h.oldCount) return undefined;
    // A pure insertion (count 0) sits after its start line; a change ends at start + count - 1.
    if (h.oldCount === 0 ? line > h.oldStart : line >= h.oldStart + h.oldCount) shift += h.newCount - h.oldCount;
  }
  return line + shift;
}

export function anchors({ base, fix, dir, root, log }: AnchorOptions): number {
  if (git(root, ["rev-parse", "--verify", "--quiet", `${base}^{commit}`]).status !== 0) {
    log(`${base} is not a commit`);
    return 2;
  }
  const { model, issues } = loadModel(dir, root);
  if (!model) {
    for (const issue of issues) log(formatIssue(issue));
    return 1;
  }
  const files = [join(dir, "catalog.yaml"), ...model.stages.map((s) => join(dir, s.folder, "stage.yaml"))];
  const texts = new Map(files.map((f) => [f, readFileSync(f, "utf8")]));
  const shown = (f: string) => relative(root, f).replaceAll("\\", "/");
  const uses = (anchor: string) =>
    files.flatMap((f) => (texts.get(f) as string).split("\n").flatMap((l, i) => (l.includes(`"${anchor}"`) ? [`${shown(f)}:${i + 1}`] : [])));

  const ranged = [...sourcesOf([model.catalog.data, ...model.stages.map((s) => s.data)])].filter((s) => /:\d+(-\d+)?$/.test(s)).sort();
  const cache = new Map<string, Hunk[]>();
  const fixes = new Map<string, string>();
  let edited = 0;
  for (const anchor of ranged) {
    const colon = anchor.lastIndexOf(":");
    const file = anchor.slice(0, colon);
    const [first, last = first] = anchor.slice(colon + 1).split("-").map(Number) as [number, number?];
    // A file new since <base>, or gone now (check reports that), has nothing to compare.
    if (!existsSync(join(root, file)) || git(root, ["cat-file", "-e", `${base}:${file}`]).status !== 0) continue;
    let changes = cache.get(file);
    if (!changes) cache.set(file, (changes = hunks(root, base, file)));
    const now = Array.from({ length: last - first + 1 }, (_, k) => mapLine(changes, first + k));
    const [from, to] = [now[0], now[now.length - 1]];
    if (now.some((n) => n === undefined) || from === undefined || to === undefined || to - from !== last - first) {
      edited++;
      log(`EDITED ${anchor}: the cited lines changed since ${base}; reread them against the fact (${uses(anchor).join(", ")})`);
      continue;
    }
    if (from === first) continue;
    const updated = `${file}:${from}${last !== first ? `-${to}` : ""}`;
    fixes.set(anchor, updated);
    log(`${fix ? "FIXED" : "MOVED"} ${anchor} -> ${updated} (${uses(anchor).join(", ")})`);
  }
  // One pass per file, so an anchor rewritten to a value another anchor had is not moved twice.
  if (fix) {
    for (const f of files) {
      const text = (texts.get(f) as string).replace(/"([^"\n]+)"/g, (whole, inner: string) => (fixes.has(inner) ? `"${fixes.get(inner)}"` : whole));
      if (text !== texts.get(f)) writeFileSync(f, text);
    }
  }
  const moved = fixes.size;
  const open = edited + (fix ? 0 : moved);
  log(
    `${open === 0 ? "OK" : "FAILED"} anchors since ${base}: ${ranged.length} with line numbers, ${moved} moved${fix && moved ? " (fixed)" : ""}, ${edited} edited`,
  );
  return open === 0 ? 0 : 1;
}

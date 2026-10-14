// The workflow tool's command line.
//   check               check the whole model in docs/workflow (levels 1 and 2); exit 0 clean, 1 on any problem
//   check <dir>         the same for the model in another folder (the test fixtures)
//   check <file...>     shape-check single Workflow Model YAML files
//   anchors <base> [--fix] [<dir>]   source anchors whose cited lines moved or changed since commit <base>
//   render [--check] [<dir>]   write the generated blocks of the workflow READMEs; --check only reports the files it would change (exit 1)
//   schema [--check]    regenerate the committed JSON Schema files; --check only reports stale ones (exit 1)
// Usage errors exit 2.
import { existsSync, statSync } from "node:fs";
import { relative } from "node:path";
import { anchors } from "./anchors";
import { checkModel, modelDir, repoRoot } from "./check";
import { formatIssue, loadFile } from "./load";
import { render } from "./render";
import { schemaDir, staleSchemas, writeSchemas } from "./schema";

const usage = "usage: bun src/cli.ts check [<model dir> | <file.yaml...>] | anchors <base> [--fix] [<model dir>] | render [--check] [<model dir>] | schema [--check]";

const isDir = (path: string) => existsSync(path) && statSync(path).isDirectory();
const shown = (dir: string) => relative(repoRoot, dir).replaceAll("\\", "/") || ".";

function checkDir(dir: string): number {
  const { issues, notes, summary } = checkModel(dir, repoRoot);
  for (const issue of issues) console.error(formatIssue(issue));
  for (const note of notes) console.log(note);
  if (issues.length > 0) {
    console.error(`FAILED model ${shown(dir)}: ${issues.length} problem(s)`);
    return 1;
  }
  console.log(`OK model ${shown(dir)}: ${summary}; levels 1 and 2 pass`);
  return 0;
}

function checkFiles(files: string[]): number {
  let failed = false;
  for (const file of files) {
    let loaded;
    try {
      loaded = loadFile(file);
    } catch (e) {
      console.error(`${file}: cannot read: ${(e as Error).message}`);
      failed = true;
      continue;
    }
    if (loaded.issues.length === 0) {
      console.log(`OK ${file} (${loaded.kind})`);
    } else {
      failed = true;
      for (const issue of loaded.issues) console.error(formatIssue(issue));
      console.error(`FAILED ${file} (${loaded.kind}): ${loaded.issues.length} problem(s)`);
    }
  }
  return failed ? 1 : 0;
}

export function main(args: string[]): number {
  const [command, ...rest] = args;
  if (command === "check") {
    if (rest.length === 0) return checkDir(modelDir);
    if (rest.length === 1 && isDir(rest[0] as string)) return checkDir(rest[0] as string);
    return checkFiles(rest);
  }
  if (command === "anchors") {
    const fix = rest.includes("--fix");
    const [base, dir, ...extra] = rest.filter((a) => a !== "--fix");
    if (!base || extra.length > 0 || (dir !== undefined && !isDir(dir))) {
      console.error(usage);
      return 2;
    }
    return anchors({ base, fix, dir: dir ?? modelDir, root: repoRoot, log: console.log });
  }
  if (command === "render") {
    const check = rest.includes("--check");
    const [dir, ...extra] = rest.filter((a) => a !== "--check");
    if (extra.length > 0 || (dir !== undefined && !isDir(dir))) {
      console.error(usage);
      return 2;
    }
    const { problems, files } = render(dir ?? modelDir, repoRoot, { write: !check });
    if (problems.length > 0) {
      for (const p of problems) console.error(p);
      console.error(`FAILED render: ${problems.length} problem(s); nothing written`);
      return 1;
    }
    const changed = files.filter((f) => f.changed);
    if (check) {
      for (const f of changed) console.error(`STALE ${f.file}: run "bun run render" in tools/workflow`);
      if (changed.length > 0) return 1;
      console.log(`OK ${files.length} generated READMEs match the model`);
      return 0;
    }
    for (const f of changed) console.log(`wrote ${f.file}`);
    console.log(`OK ${files.length} READMEs rendered, ${changed.length} changed`);
    return 0;
  }
  if (command === "schema" && (rest.length === 0 || (rest.length === 1 && rest[0] === "--check"))) {
    if (rest[0] === "--check") {
      const stale = staleSchemas();
      for (const name of stale) console.error(`STALE ${name}: run "bun run schema" in tools/workflow`);
      if (stale.length === 0) console.log(`OK schemas in ${schemaDir} match the types`);
      return stale.length === 0 ? 0 : 1;
    }
    const written = writeSchemas();
    console.log(written.length ? `wrote ${written.join(", ")}` : "schemas already current");
    return 0;
  }
  console.error(usage);
  return 2;
}

if (import.meta.main) process.exit(main(process.argv.slice(2)));

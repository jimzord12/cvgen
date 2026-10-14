// The workflow tool's command line.
//   check <file...>   shape-check Workflow Model YAML files; exit 0 clean, 1 on any problem
//   schema [--check]  regenerate the committed JSON Schema files; --check only reports stale ones (exit 1)
// Usage errors exit 2.
import { formatIssue, loadFile } from "./load";
import { schemaDir, staleSchemas, writeSchemas } from "./schema";

const usage = "usage: bun src/cli.ts check <file.yaml...> | schema [--check]";

export function main(args: string[]): number {
  const [command, ...rest] = args;
  if (command === "check" && rest.length > 0) {
    let failed = false;
    for (const file of rest) {
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

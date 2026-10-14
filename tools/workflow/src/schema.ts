// Exports the JSON Schema files from the Zod types. The files are committed
// (tools/workflow/schema/) so the VS Code YAML language server can read them
// through a `# yaml-language-server: $schema=...` line; a test fails when they
// are stale.
import { readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { z } from "zod";
import { Catalog, Stage } from "./model";

export const schemaDir = join(import.meta.dirname, "..", "schema");
export const schemas = { "stage.schema.json": Stage, "catalog.schema.json": Catalog } as const;
export type SchemaFile = keyof typeof schemas;

// draft-07: the widest support among editors; `input` so defaulted fields stay optional.
export const schemaText = (name: SchemaFile): string =>
  `${JSON.stringify(z.toJSONSchema(schemas[name], { target: "draft-7", io: "input" }), null, 2)}\n`;

/** Names of the committed schema files that differ from the types. */
export function staleSchemas(): SchemaFile[] {
  return (Object.keys(schemas) as SchemaFile[]).filter((name) => {
    try {
      return readFileSync(join(schemaDir, name), "utf8").replace(/\r\n/g, "\n") !== schemaText(name);
    } catch {
      return true;
    }
  });
}

/** Regenerates the committed schema files; returns the ones it changed. */
export function writeSchemas(): SchemaFile[] {
  const stale = staleSchemas();
  for (const name of stale) writeFileSync(join(schemaDir, name), schemaText(name));
  return stale;
}

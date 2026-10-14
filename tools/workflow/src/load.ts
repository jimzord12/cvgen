// Loads one Workflow Model YAML file and checks its shape against the Zod
// types, reporting each problem with file, line and path. Level 1 shape only:
// references across files are resolved by the model-wide check (src/check.ts),
// which takes the `data` and `lineAt` returned here.
import { readFileSync } from "node:fs";
import { basename } from "node:path";
import { isMap, isNode, LineCounter, parseDocument, type Document } from "yaml";
import type { z } from "zod";
import { Catalog, Stage } from "./model";

/** A problem in a file; `rule` names the model check that found it (absent for a file's shape check). */
export type Issue = { file: string; line?: number; path: string; message: string; rule?: string };
export type FileKind = "stage" | "catalog";
/** The line of the node at a path in the file, or of its nearest parent that exists. */
export type LineAt = (path: (string | number)[]) => number | undefined;
export type Loaded =
  | { kind: "stage"; data?: Stage; issues: Issue[]; lineAt: LineAt }
  | { kind: "catalog"; data?: Catalog; issues: Issue[]; lineAt: LineAt };

const types = { stage: Stage, catalog: Catalog } as const;

/** `catalog.yaml` holds the catalog; any other file is read as a stage. */
export const kindOf = (file: string): FileKind => (basename(file) === "catalog.yaml" ? "catalog" : "stage");

export function loadFile(file: string): Loaded {
  return loadText(readFileSync(file, "utf8"), file, kindOf(file));
}

export function loadText<K extends FileKind>(text: string, file: string, kind: K): Extract<Loaded, { kind: K }> {
  return check(text, file, kind) as Extract<Loaded, { kind: K }>;
}

function check(text: string, file: string, kind: FileKind): Loaded {
  const lines = new LineCounter();
  const doc = parseDocument(text, { lineCounter: lines, prettyErrors: true, uniqueKeys: true });
  const lineAt: LineAt = (path) => lineOf(doc, lines, path);
  if (doc.errors.length > 0) {
    const issues = doc.errors.map((e) => ({
      file,
      line: e.linePos?.[0]?.line,
      path: "(yaml)",
      message: e.message.split("\n")[0] ?? e.message,
    }));
    return { kind, issues, lineAt };
  }
  const result = types[kind].safeParse(doc.toJS());
  if (result.success) return { kind, data: result.data, issues: [], lineAt } as Loaded;
  const issues = result.error.issues.flatMap((issue) => toIssues(issue, doc, lines, file));
  return { kind, issues, lineAt };
}

function toIssues(issue: z.core.$ZodIssue, doc: Document, lines: LineCounter, file: string): Issue[] {
  const path = issue.path.filter((p): p is string | number => typeof p !== "symbol");
  if (issue.code === "unrecognized_keys") {
    return issue.keys.map((key) => ({
      file,
      line: lineOf(doc, lines, path, key),
      path: formatPath([...path, key]),
      message: "unknown key (not part of the type; check the spelling)",
    }));
  }
  const message = issue.message.includes("received undefined") ? "required field is missing" : issue.message;
  return [{ file, line: lineOf(doc, lines, path), path: formatPath(path), message }];
}

/** The line of the node at `path`, or of the nearest parent that exists. */
function lineOf(doc: Document, lines: LineCounter, path: (string | number)[], key?: string): number | undefined {
  for (let n = path.length; n >= 0; n--) {
    const node = n === 0 ? doc.contents : doc.getIn(path.slice(0, n), true);
    if (!isNode(node) || !node.range) continue;
    if (key !== undefined && n === path.length && isMap(node)) {
      const pair = node.items.find((p) => (p.key as { value?: unknown } | null)?.value === key);
      const range = (pair?.key as { range?: [number, number, number] } | undefined)?.range;
      if (range) return lines.linePos(range[0]).line;
    }
    return lines.linePos(node.range[0]).line;
  }
  return undefined;
}

export const formatPath = (path: (string | number)[]): string =>
  path.reduce<string>((out, p) => (typeof p === "number" ? `${out}[${p}]` : out ? `${out}.${p}` : p), "") || "(root)";

export const formatIssue = (i: Issue): string =>
  `${i.file}${i.line ? `:${i.line}` : ""}: ${i.path}: ${i.message}${i.rule ? ` [${i.rule}]` : ""}`;

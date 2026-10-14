// The Mermaid flowcharts `render` writes, and a validator for exactly that
// subset of the syntax. GitHub renders a ```mermaid block in the browser, so a
// broken diagram shows as an error box on the page and nothing fails here; the
// validator is what fails instead. The real Mermaid parser needs a browser DOM
// (and pulls in d3 and more), so it is not run under Bun; the subset below is
// small enough to check line by line.
//
// The subset: `flowchart TD` or `flowchart LR`; one node per line,
// `id["label"]` (a step), `id{"label"}` (a gate) or `id(["label"])` (a step in
// another stage, an escalation); one edge per line, `a --> b`, `a -.-> b` or
// either with a quoted label, `a -->|"label"| b`. Node IDs are letters, digits
// and underscores (model IDs have dots and dashes, which Mermaid reads as
// syntax: `nodeId` maps them); every label is quoted, on one line, without
// HTML and without a double quote (`label` escapes them as entity codes).

/** Mermaid's reserved words, which break a flowchart when used as a node ID. */
const reserved = new Set(["end", "graph", "flowchart", "subgraph", "style", "class", "classdef", "click", "call", "href", "linkstyle", "default", "direction"]);

/** A safe node ID for a model ID: `design.run-brief` -> `s_design__run_brief` (a dot is `__`, a dash `_`; kebab IDs never hold `__`). */
export const nodeId = (prefix: "s" | "g" | "x" | "st", id: string): string => `${prefix}_${id.replaceAll(".", "__").replaceAll("-", "_")}`;

/** A quoted label, on one line, with `#`, `"`, `<` and `>` written as Mermaid entity codes. */
export const label = (text: string): string =>
  `"${text
    .replace(/\s+/g, " ")
    .trim()
    .replace(/#/g, "#35;")
    .replace(/"/g, "#quot;")
    .replace(/</g, "#lt;")
    .replace(/>/g, "#gt;")}"`;

const id = "[A-Za-z][A-Za-z0-9_]*";
const quoted = '"([^"]*)"';
const header = /^flowchart (TD|LR)$/;
const nodeLine = new RegExp(`^(${id})(?:\\[${quoted}\\]|\\{${quoted}\\}|\\(\\[${quoted}\\]\\))$`);
const edgeLine = new RegExp(`^(${id}) (-->|-\\.->)(?:\\|${quoted}\\|)? (${id})$`);

/** Problems in a diagram of the subset above, as `line N: reason`; none means it parses. */
export function validateFlowchart(text: string): string[] {
  const problems: string[] = [];
  const lines = text.split("\n");
  const defined = new Set<string>();
  const say = (n: number, reason: string) => problems.push(`line ${n + 1}: ${reason}`);
  const checkId = (n: number, node: string) => {
    if (reserved.has(node.toLowerCase())) say(n, `${node} is a Mermaid keyword and cannot be a node ID`);
  };
  const checkLabel = (n: number, text: string) => {
    if (text.trim() === "") say(n, "empty label");
    if (/[<>]/.test(text)) say(n, `label ${text} holds HTML or an angle bracket; write #lt; and #gt;`);
    if (/#(?![a-z]+;|\d+;)/.test(text)) say(n, `label ${text} holds a bare #; write #35;`);
  };
  if (!header.test(lines[0] ?? "")) say(0, `the first line must be "flowchart TD" or "flowchart LR", not "${lines[0] ?? ""}"`);
  lines.slice(1).forEach((raw, i) => {
    const n = i + 1;
    const line = raw.trim();
    if (line === "" || line.startsWith("%%")) return;
    if (raw !== `  ${line}`) say(n, "indent every line after the header by two spaces");
    const node = nodeLine.exec(line);
    if (node) {
      const [, name = "", ...labels] = node;
      checkId(n, name);
      checkLabel(n, labels.find((l) => l !== undefined) ?? "");
      if (defined.has(name)) say(n, `${name} is defined twice`);
      defined.add(name);
      return;
    }
    const edge = edgeLine.exec(line);
    if (edge) {
      const [, from = "", , text, to = ""] = edge;
      for (const end of [from, to]) {
        checkId(n, end);
        if (!defined.has(end)) say(n, `${end} is used before it is defined with a label`);
      }
      if (text !== undefined) checkLabel(n, text);
      return;
    }
    say(n, `not a node or an edge of the subset render writes: ${line}`);
  });
  return problems;
}

/** Every ```mermaid block in a Markdown text, with the line its body starts on. */
export function mermaidBlocks(markdown: string): { line: number; body: string }[] {
  const blocks: { line: number; body: string }[] = [];
  const lines = markdown.split("\n");
  for (let i = 0; i < lines.length; i++) {
    if (lines[i] !== "```mermaid") continue;
    const end = lines.indexOf("```", i + 1);
    if (end < 0) {
      blocks.push({ line: i + 2, body: "" }); // unclosed: fails the header check
      break;
    }
    blocks.push({ line: i + 2, body: lines.slice(i + 1, end).join("\n") });
    i = end;
  }
  return blocks;
}

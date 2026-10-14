// The types against the sample stage: the valid file passes Zod and the
// committed JSON Schema (what VS Code reads); each kind of broken input fails
// both, and the workflow tool names its path and line.
import { describe, expect, test } from "bun:test";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import Ajv from "ajv";
import { parse } from "yaml";
import { loadText, type FileKind, type Issue } from "../src/load";
import { schemaDir } from "../src/schema";

const root = join(import.meta.dirname, "..");
const sample = readFileSync(join(root, "sample", "stage.yaml"), "utf8").replace(/\r\n/g, "\n");

const ajv = new Ajv({ allErrors: true });
ajv.addKeyword("patternErrorMessage"); // read by the VS Code YAML extension, not a validation rule
const editor = {
  stage: ajv.compile(JSON.parse(readFileSync(join(schemaDir, "stage.schema.json"), "utf8"))),
  catalog: ajv.compile(JSON.parse(readFileSync(join(schemaDir, "catalog.schema.json"), "utf8"))),
};

const lineOf = (text: string, fragment: string) => text.split("\n").findIndex((l) => l.includes(fragment)) + 1;

/** Replaces `from` in the sample, checking that it really occurs once. */
function broken(from: string, to: string): string {
  expect(sample.split(from).length).toBe(2);
  return sample.replace(from, to);
}

function rejected(text: string, kind: FileKind = "stage"): Issue[] {
  const { data, issues } = loadText(text, "broken.yaml", kind);
  expect(data).toBeUndefined();
  expect(issues.length).toBeGreaterThan(0);
  expect(editor[kind](parse(text))).toBe(false); // the JSON Schema refuses it too
  return issues;
}

describe("the sample stage", () => {
  test("passes the Zod types", () => {
    const { data, issues } = loadText(sample, "stage.yaml", "stage");
    expect(issues).toEqual([]);
    expect(data?.id).toBe("text");
    expect(data?.steps.map((s) => s.id)).toContain("text.client-check");
    // defaults are filled in: a step without outputs has an empty list, an artifact is not external
    expect(data?.steps.find((s) => s.id === "text.correction-cap")?.outputs).toEqual([]);
    expect(data?.artifacts.find((a) => a.id === "art.draft-pdf")?.external).toBe(false);
  });

  test("a source path may contain spaces", () => {
    const text = broken('sources: ["scripts/text-draft.typ"]', 'sources: ["backlog/tasks/task-37 - workflow-facts.md:3-9"]');
    expect(loadText(text, "stage.yaml", "stage").issues).toEqual([]);
    expect(editor.stage(parse(text))).toBe(true);
  });

  test("passes the committed JSON Schema, as VS Code reads it", () => {
    expect(sample.split("\n")[0]).toBe("# yaml-language-server: $schema=../schema/stage.schema.json");
    const ok = editor.stage(parse(sample));
    expect(editor.stage.errors ?? []).toEqual([]);
    expect(ok).toBe(true);
  });
});

describe("broken stages fail with a path and a line", () => {
  test("unknown key", () => {
    const text = broken("    action: lead.write-text-draft\n", "    action: lead.write-text-draft\n    owner: actor.owner\n");
    expect(rejected(text)).toEqual([
      { file: "broken.yaml", line: lineOf(text, "owner: actor.owner"), path: "steps[0].owner", message: expect.stringContaining("unknown key") },
    ]);
  });

  test("bad action kind in an action definition", () => {
    const text = broken("    kind: lead\n    name: Write the Text Draft", "    kind: script\n    name: Write the Text Draft");
    const [issue] = rejected(text);
    expect(issue).toMatchObject({ path: "actions[1].kind", line: lineOf(text, "kind: script") });
    expect(issue?.message).toContain("kind must be one of cmd, skill, agent, manual, lead");
  });

  test("bad action kind in a step's reference", () => {
    const text = broken("    action: lead.write-text-draft", "    action: run.write-text-draft");
    const [issue] = rejected(text);
    expect(issue).toMatchObject({ path: "steps[0].action", line: lineOf(text, "action: run.write-text-draft") });
    expect(issue?.message).toContain("kind cmd, skill, agent, manual, lead");
  });

  test("missing required field", () => {
    const text = broken("    check: The client replied OK to every underlined fact.\n", "");
    expect(rejected(text)).toEqual([
      { file: "broken.yaml", line: lineOf(text, "- id: gate.sign-off"), path: "gates[0].check", message: "required field is missing" },
    ]);
  });

  test("bad ID", () => {
    const text = broken("  - id: text.draft-write", "  - id: text.Draft_Write");
    const [issue] = rejected(text);
    expect(issue).toMatchObject({ path: "steps[0].id", line: lineOf(text, "text.Draft_Write") });
    expect(issue?.message).toContain("kebab-case");
  });

  test("a reference of the wrong kind", () => {
    const text = broken("    pass: text.sign-off-record", "    pass: art.sign-off-png");
    expect(rejected(text)[0]?.path).toBe("gates[0].pass");
  });

  test("a loop without a positive cap", () => {
    const text = broken("cap: { attended: 3 }", "cap: { attended: 0 }");
    expect(rejected(text)[0]?.path).toBe("loops[0].cap.attended");
  });

  test("a bad source anchor", () => {
    const text = broken('sources: ["scripts/text-draft.typ"]', 'sources: ["scripts/text-draft.typ:L4"]');
    expect(rejected(text)[0]?.path).toBe("artifacts[3].sources[0]");
  });

  test("a step ID that starts with a reserved prefix names the prefixes", () => {
    const text = broken("  - id: text.draft-write", "  - id: art.draft-write");
    const [issue] = rejected(text);
    expect(issue?.path).toBe("steps[0].id");
    expect(issue?.message).toContain("may not be one of the ID prefixes art, actor, gate, loop");
  });

  test("a stage named after a reserved prefix names the prefixes", () => {
    const text = broken("id: text\nname: Text Draft and Sign-off", "id: art\nname: Text Draft and Sign-off");
    const [issue] = rejected(text);
    expect(issue).toMatchObject({ path: "id", line: lineOf(text, "id: art") });
    expect(issue?.message).toContain("may not be one of the ID prefixes art, actor, gate, loop");
  });

  test("a source range that runs backwards (the workflow tool only)", () => {
    const text = broken('sources: ["docs/guides/client-workflow.md:248-278"]', 'sources: ["docs/guides/client-workflow.md:278-248"]');
    const { data, issues } = loadText(text, "broken.yaml", "stage");
    expect(data).toBeUndefined();
    expect(issues).toEqual([
      { file: "broken.yaml", line: lineOf(text, "278-248"), path: "sources[0]", message: expect.stringContaining("runs backwards") },
    ]);
  });

  test("broken YAML reports the line", () => {
    const text = broken("    inputs: [art.facts-md, art.decisions-md, art.text-draft-lib]", "    inputs: [art.facts-md");
    const { data, issues } = loadText(text, "broken.yaml", "stage");
    expect(data).toBeUndefined();
    expect(issues[0]).toMatchObject({ path: "(yaml)", line: expect.any(Number) });
  });
});

describe("the catalog", () => {
  const catalog = `actors:
  - id: actor.owner
    name: The owner
    sources: ["docs/preferences.md"]
    kind: human
    does: Talks to the client, approves the exact PDF.
actions:
  - id: agent.research-reviewer
    kind: agent
    name: Research review
    sources: [".claude/agents/research-reviewer.md"]
    agent: research-reviewer
artifacts:
  - id: art.envelope-json
    name: envelope.json
    sources: ["docs/guides/client-workflow.md:69-77"]
    path: private/<envelope>/envelope.json
    visibility: private
`;

  test("a valid catalog passes both", () => {
    expect(loadText(catalog, "catalog.yaml", "catalog").issues).toEqual([]);
    expect(editor.catalog(parse(catalog))).toBe(true);
  });

  test("an action whose ID does not match its kind fails", () => {
    const text = catalog.replace("id: agent.research-reviewer", "id: skill.research-reviewer");
    expect(rejected(text, "catalog")[0]?.path).toBe("actions[0].id");
  });

  test("an actor of an unknown kind fails", () => {
    expect(rejected(catalog.replace("kind: human", "kind: robot"), "catalog")[0]?.path).toBe("actors[0].kind");
  });
});

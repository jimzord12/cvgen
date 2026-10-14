// `render` on real files: the real model in docs/workflow (its committed
// READMEs must be current and every diagram must parse), and a copy of the
// valid fixture model in a temporary folder, rendered through the real command
// line, edited by hand and rendered again.
import { afterEach, beforeEach, describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import { cpSync, existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { modelDir, repoRoot } from "../src/check";
import { label, mermaidBlocks, nodeId, validateFlowchart } from "../src/mermaid";
import { blockNames, endMarker, render, startMarker } from "../src/render";

const tool = join(import.meta.dirname, "..");
const run = (...args: string[]) => {
  const p = spawnSync(process.execPath, ["src/cli.ts", ...args], { cwd: tool, encoding: "utf8" });
  return { code: p.status, out: p.stdout, err: p.stderr };
};

describe("the real model in docs/workflow", () => {
  test("the committed READMEs are what render writes: --check exits 0", () => {
    const r = run("render", "--check");
    expect(r).toMatchObject({ code: 0, err: "" });
    expect(r.out).toContain("OK 8 generated READMEs match the model");
  });

  test("every generated diagram parses: one journey and one per stage, eight in all", () => {
    const { problems, files } = render(modelDir, repoRoot, { write: false });
    expect(problems).toEqual([]);
    const diagrams = files.flatMap((f) => mermaidBlocks(f.text).map((d) => ({ file: f.file, ...d })));
    expect(diagrams.map((d) => d.file)).toEqual([
      "docs/workflow/README.md",
      ...["01-open", "02-intake", "03-research", "04-text-draft", "05-design", "06-deliver", "07-after"].map((s) => `docs/workflow/${s}/README.md`),
    ]);
    for (const d of diagrams) expect({ file: d.file, problems: validateFlowchart(d.body) }).toEqual({ file: d.file, problems: [] });
  });

  test("the journey shows every stage in order and the design and deliver loop going back", () => {
    const journey = readFileSync(join(modelDir, "README.md"), "utf8");
    expect(journey).toContain('st_open["01 open: Open the Envelope"]');
    expect(journey).toContain("st_design -->");
    expect(journey).toMatch(/st_deliver -\.->\|"\d+ artifacts?"\| st_design/);
    expect(journey).toContain("| `deliver` | `design` | `art.candidate-json`, `art.cv-typ` |");
  });
});

describe("a fixture model rendered through the command line", () => {
  let dir = "";
  const top = () => join(dir, "README.md");
  const stage = () => join(dir, "01-make", "README.md");
  const read = (file: string) => readFileSync(file, "utf8");

  beforeEach(() => {
    dir = mkdtempSync(join(tmpdir(), "workflow-render-"));
    cpSync(join(tool, "test", "fixtures", "valid"), dir, { recursive: true });
  });
  afterEach(() => rmSync(dir, { recursive: true, force: true }));

  test("creates each README with a placeholder heading and every block, and is stable", () => {
    const first = run("render", dir);
    expect(first.code).toBe(0);
    expect(first.out).toContain("OK 2 READMEs rendered, 2 changed");
    const text = read(stage());
    expect(text.startsWith("# 01 make: make\n\n<!-- Hand-written text goes outside the generated blocks.")).toBe(true);
    for (const name of blockNames.stage) {
      expect(text).toContain(`${startMarker(name)}\n`);
      expect(text).toContain(`\n${endMarker(name)}`);
    }
    for (const name of blockNames.journey) expect(read(top())).toContain(startMarker(name));
    // A second run changes nothing, byte for byte.
    const again = run("render", dir);
    expect(again.out).toContain("OK 2 READMEs rendered, 0 changed");
    expect(read(stage())).toBe(text);
    expect(run("render", "--check", dir).code).toBe(0);
  });

  test("the stage README holds the step table, gate, loop with its placeholder cap, and diagram", () => {
    run("render", dir);
    const text = read(stage());
    expect(text).toContain(
      "| `make.review` | make.review | `actor.code-reviewer` | `agent.code-reviewer` | `art.result` | `art.report` | `gate.review` |  |",
    );
    expect(text).toContain("| `make.fix` | make.fix | `actor.lead` | `lead.fix` | `art.report` | `art.draft` |  | The review returned FINDINGS. |");
    expect(text).toContain("| `gate.review` | gate.review | `make.review` | It holds. | `make.ship` | `make.fix` |");
    expect(text).toContain("| `loop.review` | Review rounds (placeholder cap) | `gate.review` | 2 attended, **placeholder** ([GAPS.md](../GAPS.md)) | `make.cap-reached` |");
    expect(text).toContain("| `art.draft` | Draft | `private/<envelope>/draft.json` | private | `make.start`, `make.fix` |");
    expect(text).toContain("| `cmd.status` | cmd | Status | `python scripts/cv.py status private/<envelope>` |");
    const [diagram] = mermaidBlocks(text);
    expect(validateFlowchart(diagram?.body ?? "")).toEqual([]);
    expect(diagram?.body.split("\n")).toEqual([
      "flowchart TD",
      "  %% An arrow implied by a longer path is left out, unless that path runs through an optional step with another condition; the tables list every input and handover.",
      '  s_make__start["make.start"]',
      '  s_make__build["make.build"]',
      '  s_make__review["make.review"]',
      '  s_make__fix["make.fix"]',
      '  s_make__ship["make.ship"]',
      '  s_make__cap_reached["make.cap-reached"]',
      '  g_gate__review{"gate.review"}',
      "  s_make__start --> s_make__build",
      "  s_make__build --> s_make__review",
      "  s_make__fix --> s_make__build",
      "  s_make__review --> g_gate__review",
      '  g_gate__review -->|"pass"| s_make__ship',
      '  g_gate__review -.->|"fail, loop.review"| s_make__fix',
      '  g_gate__review -.->|"cap 2 attended (placeholder)"| s_make__cap_reached',
    ]);
  });

  test("hand-written text outside the markers survives a re-render, and so does a moved block", () => {
    run("render", dir);
    const rendered = read(stage());
    const loops = rendered.slice(rendered.indexOf(startMarker("loops")), rendered.indexOf(endMarker("loops")) + endMarker("loops").length);
    const edited = `${rendered
      .replace("# 01 make: make", "# Make: the hand-written title\n\nA paragraph | with a pipe, naming `<!-- generated:start <name> -->` in passing.")
      .replace(`${loops}\n\n`, "")
      .replace(startMarker("steps"), `Before the steps, by hand.\n\n${loops}\n\nStill by hand.\n\n${startMarker("steps")}`)}\nA closing note.\n`;
    writeFileSync(stage(), edited);
    expect(run("render", "--check", dir).code).toBe(0);
    expect(run("render", dir).out).toContain("0 changed");
    expect(read(stage())).toBe(edited);
    expect(read(stage()).indexOf(startMarker("loops"))).toBeLessThan(read(stage()).indexOf(startMarker("steps")));
  });

  test("a generated block edited by hand fails --check, naming the file; render puts it back", () => {
    run("render", dir);
    const rendered = read(stage());
    writeFileSync(stage(), rendered.replace("| `make.fix` | make.fix |", "| `make.fix` | Fixed by hand |"));
    const r = run("render", "--check", dir);
    expect(r.code).toBe(1);
    expect(r.err).toMatch(/^STALE .*01-make\/README\.md: run "bun run render" in tools\/workflow$/m);
    expect(run("render", dir).out).toContain("1 changed");
    expect(read(stage())).toBe(rendered);
  });

  test("a change to the model makes the READMEs stale", () => {
    run("render", dir);
    const yaml = join(dir, "01-make", "stage.yaml");
    writeFileSync(yaml, read(yaml).replace("    name: make.ship\n", "    name: Ship it\n"));
    const r = run("render", "--check", dir);
    expect(r.code).toBe(1);
    expect(r.err).toContain("01-make/README.md");
    expect(r.err.match(/^STALE /gm)).toHaveLength(1); // the journey README names no step
  });

  test("a block whose markers were deleted comes back at the end of the file", () => {
    run("render", dir);
    const rendered = read(stage());
    const start = rendered.indexOf(startMarker("actions"));
    const end = rendered.indexOf(endMarker("actions")) + endMarker("actions").length;
    writeFileSync(stage(), `${rendered.slice(0, start)}${rendered.slice(end + 2)}`);
    expect(run("render", "--check", dir).code).toBe(1);
    run("render", dir);
    expect(read(stage()).trimEnd().endsWith(endMarker("actions"))).toBe(true);
  });

  test("a marker quoted inside a code fence is text: it is neither replaced nor counted", () => {
    run("render", dir);
    const quoted = ["```markdown", startMarker("steps"), "an example, by hand", endMarker("steps"), "```", "~~~", startMarker("nosuch"), "~~~"].join("\n");
    const edited = read(stage()).replace("# 01 make: make\n", `# 01 make: make\n\n${quoted}\n`);
    writeFileSync(stage(), edited);
    expect(run("render", "--check", dir).code).toBe(0);
    expect(run("render", dir).code).toBe(0);
    expect(read(stage())).toBe(edited);
  });

  test("a code fence never closed stops render at its line, writes nothing, and the README names the failure", () => {
    run("render", dir);
    const edited = read(stage()).replace("# 01 make: make\n", "# 01 make: make\n\n~~~\nan example left open\n");
    writeFileSync(stage(), edited);
    for (const args of [["render", dir], ["render", "--check", dir]]) {
      const r = run(...args);
      expect(r.code).toBe(1);
      expect(r.err).toMatch(/01-make\/README\.md:3: code fence ~~~ never closed/);
    }
    expect(read(stage())).toBe(edited);
    expect(readFileSync(join(tool, "README.md"), "utf8")).toContain("or a code fence never closed, stops");
  });

  test("an arrow stays when the only longer path runs through a step with another condition, and goes when it is the same", () => {
    // make.side reads art.draft (from make.start and make.fix) and writes art.note; make.join reads both.
    // start -> join is implied only through make.side, which has a condition start does not: drawn.
    // fix -> join is implied through make.side under the same condition as make.fix: left out.
    const yaml = join(dir, "01-make", "stage.yaml");
    const step = (id: string, inputs: string, outputs: string, when?: string) =>
      `  - id: ${id}\n    name: ${id}\n    sources: ["AGENTS.md"]\n    actor: actor.lead\n    action: lead.work\n    inputs: [${inputs}]\n    outputs: [${outputs}]\n${when ? `    when: ${when}\n` : ""}`;
    const extra = `${step("make.side", "art.draft", "art.note", "The review returned FINDINGS.")}\n${step("make.join", "art.draft, art.note", "art.joined")}\n`;
    const artifacts = `  - { id: art.note, name: art.note, sources: ["AGENTS.md"], visibility: private }\n  - { id: art.joined, name: art.joined, sources: ["AGENTS.md"], visibility: private }\n`;
    writeFileSync(yaml, read(yaml).replace(/\r\n/g, "\n").replace("\ngates:\n", `\n${extra}\ngates:\n`).replace("\n\nactions:\n", `\n${artifacts}\nactions:\n`));
    const r = run("render", dir);
    expect(r).toMatchObject({ code: 0, err: "" });
    const edges = (mermaidBlocks(read(stage()))[0]?.body ?? "").split("\n").filter((l) => l.includes("-->"));
    expect(edges).toContain("  s_make__start --> s_make__side");
    expect(edges).toContain("  s_make__side --> s_make__join");
    expect(edges).toContain("  s_make__start --> s_make__join");
    expect(edges).toContain("  s_make__fix --> s_make__side");
    expect(edges).not.toContain("  s_make__fix --> s_make__join");
  });

  test("a file with Windows line endings and the same content is current", () => {
    run("render", dir);
    writeFileSync(stage(), read(stage()).replace(/\n/g, "\r\n"));
    expect(run("render", "--check", dir).code).toBe(0);
  });

  const broken: [string, (t: string) => string, string][] = [
    ["an unknown block", (t) => `${t}\n${startMarker("stepz")}\n${endMarker("stepz")}\n`, 'unknown block "stepz"'],
    ["a block twice", (t) => `${t}\n${startMarker("gates")}\n${endMarker("gates")}\n`, "block gates appears twice"],
    ["an end without its start", (t) => t.replace(startMarker("gates"), "gone"), `${endMarker("gates")} has no matching start`],
    ["a start without its end", (t) => t.replace(endMarker("gates"), "gone"), "block loops starts inside block gates"],
    ["a malformed marker", (t) => t.replace(startMarker("gates"), "<!-- generated:start  gates -->"), "malformed marker"],
  ];
  for (const [what, edit, message] of broken) {
    test(`${what}: exit 1 with file and line, nothing written`, () => {
      run("render", dir);
      writeFileSync(stage(), edit(read(stage())));
      const before = read(stage());
      writeFileSync(join(dir, "01-make", "stage.yaml"), read(join(dir, "01-make", "stage.yaml")).replace("name: make.ship", "name: Changed"));
      const r = run("render", dir);
      expect(r.code).toBe(1);
      expect(r.err).toMatch(new RegExp(`01-make/README\\.md:\\d+: .*${message.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}`));
      expect(r.err).toContain("nothing written");
      expect(read(stage())).toBe(before);
    });
  }

  test("a model that fails the check is not rendered", () => {
    const r = run("render", join(tool, "test", "fixtures", "cycle"));
    expect(r.code).toBe(1);
    expect(r.err).toContain("the model must pass `bun run check` before it renders");
    expect(r.err).toContain("[cycle]");
    expect(existsSync(join(tool, "test", "fixtures", "cycle", "README.md"))).toBe(false);
  });

  test("usage errors exit 2", () => {
    expect(run("render", "no-such-dir").code).toBe(2);
    expect(run("render", dir, "extra").code).toBe(2);
  });
});

describe("the Mermaid subset", () => {
  test("model IDs map to safe node IDs and labels escape what Mermaid reads as syntax", () => {
    expect(nodeId("s", "design.run-brief")).toBe("s_design__run_brief");
    expect(nodeId("s", "a.b")).not.toBe(nodeId("s", "a-b"));
    expect(nodeId("g", "gate.a-b")).not.toBe(nodeId("g", "gate-a.b"));
    expect(label('a "quoted" <b> #1\n  next')).toBe('"a #quot;quoted#quot; #lt;b#gt; #35;1 next"');
    expect(validateFlowchart(`flowchart LR\n  a[${label('say "hi" <br> #1')}]`)).toEqual([]);
  });

  const bad: [string, string, string][] = [
    ["a dot in a node ID", 'flowchart TD\n  design.fix["x"]', "not a node or an edge"],
    ["an unquoted label", "flowchart TD\n  a[x]", "not a node or an edge"],
    ["HTML in a label", 'flowchart TD\n  a["one<br>two"]', "holds HTML"],
    ["a bare #", 'flowchart TD\n  a["no #1"]', "bare #"],
    ["an edge to an undefined node", 'flowchart TD\n  a["x"]\n  a --> b', "b is used before it is defined"],
    ["a keyword as an ID", 'flowchart TD\n  end["x"]', "end is a Mermaid keyword"],
    ["a node defined twice", 'flowchart TD\n  a["x"]\n  a["y"]', "a is defined twice"],
    ["another diagram type", 'graph TD\n  a["x"]', "the first line must be"],
    ["an empty label", 'flowchart TD\n  a[""]', "empty label"],
    ["an unclosed block", mermaidBlocks("```mermaid\nflowchart TD\n")[0]?.body ?? "?", "the first line must be"],
  ];
  for (const [what, text, problem] of bad) {
    test(`refuses ${what}`, () => {
      expect(validateFlowchart(text).join("\n")).toContain(problem);
    });
  }
});

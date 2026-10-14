# tools/workflow: the workflow tool

The TypeScript program, on Bun, that holds the `Workflow Model`'s types and
checks its YAML facts (ADR 0015): the shape of each file, the whole model
in `docs/workflow/` at levels 1 (shape and references) and 2 (flow) of the
approved design (`docs/proposals/workflow-model.md`), writes the generated
half of the workflow READMEs (`render`) and the `Atlas` client-journey page
(`atlas`) from it, and runs level 3: the model run by a fictional client
through the real scripts, plus a read-only walk of a real `Envelope`.

| Path | What it holds |
|---|---|
| `src/model.ts` | The Zod types: Stage, Step, Artifact, Action, Actor, Gate, Loop, Catalog. The one source of the contract |
| `src/load.ts` | Reads a YAML file, checks it against the types, reports file, line, path and reason |
| `src/check.ts` | The model check: every rule below, over the catalog and every stage |
| `src/render.ts` | Writes the generated blocks of `docs/workflow/README.md` and each stage's `README.md` |
| `src/atlas.ts` | Writes the `Atlas` client-journey page, `.atlas/src/pages/client-journey.json` |
| `src/mermaid.ts` | The Mermaid subset `render` writes, and the validator that proves each diagram is inside it |
| `src/reality.ts` | Level 3: the fictional run (`reality`) and the read-only `Envelope` walk (`envelope`) |
| `src/anchors.ts` | Source anchors whose cited lines moved or changed since a commit |
| `src/schema.ts` | Exports the JSON Schema files from the types |
| `src/cli.ts` | The command line |
| `schema/` | The exported JSON Schema files, committed, never hand-edited |
| `sample/stage.yaml` | A short sample stage, used by the tests; illustrative, not facts |
| `test/fixtures/` | `valid/`, a small model that passes, and one broken model per rule, named after it (`command-*` are three more for the `command` rule) |
| `.bun-version` | The Bun version CI installs (1.4.2); locally any 1.4.x from 1.4.2 |

Run every command from `tools/workflow/`. Once, after a clone:

```powershell
bun install --frozen-lockfile   # the exact versions in bun.lock; fails rather than rewrite it
```

Day to day:

```powershell
bun run check                             # the whole model in docs/workflow: exit 0 clean, 1 with problems
bun run check test/fixtures/cycle         # the same for the model in another folder
bun run check sample/stage.yaml           # shape only, file by file (catalog.yaml is read as the catalog)
bun run anchors <commit> [--fix]          # anchors whose cited lines moved or changed since <commit>
bun run render                            # rewrite the generated blocks of the workflow READMEs from the model
bun run render --check                    # exit 1, naming each README, if render would change it
bun run atlas                             # rewrite the Atlas client-journey page from the model; stamp it when it changed
bun run atlas --check                     # exit 1 if atlas would change the page
bun run reality [<model dir>] [--out <dir>]   # level 3: a fictional client runs the model; exit 0 or 1 naming the step
bun run envelope <Envelope folder>        # read-only: which artifacts the model declares exist in a real Envelope
bun test                                  # all tests
bun run typecheck                         # TypeScript type check (tsc --noEmit)
bun run schema                            # regenerate schema/*.json after changing src/model.ts
bun run schema --check                    # exit 1 if the committed schema is stale (a test does the same)
```

CI and the suite's `workflow-model` case run `bun run check`, then
`bun run render --check` and `bun run atlas --check`: after any change to the
YAML, run `bun run render` and `bun run atlas` and commit the READMEs and the
`.atlas/` changes with it. The suite's `workflow-model-reality` cases
run `bun run reality` (Typst and the suite's Python packages needed).

A problem prints as `file:line: path: reason [rule]`, for example
`docs/workflow/07-after/stage.yaml:38: steps[2]: after.keep-request is never reached: it has no inputs, and no gate branch or loop escalation leads to it [unreachable]`.

For VS Code to underline mistakes while typing, install the Red Hat YAML
extension and start each file with the hint pointing at its schema,
relative to the file:

```yaml
# yaml-language-server: $schema=../../../tools/workflow/schema/stage.schema.json
```

## What `check` proves

The check reads `catalog.yaml` and every `NN-<stage>/stage.yaml`. A shape
problem stops it there; otherwise every rule runs and every problem is listed.
The `python` it calls for `--help` is `$PYTHON` when set (the suite sets its
own interpreter), else `python` on the PATH.

Level 1, shape and references:

| Rule | Refuses |
|---|---|
| `shape` | a missing `catalog.yaml` or `stage.yaml`, broken YAML, a file that does not match its type |
| `stage-folder` | a stage whose folder is not `NN-<stage id>` |
| `duplicate-id` | an ID defined twice anywhere in the model |
| `step-prefix` | a step whose ID does not start with its stage's ID |
| `unresolved` | a reference (actor, action, input, output, gate, pass, fail, escalate, schema) that names nothing |
| `scope` | an artifact or action defined in one stage and used in another: shared ones belong in `catalog.yaml` |
| `unused` | an actor, action or artifact nothing uses |
| `gate-step` | a gate no step checks, or that more than one step checks |
| `gate-branches` | a gate whose pass and fail are the same step |
| `source` | an anchor whose file does not exist, or whose lines run past its end (or a range on a folder) |
| `given-path` | a `given: true` artifact whose repository path (one without `<placeholders>`) does not exist |
| `skill` | a `skill` action with no `.claude/skills/<name>/SKILL.md` |
| `agent` | an `agent` action with no `.claude/agents/<name>.md` that is not a built-in (`general-purpose`) |
| `command` | a `cmd` action whose `python <script>.py <subcommand>` names a script outside `scripts/` or with a `..` segment (never run), a missing script, a subcommand its `--help` does not list (`cv.py`, `outputs.py`), or a subcommand on a script whose `--help` lists none |

Level 2, flow. Edges are derived: a step that reads an artifact follows every
step that writes it (inputs are AND, producers are OR), and a gate's step is
followed by its pass and its fail step.

| Rule | Refuses |
|---|---|
| `given-produced` | a `given: true` artifact that a step produces |
| `unproduced` | an input no step produces that is not `given: true` |
| `unreachable` | a step never reached: starting from the given artifacts, a step runs once all its inputs exist, and a gate's step leads to both branches and, through a loop on that gate, to its escalation step |
| `cycle` | a cycle left after each declared loop removes the edges from its gate's step to its fail step |
| `loop-open` | a declared loop whose gate's fail branch never leads back to the gate's step |
| `dead-end` | a step that produces nothing and checks no gate, unless it is a loop's escalation step, a gate's branch (an owner's decision such as `intake.no-consent`) or optional (`when`) |

What it accepts on purpose, from the modelling notes of TASK-37:

- **Escalation steps** (`<stage>.cap-reached`) have no inputs: a loop's
  `escalate` reaches them. Any other step needs an input that gets it there,
  or a gate branch.
- **One file rewritten in place** (`typst/cv.typ` and `candidate.json`,
  written in design and fixed by `design.fix` and `deliver.fix`) joins the
  design and deliver loops into one 16-step cycle; the five declared loops on
  it break every turn of it, so it passes. A rewrite outside a loop needs its
  own artifact ID per version (`art.facts-md`, then `art.facts-final`).
- **Optional producers**: an input counts as produced when any step writes
  it, `when` or not. Whether a step's `when` branches cover every case (the
  three build paths all write `art.cv-typ`) is not something the check can
  read, and stays unchecked: level 3 runs one path (`happyPath`), so each
  build path would need a scenario of its own.
- **Order without data** (`design.clear-review-input` before `deliver.render`)
  follows from gates only and is not checked here; level 3 shows it
  (`docs/workflow/GAPS.md`).

**Placeholder caps** do not fail the check: a loop whose name says
"(placeholder cap)" is listed in a `NOTE` line on every run, so the caps
still waiting for an owner's number (`docs/workflow/GAPS.md`) stay visible
without blocking CI.

## What `render` writes

`render` runs the check first and renders nothing from a model that fails
it. It writes named blocks between markers, each alone on its line:

```markdown
<!-- generated:start steps -->
...written by render; edit the YAML, not this...
<!-- generated:end steps -->
```

| README | Blocks |
|---|---|
| `docs/workflow/README.md` | `stages` (a table: steps, gates, loops, which stages each reads from and hands to), `journey` (Mermaid: the stages, an arrow where one hands an artifact or a gate branch to another, dotted where it goes back), `handovers` (each such pair with its artifacts and branches), `actors` |
| `docs/workflow/NN-<stage>/README.md` | `summary` (purpose, entry, exit, neighbours), `diagram` (Mermaid: steps as boxes, gates as diamonds with their pass and fail, loops dotted with their cap, a step of another stage as a rounded box), `steps`, `gates`, `loops` (placeholder caps marked), `artifacts` (the ones the stage reads or writes, with who makes them), `actions` |

Everything outside the markers is hand-written and never touched. A README
that does not exist is created with a heading and every block; a block
missing from a README is added at its end; a block may be moved anywhere and
stays there. A marker quoted inside a code fence is text. A malformed,
unknown, repeated, nested or unclosed marker, or a code fence never closed, stops
`render` with the file and line, and nothing is written. The output is the
same on every run: model order or sorted, LF, no dates.

Diagrams leave out an arrow that a longer path already implies, unless that
path runs through an optional step (one with `when`) whose condition differs
from the arrow's source; the tables list every input. The conditions are
compared as text, so two unrelated steps with the same generic `when` (such
as "The review returned FINDINGS.") would count as one branch; none do today.
GitHub draws a `mermaid` block in the browser, so a broken one
would only show as an error box there: `render` checks each diagram it
writes against the small subset in `src/mermaid.ts` (`flowchart TD` or `LR`,
quoted one-line labels with no HTML, model IDs mapped to safe node IDs such
as `s_design__run_brief`) and refuses anything outside it. The Mermaid
parser itself needs a browser DOM and some 140 packages, so it is not a
dependency; on 2026-10-14 Mermaid 11.4.1 parsed all eight diagrams.

## What `atlas` writes

The `Atlas` (`.atlas/`, opened from `.atlas/index.html`) shows the client
journey as a swimlane map and a walk-through. Its page
`.atlas/src/pages/client-journey.json` is generated from the model and never
edited by hand (its `generated` field and its summary say so); the kit
(`.atlas/_kit/atlas.py`) builds it like any other page. `atlas` runs the
check first and writes nothing from a model that fails it, or when a model
actor (`actor.x`) has no actor `x` in `.atlas/src/site.json`.

| Model | Atlas page |
|---|---|
| Stage | A phase, titled with the stage's name; its purpose is a line of "The short version" |
| Step | A step with the same ID, title and actor, in model order; a step with `when` is optional and says "Only when" |
| Action | The step's summary (`does`), or "Your move" on the owner's steps; a `cmd`'s command line, marked "You run" for the owner |
| Inputs, outputs | "Takes" and "Produces": each artifact's name and path |
| Gate | On its step: the check, a pass and a fail branch, and the cap of its loops |
| Loop | Drawn on the step that goes back: the gate's own step when its fail step is earlier, else the fail step, back to the nearest step it feeds at or before the gate's step |
| Derived edges | Arrows to later steps on the main line, minus gate branches and any arrow a longer path implies; an optional step sits beside the line, as the kit draws it |
| Skill, agent, script | "Uses": the site actor whose `file` is the skill's `SKILL.md`, the agent's file, a script in the command line or an input's path |
| Sources | The model step's own anchors, so the kit's `check` tracks the files the facts come from |

Staleness and stamps: the kit's `atlas.lock.json` holds the hash of every
file a page cites as of its last stamp, and `atlas.py check` lists a page
whose cited files changed since. When `bun run atlas` writes a changed page,
it first asks the kit whether any file the page cited has changed since its
last stamp:

- none has: it stamps the page (`atlas.py stamp client-journey`, which also
  builds), because its facts come from a model that has just passed `check`;
  no one stamps it by hand after a model change;
- one has: it writes and builds the page but does not stamp it, prints the
  changed files and exits 1. `check` proves only that a cited line exists,
  not that it still says what the model says, so a model edit must not
  clear that warning. Check the model's anchors against those files
  (`bun run anchors <commit>`, fix the YAML, `bun run render`,
  `bun run atlas`), then stamp by hand:
  `python .atlas/_kit/atlas.py stamp client-journey`.

The same manual stamp, after the same anchor check, clears a page the kit
reports stale while the page itself has not changed. Only the real page is
stamped: `bun run atlas <file>` writes a copy elsewhere and leaves the
`Atlas` alone (the tests use it).

The page is the same on every run (model order, two-space JSON, LF, no
dates); `atlas.data.js`, which the kit writes on each build, carries the
build time and is not checked.

## Level 3: the model run for real (`reality`, `envelope`)

`bun run reality` first runs `check` (a model that fails levels 1 and 2 is
not run), then walks one path through the model, the `happyPath` scenario in
`src/reality.ts`: a fictional marine engineer who consents, gets no `Deep
Dive`, signs off the first `Text Draft`, fits the Flagship `Template` and
passes every review. It writes into a new folder (default
`builds/workflow-reality-<time>/`; `--out` must be inside the repository,
since Typst compiles from its root, and it refuses a folder that exists) holding `repo/`, the run's copy of the repository
layout where `private/client-2030-01-01/` is the temporary `Envelope`,
`reality.log` (every command, its output and each decision) and
`report.json`.

- **Order.** A step runs once every input it reads exists (the level-2 reach
  rule), in waves, each wave in model order. A gate's branch waits for its
  gate, except a loop's way back, which is first reached by what it reads.
  Optional steps run only when the scenario names them; escalation steps
  never run; no loop turns.
- **`cmd` steps run their real command line**: placeholders filled (the
  `<revision>` from what `render` wrote, the reviewed hash from the PDF),
  `[--...]` options dropped, paths under `private/` and `builds/` moved into
  `repo/`. Two adjustments, each in the log: `cv.py approve` gets
  `--test-only` (the owner's approval is a stand-in; cv.py refuses it under
  `private/`), and `outputs.py stamp` gets `--root <run>/repo`, so it finds
  the `Envelope`'s home there. It also makes the folder `deliver.page-png`
  saves into, as the lead does (`docs/workflow/GAPS.md`).
- **Every other step is a labelled stand-in** (`stand-in (manual)`, `(lead)`,
  `(agent)`, `(skill)`) that writes the outputs the step declares:
  fictional content, or for the files later commands read, what the lead
  would write (`envelope.json`, `candidate.json` from the engineer example
  with a client's footer and none of the example wording, the Flagship
  entry point, the `Text Draft` from `tests/fixtures/text-draft.typ`, the
  `Sign-off` screenshot). What a step declares in the repository outside
  `private/` (the client's task, research notes) lands in `repo/`, never in
  the repository.
- **Checks.** Before a step, every input it declares with a path must exist;
  after it, every output must exist at its declared path, JSON must parse,
  JSON with a `schema` must match it, and a PDF must have the `Meta File` the
  model declares beside it, valid and current (its `sha256` is the PDF's).
  An output a command finds already there (a `Meta File` it restamps) must
  come out changed: one left byte for byte as it was fails the step.
  The first problem stops the run: `FAIL <step id>: <reason>`, then `FAILED
  level 3 at <step id>`, exit 1. A gate that sends the run off its path
  (example wording found, say) fails the same way.

`bun run envelope <Envelope folder>` does the read-only half on a real
client: for every step that declares an artifact in the `Envelope`, how many
of them exist, and which are missing, by model path. It writes nothing,
opens only `envelope.json` (for the `Alias`; it also lists folders to match
the model's paths, and prints none of their names) and prints the `Alias`, model
paths and counts, never a file name inside the `Envelope` or its content. A
file several artifacts share (`README.md` and its sections) counts as
present for each; a `NOTE` line lists them. On a real client run
`bun src/cli.ts envelope <folder>` instead: `bun run` echoes its
arguments, the folder name included.

## Keeping anchors honest: `anchors`

`check` proves an anchor's lines exist, not that they are still the lines
the fact was written from: a line added above them shifts every anchor below.
`bun run anchors <commit>` compares each cited file with `<commit>` (the last
commit at which the anchors were known good, for example the merge base of
a branch that edited cited files) through `git diff`. Only anchors already in
the model at `<commit>` are judged; one written since cites the file as it is
now. Give it the commit the anchors were last checked at: an older one can
shift an anchor a second time when its new value matches another anchor's
value at that commit.

- `MOVED a:4-5 -> a:6-7`: the lines only shifted; `--fix` rewrites the anchor
  in the YAML.
- `EDITED a:8`: a cited line was changed or deleted, or a line was inserted
  inside the range; a person rereads it against the fact and re-anchors by
  hand.

It exits 0 when nothing moved or changed, 1 otherwise (after `--fix`, 1 only
for what is still `EDITED`), 2 when `<commit>` is not a commit. Run it after a
merge that edits a cited file; it is not in CI because it needs that commit.

## Reading the inventory

The inventory (`docs/workflow/inventory/`) predates the types. Its artifact
visibility `external` (Google, the chat app) is `visibility: third-party`
here, and a chat message is `third-party` too, since it lives in the chat
app; `ephemeral` is only for what is saved nowhere. `given: true` is a
separate question: set it only when no step produces the artifact (a repo
file, the client's first message). A Google Form is `third-party` but not
`given`, because `intake.form-create` makes it.

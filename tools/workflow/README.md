# tools/workflow: the workflow tool

The TypeScript program, on Bun, that holds the `Workflow Model`'s types and
checks its YAML facts (ADR 0015): the shape of each file, and the whole model
in `docs/workflow/` at levels 1 (shape and references) and 2 (flow) of the
approved design (`docs/proposals/workflow-model.md`). Rendering comes with
TASK-39.

| Path | What it holds |
|---|---|
| `src/model.ts` | The Zod types: Stage, Step, Artifact, Action, Actor, Gate, Loop, Catalog. The one source of the contract |
| `src/load.ts` | Reads a YAML file, checks it against the types, reports file, line, path and reason |
| `src/check.ts` | The model check: every rule below, over the catalog and every stage |
| `src/anchors.ts` | Source anchors whose cited lines moved or changed since a commit |
| `src/schema.ts` | Exports the JSON Schema files from the types |
| `src/cli.ts` | The command line |
| `schema/` | The exported JSON Schema files, committed, never hand-edited |
| `sample/stage.yaml` | A short sample stage, used by the tests; illustrative, not facts |
| `test/fixtures/` | `valid/`, a small model that passes, and one broken model per rule, named after it |
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
bun test                                  # all tests
bun run typecheck                         # TypeScript type check (tsc --noEmit)
bun run schema                            # regenerate schema/*.json after changing src/model.ts
bun run schema --check                    # exit 1 if the committed schema is stale (a test does the same)
```

CI runs `bun install --frozen-lockfile`, `bun test`, `bun run typecheck` and
`bun run check` on both runners (`.github/workflows/verify.yml`), and
`python tests/run.py` runs `bun run check` as its `workflow-model` case.

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
| `command` | a `cmd` action whose `python <script>.py <subcommand>` names a missing script, or a subcommand its `--help` does not list (`cv.py`, `outputs.py`) |

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
  read; level 3 (TASK-42) runs it.
- **Order without data** (`design.clear-review-input` before `deliver.render`)
  follows from gates only and is not checked.

**Placeholder caps** do not fail the check: a loop whose name says
"(placeholder cap)" is listed in a `NOTE` line on every run, so the caps
still waiting for an owner's number (`docs/workflow/GAPS.md`) stay visible
without blocking CI.

## Keeping anchors honest: `anchors`

`check` proves an anchor's lines exist, not that they are still the lines
the fact was written from: a line added above them shifts every anchor below.
`bun run anchors <commit>` compares each cited file with `<commit>` (the last
commit at which the anchors were known good, for example the merge base of
a branch that edited cited files) through `git diff`. Only anchors already in the model at `<commit>` are judged; one written since cites the file as it is now.

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

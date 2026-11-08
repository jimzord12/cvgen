**Context review, round 3 (confirmation): TASK-83 portrait preparation** (worktree `C:\Github\cvgen\.worktrees\portrait-prep`, 0c23428..2a8300b)

**Verdict: PASS.** No Blocking or Material findings. There is one new Minor and three Notes.

**Round 2 items**
- **Minor 1 (concepts README): fixed.** `studio/design-concepts/README.md:21-28` now says "folders before 2026-09-29", which matches "Since 2026-09-29" at line 8. The paragraph is rewrapped with no ragged line. The cited range 13-15 for `art.concept-brief` changed only because `portrait.jpg` became `portrait.png`, and the fact it supports still holds.
- **Note 1 (`--keep-background`): handled.** The help text (`scripts/portrait.py:3-14`, the argparse help at about line 45) and the guide (`docs/guides/client-workflow.md:88`) say the same thing: for checking a crop only, never for a CV.
- **Note 2 (six restatements): unchanged and accepted.** Nothing in this delta adds a seventh copy.

**Checks on this delta**
- **Exit 3 is consistent everywhere.** It appears in:
  - the guide (`client-workflow.md:86`)
  - the new-cv skill (`.claude/skills/new-cv/SKILL.md:30`)
  - the action description (`docs/workflow/05-design/stage.yaml:579-582`, the README at line 349 and the Atlas client-journey)
  - verification check 21 (`docs/engine/verification.md:285` onward)
  - the code: `scripts/portrait.py` returns 3, and its `Parser` sends usage errors to exit 1.

  No exit 2 is left anywhere for the portrait tool. The remaining exit-2 lines belong to `scripts/cv.py` and the workflow tool, which have their own codes.
- **Check 21 matches `tests/portrait.py`.** Each claim has a test:
  - linear and grey profiles are converted (lines 123-143)
  - a broken profile is refused by name (144-146)
  - exit 3 with `CHECK FAILED` (193)
  - `check_result` on real detections (200-203)
  - a `--face-y` that is not a number exits 1 (206)
  - no `.partial` file is left (207)
- **Workflow Model and Atlas after the merge are clean.**
  - `bun run check`, `render --check` and `atlas --check` all pass.
  - `python .atlas/_kit/atlas.py check` reports all five pages ok.
  - `anchors` against either merge parent flags only expected shifts: main's new-cv line numbers versus the branch's, and the deliberate studio edit. HEAD's anchors match the branch's numbering, and `client-workflow.md:69-94` still covers the portrait section exactly.
- **Hygiene.** Every file the delta touches has LF endings. No client identity appears, and no new glossary term is needed.

**TASK-83 record** (`backlog/tasks/task-83 - portrait-prep-...md`)
The record has the shape `docs/development.md:199-215` asks for:
- header (Owner, Branch/worktree, Integration target, Depends on)
- Outcome and boundaries, quoting the owner
- three acceptance criteria describing behaviour
- milestone `m-8` (it exists)
- `## Result and evidence` with the exact head, commands, exit results and evidence paths
- `## Review` with every round and its dispositions

`Review` is a valid status (`backlog/config.yml`), and `updated_date` 15:44Z matches the commit time (17:45 +0200).

**Minor**

1. `docs/guides/client-workflow.md:85-86`: "...which it never enlarges; the source is never changed (exit 1, nothing written)." The bracket sits on the last clause, so a reader can take exit 1 to mean "the source is never changed" instead of "refused". Smallest fix: put the bracket on the refusal, for example "It refuses (exit 1, nothing written) a photograph with no face or several, ...", and leave "the source is never changed" as its own clause.

**Notes**

- `.claude/skills/new-cv/SKILL.md:29-31`: adding the exit-3 bracket left line 31 holding only `` `portrait.png` ``. Rewrap lines 29-32.
- **TASK-83 record:**
  - The acceptance criteria are still unticked, which is fine at `Review`. Tick them with `--check-ac` before the task moves to `Ready`, because `Ready` requires them to pass (`docs/development.md:49`).
  - Add this round to `## Review`.
- **Outside this delta:** `.claude/skills/new-cv/SKILL.md:25` still says "today only marine, the Flagship". The travel merge brought the Hanami `Template`, so that line is now stale. It came from main unchanged (bf8f0d7), so fix it on main or in the travel follow-up, not here.

Verdict: PASS

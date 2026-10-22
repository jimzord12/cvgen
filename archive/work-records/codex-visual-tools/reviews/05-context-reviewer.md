## Context review round 4, TASK-4 (codex-visual-tools): db191f6 (fixes ec5ceab..db191f6, whole change 38da34d..db191f6)

**What I expected before opening the diff:** M1 can be settled by withdrawing the clause, provided four things hold:
- The rubric owner and its TOML are back to the base wording, byte for byte, with nothing new added.
- The `codex-visual-reviewer` no longer claims a Flagship-client variant. It should defer to whatever the lead briefs, so the two reviewers can never judge one snapshot by different variants.
- No restatement of the clause is left anywhere: the Atlas, the workflow YAML, skills or docs.
- No file is left driving agents to worse behaviour than at base.

**Round-3 dispositions, checked:**
- **M1:** resolved. The rubric section of `.claude/agents/design-reviewer.md` and `.codex/agents/design-reviewer.toml` matches 38da34d. Against base, the only remaining TASK-4 edits are the three-line Codex paragraph (`design-reviewer.md:18-20`) and the provenance line (criterion 7).
  - `codex-visual-reviewer.md:24-26` now defers to "one the design-reviewer's 'Rubric for a CV page' defines, as the lead briefs the design-reviewer". It keeps both reviewers on one variant and adds no rubric of its own.
  - `git grep` finds no leftover of the Flagship-as-concept wording outside `archive/`.
  - The Atlas anchors `47-143` and `72-143` fit the 166-line file: line 143 is the rubric's last line.
  - With the clause gone, a Flagship client is judged under the same unspecified reading as at base. That is no worse than before TASK-4, and sending the question to the owner is the right move: this is the owner's call, not something an agent should decide.
- **m1:** fixed in substance; the new line is long (see m1 below).
- **m2:** accepted as deliberate. Codex generates its images natively, so dropping "Codex" from its copy makes sense.
- **m3:** partly fixed (see m2 below).
- **N1:** moot now that the clause is gone.

**Hygiene:** every file changed this round is LF, has no BOM and ends with a newline. No client identity appears anywhere in the whole diff. No file outside the feedback's reach was touched this round.

### Minor

- **m1. The new evidence line is 131 characters.** `archive/work-records/codex-visual-tools/evidence/README.md:27`. Round 3's m1 fix was written as one unwrapped line, so the paragraph's wrap breaks in the middle. Rewrap it at 72 to 80 characters like its neighbours. (This is the task's own evidence file, written in this change, so editing it before the merge is fine.)
- **m2. Two long lines in the magazine-editor profile are this change's own.**
  - `.claude/agents/magazine-editor.md:213` is 105 characters. "Each generated image's record" was added in round 1 to a line that fit at base. The TOML mirror wraps the same sentence, so the two copies now differ in shape.
  - `:182` was 95 characters at base and is now 102, because the round-3 rewrap pushed "folder" onto it.

  The disposition's claim that this line "was long at 38da34d" is true but understates it: the rewrap made the line longer. Smallest fix: rewrap `:181-183` and `:212-214`.

### Notes

- **N1.** The Flagship-client question now lives only in `04-dispositions.md` and the hand-back. If the owner does not answer in this session, a backlog task, or a line in `docs/workflow/GAPS.md`, would keep it from being lost. Do not edit an earlier record to carry it.
- **N2.** `.codex/agents/design-reviewer.toml` does not carry the three-line paragraph at `design-reviewer.md:18-20` saying a second reviewer works beside it. `.codex/README.md:21-22` says the wrapper is Claude-only, so the omission reads as deliberate and no earlier round raised it. I mention it only so the choice is known.
- **N3.** The ChatGPT training-data setting is still a hand-back item for the owner.

Verdict: PASS

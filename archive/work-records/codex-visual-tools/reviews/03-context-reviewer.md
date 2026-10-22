## Context review round 2, TASK-4 (codex-visual-tools), snapshot 38da34d..f456863 (fixes 872ef3f..f456863)

**What I expected before opening the diff:** Codex is a second judge on CV pages only, meaning CV concept runs and client designs. Brand assets, non-CV Idea Runs and Flagship changes keep the design-reviewer alone. Both reviewers must pass, and an `UNAVAILABLE` from Codex falls back to the design-reviewer alone, recorded. The Codex flags and the image procedure live in one place. Client pages are deleted with the previews.

**Checking the round-1 dispositions:**
- **M1 (Workflow Model):** fixed. Step names, formats, `art.typst-sources`, `lead.fix-design`, `lead.clear-review-input`, the workflow README, and the `Envelope` layout in client-workflow all name both reviewers. The GAPS.md entry sits in "What the YAML leaves out" and gives the real reason (one actor per step).
- **M2 (magazine-editor.toml):** fixed. All four edits are mirrored.
- **M3 (where Codex joins):** fixed in the owners (`docs/review.md:30-34`, the idea-run skill, the profile description, the tech-stack row). Two restatements were missed; see m1 below.
- **m1 to m3, N1 and N4:** applied as the dispositions say.
- **The restore after the corrupted scripted edit:** `git diff 38da34d f456863` on `docs/review.md` and `docs/tech-stack.md` shows only the intended hunks. In review.md: the scope sentence and the Sonnet exception. In tech-stack.md: the "read this when" line, the stack row, and the "Codex CLI" section. Both files are LF with a final newline and no BOM.
- **Atlas source edits in round 2:** line re-anchors plus the three renamed titles and summaries. Nothing else.
- **Privacy:** the evidence files are fictional: the Flagship sample, a propeller image, and the owner's account named without any detail. No client identity appears anywhere in the diff. The JPEG's SHA-256 matches the README. All changed text files are LF.

### Minor

- **m1. Two restatements still use the old, wider scope.** `.claude/agents/design-reviewer.md:18` reads "In concept runs and client designs a `codex-visual-reviewer` judges…". `.atlas/src/site.json:273` (`calledBy`) reads "every design round of a concept run or a client design. Brand assets and Flagship changes keep the design-reviewer alone", which leaves out the non-CV Idea Run. The owners are right, so no agent would misroute because of this. But the design-reviewer on a logo run will expect a partner, and the Atlas tells the owner something narrower than review.md. Smallest fix: write "CV concept runs" in the profile line. In the Atlas, add ", a non-CV Idea Run" and re-stamp.
- **m2. Evidence README has no final newline.** `archive/work-records/codex-visual-tools/evidence/README.md` ends without one, the same slip as round-1 m1. The verbatim Codex captures beside it can stay byte-exact.
- **m3. Lines still over-long.** Lines introduced or reflowed by the change still run past the file's width:
  - `.claude/agents/codex-visual-reviewer.md:48`
  - `docs/workflow/05-design/README.md:37` and `:60`
  - `.claude/agents/magazine-editor.md:180` (made long by the round-2 reflow) and `:229`
  - `.codex/agents/magazine-editor.toml:45` and `:238`
  - `.claude/skills/idea-run/SKILL.md:83`

  Cosmetic; rewrap when next in the file.

### Notes

- **N1. The walk tested a variant that is now out of scope.** The recorded walk (`evidence/2026-10-22-review-prompt-01.md`, "Rubric variant: a Flagship change") used the variant that M3 removed: the profile's variants are now concept page, client CV built from a concept, or client CV on the Flagship. The walk still proves the command, the flags and the plumbing. One sentence in `evidence/README.md` would stop a reader from taking it as the in-scope path: the variant was removed after the walk, and the first in-scope use is the next CV run (N4).
- **N2. Gate checks leave out the fallback.** The gate checks at `docs/workflow/05-design/stage.yaml:293` and `:314`, and `docs/workflow/README.md:142`, say "both return PASS" without the `UNAVAILABLE` fallback. The hand-written "When to stop" (`05-design/README.md:58-60`) and both skills carry it, so the generated rows are accurate for the normal path only. Optional: add "(or the design-reviewer alone when Codex is `UNAVAILABLE`)".
- **N3. Proposal wording.** `docs/proposals/codex-visual-tools.md:129` (lead defaults) also says "concept runs" without "CV". It is a dated decision record and `docs/review.md` owns the rule, so leave it as it is.
- **N4. Still open with the owner.** The owner's ChatGPT training-data setting remains a hand-back item for him. It is correctly not something an agent can settle.

Verdict: PASS

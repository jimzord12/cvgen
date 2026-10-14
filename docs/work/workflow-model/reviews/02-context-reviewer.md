## Review round 2: context-reviewer, 2026-10-14

Snapshot: `7acccd8..dd20040` (23aef00, f422d37, dd20040) in `.worktrees/task-33`. Lead lenses: one wording of the `Three-Second Test` everywhere, `specialty` defined once; dated correction lines factual against history and Atlas ranges correct.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Checked and correct: "`Domain`, specialty and `Rank`" in the glossary (specialty defined once at docs/glossary.md:77, consistent with the `Role` and `Rank` rows), AGENTS.md:17, vision.md:48, design-reviewer.md, magazine-editor.md, the idea-run and new-cv skills, client-workflow.md:293 and the Atlas sources; design-core F1 reviewer naming consistent in review.md, development.md and AGENTS.md; hashes a66b448, 74a6f82, f78a181 verified; Atlas `check --strict` exit 0; re-pointed ranges docs/review.md:178-215 and docs/development.md:107-196 exact; all 25 changed files LF; no real client identity.

Material
- 1: the Codex mirrors still say "role" (`.codex/agents/design-reviewer.toml:111`, `:178`; `.codex/agents/magazine-editor.toml:60`, `:125`, `:228`); `.codex/README.md` says they preserve each source agent's brief, so a Codex design run would brief and judge on the ambiguity F2 removed. Fix: the same substitution in the two TOMLs.

Notes
- docs/work/idea-runs/2026-10-02-editor/run.md:11: `a66b448` merged `docs/idea-run-2026-10-02-editor-b`, which contained this branch; naming the merged ref lets a reader check it.
- docs/workflow/inventory/c-catalog-and-drift.md:25 still says "Domain/specialty/role": a dated snapshot, correctly left.
- magazine-editor.md:203 lowercase "domain, specialty and rank" matches its line; fine.

## Dispositions (lead)

- Material 1: fixed by the lead, the five lines now match their Claude sources (`Rank` / `rank`).
- Note 1: fixed, the line names `docs/idea-run-2026-10-02-editor-b` and merge `a66b448`. Notes 2 and 3: accepted.
- Round 3 follows on the delta.

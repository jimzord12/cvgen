## Review round 1 (context): context-reviewer, 2026-10-14

Snapshot: `git diff origin/main...HEAD` at 8628b0b, limited to docs and agent context. Lenses: 1 faithfulness; 2 placement.

Verdict: FINDINGS. Recorded in substance.

Material
- M1 three anchors shifted twice: `docs/workflow/06-deliver/stage.yaml` `deliver.page-png` and `art.page-png` cite `.claude/skills/verify-cv/SKILL.md:68-79`; `docs/workflow/catalog.yaml` `cmd.page-png` cites `:75-79`. 0654a73 (on main) had moved them 62-73 -> 65-76; 6f00e54 (against base d7da40d) added another +3, so 68-79 drops "## Visual evidence" and ends at "## Report", and 75-79 drops the snippet's `import`/`open` lines. `check` cannot catch it (the lines exist). Fix: restore 65-76 (twice) and 72-76; correct TASK-38 note (9), which credits 6f00e54 with the verify-cv drift. The other 12 re-anchors (GAPS.md) check out.

Minor
- m1 the four-command CI list appears in `tools/workflow/README.md`, `docs/engine/verification.md:21-24`, the `docs/tech-stack.md` CI row and `.atlas/src/site.json`; cut the README's to "CI and the suite's `workflow-model` case run `bun run check`".
- m2 `tools/workflow/README.md` "Keeping anchors honest": one overlong line.

Notes
- Faithfulness holds: 20 rules match `check.ts:26-49`, one fixture each (three for `command`); shape problem stops the check; NOTE, `$PYTHON`, argument forms match `cli.ts`; anchors exit codes; suite case, SKIPPED without Bun, CI failure via `CI` match `tests/run.py`.
- The two fact changes are recorded as inferences in GAPS.md:54-61 with sources that read right; artifacts moved to the catalog per `scope`.
- Placement fine (README owns the rules; verification.md case 16 points to it; AGENTS.md row one clause longer; glossary updated). `atlas check --strict` 0; site.json by hand OK. LF in blobs. `docs/history.md` entry due at close. No client named.

## Dispositions (lead)

- M1: fix (restore the main values; correct note 9). m1, m2: fix. history.md entry: at close.

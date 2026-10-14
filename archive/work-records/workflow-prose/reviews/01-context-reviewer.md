## Review round 1 (context): context-reviewer, 2026-10-14

Snapshot: `feature/task-40-workflow-prose` at 8a65c97, `origin/main...HEAD`. Lenses: 1 faithfulness and placement; 2 the reader.

Verdict: FINDINGS. Recorded in substance.

Checks: `bun run check` OK (6 placeholder caps listed); `render --check` 8 match; `atlas check --strict` exit 1 on the branch (0 on main 302123d); LF in 12 files; top README 251 lines; no client named.

Holds up: the 05-design model fix is correct (new-cv SKILL.md:43-53 writes the record before the `Idea Run`; client-workflow.md:44 lists `candidate.json` in every `Envelope`; build-a-cv.md:130-136 render refuses without it); 15 claims sampled match YAML, guides, skills and code (one batch per round, consent hard stop, LinkedIn, Google sign-in, test answer, `ready`/`sent`, `envelope()` refusing, Drive Trash, stall rule, roles, decisions #1-#7, P-0018 1a-7 as pending); no contracts restated; guide section pointers right; all five newcomer answers findable where cited.

Material
1. `docs/glossary.md:87` change makes `client-journey`, `design-run`, `system-map` STALE; `--strict` fails; AGENTS.md and `docs/development.md:87-89` require re-check, build, stamp in the same session.

Minor
2. `docs/workflow/06-deliver/README.md:60-63`, `docs/workflow/README.md:99-102` claim a second `design.preview`/`design.client-review` pass and a `design-reviewer` round after a render or wording fix; the model does not order that and no source asks for it. Fix: say only that `deliver.fix`'s files feed `design.preview` again in the model; note the re-review as an inference (GAPS.md or TASK-43 notes).
3. `docs/workflow/README.md:151` "wait, ask again or delete" vs `07-after/README.md:45` "wait or delete". One wording; cite P-0018 item 3 if "ask again" stays.
4. `docs/workflow/README.md:207-209` "follow the model" too broad (only docs/workflow says so; some TASK-43 items are undecided drift). Narrow to the owner's decisions in P-0017 winning over a guide that has not caught up.

Notes
5. `01-open/README.md:30` points to glossary rule 3; the id rule is in the `Domain` row (glossary.md:38).
6. `docs/workflow/README.md:181-186` "Inferences" list reads as complete; say "among them".

## Dispositions (lead)

- 1-4: fix. 5, 6: fix.

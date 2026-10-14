## Review round 1 (context): context-reviewer, 2026-10-14

Snapshot: e9a6acb, `git diff origin/main...HEAD` limited to docs and agent context and the generated READMEs. Lenses: 1 the generated READMEs as a reader sees them; 2 placement.

Verdict: PASS (no Blocking or Material). Recorded in substance.

Checked: `bun run check` (levels 1 and 2, 6 placeholder caps in its NOTE); `bun run render --check` ("8 generated READMEs match the model"); `atlas check --strict` 5 pages, site.json `github-ci` role matches `verify.yml`; 25 changed files LF; no client named; 12 items in 03 and 05 match their `stage.yaml` (gate targets, loop gates, caps, escalations, `when`); placeholder caps marked in tables and diagram edges with a `GAPS.md` link; render command and marker rule documented once (`tools/workflow/README.md`); `AGENTS.md:112` one clause; `verification.md:171-173` matches `tests/run.py:473-474`; `STALE` matches `cli.ts:87`; history entry accurate; top README 77 generated lines, leaving 120-220 for TASK-40.

Minor
1. `docs/workflow/05-design/README.md:53-111` diagram crowded (33 nodes, 59 edges): every Idea Run step has a `when`, so the optional-step exemption keeps nearly every redundant arrow (`run_draw -> pick`, `run_draw -> record_choice`, four arrows from `run_revise_design`). Fix: treat an intermediate step as transparent when its `when` equals the source step's `when` (`render.ts`).
2. `tools/workflow/README.md:142` leaves `nested` out of the marker failure list (`render.ts:42` has it).

Notes
- The generated `summary` already prints the stage's Purpose; TASK-40 should write judgement and branches, not a second purpose line.
- 05: `design.fill-data` is entered only from `gate.template-exists` pass; on the no-Template path `port-concept` reads `art.candidate-json` but no arrow leads into `fill-data`; faithful to the YAML, a model or prose question.
- `verification.md:205-208` troubleshooting covers only `STALE`; a malformed marker or an unrendered `render.ts` change deserve a clause.
- Task note (8) says 84 generated lines; the file has 77.

## Dispositions (lead)

- Minor 1, 2: fix. Notes: Purpose and fill-data go into TASK-40's notes (fill-data also checked there against the guides); troubleshooting clause and note (8): fix.

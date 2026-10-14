## Review round 1 (context): context-reviewer, 2026-10-14

Snapshot: 9051736, `git diff origin/main...HEAD` limited to docs and agent context. Lenses: 1 faithfulness; 2 placement.

Verdict: FINDINGS. Recorded in substance (Alias only).

Clean: level 3 matches the handoff's "Verification levels" table and ADR 0015:66; stand-ins described as labelled; verification.md case matches `run_reality`; only the Alias `client-2026-09-03` appears; `atlas check --strict` ok, site.json row accurate; `bun run check` passes; LF.

Material
1. `tools/workflow/README.md:109-112` still says level 3 (TASK-42) runs the `when`-branch coverage; it runs one scenario (`happyPath`), so branch coverage is not proven. Fix: say it stays unchecked; each build path would need its own scenario.
2. `docs/workflow/GAPS.md:63-78`: a new section above "What the YAML leaves out", which owns such items; the page-png bullet is an unsourced inference; the export half repeats `verification.md:186-188`; its `design.preview` example differs from README:113's `design.clear-review-input` for the same gap. Fix: move both bullets into "What the YAML leaves out" with sources and "Added by TASK-42", drop the export sentence, one example pair in both files.

Minor
3. `--root` is in neither `docs/pdf-workflow.md:137-143` nor `AGENTS.md:134`, with no reason; AGENTS.md right to omit; add one clause to pdf-workflow.md.
4. The read-only promise (`README.md:164-169`, task decision 9) says it opens only `envelope.json`; `reality.ts`'s glob also lists folders (`readdirSync`), never printed; say so.
5. `docs/history.md:326-327` "an `Envelope` outside `private/`": it sits in `<run>/repo/private/`; say "outside the repository's `private/`". `README.md:131` omits that `--out` must be inside the repository (`reality.ts:210-212`).
6. `AGENTS.md:113` two parenthesised clauses where one would do.

Notes
- `verification.md:220` names only the happy run's failure label; the broken copies fail as `('renamed-output', ...)` and `('export-before-approval', ...)`.
- `README.md:160-161` glossary terms without backticks.
- "Render runs before the design review returns" is an open model question rather than a gap explanation; GAPS.md tracks nothing; put it in a task's notes or P-0018.

## Dispositions (lead)

- 1, 2, 3, 4, 5, 6: fix. Notes: fix the first two; the render-order question goes into TASK-43's notes (TASK-38 is closed).

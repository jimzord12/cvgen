## Review round 1: code-reviewer, 2026-10-14

Snapshot: worktree `.worktrees/task-56`, branch `refactor/task-56-legacy-removal`, head 6120815; task diff 5c61091..6120815 (work 62c373e, record-keeping 6120815). Lead lenses: correctness of the migration and mapping table; docs and contract consistency.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: no public import of the 32 flat names outside the legacy layer (M/lib.typ re-exports; legacy-parity.typ imports lib.typ as L; no `*` imports). All 32 table rows checked against both legacy.typ wrappers and the ctx-first components: core defaults match (label color none, rule 0.5pt, decoration auto/auto/true, metric gap 3mm); Flagship defaults match (skills-section title, skills geometry fallback, contact-group alignment, company-experience continued false, section-heading subtitle none); wrapper-only values come from the right ctx slices (copy.combined, copy.certificate-columns, options.show-vessel-durations). Frozen v11 reference passes. skills.typ before/after compiled by the reviewer: pixel-identical.

Findings
- m1 Minor: AGENTS.md:82, 89, 238, docs/reference/domains-and-roles.md:145, docs/architecture.md:80 state "removed 2026-10-31" as fact; TASK-58 needs re-pointing of two private cv.typ first. Fix: "removal planned 2026-10-31 (TASK-58)".
- m2 Minor: packages/cv-framework/lib.typ:10-12 and packages/domains/marine/lib.typ:16 say only "Deprecated"; add the same date and pointer as the legacy.typ headers.
- n1 Note: tests/fixtures/skills.typ was the only caller of legacy `skills-section` without `geometry:`; legacy-parity.typ always passes it, so the wrapper default (F/legacy.typ:21-26) is now untested. Add one default-geometry call pair if it matters.
- n2 Note: TASK-58 lists only TASK-56 as dependency; add TASK-32 per the lead's settled note.

Checks rerun: suite exit 0, 94 cases, repo-maintenance 25/25 (builds/tests-20261014-083704-725428); outputs check 19 PDFs 0 problems; skills.typ before/after 1 page 2481x3508, 0 differing bytes, identical text (builds/review-task-56-r1-skills/); diff --check clean; LF.

Limitations: private compositions unreadable (counts rest on the author's grep); table text not mechanically tied to the fixture; author's evidence folders and Atlas check not inspected.

## Dispositions (lead)

- m1, m2, n1, n2: fix now. A context-reviewer round follows for the doc changes (docs/review.md).

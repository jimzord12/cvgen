## Review round 2: context-reviewer, 2026-10-14

Snapshot: worktree `.worktrees/task-56`, head be6af79; whole diff 298fc49..be6af79, focus on 5ca7401 and be6af79. Round-1 m1, m2, n1, n2 fixed as dispositioned.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Material
- M1. The date is copied into about 15 places (AGENTS.md:82, 89, 238; docs/architecture.md:80; docs/conventions.md:47; docs/guides/build-a-cv.md:254, 287; docs/reference/domains-and-roles.md:145; docs/reference/skills-component.md:36; docs/framework-gaps.md:49, 66; both lib.typ comments; both legacy.typ headers line 5; TASK-58 title and filename). TASK-58 says re-plan the date if TASK-32 has not landed, which would make every copy false at once. Four still state it as fact: framework-gaps.md:49 Status "removal date 2026-10-31", core/legacy.typ:5 and flagship/legacy.typ:5 "Removal date 2026-10-31", TASK-58 title "remove … on 2026-10-31". The Status edit also dropped the date-independent precondition ("remove when no custom composition imports them"). Fix: keep the date only in TASK-58 (due_date, description) and the framework-gaps Update line; elsewhere "removal planned (TASK-58)" plus the table pointer; Status "open, removal planned in TASK-58 once TASK-32 re-points the private compositions"; retitle TASK-58 without the date.

Minor
- m1. docs/conventions.md:46 "No public file calls them any more" and docs/architecture.md:80-81 "the only callers left are two private compositions" forget the parity fixture named a line earlier. Fix: "Apart from the parity fixture, no public file calls them".
- m2. docs/framework-gaps.md: `Needed` (:52) says private compositions are never edited by an agent and `Lesson` (:60-61) waits for the owner's approval; the Update (:63-68) has TASK-32 re-point them without saying approval was given. Fix: add "re-pointing authorized by the owner inside TASK-32 (2026-10-14)".

Notes
- n1 verified: legacy-parity.typ compiled with api=legacy and api=contract, 5 pages each, pixel-identical at 2x; the default-geometry pair renders on page 4 in both; tests/run.py:253-262 compiles both APIs, requires 5 pages, compares pixels and /Artifact count.
- Atlas check all five pages ok in PowerShell (Git Bash python differs; not the change).
- Hygiene: 20 files LF, diff --check clean, no client identity, glossary unaffected. Placement right. TASK-56's older "needs the owner's go" paragraph is overtaken by its Review section; fine as history.

## Dispositions (lead)

- M1, m1, m2: sent to the author to fix.

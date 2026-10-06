---
id: TASK-25
title: >-
  component-contract: migrate Flagship modules to the ADR 0008 shape (roadmap
  item 4)
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/0fdjGNzw'
ordinal: 25000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# component-contract: migrate Flagship modules to the ADR 0008 shape

Owner: Claude Code, overnight 2026-09-25. Branch `refactor/component-contract` -> `main`. Roadmap item 4, opened by the owner 2026-09-25.

## Outcome
Every Flagship component follows `docs/conventions.md` (ADR 0008): `ctx` first, data, named props, slots. One module per commit; every commit renders the engineer example pixel-identical to the frozen v11 reference and the suite passes.

## Acceptance
- All Flagship modules migrated, or the remaining ones listed with the reason.
- AGENTS.md "No module is migrated yet" updated.
- Suite green at every commit; review PASS; merged; CI confirmed.
## Progress (2026-09-25, overnight)
- Branch `refactor/component-contract`, worktree `cvgen-wt-contract`. Base 422f150.
- Module commits (suite PASS after each; evidence in the worktree's builds/): ab54e26 primitives (tests-20260925-014256-833429), 140eb07 sections (-014453-150302), e1d67a7 skills (-014540-654455), 2b1dc2a education (-014632-476393), 614bb4e certificates (-014717-333752), 40a19e7 experience (-014817-685185), 36d0d04 hero (-014919-438047), 3cfa7aa page shell (-015008-551325), b2334a6 template (-015046-722731), 3f0ccb9 fixtures (-015319-388625), d286219 docs (-015559-648361).
- Review round 1: FINDINGS (2 Material, 3 Minor, 2 Notes), fixed in 81c6057; report + disposition at docs/work/component-contract/reviews/01.md. Suite at 81c6057: PASS 41 cases, builds/tests-20260925-021731-898707.
- Private workspaces (read-only copies, both pages raster+text equal to reference.pdf): kept evidence builds/private-evidence-20260925-021806 (script, verify result.json per workspace, reference SHA-256, HEAD 81c6057).
- Review round 2: FINDINGS (1 Material, 2 Minor, 1 Note), fixed in f232f57; report + disposition at docs/work/component-contract/reviews/02.md. Suite at f232f57: PASS 41, builds/tests-20260925-023805-600045. Mutations caught: builds/mutations-20260925-023721. Private evidence at f232f57: builds/private-evidence-20260925-024021 (both workspaces equal).
- Next: review round 3; after PASS merge main in, rerun, integrate.
## Merge checklist (review F10, 2026-09-25)
Order: docs-audit reaches main first (done: db03370), then merge origin/main into this branch.
1. build-a-cv.md section 8: keep the docs-audit `copy:` override (certificates-subtitle, brand) inside this branch's ctx-first snippet (make-ctx, core-components/flagship-components); recompile the snippet.
2. architecture.md: keep this branch's ctx text; drop docs-audit's "certificates and education get the whole layout" sentence.
3. layout-and-pagination.md: same as 2.
4. ADR 0008 Status line: keep both notes (paths amended by 0010/0011; applied 2026-09-25).
5. history.md: keep both entries, in date order.
6. domains-and-roles.md naming rule: delete the interim clause "until that lands on main, Flagship's components are only the flat names above"; conventions.md points to that rule.
Then: both doc snippets compile, link scan, suite, private evidence, push, final review round; the lead merges to main.
- Round 3: PASS (3 Minor, 1 Note) fixed in 290f8dd, f688eaf, 9e554b9; mutations on a git-archive copy: builds/mutations-r3d-20260925-030002 (6/6 caught).
- Integration prep: origin/main (db03370) merged into the branch as ce7741e, F10 checklist applied. Suite PASS 41: builds/tests-20260925-030154-274425. Private evidence at ce7741e: builds/private-evidence-20260925-030211 (both equal). Links + doc snippets: builds/final-checks-20260925-030147 (only broken link is retired docs/now.md into builds/, pre-existing, left for owner). Awaiting final review; lead merges to main.
## Result (2026-09-25)
Done. main merged into the branch again after candidate-validation (c66c0fb, README count 43); suite PASS 43 at c66c0fb and private evidence equal (builds/private-evidence-20260925-034213, worktree since removed). Review round 4 PASS (F12 vision item 4, F13 architecture header wording, fixed in accb15a; report docs/work/component-contract/reviews/04.md). Integrated at b264f1d; suite on main PASS 43 builds/tests-20260925-035547-202757; CI verify run 36079788642 success. All modules migrated; old signatures kept as deprecated wrappers (framework-gaps.md). Branch and worktree deleted.
<!-- SECTION:DESCRIPTION:END -->

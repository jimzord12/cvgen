---
id: TASK-16
title: 'framework-split: the Framework knows no Domain, in folders and in imports'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/oSLK5U4I'
ordinal: 16000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# framework-split: the Framework knows no Domain, in folders and in imports

Owner: Claude Code (lead session 2026-09-25)
Branch/worktree: refactor/framework-split
Integration target: main
Depends on: client-workflow (merge order, shared docs)

## Outcome and boundaries
The shared Typst core becomes its own package that imports no Domain, and each Domain lives beside it as its own package: packages/cv-framework/ and packages/domains/marine/ (owner, 2026-09-25, decision 8). Importing the Framework no longer brings Marine or Flagship with it. Needs an ADR; the frozen v11 reference must stay pixel-identical. The owner OKs editing the import lines of the two private compositions (2026-09-25).
Excludes: new Domains, behaviour changes, removal of legacy wrappers.

## Acceptance
- [x] ADR recording the split and its compatibility cost.
- [x] packages/cv-framework (core, fonts, licences) imports nothing under domains; marine has its own entry point with Flagship and its legacy wrappers.
- [x] Examples, tests, scripts, cv-workflow, CI and docs point to the new paths.
- [x] python tests/run.py PASS, engineer example pixel-identical to v11.
- [x] Both private CVs render pixel-identical to their reference.pdf after their import lines are updated.
- [x] Independent review PASS; merged; CI green.

## Result and evidence
Merged to main in 679912d (https://github.com/jimzord12/cvgen/commit/679912d); CI green (run 36128484592). ADR 0012. packages/cv-framework (core only) + packages/domains/marine (own lib.typ). Suite PASS 44, engineer example pixel-identical to v11. Both private compositions: engine paths rewritten at merge (owner's OK), then compared: pixel-identical to their reference.pdf at 144 dpi (builds/private-verify-20260925-141552). A Framework-only one-off loads no domain file (typst --deps) and render checks no schema (reviewer's probe through cv.py render).

## Review
docs/work/framework-split/reviews/01.md PASS (minors fixed), 02.md PASS (minors applied as the reviewer worded them). R2-N3 (a Framework-only render case in tests/workflow.py) moved to card revision-snapshot.

## Handoff
Done. Owner action: the worktree ../cvgen-framework-split holds builds/private-check-* copies of real client data; deleting them was refused by the harness permissions. Owner removes it: git worktree remove --force ../cvgen-framework-split, then git branch -D refactor/framework-split and git push origin --delete refactor/framework-split.
<!-- SECTION:DESCRIPTION:END -->

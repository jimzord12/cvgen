---
id: TASK-19
title: >-
  domains-move: move Flagship and schema under domains/marine, regenerate
  baseline
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/gO8jcpSK'
ordinal: 19000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# domains-move

Stage 1 of ADR 0011. Mechanical move of Flagship, its assets and the candidate schema under packages/cv-engine/domains/marine/, examples under examples/marine/flagship/, with every path rewritten and tests/baseline.json regenerated. No behaviour change.

## Outcome and boundaries
The tree matches the ADR 0011 layout while every frozen byte is unchanged and the engineer example is pixel-identical to Marine-Engineer-CV-v11.pdf. examples/candidates/ does not move (frozen JSONs pin the portrait path). Excludes the core split (domains-core-split) and private workspaces.

## Acceptance
- [ ] `git mv` only for frozen files; `git diff --stat -M main...HEAD` shows 100% renames for the reference PDF and the 17 SVGs.
- [ ] tests/baseline.json regenerated: 31 keys, values identical to the pre-move manifest (`git show archive/pre-domains:tests/baseline.json`).
- [ ] Zero hits: `git grep -nE "cv-engine/templates/|cv-engine/schema|E/templates/|E/schema|examples/flagship" -- . ":!docs/history.md" ":!docs/work" ":!docs/decisions"`.
- [ ] `python tests/run.py` PASS with exact/result.json raster_equal and text_equal true on both pages; `./scripts/build.ps1` produces the four PDFs.
- [ ] Code-reviewer rounds (lenses 3 integrity, 8 repository) until PASS; reports under docs/work/domains-move/reviews/.
- [ ] Tag archive/pre-domains on main before the move, pushed.

## Plan
Branch refactor/domains-move. Rewrite sites: root-absolute asset prefix in artwork/engineer.typ, artwork/captain.typ, tests/fixtures/skills.typ; template prefix in lib.typ, the 8 fixtures, tests/workflow.py ENTRY, tests/run.py, tests/verify.py, scripts/build.ps1, typst.toml exclude, both schemas' $id/description; relative depth inside the moved template and the examples; explicit non-grep sites core/data.typ:46 comment, typst.toml exclude, candidate.schema.json:5; path-only docs (AGENTS.md, constitution 1/3, architecture, conventions, reference/*, guides/build-a-cv, pdf-workflow, README, archive/design-studies/README, skills new-cv/new-theme/verify-cv).

## Result and evidence
Merged to main as 195fbab (branch refactor/domains-move, 2 commits). 18 binary renames at 100% (17 SVG + v11 PDF); baseline 31 keys re-keyed, values identical to archive/pre-domains; zero-hit grep clean. Suite PASS at 10fd66d: builds/tests-20260921-015810-230169 (35 cases, exact reference equal); four PDFs in builds/library-20260921-015831-016.

## Review
Round 1 PASS (lenses 3, 8): https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/work/domains-move/reviews/01.md . Two Minor doc-path fixes landed before merge.

## Handoff
Done 2026-09-21. Private-workspace import lines (root-absolute) after the core split: /packages/cv-engine/lib.typ (flagship), /packages/cv-engine/domains/marine/roles/<deck|engine>/role.typ, /packages/cv-engine/domains/marine/templates/flagship/{themes,artwork,layouts}/... Next: domains-core-split.
<!-- SECTION:DESCRIPTION:END -->

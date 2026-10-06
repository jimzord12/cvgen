---
id: TASK-13
title: 'rename-cvgen: rename the project to CVgen (repo, package, README, board)'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/ZV2X4IKE'
ordinal: 13000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# rename-cvgen

Stage 3 of ADR 0011. The project becomes CVgen: GitHub repository, Typst package, README, AGENTS.md, skills, Trello board. Folder names packages/cv-engine and packages/cv-workflow stay; frozen reference and export file names stay.

## Outcome and boundaries
`gh repo view jimzord12/cvgen` resolves (old URL redirects); typst.toml name is `cvgen`; README and AGENTS.md open with the new name; the trello skill, recipes, AGENTS.md and development.md name the renamed board and `-Lists 'CVgen'` returns board IPsBxAwf. Excludes the local checkout folder name (owner's machine) and any engine behaviour.

## Acceptance
- [ ] `git remote -v` shows the cvgen URL; CI green on the renamed repository.
- [ ] `python tests/run.py` PASS after the rename commit.
- [ ] Board renamed immediately before merge, after the four files were edited on the branch; `-Lists 'CVgen'` returns IPsBxAwf.
- [ ] Code-reviewer round (lenses 8, 4) PASS; report under docs/work/rename-cvgen/reviews/.

## Plan
Branch chore/rename-cvgen. Owner approved the repo rename in conversation on 2026-09-21.

## Result and evidence
Merged to main as 422f150 (branch chore/rename-cvgen). Board renamed to CVgen (PUT boards/IPsBxAwf) right before merge; -Lists 'CVgen' returns board 6aaa8e2682dc1eb78abae810. gh repo rename cvgen done after merge; origin now https://github.com/jimzord12/cvgen.git (old URL redirects). CI green on 422f150. Suite PASS at 1cf346e: builds/tests-20260921-022946-845877.

## Review
Round 1 PASS, no findings: https://github.com/jimzord12/cvgen/blob/main/docs/work/rename-cvgen/reviews/01.md

## Handoff
Done 2026-09-21. Not done on purpose: the owner's local checkout folder is still named marine-engineer-cv (owner's call; renaming it moves Claude's project memory path).
<!-- SECTION:DESCRIPTION:END -->

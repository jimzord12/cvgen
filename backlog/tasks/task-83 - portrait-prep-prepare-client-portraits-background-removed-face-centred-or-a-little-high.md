---
id: TASK-83
title: >-
  portrait-prep: prepare client portraits - background removed, face centred or
  a little high
status: Active
assignee: []
created_date: '2026-11-08T15:36:00Z'
labels: []
milestone: m-8
dependencies: []
ordinal: 83000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session (lead)
Branch/worktree: feat/portrait-prep in .worktrees/portrait-prep
Integration target: main
Depends on: none

## Outcome and boundaries
Owner, 2026-11-08: "remove the background from the profile image ... make sure when you are using an image the face in the center of the shape or just a tiny bit higher if that way it looks better." scripts/portrait.py prepares a portrait for any template: one face found, a square crop with the face centred and a little high, the background removed, colours in sRGB, a sidecar as evidence. The rule reaches the design reviewer, the magazine-editor and the component contract. Excludes changing any existing Frozen Reference portrait.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 A prepared portrait has its face within 2% of the target and a transparent background (tests/portrait.py)
- [ ] #2 Every refusal is loud and writes nothing; a failed check after writing exits with its own code
- [ ] #3 Designers and reviewers carry the rule (design-reviewer, magazine-editor, conventions)
<!-- AC:END -->

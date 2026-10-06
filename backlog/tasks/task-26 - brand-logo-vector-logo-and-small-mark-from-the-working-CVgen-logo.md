---
id: TASK-26
title: 'brand-logo: vector logo and small mark from the working CVgen logo'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/CEdYJtcF'
ordinal: 26000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
**Goal.** Turn the working CVgen mark into files we can actually use.

**Where it stands (2026-09-25).** Working mark is v3: big black serif "CV", flat, on white, one thin copper thread that wraps the C and curves through the V, loose tail on the right. Image-model render, not a production file.
- File: https://github.com/jimzord12/cvgen/blob/main/brand/logos/CVgen_Logo.v3.jpg
- Notes and history (v1 3D mock-up, v2 dropped as a crossed-out CV): https://github.com/jimzord12/cvgen/blob/main/brand/README.md

**Brief the owner gave.** Originally "CV" nature-like and "gen" technology-like, blended; then dropped nature: a big CV with "gen" passing inside it. Unique, alternative, sophisticated.

**To do.**
1. Flat vector redraw (SVG), transparent background.
2. Full wordmark: "gen" set small at the thread's right-hand tail (as in v1).
3. Small-size variant with a thicker thread; at 32 px the current one disappears.
4. Record the ink and copper colour values in brand/README.md.
5. Optional: the thread as the signature element of premium-text-draft.

**Open point from Claude.** Copper + classic serif reads elegant/luxury, closer to "sophisticated" than "alternative artist". Revisit together with premium-text-draft so the two feel like one brand.
## Night Shift 2026-09-27: vector options delivered (owner to pick)
- Files on main: https://github.com/jimzord12/cvgen/tree/main/brand/logos (mark, wordmark with "gen", small mark, padded avatar, bold alternative, and reversed versions for dark backgrounds). Colours and fonts: https://github.com/jimzord12/cvgen/blob/main/brand/README.md
- Ink #131210, copper #B7713D (sampled from v3); reversed ink #F4EFE6, reversed copper #C07B45. Letters: Cormorant Garamond Bold outlines; "gen": Jost Light (both OFL).
- Small mark reads as CV with a visible copper thread at 32 px; at 16 px it is faint (32 px is the practical minimum).
- Design review round 1 PASS (Minor fixes applied): https://github.com/jimzord12/cvgen/blob/main/docs/work/brand-logo/reviews/01-design-reviewer.md
- Merge: https://github.com/jimzord12/cvgen/commit/e09e4db
- Waiting on the owner: which direction (Night Shift question Q3). Item 5 (the thread as the Text Draft's signature) is picked up by the "First Fitting" Text Draft direction.

## Handoff
Next action after the owner's pick: make the chosen file the working logo in brand/README.md and delete nothing (options stay as history); if he picks "custom letter detail", brief an agent for one signature cut on the C or V.
<!-- SECTION:DESCRIPTION:END -->

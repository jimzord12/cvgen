# Research review round 1: docs/work/idea-agents/research.md

Reviewer: research-reviewer brief, run as a general-purpose agent (the
agent file was new this session). Snapshot: 580c170.

Claims checked: 26 load-bearing, 23 confirmed, 3 unreachable directly (TDC
archive 403; Adobe helpx 403, confirmed via a search excerpt of the same
page; EUIPO 5.3.9 page did not render, search confirms typeface design
registration exists).

## Findings

### R1 Blocking: "A subagent cannot spawn further subagents unless `Agent(...)` is granted"
Source: https://code.claude.com/docs/en/sub-agents.md - Says: by default a
subagent can spawn subagents up to three layers below the main
conversation; `Agent(type)` in `tools` limits which types; spawning is
blocked only when an explicit `tools` list omits `Agent` or
`disallowedTools` names it. The design choice rested on a false premise.
Fix: state the default, that the idea agents omit `Agent` on purpose, and
the real reason the lead runs the loops.

### R2 Note: effort range
Values are `low`, `medium`, `high`, `xhigh`, `max`, model-dependent.

### R3 Note: OFL FAQ citation
Bundling with software is FAQ 1.20; 1.2 is FLOSS distributions.

### R4 Note: commercial desktop EULAs
One foundry generalised to all; word it as "typically forbid embedding in
products or apps", with the example clause.

### R5 Note: layout not copyrightable, missing caveat
Original, sufficiently creative selection and arrangement of specific
content can be protected.

### R6 Note: LLM-judge mitigations attributed to the paper
"Fresh context plus fixed rubric" is synthesis; self-preference risk
remains with same-family reviewers.

### R7 Note: stretches on brief-writing sources
"Examples go with explicit instructions" is a choice, not the Gemini page;
"3 of 5 is hard to act on" rests on hamel.dev [O] alone.

## Coverage check
Typst Universe packages may not ship fonts (worth one line); Adobe Fonts
terms match the claim; SPD, D&AD, Museum für Gestaltung, Butterick and Eye
on Design sources exist.

## Verdict: FINDINGS

## Disposition (lead, 2026-09-25)
All seven applied in research.md; R1 also in the idea-run skill (the lead
runs the loops by design: fresh reviewer rounds, one place for caps,
visible record). The Typst Universe font line added to section 3.

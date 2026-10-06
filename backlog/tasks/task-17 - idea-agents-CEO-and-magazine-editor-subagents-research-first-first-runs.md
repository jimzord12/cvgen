---
id: TASK-17
title: 'idea-agents: CEO and magazine-editor subagents, research first, first runs'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/dfbCOLql'
ordinal: 17000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# idea-agents: CEO and magazine-editor subagents (research first, first runs)

Owner: Claude Code, overnight run. Requested by the owner 2026-09-25. Integration target: `main`.

## Outcome
Two subagents under `.claude/agents/` that only propose, never decide or merge:
- **ceo**: reads vision, roadmap, framework gaps, board, history, current examples; researches the CV/recruiting market; returns at most 3 roadmap-aware ideas per run (who it helps, smallest shippable version, cost, risk, roadmap slot), each saved as a `pending` proposal under `docs/proposals/`.
- **magazine-editor**: studies editorial design and `archive/design-studies/`; returns 2-3 template concepts per run, each with a one-page Typst mock-up PDF on fictional data. Never touches the frozen engine or Flagship; inspiration, never copies a publication's layout or branding; OFL-licensed fonts only.

## Steps
1. Targeted research (30-45 min), sources cited in the agent files: current Claude Code subagent format (frontmatter, tools incl. web search, model/effort), writing briefs that give sharp rather than generic output, font licensing for bundled Typst fonts, trustworthy editorial-design sources. Market and trend research stays inside the agents' runs.
2. Write both agent files; document them in AGENTS.md "Skills and agents".
3. First runs: editor -> 2-3 concepts with PDFs; CEO -> market scan + up to 3 proposals.
4. Review round under docs/review.md, merge, report with links to the PDFs and proposals.

## Acceptance
- Owner opens the concept PDFs and proposals in the morning without reading code.
- No product decision taken by either agent; proposals are `pending`.
- CEO cadence recommendation: weekly, not nightly (agent's pushback, 2026-09-25).
## Owner addition 2026-09-25: closed review loops
Each creator gets a counterpart reviewer, and web research gets one too:
- **ceo-reviewer** judges each idea: real user need, fits the vision, smallest version honest, cost/risk realistic, not a duplicate of the roadmap.
- **design-reviewer** judges each concept PDF: premium and distinct from Flagship, readable as a CV, prints cleanly, fictional data, OFL fonts, no copying.
- **research-reviewer** checks any web research (the creators' and the upfront research): sources exist, are current, and say what is claimed.
Loop: author revises until the reviewer passes; max 5 rounds when the owner is attending, 10 when unattended (owner, 2026-09-25); still failing -> reaches the owner marked unresolved with the reviewer's reason. Calibration (owner): decently strict, not perfectionist; the niche is custom, unique, premium work. Reviewers fail generic, copied or unsupported work; taste nitpicks are notes, not failures.
## Result (2026-09-25)
Done. Integrated at 8f7bf35; CI verify run 36079889960 success; suite on the merged branch PASS 43 (cvgen-wt-ideas/builds/tests-20260925-035709-054243, worktree since removed). Code reviews 01-07 in docs/work/idea-agents/reviews/ (round 5 PASS, notes applied in 194e7bf). Agents: ceo, ceo-reviewer, magazine-editor, design-reviewer, research-reviewer; skill idea-run. First runs: proposals certificate-validity-check, vessel-particulars, candidate-intake (pending); concepts measured-in-months, feature-opener, fleet-in-signs (proposed). Owner items parked on the handoff card: the docs/review.md idea-gate exception, the three proposals, the three concepts, D11 (engineer example names a real institution; touches frozen v11). The agent files load at session start: in a fresh session they can be started by name.
<!-- SECTION:DESCRIPTION:END -->

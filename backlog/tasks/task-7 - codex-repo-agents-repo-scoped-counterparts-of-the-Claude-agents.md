---
id: TASK-7
title: 'codex-repo-agents: repo-scoped counterparts of the Claude agents'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/pc3a0vY1'
ordinal: 7000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# codex-repo-agents: repo-scoped counterparts of the Claude agents

Owner: Codex, owner request 2026-10-02
Integration target: codex/repo-agents

## Outcome and acceptance
Delivered seven native Codex agents in .codex/agents with source role parity, preserved rubrics and privacy, supported settings and inherited models. Usage notes in .codex/README.md. The nine existing skills are shared from .claude/skills. Existing repo/global configuration and CV source were outside scope.

## Result and evidence
Final published commit: 3e432f7d1c018898ac700414cd21791097453f03. Reviewed source commit: 5177455cc1b5c7f3568eef65c7845879f3d37ff4. Working tree clean.

Native loading and all seven TOML/name/LF/hash checks passed. Current source evidence: builds/codex-agents-round2-20261002-163356/snapshot.json and builds/codex-revised-loader-20261002-163649/transcript.json. Original duplicate-role control proved native directory scanning.

Final exact-head CI SUCCESS: https://github.com/jimzord12/cvgen/actions/runs/37014528627
Setup: https://github.com/jimzord12/cvgen/blob/3e432f7d1c018898ac700414cd21791097453f03/.codex/README.md

## Review
Fresh Claude Opus high round 2 PASS on source 5177455. Report saved unchanged: https://github.com/jimzord12/cvgen/blob/3e432f7d1c018898ac700414cd21791097453f03/docs/work/codex-repo-agents/reviews/03-claude.md
Dispositions: same folder, 03-dispositions.md. F1-F3 resolved; F4 accepted; F5 outside scope. F6 Minor deferred with lead-owned confirmed-removal workaround. Earlier advisory Codex feedback was not used as the Claude gate.

## Handoff and limitations
Start a fresh Codex session here and request a named role. No owner action needed. Actual model-driven Codex role invocation remains untested; native loading and contracts were verified. Include active owner checkpoints in delegation briefs; broader parent runtime permissions can override sandbox defaults. The task branch inherits earlier editor-work ancestry; only this setup's own commits are fdcb191, 5177455 and record-only 3e432f7. Main remains 0488c4f. Inherited stale Atlas pages and the client-workflow proposal metadata discrepancy are recorded in session-handoff, outside this setup scope.
<!-- SECTION:DESCRIPTION:END -->

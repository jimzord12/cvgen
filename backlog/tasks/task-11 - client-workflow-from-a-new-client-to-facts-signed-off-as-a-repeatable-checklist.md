---
id: TASK-11
title: >-
  client-workflow: from a new client to facts signed off, as a repeatable
  checklist
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/ac5Culy0'
ordinal: 11000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# client-workflow: from a new client to facts signed off, as a repeatable checklist

Owner: Claude Code (lead session 2026-09-25)
Branch/worktree: feat/client-workflow (worktree ../cvgen-client-workflow)
Integration target: main
Depends on: docs/glossary branch (glossary terms), owner decisions 2026-09-25 (chat)

## Outcome and boundaries
The owner can start a new client and reach a signed-off text draft by following one guide and one skill (`new-client`), then hand over to `new-cv`. Decisions (owner, 2026-09-25): Envelope = existing private/<envelope>/ folder plus intake/ and research/; Relay intake (Claude writes questions, owner passes them by chat; no web form, Hermes later); one batched follow-up, hard cap 10 questions, aim 5; Scout checks the Research Library first; owner picks Deep Dives (0-3, 6 for executives); research is enough when every CV decision has a sourced answer; no client name or employer in web searches; consent line in intake; client Sign-off on a plain text draft before design; shared Research Library (public, dated, recheck after 6 months, no client data); no new agent profiles.
Excludes: automation (Hermes), web app, drafting/layout/QA/delivery stages beyond the handover.

## Acceptance
- [x] docs/guides/client-workflow.md: the flow, the question list, the follow-up rules, research rules, Sign-off, handover.
- [x] .claude/skills/new-client/SKILL.md: the checklist version.
- [x] Envelope drawers intake/ and research/ documented in build-a-cv.md and new-cv; cv.py render still works with them present.
- [x] docs/research/ Research Library with its rules and a first note (client intake practice, research-reviewer PASS).
- [x] candidate-intake proposal marked superseded; a decision record for the workflow.
- [x] "field" wording swept from architecture.md and reference/domains-and-roles.md; glossary rows updated.
- [x] Independent review PASS; merged; CI green.

## Result and evidence
Merged to main in 9598d5b (https://github.com/jimzord12/cvgen/commit/9598d5b); CI green on the merge head (run 36128484592). Suite PASS 44 cases (text-draft case added), builds/tests-20260925-141559-584790 on main. Guide docs/guides/client-workflow.md, skill .claude/skills/new-client, Research Library docs/research/ with note cv-intake-practice (research-reviewer PASS round 2), scripts/text-draft.typ, proposal docs/proposals/client-workflow.md, candidate-intake rejected as superseded.

## Review
docs/work/client-workflow/reviews/01.md FINDINGS (3 material: new-domain handover, research-reviewer and client names, consent order; all fixed), 02.md PASS; its minors applied on framework-split and covered by that branch's round 2. Research: research-01.md FINDINGS, research-02.md PASS.

## Handoff
Done. Not yet used on a real client. Proposal status is approved; set it applied with the first real run's evidence.
<!-- SECTION:DESCRIPTION:END -->

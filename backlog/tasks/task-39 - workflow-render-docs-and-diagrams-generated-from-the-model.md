---
id: TASK-39
title: 'workflow-render: docs and diagrams generated from the model'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 10:16'
labels:
  - workflow-model
dependencies:
  - TASK-38
ordinal: 39000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`render` writes the generated blocks (between markers) in `docs/workflow/**/README.md` and the Mermaid diagrams. CI fails if regeneration changes anything. Source: archive/work-records/workflow-model/handoff.md, section 4, item 7 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 The regenerated tree is identical in CI
- [ ] #2 diagrams render on GitHub
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
TASK-39 decisions (lead, 2026-10-14): (1) Markers: <!-- generated:start <name> --> and <!-- generated:end <name> -->, each alone on its line, the name on both so pairs are checked. (2) Blocks: docs/workflow/README.md has stages, journey, handovers, actors; each NN-<stage>/README.md has summary, diagram, steps, gates, loops, artifacts, actions. A missing README is created with a placeholder heading and an HTML comment explaining the blocks; a missing block is appended at the end; a moved block stays where it is; an unknown, repeated, nested, unclosed or malformed marker (a line starting <!-- generated:) stops render with file:line and nothing is written. (3) render runs the full check first and refuses a model that fails it; it reuses check.ts (deriveGraph, placeholderCap, the indexed defs) rather than a second graph. (4) Diagrams: steps boxes, gates diamonds with pass/fail, a loop's fail edge and its cap escalation dotted with the cap (placeholder marked), steps of another stage as rounded boxes; an arrow implied by a longer path is left out unless that path runs through an optional (when) step; the journey draws forward handovers solid (transitively reduced) and back ones (deliver to design) dotted; the tables list every input and handover. (5) Diagram validation: a validator for the emitted Mermaid subset (src/mermaid.ts), run by render on every diagram and by the tests; the real Mermaid parser is not a dependency because it needs a DOM shim and about 140 packages; a one-off run of Mermaid 11.4.1 under happy-dom in the scratchpad parsed all 8 diagrams and refused two broken controls. (6) Tests render a temp copy of test/fixtures/valid (no new fixture folder: check.test.ts pins the fixture list). (7) A README with CRLF and the same text counts as current. (8) The top README is 84 generated lines today, leaving TASK-40 room for 120-200 lines of prose within the owner's 200-300.
<!-- SECTION:NOTES:END -->

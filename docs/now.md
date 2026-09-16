# Retired status snapshot

Retired 2026-09-15 at the owner's direction. Do not use this file for current
state, next steps, or agent orientation. The content below is historical only;
derive current reports from authoritative sources as described in `AGENTS.md`.

## Historical snapshot

Recorded 2026-09-15. The following status and recommendations are not maintained.

## Goal

Produce distinctive, accurate maritime CVs through several templates. Keep the
engine locally usable, then add a web app for intake, review, approval, and
delivery after the core is stable.

## Actual state

- Flagship is the only implemented template. Three public fictional examples
  exist: engineer, captain, and captain silver. The repository still uses the
  original top-level source folders.
- [ADR 0010](decisions/0010-public-monorepo-and-pdf-workflow.md) and
  [PDF workflow](pdf-workflow.md) are approved. The monorepo migration,
  candidate/adapter split, approval sidecars, and web app are not implemented.
- Claude Code owns implementation, tests, and implementation review. Codex is
  optional for discussion and design documentation.

## Active work

Designing the [development protocol](proposals/development-protocol.md), with
an [eight-lens review protocol](proposals/review-protocol.md) and
[small work records](proposals/work-records.md). These are proposals, not active
review gates. A Claude reviewer definition has not been installed.

The owner selected an eight-round review cap and wants the development system
to evolve through trials and explicit decisions. The
[process-governance package design](proposals/process-evolution.md) and
[Kanban research](proposals/kanban-tooling-research.md) make that concrete.
Backlog.md is the recommended first trial; no task tool or package is installed.

## Next

Settle the process-evolution proposal and first tooling trial, then let Claude
Code establish the agreed records/reviewer and plan the monorepo migration in
small steps. Tool selection and trial authorization remain open.

Owner action: consider the proposed Backlog.md pilot and process lifecycle.
This status page does not grant implementation or merge approval.

## Evidence and open work

- Last recorded suite result, from the preceding documentation task:
  [24 compilation cases plus PDF/data/layout assertions passed](../builds/tests-20260915-120740-835065/report.json).
  This is local historical evidence, not a fresh implementation review.
- Working branch: `docs/product-direction`; last commit observed:
  `17c02e9`. Architecture and preference documentation changes are uncommitted.
  Recheck both facts on resume; do not discard those changes.
- [Framework gaps](framework-gaps.md): contract periods, configurable certificate
  columns, and skills placement remain open. These are backlog, not active code
  work during protocol design.

## Review round 3 (context round 1): context-reviewer, 2026-10-14

Snapshot: `origin/main...747d01b` in `.worktrees/task-36`. Lead lenses: consistency with ADR 0015 and the glossary; the sample's illustrative bits marked, README usable, Atlas citations right.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Material
- M1: `external` has two meanings. The inventory and handoff use it for "outside the repo: Google, the chat app" (`docs/workflow/inventory/README.md:107-109`, `a-stages-1-4.md:104`, `docs/work/workflow-model/handoff.md:289`); the types renamed that visibility `third-party` and reuse `external` for "no step produces it" (`src/model.ts:124-130`); the sample sets `external: true` on a repo file (`stage.yaml:114`). An agent following the inventory would mark `art.google-form` `external: true` though `intake.form-create` produces it, and nothing catches it before TASK-38. A chat message is `third-party` in one place and `ephemeral` in another. Fix: a "Reading the inventory" paragraph in the README and a TASK-37 pointer; decide where a chat message belongs.

Minor
- m1: the sample marks only the cap as illustrative (`stage.yaml:79`); `text.correction-cap` (`:63-68`) and `manual.decide-next-round` (`:158-162`) exist only because of it. Fix: extend the comment; say "illustrative, not facts" in `README.md:15`.
- m2: `stage.yaml:3-5` ("live in docs/workflow/catalog.yaml") and `README.md:30` read as if TASK-37's files exist. Fix: "will live", "(from TASK-37)".
- m3: whole notes sit inside `##` heading lines (TASK-37 notes `:32`, `:34`; TASK-36's review-round notes). Fix: heading and body on separate lines.

Notes
- TASK-38's title still says "the engine verifies"; the glossary forbids it.
- 21 top-level entries vs `max_top_level: 18` (`.claude/repo-maintenance.md:68`); ADR 0015 left `tools/`'s place to TASK-55.

Verified: `atlas check --strict` exit 0; `.atlas/src` citations into AGENTS.md sit above the edits; site.json cites no changed line; sample anchors land right; README commands match `package.json` and `cli.ts` with exit codes 0, 1, 2; nothing claims facts, rendering or CI wiring exist; AGENTS.md tight; LF; no client data.

## Dispositions (lead)

- 🧭 M1: rename the boolean `external` to `given` ("given to the workflow: no step produces it"), so `external` has no meaning in the types; the inventory's `external` maps to `visibility: third-party`. A chat message is `third-party` (it lives in the chat app); `ephemeral` is only for what is saved nowhere. README "Reading the inventory" paragraph and a TASK-37 note say both.
- m1, m2, m3: fix. TASK-38 title: fix through the backlog CLI. Top-level count: TASK-55.

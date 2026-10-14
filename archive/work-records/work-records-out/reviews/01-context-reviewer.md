## Review round 1 (context): context-reviewer, 2026-10-14

Snapshot: `546c658..e05656f`. Lenses: 1 completeness (every live pointer moved), 2 coherence (the archive's role described once and consistently).

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Clean: about 280 files renamed with history; rules, skills, agents, `.codex`, `.atlas/src` incl. `site.json`, workflow YAML and `.claude/repo-maintenance.md` point to `archive/work-records/`; nothing calls `archive/` "never touched" while reports land there; `docs/pdf-workflow.md:118` holds (no PDFs); `docs/history.md` entry accurate; no client named.

Material
1. `docs/workflow/05-design/stage.yaml:355`: `art.concept-brief` cites `AGENTS.md:102`, which after the new row at :101 is the `archive/anti-examples/` row, not `design-concepts/`. Fix: `AGENTS.md:103`.
2. Open tasks still send readers to old paths (closed notes may keep them): TASK-38 :18, :31; TASK-39 :17; TASK-40 :18; TASK-41 :17; TASK-42 :18; TASK-43 :20; TASK-51 :16; TASK-55 :19 (`Source: docs/work/workflow-model/handoff.md`); TASK-4 :28 (`docs/work/codex-visual-tools/reviews/01.md`, its open review). Fix: path only.

Minor
1. The report filename is written three ways (`AGENTS.md:101` `<task-slug>/reviews/NN-<reviewer>.md`; `docs/review.md:223` `<task-id>/reviews/<NN>.md`; `docs/development.md:119,137` `<id>/reviews/NN.md`). Settle one in `docs/review.md` (`NN-<reviewer>`), match development.md, point the AGENTS.md row to review.md.
2. `backlog/docs/doc-1 - session-handoff.md:18,19,27` still name `docs/work/...`; fix in the end-of-session rewrite.
3. `docs/development.md:119` comment out of line.

Notes
- `.claude/repo-maintenance.md:42` duplicates `archive/**` at :38; harmless.
- `docs/proposals/trello-free-trial.md:176,281` link text shows the old path, target new.
- TASK-55 regroups `archive/`, moving the report path again; it should carry this task's list of live files.
- `.claude/agents/magazine-editor.md:194` no conflict.
- `TASK-43:32` two Research Library report patterns: predates this task.

Checks rerun: `git grep "docs/work\b"` judged hit by hit; repo-maintenance `audit.py --mode quick` no archive findings; LF; AGENTS.md line shift base vs head. Suite, CI, Atlas not rerun.

## Dispositions (lead)

- M1: fixed (`AGENTS.md:103`).
- M2: fixed for TASK-4, 39, 40, 41, 42, 43, 51, 55 (path only). TASK-38 is Active on its own branch, which is appending notes; its two paths are fixed when TASK-38 merges, to avoid a conflict.
- m1: fixed: `docs/review.md` names `archive/work-records/<task-slug>/reviews/NN-<reviewer>.md`; development.md's tree points to review.md; the AGENTS.md row says "named in `docs/review.md`".
- m2: done in this session's handoff rewrite. m3: realigned as far as the path allows.
- Notes: TASK-55 gets a note naming this task's live-file list; the rest accepted.

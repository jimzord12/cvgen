## Review round 1, lens B (context): context-reviewer, 2026-10-14

Snapshot: head 9e7e6e1, base 2626907. Lens B: does the map work, are the citations right.

Verdict: PASS. Recorded in substance.

Checked: all 50 paths and commands in AGENTS.md exist (`apps/web/` is declared unbuilt); `cv.py --help` and `outputs.py --help` match; 741 words, no CRLF; `bun run check`, `render --check`, `atlas --check`, `atlas check --strict` OK; 33 moved anchors read right apart from two below; every quoted heading exists; nothing outside dated records cites an old AGENTS.md section, line or the W/M/F shorthand; CLAUDE.md import and wording read correctly; `.codex` edits consistent; the five tasks (session start, client CV, Flagship engine change, idea run, review) each find their next file, the test command and the hard rules from AGENTS.md alone; glossary terms present; no client named.

Minor
1. `AGENTS.md:39` "each has a `README.md`": `studio/archive/` has none (only its subfolders).
2. `.atlas/src/pages/change-review.json:108` cites the whole AGENTS.md for "Understand the seam first"; now `docs/conventions.md:6-11`.
3. `.atlas/src/pages/change-review.json:48` cites `docs/development.md:109-121` (the handoff rewrite at session end) for the session-start step; drop it.
4. `AGENTS.md:12-13`, `:71`: the only cue for the constitution is "before anything irreversible", which does not fire for a Flagship engine change. Fix: "before changing a template or anything irreversible".

Notes
- `bun run anchors 2626907` exits 1 with two EDITED anchors (`client-workflow.md:21-27` from `01-open/stage.yaml:4,26,74,97`), from the line-22 pointer swap; facts hold; record in the task notes.
- `CLAUDE.md:11-13`, `.codex/README.md:63` describe AGENTS.md as holding the rules; it points to them; acceptable.
- ruff not run (environment).

## Dispositions (lead)

- PASS. Minors 1-3: fix. Minor 4 is folded into lens A's Material 1 (the six rules named by title). Notes: the anchor reread goes into the task notes.

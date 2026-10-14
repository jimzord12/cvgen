## Review round 2 (context): context-reviewer, 2026-10-14

Snapshot: `cb705cc..414a38e` (merge checked against 3727721). Lenses: 1 round-1 dispositions; 2 the merge.

Verdict: FINDINGS (one Material). Recorded in substance.

Clean: B1 fixed (`docs/git-workflow.md:115` `archive/<name>`; no tag reference says `studio/archive` in preferences.md :62,71, git-workflow.md :79-81, AGENTS.md :256, history, ADR 0005); m1 fixed; m2 back to a pointer (AGENTS.md 3,368 words vs main 3,353, the folder rows account for it); m3 annotated; N1, N2 applied in `.claude` and `.codex`; merge clean (`05-design/stage.yaml` keeps `studio/` paths, `catalog.yaml` `outputs.py` anchors from main); `bun run check` OK (7 stages, 104 steps); `atlas check --strict` 5 pages ok; site.json by hand; LF; no client.

Material
- M1 (rest of round 1) `.claude/skills/new-cv/SKILL.md:64-67`: the short-career branch still says `flagship-one-page.typ` / `layout: one-page(candidate)`; under the one import only `flagship-layouts` is in scope (unknown variable); disagrees with `build-a-cv.md:60`, `domains-and-roles.md:158`, `deck-cadet.typ:5`. Fix: `layout: flagship-layouts.one-page(candidate)`.

Minor
- `.claude/skills/new-cv/SKILL.md:60`, `.claude/agents/magazine-editor.md:195` (and the `.toml`) past the wrap width.

Notes
- `layout-and-pagination.md:17,143` name bare `one-page(candidate)` in tables; readable as the function name; prefix optional.
- Test fixtures and `tests/workflow.py`'s snippet import per file; test code, no finding.

## Dispositions (lead)

- M1 and the Minor: fixed by the lead; the 19 workflow anchors the rewrap moved were repointed with `bun run anchors HEAD --fix` (2 edited spans reread: facts hold), Atlas citations into the two files shifted by hand and re-stamped. Notes: accepted.

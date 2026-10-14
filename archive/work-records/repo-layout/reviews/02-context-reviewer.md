## Review round 1 (context): context-reviewer, 2026-10-14

Snapshot: `dbc11bd..cb705cc`. Lenses: 1 links and placement; 2 coherence.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Clean: `atlas check --strict` 5 pages ok; new modules match their docs; every tracked name follows the table except listed `GAPS.md` and Backlog's `doc-1 - session-handoff.md`; LF; no client named (`client-2026-09-01` is an `Alias`); no stale live path to a moved folder; remaining old paths in closed tasks, the handoff and frozen anti-example sources, on purpose; `archive/` and `studio/archive/` each described once (`AGENTS.md:100-102`, `pdf-workflow.md:53-56`), consistent; naming table stated once.

Blocking
- B1 `docs/git-workflow.md:115`: the tag namespace was renamed with the folders (`studio/archive/<name>`); tags are not paths; real tags are `archive/pre-domains`, `archive/pre-monorepo`, `archive/pre-restructure`, `archive/premium-draft-rejected`; the owner-only rule covers `archive/*` tags (`docs/preferences.md:62,71`, `git-workflow.md:79-81`, `AGENTS.md:256`). Fix: back to `archive/<name>`.

Material
- M1 `.claude/skills/new-cv/SKILL.md:57-60`, `docs/engine/layout-and-pagination.md:48,79`, `docs/engine/skills-component.md:11` still teach per-file imports while build-a-cv, README and `conventions.md:35-38` teach the single import. Fix: module form, or one clause in conventions if direct imports stay acceptable for fixtures.

Minor
- m1 `docs/history.md:298-319`: lost final newline; "read them under `studio/`... (the work records excepted)" ambiguous; suggested wording given.
- m2 `AGENTS.md:81` grew about 25 words (3,340 -> 3,373); shorten to a pointer.
- m3 TASK-55 notes: "Decision (grouping folder)" still says work records under `studio/archive`; "Decision (tools/)" says "17 to 16" (now 17). Strike or annotate.

Notes
- N1 `.claude/repo-maintenance.md:39` overlap with :44 and `ignore`; harmless; :42 comment misaligned.
- N2 `magazine-editor.md:194` (and `.toml`) "do not touch" list no longer covers `archive/work-records/`; allow-list at :22 still covers it.
- N3 `docs/workflow/inventory/*` dated pass, paths only.
- N4 working-tree CRLF in the round-1 report; blob LF.

## Dispositions (lead)

- B1: fix. M1: fix (module form everywhere live; one clause in conventions only if a fixture needs a direct import). m1, m2, m3: fix. N1: realign; N2: add `archive/work-records/` to the do-not-touch list in both files. N3, N4: nothing.

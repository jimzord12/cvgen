## Review round 2 (context round 1): context-reviewer, 2026-10-14

Snapshot: `9a8ed1c...f990dda` in `.worktrees/task-59`. Lead lenses: docs say what the code does, boundary lists live once, the `hero` exception is findable; placement and tightness.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Checked: claims match `core/theme.typ` (five colours plus two fonts; `require-colors`), `flagship.typ:36-42,60` and `check_core_boundary` (`colors` allowlist includes `hero`; Flagship colour names banned as strings); "still Flagship-shaped" gone from live files (kept in dated reports); `atlas check --strict` exit 0; 15 files LF; no client identity; the boundary lists live once in verification.md item 10; code round dispositions applied.

Material
- M1: `docs/architecture.md:104-108` principle omits theme colours, while `AGENTS.md:81` and `system-map.json:93` now include them. Fix: "read a layout key, artwork slot or theme colour it does not own".
- M2: the `hero` exception is only in `docs/reference/theme.md`, which addresses theme editors; a template author setting `shell.band` reads `layout-and-pagination.md:63-64` or `domains-and-roles.md:59-61`, neither of which says the theme must carry `hero` and the template must require it; "What the Framework owns" in domains-and-roles never mentions `validate-theme`/`require-colors`. Fix: a clause at `layout-and-pagination.md:64`; add theme validation to the list at `domains-and-roles.md:57-65`.

Minor
- m1: `docs/architecture.md:95` spells out both colour lists (a fourth copy). Fix: function names only, point to theme.md.
- m2: `docs/reference/theme.md:50` "a template ... must supply `hero`": the theme supplies it. Fix: "must require `hero` in its own check, and its themes supply it".

Note
- n1: new-theme skill line 17 longer than its neighbours; acceptable.

## Dispositions (lead)

- M1, M2, m1, m2: fixed by the lead. n1: rewrapped. Round 2 (context round 2) follows.

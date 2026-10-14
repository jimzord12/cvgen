## Review round 3 (context round 1): context-reviewer, 2026-10-14

Snapshot: `origin/main...36d40f2` docs and agent context in `.worktrees/task-45`. Lead lenses: docs say what the code now does; rules in their owning file, Atlas citations right.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Checked against the code, accurate: the `shell` slice (`margin`, optional `band`) and the refusal through `flagship` and the deprecated `document-shell`; core `validate-pages` checks rows only with the domain's `row` noun, Flagship's `validate-plan` keeps the old messages in order; recolour order `art-palette`, `{{<colour>}}`, `art-colors`; verification.md allowlist and colour constructors match `check_core_boundary`; legacy count 32; fixture rows match; no stale `opening-margin`, `band-height` or the four hex colours outside records (ADR 0003:18 correctly left); `atlas check --strict` exit 0, citations outside the edited lines; LF; no client identity.

Material
- M1: `docs/architecture.md:106-111` restates the boundary check in full (word list, eight-key allowlist, colour rule) that `docs/reference/verification.md:82` (item 10) owns; the two copies already differ. Fix: keep the principle, point to verification.md item 10.

Minor
- m1: `AGENTS.md:80` and `.atlas/src/pages/system-map.json:93` "names no domain or template word, layout key or colour" overclaims (the core reads its own layout keys; theme colours are TASK-59). Fix: "no layout key or artwork slot it does not own, no colour literal".
- m2: `docs/reference/layout-and-pagination.md:5-8` names `validate-plan` twice; `:61-67` one ~70-word sentence inside a parenthesis. Fix: split.

Notes
- n1: `docs/architecture.md:95` lists theme validation under the Framework without saying it is still Flagship-shaped (TASK-59).
- n2: `docs/guides/build-a-cv.md:339-340` "ignore them" holds for a layout spread from the base; a from-scratch layout without `shell` fails loudly; "rename first" covers it.
- n3: `.claude/skills/new-theme/SKILL.md:26` could name the `domain` import.

## Dispositions (lead)

- M1: fixed, architecture.md keeps the principle and points to verification.md item 10.
- m1: fixed in AGENTS.md and the system-map page. m2: fixed, both sentences split.
- n1: fixed (theme validation marked Flagship-shaped, TASK-59). n3: fixed (the skill names the import). n2: accepted.
- Round 4 (context round 2) follows after merging main.

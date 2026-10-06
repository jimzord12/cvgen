# Context review, round 1 — docs/worktrees-folder

Reviewer: fresh general-purpose agent acting as `context-reviewer` (Opus).
Base 1e684eb, head fc586ba. Verdict: FINDINGS (0 Blocking, 1 Material, 3 Notes).

1. Material — `.claude/skills/idea-run/SKILL.md:32` creates worktrees with no
   location. Fixed: points to `.worktrees/idea-run-<date>-<ceo|editor>` and
   `docs/git-workflow.md`.
2. Note — `<branch-topic>` can collide (`fix/x`, `feat/x`). Fixed: fall back
   to the full branch name with `/` replaced by `-`.
3. Note — `AGENTS.md` map lacked a `.worktrees/` row. Fixed: row added.
4. Note — `.claude/repo-maintenance.md` protected list. Fixed: `.worktrees/**`
   added.

Tool wiring checked clean in source: Output Contract scan, Design Review app,
`tests/run.py`, Atlas (`git ls-files`), repo-maintenance audit
(`--exclude-standard`).

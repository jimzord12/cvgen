---
kind: proposal
status: applied
revision: 1
---

# Repo maintenance: a skill and a read-only auditor

## Problem

The owner reads the tree, not the code, and wants the repository kept "nice,
simple and clean", restructured without fear whenever that helps navigation,
understanding and developer experience (owner, 2026-09-30; `docs/preferences.md`).
Drift (files in the wrong home, docs naming paths that moved, duplicates, an
overgrown map) was found only by chance, as with the old root `exports/`.

## Change

Adopted from the owner's research bundle (`docs/work/repo-maintenance/research/`,
starting at `00-bundle-readme.md`), in its recommended variant:

- `.claude/skills/repo-maintenance/`: `SKILL.md` (modes `quick`, `audit`,
  `deep`, `apply`; two layers, generic first; precedence; a safety floor; a
  one-screen report; the `apply` protocol: a branch, a pure `git mv` commit,
  then a reference commit), `checklist.md` (35 checks) and
  `scripts/audit.py` (27 deterministic, read-only checks, standard library
  and Git).
- `.claude/agents/repo-auditor-lite.md`: the judgement checks, read-only, no
  shell.
- `.claude/repo-maintenance.md`: CVgen's layer (protected paths, records left
  out, owners, the proof commands), verified against the tree.
- One line in the `Session Sweep` (`docs/development.md`): run `quick`.
- `tests/repo_maintenance.py`: the bundle's self-test pointed at the installed
  files, run by `tests/run.py`.

Not adopted: the shell-carrying `repo-auditor` and its Bash guard, the
commit hook, any schedule.

Changes made to the bundle: `SKILL.md` pre-approves only `git status`,
`git ls-files`, `git rev-parse` and the audit script by its full path (no
`git diff`, `git log` or `git grep`, which can write files or run a
program); `audit.py` refuses a `--since` value that looks like an option,
reads a comment on a key line as no value, and no longer reports a mention of a
Git-ignored area (`private/`, `.local/`, `builds/`) as a dead path; the
adapter leaves dated records (`docs/work/`, `docs/decisions/`,
`docs/history.md`, `docs/now.md`) out of every check. The first audit's
dead-path mentions fell from 674 in 122 docs to 193 in 32 docs (mostly paths
inside a client's `Envelope`, named relative to it: leads, confirmed by
reading).

## Decision

- 2026-09-30, owner: asked for the research ("Having a well maintained repo
  is a priority to me"), then handed over the bundle. Lead defaults, reported
  to him: the variant above, the `Session Sweep` line as the cadence,
  reports in chat unless asked.
- 2026-09-30, applied: reviews `docs/work/repo-maintenance/reviews/01.md`
  (FINDINGS, fixed) and `02.md` (PASS); `python tests/run.py` PASS (94 cases,
  25 of them the repo-maintenance self-test).

## Known limits

The skill and the auditor load only in a fresh Claude Code session, so the
first `/repo-maintenance audit` in a new session is also the first live test
of the skill invocation and the auditor spawn; record what happens.

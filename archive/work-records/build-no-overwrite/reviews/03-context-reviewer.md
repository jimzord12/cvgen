## Review round 3 (context round 1): context-reviewer, 2026-10-14

Snapshot: `.worktrees/task-49`, `git diff origin/main...a7926a0` over AGENTS.md, docs, .claude, backlog, .atlas/src and examples/release.json. Lead lenses: the owner's go has one owner, counts defer to the list; AGENTS.md tight, Atlas citations right.

Verdict: PASS. Recorded in substance (formatting condensed).

Checked: `docs/preferences.md:78-81` owns the rule; AGENTS.md:124, pdf-workflow.md:214-215, git-workflow.md:140-150, new-cv:32-35, verify-cv:55-56, repo-maintenance.md:39 and the Atlas point to it or name it as "owner's go", none contradicts; constitution section 2, glossary `Release` (:65) and pdf-workflow.md:146 still true; no live doc still says "five" (dated records and README.md:41 remain); shifted Atlas citations match their lines, `check --strict` exit 0; LF; no client data; code claims (verification.md check 14, run.py list and drift asserts) match the code.

Minor
1. `AGENTS.md:96, :104, :121-124`: the role of `examples/release.json` is described three times and the refusal twice. Fix: drop row 96's second sentence; end row 104 at "refuses while a `Release` exists".
2. `scripts/build.ps1:38-39` refusal text says "with it he runs ./scripts/build.ps1 -ReplaceRelease", but the agent runs it after the go (preferences.md:69, git-workflow.md step 3, build.ps1:11). Fix: "with it, run ...".
3. `.claude/skills/new-theme/SKILL.md:26-27` lost "and its assertions in `tests/run.py`" while new-cv:31 and domains-and-roles.md:109 still ask for one; the list only compiles a new example. Fix: restore the clause.
4. `.claude/skills/verify-cv/SKILL.md:55-56`: ragged line; the owner's go has no pointer. Fix: rewrap, point to `docs/preferences.md`.

Notes
- `README.md:41` "Five PDFs land..." will drift; optional.
- `pdf-workflow.md:215` cites constitution section 2 beside preferences.md; harmless.

## Dispositions (lead)

- Minors 1-4 and the README note: fix. The pdf-workflow note: accepted.

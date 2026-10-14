# 03. Safe restructuring, autonomy and cadence

## Order of operations (the `apply` protocol)

Inventory, plan, move, repair references, verify, review. Full text is `SKILL.md` step 4; the reasoning is here.

1. **Preflight.** Clean tree, a `maintenance/<date>-<slug>` branch, HEAD noted, green baseline (test command plus `audit.py --json`). A red baseline stops the run.
2. **Inventory.** `old -> new` and the reason per approved move. If an untracked or ignored file sits under an old path, stop: moving a directory carries it along.
3. **Find every reference first.** `git grep -n -F <path>` and `git grep -n --untracked -F <path>`. Also the basename, the path without extension, the dotted module form, and
   relative forms (a relative link changes with the referencing file's location). Then the places people forget: CI workflows, build scripts, path aliases, `.gitattributes`,
   `.gitignore`, `CODEOWNERS`, the map and glossary, generated indexes, test fixtures and manifests, and the references made *from* the moved files. Prefer a language-aware rename
   (language server, `ast-grep`) where available. Plan the rollback.
4. **Move commit.** `git mv` only, then `git diff --cached -M100% --summary` must show every entry as a 100% rename. Commit as `move: ...`.
5. **Reference commit.** Edit references. One logical change per commit. A behaviour change is a different job.
6. **Verify.** Old path returns zero hits (tracked and untracked); declared tests and checks pass as they did at baseline; the script shows no new findings against the baseline;
   `git diff --check` is clean; `git status --porcelain` is empty and the untracked list equals the preflight list; `git log --follow -- <new path>` shows older history for one file;
   any frozen hash or visual gate the repository names still holds. A passing suite alone does not prove a move is safe.
7. **On failure** fix forward once, otherwise `git revert` your own commits on the branch and report. Never `reset --hard`.
8. **Close.** Propose the move commit for `.git-blame-ignore-revs` if the repo uses one, send hand-offs, stop. The repository's own review gate is next.

Why separate commits: Git compares snapshots and infers renames when enough of a file is unchanged (default 50%; `-M100%` means exact). `git log --follow` follows one file at a time.
The `git mv` documentation does not promise that history is preserved; a pure-move commit is what makes detection reliable. Editing while moving can push a file below the threshold.

## What the agent may do alone

| Action | A: alone | B: owner approves | C: owner only |
| --- | --- | --- | --- |
| Fix a broken link or path mention when exactly one successor exists (and the file is not owned by someone else) | yes | | |
| Update references after an approved move | yes | | |
| `git mv`, rename, merge duplicates, `git rm` a tracked file | | yes | |
| Untrack a generated or ignored file (`git rm --cached`) and add an ignore rule | | yes | |
| Consolidate config, remove an unused dependency, edit `.gitignore` | | yes | |
| Anything untracked, ignored, private, protected, or a frozen reference | | | yes |
| Rewrite history, force push, Git LFS migrate, rotate a leaked secret | | | yes, never the agent |
| Edit a document owned by another agent or role (map, glossary, conventions) | | | hand-off |

"Approved" means the owner named the item (by ID) and, for a deletion, saw the exact paths and the consequence.

## Cadence and triggers

| Trigger | Mode | How | Notes |
| --- | --- | --- | --- |
| On demand | any | `/repo-maintenance audit` | Always available |
| End of a feature / end of a session | `quick` | One line in the repo's definition of done, or its session-end checklist | Seconds; prints nothing when clean |
| After each commit | `quick`, changed files only | Optional `PostToolUse` hook (`install/.claude/settings.hook.example.json`), async, wakes the agent only on High or Critical | Claude Code has no timer event; hooks fire on lifecycle events. The hook runs the script only, never a model |
| Weekly | `audit`, read-only | A cloud routine (`/schedule`), or `claude-code-action` on a cron | Routines run on a fresh clone, push only to `claude/` branches, have a 1-hour minimum interval and a daily cap |
| While a session is open | `quick` or `audit` | `/loop 1d /repo-maintenance quick` | Session-scoped; recurring tasks expire after 7 days |
| Monthly or before a restructure | `deep` | On demand | Runs tests and external tools |

Only a cloud routine or a CI cron survives a closed laptop. Verify the first scheduled run before trusting the schedule; token cost per run has not been measured.

**Keeping a run proportional:** the mode ladder (13 checks, then 27 plus the auditor, then tools and tests); `--since` for changed files only; `--baseline` for new and resolved only;
at most 6 evidence lines per finding; at most 5 decisions in the report; the auditor stops after 40 turns and returns one page; a clean tree ends the run in one line.

## The report

Format and severity words are in `SKILL.md` step 3. The decision-ready shape: verdict, up to five decisions in tree language (evidence, smallest fix, safe-alone tier, Now/After sketch, "reply approve N"),
one line for each other finding, hand-offs, what was fixed, what could not be checked. No score. Trend by counts. If a repository requires saved outputs to go in new folders, `report_home` names the pattern.

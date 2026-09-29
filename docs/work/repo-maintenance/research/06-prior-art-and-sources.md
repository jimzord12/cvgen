# 06. Prior art and sources

Status key: **checked** = the source was opened during this work; **secondhand** = taken from the third-party review (`third-party-review.md`) or from memory of the tool; **unverified** = not opened, do not rely on it.
Retrieved 2026-09-30 unless noted.

## Claude Code behaviour the design relies on

| Claim | Where | Status |
| --- | --- | --- |
| Skills: `SKILL.md` frontmatter (`name`, `description`, `allowed-tools`, `context: fork`), supporting files in the skill folder | Claude Code docs, "Skills" (`https://code.claude.com/docs/en/skills`) | checked |
| Subagent frontmatter: `tools`, `disallowedTools`, `model`, `effort`, `maxTurns`, `permissionMode`, `hooks`; subagents can spawn subagents by default; a parent in `bypassPermissions`, `acceptEdits` or auto mode overrides the subagent's `permissionMode` | "Subagents" (`https://code.claude.com/docs/en/sub-agents`) | checked |
| Hooks: `PreToolUse` / `PostToolUse`, matcher, `type: command`, `async`, `asyncRewake`, `if`, `CLAUDE_PROJECT_DIR`; exit 2 blocks on PreToolUse, on PostToolUse only shows stderr | "Hooks" (`https://code.claude.com/docs/en/hooks`) | checked |
| CLAUDE.md target under about 200 lines; `AGENTS.md` is read natively only when there is no CLAUDE.md, otherwise import with `@AGENTS.md` | "Memory" (`https://code.claude.com/docs/en/memory`) | checked |
| Cloud routines: fresh clone, push to `claude/` branches, 1-hour minimum interval, daily cap. `/loop` is session-scoped with 7-day expiry. `claude-code-action` can run on a GitHub cron | Claude Code docs (routines / scheduled tasks) and the action's README | checked for routines and `/loop`; the action's cron use is secondhand |

## Git behaviour the restructure protocol relies on

| Claim | Where | Status |
| --- | --- | --- |
| Git stores snapshots and infers renames when similarity passes a threshold (default 50%); `-M100%` means exact | `git-diff` documentation (`-M<n>`) | checked |
| `git mv` documentation makes no promise about history preservation | `git-mv` documentation | checked |
| `git log --follow` follows one file at a time | `git-log` documentation | checked |
| `git diff --check` reports whitespace errors and conflict markers | `git-diff` documentation | checked |
| `.git-blame-ignore-revs` lets `git blame` skip mechanical commits | `git-blame` documentation (`--ignore-revs-file`) | checked |
| GitHub warns above 50 MiB and blocks pushed files above 100 MiB | GitHub Docs, "About large files on GitHub" | checked |

## Standards behind the checklist numbers

| Number or rule | Source | Status |
| --- | --- | --- |
| README description at most 120 characters | Standard Readme specification | checked |
| Root `README`, `LICENSE`; community files | GitHub Docs (community profiles) | secondhand |
| Depth 5, 12 top-level entries, 25 entries per folder, 1/10/50 MiB warning sizes | **None. These are my conventions**, marked † in `checklist.md`. Tune them per repo | n/a |

## Existing tools (ideas borrowed; nothing is installed by this bundle)

| Tool | Idea used | Licence, status | Status |
| --- | --- | --- | --- |
| repolinter | Declarative repository rules; the model for the checklist and the per-repo config | Apache-2.0; archived 2026-02-06 | checked |
| lychee | Link checking; `deep` mode runs it `--offline` if installed | MIT / Apache-2.0 | secondhand |
| Knip (JS/TS) | Unused files, exports, dependencies | ISC (per the third-party review) | secondhand |
| vulture (Python) | Unused code | MIT | secondhand |
| deptry (Python) | Unused and missing dependencies | MIT | secondhand |
| ls-lint | File and folder naming rules | Licence unverified | unverified |
| Codex and Cursor guidance on agent instruction files | Keeping the entry file short; a nested-file model | Links in the third-party review; not re-opened | unverified |

`deep` mode uses a tool only if the repository already has it. The bundle adds no dependency.

## Failure reports that shaped the "never delete on your own" rule

Public write-ups describe an agent "clean-up" that ran `rm -rf` with an unexpanded or wrongly expanded home path, one that treated a source
folder as build output, and a planning mode that still removed tracked files. I read these as reports, not as measurements of how often it happens.
The links are in `third-party-review.md`; they were not re-opened. The design does not depend on them: it never runs `rm -rf`, `git clean` or `reset --hard`.

## CVgen sources

See `04-cvgen-facts-and-fit.md` for the list, the conflicts and what to verify. The raw files were read from `https://raw.githubusercontent.com/jimzord12/cvgen/main/...`
(AGENTS.md, CLAUDE.md, README.md, docs/constitution.md, docs/review.md, docs/glossary.md, scripts/outputs.py, .claude/agents/code-reviewer.md).

## Not measured

Token cost per run, real-session behaviour of the skill and subagents, the `apply` protocol end to end, and Windows behaviour of the script. See `02-design-rationale.md`, "Known weak points".

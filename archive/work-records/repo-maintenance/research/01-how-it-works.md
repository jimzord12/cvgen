# 01. How it works

A map of the moving parts, in the order they run. Everything named here is a file under `install/.claude/`.

## The pieces

```
               owner types  /repo-maintenance [quick|audit|deep|apply]
                                     |
                                     v
   SKILL.md  (the procedure: modes, layer loading, precedence, safety floor, report, apply protocol)
      |                |                                 |
      | reads          | runs (read-only)                | hands judgement work to
      v                v                                 v
 checklist.md     scripts/audit.py                  repo-auditor  or  repo-auditor-lite
 (35 checks,      (27 deterministic checks,         (fresh context, cannot write;
  tests, severity) JSON or text, no writes)          returns one page of findings)
      ^                ^                                 |
      |                | reads settings                  | Bash of the full variant passes through
      |                |                                 v
      |        .claude/repo-maintenance.md        scripts/readonly_guard.py  (hook: blocks anything that writes)
      |        (THE REPOSITORY'S OWN LAYER)
      +--- points at the repo's map, glossary, conventions, constitution, checks
```

Only two things write to the repository, and only in `apply` mode: the working agent's `git mv` and its reference edits,
on a branch, for items the owner approved. Everything else reads.

## The two layers

| Layer | Lives in | Knows | Never does |
| --- | --- | --- | --- |
| Generic | `SKILL.md`, `checklist.md`, `audit.py`, the agents | What "good condition" means, how to measure it, how to fix safely, how to report | Assume any project fact |
| Repository | `.claude/repo-maintenance.md` plus the files it names (AGENTS.md, glossary, conventions, constitution) | Homes, protected paths, official terms, thresholds, the commands that prove health, who owns what | Widen what the agent may do alone |

"Generic first" is an order of reading, not a period in which project rules are off. Anything the session already
loaded (AGENTS.md, CLAUDE.md, rules, permissions) applies from the first minute.

**Precedence:** the owner's live instruction and permissions; then the repo's frozen rules (constitution, conventions);
then `.claude/repo-maintenance.md`; then the skill's defaults. The safety floor (see `SKILL.md`) sits under all four.
A repo layer may add protection, move thresholds, change severities, declare exceptions and narrow a test. It may not authorise
deleting untracked files, rewriting history or acting without approval. Two repo files that disagree stop the affected
change and are reported with both anchors.

**With no repo layer** the skill still runs: naming, links, duplicates, generated output, ignore rules, large files,
binaries, config and lockfiles need no project knowledge. Checks that need it are reported as NOT_CHECKED.

## The modes

| Mode | What runs | Output |
| --- | --- | --- |
| `quick` | `audit.py --mode quick`: 13 checks (N2 N3 D2 G1 I1 I2 I3 B1 B2 L1 C2 H2 R3) | One line if clean, else a short list |
| `audit` | Working agent runs `audit.py --mode audit` (27 checks), then a read-only auditor subagent does the judgement checks and confirms the script's leads | The report (below) |
| `deep` | `audit` plus the repo's declared `checks`, its test command, `lychee --offline`, dead-code and dependency tools if installed, the README quickstart in a clean worktree | The report, with fewer NOT_CHECKED |
| `apply` | Only the items the owner approved by ID, with the protocol in `SKILL.md` step 4 | Commits on a maintenance branch, plus a verification list |

## What is deterministic and what is judgement

`audit.py` does the counting: names, sizes, hashes, links, tracked-vs-ignored, lockfiles, headings, term lists. It is
standard-library Python plus git. Its findings that are only **leads** (L2 dead path mentions, L3 stale docs, D3 orphan docs, N4/R1
wording) are confirmed by a reader. The auditor does the checks a script cannot: H3 one canonical doc per topic, X1 the
newcomer test (can a stranger answer three questions from the README and the map within three file reads), L4 ownership
and review dates, and the confirmation of leads. Tools the repo already uses (knip, vulture, deptry, lychee) feed D4, P1 and L1.
Anything not run is reported NOT_CHECKED. A check that was not run is never a pass.

## The two auditor variants

| | `repo-auditor` | `repo-auditor-lite` |
| --- | --- | --- |
| Tools | Read, Grep, Glob, Bash (guarded by a hook) | Read, Glob, Grep |
| Can run git or the script | Yes, read-only commands only | No. The working agent runs the script and passes the output |
| Boundary | Tool allowlist plus `readonly_guard.py` | Tool allowlist (no shell exists to misuse) |
| Extra setup | The hook path inside the agent file must match the install location; `python3` vs `python` | None |
| Use when | You want the auditor to re-run checks itself | You want the smallest, safest boundary, or the machine is Windows/PowerShell |

Claude Code's docs are explicit that a parent session in `bypassPermissions`, `acceptEdits` or auto mode makes a subagent run in
that mode and ignores its `permissionMode`. So the **tool allowlist** is the boundary, not the prompt and not `permissionMode`.
Docs also say subagents can spawn subagents by default (up to three layers), so both agents carry an allowlist without the
`Agent` tool.

## The audit script in one page

`python audit.py [--mode quick|audit|deep] [--since REF] [--baseline prev.json] [--json] [--fail-on SEV [--fail-code N]] [--max-evidence N] [--config PATH] [--root DIR]`

Each finding has: `id`, `severity` (Critical, High, Medium, Low, Info), `title`, `paths`, `evidence`, `fix`, `tier`, `protected`.
Tier **A** the agent may fix alone (unique-target link or path fixes), **B** needs the owner's approval, **C** the owner's call
only. A finding whose paths are all `protected` is forced to tier C. `--since REF` keeps only file-scoped findings that touch
files changed since REF. `--baseline` compares path-level keys with an earlier `--json` run and prints new/resolved counts.
The script never writes to the repository and never runs a command from the config; the `checks` list is for the agent to run.

## The report

One screen: verdict (RED any Critical or High, AMBER Medium only, GREEN Low or nothing), at most five decisions in tree
language with a Now/After sketch for moves, one line per remaining finding, what was handed off, what was fixed, what was
not checked. The owner replies "approve 1, 3". Format in `SKILL.md` step 3. No single score; a trend of counts by severity
when a previous report was saved.

## The checklist, by group

Naming N1-N4, homes H1-H3, dead/duplicate/orphan D1-D4, docs L1-L4, README and entry points R1-R3, generated output G1-G2,
config C1-C2, dependencies P1-P2, ignore rules and secrets I1-I3, binaries B1-B2, terminology T1-T2, discoverability and health
X1-X4. Each has a test, a default severity and a "run by" column in `install/.claude/skills/repo-maintenance/checklist.md`.

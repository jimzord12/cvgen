# 02. Design rationale

Why it is built this way, what was rejected, and the trade-offs. Read this before you change the design, not before you use it.

## The problem

A repository drifts: files land in the wrong home, docs point at paths that moved, generated output gets committed,
two files explain the same thing differently. The owner reads the tree, not the code, so drift costs him the most. He wants
a repository that stays "nice, simple and clean" and is not afraid to be restructured, as long as nothing is lost.

Design principles, in priority order:

1. **Never lose work.** Untracked, ignored, private, frozen and unapproved things are never touched.
2. **Measure actionable drift**, not neatness. A finding needs a practical consequence.
3. **Smallest capability that works.** No service, no new dependency, nothing to keep running.
4. **Generic first, repository second.** One reusable core; each repository adds a short pointer file.
5. **Decision-ready output.** The owner decides in one or two minutes.

## Options considered

| Option | Context cost | Independent judgement | Tool permissions | Reuse across repos | Verdict |
| --- | --- | --- | --- | --- | --- |
| Skill only | Body stays in the working context, plus every listing the audit reads | None: the agent that built the feature audits its own mess | Inherits the session's; an audit can write by accident | Best: one folder | Fallback |
| Agent only | Nothing in the working context | Good | Forced choice: read-only (cannot fix) or write access (no guarantee) | The protocol has nowhere to live but one long prompt | No |
| **Skill + read-only auditor** | Skill body plus a one-page report | Good for the audit; fixes stay with the agent that has the context | Auditor cannot write; applier uses normal prompts | Copy `.claude/` | **Chosen** |
| Auditor agent + applier agent | Two extra contexts | Good | Two profiles to keep in sync | Two files plus the protocol anyway | Overbuilt |

A second design, written independently (see `05-two-designs-compared.md`), reached the same shape: one skill, one optional
read-only auditor, no applier agent, no service, no automatic cleanup hook. Two separate analyses converging is the best
evidence for the shape.

## Decisions and their reasons

- **A script for the counting.** Names, hashes, sizes, links and tracked-vs-ignored are the same every time and cheap to run;
  a model doing them is slower, costlier and wrong more often. The script is standard library plus git, read-only, and returns
  findings with evidence so a model only judges. It exists because the skill is meant to be re-run.
- **A judgement pass by a fresh reader.** Terminology, "one canonical doc per topic", the newcomer test and confirming leads need reading.
  A fresh-context subagent has no stake in the work just done.
- **The tool allowlist is the read-only boundary.** A prompt that says "read only" is a promise; a tool list without Write/Edit is
  a fact. The full variant also passes Bash through a hook that blocks anything not on a read-only allowlist, because the docs say
  a hook blocks an action regardless of what the model decides. The lite variant removes the shell entirely.
- **No applier agent.** An approved move list is short. A fresh applier would not know why each move matters. The working agent
  applies it under a protocol, on a branch, and the repository's own review gate checks the diff.
- **No `context: fork` on the skill.** A forked skill runs as a subagent without the conversation and cannot ask the owner to approve.
- **Two commits per restructure.** Git does not record renames; it infers them at compare time, by default when at least 50% of a
  file is unchanged. A commit that only moves files is detected as pure renames (`-M100%`), so `git log --follow` and blame stay
  readable, and the review shows only moves. A move mixed with edits can look like delete plus add. It is a review aid, not a guarantee.
- **Everything destructive needs the owner.** The failure reports for "clean up" requests are real (see `06-prior-art-and-sources.md`):
  `rm -rf` with an expanded `~/`, a source folder mistaken for build output, tracked files deleted by a planning mode. Hence no `rm -rf`,
  `git clean` or `reset --hard`; approved removals use `git rm`; every path is printed absolute before a move.
- **No single score.** It hides which problem matters and invites gaming. Counts by severity, plus what is new or resolved against the
  last saved report, carry the trend.
- **Thresholds are defaults, and the documents say which are mine.** No published standard sets a maximum tree depth or "one home per
  kind of file". The numbers (5 levels, 12 top-level entries, 25 entries per folder, 1/10/50 MiB) are conventions. The 50 and 100 MiB
  GitHub limits, the 120-character README description, and the 200-line CLAUDE.md target are sourced.
- **Report words follow the repository.** CVgen's review protocol already uses Blocking, Material, Minor, Note; the adapter maps to them.

## What it deliberately does not do

- It does not review implementations or issue verdicts (that is the repository's review gate).
- It does not edit documents another role owns (it hands them off).
- It does not keep a backlog or status file (the repository has a task record).
- It does not install linters. It borrows their ideas and uses the ones the repo already has.
- It does not schedule itself. The cadence options are in `03-safe-restructuring-and-cadence.md`.

## Known weak points

- Untested inside a live Claude Code session: skill invocation, subagent spawn, the agent-frontmatter hook, and the `apply` protocol
  end to end. `tests/selftest.py` covers the script, the guard and the frontmatter only.
- Written to be portable (git paths are handled as POSIX strings, `--fail-code` avoids `sh -c` in the hook) but tested on Linux only.
- L2 and L3 are heuristics with false positives; that is why they are leads that a reader confirms.
- The first run on a real repository will be noisy. Tune with `protected`, `allow_*` and `ignore` before trusting the counts.

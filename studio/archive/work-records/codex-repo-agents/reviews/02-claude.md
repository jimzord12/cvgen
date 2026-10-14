# Review round 1: pc3a0vY1 (codex-repo-agents)

Snapshot: I read the eight `.codex/` files in the working tree, on branch `codex/repo-agents` (`.git/HEAD`). I couldn't confirm that the tree is exactly commit `fdcb191`, or recompute the SHA-256 values in `builds/codex-agents-20261002-161646/snapshot.json`, because I had Read/Grep/Glob only. See Limitations.
Lead lenses: contracts/compatibility; repository/documentation.
Coverage:
1. Product fit and wiring: all seven roles are there with matching `name`s. Loader evidence shows the directory is scanned (the duplicate warning fires). Model-driven invocation is untested.
2. Correctness and edge cases: the role bodies match their sources word for word except for the Codex adaptations. One of those adaptations breaks the author revision loops (F1).
3. Data and document integrity: fictional data, totals, `Meta File` stamping and the never-approve-a-real-PDF rule are kept.
4. Contracts, access and privacy: the `private/` bans are kept. The safety preamble contradicts the canonical owner rules (F1). A local-profile line was copied into tracked files (F2).
5. Tests and visible evidence: I inspected the author's positive and negative loader transcripts. Visual evidence is n/a (config only).
6. Failure handling and recovery: missing tools are treated as limitations, never as a reason to install. The sandbox can be overridden by the parent session (F4).
7. Simplicity and ownership: skills are reused, not copied. The policy text in seven prompts adds a second rule source (F1).
8. Repository and documentation: the README is clear. One leftover wording conflict (F3), and the repo map doesn't mention `.codex/` (F5).

## Findings

### F1 Material: The Codex safety preamble contradicts the canonical owner rules and stalls the author revision loops
Anchor: lines 24-28 of all seven `.codex/agents/*.toml`; `.codex/agents/magazine-editor.toml:240-243`; `.codex/README.md:63-66`; compare `docs/preferences.md:52-77` and `AGENTS.md:244-250`.
- **Scenario:** a `magazine-editor` revision round. It must recompile and re-stamp `condensed-<tier>.pdf`, its PNGs and its `Meta File`. A `ceo` revision must "fix every Blocking finding in place".
- **Expected:** `docs/preferences.md` is the only list of owner checkpoints. It names routine work agents do "without asking": clearing `builds/` by path, `reset`, force-pushing a feature branch, and so on. It lists deletions that need the owner's go, and in-repo files an agent created are not on that list. The brief says "no role-policy change".
- **Actual:** every prompt says to stop and get explicit confirmation before *deleting or overwriting files*, clearing generated content or destructive Git. It adds that "a run's revise/drop instruction does not waive this checkpoint". The `magazine-editor` drop step has changed from deleting the style folder itself to getting the owner's confirmation first. The source of this stricter rule isn't named anywhere in the repo. `.local/preferences/user-profile.md:84` only says "existing safety checkpoints still apply", and I couldn't read any harness or global instruction.
- **Impact:** read literally, the author roles must ask before every re-render or in-place edit. A subagent reports to the lead, so it can't get the owner's confirmation itself. In an unattended run (cap 10) the loop stalls. Alternatively, a dropped style's folder and README row stay behind, which breaks "a run still ends with three styles". This is a role-policy change the brief says isn't there.
- **Smallest useful fix:** in the preamble, point to `docs/preferences.md` ("What he decides and what agents decide"), plus any stricter rule from the session itself, instead of copying a list. Restore the source's drop clause. If the owner does want the stricter Codex rule, record it with attribution in the canonical document, not only in these prompts.

### F2 Minor: A line from the untracked local profile was copied into tracked files
Anchor: line 29-30 of each TOML ("End replies to the owner with a brief natural closing cue"); its source is `.local/preferences/user-profile.md:43`.
- **Expected:** `AGENTS.md:22-24` says to keep that file untracked and not copy its contents into shared documentation.
- **Actual:** the line is copied into seven tracked prompts. It also addresses "the owner", but these subagents reply to the lead.
- **Fix:** drop the clause, or replace it with a pointer to `docs/preferences.md`.

### F3 Minor: `ceo` prompt contradicts itself about having a shell
Anchor: `.codex/agents/ceo.toml:42` against `:45-46`.
- **Actual:** line 42 gives a read-only shell fallback. The board bullet still says "you have no shell".
- **Fix:** change it to "you never run the Trello helper or touch the board yourself".

### F4 Note: The sandbox setting is advisory in the owner's real setup
Anchor: `builds/codex-thread-loader-20261002-162122/transcript.json`. The parent session runs `dangerFullAccess` with approval policy `never`.
- So `sandbox_mode = "read-only"` probably won't constrain the reviewers there. `.codex/README.md:57-61` and the verification limitations already say this. No change needed.

### F5 Note: The repo map doesn't mention `.codex/`
Anchor: `AGENTS.md:180-203` (Skills and agents).
- A future session reading the map won't learn about the advisory Codex counterparts. This is optional and outside this change's stated scope (no existing files changed). Raise it with the owner.

## Checks rerun
None. Read/Grep/Glob only, as briefed.

## Evidence inspected
- Working tree on `codex/repo-agents`: all seven `.codex/agents/*.toml`, `.codex/README.md`, all seven `.claude/agents/*.md`.
- `docs/review.md`, `AGENTS.md`, `docs/preferences.md:40-89`, `.local/preferences/user-profile.md:35-87`, `.claude/skills/idea-run/SKILL.md:40-79`, `docs/work/codex-repo-agents/reviews/01-codex.md`.
- `builds/codex-agents-20261002-161646/snapshot.json`, `builds/codex-agents-verified-20261002-162303/verification.json`.
- Both loader transcripts. Fixture `name =` lines in `builds/codex-loader-20261002-162042/`: `duplicate.toml` is a second `ceo`.

## Limitations
- I could not hash files, read Git objects or diff the base and head. Snapshot identity and "no existing files changed" are taken from the author's evidence and the earlier advisory review.
- The CI run was not inspected (no external access).
- `C:\Users\jimzord12\.codex\AGENTS.md` was blocked by restricted mode, so F1's stricter rule may come from there. Even so, it should be recorded in the canonical document and not hard-coded so that it contradicts `docs/preferences.md`.
- This is a stand-in invocation: an explicit `--agents` prompt equal to the body of `.claude/agents/code-reviewer.md`, tools narrowed to Read/Grep/Glob, Opus high.

## Verdict: FINDINGS
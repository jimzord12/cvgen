# Review round 2: pc3a0vY1 (codex-repo-agents)

Snapshot: base `8551dae8270f4976a96b42b7305690731953a20a`, round-1 head `fdcb191`, current head `5177455cc1b5c7f3568eef65c7845879f3d37ff4` on branch `codex/repo-agents`. The working tree is clean and `HEAD` is `5177455`, so the files I read are that commit. I did not recompute the SHA-256 values in `builds/codex-agents-round2-20261002-163356/snapshot.json`, because hashing commands were not authorized. Git object identity covers the same need.

Lead lenses: contracts/compatibility; repository/documentation.

Coverage:
1. Product fit and wiring: all seven `name`s match `.claude/agents/*`. The round-2 diff changes only instruction text, not the schema or settings fields, so the loader evidence from round 1 still applies. A model-driven role invocation is still untested, and the author says so.
2. Correctness and edge cases: I word-diffed each source body against its TOML. The only differences are the Codex preamble and the stated adaptations: no shell becomes a read-only shell fallback, WebFetch/Read become the available web and image tools, and the design-reviewer's cliché list now points to `.codex/agents/magazine-editor.toml`, whose body is the same. One leftover inconsistency remains in the editor's drop step (F6).
3. Data and document integrity: the fictional-only, totals, `Meta File` stamping, `private/` and never-approve rules are all kept.
4. Contracts, access and privacy: F1 is resolved. The checkpoint list is gone and the prompts point to AGENTS.md, `docs/preferences.md` ("What he decides and what agents decide", which exists at line 44) and the current-session owner instructions. A role that needs confirmation sends it back to the lead. F2 is resolved: no closing-cue text and no local-profile content is left in tracked files.
5. Tests and visible evidence: the author's loader evidence was inspected in round 1. Visual evidence is n/a because this is config only and produces no PDF.
6. Failure handling and recovery: missing tools are treated as limitations and never as a reason to install. When a checkpoint applies, the role returns the exact command, paths and consequence to the lead. That is a clear failure path.
7. Simplicity and ownership: the rule list now has one source and the prompts only point to it. Skills are reused, not copied.
8. Repository and documentation: `git diff --check` is clean, all 11 files are `i/lf w/lf`, and nothing outside `.codex/` and `docs/work/codex-repo-agents/` changed. The nine-skill list in the README matches `.claude/skills/`. F5 was deferred, and that is out of this task's scope.

## Findings

### F6 Minor: The magazine-editor's drop step gives the removal job to no one
Anchor: `.codex/agents/magazine-editor.toml:44-48` against `:241-243`.
- **Scenario:** a style cannot be saved, and the owner confirms the removal through the lead.
- **Expected:** one clear actor removes the folder, the README row and the unique font family.
- **Actual:**
  - Lines 241-243 tell the editor to "drop it … follow the current owner checkpoints before those removals". That implies the editor removes the files after confirmation.
  - The editor's shell list (lines 44-45) no longer includes "removing a style folder you drop" as the source did. So the editor has no permitted way to delete the folder.
  - A Codex subagent also ends when it replies, so it cannot wait for the confirmation.
- **Impact:** a small risk that the dropped folder stays behind, or that the editor improvises a delete outside its stated shell uses.
- **Smallest useful fix:** one clause, for example "return the removal list to the lead, which removes it after the owner confirms". Alternatively, permit removal of only the confirmed paths.

### N1 Note: Current-session instructions must reach the subagent
Anchor: `.codex/README.md:36-38, 63-66`; line 26 of each TOML.
- The prompts defer to "the owner's current-session instructions". A delegated agent sees those only if Codex loads the same AGENTS.md layers for subagents (unverified) or the lead includes them in the brief.
- Optional: in the README's "Use" section, say "include any active owner checkpoints in the delegation brief".

### Earlier findings
- F1 (Material) and F2 (Minor): resolved as described above.
- F3: resolved. `ceo.toml:43` and `:71-72` now agree.
- F4: accepted, and the README still documents it at `:57-61`.
- F5: deferred with a reason. I agree that it is outside this new-file-only scope.

## Checks rerun
- `git diff --check 8551dae..5177455`: exit 0.
- `git ls-files --eol`: all LF.
- `git diff --name-only` with the in-scope paths excluded: empty.
- `git diff --no-index --word-diff` of each `.claude/agents/<n>.md` against `.codex/agents/<n>.toml`.

All of these only read the repository and write nothing.

## Evidence inspected
- At `5177455`: all seven `.codex/agents/*.toml`, `.codex/README.md`, all seven `.claude/agents/*.md`, the diff `fdcb191..5177455`, and `fdcb191:.codex/agents/magazine-editor.toml`.
- `docs/review.md`, `docs/preferences.md:44`, `.claude/skills/` listing, `.claude/skills/idea-run/SKILL.md` (drop handling).
- `docs/work/codex-repo-agents/reviews/02-claude.md` and `02-dispositions.md`.
- `builds/codex-agents-round2-20261002-163356/snapshot.json`.

## Limitations
- I did not reopen the loader transcripts this round. I rely on round 1's inspection, plus my own check that this diff changes no schema or settings line.
- No suite, Python, TOML parse or CI run was done, as briefed. The current-head CI is still pending, and old CI is not current proof.
- I could not see the owner's live AGENTS.md instructions. I took them from the brief.

## Verdict: PASS

There are no Blocking or Material findings. The author should fix or record a reason for deferring F6.
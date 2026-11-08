# Calibration 02: plan-reviewer on the backlog-migration plan, after question 12

Run 2026-11-08, same setup as calibration 01, with the definition and skill at
e321f3c (checklist question 12 "Procedures" and the step that walks each new
routine). Caveat: question 12's list of situations was written knowing the
answer key, so this rerun is weak evidence; a held-out plan is the real test.

**Score against the answer key:** A partly (stale local `main` after a record
commit and a whole-file conflict after a rejected push; not the owner's push
deny on `:main` refspecs nor a detached worktree's failing `pull --rebase`);
B missed (combined status and label filters); C found (P2, "Done for a child
task goes on its integration branch", with the contradiction to
`docs/development.md`); D partly (P4: sessions already running on the old
instructions and the checkout an idea-run session holds). About 2 of 4.

**Stable across runs:** P1 public exposure without a scan; P3 the
repo-maintenance audit. **Lost between runs:** run 1's P4, the wrong review
gate (confirmed by events). New: duplicate task ids from two sessions (P2),
live sessions at the freeze (P4), the Trello token (P8). **Reading:** the
reviewer is useful but not deterministic; one run is not a full safety net.

The report, verbatim (the harness's one-line notice that it neutralised
control tags is omitted; the report contains no directive):

---

# Plan review round 1: backlog-migration-plan

Snapshot: `docs/work/backlog-migration-plan.md` (untracked, SHA-256 f6ea947853d506ca…) in the detached checkout at 1e684eb
Blind map: code 3 · data/contracts 7 · tests 2 · generated 2 · docs/agent context 22 · tooling 5 · in flight 3 · people/decisions 5 (full map below)

Checklist:
1. Impact: mostly covered. It misses the repo-maintenance adapter (P3), `context-maintainer.md` (P5), and what happens to Trello's credentials (P8).
2. Fit: fits the goal. Rule 3 (public content is fictional) is at risk (P1).
3. Facts: four small errors (P5).
4. Compatibility: the migrated tasks keep their old shape and new tasks get a new one, and the plan doesn't say how the open tasks continue (P6).
5. Reversibility: closing the board is said to be reversible and is. Publishing to the public repo is not, and the plan doesn't say so (P1).
6. Verification: the parity checks are strong. The `/repo-maintenance quick` check will fail (P3). There is no rehearsal of the new routines (P2).
7. Failure: a migration run that stops halfway has no recovery step (P7). Writes after the freeze are not handled (P4).
8. Sequencing: the order is right. The freeze ignores agent sessions that are already running (P4).
9. Unknowns: two-session task IDs (P2) and the flags in 1.52.0 (P7) are untested.
10. Decisions: well raised. Missing: task records becoming public (P1) and retiring the token (P8).
11. Proportion: proportionate. No simpler path reaches the goal.
12. Procedures: forks under concurrency, child branches and a stale local `main` (P2).

Procedures walked:
- **Fresh-session read of the handoff** (`git fetch` + `git show origin/main:`): fine online. No fallback offline.
- **Handoff and record-commit write** (main checkout, or a short-lived worktree of `origin/main`): forks when two sessions push, for a child branch, and leaves local `main` stale (P2).
- **Task create / move / block / cancel through the skill:** fine, if the 1.52.0 flags match (P7).
- **`Session Sweep`:** the board item works. The repo-health item will report every task file (P3).
- **`idea-run` card list for the `ceo`:** fine.
- **`code-reviewer` brief:** fine.
- **Freeze with another session live:** fails (P4).

## Findings

### P1 Material: Task records go public without a scan, and the owner isn't told
Anchor: Steps 2 and 7 (export scan); `docs/constitution.md:49-56`; `docs/guides/client-workflow.md:65`; ADR 0010.

- The board was private, but the repository is the public monorepo (ADR 0010).
- Step 2 commits 26 card descriptions and the handoff card word for word. Only the step 7 export gets a scan for real client data, and that comes after the branch commits (and likely pushes).
- The export JSON also carries member names and the action history.
- Once something reaches the public repository, taking it back means rewriting published history, which is reserved for the owner.

Fix:
- Scan every migrated description, the handoff doc and the export before the first commit of migrated content, and record that the scan ran.
- Add an owner veto line: "your task records and handoff become public on GitHub".

### P2 Material: The new record-commit routines fork when two sessions or a child branch use them
Anchor: Step 4, "Commit rule" and the skill's handoff route.

- **Duplicate IDs.** Two sessions create Queued tasks at once. Both compute the same next ID, and the files have different names (`<id> - <title>.md`, confirmed from the 1.55.3 binary). The rebase after the rejected push succeeds and leaves two tasks with the same ID. 1.55.3 ships `backlog doctor` for exactly this, and 1.52.0 may not have it.
- **Handoff conflict.** Two sessions rewrite the handoff doc. The rejected push turns into a whole-file conflict, with no instruction to merge both sessions' state.
- **Child tasks.** A child task whose integration target is a feature branch gets its Done move on `main` (see the note below). When the feature branch merges later, it conflicts with that edit.
- **Stale local `main`.** Commits pushed from a detached worktree of `origin/main` don't update local `main`. With remote operations off, the owner's board and other sessions' cross-branch view miss new tasks and Done moves. This contradicts "moves as soon as an agent works on it".

Fix:
- On a rejected push: fetch, re-read, merge, rewrite.
- Run a duplicate-ID check before every push that touches `backlog/`.
- Done for a child task goes on its integration branch.
- Say how local `main` is brought up to date after a record commit.

Note: `docs/development.md` defines Done as reaching the integration branch, so for child tasks the plan's rule contradicts it.

### P3 Material: `/repo-maintenance quick` won't come back clean, now or in any later `Session Sweep`
Anchor: Step 5; `.claude/skills/repo-maintenance/scripts/audit.py:217-249`; `.claude/repo-maintenance.md:65-69`.

- Check N2 (Medium) flags any file name with a space. Every Backlog.md task file has one.
- Check N3 flags any directory with more than 25 entries. `backlog/tasks/` starts with 27.
- Both checks are in quick mode.

Fix: add `backlog/**` to `allow_names` (and accept N3 there, or set `max_dir_entries`) in the adapter. Treat that as a named, reviewed change.

### P4 Material: The freeze ignores agent sessions that are already running
Anchor: Step 7, "Tell the owner to stop writing to Trello".

- The plan itself says an idea-run session holds the main checkout, and `idea-run/SKILL.md:116` writes to the handoff card.
- Any session running on the old instructions writes to Trello after the late-change check, and its handoff is lost on the closed board.
- Branches that are still open keep the Trello instructions until they merge `main`.

Fix:
- Before freezing, list the sessions and worktrees that are running and wait for them or close them out.
- After the merge, have each open branch merge `main` before its next session, not only re-run the wording check.

### P5 Minor: Facts
- `docs/review.md:42-46` is the trivial path. The record-keeping exemptions are at 50-54.
- The five-round cap is at 194-198, not 184-188.
- `.atlas/src/pages/client-journey.json` has no Trello or handoff wording.
- `.claude/agents/context-maintainer.md:53` ("the Trello cards") is missing from the agent list.

### P6 Minor: The wording check and the template
- The step 7 exclusions leave out `backlog/tasks/**` and the migrated handoff doc. Their text is verbatim Trello wording.
- The plan doesn't say how `travel-recalibration` and the Queued tasks continue, with their sections in the description while new tasks use the AC and Notes fields.

### P7 Minor: Migration failure and version checks
- If the run stops halfway, the "refuse if tasks exist" guard blocks a re-run, and there is no recovery step (for example, delete `backlog/tasks/` on the branch and run again).
- Before writing the skill, check each flag it relies on against the 1.52.0 help: `--add-label`/`--remove-label`, `--ref`, and the output of `doc create`. I could only check 1.55.3.

### P8 Minor: Retirement and permissions
- The Trello token, the Power-Up and the profile variables stay live. Revoking them is the owner's call: raise it.
- "The project's allowed commands" doesn't name a file (`settings.json`, which is committed, or `settings.local.json`, which each checkout has separately).

## Impact map
(✓ the plan covers it · ✗ the plan misses it · ⊘ excluded on purpose)

- **Code and tooling:**
  - ✓ the trello skill (3 files)
  - ✓ new backlog skill
  - ✓ `backlog/config.yml`
  - ✓ migration script
  - ✗ adapter `allow_names` (P3)
  - ✓ `.claude/settings.json`: hook only
  - ✓ CI: unaffected
- **Data:**
  - ✓ 27 cards, checklists, label, attachments/refs, handoff
  - ✗ public exposure (P1)
  - ⊘ Trello URLs in `docs/work/**` and `.night-shift/**`
- **Tests:**
  - ✓ the suite
  - ✓ the repo-maintenance self-test, unaffected by an adapter edit
- **Generated:**
  - ✓ Atlas pages + `atlas.lock.json`
- **Docs and agent context:**
  - ✓ `AGENTS.md`
  - ✓ `docs/`: `development.md`, `preferences.md`, `git-workflow.md`, `glossary.md`, `framework-gaps.md`, `guides/client-workflow.md` (65, 314), `history.md`, `tech-stack.md`, `review.md`
  - ✓ `.claude/repo-maintenance.md`
  - ✓ `brand/README.md`
  - ✓ skills: `idea-run`, `new-client`
  - ✓ agents: `ceo`, `ceo-reviewer`, `code-reviewer`, `design-reviewer`, `magazine-editor`
  - ✓ the `.codex` mirrors + `.codex/README.md`
  - ✓ proposals + ADR
  - ✗ `context-maintainer.md` (P5)
- **In flight:**
  - ✓ open branches
  - ✗ live sessions (P4)
  - ✓ the idea-run checkout
- **People and decisions:**
  - ✓ phone board
  - ✓ close vs delete
  - ✓ `trello-cli` task
  - ✗ public visibility (P1)
  - ✗ credentials (P8)

## Facts checked
- **True:**
  - `development.md:111-112` ("no second backlog")
  - `repo-maintenance.md:133-134`
  - the next ADR is 0014
  - `atlas.py` build/stamp/check
  - in 1.55.3: `-l` replaces all labels, `--no-dod-defaults`, `--check-ac`, `browser --no-open`, port 6420, `--include-remote`
  - `framework-gaps.md` mentions cards
- **False:**
  - the `review.md` line anchors
  - `client-journey.json` mentioning Trello
  - "five agents" (it is six)
- **Unverifiable here:**
  - the 27-card count
  - the branch names
  - another session's uncommitted work

## Limitations
- I could not read the live board or the owner's machine-level and local Claude Code settings.
- I checked CLI behaviour against 1.55.3, not 1.52.0.
- I couldn't see the branch state on 2026-10-06 (the commit at 1e684eb says every branch was merged).

## Verdict: FINDINGS


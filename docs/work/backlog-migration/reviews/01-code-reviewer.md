# Review round 1 (second, focused reviewer: data migration): TASK-27 backlog-migration

**Verdict: PASS.** I found no Blocking or Material problems, three Minor and four Notes.

Snapshot: `1e684eb..0fbc85d` (a46ba0c, 0fbc85d) in the worktree `C:\Users\jimzord12\Documents\GitHub\cvgen-backlog`. HEAD was 0fbc85d and the tree was clean when I started. Partway through, six uncommitted edits appeared (SKILL.md, development.md, glossary.md, framework-gaps.md, context-maintainer.md and the handoff doc), presumably from the lead. I did not review them.

Lead lenses: (3) data and document integrity, (4) contracts, access and privacy.

Coverage:
- 1 Product fit and wiring: the CLI reads all 27 tasks. The board screenshot shows Queued 3, Active 1, Review 1, Ready 0, Done 22, plus the session-handoff doc. I did not trace the other wiring; the general round covers it.
- 2 Correctness and edge cases: the CLI shows YAML-folded titles (TASK-11) exactly, a U+00B7 middle dot is preserved (TASK-10), and commas inside AC items survive. Lines like `- [x]` inside descriptions are not read as AC.
- 3 Integrity, checked deeply: my own Python comparison against `cards.json` and `lists.json` is exact and case-sensitive, with no trimming except the final newline. All 26 tasks match on title, status, description, AC text, AC state and numbering, and each has exactly one reference, its card URL. No labels on either side, LF endings only, Trello order kept in the ids and ordinals. Three expected differences: TASK-1 is Done (the cancellation, with its note in Notes), and TASK-11 and TASK-16 lack only the card's trailing `\n`. The handoff doc body is byte-identical to the card. The snapshot holds only open cards, and its own fidelity to the live board cannot be checked offline.
- 4 Contracts, checked deeply: `config.yml` matches the plan (5 statuses, default Queued, labels `[blocked]`, auto_commit, bypass_git_hooks and remote_operations all false, check_active_branches true, no DoD list). I checked every SKILL.md command and flag against the 1.52.0 `--help` and they all exist as described, including that `-l` replaces all labels. The CLI binary skips `fetch` when `remoteOperations===false`, so the "no network" claim holds. No real client names (I checked against the three `private/` folder names), no credentials, and only the alias `client-2026-09-01` in `backlog/`. The permission allowlist covers read commands only.
- 5 Tests and evidence: the author's parity script is weak (F1). My independent comparison found no difference.
- 6 Failure handling: the migration script refuses a non-empty `tasks/` and throws on a failed create. The skill's recovery step is broken (F2).
- 7 Simplicity: proportional; one-off scripts stay out of the repo.
- 8 Repository and docs: the ADR wording runs ahead of reality (N1). The migration evidence is not persisted (F3).

## Findings

### F1 Minor: the parity script would miss case-only differences
Anchor: scratchpad `parity.ps1` (title, status, description and AC comparisons)
- Scenario: a title or description changes only in letter case.
- Expected: reported as a FAIL. Actual: PowerShell `-ne` ignores case, so it passes.
- The script also never checks label mapping or the exact set of files.
- Impact: none today, since my exact check is clean. But step 7 reruns this script for late-changed cards.
- Fix: use `-cne`, and assert the label mapping and the expected set of task files.

### F2 Minor: the skill's recovery command fails in a detached worktree
Anchor: `.claude/skills/backlog/SKILL.md:79,85-86`
- Scenario: the push is rejected and the agent runs `git pull --rebase` inside the worktree made with `--detach`.
- Actual: git refuses with "You are not currently on a branch".
- Fix: `git pull --rebase origin main`, or `git fetch origin; git rebase origin/main`.

### F3 Minor: the step 7 late-change check depends on files in a temporary folder
Anchor: TASK-27 (no notes); plan step 7, "Late-change check"
- The check needs the step 2 snapshot time, 2026-10-06T07:24:16Z. That time and the parity output exist only in the session's temporary scratchpad, which may not survive into the session that runs step 7.
- Fix: append the snapshot time and the parity summary (26 ok, handoff ok, 0 failures) to TASK-27's notes.

### N1 Note
ADR 0014 says in past tense that the board "was exported … and closed". That becomes true only at step 7, so the merge must stay after step 7, as the plan says.

### N2 Note
Ten Done tasks keep their acceptance as `- [x]` lines inside the description, because the cards had no checklists. That follows the verbatim rule; the only effect is that those tasks show no AC count.

### N3 Note
The CLI and browser still offer built-in priorities (High, Medium, Low) and task types, even though the config lists none. Harmless.

### N4 Note
The snapshot holds only open cards' name, description, checklists and labels. For step 7, the export should ask for closed cards, actions (comments) and attachments. That export becomes the only copy of any comments.

## Checks rerun
- My exact, case-sensitive comparison (Python, piped in on stdin; it wrote no file): 26 matched with only the expected differences, handoff byte-identical. Output only in my session.
- `backlog --version` (1.52.0), `task list --plain`, `task list -s Active -s Review -s Ready`, `task list -l blocked`, `task view TASK-14`, `search`, `doc list`, `doc view`, and `--help` for task list, task edit, task create, search and browser: all exit 0, no writes.
- `python tests/run.py` was not rerun. My attempt aborted before the suite started (no `builds/` folder was created). By then the tree no longer matched the snapshot, so I did not retry.

## Evidence inspected
- At 0fbc85d: `backlog/**`, `.claude/skills/backlog/SKILL.md`, `.claude/settings.json` diff, `docs/review.md` diff, ADR 0014, `docs/work/backlog-migration/plan.md` and `reviews/00-plan.md`.
- In the scratchpad: `cards.json`, `lists.json`, `migrate-trello.ps1`, `parity.ps1`, `parity-step3.txt`, `snapshot-time.txt`, `backlog-board.png`.
- The author's suite report `builds/tests-20261006-103428-926766/report.json`: passed.

## Limitations
- The suite evidence is author-run. It ran at 10:34, before 0fbc85d was committed at 10:37, and records no revision.
- I could not compare the snapshot with the live board (no external access).
- Lenses 1, 7 and 8 were covered only briefly; the general reviewer covers them.
- The concurrent uncommitted edits were not reviewed.

## Verdict: PASS

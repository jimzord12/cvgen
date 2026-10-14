## Review round 3 (context round 1): context-reviewer, 2026-10-14

Snapshot: `9a8ed1c...41c9b4d` in `.worktrees/task-28`. Lead lenses: proposal rules live once in the README, mirrors agree, orientation consistent; metadata-only edits, Atlas citations right.

Verdict: PASS. Recorded in substance (formatting condensed).

Checked: rules live once in `docs/proposals/README.md`; AGENTS.md, the idea-run skill and the ceo agent point at it; both ceo files carry the same line; the 17 files gained only `id` and `created`, no body or status change (`created` checked against git for four files); LF; `atlas check --strict` exit 0; the script prints the expected line; verification.md item 14 matches `tests/proposals.py`; code R1-2, R1-4, R1-5 fixed in the text.

Minor
- M1: `docs/development.md:36-44` fresh-session steps omit the script, and the `Session Sweep` "Proposals" line (`:72-73`) still scans for `status: approved` by hand. Fix: add the script to step 2; optionally use its approved-not-applied count in the Sweep.
- M2: `docs/proposals/README.md:29,33` template uses real values (`P-0018`, `2026-10-14`). Fix: `P-NNNN`, `YYYY-MM-DD`.
- M3: README:46-48 lists only some refusal rules. Fix: "refuses by name any file that breaks the rules above".
- M4: README:38 uses "the snapshot's `next_id`" before "snapshot" is defined. Fix: "take `next_id` from `python scripts/proposals.py --json`".
- M5: ceo (`.claude/agents/ceo.md:85`, `.codex/agents/ceo.toml:111`) writes `created` while the idea-run skill (`SKILL.md:16`) has the lead set it to the move date. Fix: the ceo leaves both `id` and `created` to the lead, in both mirrors.
- M6: `.atlas/src/pages/change-review.json:49` cites README:46-51 but not the "tell the owner its line" rule at README:91-93. Fix: add `docs/proposals/README.md:89-97`, build, stamp.

Notes
- AGENTS.md:52 reflow dropped "still"; harmless.
- References carry `id` but no `created`; clear enough.
- AGENTS.md grew by one line; nothing blocks the planned trim.

## Dispositions (lead)

- M1 (both parts), M2-M6: fix. Notes: accepted.

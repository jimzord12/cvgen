## Review round 2 (context): context-reviewer, 2026-10-14

Snapshot: `4d1eae7`, `git diff origin/main...HEAD` (main `362f004`). Lenses: round-1 fixes and anchors; whether TASK-38 to TASK-40 can build on these facts.

Verdict: FINDINGS (1 Material). Recorded in substance (formatting condensed).

Re-run: `bun run check` OK on 8 files; `bun test` 24 pass; `proposals.py` 1 pending, P-0018 does not collide; `atlas check --strict` exit 0; 683 anchors resolve and stay in range; no `Alias` or client name; LF. About 90 cited ranges read, including every anchor into `build-a-cv.md`, `framework-gaps.md`, verify-cv `SKILL.md`, `export.py`, `render.py`: all say what the entity claims.

Round 1: findings 1-5 and minors 6-9 fixed; 3 acceptable as done (the link from `intake.no-consent` is text only, but `after.stall-check` reads `art.envelope-readme`, then erase, then `after.close`); the Note fixed indirectly (`research.follow-up-write` reads `art.decisions-md`).

Material
1. `docs/proposals/workflow-gaps.md:29`: item 1 opens "Keep what the YAML holds" then recommends values the YAML does not hold (research rounds "3, or 6 for an executive", while `loop.research-rounds` holds `{attended: 3}` and `GAPS.md:25` says a second cap cannot express 6; "no cap on the owner's own change rounds", while `loop.owner-changes` has cap 5), and treats the `Deep Dive` count as a round count. Fix: split into keep-as-held and change, and say how each change is encoded.

Minor
2. `docs/workflow/GAPS.md:3` "`main` after TASK-58" is stale.

Notes
3. `02-intake/stage.yaml:140-145`: `intake.no-consent` has no outputs; TASK-38's flow check needs a rule for owner-decision endpoints.
4. `builds/task-37-refs/check_refs.py` is in ignored `builds/`; the TASK-38 note should say it must be rebuilt.
5. Mixed line endings in the working copy of `01-context-reviewer.md` only; index is LF.

## Dispositions (lead)

- 1: fixed by the lead: item 1 split into 1a (four loops kept as held), 1b (research rounds stay 3 for everyone; the owner decides at `research.cap-reached` whether an executive gets more; no second cap) and 1c (owner changes: cap 5 kept as a check-in at `deliver.cap-reached`); the problem line says nine points.
- 2: fixed (`main` at 362f004, after TASK-47).
- 3, 4: moved to TASK-38's notes. 5: nothing to do.

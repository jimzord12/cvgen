## Review round 1 (context): context-reviewer, 2026-10-14

Snapshot: `e5d9b02` against `70631ed` in `.worktrees/task-37`. Lead lenses: faithfulness (27 sampled entities, anchors read); usefulness and placement of the gaps.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Checked: the owner's nine decisions applied as recorded (#1 Export-date wording, #2 `ready`, #3 12 months plus keep request, #4 every CV gets a `design-reviewer` round, #5 the lead exports, #6 engine changes through `code-reviewer`, #7 task plus `after.close`, #8 stamp refusals, #9 no `text-NN`); gates binary; per-item `when` text consistent; four implicit steps present; `bun run check` passes on all 8 files; `atlas check --strict` exit 0; LF; no client named.

Material
1. Placeholder loop caps look like sourced facts once parsed (`03-research/stage.yaml:257-269`, `04-text-draft/stage.yaml:120-127`, `06-deliver/stage.yaml:162-183`): the only marker is a YAML comment; e.g. "owner changes: cap 5" is sourced to `docs/review.md:198-202`, which is about reviewer rounds; `loop.research-rounds` cap 3 is wrong for an executive (6 Deep Dives). Fix: cite GAPS.md and mark "(placeholder cap)" in the name, or set a convention in TASK-38 before anything renders.
2. Anchors drift once merged (TASK-58 moved lines in `build-a-cv.md` and `framework-gaps.md`): `05-design/stage.yaml` lines 161, 173, 182, 193, 344, 464, 584, 593, 603. Fix: merge main, re-anchor, re-run the reference script.
3. Stalled and no-consent clients have no way out (`07-after/stage.yaml:62,70,79`, `02-intake/stage.yaml:139-144`): erasure is gated on a passed delete-by date, but `client-workflow.md:333-338` names such clients to the owner so he can delete them; `intake.no-consent` leads nowhere; `after.close` unreachable for them (against decision #7). Fix: widen the `when` texts or record a gap.
4. `docs/workflow/GAPS.md:11-57` sits outside where owner decisions and task work are tracked: items 1-8 are owner decisions without recommendations, invisible to `scripts/proposals.py`; the "For TASK-38/43" lists are a second backlog. Fix: decisions with recommendations as a pending proposal; move task items into the tasks' notes; GAPS.md may stay as the explanatory record the YAML points to.
5. `docs/glossary.md:87` still says the facts are planned (TASK-37).

Minor
6. `GAPS.md:63-64` says code refusals stay in the action's description; `cmd` actions have none, so the approve and export refusals are not encoded. Say so.
7. `04-text-draft/stage.yaml:2` stage id `text` vs folder `04-text-draft` and the glossary's `Text Draft`.
8. `manual.decide-at-cap` (`catalog.yaml:127-133`) uses reviewer language but also escalates client draft corrections and the owner's own changes.
9. `05-design/stage.yaml:10` "(stage text)" reads as a typo.

Note
- `03-research/stage.yaml:166`: `research.follow-up-write` takes no Deep Dive input though the follow-up carries research questions.

Sampled: 24 OK; 3 OK at base but drifting on main (`gate.template-fits`, `design.port-concept`, `design.engine-change`); not OK: placeholder loops (`loop.research-rounds`, `loop.library-review`, `loop.draft-correction`, `loop.revision-fix`, `loop.owner-changes`) and the stalled-client path (`intake.no-consent`, `after.erase-envelope`, `after.close`).

## Dispositions (lead)

- 1: fix in the facts: each placeholder loop names itself "(placeholder cap)" and cites its GAPS.md line; research rounds cap recorded as a gap (base 3, executive 6).
- 2: fix: merge main, re-anchor, re-run the reference script.
- 3: fix: widen the erase/close `when` texts to "or the owner decides to delete a client who never reached `Export`", sourced to `client-workflow.md:333-338`; `intake.no-consent` leads there.
- 4: fix: owner decisions become a pending proposal `docs/proposals/workflow-gaps.md` (id from `scripts/proposals.py --json` next_id), each with a recommendation; TASK-38 and TASK-43 items move into those tasks' notes; GAPS.md stays explanatory and points to both.
- 5-9 and the Note: fix (7: rename the stage id to `text-draft`).

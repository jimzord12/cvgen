## Context review round 3: TASK-74 (plan-reviewer)

**Snapshot:** 1e00f50..9929b69, limited to `.claude`, `docs`, `.atlas` and `backlog/tasks/task-74*`. I read the plan revision and TASK-75 to 78 as context only.

**What I expected before opening the diff:** the round 2 fixes stay inside their owners. The re-anchored citations point at the same facts they cited at 9b06670. The two glossary rows define what the skill and `review.md` already mean, without adding a rule. No other citation into `glossary.md`, `review.md` or `development.md` moves.

### Round 2 fixes
- **M1 holds.** `SKILL.md:136-142` now reads "such as … and any other the sources hold". It adds the data-schema case (a value that is optional, repeated or missing), so the question now fits a data schema as well as a process graph.
- **m1 holds.** `development.md:31-32` now points to the skill's "When a plan is needed" and no longer keeps its own copy of the list.
- **m2 holds** for the three passages I named.
- **N2 is answered** by the `Plan` row.

### Re-anchoring
I compared `review.md` at 9b06670 with 9929b69, line by line:
- 20-27 → 23-30, 197-204 → 248-255, 205-209 → 256-260 and 229-232 → 283-286 are the same text, moved.
- 192-209 → 242-260 is the edited loop. Only step 1 changed (it now also names the `plan-reviewer`). The facts that `gate.engine-review` and `agent.code-reviewer` rely on still hold: a fresh `code-reviewer`, fix and re-review, PASS, and the caps.
- `review.md:7-9` did not move.
- The new glossary rows sit at lines 84-85. Every glossary citation in `docs/workflow/` and `.atlas/src/` is at line 81 or earlier, so none moved.
- The record's count is right: 4 spans moved (12 references) and 1 span was edited.

**Checks I reran:**
- `bun run anchors 9b06670`: 379 citations, 0 moved, 0 edited.
- `bun run check`: OK at levels 1 and 2.
- LF line endings in all eight files I counted.

### Glossary rows
- **`Plan`:** the meaning, the code name, and what it is not (its source, and a task's `--plan` field) agree with `development.md:29-33` and `review.md:82-91`.
- **`Impact Map`:** its rings match the skill's table (`SKILL.md:45-54`). The claim that the reviewer builds its own map before reading the `Plan` matches `plan-reviewer.md:38`.
- Both rows follow Rule 3: one meaning, where the term lives, and a date. Rule 4 is the lead's to meet in the next report.

### Minor

**m1. The client-journey Atlas page is STALE again, and the task record says it is stamped.**
- Where: `backlog/tasks/task-74 - ….md:69` and `.atlas/atlas.lock.json`.
- What: 6452dec stamped client-journey, then 9929b69 changed `docs/glossary.md`. `python .atlas/_kit/atlas.py check` now reports `STALE client-journey docs/glossary.md`. It also adds `glossary.md` to the stale sources of design-run and system-map. The record still says only the four hand-written pages stay STALE, and the stale map in `atlas.data.js` is out of date.
- Why it matters: the cited glossary lines did not move, so nothing on the page is wrong. But someone reading the record would trust a stamp that no longer holds, and the `Session Sweep` would flag it. TASK-78 AC 2 (atlas check passes) would catch it eventually.
- **Smallest fix:** in `tools/workflow`, run `bun run atlas` again and stamp client-journey. Alternatively, change the note to say client-journey is also stale until T5.

### Notes

- **N1. Two paragraphs still end on a short line, apparently to keep the line count stable:**
  - `docs/development.md:37` ("never a label or a date. Every")
  - `docs/review.md:282` ("instead. Never report an")

  This looks deliberate: `review.md:283-286` is a cited span, and the Atlas cites `development.md:24-59`. That is a fair trade. The cleaner route is to re-wrap and run `anchors --fix`, as 6452dec did. No change needed now.
- **N2.** `review.md:82-84` keeps its own short list of when a plan is needed, next to the pointer. Round 2 accepted this, and it matches the skill except that it puts the owner's request in the next clause. It is not a finding.
- **N3.** I did not check that the four hand-written Atlas pages' citations into `review.md` and `development.md` still hold, because the record defers them to T5 (TASK-78). They do need that re-check, since `review.md` grew by about 50 lines above some of them (for example roster `review.md:138-153`).

Nothing in the diff identifies a real client. No file outside the feedback's reach was touched in my scope.

Verdict: PASS

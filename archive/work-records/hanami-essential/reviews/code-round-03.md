# Review round 3: TASK-79 (hanami-essential)

Snapshot: worktree `C:\Github\cvgen\.worktrees\hanami-essential`, head 39f096a. The tree was clean. I reviewed `git diff 8f1ee01..39f096a`, which covers two commits:
- da4c58c: decoration.py, tests/run.py, framework-gaps.md, the TASK-79 record, and code-round-02.md.
- 39f096a: framework-gaps.md and stamp.typ.

Lead lenses: (6) failure handling, (5) tests.

Coverage:
1. Wiring: OK. `decoration_errors` still has one production caller, `render.py:196`, which passes `choice.get('template')` and `choice.get('variation')`. Round 2 showed that `choose` always records a Variation for hanami; nothing in this delta changes that.
2. Correctness: OK. The values I probed are listed under lens 6.
3. Integrity: n/a. Neither revisions nor approval changed.
4. Contracts: OK. The stamp assert's condition is unchanged; only its message changed. The suite matches on "wider than the stamp's inner disc" (`run.py:408`, cases long-native and long-stamp-kanji), and that substring is still in the new message.
5. Tests: OK, see below.
6. Failure handling: OK, see below.
7. Simplicity: OK. Switching from an allow-list to an exempt-list is one line.
8. Repository and docs: OK. LF endings are confirmed on all four changed files. Round 2's report is stored unchanged. The gap entry and the docstring now say showcase only. The petal count now reads "those that met the twin's words". Note N1 is below.

**Lens 6: can a showcase render skip the check?** No. `decoration.py:71` reads `template not in PETAL_TEMPLATES or variation in PETAL_EXEMPT.get(template, set())`. I ran `decoration_errors` in-process against this run's `travel-petal-probe.pdf`:
- hanami with None, 'showcase' and a made-up 'compact': 2 errors each. A future Variation is checked by default, which fixes round 2's N1.
- hanami with 'essential': 0.
- flagship/None, None/None and marine/'essential': 0. These leave at the `PETAL_TEMPLATES` test before reaching `.get`, so the `set()` default only matters if a future petal Template has no exempt entry, and then it checks everything.

A future Variation that draws petals cannot skip the check silently. Its only way out is to be added to `PETAL_EXEMPT`, which is a deliberate edit.

**Lens 5: does the new assert catch a skipped showcase?** Yes. With `'showcase'` added to `PETAL_EXEMPT['hanami']` in-process (no source edited), the call with None still gave 2 errors but the call with 'showcase' gave 0. So the conjunction at `run.py:361` fails. The round 2 mutant (`variation is not None` skips every named Variation) would also give 0 for 'showcase' and fail it. This fixes round 2's F1.

**Round 2 dispositions:**
- F1: fixed (`run.py:361`), and I proved it with the mutant above.
- F2: fixed (`framework-gaps.md:138`, `decoration.py:4`).
- N1: fixed (`PETAL_EXEMPT`).
- N2: the task record now lists the code rounds.
- N3: kept as a Note, as recorded. I accept that.

## Findings

### N1 Note: the travel-domain round 3 notes are recorded only in a commit message
Anchor: commit 39f096a; `archive/work-records/travel-domain/reviews/code-round-03.md` N-1, N-2.
- **Scenario:** a later reader looks for what happened to travel-domain round 3's N-1 and N-2.
- **Expected:** a one-line disposition in a task record.
- **Actual:** only the commit subject records it. Both items were Notes, so nothing is owed.
- **Smallest useful fix (optional):** add one line to the TASK-79 notes, "travel-domain code round 3 N-1, N-2 applied in 39f096a".

No Blocking, Material or Minor findings.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py` on the clean tree at 39f096a: exit 0, "PASS: 268 compilation cases", 25 workflow checks passed, 0 failed. Evidence is in `C:\Github\cvgen\.worktrees\hanami-essential\builds\tests-20261108-141852-950248`. The log is at `C:\Users\jimzord12\AppData\Local\Temp\claude\0bad7b43ffb974fe\bd07fd7a-826f-4da0-ace1-f4e996f70146\scratchpad\run.log`.
- `ruff check`: exit 0, "All checks passed!"
- In-process probe and mutant: `C:\Users\jimzord12\AppData\Local\Temp\claude\0bad7b43ffb974fe\bd07fd7a-826f-4da0-ace1-f4e996f70146\scratchpad\probe.py`, run with `-I` against `builds\tests-20261108-141852-950248\travel-petal-probe\travel-petal-probe.pdf`. It wrote no files.

## Evidence inspected
All at 39f096a:
- `packages/cv-workflow/cv_workflow/decoration.py`
- `packages/cv-workflow/cv_workflow/render.py:185-199`
- `packages/domains/travel/templates/hanami/components/stamp.typ`
- `tests/run.py` (lines 355, 361, 399-408, 419)
- `docs/framework-gaps.md:135-139`
- the TASK-79 record
- `archive/work-records/hanami-essential/reviews/code-round-02.md`
- `archive/work-records/travel-domain/reviews/code-round-03.md`

## Limitations
- The mutation test was an in-process monkeypatch. I did not run the suite on mutated source.
- I ran no `cv.py render` under `private/`.
- Design quality is outside this round.

## Verdict: PASS

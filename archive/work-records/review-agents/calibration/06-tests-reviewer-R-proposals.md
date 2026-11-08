# Tests review round 1: tests-proposals

I ran as a general-purpose agent, because the `tests-reviewer` subagent type is not registered in this session. I followed `C:\Github\cvgen\.worktrees\probe-20261108-164120\.claude\agents\tests-reviewer.md`, the `test-principles` skill, `docs/review.md` ("Tests review" and "Reviewer boundaries") and `docs/engine/verification.md` ("Probing a test"), all read inside the probe copy.

Snapshot: the whole of `tests/proposals.py` at `0bdfc98`, reviewed as if it were new (there is no base). Copy: `C:\Github\cvgen\.worktrees\probe-20261108-164120`, detached at `0bdfc98`.
Clean run: `builds/tests-clean` in the copy passed (211 cases, all 17 `proposals:` checks passed).

| Test | Claims to guard | Judged by | Verdict |
|---|---|---|---|
| summary line on a fixture folder | Exact line; each state has a different count; the 7-day stale boundary; references not counted | F2 caught | keep |
| JSON snapshot | Item fields, ids from the opening block only, age 0 on today, `next_id` = highest id + 1, summary = stdout | F3 survived; reading | fix (T3) |
| snapshot refuses an existing folder | Exit 2, nothing on stdout, old file's bytes unchanged | F6 caught | keep |
| refuses missing-id | The id rule | F1 survived (only "missing" is tested) | fix (T1) |
| refuses invalid-revision | The revision rule | F4 survived (only a non-number is tested) | fix (T2) |
| refuses pending-in-rejected / rejected-in-place | `rejected/` rule, both ways | F7 caught | keep |
| refuses future-created (with `today-idea` accepted in VALID) | `created` may not be after today; today itself is allowed | F8 caught | keep |
| other refusals (invalid/missing status, duplicate id, reference with status, unknown kind, missing/invalid created, no opening block) | One rule each, by file and message | reading | keep |
| docs/proposals/ is valid | Real proposals are valid and add up, through the default folder | F9 caught | keep |

## Probes
All probes changed `scripts/proposals.py`, one commit each, with the copy returned to `0bdfc98` before the next.

| Id | Kind | Target | Diff (short) | Outcome | Evidence |
|---|---|---|---|---|---|
| F1 | fault | id rule | `ID.fullmatch(pid)` -> `ID.match(pid)` (accepts `P-00012`, `P-0001x`) | **survived** | `builds/tests-F1`, PASS |
| F2 | fault | stale boundary | `age_days > STALE_DAYS` -> `>=` | caught, `tests/proposals.py:80` | `builds/probe-F2.log` |
| F3 | fault | `next_id` | count only `kind == 'proposal'` ids | **survived** | `builds/tests-F3`, PASS |
| F4 | fault | revision rule | a missing revision is accepted (rule only checked when the field is present) | **survived** | `builds/tests-F4`, PASS |
| F5 | fault | every problem named | `for problem in problems[:1]` | **survived** | `builds/tests-F5`, PASS |
| F6 | fault | refuse an existing folder | `exist_ok=True` | caught, line 99 | `builds/probe-F6.log` |
| F7 | fault | `rejected/` rule | checked one way only | caught, `pending-in-rejected` | `builds/probe-F7.log` |
| F8 | fault | future `created` | `created >= today` | caught, line 79 (`today-idea`) | `builds/probe-F8.log` |
| F9 | fault | default `--proposals` | default changed to `docs/proposals/rejected` | caught, line 112 (only the real-data check reaches it) | `builds/probe-F9.log` |
| R1 | refactor | parsing / reading | `metadata()` split into `_closing`, `_pairs`, `_title`; `read` renamed `collect` | full pass: not tied to code structure | `builds/tests-R1` |

For each survivor, `report.json` shows all 17 `proposals:` cases ran and passed.

## Findings
### T1 Material: the id rule is tested only for a missing id, not a malformed one
Anchor: `tests/proposals.py:52`; `scripts/proposals.py:51`.
F1 survived: an id like `P-00012` or `P-0001x` would be accepted, and a malformed id would also break `next_id` (`int(i['id'][2:])`). The rule is "missing or not P-NNNN"; only the first half is tested.
Smallest fix: add a BROKEN case such as `'bad-id': ({'long.md': proposal('P-00012', ...)}, "long.md: id 'P-00012' is missing or not P-NNNN")`.

### T2 Material: the revision rule is tested only for a non-number, not a missing revision
Anchor: `tests/proposals.py:63`; `scripts/proposals.py:68`.
F4 survived. The `proposal()` helper always writes a `revision:` line, so no case can leave it out.
Smallest fix: let `revision=None` drop the line, as `id` and `status` already do, and add a `missing-revision` case expecting `"revision None is not a whole number"`.

### T3 Material: `next_id` is not tested when the highest id belongs to a reference
Anchor: `tests/proposals.py:94`; `scripts/proposals.py:123`.
F3 survived: the highest fixture id (P-0030) is a proposal, so leaving references out of `next_id` goes unnoticed. That fault would hand out an id a reference already holds, which `docs/proposals/README.md` forbids ("never reuse one"). In the real folder today, `next_id` comes from proposal P-0019, so nothing shows it.
Smallest fix: give a reference the highest fixture id (for example a reference at P-0031) and expect `next_id == 'P-0032'`.

### T4 Minor: no case has two bad files, so "every problem named" is unguarded
Anchor: `tests/proposals.py:103-108`; `scripts/proposals.py:107-111`.
F5 survived. The refusal itself still happens, so only the diagnostics would get worse. Smallest fix: one case with two bad files that asserts both file names and `2 file(s)`.

### T5 Note: the refusal for a `--proposals` path that is not a folder is untested
`scripts/proposals.py:103`; low risk.

### T6 Note: the default `--json` output folder is never exercised
Every `--json` call passes `--output`. The default is `builds/proposals-<timestamp>/`, and a broken default would only show up in use. A test would have to write under the repository's `builds/`, so this may be fine left alone.

### T7 Note: the existing-folder case reads the system clock
Line 98 passes no `--today`, so the script uses today's date. That is also what makes the byte comparison mean something: the snapshot's dates differ from the first run's, so an overwrite would change the bytes. Exit code 2 catches the fault anyway (F6). It is deterministic for any clock after 2026-10-14. A comment would help; adding `--today` would weaken the byte check.

## Missing tests
All go through `scripts/proposals.py` on the command line, as fixture folders under the existing `proposals/` folder:
- id rule: a malformed id is accepted (T1).
- revision rule: a missing revision is accepted (T2).
- `next_id`: reference ids left out, so an id is reused (T3).
- several bad files: only the first is named (T4).

## Limitations
- I did not probe the 7-day stale threshold from above (no fixture at exactly 8 days). A fault there changes the threshold's printed text and is unlikely; judged by reading.
- I did not probe the oracle that recounts the real proposals. It repeats the script's counting, but F9 shows what that check adds: the default folder and the real data.
- No Bun probe was needed.
- Each probe commit was undone by checking the copy out at `0bdfc98` again; those commits were never on a branch.

## Verdict: FINDINGS
Three Material findings (T1-T3), one Minor (T4), three Notes (T5-T7). The tests present are honest and hold up: every fault aimed at them was caught (F2, F6, F7, F8, F9) and the refactor passed (R1). What fails the bar is three refusal and `next_id` faults that no test covers.

---

## Lead's disposition

This was a real-world run with no answer key; the plan's TASK-75 evidence asks
for `tests/proposals.py` "reviewed for real".

- **Is it useful?** Yes:
  - It probed what each check claims instead of counting tests.
  - It kept every check that held up (5 faults caught; the refactor passed).
  - It asked for no test for its own sake, and named only four missing cases, each tied to a fault that survived.
  - It did not recommend removing the recount of the real folder, because F9 shows what that check adds.
- **Checked by the lead:** T1 is true from the file alone. The BROKEN cases test an id only when it is missing, never when it is malformed, and `ID.fullmatch` is the only guard.
- **What happens to the findings:** T1 to T4 are gaps in an existing test, not in TASK-75's change, so they go to the D17 audit task as known items. TASK-75 rewrites no existing test (its boundary).

# Tests review round 1: test-hardening (proposal summary, engineer combined service, anchors line mapping)

There was no registered `tests-reviewer` type in this session, so I ran as a general-purpose agent. I followed `.claude/agents/tests-reviewer.md`, `.claude/skills/test-principles/SKILL.md`, `docs/review.md` ("Tests review", "Reviewer boundaries") and `docs/engine/verification.md` ("Probing a test"), all read inside the probe copy.

Snapshot: 7e341a0..56bc339; copy: C:\Github\cvgen\.worktrees\probe-20261108-163112 at 56bc339. The copy is left detached at 56bc339 with a clean tree.
Clean runs:
- Python: `builds\tests-clean-r1` passed, with 212 compilation cases plus PDF/data/layout assertions.
- Bun: `bun test` passed, 110 of 110.

| Test | Claims to guard | Judged by | Verdict |
|---|---|---|---|
| tests/proposals.py:79-86 "summary counts every state and the stale ones" | Summary line counts each state and the stale pending proposals | P1 | remove |
| tests/run.py:299-302 combined service, Pelagic Shipping | A company's combined service is the sum of its vessels' months | P4 (masked path), reading | keep, fix (Minor) |
| tools/workflow/test/anchors.test.ts:38-42 "a cited line is mapped through the diff's hunks" | `anchors` maps a cited line through the diff's hunks | P2, P3 | fix (rewrite) |

## Probes
| Id | Kind | Target | Diff (short) | Outcome | Evidence |
|---|---|---|---|---|---|
| P1 | fault | proposals summary, stale count | `scripts/proposals.py` summary: `age_days > STALE_DAYS` changed to `>=` (576d9a1) | **survived**: the new check (line 85) passed; the older literal check at line 90 failed next ("4 older than 7 days") | builds\tests-P1 |
| P2 | fault | anchors line mapping | `anchors.ts` mapLine: `return line + shift` changed to `return line` (240e0e5) | **survived**: the new test passed by name (`-t "mapped through"`); 4 older anchors tests failed | Bun output |
| P3 | refactor | anchors, private helper | rename `mapLine` to `whereNow`, behaviour unchanged (a4c2276) | **structure-sensitive**: the full Bun suite ran 109 pass and 1 fail, and the 1 failure is the new test | Bun output |
| P4 | fault | company combined service | `data.typ:31`: `known.slice(1)...sum` drops the first vessel (6998639) | **masked by check 2** (raster and text mismatch, run.py:295). On the masked path (77cd383: probe PDF over the v11 reference, pin updated) the rerun was **caught** by the new check at run.py:302 | builds\tests-P4, builds\tests-P4b |
| P5 | fault | anchors, deletion or edit before a cited line | mapLine: `shift += h.newCount - h.oldCount` changed to `shift += h.newCount` (f07f8f8) | **survived the whole Bun suite**: 110 pass, the new test included | Bun output |

## Findings

### T1 Material: the new proposals check takes its expected value from the code under test
Anchor: tests/proposals.py:80-86. The code it exercises is `scripts/proposals.py` `summary()` and `read()`.
- **Problem:** the check compares the CLI's output with `script.summary(script.read(...))`, which comes from the same module. The expected value is the code itself, so any counting fault in `summary` or `read` agrees with itself.
- **Evidence:** P1 survived, and the existing literal check at line 90 caught the fault instead. The check also goes around the CLI, importing the script as a module, which goes against rubric question 1.
- **Consequence:** the check cannot fail for the behaviour it names, and it duplicates line 90. That literal check already pins every count, and the fixture is built so that every count is different.
- **Smallest fix:** remove lines 79-86 and the `importlib.util` import. Reason for removal: the check cannot fail for a counting fault (P1), and line 90 catches that fault.

### T2 Material: the new anchors test checks the source code, not what `anchors` does
Anchor: tools/workflow/test/anchors.test.ts:38-42 and src/anchors.ts:33, 43.
- **Problem:** the test reads `anchors.ts` as text and checks that two private function signatures appear in it. That is a change detector that tests the code's structure, not its behaviour.
- **Evidence:** it passed when the mapping was broken (P2), and it was the only test to fail on a rename that kept behaviour (P3).
- **Smallest fix:** rewrite it through `anchors()` in the throwaway Git repository the file already sets up. Make it cover the fault P5 shows is untested (see Missing tests). One example: delete lines 1-2 of `notes.md` and expect `MOVED notes.md:4-5 -> notes.md:2-3` and `MOVED notes.md:8 -> notes.md:6`, with `notes.md:2-3` reported as EDITED.

### T3 Minor: the combined-service check reads a company with one vessel-type group
Anchor: tests/run.py:299-302, which exercises data.typ:9-33 and experience.typ:13-28.
- **What is good:** the expected value "2 years 2 months" is written as a fact. P4 shows the check is the only check outside the frozen ones that catches a wrong company sum on the engineer example. It is worth keeping, because check 2 would agree with a wrong sum after a future re-approval of the reference.
- **Weakness, judged by reading:** Pelagic Shipping has a single group, so a fault that sums only the first group (`company.groups.at(0).ships`) leaves its total unchanged and would pass. Northline Marine has two groups (8+7+6+6 and 5+4, 36 months, shown as "3 years"), so asserting its phrase too would catch that fault.
- **Also:** the assertion pins the order in which the PDF text comes out across columns. That is acceptable here only because check 2 already freezes this page.

## Missing tests
- **anchors line mapping, edits and deletions before a cited line:** the fault is that the shift ignores the lines a hunk removes (`h.oldCount`). P5 survived all 110 Bun tests. The test should go through `anchors()` with a deletion, or a 2-line to 1-line change, above a cited range, and expect the exact MOVED target.
- **anchors line mapping, several hunks before one cited line:** the fault is that the shift is not added up across hunks. The test should go through `anchors()` with one insertion and one deletion above the same anchor, and expect the net shift.
- **Proposals summary:** nothing is missing. Line 90 already covers it.

## Limitations
- I ran as a general-purpose agent, not the registered subagent type.
- I did not probe T3's single-group weakness; I judged it by reading, because it would have needed two more full Python runs.
- The P4 masked-path commit existed only in the probe copy.
- I did not check `ruff`.

## Verdict: FINDINGS
T1 and T2 are Material. T3 is Minor. There are two missing anchors tests.

---

## Lead's scoring against `05-tests-reviewer-answer-key.md`

- **S1: hit.** Material, remove, backed by a fault probe that survived (P1, the same fault as K1).
- **S2: hit.** Material, backed by a refactor probe that fails the test by name (P3). It was also shown unable to fail (P2). The verdict is "rewrite through `anchors()`" rather than "remove"; that is the better fix, because the rewrite covers a real gap (P5).
- **S3: hit.** Kept, with the masked path run through to **caught** (P4, a different fault from K3). The Minor finding (single group; text extraction order) is the acceptable kind the key names.
- **Score: 3 of 3**, with no false positive. That clears the D14 bar.
- **Procedure:**
  - A clean run came first in both suites.
  - The copy was left at `56bc339` with a clean tree.
  - No branch or stash was added (checked: 6 branches, empty stash).
  - Each probe was its own commit.
- **Beyond the key:** P5 is a real gap in the existing `anchors` tests. If a hunk's removed lines are ignored in the shift, all 110 Bun tests still pass. It is carried into the D17 audit task. The two-group weakness of S3 is real, but S3 is seeded and is not kept.
- **Not shown:** whether the reviewer set `PYTHON` for Bun is not stated. Without it, `check.test.ts` and `atlas.test.ts` fail on this machine (round 5, A5-P2), so a clean 110-pass run implies it was set.

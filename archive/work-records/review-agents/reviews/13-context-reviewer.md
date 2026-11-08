# Context review round 1: TASK-75 (tests-reviewer)

**Snapshot:** `8306aae..4085e84` on `feat/review-agents`, read in `C:\Github\cvgen\.worktrees\review-agents`.

**What the feedback implies (written before reading the diff):** a test is worth keeping only if it fails when the behaviour it claims to guard breaks. Tests that are tautological, duplicated, padding or tied to how the code is written should be rejected. The reviewer should say which tests are missing, which need fixing and which should go. The number of tests is not a goal. The gate fires on test changes only and is not an audit of the existing suite. It must not discourage regression tests that guard real behaviour.

**Placement and coverage:**
- **Placement is right.** The generic rules are in the skill, CVgen's probe procedure and frozen set are in `verification.md`, the gate is in `review.md`, and the agent file holds only its own procedure plus brief restatements with pointers. The conventions bullet that said "a test that would pass with the feature deleted is not written" moved into the skill instead of staying beside it.
- **Decisions applied:** D5, D6, D12 and D19 are all in the text. The D12 paths all exist, and `tests/report.py` does read `sample.json`.
- **Round-5 bullets for TASK-75:** all applied (anchor base `8306aae`, `--lock --reason` with the path in the task notes, the full list of moves, an invalid refactor redone, re-baselining only inside the copy, the `AGENTS.md` row at 800 words).
- **Calibrations:** they match the documented procedure.
- **Hygiene:** every file has LF line endings, there is no client data, and the Workflow Model diffs only shift line numbers.

## Findings

### 1. Material: rubric question 1 would wrongly fire on checks whose behaviour *is* structure
`.claude/skills/test-principles/SKILL.md:29-32` (with the "Change detector" row at :62)
- **Problem:** question 1 rules out assertions on "internal structure" with no exception. Several checks in the suite enforce a rule about structure:
  - check 10, the Framework boundary (imports, forbidden words, colour literals);
  - check 13, the auditor agent's read-only frontmatter.
- **Why it matters:** for these, the structure is the behaviour. The D17 audit applies this rubric to the whole suite next, and as written it invites "structure-sensitive, fix or remove" findings on exactly these checks. The frozen detectors have an exception (:103-105), but these checks do not.
- **Smallest fix:** add one sentence to question 1 or to the bullet at :103, for example: "When the rule under test is itself about structure (an import boundary, a file's frontmatter, a naming rule), that structure is the observable behaviour: judge whether it pins the rule, not by a refactor probe."

### 2. Material: the masked path names a reference path that does not exist
`docs/engine/verification.md:338`
- **Problem:** `tests/approved/Marine-Engineer-CV-v11.pdf` sits next to `baseline.json` and `tests/run.py`, so it reads as relative to the repository root. The file is actually at `packages/domains/marine/templates/flagship/tests/approved/`, as line 45 and the pin's key in `baseline.json` spell it.
- **Why it matters:** a reviewer following this literally writes a new file at the root, and check 2 stays red. Run K got it right, but by inference.
- **Smallest fix:** use the full path, as line 45 does.

### 3. Minor: `commit -am` skips new files
`docs/engine/verification.md:326`
- **Problem:** `git -C <copy> commit -am` does not commit untracked files. A refactor probe that splits a module into a new file under `packages/` leaves that file untracked.
- **Why it matters:** check 11's clean-engine assertion runs `git status --porcelain` on the engine paths (`render.py:231`), so it fails. Under :347-348 the reviewer then calls a valid refactor "invalid, redone".
- **Smallest fix:** `git -C <copy> add -A` before `git -C <copy> commit -m ...`.

### 4. Minor: the code-reviewer's test paragraph does not point to the new rubric
`docs/review.md:204-208` ("Depth and evidence")
- **Problem:** the paragraph still words test judgement in its own terms ("would fail for the relevant broken behaviour", "Avoid tests that only restate the implementation") and points only to `conventions.md`. That half-repeats the skill's questions 2 and 4 and its "Expected value from the code" pattern.
- **Why it matters:** the code-reviewer keeps lens 5 (D10) but gets no pointer to the rubric the tests-reviewer applies to the same kind of test.
- **Smallest fix:** add "(the `test-principles` skill)" after "restate the implementation".

### 5. Note: the owner's own convention is in the skill but not credited to him
`.claude/skills/test-principles/SKILL.md:133-137`
- **Problem:** "The owner's conventions" says none are recorded. Yet his words ("we do not care about having many tests, we care that the written tests test the actual behaviors") are a cross-project convention, and they appear unattributed in the intro (:12-13).
- **Fix:** optional. Attributing them there would make the section's "none yet" true.

### 6. Note: the "not a reason to remove" half lives only in the skill
`docs/engine/verification.md:344`
- **Problem:** the line says masking by an ordinary check shows overlap, but leaves out "not by itself a reason to remove". That half is only in the skill (:95-96).
- **Fix:** acceptable as it is, since the skill owns the method. A pointer would help, but it is not required.

**Not raised (scope):** the four stale Atlas pages, which the plan records as an exception, and TASK-76 to 78's files.

Verdict: FINDINGS

---

## Dispositions (lead)

1. Fixed: question 1 and the probes section both say that a check whose rule is about structure (an import boundary, a file's frontmatter, a naming rule) treats that structure as its behaviour, and that it is judged on whether it pins the rule, not by a refactor probe.
2. Fixed: the full path to the reference.
3. Fixed: `git -C <copy> add -A`, then `commit -m`.
4. Fixed: a pointer to the `test-principles` skill.
5. Fixed: the owner's words, dated and attributed, under "The owner's conventions".
6. Fixed: a pointer to the skill's "Removing a test".

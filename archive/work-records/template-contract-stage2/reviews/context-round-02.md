Round 2 context review of P-0019 Stage 2 (TASK-68). I reviewed worktree C:/Github/cvgen/.worktrees/contract-stage-2 at head 6be2cb2. Scope was `git diff main...HEAD -- docs .claude .codex AGENTS.md .atlas backlog`, checked against contracts.py, validate.py, scripts/cv.py and tests/run.py.

## Round 1 findings: all fixed

- **M1, fixed.** domains-and-roles.md:117-120 and template-contract.md:11-14 now give the schema rules:
  - the Template's input schema refers to the facts schema with `$ref` and declares only `copy`, with no `$defs`;
  - both schemas carry an `$id`;
  - the facts schema leaves `copy` open, and the Template's schema closes it.

  This matches tests/run.py:141-148, validate.py `registry()` (which finds a schema only by its `$id`) and the marine candidate.schema.json:92 (`"copy": {"type": "object"}`).
- **M2, fixed.** architecture.md:167 and :169 now match `contracts.py` (compare, compatibility, report) and the five subparsers in cv.py:47-69.
- **m1, fixed.** template-contract.md:92-96: the four results match `RESULT`. "The stricter result wins" matches `worst()`. I checked the claim "a group it renders whose `schemaVersion` rose is an error whenever the record holds it" against `compare()`:
  - required turned optional and rose: held + lacking, which gives always;
  - claimed, turned required and rose: held + never, which gives held;
  - required, stayed required and rose: always.

  The claim holds in all three cases.
- **m2, fixed.** template-contract.md:69-71 matches contracts.py:193 (`not [v for v in declared if v >= oldest]`). Saying "any version" is correct: a version the Variation declares is already at or above `oldest`.
- **m3, fixed.** candidate-schema.md:38-42 now agrees with :136-137.
- **m4, fixed.** verification.md:234 now points to the manual's table.
- **m5:** line 53 and lines 27-29 are fixed. The verification.md wrap is only partly fixed (see Minor below).
- **N1:** the eight "Major decisions" in TASK-68 match the code, including "a claim never relaxes the changed-group error" (`shown = name in claimed`, any shape).
- **N2:** build-a-cv.md:137-138 now names the refusal.
- **Other checks:**
  - LF only in all eight touched files.
  - English throughout, and no client is named.
  - ADR 0016 and P-0019 are unchanged in this round.
  - The Workflow Model line anchors shifted by one, which matches the one added line in build-a-cv.md.
  - The Atlas was restamped.

## Minor

**R2-m1. docs/engine/verification.md:215-216 and :233.** The m5 fix broke the line after "so every claim / is proved. Then the judging" and left "itself and the checks…" on the next line. The result is a ragged pair of lines in a list item whose other lines are evenly wrapped. Line 233 ("table in `docs/engine/template-contract.md`, a record ahead of, behind or below what a Variation") is also new and 100 characters long, against about 80 for the lines around it. **Fix:** reflow item 18 from "is proved." to the end, and item 20's lines 233-235.

## Note

**R2-N1. docs/engine/verification.md:127.** It still says the flat layout is "refused by all four commands". That remains true of the four commands that take a workspace, since `contracts` takes none. But architecture.md now says "five local commands", so a reader may ask which four are meant. **Fix (optional):** "all four workspace commands".

**R2-N2. docs/architecture.md:167.** At 167 characters, this row is the longest in the tree block; the others run to about 140. A shorter wording would be "checks before a render, version comparison, coverage, the compatibility report". This is cosmetic.

**R2-N3. TASK-68 notes, "Evidence".** The notes still cite the suite run on f1b6b39 (builds/tests-20261108-123228-323975). The fix commit's run is builds/tests-20261108-123928-837247. Add it when the task closes, so the record shows evidence for the head that merges.

Verdict: PASS

Round 1 context review of P-0019 Stage 2 (TASK-68). I reviewed `git diff main...HEAD` on feat/contract-stage-2 (head f88365e) in C:/Github/cvgen/.worktrees/contract-stage-2, checking it against contracts.py, validate.py, cv.py, tests/run.py, tests/coverage.py and tests/compatibility.py.

What holds up:
- The manual's table in template-contract.md matches `compare` and `RESULT` row by row, and it matches P-0019 section 6.
- The `oldestSupported` rules, the claims at two schema versions and the refusal of a version an `exactly` list skips are all stated in the owning manual.
- ADR 0016 changed only its Status line, and its index row is updated.
- The Atlas and Workflow Model line references match the new line numbers.
- Line endings are LF, the text is English, and no client is named.

## Material

**M1. docs/engine/domains-and-roles.md:115-117.** The checklist for wiring a new `Domain` was not updated. It still says only "A template adds `schema/<template>-input.schema.json`". The suite now requires three things it does not mention (tests/run.py:141-148):
- the Template's input schema refers to the facts schema with `$ref`;
- it declares no properties except `copy` and no `$defs`;
- the facts schema declares its own open `copy`.

Also, `validate.py`'s `registry()` finds a schema only if it has an `$id`. The travel `Domain` is the next to follow this checklist, and its author will find these rules only when the suite fails. The text "adds only `copy`" in template-contract.md:11-13 doesn't say that the Domain's facts schema must leave `copy` open. **Fix:** add one sentence to checklist step 2 that points to template-contract.md, and say in template-contract.md:11-13 that the facts schema keeps `copy` open and the Template's schema closes it.

**M2. docs/architecture.md:167, 169.** The `contracts.py` row still says only "the checks before a render, coverage judging", without the version comparison or the compatibility report. `scripts/cv.py` is still described as "the four local commands", but `contracts` makes five. **Fix:** update both rows.

## Minor

**m1. docs/engine/template-contract.md:88-98.** When a group differs in two ways, the stricter result wins (`worst`). P-0019 states this at lines 201-202: "an error whenever the record holds it, whatever else moved". The manual leaves it out. For example, an optional group the Variation claims that both became required and rose matches row 5 ("Warning") and row 3 ("Error when the record holds it"). The lead-in sentence on lines 88-89 ("a warning, or an error always, when …, or when …") is also hard to parse. **Fix:** rewrite the lead-in and add "A group that differs in two ways takes the stricter result."

**m2. template-contract.md:63-67, 83-86.** One refusal is not written down: a Variation that names no version the engine still reads (contracts.py:193; the report line "renders no version the engine still reads … update the Template"). The manual says such a record is compared. **Fix:** add this case to the list of refusals.

**m3. docs/engine/candidate-schema.md:38-41.** It still says the Flagship input is "a slightly wider shape … the same record plus an optional `copy` key". The facts schema now accepts `copy` as well (candidate.schema.json), and line 136-137 of the same file says so. **Fix:** reword lines 38-41 to say that only `copy`'s keys differ, and that the Flagship schema checks them.

**m4. docs/engine/verification.md:232.** It points to "the P-0019 section 6 table". The manual's table (template-contract.md:91-98) now owns these rules and is worded differently. **Fix:** point to the manual.

**m5. Formatting in template-contract.md:**
- Line 53: no blank line after the closing code fence.
- Line 60 (133 characters) is far longer than the lines around it, and verification.md:214 also runs long.
- Lines 27-28: "a `schemaVersion` falling, without a rise" says almost the same thing twice; "a `schemaVersion` that falls" is enough.

## Note

**N1. TASK-68 notes.** The notes describe what was built, but they don't name any of the author's decisions as Major, as docs/preferences.md:57 asks. These look like Major contract details:
- claims at several schema versions (`places@1`, `places@2`), which P-0019 section 5 doesn't show;
- refusing a version that an `exactly` list skips;
- a group that was required stays shown after it becomes optional;
- an open `copy` in the facts schema;
- building Stage 2 before any contract reached version 2.

Each one is written down where a later reader will look: the manual, candidate-schema.md, and the ADR Status line together with docs/proposals/travel-domain.md:95. So nothing is lost, but a "Major decisions" line in the notes would let the final report use them directly.

**N2. docs/guides/build-a-cv.md:137.** The list of refusals doesn't include a version the Variation doesn't render. It points to template-contract.md, so this can wait.

Verdict: FINDINGS

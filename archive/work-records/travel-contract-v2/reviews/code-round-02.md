# Review round 2: TASK-80 (travel-contract-v2)

**Verdict: PASS.** No Blocking or Material findings. All four round 1 code findings (m1, m2, n1, n2) are fixed, and the new layout code fails loudly where it should. One Minor (the two-line licence fallback is never tested) and two Notes; I reran the suite (247 cases) and ruff myself, both pass. The design gate still needs its round 3 on this layout.

Snapshot: worktree `C:\Github\cvgen\.worktrees\travel-contract-v2`, head ded1f6e (clean tree). Delta reviewed: `96e9a98..ded1f6e` (20233e0, ded1f6e).
Lead lenses: (1) the version comparison on the real v2; (2) loud failure and data integrity of both record shapes, now including the new layout code.

Coverage:
1. **Wiring:** the twin, the v1 twin, the v2 Coverage Fixture and the new cases all reach the new code through the real Hanami path.
2. **Correctness:** the round 1 fixes hold.
   - **m1:** the anchor now cites lines 165-170, which is the approve paragraph. `bun run anchors 96e9a98` reports 0 moved, 0 edited.
   - **m2:** `brief` now declares `exactly: [2]`; a v1 record is refused with its message; the report line reads "renders version 2". The manual (template-contract.md, around line 96) gives both correct options.
   - **n1:** the wording now says both versions require `destinations`.
   - **n2:** `day-month-year` refuses "31 Feb 2029" and accepts "29 Feb 2028"; the leap-year rule is right.
3. **Integrity:**
   - The role is never lost. It is drawn under the stamp, and "LED THE GROUP" is checked in full on a "September 2024" card. In the v2 fixture PDF each role sits with its own trip.
   - The licence keeps title, issuer, region and date. In the fixture it measures 29-119 mm, inside the 104 mm budget.
   - The only thing replaced is the studies subtitle, which is `copy` wording (copy.typ:10), not facts.
   - The twin's licence and trip kinds changed, but they are fictional, and the region is still proved by `Qxvalidzone`.
4. **Contracts:** unchanged since round 1.
5. **Tests:** new cases for `led-long-period`, `leap-day`, `no-such-day`, `long-role` and `long-licence`, each checked by its message. One gap: m3.
6. **Failure handling:**
   - The role width is asserted against the 26 mm column (sections.typ:132).
   - Each licence line is asserted against 104 mm, after the fallback.
   - Several licences grow the heading, and page-2 overflow then fails through the slot.
   - Petal collisions still fail the render.
   - A "31 Feb" date passes the Python schema but stops the Typst compile, which is still a loud failure.
7. **Simplicity:** the code stays in its owning modules; `studies()` is simpler than before.
8. **Repository and docs:** the manuals, verification.md, the task notes and the Atlas are coherent; ruff is clean.

## Findings

### m3 Minor: the two-line licence fallback is never exercised
Anchor: `packages/domains/travel/templates/hanami/components/sections.typ:222`
- **Scenario:** a client licence whose title plus "issuer · region · Valid until …" is wider than 104 mm, but where each part fits on its own line. This is the normal case for a real licence with a region.
- **Expected:** a test renders it on two lines and finds both.
- **Actual:** every case is either one line (the twin, the coverage fixture) or refused because the title alone is too long (`long-licence`). The `else` branch never runs, so a defect there would pass the suite.
- **Fix:** add a `travel.typ` case such as `two-line-licence` (for example a long issuer with a region). Assert that it compiles, that the title and "Valid until" are both on page 2, and that the title and the issuer sit on different text lines.

### n3 (carried) Note: the design gate is still open
The stored design round 2 had D14 and D15 as Blocking. The new layout is a different render, so it needs design round 3. This code PASS does not cover how it looks.

### n4 Note: a trip without a stamp shows its role alone
Anchor: sections.typ:147
At version 2 the stamp is optional (`travel-story`). A trip without one puts its role label alone at the top of an empty 26 mm column. The v2 fixture's "Qxspringtrip" and "Qxwintertrip" show it: "ORGANISED" and "TRAVELLED" float to the left of their periods. For the design-reviewer to judge in round 3.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py` on ded1f6e: exit 0, "PASS: 247 compilation cases… 25 passed". Evidence: `C:\Github\cvgen\.worktrees\travel-contract-v2\builds\tests-20261108-132031-123145`.
- `ruff check`: all checks passed.
- `bun run anchors 96e9a98` (read-only, no `--fix`): OK, 0 moved, 0 edited.

## Evidence inspected
At ded1f6e:
- the 96e9a98..ded1f6e diff
- sections.typ, hanami.typ, data.typ, copy.typ
- tests/fixtures/travel.typ, tests/run.py, tests/coverage.py
- the docs changed in this delta
- the TASK-80 record
- page 2 of the Frozen Reference candidate, viewed as an image
- the text positions and an image of page 2 of the v2 Coverage Fixture PDF, from the author's run `builds/tests-20261108-131841-005884`

## Limitations
I did not compile a two-line licence case: that would have meant adding a source fixture, which I may not do. I judged no design quality; that belongs to design round 3.

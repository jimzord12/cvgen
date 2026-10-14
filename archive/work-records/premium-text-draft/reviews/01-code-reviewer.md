# Review round 1: premium-text-draft (code-reviewer)

Lead's summary of the returned report (the original text was not kept).

Snapshot: eac00ec (feat/text-draft-first-fitting) against 25469c9 (main),
2026-09-28. Lead lenses: Contracts/API (real-client variants); Tests and
visible evidence.

## Coverage (summary)

- The owner's settled words are in the house copy exactly; no tailoring
  pun remains. Needle, quieter headline and white space match the brief.
- Variants compiled: Greek CV for a male client with a 46-character name
  (tag wraps cleanly; "Σελίδα n από 3"); `client: none` (running head on
  page 1); 36 headings over 5 pages (no heading ends a page).
- No `.typ` under `private/` imports the script; the old fixture fails
  loudly against the new API.
- Bona Nova files and licence match the upstream SHA-256 values.
- Suite rerun: PASS, 52 cases, `builds/tests-20260928-013857-330734`.

## Findings

- **F1 Material:** the suite could not see the fact marks. Mutants (fact
  = body, needle removed, running head on the Check Page, white paper, 9pt
  body) all passed the text-draft assertions. Fix: assert copper strokes
  under fact words and none under plain words.
- **F2 Material:** the Check Page overprinted silently. Sample rows had a
  fixed 12 mm height (a long legal company name wrapped onto the next
  label), and the reply block was `place`d at the foot outside the flow
  (extra rows or a longer intro printed over it). Both compiled with
  exit 0. Fix: rows that grow; reply in the flow; fail if it overflows.
- **F3 Minor:** `check-lang` other than "el" or `lang` other than en/el
  failed with a bare dictionary error, before `copy` was merged.
- **F4 Minor:** AGENTS.md row, theme.md and new-theme skill (font list),
  magazine-editor fonts list out of date.
- **F5 Note:** header comment did not document `lang`, `check-lang`,
  `copy`; missing greeting or date give bare errors or empty fields; the
  drafter must underline every fact.
- **F6 Note:** body went from 13pt to 12pt; no glossary term for the
  fact mark.

## Verdict: FINDINGS

## Dispositions (lead)

- F1 fixed (b753b89): copper-stroke assertions on both pages; mutation
  with `fact` = body fails the suite at (0, 'Example', 'not stitched').
- F2 fixed (b753b89, 8a7ddfb): grid with `row-gutter`, reply in the flow,
  Check Page overflow assert; suite case `text-draft-long` checks word
  overlaps below the tilted tag.
- F3 fixed: default plus an assert naming the missing keys; suite case
  `text-draft-english`.
- F4 fixed. F5: comment and new-client step 8 updated; missing
  greeting/date left to Typst's own errors (deferred). F6: body 13pt,
  term `Fact Mark` added.

# Review round 2: premium-text-draft (code-reviewer)

Snapshot: 8a7ddfb (fixes b753b89, 8a7ddfb on eac00ec), base 25469c9,
2026-09-28. Lead lenses: Tests and visible evidence; Failure handling and
layout.

## Coverage (summary)

- F1 fix holds against five mutants: fixed 12 mm rows, `fact` drawing
  nothing after page 1, samples unstitched, stitch 14 pt lower, plain
  words stitched; all killed.
- Exactly-full layout: a bisected sweep shows the page-1 assert never
  misfires; at the last passing point the reply sits at the foot with the
  12 mm gap and no blank page.
- Suite rerun: PASS, 54 cases, `builds/tests-20260928-014816-365373`;
  text-draft PDFs pixel-identical to the author's.

## Findings

- **F7 Material:** the suite could not see the reply-in-flow and
  loud-overflow half of the F2 fix. Mutants with the reply `place`d back at
  the foot, the page-1 assert removed, or both, left the suite green,
  because the long case leaves room above the reply. With one more row the
  real script fails correctly, while the mutants overprint or spill onto
  page 2. Fix: a fixture case one row too full, expected to fail.
- **F8 Minor:** `docs/reference/verification.md` still described the
  eac00ec checks.
- **F9 Minor:** a string `copy.headline` rendered silently as two letters.

## Verdict: FINDINGS

## Dispositions (lead)

- F7 fixed: fixture `case=full` (the long samples plus one row) and suite
  case `text-draft-full` expecting "the Check Page runs past one page".
  Mutation check: with the reply placed at the foot, the suite fails at
  ('text-draft-full', '').
- F8 fixed: the row lists the Fact Mark check, `case=long`, and the two
  refusals.
- F9 fixed: an assert requires `copy.headline` to be two lines.

# Context review round 5: P-0019 Template Contract

Reviewer: context-reviewer (fresh context). Date: 2026-11-04.
Snapshot: docs/proposals/template-contract.md after round 4, uncommitted.

Blocking and Material: none. Round-4 fixes confirmed; every table row was walked against the line under the table.

## Minor
1. "A custom composition takes the latest version" had no "new" and no writer.
2. The optional-made-required row showed "Renders" without a warning, and the suite's "error row" missed errors from the line under the table.
3. Wrap drift.

## Notes (ADR-level)
Where the script's refusal of a broken contract should run (a suite row would catch it earlier). A group rendered but not claimed reads as unused. A group moved from required to optional may read as dropped.

Verdict: PASS

## Author's response (lead, 2026-11-04)
Minors 1 and 2 applied as the reviewer worded them; rewrap skipped as cosmetic. The notes go to the ADR.

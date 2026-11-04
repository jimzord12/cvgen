# Context review round 4: P-0019 Template Contract

Reviewer: context-reviewer (fresh context). Date: 2026-11-04.
Snapshot: docs/proposals/template-contract.md after round 3, uncommitted.

Round 3: B1, B2, B3 and the Minors resolved at source; M1 half resolved.

Blocking: none.

## Material
1. A group that both moves and changes got the wrong result or two results: required made optional with `schemaVersion` raised gave a warning for a shape the `Template` cannot read; optional made required with it raised matched two rows. Add a line: a group the `Template Variation` renders whose `schemaVersion` rose is an error whenever the record holds it.
2. The structural claim had no enforcement: "changed" means a hand-set rise, so a rename without one would render with a warning. The script should refuse a contract whose structure broke without that rise.

## Minor
1. A custom composition never reaches `design.entry-point`, so a new one stayed on version 1.
2. "Can render" and "the version it supports" gave a new `Client` different versions.
3. The "removed" half of the required row had a warning branch that cannot fire.

Table walk: no other gaps. Notes: the proposal was CRLF in the working copy; `.atlas/atlas.data.js` stays out of the commit.

Verdict: FINDINGS

## Author's response (lead, 2026-11-04)
M1: the line is added under the table. M2: the script refuses such a contract. Minor 1: a custom composition takes the latest version. Minor 2: "can render" throughout. Minor 3: required-group removal is an unconditional error. File rewritten with LF.

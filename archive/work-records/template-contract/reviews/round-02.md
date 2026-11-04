# Context review round 2: P-0019 Template Contract

Reviewer: context-reviewer (fresh context). Date: 2026-11-04.
Snapshot: docs/proposals/template-contract.md after round 1, uncommitted, and the eight pending rows in docs/glossary.md.

Round 1: 1, 6, 7, 8, 9, 10, 12, 13, 14, 15 resolved; 2 reworded, not resolved; 4, 5, 11 and the table Minor partly resolved; 3 resolved, but its fix introduced M2.

## Blocking
B1. "Never forced" and "never turns the suite red" were false. Flagship imports live `Domain` code. If `oldestSupported` passes the shape of `engineer-example.json`, the frozen comparison fails, and upgrading that pinned record needs an ADR, a new `Frozen Reference` and a PDF version bump. Examples have no `envelope.json`, so their version was undefined.
B2. The sections disagreed on a `Client` at v4 with `upTo: 3`. "Supported" was undefined; nothing enforced "Error if used"; nothing strips a changed group; no rule gave a new `Client`'s version.

## Material
M1. "Facts cannot drop out unnoticed" was overstated: a new optional field raised no version, one marker per group proves one field, the portrait sits in a required group, and the contract was not said to stay closed.
M2. "Validated exactly as today" contradicted section 4; existing `Envelope`s had no version; "unaffected" contradicted `contacts` becoming required; a new `Envelope` omitting the fields skipped every check.
M3. Rule changes not named: ADR 0010, `docs/vision.md:10`, principle 1, "safe professional", further docs, `catalog.yaml`, `new-theme`, `.atlas/src/`, `outputs.py`, a revision of P-0013. Whether the adapter survives was unsaid.
M4. "Scan-first" was undefined, the manifest had no bar field, and "apply to craft only" had no meaning for the `Batch Test`.
M5. Sequencing contradicted itself: TASK-3 before Stage 1 cannot be the first `schemaVersion` change, and TASK-2 has nothing earlier to compare.

## Minor
The Essential example omitted `education`; a required group removed or made optional had no row; the display switch was omitted; bare "Variation"; Stage 2's definition differed in two places; no `Layout` was named for Essential; a `Revision` recorded neither its `Template Variation` nor its version.

## Notes
The proposal's term table duplicated the glossary; no rule said a `Base Contract` change raises a `Domain`'s version; "the owner chose" needed a source; the research note is CRLF in the working copy.

Verdict: FINDINGS

## Author's response (lead, 2026-11-04)
B1: the claims are narrowed to "most" and "usually"; `oldestSupported` is limited by the frozen records; a record's version moves into `candidate.json`, and a missing field means version 1, so examples are covered without editing pinned files. B2: section 6 defines supported, and section 8 has a row for it; the table now states when a changed group errors (the record holds it); a new record takes the latest version at `design.fill-data`. M1: any contract change raises `version`; the portrait becomes its own optional group; a marker in every printed field; the contract stays closed. M2: section 8 rewritten: checks always run when `cv.typ` imports a `Template`. M3: section 2 keeps the adapter; section 3 answers principle 1; Decision 2 and Consequence extended. M4: a `designBar` manifest field; Decision 1 restates each test. M5: Stage 1 is all version 1; the first move to version 2 triggers Stage 2; Decision 4 rewritten. Minors and notes fixed; the term table is replaced by a pointer to the glossary. The CRLF is normalised on add.

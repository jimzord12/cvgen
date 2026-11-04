# Context review round 1: P-0019 Template Contract

Reviewer: context-reviewer (fresh context). Date: 2026-11-04.
Snapshot: docs/proposals/template-contract.md, revision 1, first draft, uncommitted. Line numbers refer to that draft.

Clean: metadata, id, required sections, LF line endings; names no real client.

## Blocking
1. A `schemaVersion` break did not raise `version`, yet the script compared versions, so a required-group break went undetected. Raise `version` on any change, or compare per group and pin required groups.
2. "Cannot break their next `Revision`" was false: `cv.typ` imports live packages (`render.py:156`), so a number in `envelope.json` selects no code, and one engine rendering every kept version was an undeclared cost.
3. "Nothing states" was wrong: two schemas state the contracts. `validate.py` picks the closed Flagship input schema, so a new optional group is refused, and `tests/run.py:124` fails on `$defs` divergence, so a `Domain` change can turn the suite red. Consequence named neither, nor which of `envelope.json` and `cv.typ` wins.
4. The recommended bar kept `Flagship Parity` (portrait, ship, propeller) for a page with no photo and one motif; `docs/vision.md` passages were not addressed, so the `design-reviewer` would still fail it.

## Material
5. Consequence omitted rule texts, agents, skills, docs, `cv_workflow/` modules and P-0013.
6. "Variation" collisions were understated; the `envelope.json` key `contract` collides with the Meta File's `contract`.
7. Glossary rule 3: terms in an undecided proposal are added now as pending.
8. `Template Contract` titled the proposal but no section said what it requires.
9. The new `Template` definition required a manifest a one-off lacks and dropped "belongs to a `Domain`".
10. "No template field" overstated: `CV Decisions` holds it. Say no machine-readable field.
11. The custom composition path had no rule.
12. A Variation's hold on `Theme` and `Artwork Pack` was unclear; `showcase` spans two `Layout`s; "about half" is unmeasurable, and Essential may trip it.
13. Constitution section 9 (no speculative abstraction) was not named, and no split option was offered.
14. Q3 (naming) is the agents' call; no question named the constitution; TASK-3's order was undecided; Q4 hid deferred P-0013.
15. The note covers no marine or crewing work; the photo limits and "the base is weak" were dropped.

## Minor
"role" for a job and "candidate" for a person; the compatibility table omitted a removed group and a move between required and optional.

Verdict: FINDINGS

## Author's response (lead, 2026-11-04)
All findings fixed in the same revision (still revision 1: not yet put to the owner). 1: `version` rises on any contract change, and the comparison is per group. 2: the one-live-engine limit and `oldestSupported` are stated, and the promise is narrowed. 3: Problem and section 4 say the `Domain Contract` replaces the closed schema and the `$defs` check; `typst/cv.typ` disagreeing with `envelope.json` stops the render. 4: Decisions 1 and 2 name the passages. 5: Consequence extended. 6: key renamed `domainContract`; the term is always two words, so the constitution's wording stays. 7: rows added to the glossary. 8: new section 2. 9: definition corrected, with the one-off exception. 10: fixed. 11: section 8. 12: section 3; no threshold. 13: Risk and Recommendation, with two stages. 14: Essential named by agents; Decision 3 added; Decision 4 covers TASK-3 and P-0013. 15: section 9. Minor: fixed.

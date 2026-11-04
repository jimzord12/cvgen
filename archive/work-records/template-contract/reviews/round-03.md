# Context review round 3: P-0019 Template Contract

Reviewer: context-reviewer (fresh context). Date: 2026-11-04.
Snapshot: docs/proposals/template-contract.md after round 2, uncommitted.

Round 2: B1, M1 to M5, the Minors and Notes resolved at source. B2 resolved on "supported" and on when a changed group errors; the new-`Client` rule introduced B2 below.

## Blocking
B1. "The portrait moves out of `identity`" contradicted "no edit": pinned example records hold `identity.portrait`, the schemas are closed, and `render.py:121-145` reads that path. Say the record keeps the field and the group points at it.
B2. A new `Client` on "latest" stopped where a supported version would render, every time, on every behind `Template`, while the suite said only "behind". A new record should take the latest version its `Template Variation` can render, and "behind" should report an error-row gap.
B3. `design.record-choice` sits on the no-`Template` path only (`stage.yaml:115`, `:304`), so the fields were not written on the path Essential uses, and no step offered the choice. Name `design.entry-point`.

## Material
M1. "Nobody labels a change as small by hand" was false for a changed meaning, and "changed" was undefined, so a new optional field matched several rows and a claimed optional group becoming required had no row.

## Minor
PDF text cannot prove an image field. "New facts count as dropped", but the Meta File recorded only groups. "The version" was ambiguous. The example's `sea-service` used the shape of base `experience`.

## Notes
Nothing said `showcase` is the default. "Imports a `Template`" cannot separate a custom composition from a Flagship entry; this can go to the ADR. `.atlas/atlas.data.js` stays out of the commit.

Verdict: FINDINGS

## Author's response (lead, 2026-11-04)
B1: section 4 says a group points at parts of the record, and the portrait stays at `identity.portrait`. B2: a new record takes the latest version its `Template Variation` can render, errors name the fix, and "behind" reports error-row gaps. B3: a new step offers the choice, and `design.entry-point` writes it and the version. M1: "changed" means its `schemaVersion` rose; the claim is narrowed to structural changes; rows added. Minors and the `showcase` note fixed. "Imports" became "renders", with the separation left to the ADR.

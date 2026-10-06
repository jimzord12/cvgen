---
id: TASK-14
title: 'monorepo-migration: move the repository to the approved ADR 0010 layout'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
updated_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/Z0CTAVrT'
ordinal: 14000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# monorepo-migration: move the repository to the approved layout (ADR 0010)

Owner: Claude Code. Branch: `feat/monorepo-migration` (feature branch; substantial change).
Integration target: `main`. Depends on: none (dev-setup Done, Trello adopted).

## Outcome and boundaries
The repository follows the target tree in docs/pdf-workflow.md: candidate facts are separated from the Flagship template's input contract and connected through the template adapter; presentation stays owned by the template. Fictional examples are organised per the approved layout: three candidate datasets covering deck and engine, one example per supported template/dataset combination. Historical design studies stay together.
Excludes: component rewrite, a speculative shared marine schema, new templates just to fill a matrix, any change to frozen reference bytes or accepted baselines, the PDF workflow commands (next card).

## Acceptance
See checklist. Evidence per item goes in the card or in `docs/work/monorepo-migration/`.

## Links
- ADR 0010: https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/decisions/0010-public-monorepo-and-pdf-workflow.md
- Target tree and lifecycle: https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/pdf-workflow.md
- Working rules: https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/development.md
- Baseline before moving code: `python tests/run.py` PASS, 24 cases, builds/tests-20260916-154403-397582 (local)

## Result and evidence
Branch `feat/monorepo-migration`, commits d0978b2 (move + adapter + third dataset), f122de8 (schema formatting), fe9bd1d (docs + gallery PDF). CI green on fe9bd1d: https://github.com/jimzord12/marine-engineer-cv/actions?query=branch%3Afeat%2Fmonorepo-migration
- Suite: `python tests/run.py` PASS, 26 cases (was 24), builds/tests-20260916-205345-010752 (local).
- Frozen reference: engineer example pixel- and text-identical to Marine-Engineer-CV-v11.pdf from the new tree (suite gate `exact`).
- tests/baseline.json: 31 entries re-keyed; 29 hash values carried over unchanged (reference PDF, 3 fonts, 18 assets, 7 design-study files). Two changed: the engineer and captain records, each a one-line portrait path edit (`/assets/...` -> `/examples/candidates/...`), shown in commit d0978b2.
- Contracts: packages/cv-engine/schema/candidate.schema.json (facts) and templates/flagship/schema/flagship-input.schema.json (facts + copy); templates/flagship/adapter/adapter.typ owns Flagship wording; all three records validate against both.
- Third dataset: examples/candidates/chief-officer-example.json (deck, no portrait) + examples/flagship/chief-officer.typ, silver theme; rendered pages inspected; exports/Marine-Chief-Officer-CV-Silver-v01.pdf.
- Existing deliverables: rebuilt PDFs raster- and text-identical to the committed exports (only the creation timestamp differs); exports untouched.
- Durations switch: covered by the `engineer-hidden` and `long-hidden` cases; build.ps1 -HideVesselDurations path updated.
- Packaging/privacy: typst.toml moved into the package with exclude = templates/flagship/tests; private/ and builds/ still ignored; git grep for old paths in active docs clean.
- Legacy private entry points (2 real candidates, untouched): they import `../../themes/...`, `../../src/...` and `/assets/...`; after this change they fail to compile until their imports become `../../packages/cv-engine/...` and asset paths `/packages/cv-engine/templates/flagship/assets/...`. Candidate records were not modified. Owner to decide when to touch them. (Both compose pages by hand and read the record's `copy` directly, so the adapter's merge does not affect them; only the paths break.)
- Design studies: moved unchanged to archive/design-studies (hashes pinned); they no longer compile in place; README explains recompiling from tag `archive/pre-monorepo`.

## Review
Round 1 on fe9bd1d, lead lenses 3 and 4: https://github.com/jimzord12/marine-engineer-cv/blob/feat/monorepo-migration/docs/work/monorepo-migration/reviews/01.md - FINDINGS. M1 (candidate-schema reference described the old copy contract) fixed; M2 (stale paths in skills/references, silent --font-path fonts) fixed; m1 previews re-rendered from the committed export into docs/images; m2 precedence test tightened; m3 verification.md, .gitignore, .gitattributes, README gallery fixed; N1 card statement corrected. All in commit 2f76890.
Round 2 on 2f76890, lead lenses 8 and 5: https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/work/monorepo-migration/reviews/02.md - PASS. m4-m6 (two backticked /assets/ paths, 'three PDFs', 'migration pending' status lines) fixed in 4a3d6ad; N2 (older preview PNG size) and N3 deferred to the next release.

## Handoff
Done 2026-09-16. Integrated into `main` by fast-forward at 4a3d6ad (CI success). Pre-migration snapshot: tag `archive/pre-monorepo`. Open for the owner: the two private entry points need their import and asset paths updated before their next render (see Result). Next card: pdf-workflow.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 All existing public examples build from their new locations
- [x] #2 examples/engineer output is byte-identical to reference/Marine-Engineer-CV-v11.pdf; tests/baseline.json hashes unchanged (paths updated, payloads preserved, not regenerated)
- [x] #3 Candidate facts and the Flagship input contract are separate files joined by the template adapter
- [x] #4 Three fictional candidate datasets covering deck and engine, one example per template/dataset pair
- [x] #5 The durations switch still works on every example
- [x] #6 Packaging and privacy exclusions (private/, builds/) hold in the new tree; CI green
- [x] #7 Maps and docs (AGENTS.md, architecture, guides, reference) describe the new layout; ADR history preserved
- [x] #8 Legacy private entry points: compatibility issue identified and reported, candidate records untouched
- [x] #9 python tests/run.py PASS and code-reviewer PASS on the final snapshot
<!-- AC:END -->

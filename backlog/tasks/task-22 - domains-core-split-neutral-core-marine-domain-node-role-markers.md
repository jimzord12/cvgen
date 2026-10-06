---
id: TASK-22
title: 'domains-core-split: neutral core, marine domain node, role markers'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/ffwl9ZuM'
ordinal: 22000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# domains-core-split

Stage 2 of ADR 0011. The maritime data model leaves the shared core and becomes the marine domain; core gains the merge helper; Flagship takes a role; deck and engine role markers exist; tests prove the composition is wired.

## Outcome and boundaries
packages/cv-engine/core/ imports nothing from domains/ and reads no groups/ships; domains/marine/{domain.typ,data.typ,roles/deck,roles/engine} exist; flagship(..., role: none) forwards the role; copy is composed domain < role < template < record < call site; the engineer example stays pixel-identical. Excludes the rename (rename-<name>) and any second domain.

## Acceptance
- [ ] `python tests/run.py` PASS, engineer exact match unchanged.
- [ ] New cases fail for distinct wiring defects: role.typ through flagship (role not forwarded), core-model.typ with a non-marine shape (core still reads ships), missing-name negative (validate-common skipped), `'5 years' x 2` in three-pages (fragment durations), literal 15-key copy dictionary and role-override assertions in data.typ (merge order), core boundary guard (bare sibling imports only).
- [ ] `git grep -nE '#import "[^"]*(/|\.\.)' packages/cv-engine/core` returns nothing.
- [ ] Docs: architecture.md rewritten, new docs/reference/domains-and-roles.md, candidate-schema.md split into domain/template words, AGENTS.md map and six-inputs sentence, build guide custom-composition snippet, skills mention role.
- [ ] Code-reviewer rounds (lenses 2 correctness, 5 tests; then 7) until PASS; reports under docs/work/domains-core-split/reviews/.

## Plan
Branch refactor/domains-core. See the approved plan: core/node.typ (merge, compose); core/data.typ keeps duration-parts, required-text, adds normalize-common, validate-common; domains/marine/data.typ takes company-months, experience-totals, normalize-candidate, validate-candidate (whole companies block incl. unique-ids assertion), experience-model (count, slice with display-months from the full company, totals); pagination takes the model; page.typ takes title/author strings; adapter composes copy with the six marine words in domain.copy; experience.typ repoints company-months; lib.typ keeps names and adds company-months.

## Result and evidence
Merged to main as 3296e91 (branch refactor/domains-core, 2 commits). core/ is field-neutral (node.typ, common facts, pagination over a domain row model, shell with title/author); domains/marine/{domain,data}.typ and roles/{deck,engine}; flagship(role:) forwards to the adapter; copy composed domain < role < template < record < call site. Suite PASS 38 cases with exact reference equal: builds/tests-20260921-022719-915489. Negative proofs: role not forwarded -> role case fails; fragment months -> '5 years' count 0. Reviewer compared nine entry points against main: identical pixels, text and metadata.

## Review
Round 1 PASS (lenses 2, 5): https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/work/domains-core-split/reviews/01.md . Four Minor fixed before merge (guide snippet, role scope wording, boundary regex, doc lag); role type assert added.

## Handoff
Done 2026-09-21. Both private entry points repathed the same night (imports only; records untouched) and match their reference.pdf pixel for pixel. Next: rename-cvgen, then travel-and-tourism.
<!-- SECTION:DESCRIPTION:END -->

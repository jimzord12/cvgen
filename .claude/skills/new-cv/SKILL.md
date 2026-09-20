---
name: new-cv
description: Produce a CV for a real or new fictional candidate with the CVgen library. Use when asked to create, set up or render a CV for a person, or to add a new example. Covers the private workspace, data file, entry point, page plan and evidence.
---

# New CV

Follow `docs/guides/build-a-cv.md`. This skill is the checklist.

## Decide the destination

- Real person: one folder per candidate under `private/` (ignored), named
  after the person and role: `private/<name>-<role>/` with `candidate.json`,
  `cv.typ`, `portrait.<ext>` and a `README.md` recording what was decided
  and where the evidence is. Renders go to `revisions/` and approved copies
  to `exports/` through `scripts/cv.py`. Never under `examples/`.
- New public example: fictional data under `examples/candidates/<name>-example.json`,
  entry under `examples/marine/flagship/<name>.typ`, and add it to `scripts/build.ps1` and
  the compile list in `tests/run.py`.

## Steps

1. Copy the closest data file under `examples/candidates/` (`engineer-example.json`,
   `captain-example.json` or `chief-officer-example.json`) and replace every value. Keep stable ids.
   Whole months. If months per vessel are unknown, use `service-months` on
   the company and plan to hide durations.
2. Validate the JSON against `packages/cv-engine/domains/marine/schema/candidate.schema.json` if a validator
   is available; otherwise rely on the compile-time assertions.
3. Write the entry point as shown in the guide, importing the engine by
   root-absolute path (`/packages/cv-engine/...`). Pick the role marker
   (`domains/marine/roles/deck` or `roles/engine`), theme and artwork from
   `packages/cv-engine/domains/marine/templates/flagship/themes/` and `artwork/`, the durations switch, and import the layout
   `as base` with a `pages` override that lists this candidate's company
   indices. The shipped plan assumes six companies and fails with
   `Page plan company index out of bounds` for fewer, or
   `Page plan must cover each vessel row once, in candidate order` for more.
   If the data does not fit `flagship` (the known cases are in
   `docs/framework-gaps.md`: contract periods instead of months, a
   three-column certificate table, a skills block), use the
   custom-composition path in guide section 8, record the reason in the
   folder's `README.md`, and add an entry to `docs/framework-gaps.md`.
4. Real person: `python scripts/cv.py render private/<name>-<role>` (add
   `--pages 3` for a three-page plan); the revision id, hash and check
   result are printed and kept under `revisions/<id>/`. Public example:
   `typst compile --root . --font-path packages/cv-engine/fonts <entry> builds/<name>-01.pdf`.
5. On a fit or overflow error, apply the fix the message names. Page plan
   changes go in the entry point as a layout override, see
   `docs/reference/layout-and-pagination.md`. Never shrink body fonts.
6. Render each page to PNG and look at it. `python -c` with `pymupdf` works:
   `page.get_pixmap(dpi=96).save(...)`.
7. For a public example, run `python tests/run.py` and confirm PASS.
8. For a real person, stop at the render. Approval (`scripts/cv.py approve`)
   is the owner's act on the revision they reviewed; export follows it.
   Never approve a real candidate's PDF yourself.

## Report

State the revision folder or output path, the PDF hash for a real
candidate, the page count, what was checked on each page, and any override
applied to the layout or theme.

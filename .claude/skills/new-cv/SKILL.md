---
name: new-cv
description: Produce a CV for a real or new fictional candidate with the CVgen library. Use when asked to create, set up or render a CV for a person, or to add a new example. Covers the design, the record, the entry point, the design review, render, Export and evidence.
---

# New CV

The design is the product (`docs/vision.md`, "Design is the product"): a
client's CV must pass the `Batch Test` and the `Three-Second Test` at the
level of the Marine Flagship; tidy but quiet is a failure.

For a real client this skill is the checklist of the `Workflow Model`'s
`design` and `deliver` stages: read `docs/workflow/05-design/README.md` and
`06-deliver/README.md` for the judgement, branches and common mistakes,
then follow the step IDs below. It starts after the `new-client` skill:
the facts come from `intake/facts.md`, the wording from the signed-off
draft; never re-ask the client or reword beyond fitting the page. The
engine reference is `docs/guides/build-a-cv.md`, "BC" below. Run every
command from the repository root.

## A real client: 05 design

- `design.handover` (`gate.template-exists`): does the client's `Domain`
  have a `Template` (today only marine, the Flagship)?
- `design.fill-data`, on every path: `candidate.json` at the `Envelope`'s
  root from the closest example record with every value replaced, the
  portrait in `images/portrait/`, the example wording gone (BC section 2).
- No `Template`: `design.run-brief` to `design.pick` through the
  `idea-run` skill (fictional data for the client's `Domain`, specialty
  and `Rank`; the `Alias` only); then `design.record-choice`
  (`python scripts/outputs.py stamp <pdf> status=chosen`) or
  `design.record-other-answer`; then `design.port-concept`: the one-off
  `Template` as `typst/cv.typ` importing only
  `/packages/cv-framework/lib.typ`, with its files beside it in
  `typst/designs/`, `typst/text/` and `typst/art/`. A concept's generated
  images come with it into `typst/art/`; a new one for this design is
  made, placed and recorded in the `Envelope`'s `README.md` as
  `docs/tech-stack.md`, "Codex CLI", says (never a portrait, nothing about
  the `Client` in the prompt).
- A `Template`: `design.flagship-fit` (`gate.template-fits`, the known
  gaps in `docs/framework-gaps.md`), then `design.entry-point` (BC
  section 1) or `design.custom-composition` (BC section 5).
- `design.framework-gap` after a custom composition or a one-off;
  `design.engine-change` and `design.engine-review` (a fresh
  `code-reviewer`) only when the design needs what only the engine holds.
- `design.preview`, for every client CV:

  ```powershell
  $out = "builds/design-review-input-$(Get-Date -Format yyyyMMdd-HHmmss)"; New-Item -ItemType Directory $out
  typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts private/<envelope>/typst/cv.typ "$out/cv.pdf"
  ```

  A portrait path relative to the `Envelope` compiles only through
  `cv.py render`; use the root path BC section 2 gives.
- `design.client-review`: a fresh `design-reviewer` and, beside it on the
  same previews, a fresh `codex-visual-reviewer` per round, both briefed
  as the design README says (Codex makes its sheets in the same input
  folder); each report verbatim as `reviews/design-NN.md` and
  `reviews/design-NN-codex.md`; `design.fix` until both pass, or
  `design.cap-reached`. Codex `UNAVAILABLE`: the design-reviewer alone,
  noted in `README.md`.
- `design.clear-review-input`: `Remove-Item -Recurse <that folder>`, by path.

## A real client: 06 deliver

- `deliver.render` (`gate.render-ok`):
  `python scripts/cv.py render private/<envelope>` (`--pages 3` or
  `--pages 1` for those plans). On exit 1 or 2, `deliver.fix` and render
  again (BC sections 3-4).
- `deliver.page-png`, for each page N, into a new `builds/<new-folder>/`:
  `python -c "import pymupdf; doc = pymupdf.open('private/<envelope>/revisions/<revision>/cv.pdf'); doc[<N>].get_pixmap(dpi=96).save('builds/<new-folder>/cv-p<N>.png')"`;
  look at each.
- `deliver.wording-check` (`gate.example-wording`; `[]` passes):
  `python -c "import pymupdf,sys; t=''.join(p.get_text() for p in pymupdf.open(sys.argv[1])).lower(); print([w for w in ('fictional','illustrative','flagship') if w in t])" private/<envelope>/revisions/<revision>/cv.pdf`
- `deliver.report`: the revision folder, the PDF hash, the page count,
  what was checked on each page, any override, and every `WARNING:` and
  `NOTE:` line word for word. Clear the page PNGs by path. **Stop here.**
- The owner: `deliver.owner-review`, `deliver.approve`. Never approve a
  real client's PDF yourself.
- After his `Approval`: `deliver.export`
  (`python scripts/cv.py export private/<envelope> <revision>`), then
  `deliver.record-delete-by` ("Exported <date>, delete by <date + 12
  months>" in `README.md`) and `deliver.report-delete-by`.
- Once he says he sent it: `deliver.stamp-delivered`
  (`python scripts/outputs.py stamp private/<envelope>/revisions/<revision>/cv.pdf status=delivered`).
- `deliver.status`, any time: `python scripts/cv.py status private/<envelope>`.

## A new public example

Not a client step. Fictional data under
`examples/candidates/<name>-example.json` (copied from the closest record,
every value replaced), the entry under `examples/marine/flagship/<name>.typ`
(BC section 1), an entry in `examples/release.json` (with its `title` and
`variant`; `scripts/build.ps1` and `tests/run.py` both read it, and the
suite fails on an entry point missing there), and its own assertions in
`tests/run.py`.

1. Compile: `typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts <entry> builds/<name>-01.pdf`;
   it exits 0 even when a font is missing, so a
   `warning: unknown font family` line is a failure.
2. Render each page to PNG (the command above) and look at it.
3. Run `python tests/run.py` and confirm PASS.
4. Adding it to the `Release` (`./scripts/build.ps1 -ReplaceRelease`,
   which writes `<name>.pdf` and its `Meta File` beside the entry)
   replaces the other `Release` PDFs too, so it needs the owner's go
   (`docs/git-workflow.md`, "Releasing a new render").

Report the output path, the page count, what was checked on each page and
any override applied to the layout or theme.

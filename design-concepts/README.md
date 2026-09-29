# Design concepts

Proposals for new CV templates, each drawn as real one-page mock-ups on
fictional data. Produced by the `magazine-editor` agent through the `idea-run`
skill. Not library code: nothing here is imported by `packages/`, and a concept
becomes a template only after the owner keeps it and a build task is agreed.

Since 2026-09-29 a run has three very distinct styles, one folder each,
and every style is drawn in three `Design Tier`s: `safe.typ`, `stylish.typ`,
`creative.typ` (self-contained), their PDFs, a `<tier>.png` of each (96 dpi)
and one `brief.md` (idea, tiers, references, fonts with source and SHA-256,
data, weaknesses). Earlier folders hold one `concept.typ`, `concept.pdf`
and `page-1.png` instead. Downloaded font families live once in `fonts/<family>/`
with their licence and are shared between concepts. Compile from the repository root:

```powershell
typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/<folder>/<tier>.typ design-concepts/<folder>/<tier>.pdf
```

Every compile rewrites the PDF (Typst embeds the compile time). To check a
concept without changing it (reviewers and the lead), write to a new folder
under `builds/` instead. A wrong `--font-path` still exits 0 but falls back
to another font; Typst then warns `unknown font family`, so read the
warnings.

Every PDF here has a `Meta File` beside it (`<pdf-stem>.meta.json`: its
`Domain`, `Style`, idea, status and hash; the `Output Contract`,
`docs/pdf-workflow.md`), so stamp it after every compile:

```powershell
python scripts/outputs.py stamp <pdf> domain=<id> "candidate=<sample name>" "style=<Style name>" "idea=<three words>" status=proposed producedBy=magazine-editor
```

The `Design Review` app and the suite read these files, not this table: when
a concept's status changes, re-stamp its PDFs with the new status
(`parked`, `rejected` or `unresolved`; for `chosen`, only the `Design Tier`
he picked, `idea-run` step 8) as well as updating its row. An earlier flat run's `concept.pdf` also passes `kind=text-draft`.

| Concept | Idea | Date | Status | PDF |
|---|---|---|---|---|
| Measured in Months | The career drawn to scale: one bar per vessel, length = service months; marine and travel variants | 2026-09-25 | rejected (owner, 2026-09-27); removed in 7e9f619 | in Git history |
| Feature Opener | The CV as a magazine feature opener: headline name, standfirst, contents list, pull-quote; marine and travel variants | 2026-09-25 | rejected (owner, 2026-09-27); removed in 7e9f619 | in Git history |
| Fleet in Signs | Isotype count of the fleet: one sign per vessel, silhouette = class, colour = rank | 2026-09-25 | rejected (owner, 2026-09-27); removed in 7e9f619 | in Git history |
| First Fitting | `Text Draft` direction (not a CV template): the draft as a tailor's baste fitting; one copper thread, every fact tacked with a running stitch | 2026-09-27 | chosen (owner, 2026-09-28), built into `scripts/text-draft.typ` with his changes | [2 pages](2026-09-27-first-fitting/concept.pdf) |
| Stoichedon | `Text Draft` direction (not a CV template): every letter in its own square cell, as Attic inscriptions; facts rubricated in bold red ochre | 2026-09-27 | not picked (owner chose First Fitting, 2026-09-28); kept as inspiration | [2 pages](2026-09-27-stoichedon/concept.pdf) · [long name](2026-09-27-stoichedon/concept-long.pdf) |
| Two Inks | `Text Draft` direction (not a CV template): black is ours, orange is yours; facts overprint misregistered orange slabs, giant orange draft number and OK | 2026-09-27 | not picked (owner chose First Fitting, 2026-09-28); kept as inspiration | [2 pages](2026-09-27-two-inks/concept.pdf) · [long name](2026-09-27-two-inks/concept-long.pdf) |

# Build a CV for a real person

Read this when producing an actual CV. The public repository never receives
real data; everything below happens in the ignored `private/` folder.

## 1. Create the private workspace

One folder per candidate, named after the person and role:

```text
private/jane-doe-second-engineer/
  README.md              how to build, what was decided, where the evidence is
  candidate.json         candidate data
  cv.typ                 entry point
  portrait.<ext>         authorised photograph, jpg or png
  reference.pdf          the approved render, once there is one
  presentation.json      only for the custom path in section 7: data the schema cannot hold
```

`cv.typ`. The shipped layout's page plan assumes the example's six
companies, so a real candidate always overrides `pages` with their own
company indices, zero-based, in JSON order:

```typst
#import "../../packages/cv-engine/lib.typ": flagship
#import "../../packages/cv-engine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/cv-engine/templates/flagship/layouts/flagship-v11.typ": layout as base
#let layout = (..base, pages: (
  (companies: (0, 1)),
  (companies: (2,), synopsis: true, certificates: true, education: true),
))
#let candidate = json("candidate.json")
#show: flagship.with(candidate: candidate, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: true)
```

Three companies here: two open page one, the third closes page two with the
synopsis, certificates and education. Adjust the split after looking at the
render. Splitting one large company across pages is shown in
`../reference/layout-and-pagination.md`.

## 2. Fill the data

Copy `examples/candidates/engineer-example.json` or `examples/candidates/captain-example.json` and
replace every value. Field meanings and error messages are in
`../reference/candidate-schema.md`. Set `identity.portrait` to
`/private/jane-doe-second-engineer/portrait.<ext>` or `null`.

If you do not know months per vessel, set `show-vessel-durations: false` and
give each company a `service-months` total instead.

## 3. Compile

```powershell
typst compile --root . --font-path packages/cv-engine/fonts private/jane-doe-second-engineer/cv.typ builds/jane-doe-01.pdf
```

Use a new file name each time. For live editing:

```powershell
typst watch --root . --font-path packages/cv-engine/fonts private/jane-doe-second-engineer/cv.typ builds/jane-doe-preview.pdf
```

## 4. Fix what does not fit

Every failure names the fix. The common ones:

- A name, rank or contact too long for the hero: shorten it or override the
  size in the entry point, `theme: (..theme, sizes: (..theme.sizes, name: 30pt))`.
- `Page plan company index out of bounds`: the `pages` override does not
  match the number of companies in the JSON. Fix the indices.
- Overflow on a page: move a company to the next page or split it as shown
  in `../reference/layout-and-pagination.md`. Do not shrink the body font.

## 5. Look at every page

Open the PDF. Check the hero, the split between pages, the synopsis
position, and that education sits where you want it. Check the text is
selectable and the reading order makes sense for the portal you will submit
to.

## 6. Keep it private

Nothing under `private/` is tracked. Do not copy renders into `exports/`.
Do not commit certificate numbers, scans or passport details anywhere.

## 7. When the template does not fit

Some real CVs cannot go through `flagship` yet. The known causes are
recorded in `../framework-gaps.md`: a career recorded as contract periods
rather than service months (see the note in
`../reference/candidate-schema.md`), an approved design that needs a
three-column certificate table, and a skills block the template has no
slot for. Until the template supports these, compose the page by hand from
the same public exports:

```typst
#import "../../packages/cv-engine/lib.typ": (document-shell, page-header, hero, profile-summary,
  section-heading, skills-section)
// then place the hero, the sections and your own table below
```

The skills block is documented in `../reference/skills-component.md`. From a
private workspace folder the library is `../../packages/cv-engine/lib.typ`.

Rules for this path:

- Import from `packages/cv-engine/lib.typ`; never copy library code into the workspace.
- Keep the candidate JSON valid against the schema. Put data the schema
  cannot hold, such as contract periods, in a separate `presentation.json`
  beside it. Never invent months from calendar periods.
- Keep the approved render as `reference.pdf` in the folder and record in
  the folder's `README.md` why the custom composition exists and what it
  matched. Once the template can express the data, the entry point is
  rewritten to use `flagship` and compared against that reference.
- Add an entry to `docs/framework-gaps.md` saying what you needed, what
  you went around and what you built. That is how the gap gets closed.

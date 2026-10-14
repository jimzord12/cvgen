# Build a CV: the engine reference for a client's CV

The steps that design, build, render, approve and export a client's CV are
the `Workflow Model`'s `design` and `deliver` stages
([`docs/workflow/05-design/`](../workflow/05-design/README.md),
[`06-deliver/`](../workflow/06-deliver/README.md)); the checklist an agent
follows is the `new-cv` skill. **This file describes no step.** It is the
reference those steps use: how to write `typst/cv.typ` and `candidate.json`,
what the scripts print and refuse, what to do when a page does not fit, and
how to compose a page by hand. Everything here happens in the client's
`Envelope` under the ignored `private/` (its tree:
[`client-workflow.md`](client-workflow.md) section 1); the public repository
never receives real data.

## 1. The entry point, typst/cv.typ

Used by `design.entry-point`.

`typst/cv.typ`. Import the engine by root-absolute path (a leading `/` means the
repository root), so the copy the workflow keeps with each revision compiles
on its own; read the record one folder up, `json("../candidate.json")`.
The shipped layout's page plan assumes the example's six
companies, so a real candidate always overrides `pages` with their own
company indices, zero-based, in JSON order:

```typst
#import "/packages/domains/marine/lib.typ": (flagship, roles, flagship-themes,
  flagship-artwork, flagship-layouts)
// Pick each input by name: roles.engine or roles.deck, flagship-themes.golden-blue or
// .silver-bridge, flagship-artwork.engineer or .captain.
#let base = flagship-layouts.flagship-v11
#let layout = (..base, pages: (
  (companies: (0, 1)),
  (companies: (2,), synopsis: true, certificates: true, education: true),
))
#let candidate = json("../candidate.json")
#show: flagship.with(candidate: candidate, role: roles.engine, theme: flagship-themes.golden-blue,
  artwork: flagship-artwork.engineer, layout: layout, show-vessel-durations: true)
```

Three companies here: two open page one, the third closes page two with the
synopsis, certificates and education. Adjust the split after looking at the
render. Splitting one large company across pages is shown in
`../engine/layout-and-pagination.md`. The shipped plan fails with `Page
plan company index out of bounds` for fewer than six companies, or `Page
plan must cover each vessel row once, in candidate order` for more.

A short career (a cadet or junior officer) goes on one page with
`flagship-one-page.typ` instead: pass
`layout: flagship-layouts.one-page(candidate)`; it plans the candidate's own companies, so
no override is needed. Render with `python scripts/cv.py render private/<envelope>
--pages 1`. Whether a record fits is in
`../engine/layout-and-pagination.md`, "Choosing a profile".

## 2. The record and the example wording

Used by `design.fill-data` and, for the wording, `deliver.wording-check`.

Copy `examples/candidates/engineer-example.json`, `captain-example.json` or
`chief-officer-example.json` and replace every value; keep stable ids.
Field meanings and error messages are in
`../engine/candidate-schema.md`. Set `identity.portrait` to
`/private/<envelope>/images/portrait/portrait.<ext>` (a path from the
repository root, which both a direct compile and the workflow
accept) or to `null`. A path relative to the `Envelope`,
`images/portrait/portrait.<ext>`, works only through `scripts/cv.py render`, which copies
the file into the revision; the direct compiler cannot find it.

If you do not know months per vessel, set `show-vessel-durations: false` and
give each company a `service-months` total instead.

`scripts/cv.py render` checks the record against the schema its entry
point's imports name (the Flagship input for marine, needs `jsonschema`)
and lists the offending field paths; the engine's compile-time assertions
then check totals. A one-off `Template` that imports only the `Framework`
gets no schema check: keep `identity.name` and `identity.portrait`, and run
`normalize-common` and `validate-common` in its `cv.typ`.

**Replace the example wording.** Three defaults exist for the fictional
examples and would otherwise print on a real CV:

| Where it shows | Default | Set it in |
|---|---|---|
| Footer, left, every page | `FICTIONAL CANDIDATE & AI PORTRAIT / DESIGN STUDY` | `"disclosure"` in `candidate.json` |
| Certificates heading subtitle | `Illustrative register - dates and credentials are fictional` | `copy: (certificates-subtitle: ...)` in `cv.typ` |
| Footer, right, before the page number | `FLAGSHIP` | `copy: (brand: ...)` in `cv.typ` |

```json
"disclosure": "CURRICULUM VITAE - SEPTEMBER 2026",
```

```typst
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: true,
  copy: (certificates-subtitle: "Certificates of competency and endorsements", brand: "JANE DOE"))
```

An empty string (`""`) leaves a slot blank. `deliver.wording-check`
searches the rendered PDF for "fictional", "illustrative" and "flagship";
its gate, `gate.example-wording`, states the one exception.

## 3. What the scripts print and refuse

Not a step: what `scripts/cv.py` and `scripts/outputs.py` do when a step
runs them (`deliver.render`, `deliver.approve`, `deliver.export`,
`deliver.status`, the stamps). Run every `scripts/cv.py` command from the
repository root; the `Envelope` path is relative to it. They need the
Python packages in `requirements.lock`, like the test suite.

**`render`.** Every render is a new folder under `revisions/`, named by
timestamp plus a random suffix, holding a snapshot of the inputs, the
compiler log, the PDF, its checks and its `Meta File` (`cv.meta.json`,
`status: render`, filled from `envelope.json`). Nothing in an existing
revision is ever rewritten, except that its `Meta File` is re-stamped when
its status changes (`approved`, then `delivered`). The command prints the
revision id, the PDF's SHA-256, the schema the record was checked against
and whether the
automated checks passed (page count, no empty page, fonts embedded, text
inside the page, every font family bundled: Typst sets a missing one in
another font, so it fails the checks). Exit code 1 means the compiler or
a check failed; the revision stays, with the error in its `render.log` or
`checks.json`, and the fix is a new revision. Exit code 2 prints
`REFUSED: <reason>`: the inputs are not usable (an `Envelope` without
`envelope.json`, `candidate.json` or `typst/cv.typ`, one that still keeps
`cv.typ` at its root, invalid
JSON, a record that breaks its schema - the offending fields are listed
with their paths, the first ten and then a count - a missing portrait file, no Typst on PATH), and the reason
names the fix. Nothing is written on a refusal. Its options: `--pages N`
(the page count the checks expect, default 2), `--input key=value`
(passed to `typst --input`; `lang=<xx>` also goes into the `Meta File`),
`--typst <path>` and `--reference-date` (below).

**The `Certificate Warning`.** Certificate dates are checked against the day of the render: a
certificate whose expiry (the fourth field, or `review`) has passed, or
falls within 180 days, prints a `WARNING:` line naming it, and `status`
repeats it for that revision. Warnings never fail the render or block
approval (owner, 2026-09-25): the owner reads them before he approves, and
the date is renewed, updated or reworded if needed. Only dates written like `14 Jul 2029`
are checked; when some are not, render prints a `NOTE:` line with the
count, and the summary, `status` and `checks.json` carry the counts and the
day used (`reference_date`; `--reference-date YYYY-MM-DD` sets it).

**A preview.** For live editing while you adjust the page plan, the compiler still works
directly; write to a fresh name under `builds/`:

```powershell
typst watch --root . --ignore-system-fonts --font-path packages/cv-framework/fonts private/<envelope>/typst/cv.typ builds/<new-folder>/preview.pdf
```

A preview is not a revision: what is approved and exported is always a
`revisions/<id>/cv.pdf`.

**`approve`.** It writes `cv.approval.json` beside the PDF, bound to the
revision id and the hash, and re-stamps the revision's `Meta File`
`approved`. It refuses an `Envelope` without `envelope.json` (the
`Meta File` follows the receipt), and refuses if the bytes changed since the render, if the checks
failed or are stale, or if the hash passed (`--sha256`, the first 12 or
more characters of the hash the owner reviewed) does not match.

**`export`.** It copies the approved bytes and the receipt into
`exports/<revision-id>/` after verifying render, checks and approval, then
verifies the copy. It never compiles. Running it again on a finished export
verifies and returns the same bundle; a folder with different content is
never overwritten.

**`outputs.py stamp`.** It refuses `delivered` without the revision's
approval receipt and its verified `Export`, `approved` without the receipt
(`cv.py approve` stamps `approved` itself), and `signed-off` without the
`Sign-off` screenshot (owner's decision #8; `../pdf-workflow.md`, "Output Contract").

**`status`** lists every revision with a one-word state, which is a
listing, never a proof. Its words and the `Meta File`'s statuses map like
this:

| `cv.py status` | The revision's `Meta File` | Meaning |
|---|---|---|
| `failed` | none (no PDF) | the compile failed; `render.log` says why |
| `checks-failed` | `render` | a check failed; never approvable |
| `rendered` | `render` | checks passed, not approved |
| `approved` | `approved` | the receipt is beside it, no `Export` yet |
| `exported` | `approved`, then `delivered` once the owner has sent it | a verified copy is in `exports/<revision-id>/` |
| `changed`, `corrupt`, `incomplete`, `export-conflict` | as last stamped | a file was changed or broken by hand; approve and deliver nothing from it |

## 4. Fix what does not fit

Used by `deliver.fix`. Every failure names the fix. The common ones:

- A name, rank or contact too long for the hero: shorten it or override the
  size in the entry point, `theme: (..theme, sizes: (..theme.sizes, name: 30pt))`.
- `Page plan company index out of bounds`: the `pages` override does not
  match the number of companies in the JSON. Fix the indices.
- Overflow on a page: move a company to the next page or split it as shown
  in `../engine/layout-and-pagination.md`. Do not shrink the body font.

## 5. When the template does not fit

Used by `design.custom-composition`.

Some real CVs cannot go through `flagship` yet. The known causes are
recorded in `../framework-gaps.md`: a career recorded as contract periods
rather than service months (see the note in
`../engine/candidate-schema.md`), an approved design that needs a
three-column certificate table, and a skills block the template has no
slot for. Until the template supports these, compose the page by hand from
the same public exports:

```typst
#import "/packages/domains/marine/lib.typ": (make-ctx, normalize-candidate, to-flagship-input, marine,
  core-components as cc, flagship-components as fc, flagship-themes, flagship-artwork, flagship-layouts)
#let theme = flagship-themes.golden-blue
#let artwork = flagship-artwork.engineer
#let layout = flagship-layouts.flagship-v11
// The shell reads copy.brand and disclosure, so the record goes through the adapter first.
// copy is not allowed in candidate.json; replace the example wording here (section 2).
#let d = normalize-candidate(to-flagship-input(json("../candidate.json"),
  copy: (certificates-subtitle: "Certificates of competency and endorsements", brand: "JANE DOE")))
// One ctx for every component: theme, layout, artwork, the composed wording, switches (ADR 0008).
#let ctx = make-ctx(theme: theme, layout: layout, artwork: artwork, copy: d.copy,
  options: (show-vessel-durations: true))
// document-shell takes the PDF metadata as named arguments.
#show: cc.document-shell.with(ctx, d,
  title: d.identity.name + " | " + d.identity.rank + " | " + marine.meta.title, author: marine.meta.author)
#fc.hero(ctx, d)
#fc.profile-summary(ctx, d.profile)
#fc.section-heading(ctx, "Experience", number: "01", spacing: layout.headings.opening)
// page 2 onward: #cc.page-header(ctx, (name: d.identity.name, headline: d.identity.rank), caption: "EXPERIENCE / CREDENTIALS")
// then the other sections and your own table below
```

Entry points reach components only through `lib.typ`: `core-components`
holds the page shell and the small pieces, `flagship-components` every
Flagship section (`docs/conventions.md`). The skills block is
documented in `../engine/skills-component.md`. The root-absolute import
works from any `Envelope`. `marine` is the domain node exported by
`lib.typ` (`docs/engine/domains-and-roles.md`).

Rules for this path:

- Import from `packages/domains/marine/lib.typ`; never copy library code into the `Envelope`.
  A client whose domain does not exist yet imports `/packages/cv-framework/lib.typ`
  only (render then checks no schema; `design.port-concept`).
- Keep the candidate JSON valid against its schema, if it has one. Put data the schema
  cannot hold, such as contract periods, in a separate `typst/presentation.json`
  beside `cv.typ`. Never invent months from calendar periods.
- Read every `Envelope` file by a literal path relative to `cv.typ`
  (`json("presentation.json")`, `#import "designs/table.typ"`, `image("art/map.svg")`,
  `image("../images/portrait/portrait.jpg")`).
  `render` finds these reads, follows local `.typ` helpers, copies each file
  into the `Revision` and records its hash in `render.json`. It refuses a
  root-absolute path into `private/` (the revision would read the live
  file), a path that leaves the `Envelope`, and a missing file. A computed
  path (`image(d.photo)`) is not found by the scan; if its file is not in
  the snapshot the compile fails, and if it reads a live file the revision's
  checks fail, so it cannot be approved.
- The hand-composed render goes through the same `deliver` steps: its
  entry point is still `typst/cv.typ`. Record in
  the folder's `README.md` why the custom composition exists and what it
  matched. Once the template can express the data, the entry point is
  rewritten to use `flagship` and compared against the approved revision.
- Add an entry to `docs/framework-gaps.md` saying what you needed, what
  you went around and what you built (`design.framework-gap`). That is how the gap gets closed.

### A composition written before 2026-09-25

The flat names with the old signatures (`hero(identity, contacts, theme, artwork, geometry)`
and the like) were removed on 2026-10-14 (TASK-58), so such a composition
fails at import. Rewrite it with `make-ctx`, `core-components as cc` and
`flagship-components as fc` as in the example above; the old-to-new mapping
table, one row per name, stays in Git history:
`git show 70631ed:docs/guides/build-a-cv.md` (section 8, "Migrating a composition written before 2026-09-25").

The page shell reads `layout.shell` (`docs/engine/layout-and-pagination.md`):
a layout written before TASK-45 renames `opening-margin` to `shell.margin`
and `hero.band-height` to `shell.band`. `flagship` refuses the old keys;
`cc.document-shell` and `cc.page-background` cannot name them and ignore
them, so a custom composition renames them first.

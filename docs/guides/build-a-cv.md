# Build a CV for a real person

Read this when producing an actual CV. The public repository never receives
real data; everything below happens in the ignored `private/` folder.

A new client starts with [the client workflow](client-workflow.md): intake,
research and the client's `Sign-off` on the text. This guide takes over
from there, with the facts in `intake/facts.md` and the signed-off draft.

## 1. Create the private workspace

One folder per client, the `Envelope`, named after the person and their
`Rank` (the client workflow has usually created it already):

```text
private/jane-doe-second-engineer/
  README.md              how to build, what was decided, where the evidence is
  envelope.json          who the client is, once: alias, domain, candidate, rank (below)
  intake/, research/, draft/   from the client workflow; not copied into a revision unless cv.typ reads them (it should not)
  candidate.json         candidate data
  cv.typ                 entry point
  portrait.<ext>         authorised photograph, jpg or png
  presentation.json      only for the custom path in section 8: data the schema cannot hold
  revisions/             one folder per render, written by scripts/cv.py (section 3)
  exports/               one folder per exported revision, written by scripts/cv.py (section 6)
```

`envelope.json` names the client for every `Meta File` written in the
`Envelope` (the `Output Contract`, `../pdf-workflow.md`); `render` refuses
a workspace without it. `domain` is an id from the glossary's `Domain` row;
`candidate` is the display name, which never leaves `private/`:

```json
{"alias": "client-2026-09-01", "domain": "marine", "candidate": "Jane Doe", "rank": "Second Engineer"}
```

`cv.typ`. Import the engine by root-absolute path (a leading `/` means the
repository root), so the copy the workflow keeps with each revision compiles
on its own. The shipped layout's page plan assumes the example's six
companies, so a real candidate always overrides `pages` with their own
company indices, zero-based, in JSON order:

```typst
#import "/packages/domains/marine/lib.typ": flagship
#import "/packages/domains/marine/roles/engine/role.typ": role   // or roles/deck
#import "/packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "/packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "/packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout as base
#let layout = (..base, pages: (
  (companies: (0, 1)),
  (companies: (2,), synopsis: true, certificates: true, education: true),
))
#let candidate = json("candidate.json")
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: true)
```

Three companies here: two open page one, the third closes page two with the
synopsis, certificates and education. Adjust the split after looking at the
render. Splitting one large company across pages is shown in
`../reference/layout-and-pagination.md`.

A short career (a cadet or junior officer) goes on one page with
`flagship-one-page.typ` instead: import `one-page` from it and pass
`layout: one-page(candidate)`; it plans the candidate's own companies, so
no override is needed. Render with `python scripts/cv.py render <folder>
--pages 1`. Whether a record fits is in
`../reference/layout-and-pagination.md`, "Choosing a profile".

## 2. Fill the data

Copy `examples/candidates/engineer-example.json` or `examples/candidates/captain-example.json` and
replace every value. Field meanings and error messages are in
`../reference/candidate-schema.md`. Set `identity.portrait` to
`/private/jane-doe-second-engineer/portrait.<ext>` (a path from the
repository root, which both the preview in section 3 and the workflow
accept) or to `null`. A path relative to the workspace folder,
`portrait.<ext>`, works only through `scripts/cv.py render`, which copies
the file into the revision; the direct compiler cannot find it.

If you do not know months per vessel, set `show-vessel-durations: false` and
give each company a `service-months` total instead.

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

An empty string (`""`) leaves a slot blank. Before approving, search the
rendered PDF's text, ignoring case, for "fictional", "illustrative" and
"flagship": none may appear. The one exception is "flagship" in the
candidate's own words (a profile may mention "the company's flagship"), and
only once the footer shows the configured brand; never edit the candidate's
text to pass the check. This prints `[]`
when the PDF is clean:

```powershell
python -c "import pymupdf,sys; t=''.join(p.get_text() for p in pymupdf.open(sys.argv[1])).lower(); print([w for w in ('fictional','illustrative','flagship') if w in t])" private/jane-doe-second-engineer/revisions/<id>/cv.pdf
```

## 3. Render a revision

Every render is a new folder under `revisions/`, named by timestamp plus a
random suffix, holding a snapshot of the inputs, the compiler log, the PDF,
its checks and its `Meta File` (`cv.meta.json`, `status: render`, filled
from `envelope.json`). Nothing in an existing revision is ever rewritten,
except that its `Meta File` is re-stamped when its status changes
(`approved` by section 6, `delivered` when the owner sends it).

```powershell
python scripts/cv.py render private/jane-doe-second-engineer            # --pages 3 for a three-page plan
```

Run every `scripts/cv.py` command from the repository root; the workspace
path is relative to it. The command prints the revision id, the PDF's
SHA-256, the schema the record was checked against and whether the
automated checks passed (page count, no empty page, fonts embedded, text
inside the page). Exit code 1 means the compiler or a check failed; the
revision stays, with the error in its `render.log` or `checks.json`, and the
fix is a new revision. Exit code 2 prints `REFUSED: <reason>`: the inputs
are not usable (a workspace without `envelope.json`, `candidate.json` or `cv.typ`, invalid
JSON, a record that breaks its schema - the offending fields are listed
with their paths, the first ten and then a count - a missing portrait file, no Typst on PATH), and the reason
names the fix. Nothing is written on a refusal.
Needs Python with `pymupdf` and `jsonschema` like the test suite.

Certificate dates are checked against the day of the render: a
certificate whose expiry (the fourth field, or `review`) has passed, or
falls within 180 days, prints a `WARNING:` line naming it, and `status`
repeats it for that revision. Warnings never fail the render or block
approval (owner, 2026-09-25): read them before you approve, and renew,
update or reword the date if needed. Only dates written like `14 Jul 2029`
are checked; when some are not, render prints a `NOTE:` line with the
count, and the summary, `status` and `checks.json` carry the counts and the
day used (`reference_date`; `--reference-date YYYY-MM-DD` sets it).

For live editing while you adjust the page plan, the compiler still works
directly; write to a fresh name under `builds/`:

```powershell
typst watch --root . --font-path packages/cv-framework/fonts private/jane-doe-second-engineer/cv.typ builds/jane-doe-preview.pdf
```

A preview is not a revision: what you approve and export is always a
`revisions/<id>/cv.pdf`.

## 4. Fix what does not fit

Every failure names the fix. The common ones:

- A name, rank or contact too long for the hero: shorten it or override the
  size in the entry point, `theme: (..theme, sizes: (..theme.sizes, name: 30pt))`.
- `Page plan company index out of bounds`: the `pages` override does not
  match the number of companies in the JSON. Fix the indices.
- Overflow on a page: move a company to the next page or split it as shown
  in `../reference/layout-and-pagination.md`. Do not shrink the body font.

## 5. Look at every page

Open `revisions/<id>/cv.pdf`. Check the hero, the split between pages, the
synopsis position, and that education sits where you want it. Check the
text is selectable and the reading order makes sense for the portal you
will submit to. Anything to change means editing the inputs and rendering a
new revision; the one you looked at is never modified.

## 6. Approve and export

Approval is the owner's explicit act on the exact bytes reviewed. It writes
`cv.approval.json` beside the PDF, bound to the revision id and the hash,
and re-stamps the revision's `Meta File` `approved`; the command refuses if the bytes changed since the render, if the checks
failed or are stale, or if the hash you pass does not match:

```powershell
python scripts/cv.py approve private/jane-doe-second-engineer <revision-id> --approver "Jim" --sha256 <first 12+ characters of the hash you reviewed>
```

Export copies the approved bytes and the receipt into
`exports/<revision-id>/` after verifying render, checks and approval, then
verifies the copy. It never compiles. Running it again on a finished export
verifies and returns the same bundle; a folder with different content is
never overwritten.

```powershell
python scripts/cv.py export private/jane-doe-second-engineer <revision-id>
python scripts/cv.py status private/jane-doe-second-engineer               # every revision and its state
```

Export means ready to deliver; sending the PDF is a separate, manual act.
Once the owner has sent it, re-stamp the revision:
`python scripts/outputs.py stamp private/jane-doe-second-engineer/revisions/<id>/cv.pdf status=delivered`.
A new revision, for any reason, inherits no approval: review, approve and
export it again. The lifecycle and the records are specified in
`../pdf-workflow.md`.

## 7. Keep it private

Nothing under `private/` is tracked by this repository. `private/` is its own
private Git repository: commit and push the `Envelope` there, scans included,
with commit messages that name the client only by `Alias`. Do not copy renders
into `examples/`, where the public fictional `Release` lives. Never commit
certificate numbers, scans or passport details to this public repository.

## 8. When the template does not fit

Some real CVs cannot go through `flagship` yet. The known causes are
recorded in `../framework-gaps.md`: a career recorded as contract periods
rather than service months (see the note in
`../reference/candidate-schema.md`), an approved design that needs a
three-column certificate table, and a skills block the template has no
slot for. Until the template supports these, compose the page by hand from
the same public exports:

```typst
#import "/packages/domains/marine/lib.typ": (make-ctx, normalize-candidate, to-flagship-input, marine,
  core-components as cc, flagship-components as fc)
#import "/packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "/packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "/packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
// The shell reads copy.brand and disclosure, so the record goes through the adapter first.
// copy is not allowed in candidate.json; replace the example wording here (section 2).
#let d = normalize-candidate(to-flagship-input(json("candidate.json"),
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
Flagship section (`docs/conventions.md`). The flat names such as `hero` or
`section-heading` still work with their old signatures, for compositions
written before 2026-09-25, but are deprecated. The skills block is
documented in `../reference/skills-component.md`. The root-absolute import
works from any workspace folder. `marine` is the domain node exported by
`lib.typ` (`docs/reference/domains-and-roles.md`).

Rules for this path:

- Import from `packages/domains/marine/lib.typ`; never copy library code into the workspace.
  A client whose domain does not exist yet imports `/packages/cv-framework/lib.typ`
  only (render then checks no schema; `client-workflow.md` section 9).
- Keep the candidate JSON valid against its schema, if it has one. Put data the schema
  cannot hold, such as contract periods, in a separate `presentation.json`
  beside it. Never invent months from calendar periods.
- Read every workspace file by a literal path relative to `cv.typ`
  (`json("presentation.json")`, `#import "parts/table.typ"`, `image("map.png")`).
  `render` finds these reads, follows local `.typ` helpers, copies each file
  into the `Revision` and records its hash in `render.json`. It refuses a
  root-absolute path into `private/` (the revision would read the live
  file), a path that leaves the workspace, and a missing file. A computed
  path (`image(d.photo)`) is not found by the scan; if its file is not in
  the snapshot the compile fails, and if it reads a live file the revision's
  checks fail, so it cannot be approved.
- Approve and export the hand-composed render through the same workflow
  (sections 3 and 6): its entry point is still `cv.typ`. Record in
  the folder's `README.md` why the custom composition exists and what it
  matched. Once the template can express the data, the entry point is
  rewritten to use `flagship` and compared against the approved revision.
- Add an entry to `docs/framework-gaps.md` saying what you needed, what
  you went around and what you built. That is how the gap gets closed.

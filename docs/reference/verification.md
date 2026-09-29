# Verification

Read this to know what `python tests/run.py` proves and how to read its
output.

## Run

```powershell
python tests/run.py                       # Typst on PATH
python tests/run.py --typst C:/path/to/typst.exe
```

Output goes to a new `builds/tests-<timestamp>/` folder with a
`report.json` and one folder per case (ADR 0013): `<case>.pdf`,
`compile.log` with the compiler's stderr, and for a case checked visually
`check/result.json`, a `page-N.png` of every page rendered by the suite,
and on a raster mismatch `check/diff-N.png` highlighting changed pixels.
The page images are what to show the owner or a reviewer.

## What it checks

1. **Frozen inputs.** Every path in `tests/baseline.json` still has its
   recorded SHA-256. Runs first and last.
2. **Engineer exact match.** `examples/marine/flagship/engineer.typ` renders two pages that
   equal `packages/domains/marine/templates/flagship/tests/approved/Marine-Engineer-CV-v11.pdf` pixel for pixel at 144 dpi,
   with identical whitespace-normalised text per page.
3. **Hidden durations.** The same example with `vessel-durations=false` keeps
   every vessel name and rank at the same coordinates and emits no duration
   text.
4. **Captain examples.** Both compile to two pages; silver and classic have
   identical text; no "Engineer" wording appears.
5. **Chief Officer example.** Compiles to two pages without a portrait; the
   name, first and last company, total, disclosure, certificate heading and
   the default `FLAGSHIP` brand all appear. Rendered again with
   `brand=SILVER BRIDGE`, the new brand replaces the default and every other
   word keeps its position, which proves the `copy` argument reaches the page
   through the adapter and nothing else moves.
6. **Deck Cadet example.** `deck-cadet.typ` on the one-page profile
   (`flagship-one-page.typ`) compiles to exactly one page with the name,
   both companies, the total, and the certificate and education headings.
   The `one-page.typ` fixture repeats this for one and three companies.
7. **Every PDF.** Expected page count, no empty page, all fonts embedded, no
   text outside the page.
8. **Fixtures under `tests/fixtures/`:**

| Fixture | Cases |
|---|---|
| `configuration.typ` | Theme validates; frozen geometry constants (hero 77mm, page-two bottom margin 11mm, backdrop 94mm) |
| `content.typ` | Experience, synopsis, certificates and education compose on one page |
| `data.typ` | The core leaves `copy` empty and the adapter composes it domain < role < template < record < argument (a role overrides only domain words; arrays are replaced); duration parts, totals 138 months / 23 vessels / 6 companies, vessel dedup, company-only months; rejects missing months, mismatched totals, negative months, a blank identity name |
| `role.typ` | A role's wording reaches page one through `flagship` |
| `core-model.typ` | The core paginates a domain with no ships (row model supplied by the domain); `merge`/`compose` semantics |
| `components.typ` | Hero renders with and without portrait or contacts; rejects a name or email that does not fit |
| `options.typ` | Company-only months, all optional fields empty, a long vessel name whose duration wraps, with and without durations |
| `pagination.typ` | Three pages with a company split across pages; rejects overflow and duplicate allocation |
| `one-page.typ` | The one-page profile's `one-page` plan on the deck cadet record cut to one company with one vessel (`case=one`, synopsis reads "1 VESSEL" and "1 COMPANY") and on three companies with three vessels and three certificate rows, the measured edge (`case=three`), one page each. Refused: `case=overflow` (the same with one vessel more: "Content overflow on planned page 1"). `spread`: on `case=one` the synopsis stays within 17mm of the Experience block and the two flexible gaps are each over 15mm and differ by less than 8mm, so a thin record never gets one hole; on `case=no-education` and `case=no-certificates` (one closing section missing) the blocks stack from the top `stack-gap` apart, each gap text to text between 17 and 32mm |
| `particulars.typ` | The engineer record with `Vessel Particulars` on five ships: the suffix text on each row and every other word exactly where the engineer example has it; refuses a repeated vessel with a different value, an unknown unit, a zero value, an extra key and a row too long to fit |
| `certificate-continuation.typ` | Fifty rows, header repeats on page two |
| `skills.typ` | Titles, one to three columns, wrapping, two themes, SVG and plain bullets (through the `lib.typ` wrapper) |
| `contract.typ` | 31 of the 32 ctx-first components rendered alone, one per page, headed by its name (ADR 0008 fixtures); `document-shell` wraps a whole document and is covered by `legacy-parity.typ` |
| `text-draft.typ` | The `Text Draft` (`scripts/text-draft.typ`, house design First Fitting): two pages, the Greek `Check Page` first with the house headline, client name, date and a sample fact; the content second with its running head (`Page 2 of 2`); Bona Nova as the only font; the copper `Fact Mark` under fact words on both pages and none under our wording. `case=long` (a long legal name, seven rows): no overlapping words below the tag. Refused: `case=full` (one row too many: "the Check Page runs past one page") and `case=english` (no house copy: names the missing keys) |
| `legacy-parity.typ` | One five-page custom composition written with all 32 deprecated pre-contract names marine's `lib.typ` exports (9 from the Framework's `lib.typ`, 23 from Flagship) (`api=legacy`) and with `core-components`/`flagship-components` (`api=contract`); every page must be pixel-identical with the same number of `/Artifact` tags, both PDFs carry the title and author passed to `document-shell`, page 5 (only `page-background`, shell background off) must show more than one colour, and the suite fails if a legacy name exported by `lib.typ` is not called outside a comment (textual check: a call inside a never-invoked `#let` still counts) |

9. **Example records.** Before any compile, every record an example entry
   point reads validates against the schema its imports select (the Flagship
   input schema for all five), with the same code `scripts/cv.py render`
   uses, and every entry point must contribute a record; the
   template-over-domain choice is also pinned for role-first imports, an
   entry importing only marine's `lib.typ` (Flagship's schema), only the
   Framework's `lib.typ` (no schema), marine's `lib.typ` with a marine role,
   marine's `lib.typ` with a non-marine domain (no schema) and domains under
   a folder named `templates`; a record with 23 bad values is refused with
   ten lines and a count. The two marine schemas share identical `$defs`;
   a record with vessel particulars is accepted and a `hp` power unit refused.

10. **Framework boundary.** Every `import`/`include` in `packages/cv-framework/core/*.typ` names a bare sibling file; `packages/cv-framework/lib.typ` imports only `core/` files; no Framework `.typ` file names a `domains/` path outside a comment; every domain file that imports a core file does so through `cv-framework/core/` (ADR 0011, 0012).

11. **Candidate workflow** (`tests/workflow.py`). A fresh fictional workspace
   under the run's `workflow/` folder is driven through the real
   `scripts/cv.py`: render (the revision's PDF must equal the frozen v11
   reference, the snapshot must be self-contained, `checks.json` bound to
   the hash), approval only with the reviewed hash and a name, test-only
   approval refused under `private/`, export with no compiler on PATH,
   repeated export untouched, a later revision without approval, a copied
   receipt, bytes changed after approval, failing and stale checks, a
   failed compile kept with its log, a data error naming a Greek company
   that reaches `render.log` intact, refused renders (bad JSON, missing
   portrait, a record that breaks its schema - misspelt key, wrong type,
   null value, missing required field, a bad certificate field - with every
   field path named) that leave no folder, a receipt rewritten for other bytes, a
   revision without `render.json`, a leftover partial export, a
   conflicting destination and a bundle with a different receipt,
   a workspace without `envelope.json` refused before anything is written,
   the revision's `Meta File` (`render`, then `approved`, filled from
   `envelope.json`),
   certificate dates (against a fixed reference date: expired and
   within-180-day certificates warn in render, `status` and `checks.json`
   without failing the render or blocking approval; unchecked dates are
   counted; a broken certificate block never breaks `status`), and a
   one-off `Framework`-only entry (schema null, one page) whose sibling
   data, local helper and files read after a URL are snapshotted and
   hashed and compile after the live files are gone; live reads are
   refused (root-absolute into `private/` or the workspace, outside the
   workspace, missing, taking the portrait's place) or, when computed,
   fail the checks and block approval.
   `commands.log` holds every command with its output and exit code.

12. **Output Contract** (`output-contract (N PDFs)`). Every PDF in
   `design-concepts/`, `examples/` and a stray root `exports/` sits in its
   home with a valid `Meta File` whose hash matches the PDF
   (`docs/pdf-workflow.md`, "Output Contract"); the assertion lists each
   PDF that fails and why.

Negative cases assert on the exact error text so a message change is a test
change.

## Reading a failure

- `AssertionError: ('engineer', ...)` with stderr: the example does not
  compile. Read `engineer/compile.log`.
- `Raster mismatch on page N`: open `engineer/check/diff-N.png`. Any non-black pixel
  is a change from v11.
- `Frozen file changed: <path>`: an input under the manifest was edited.
  Either revert it or follow the constitution's procedure for a new
  reference.

## Adding a check

Add a fixture with `sys.inputs` cases, then a few lines in `run.py` that
compile it and assert on the PDF. Keep the runner linear and readable; it is
the specification of what "passing" means.

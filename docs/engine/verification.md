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

CI (`.github/workflows/verify.yml`) installs the Python packages from
`requirements.lock` (hash-checked), runs `ruff check` (`ruff.toml`), installs
Bun from `tools/workflow/.bun-version` and runs the workflow tool's
`bun install --frozen-lockfile`, `bun test`, `bun run typecheck`,
`bun run check`, `bun run render --check` and `bun run atlas --check`
(`tools/workflow/README.md`), and then the suite on every push (when and
why: `docs/tech-stack.md`, CI row) on a Linux and a Windows runner, writing to `builds/ci/`
(on both, the suite itself runs `scripts/build.ps1` in a throwaway copy: check 14), and on
Windows also runs `scripts/build.ps1` on the checkout. Each runner uploads its evidence,
the `build-script/<shell>.log` files included, as the artifact
`verification-evidence-Linux` or `verification-evidence-Windows` (the
Windows one also holds the PDFs that build wrote, one per example in
`examples/release.json`); `gh run download <run-id>` fetches them.

## What it checks

1. **Frozen inputs.** Every path in `tests/baseline.json` still has its
   recorded SHA-256. Runs first and last.
2. **Engineer exact match.** `examples/marine/flagship/engineer.typ` renders two pages that
   equal `packages/domains/marine/templates/flagship/tests/approved/Marine-Engineer-CV-v11.pdf` pixel for pixel at 144 dpi,
   with identical whitespace-normalised text per page, and its PDF title and
   author are the ones `flagship` passes to `document-shell`.
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
   text outside the page. Every compile reads only the bundled fonts
   (`--ignore-system-fonts --font-path packages/cv-framework/fonts`, plus
   Typst's own embedded fonts), and a case whose output has
   `warning: unknown font family` fails: Typst would otherwise set that
   text in another font and exit 0.
8. **Fixtures under `tests/fixtures/`:**

| Fixture | Cases |
|---|---|
| `configuration.typ` | Golden Blue passes Flagship's theme check (`validate-flagship-theme`); frozen geometry constants (hero 77mm, page-two bottom margin 11mm, backdrop 94mm) |
| `theme.typ` | The core's `validate-theme` accepts a theme with only `ink`, `accent`, `metal`, `muted` and `paper` (`case=core`) and refuses one without any of them (`case=core-missing`, five cases); through `flagship`, a Golden Blue theme without `hero`, `surface`, `plate`, `rule` or `on-hero` (`case=missing`, five cases) is refused with "Missing theme color: <key>", and one whose `plate` is a string (`case=not-color`) with "Theme color must be a color: plate" (TASK-59) |
| `content.typ` | Experience, synopsis, certificates and education compose on one page |
| `data.typ` | The core leaves `copy` empty and the adapter composes it domain < role < template < record < argument (a role overrides only domain words; arrays are replaced); duration parts, totals 138 months / 23 vessels / 6 companies, vessel dedup, company-only months; rejects missing months, mismatched totals, negative months, a blank identity name |
| `role.typ` | A role's wording reaches page one through `flagship` |
| `core-model.typ` | The core paginates a domain with no ships (row model supplied by the domain) and accepts a plan with no synopsis (closing sections are a template's rule); `merge`/`compose` semantics |
| `components.typ` | Hero renders with and without portrait or contacts; rejects a name or email that does not fit |
| `options.typ` | Company-only months, all optional fields empty, a long vessel name whose duration wraps, with and without durations |
| `pagination.typ` | Three pages with a company split across pages; rejects overflow and duplicate allocation, and through Flagship's `validate-plan` a plan with no synopsis and certificates before the last Experience page |
| `retired-keys.typ` | A layout that still sets `opening-margin` or `hero.band-height` (replaced by `shell.margin` and `shell.band`) is refused through `flagship` with a message naming the `shell` key (two cases) |
| `one-page.typ` | The one-page profile's `one-page` plan on the deck cadet record cut to one company with one vessel (`case=one`, synopsis reads "1 VESSEL" and "1 COMPANY") and on three companies with three vessels and three certificate rows, the measured edge (`case=three`), one page each. Refused: `case=overflow` (the same with one vessel more: "Content overflow on planned page 1"). `spread`: on `case=one` the synopsis stays within 17mm of the Experience block and the two flexible gaps are each over 15mm and differ by less than 8mm, so a thin record never gets one hole; on `case=no-education` and `case=no-certificates` (one closing section missing) the blocks stack from the top `stack-gap` apart, each gap text to text between 17 and 32mm |
| `particulars.typ` | The engineer record with `Vessel Particulars` on five ships: the suffix text on each row and every other word exactly where the engineer example has it; refuses a repeated vessel with a different value, an unknown unit, a zero value, an extra key and a row too long to fit |
| `certificate-continuation.typ` | Fifty rows, header repeats on page two |
| `fonts.typ` | A font family that is not bundled is refused: when a family exists nowhere (`case=missing`) and when it exists only among the machine's fonts (`case=system`, the first plain family `typst fonts` lists that is not bundled, chosen at run time: it fails only while `--ignore-system-fonts` is passed). With no such font on the machine, `fonts-system` and `workflow-system-font-fails-checks` are printed as `SKIPPED` and recorded in `report.json` with the reason; on CI (`CI` set) that fails the suite instead, and `.github/workflows/verify.yml` installs `fonts-dejavu-core` on its Linux runner so both cases run there (the Windows runner ships its own fonts) |
| `skills.typ` | Titles, one to three columns, wrapping, two themes, SVG and plain bullets (through `flagship-components`); the compass bullet keeps Golden Blue's baked brass and teal (`#c8a579`, `#236a70`) in the gold section and shows neither pixel colour in the Silver Bridge section (the theme's `art-palette` is applied) |
| `contract.typ` | 31 of the 32 ctx-first components rendered alone, one per page, headed by its name (ADR 0008 fixtures); `document-shell` wraps a whole document and is covered by the examples (item 2: the engineer PDF's title and author) |
| `text-draft.typ` | The `Text Draft` (`scripts/text-draft.typ`, house design First Fitting): two pages, the Greek `Check Page` first with the house headline, client name, date and a sample fact; the content second with its running head (`Page 2 of 2`); Bona Nova as the only font; the copper `Fact Mark` under fact words on both pages and none under our wording. `case=long` (a long legal name, seven rows): no overlapping words below the tag. Refused: `case=full` (one row too many: "the Check Page runs past one page") and `case=english` (no house copy: names the missing keys) |

9. **Example records.** Before any compile, every record an example entry
   point reads validates against the schema its imports select (the Flagship
   input schema for every listed example), with the same code `scripts/cv.py render`
   uses, and every entry point must contribute a record; the
   template-over-domain choice is also pinned for role-first imports, an
   entry importing only marine's `lib.typ` (Flagship's schema), only the
   Framework's `lib.typ` (no schema), marine's `lib.typ` with a marine role,
   marine's `lib.typ` with a non-marine domain (no schema) and domains under
   a folder named `templates`; a record with 23 bad values is refused with
   ten lines and a count. The two marine schemas share identical `$defs`;
   a record with vessel particulars is accepted and a `hp` power unit refused.

10. **Framework boundary.** Every `import`/`include` in `packages/cv-framework/core/*.typ` names a bare sibling file; `packages/cv-framework/lib.typ` imports only `core/` files; no Framework `.typ` file names a `domains/` path outside a comment; every domain file that imports a core file does so through `cv-framework/core/` (ADR 0011, 0012). Outside comments, Framework code also uses no marine or Flagship word (vessel, ship, marine, flagship, synopsis, rank, ...) or Flagship layout key (`opening-margin`, `band-height`, ...), reads no layout key or artwork slot it does not own (an allowlist: `paper`, `width`, `height`, `shell`, `header`, `footer`; `background-first`, `background-continuation`) or theme colour it does not own (`ink`, `accent`, `metal`, `muted`, `paper`, and `hero` for the shell's optional band), names no Flagship colour (`hero`, `plate`, `on-hero`, `surface`, `rule`) as a string, so the core theme check cannot require one (TASK-59), and holds no colour literal: a hex string, a colour constructor (`rgb`, `cmyk`, `luma`, `oklab`, `oklch`, `hsl`, `hsv`, `linear-rgb`) or a named colour other than `white` and `black` (TASK-45). Comments are removed by a scan that also matches string literals, so `//` inside a string does not hide the rest of its line.

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
   the `Envelope` layout (`typst/cv.typ` reading `../candidate.json`, the
   snapshot mirroring it under `inputs/`) and the old flat layout (a root
   `cv.typ`) refused by all four commands with the move to make,
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
   fail the checks and block approval; a one-off naming a font family that
   is not bundled (one that exists nowhere, and the run's system-only
   family) renders but fails the checks with the family named, and
   approval is refused.
   `commands.log` holds every command with its output and exit code.

12. **Output Contract** (`output-contract (N PDFs)`). Every PDF in
   `studio/design-concepts/`, `examples/` and a stray root `exports/` sits in its
   home with a valid `Meta File` whose hash matches the PDF
   (`docs/pdf-workflow.md`, "Output Contract"); the assertion lists each
   PDF that fails and why.
13. **Repo maintenance** (`repo-maintenance: <check>`, `tests/repo_maintenance.py`).
   The `repo-maintenance` skill's audit script on throwaway Git
   repositories seeded with known problems (every check fires, tiers,
   `--baseline`, `--since`, CVgen's layer: protected paths, allowed
   duplicates and versioned names, a mention of an ignored area is not a
   dead path), and the auditor agent's read-only frontmatter.
14. **Example list and `scripts/build.ps1`** (`example-list`, `build-script-<shell>-<check>`,
   `tests/release.py`). The examples of checks 2 to 6 are compiled from
   `examples/release.json`, the list `build.ps1` reads; the suite fails when
   an entry point under `examples/` is missing from it or it names one that
   does not exist. Then the real `build.ps1` runs under every PowerShell on
   the machine (`pwsh`, and on Windows also Windows PowerShell 5.1) in a
   throwaway copy under the run's `build-script/` folder, with the list cut
   to `deck-cadet`: the suite refuses that list, a list without its
   `examples` key, or with an entry lacking its `title`, makes `build.ps1` refuse before it builds, a plain build writes only
   `deck-cadet.pdf`, `-Release` over an existing `Release` exits non-zero
   with `Refused: the Release already exists` and builds nothing, leaving the
   PDF and its `Meta File` byte-identical, `-Release` with no `Release`
   writes it with a current `Meta File`, and `-ReplaceRelease` replaces it.
   `build-script/<shell>.log` holds each command's output. With no
   PowerShell at all the case is `SKIPPED`; on CI that fails the suite.
15. **Proposals** (`proposals: <check>`, `tests/proposals.py`). The real
   `scripts/proposals.py` on fixture folders under `proposals/`: the exact
   summary line (a different count in every state), the JSON snapshot,
   refusal of an existing output folder, and one refusal per rule (id,
   duplicate id, kind, status, a reference with a status, `rejected/` both
   ways, revision, missing, invalid or future `created`, no opening block);
   then `docs/proposals/` itself must give the line its files add up to.
16. **Workflow Model** (`workflow-model`). The workflow tool's
   `bun run check` on `docs/workflow`: levels 1 and 2 of ADR 0015, every
   rule in `tools/workflow/README.md` ("What `check` proves"), with this
   run's Python for the `--help` calls; its output, the placeholder-cap
   `NOTE` included, is in `workflow-model/check.log`. Then
   `bun run render --check`: the generated blocks of the workflow READMEs
   must be what the model renders to (`render.log`), and `bun run atlas --check`:
   the `Atlas` page `.atlas/src/pages/client-journey.json` must be what the
   model generates (`atlas.log`). A checkout without
   `tools/workflow/node_modules` gets `bun install --frozen-lockfile` first
   (`install.log`). The rules' own broken fixtures run in `bun test`, not
   here. With no Bun on the machine the case is `SKIPPED`; on CI that fails
   the suite.

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
- `AssertionError: ('<case>', 'warning: unknown font family: <family> ...')`
  with exit code 0 from Typst: the case names a font family that is not
  bundled. Fix the name or add the font to `packages/cv-framework/fonts`.
- `AssertionError: ('fonts-system', 'CI has no font outside the bundled
  ones, ...')`: the CI runner found no system font for the system-font
  case; check the font install step in `.github/workflows/verify.yml`
  (Linux; the Windows runner relies on its own fonts).
- `SKIPPED N: <cases> (reasons in report.json)` after the `PASS` line: those
  cases did not run on this machine (the system-font cases, when it has no
  font outside the bundled ones; `build-script`, when it has no
  PowerShell; `workflow-model`, when it has no Bun). The run passed without
  them.
- `AssertionError: ('workflow-model', ...)`: the Workflow Model check
  failed; each problem names its file, line, path and `[rule]`
  (`tools/workflow/README.md`). Fix the YAML in `docs/workflow`, or rerun
  `bun run check` in `tools/workflow/` to iterate. A `STALE <README>` line
  instead: the YAML changed without `bun run render`, or a generated block
  was edited by hand, or `tools/workflow/src/render.ts` changed without a
  re-render; run `bun run render` and commit the READMEs. `FAILED render`
  with a `README.md:<line>`: a malformed, unknown, repeated, nested or
  unclosed marker there; fix the marker line. `STALE .atlas/src/pages/client-journey.json`:
  the model or `tools/workflow/src/atlas.ts` changed without `bun run atlas`, or the
  page was edited by hand; run `bun run atlas` (it also stamps the page) and commit
  the `.atlas/` changes.
- `AssertionError: entry points not in examples/release.json, ...`: an
  example was added without its line in `examples/release.json` (or a
  line was removed); add the line with its `title` and `variant`.

## Adding a check

Add a fixture with `sys.inputs` cases, then a few lines in `run.py` that
compile it and assert on the PDF. Keep the runner linear and readable; it is
the specification of what "passing" means. Checks are bare `assert`s, so
`run.py` refuses to start under `python -O` or `PYTHONOPTIMIZE`, which would
strip them.

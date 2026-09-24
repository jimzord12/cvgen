# Verification

Read this to know what `python tests/run.py` proves and how to read its
output.

## Run

```powershell
python tests/run.py                       # Typst on PATH
python tests/run.py --typst C:/path/to/typst.exe
```

Output goes to a new `builds/tests-<timestamp>/` folder. It contains every
compiled PDF, a `.log` with the compiler's stderr per case, a `report.json`,
and per-check folders with `result.json` and, on a raster mismatch, a
`diff-N.png` highlighting changed pixels.

## What it checks

1. **Frozen inputs.** Every path in `tests/baseline.json` still has its
   recorded SHA-256. Runs first and last.
2. **Engineer exact match.** `examples/marine/flagship/engineer.typ` renders two pages that
   equal `packages/cv-engine/domains/marine/templates/flagship/tests/approved/Marine-Engineer-CV-v11.pdf` pixel for pixel at 144 dpi,
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
6. **Every PDF.** Expected page count, no empty page, all fonts embedded, no
   text outside the page.
7. **Fixtures under `tests/fixtures/`:**

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
| `certificate-continuation.typ` | Fifty rows, header repeats on page two |
| `skills.typ` | Titles, one to three columns, wrapping, two themes, SVG and plain bullets (through the `lib.typ` wrapper) |
| `contract.typ` | Each of the 31 ctx-first components rendered alone on its own page, headed by its name (ADR 0008 fixtures) |
| `legacy-parity.typ` | One custom composition written with `lib.typ`'s pre-contract names (`api=legacy`) and with the ctx-first components (`api=contract`); every page must be pixel-identical |

8. **Core boundary.** Every `import`/`include` in `packages/cv-engine/core/*.typ` names a bare sibling file; the core never reaches a domain (ADR 0011).

8. **Candidate workflow** (`tests/workflow.py`). A fresh fictional workspace
   under the run's `workflow/` folder is driven through the real
   `scripts/cv.py`: render (the revision's PDF must equal the frozen v11
   reference, the snapshot must be self-contained, `checks.json` bound to
   the hash), approval only with the reviewed hash and a name, test-only
   approval refused under `private/`, export with no compiler on PATH,
   repeated export untouched, a later revision without approval, a copied
   receipt, bytes changed after approval, failing and stale checks, a
   failed compile kept with its log, a data error naming a Greek company
   that reaches `render.log` intact, refused renders (bad JSON, missing
   portrait) that leave no folder, a receipt rewritten for other bytes, a
   revision without `render.json`, a leftover partial export, a
   conflicting destination and a bundle with a different receipt.
   `commands.log` holds every command with its output and exit code.

Negative cases assert on the exact error text so a message change is a test
change.

## Reading a failure

- `AssertionError: ('engineer', ...)` with stderr: the example does not
  compile. Read the `.log`.
- `Raster mismatch on page N`: open `exact/diff-N.png`. Any non-black pixel
  is a change from v11.
- `Frozen file changed: <path>`: an input under the manifest was edited.
  Either revert it or follow the constitution's procedure for a new
  reference.

## Adding a check

Add a fixture with `sys.inputs` cases, then a few lines in `run.py` that
compile it and assert on the PDF. Keep the runner linear and readable; it is
the specification of what "passing" means.

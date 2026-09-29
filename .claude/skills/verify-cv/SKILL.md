---
name: verify-cv
description: Run the CVgen regression suite and produce readable evidence. Use after any change under packages/, examples/ or tests/, and before publishing those changes to main or reporting them as done.
---

# Verify

## Run

```powershell
python tests/run.py
```

Requires Typst 0.15.1 on PATH and Python with `pymupdf`, `pillow` and `jsonschema`. Pass
`--typst <path>` if Typst is elsewhere. Every run writes to a new
`builds/tests-<timestamp>/` folder, one sub-folder per case with its PDF,
`compile.log` and, for a checked case, `page-N.png` and `check/`.

## Read the result

- Last line `PASS: N compilation cases ...` with the evidence path: done.
- `Frozen file changed: <path>`: an input in `tests/baseline.json` was
  edited. Revert it unless the change is a deliberate new reference
  following `docs/constitution.md` section 1.
- `Raster mismatch on page N`: open `<evidence>/engineer/check/diff-N.png`. Any
  non-black pixel is a deviation from v11. Decide whether the change was
  intended; if not, fix the cause.
- `AssertionError: ('<case>', '<stderr>')`: a fixture failed to compile or
  compiled when it should have failed. Read `<evidence>/<case>/compile.log`.
- `Text mismatch on page N`: the page looks the same but its extractable text
  differs from v11 (wording, order or a hidden character). Compare the page
  text of both PDFs.
- `example record <file> (read by <entry>) breaks its schema: ...`: a
  fictional record no longer matches its schema; the lines after it name
  the field paths (the first ten, then a count). Fix the record (or the
  schema, if the change is meant).
- `ImportError` or `ModuleNotFoundError` naming `jsonschema` at the start
  of the run: the dependency is missing or older than 4.0:
  `pip install "jsonschema>=4"`.
- `core/<file> imports outside core: <target>`: a core module reached into a
  domain or `lib.typ`; the core must import only its siblings (ADR 0011).
  `the Framework lib.typ imports outside core`, `... names a domain path` or
  `... reaches a core file outside the Framework`: the Framework touched a
  domain, or a domain file bypassed `cv-framework/` to reach the core
  (ADR 0012).
- An `AssertionError` from `tests/workflow.py`: a candidate-workflow step
  misbehaved. Its repr shows the command arguments, expected and actual exit
  code, stdout and stderr, or the render/check record that failed. A failure
  naming `engine_uncommitted_changes` means engine files are uncommitted:
  commit them and rerun.
- An `AssertionError` listing `<pdf>: no Meta File`, `... is stale`,
  `not in a home of the Output Contract` or `the root exports/ is
  retired`: a public PDF breaks the `Output Contract`
  (`docs/pdf-workflow.md`). Re-stamp it (`python scripts/outputs.py stamp
  <pdf> status=<status>`; for the `Release`, `./scripts/build.ps1
  -Release`), or move a stray PDF into its home or under `builds/`.
  `python scripts/outputs.py check` lists the same without the suite.

## Visual evidence for a visual change

The suite renders every page of each checked case: use
`<evidence>/<case>/page-N.png` and include its path in the report. Render
by hand only a PDF the suite does not render (a real client's revision,
say), at 96 dpi:

```python
import pymupdf
doc = pymupdf.open("private/<envelope>/revisions/<id>/cv.pdf")
doc[0].get_pixmap(dpi=96).save("builds/<new-folder>/cv-p1.png")
```

## Report

Always give: the command, the last line of output, the evidence folder, and
for visual work the PNG you inspected. "Tests pass" without a path is not a
report.

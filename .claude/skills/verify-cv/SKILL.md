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
`builds/tests-<timestamp>/` folder.

## Read the result

- Last line `PASS: N compilation cases ...` with the evidence path: done.
- `Frozen file changed: <path>`: an input in `tests/baseline.json` was
  edited. Revert it unless the change is a deliberate new reference
  following `docs/constitution.md` section 1.
- `Raster mismatch on page N`: open `<evidence>/exact/diff-N.png`. Any
  non-black pixel is a deviation from v11. Decide whether the change was
  intended; if not, fix the cause.
- `AssertionError: ('<case>', '<stderr>')`: a fixture failed to compile or
  compiled when it should have failed. Read `<evidence>/<case>.log`.
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

## Visual evidence for a visual change

Render the changed page at 96 dpi and include the PNG path in the report:

```python
import pymupdf
doc = pymupdf.open("builds/.../engineer.pdf")
doc[0].get_pixmap(dpi=96).save("builds/.../engineer-p1.png")
```

## Report

Always give: the command, the last line of output, the evidence folder, and
for visual work the PNG you inspected. "Tests pass" without a path is not a
report.

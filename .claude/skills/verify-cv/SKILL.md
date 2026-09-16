---
name: verify-cv
description: Run the marine-cv regression suite and produce readable evidence. Use after any change under packages/, examples/ or tests/, and before publishing those changes to main or reporting them as done.
---

# Verify

## Run

```powershell
python tests/run.py
```

Requires Typst 0.15.1 on PATH and Python with `pymupdf` and `pillow`. Pass
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

# cv-workflow

Everything around a candidate render: fresh revisions, automated checks,
the owner's approval receipt and the verified export. Specified in
`docs/pdf-workflow.md` (ADR 0010); the commands are in
`docs/guides/build-a-cv.md`. The engine renders; this package never sends,
publishes or deletes a PDF.

## Functions

Python 3.11, standard library plus `pymupdf` for the render checks. Called
by `scripts/cv.py` today and by the future web backend later:

```python
from cv_workflow import render_revision, approve_revision, export_revision, workspace_status, WorkflowError
render_revision(workspace, typst='typst', pages=2, inputs={})      # -> revision id, sha256, checks_passed
approve_revision(workspace, revision_id, approver, sha256, test_only=False)
export_revision(workspace, revision_id)                            # -> export folder, existing flag
workspace_status(workspace)                                        # -> state and hash prefix per revision
```

A `workspace` is a folder inside the repository checkout (`private/<name>`,
or under `builds/` for fixtures) holding `candidate.json` and `cv.typ`. Every
refusal raises `WorkflowError` whose message names the reason and the next
step; nothing is overwritten on the way.

## What each step writes

`revisions/<id>/`, id = UTC timestamp plus a random suffix, never reused:

| File | Written by | Holds |
|---|---|---|
| `inputs/cv.typ` | render | the entry point, verbatim |
| `inputs/candidate.json` | render | the record with `identity.portrait` repointed at `inputs/assets/` |
| `inputs/assets/` | render | the portrait actually used |
| `render.log` | render | compiler output, also for failed runs |
| `render.json` | render | status, engine commit and dirty flag, compiler version and command, input hashes and imports, PDF hash |
| `checks.json` | render | page count, empty pages, fonts, bounds; `pdf_sha256` of the bytes checked |
| `cv.pdf` | render | the PDF, on success |
| `cv.approval.json` | approve | revision id, sha256, approver, time, scope `owner` or `test-only` |

`exports/<id>/cv.pdf` and `cv.approval.json` are byte copies, made in a
`.partial-<id>-<suffix>` folder and renamed into place after verification.

## The refusal rules

- Render checks the record and locates the portrait before it creates the
  revision folder, so a refusal leaves nothing; compiler output is decoded
  as UTF-8 so a Greek name in an error survives the Windows console codec.
- Approve and export need `render.json` with `status: success` and a
  `cv.pdf` whose hash still equals the recorded one, and a `checks.json`
  that passed for exactly that hash. A folder without `render.json` is an
  interrupted render.
- Approve needs an approver name and the reviewed hash (twelve or more
  hex characters of it). An existing matching receipt is reported, never
  rewritten; a different one is refused. `test_only` is refused for any
  workspace under `private/`.
- Export needs the receipt for this revision id and this hash. A finished
  export whose bytes match is returned; a folder with anything else in it
  is left untouched and reported. Export never calls the compiler.

The suite (`tests/workflow.py`, part of `python tests/run.py`) exercises
every rule above through `scripts/cv.py` on a fictional workspace.

# Review round 1 (CI fix): a137b05

Follow-up to the revision-snapshot merge (20622b4), whose CI run on
ubuntu-latest failed. Reviewer: `code-reviewer`, fresh context, 2026-09-28.
Lead lenses: Correctness (the diagnosis holds across platforms), Tests with
Integrity (the skip hides no product gap).

## What changed

`tests/workflow.py`, step 10: the `/./Private/...` refusal row now runs only
where `os.name == 'nt'`. On Linux `Private/` is a different folder from
`private/`, so `live_path` rightly treats it as a repository read. The scan
then reached `parts/link.txt`, which the test had deleted earlier, and
refused with "does not exist" instead of the expected message.

## Verdict: PASS

- Diagnosis confirmed by a pathlib probe on Python 3.11.15. The only new
  code in `tests/` since the last green run is step 10, and nothing else in
  it depends on the platform.
- Full suite rerun at a137b05: PASS, 52 cases.
- CI on a137b05 (ubuntu-latest): success.

## Notes and dispositions

- **N1** (pre-existing, not from a137b05): on macOS the filesystem ignores
  case, but Python compares POSIX paths case-sensitively. A `/Private/...`
  read would therefore be neither refused nor caught as a `Live Read`.
  Smallest fix: casefold both sides in `live_path`.
  *Disposition:* deferred. The owner works on Windows, it needs a
  deliberate odd spelling, and approval stays bound to the reviewed bytes.
  Revisit if a macOS machine joins.
- **N2:** no row covers the `resolve()` step itself; only a `..` spelling
  such as `/packages/../private/...` needs it.
  *Disposition:* deferred. A regression there is still caught after the
  compile, because Typst normalises `..` in its dependency list.

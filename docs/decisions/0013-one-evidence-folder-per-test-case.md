# 0013. One evidence folder per test case

Date: 2026-09-28
Status: Accepted (owner, 2026-09-28: "I love it! Make it also a short ADR")

## Context

`python tests/run.py` wrote each case's PDF and compiler log flat into the
run folder, and a checked case's `result.json` (and diff images) into a
sibling folder named `<case>-check` or `exact`. One case's evidence was
split in two places. The page images shown to the owner and to the
`design-reviewer` were not suite output at all: the lead rendered them by
hand afterwards, sometimes from a different run than the final one.

## Decision

Every case gets its own folder in the run folder, holding all of its
evidence: `<case>.pdf`, `compile.log`, and for a case the suite checks
visually, `check/result.json` (plus `diff-N.png` on a raster mismatch)
and a `page-N.png` of every page, rendered by the suite at 110 dpi.
`report.json` stays at the top and names the folder of each case that
has one (the candidate workflow's checks share `workflow/`).

```text
builds/tests-<timestamp>/
  report.json
  engineer/  engineer.pdf  compile.log  page-1.png  page-2.png  check/result.json
  deck-cadet/  deck-cadet.pdf  compile.log  page-1.png  check/result.json
  overflow/  compile.log          (a case that must fail keeps only its log)
  workflow/  ...                  (the candidate workflow's own workspace)
```

## Consequences

- One place to look per case, and the page images are the tested output,
  so evidence cannot drift from the run it claims.
- A run takes a few seconds longer and its folder is larger (17
  checked cases render PNGs today; internal fixtures that are not checked
  visually do not).
- Paths in docs and skills change: the v11 diff is now
  `engineer/check/diff-N.png`, a compile log `<case>/compile.log`. Older
  run folders keep the old layout; nothing reads them.

## Review round 1: code-reviewer, 2026-10-14

Snapshot: `refactor/task-59-theme-neutral` at e607f76, base origin/main 9a8ed1c (14 files). Lead lenses: seams and wiring; test strength.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: the only caller of `validate-theme` is `flagship.typ:40` inside `validate-flagship-theme`, called at `:60` where the old call was; not exported from either `lib.typ`; no design concept, script or private composition calls it (private CVs use the legacy `document-shell`, which never validated the theme); messages identical (a theme missing several colours may now report a different one first; acceptable); docs, skill and Atlas consistent.

Findings
- R1-01 Minor: the core check is tested for one of its five colours (tests/run.py:202, tests/fixtures/theme.typ:16): removing `ink`, `accent`, `metal` or `paper` from the core list keeps the suite green. Fix: loop the core-missing case over the five keys.

Notes
- N1: the core may read `hero` with dot syntax (allowlisted, documented in run.py:40 and verification.md item 10) but may never name it as a string, so a band guard such as `"hero" in theme.colors` is refused; theme.md marks `hero` "yes (Flagship)" without saying a template that asks the core for a band needs it. Optional: one clause in theme.md; later a neutral name for the band colour.
- N2: the boundary rule can be bypassed on purpose (aliasing, concatenation, raw text); same weakness as the layout allowlist; acceptable.

Checks rerun: suite exit 0, PASS 112 incl. the engineer pixel gate (`builds/tests-20261014-095124-797277` in the worktree); mutations in a disposable copy: `rule` dropped from Flagship's list, Flagship calling only the core check, type assert removed: caught; `ink` dropped from the core list: survived (R1-01); boundary probes as in N2; `atlas check` all ok.

Limitations: private revision snapshots not searched; no visual review (the pixel gate covers the frozen reference).

## Dispositions (lead)

- R1-01: fix (loop over the five keys). N1: add the theme.md clause. N2: accepted. A context-reviewer round follows for the docs.

## Review round 1 (code): code-reviewer, 2026-10-14

Snapshot: `refactor/task-58-legacy-delete` at e92c619, base 70631ed (24 files, +99/-378). Lead lenses: nothing reaches a deleted name and the new metadata assertion guards what parity did; the boundary test and `contract.typ` still enforce the contract.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: every example and fixture imports `flagship` or `make-ctx` plus `flagship-components`; no flat-name import left in the public tree (greps over .claude, .codex, .github, scripts, examples, design-concepts, archive); `retired-keys` still refuses both keys through `flagship`; the accepted gap is narrower than "silently ignores" (`cc.document-shell` asserts `shell.margin` exists, `page.typ:43`, so only a layout with both old and new keys passes silently); frozen v11 pixel-identical; `baseline.json` lists no deleted file; an old composition now fails at import, loudly.

Findings
- m1 Minor: `docs/vision.md:137-138` roadmap item 4 says the deprecated wrappers stay. Fix: past tense, removed by TASK-58.

Notes
- n1: ADR 0012:31 mentions the wrappers; a dated decision record, left as history.
- n2: nothing useful lost with `legacy-parity`: it only proved the wrappers forwarded correctly; `page-background` is covered by the v11 pixel match, metadata by the new assertion; no check counts decoration `/Artifact` tags absolutely (neither did the old one). `check_core_boundary` had no legacy allowlist; `contract.typ` still requires 31 components, the 32nd proven through the engineer metadata.

Checks rerun: suite exit 0, 142 cases (`builds/tests-20261014-113438-279670` in the worktree); mutation in a disposable copy: removing `set document(title: title)` from `core/page.typ` keeps pixels equal but the new title assertion (`run.py:240-241`) fails.

Limitations: private/ not opened (the author's private comparison not verified); the old frozen private snapshot not examined; no Linux CI run.

## Dispositions (lead)

- m1: fixed (same line as the context round's M1). n1, n2: accepted.

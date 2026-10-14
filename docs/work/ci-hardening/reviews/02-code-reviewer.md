## Review round 2: code-reviewer, 2026-10-14

Snapshot: `ci/task-48-hardening` at 05320e0 (author delta `d4b8dbf..8dea477` plus 75ad56e and 05320e0; merge 4c46266 spot-checked). Lead lenses: the concurrency expression; pinning and cache.

Verdict: PASS. Recorded in substance (formatting condensed).

Lens 1: the expression is valid (the workflow parsed and ran on 05320e0); `a && b || c` is safe because `github.sha` is never empty. On main the group is `verify-<sha>`, one push per group, so no pending main run can be replaced; a SHA group cannot collide with a `verify-refs/heads/...` group; on feature branches the group is per ref with cancel-in-progress (run 38520434543 cancelled by the next push).

Lens 2: the only `pip install` line pins all three packages; setup-python's prefix restore-key restores pip's download cache only, pip still resolves the exact pins (both 05320e0 jobs logged pillow-12.3.0 pymupdf-1.28.2 jsonschema-4.26.0), so a stale cache cannot hide a version change.

Findings
- m2 Minor: the task record (`backlog/tasks/task-48 ...md:51`) still said pillow stays unpinned while line 54 records it fixed. Fix: amend line 51.

Notes
- N4: transitive dependencies of jsonschema float (attrs, referencing, ...); would show as a red run, not hide one; a constraints file belongs with TASK-47.
- N5: TASK-47's description, `docs/work/workflow-model/handoff.md:294` and `docs/tech-stack.md:22` (local setup, unpinned) still describe pillow as unpinned; TASK-47's scope.
- N6: a `workflow_dispatch` on main at a SHA whose push run is still running joins `verify-<sha>` and waits; harmless.

Checks rerun: `gh run view 38521920254` and its log (success on both OSes, checksum OK, typst 0.15.1, pinned versions, PASS 98, 5 CVs); `gh run view 38521749564 --log` (restore-key path); `gh run list` (cancelled run seen); `atlas.py check --strict` exit 0. Suite not rerun (CI ran it on both OSes; local report passed).

Limitations: the main side of the group expression has not run in CI (GitHub's documented rule, settled); merged main content reviewed only via the Atlas check; the doc edits also need a context-reviewer round.

## Dispositions (lead)

- m2: fixed, the record line now says pillow was pinned after round 1. N4, N5: carried to TASK-47 (lead adds a note there at its start). N6: accepted. A context-reviewer round follows.

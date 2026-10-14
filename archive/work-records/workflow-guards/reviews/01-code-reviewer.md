## Review round 1: code-reviewer, 2026-10-14

Snapshot: `.worktrees/task-44`, `feature/task-44-workflow-guards`, `git diff 7acccd8..f456358`. Lead lenses: correctness of the guards at their seams; test strength.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: every stamp goes through `stamp()`; `cv.py render` stamps `render`, `approve` writes the receipt then stamps `approved` and its heal path never downgrades `delivered`; `build.ps1` stamps `release`; the Design Review server stamps nothing; no script compiles a `Text Draft`, and the guide (client-workflow.md:261-270), the new-client skill (:62-70) and the Atlas pair compile with `status=ready` and set `sent` only after the owner confirms; a stale receipt fails (revision and sha256 compared, `verify_bundle` checks the export); a refusal happens before `write_json`; the kind rename is breaking but only the one concept used the old kind; one function in the owning module; docs, glossary, schema and Atlas agree.

Findings
- R1-01 Minor: the revision half of the receipt binding is untested (outputs.py:157; tests/workflow.py:441): removing `approval.get('revision') != pdf.parent.name or` survives. Fix: one refused stamp with the right sha256 but another revision.
- R1-02 Minor: the task record was not updated (status Queued, criteria unchecked, no evidence). Fix: Active, evidence, criteria.

Notes
- R1-03: the `reference.pdf` exemption matches on file name only (outputs.py:151); not abusable through the CLI today. Optional: require `home_of(pdf) == {'kind': 'client-cv'}`.
- R1-04: legacy real data: 8 `delivered` revisions without receipt or export and one `signed-off` draft without its screenshot; `check` stays silent by design (decision #8), but any later re-stamp of those is refused. Tell the owner.
- R1-05: tests call `outputs.stamp` directly (the CLI cannot stamp outside a home); the manual walk covers the CLI.

Checks rerun: 9 single-line mutations of a copy of `outputs.py` replayed against the guard sequence (tests/workflow.py:425-459): 8 caught, `no-revision-check` survived (`builds/review-task44-r1-mutations-20261014-094005/mutations.log` in the worktree). Full suite and Atlas not rerun.

Limitations: private/ read only for Meta File kind; the author's legacy count not verified.

## Dispositions (lead)

- R1-01, R1-02: fix. R1-03: tighten (cheap). R1-04: reported to the owner in the final report. R1-05: accepted. A context-reviewer round follows for the docs, glossary and skill.

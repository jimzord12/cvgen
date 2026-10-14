---
id: TASK-48
title: 'ci-hardening: CI pinned, checksummed, and covering Windows'
status: Review
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 06:23'
labels:
  - restructure
dependencies: []
ordinal: 48000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Pin actions by SHA; checksum the Typst download; pip cache; a Windows job (the owner works on Windows; `build.ps1` is never run in CI); run once per change, not push plus PR. Source: docs/work/workflow-model/handoff.md, section 4, item 16 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Every action in .github/workflows/verify.yml is pinned by full commit SHA with a version comment, each SHA verified against the tag through the GitHub API
- [x] #2 The Typst 0.15.1 download is checked against a recorded SHA-256 on both runners, and the build fails on a mismatch; the hash source is recorded
- [x] #3 pip downloads are cached between runs (setup-python cache, keyed on the workflow file that lists the pinned dependencies)
- [x] #4 A Windows job runs python tests/run.py and scripts/build.ps1 on a Windows runner with the checksummed Typst; the Linux job keeps fonts-dejavu-core
- [x] #5 Each pushed commit triggers one run (push to any branch plus manual dispatch; no pull_request duplicate, no tag-push duplicate), and the choice is explained in docs/tech-stack.md
- [x] #6 A run on the pushed branch head is green on both Linux and Windows, with run IDs recorded in the notes; local python tests/run.py PASS; Atlas check --strict exit 0
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Resolve action SHAs and Typst asset digests (gh api, plus a local download hash). 2. Rewrite verify.yml as a two-OS matrix: pinned runners ubuntu-24.04 and windows-2025, push(branches **)+workflow_dispatch, concurrency, read-only permissions. 3. Update docs/tech-stack.md and docs/reference/verification.md. 4. Push the branch, watch the run, iterate to green. 5. Atlas check/stamp, local suite, notes.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
Owner: Claude implementation agent (lead runs review and merge). Branch/worktree: `ci/task-48-hardening` in `.worktrees/task-48`. Integration target: `main`.

- `.github/workflows/verify.yml` rewritten: one `suite` job as a matrix on pinned `ubuntu-24.04` and `windows-2025` (fail-fast off). `ubuntu-latest` moves to Ubuntu 26.04 from 2026-10-19; pinning makes an image move a deliberate commit.
- Triggers: `push` on `branches: ['**']` plus `workflow_dispatch`. No `pull_request` (the project uses no PRs, docs/git-workflow.md, so it would only rerun the same commit) and no tag-push runs. Concurrency cancels a superseded run on a feature branch; `main` keeps every run because git-workflow.md watches each published main commit. `permissions: contents: read`.
- Actions pinned by full commit SHA, latest releases, each resolved with `gh api repos/<repo>/git/ref/tags/<tag>` (lightweight tags, type commit) and cross-checked with `gh api repos/<repo>/commits/<tag>`: actions/checkout v7.0.1 `3d3c42e5aac5ba805825da76410c181273ba90b1`; actions/setup-python v7.0.0 `5fda3b95a4ea91299a34e894583c3862153e4b97`; actions/upload-artifact v7.0.2 `cf430e030ddbb5b0abf93d22962f4752f3646cd9`. Majors moved from v4/v5/v4; release notes show no input this workflow uses was removed (setup-python v7 dropped `pip-install`, unused).
- Typst 0.15.1 SHA-256 from the `digest` GitHub records for each release asset (`gh api repos/typst/typst/releases/tags/v0.15.1`), cross-checked by downloading both assets locally on 2026-10-14 (`Get-FileHash`): linux-musl tar.xz `a6d077d0...118c`, windows-msvc zip `19ce3551...6736` (full values in the workflow `env`). Linux: `sha256sum --check --strict`; Windows: `Get-FileHash` compare and `throw`. Both guards proven to fail on a wrong file locally (pwsh exit 1 with "Typst download checksum mismatch"; sha256sum "FAILED", exit 1). Downloads go to `$RUNNER_TEMP`, not the checkout.
- pip cache: `setup-python` `cache: pip` keyed on `.github/workflows/verify.yml` (the file that lists the pinned dependencies). First run saved, second run "Cache hit" on both OSes.
- Windows job also runs `./scripts/build.ps1 -OutputDirectory builds/ci-library` (5 CVs created); the PDFs ride in the `verification-evidence-Windows` artifact. Linux keeps `fonts-dejavu-core`. `fonts-system` ran on both (no SKIPPED in report.json).
- Docs: `docs/tech-stack.md` CI row (triggers and why, pinning, checksum, cache), `docs/reference/verification.md` (CI paragraph, Linux-only font step). Atlas: `site.json` github-ci role and `system-map` n-ci blurb; change-review, roster, system-map re-stamped; `atlas.py check --strict` exit 0.
- CI runs (all push-triggered, one run per commit): 38520450078 on 092293e (workflow change): suite (ubuntu-24.04) job 115708700930 success, suite (windows-2025) job 115708700634 success, both suite PASS 98 cases, Windows build.ps1 5 CVs. 38520781279 on 45c816c (Atlas stamps): ubuntu job 115709729248 success, windows job 115709728990 success, pip cache hit on both. A stray run 38520434543 (old workflow, branch first pushed at main's 8d248f2 by mistake) was cancelled.
- Local: `python tests/run.py` PASS, 98 cases, `builds/tests-20261014-090816-690899` (worktree).
- `pillow` was unpinned when this list was written; pinned to 12.3.0 after review round 1 (see Review).

## Review
- Round 1, code-reviewer: FINDINGS (`docs/work/ci-hardening/reviews/01-code-reviewer.md`). M1 fixed in 8dea477: main pushes get their own concurrency group (`github.ref == 'refs/heads/main' && github.sha || github.ref`), so GitHub cannot replace a pending main run; cancel-in-progress stays non-main only. m1 fixed: "once per push (its head commit); a newer push to a feature branch cancels the older run" in docs/tech-stack.md, docs/reference/verification.md, .atlas/src/site.json, .atlas/src/pages/system-map.json. N1 fixed: `pillow==12.3.0` in verify.yml (tech-stack Verification row says 12.3). N2 accepted. N3: merged origin/main in 4c46266, took main's generated Atlas files, rebuilt, re-stamped change-review and roster, then system-map after commit (75ad56e); `atlas.py check --strict` exit 0. Citation ranges into changed files checked (github-ci cites docs/git-workflow.md:90-103, the CI-observation bullet on merged main).
- Evidence after fixes: CI run 38521749564 on 75ad56e green: suite (ubuntu-24.04) job 115712804636, suite (windows-2025) job 115712804971; pillow-12.3.0 installed, PASS 98 on both, Windows build.ps1 5 CVs; pip cache restored by restore-key and saved under the new key (verify.yml changed). Local `python tests/run.py` PASS on the merged head (`builds/tests-20261014-092144-096170`). The M1 fix rests on GitHub's documented concurrency rule; not reproduced with two main pushes (no pushes to main from this branch).
<!-- SECTION:NOTES:END -->

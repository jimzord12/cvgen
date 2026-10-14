## Review round 1: code-reviewer, 2026-10-14

Snapshot: `ci/task-48-hardening` at d4b8dbf against merge-base 8d248f2. Lead lenses: supply chain and correctness; behaviour (what CI runs, cancels or skips).

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Coverage: push reaches both jobs; run 38520997042 green on both, Windows ran build.ps1; both checksum guards fail on mismatch; `contents: read` suffices; 98 cases on Linux and Windows, no SKIPPED, both artifacts uploaded; curl -f, sha256sum --check --strict under bash -e, pwsh throw and build.ps1 throw all fail the step; proportionate.

Material
- M1: .github/workflows/verify.yml:14-18 — concurrency can cancel a main run. GitHub replaces any pending run in the same group with a newer queued one regardless of cancel-in-progress; the lead's push pattern on main (merge, then "close TASK", then handoff) leaves a published main commit with only a cancelled run, and `gh run watch --exit-status` fails; docs/git-workflow.md relies on each published commit's run. Regression (no group before). Fix: `group: verify-${{ github.ref == 'refs/heads/main' && github.sha || github.ref }}`, keep cancel-in-progress as is.

Minor
- m1: "once per pushed commit" (docs/tech-stack.md:14, docs/reference/verification.md:20, .atlas/src/site.json:456, .atlas/src/pages/system-map.json:349) overstates: a multi-commit push runs once for its head; a newer feature-branch push cancels the older. Fix the wording.

Notes
- N1: pillow unpinned (verify.yml:79), pre-existing; the cache key does not change on new pillow releases, so raster checks may drift. Pin in a follow-up (12.3.0 installed today).
- N2: the cache key is the whole workflow file; acceptable.
- N3: merge-tree with origin/main conflicts in the generated Atlas files; rebuild and re-stamp at integration.

Checks rerun: the three action tags are lightweight tags at exactly the pinned SHAs (commits/<tag> agrees; each is releases/latest); Typst asset digests equal the recorded hashes; both guards fail on a wrong file (exit 1); run 38520997042 log: "typst.tar.xz: OK", "typst 0.15.1", pip cache hit, "PASS: 98" on both, "5 CVs created", artifacts uploaded, no SKIPPED/error/warning; `atlas.py check --strict` exit 0. Suite not rerun (CI-only change; GitHub ran it on both OSes).

Limitations: M1 rests on GitHub's documented rule, not reproduced; author's local cross-checks not repeated; a context-reviewer round is also required for the doc edits.

## Dispositions (lead)

- M1, m1: fix. N1: pin pillow now (cheap, same file). N3: handled at merge.

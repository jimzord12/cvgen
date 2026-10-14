## Review round 2 (code): code-reviewer, 2026-10-14

Snapshot: dd0b8fc (clean); branch delta `9051736..dd0b8fc` compared with `origin/main...dd0b8fc` (merge-base 302123d). Lenses: 1 F1 and the context fixes touching code/tests; 2 TASK-39 merge, tool checks, Envelope read-only, anchors.

Verdict: PASS. Recorded in substance (Alias only).

Coverage: `run_reality` wired after check and render --check; the hash is taken right before a step's commands on files matching its declared output globs; stamp keeps `date` when bytes are unchanged, so the check is deterministic; the happy path does not trip it; the new case fails without the fix at `text-draft.draft-sent` for the stated reason.

Minor
- F1 `docs/workflow/GAPS.md:59` still cites `pdf-workflow.md:211-214`; after the `--root` clause (+2 at 143) it should be `213-216` (as `07-after/stage.yaml:95` says); `anchors --fix` checks only YAML `sources`.

Notes
- N1 `reality.ts:379-380` comment says it catches "a wrong status"; only a status equal to the earlier one. README:205-206 accurate.
- N2 `bun run envelope <folder>` echoes the argv line including the folder name; the tool's own output names none; `bun src/cli.ts envelope` avoids it.
- N3 `tests/run.py:476` says "two disagreeing copies" (three); verification.md's `('no-op-stamp', ...)` label covers only the returncode assertion.

Anchors otherwise OK (line 143 inside no model span; Atlas site.json 123-165 -> 123-167 widened correctly; `anchors 9051736` and `anchors origin/main` 0 moved, 0 edited). Checks rerun: suite exit 0, PASS 147 (builds/tests-20261014-135644-516672), five workflow-model* cases pass; bun test 96; typecheck 0; check; render --check 8 match; `git diff --check` clean; atlas ok; `envelope` on Alias client-2026-09-03 read-only (Envelope 22 entries, `private/` 926 entries, identical hashes before and after; 17 complete, 1 partial, 23 none; 18 of 37).

## Dispositions (lead)

- PASS. F1, N1, N3 (comment): fixed by the lead. N2: the README tells people to use `bun src/cli.ts envelope` for a real Envelope (one line). N3 (label): accepted.

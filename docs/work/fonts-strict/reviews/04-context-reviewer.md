## Review round 4: context-reviewer, 2026-10-14

Snapshot: `git diff b2a0dde..7d2d51a` in `.worktrees/task-46`.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Round-2 findings: M1 fixed at this head (will go stale again once this report is committed; stamp system-map last); M2 fixed (client-journey.json differs from main only on lines 307 and 445; main's erase wording and source client-workflow.md:298-327 kept); M3, m4, m5 and the notes fixed. verification.md items 7 and 11, the fonts.typ row (skip names, CI assertion, fonts-dejavu-core, "first plain family … not bundled"), theme.md, architecture.md, tech-stack.md, both skills and the README match the code. No live doc has --font-path without the flag; LF; diff --check clean; no new terms; no client data.

Material
1. Atlas citations shifted by one line: .atlas/src/pages/client-journey.json:463, 464, 491, 514, 535 and .atlas/src/site.json:377. The M3 fix added a line at build-a-cv.md:133 and the new-cv note one at SKILL.md:94; inherited ranges were not moved, so each cuts off its last line (deliver step 202-204 now misses line 205, its own `outputs.py stamp … status=delivered`; export 191-206 and site.json 117-206 miss line 207; render new-cv 104-114 misses the WARNING lines; render 117-149 and approve 182-189 drop a line). `check --strict` passes because stamping re-hashes whatever range is cited. Fix: build-a-cv.md 117-150, 183-190, 192-207, 203-205; site.json 117-207; new-cv/SKILL.md 105-115; build, stamp, system-map last.

Minor
2. verification.md:63 "so the case runs there" — two cases; write "so both cases run there" and the full path `.github/workflows/verify.yml`.

Notes
- Long lines: build-a-cv.md:133 (92), verification.md:111 (99), architecture.md:160 (100); re-wrap if convenient.
- verification.md:130-138 "Reading a failure" could list the CI failure `AssertionError: ('fonts-system', 'CI has no font …')` and the `SKIPPED N:` line; optional.
- "the case runs there" on ubuntu-latest unverified; confirm on the first CI run after the push.

## Dispositions (lead)

- 1, 2 and the optional notes (re-wrap, "Reading a failure"): fix. CI run checked by the lead after merge.

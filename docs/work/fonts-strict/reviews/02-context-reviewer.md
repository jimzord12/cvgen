## Review round 2: context-reviewer, 2026-10-14

Snapshot: 5c61091..83201d7 in `.worktrees/task-46`.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Holds up: the flag is on every documented typst compile/watch/fonts command in live docs, skills, agents and the Atlas (only archive/, docs/workflow/inventory/, docs/work/** and the two Minor items lack it); verification.md items 7 and 11, the fonts.typ row, theme.md, the new-theme skill and architecture.md agree with render.py, run.py and build.ps1 incl. skip behaviour; the stale "the suite does not catch it" is gone; the guard is owned in verification.md and theme.md; no CRLF; no client data; the Atlas private-repo and .worktrees claims are true.

Material
1. .atlas/atlas.lock.json system-map is stale at head: `atlas.py check --strict` at 83201d7 returns `STALE system-map docs/work`, exit 1 (stamped before docs/work/fonts-strict/reviews/01-code-reviewer.md was committed). The task record's "check --strict clean" is no longer true. Fix: stamp system-map last, after every review report is committed.
2. .atlas/src/pages/client-journey.json:547-557, the retention step, re-stamped as verified, leaves out the history erase: its "you" line says delete the `Envelope`, the `Intake Form`…, then empty Drive's Trash; docs/guides/client-workflow.md:307-327 says deleting the folder is not enough, the `Envelope` must be erased from the private repo's history (preferences.md:74 too). The step cites 297-305, stopping before that paragraph. Fix: add the erase to `you` and the gate label, widen the source to 297-327, build and stamp.
3. docs/guides/build-a-cv.md:131-132: the Atlas render step (client-journey.json:445) lists "every font family bundled" but its cited guide lists only page count, no empty page, fonts embedded, text inside the page. Fix: add the clause to the guide, re-stamp client-journey.

Minor
4. scripts/text-draft.typ:27 "Compile with --font-path packages/cv-framework/fonts" lacks the flag; the one manual compile with no runner. Add it.
5. docs/tech-stack.md:10 Fonts row lacks `--ignore-system-fonts`; append it.

Notes
- .claude/skills/new-cv/SKILL.md:93: the public-example compile prints the warning but exits 0; add "a `warning: unknown font family` line is a failure".
- packages/cv-workflow/README.md:41 "fonts" in the checks.json row is vague now; optional.
- system-map sources the whole docs/work folder, so every review report makes it stale; pre-existing, narrow later.
- `atlas.py check` prints "snapshot as of 2026-10-06" (site.json date) while pages say verified 2026-10-14; outside this task.

## Dispositions (lead)

- 1, 2, 3, 4, 5 and the new-cv note: fix. The docs/work staleness is a known side effect, handled by stamping system-map after the reports land; the folder moves in TASK-52, where the source gets narrowed. Optional README wording: fix if cheap.

## Review round 1, lens B (context): context-reviewer, 2026-10-14

Snapshot: `6e93bad..e9cf613`. Lens B: sources and generated views (a parallel reviewer covers content).

Verdict: PASS. Recorded in substance.

Generated views current (PowerShell; Git Bash exits 1 silently): `bun run check` (7 stages, 104 steps, 100 artifacts, 16 gates, 11 loops; NOTE for 6 placeholder caps); `render --check` 8 match; `atlas --check` client-journey matches; `atlas check --strict` 5 ok; LF.

B1 anchors: about 260 model anchors into the rewritten files read (both guides, `pdf-workflow.md`, `new-client`, `new-cv`, `idea-run`, `docs/research/README.md`, `scripts/cv.py`, `intake-form.gs`, `text-draft.typ`, glossary, `GAPS.md` rows): every one still says what its entity claims. Every "section N" reference matches the new numbering (client-workflow 1-5, build-a-cv 1-5); named anchors in `GAPS.md` exist. Every backticked ID in guides, skills, `pdf-workflow.md`, glossary, `AGENTS.md`, research README and `scripts/cv.py` exists in the YAML, incl. every "Used by"/"Not a step" header. The eight removed hand-written Atlas facts now live in sources (LinkedIn `02-intake/README.md:36`; consent `client-workflow.md:103-106`; `Fact Mark` `04-text-draft/README.md:18`; render checks and `Certificate Warning` `build-a-cv.md:110-141` plus a GAPS bullet; no inherited approval `06-deliver/README.md:20`; `Design Review` before the pick `05-design/README.md:31`; refusals `build-a-cv.md:153-169`; Drive Trash `07-after/README.md:33`). B2: all 37 hand-written Atlas citations into the rewritten files read correctly.

Minor
1. `docs/workflow/05-design/stage.yaml:263` comment says "new-cv step 1 comes before the Idea Run of step 3"; the skill has no numbered steps now.
2. `.atlas/src/site.json:126`, `.atlas/src/pages/system-map.json:205`: `Idea Run` without backticks.

Notes
3. `bun run anchors 6e93bad` reports 9 false MOVED (`client-workflow.md:43,44,47,48,49`; `pdf-workflow.md:89-92`), already hand-moved; `--fix` against 6e93bad would break them (README caveat). Record that the next baseline is e9cf613.
4. `01-open/stage.yaml:42,:115` cite overlapping `client-workflow.md:85-94` and `:85-90`; drop `:85-90`.
5. `gate.template-exists` (`05-design/stage.yaml:266`) sources support the comment, not the check; acceptable.

## Dispositions (lead)

- PASS. Minors 1, 2 and notes 3, 4: fix. Note 5: accepted.

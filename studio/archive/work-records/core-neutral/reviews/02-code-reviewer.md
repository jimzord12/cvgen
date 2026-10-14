## Review round 2: code-reviewer, 2026-10-14

Snapshot: `refactor/task-45-core-neutral` at 4d66005 (delta 08cf1bd plus record and Atlas restamps 14fdb87, 3892911, 4d66005; full branch diff against origin/main 7acccd8 read for context; 5a04bd4, a Queued backlog task, not reviewed). Lead lenses: the legacy rewiring; test strength.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: `flagship()` runs `check-layout` before `validate-plan`; marine `lib.typ` takes `document-shell` from Flagship's `legacy.typ`, same signature, no import cycle, name set still 32; non-dictionary `hero` handled; both layouts carry `shell`; no `opening-margin` left in packages, tests, scripts or design concepts; both private marine compositions set neither retired key and render pixel-identical to origin/main; refusal messages name the `shell` key with an example; the check lives in Flagship, so the core still names no Flagship key.

Findings
- N1 Note: compositions migrated to `cc.document-shell` / `cc.page-background` (or calling legacy `page-background` directly) are not checked for retired keys (`docs/guides/build-a-cv.md:309-310`, `packages/cv-framework/core/page.typ:34,50`); the old value would be silently ignored. Low impact: no caller sets either key (tree and private/ grepped); a section-8 migrator hits the legacy refusal first. Optional fix: one line in section 8 naming the renames.
- N2 Note: the TASK-45 record's Result bullet still said flagship-v11 supplies `shell` "from one `opening-margin` binding".

Checks rerun: suite in the worktree exit 0, PASS 104; mutations on disposable `git archive` copies, each failing as intended: check-layout removed from `flagship()`, check removed from the legacy wrapper, marine lib.typ back to the Framework's `document-shell`, golden-blue `art-palette` removed, silver `art-palette: (:)`; boundary probes caught `navy`, `color.teal`, `color.hsl`, `color.linear-rgb`, `blue.lighten`, a hex after a URL string, `rgb(` after `"a//b"`, and correctly ignored a colour word inside a string and in a comment (aliasing accepted in round 1); private compositions 2 vs 2 pages, 0 differing at 150 dpi, comparator sanity-checked; all copies deleted, worktree and Main Folder clean.

Limitations: the author's 61-PDF comparison, outputs and Atlas checks not rerun; Atlas restamp commits not read line by line.

## Dispositions (lead)

- N1: fixed, `docs/guides/build-a-cv.md` section 8 now names the renames and says the contract shell ignores the old keys. N2: fixed in the record. A context-reviewer round follows for the docs.

# Context review round 1: Output Contract (8c2657f..56d5549, docs scope)

Principle I held before opening the diff: every PDF shown to someone has exactly one home by kind and a self-describing, hash-bound `Meta File`. Every writer stamps, and drift fails loudly. The root `exports/` is gone everywhere except as history. Out of scope: `builds/`, an `Envelope`'s `exports/` bundles, `intake/` documents.

Overall the change is coherent. The owner file is `docs/pdf-workflow.md` "Output Contract", and the other files point to it. The glossary is updated in place (`Release`, `Domain` ids, two new terms). The commands match `scripts/outputs.py` and `cv_workflow/outputs.py`. Line endings are LF. No client identity appears.

## Blocking

1. **`docs/conventions.md:139-143` ("Versioning of deliverables") is stale and was not touched.** It still says: "Rendered PDFs are named `<Domain>-<Role>-CV-<Variant>-vNN.pdf` … A new render with visible changes gets a new number and a new file. Old files are removed." That contradicts the approved decision (proposal §1: versioned names become the `title` field), `docs/git-workflow.md:120-126` and `home_of()`. `home_of()` only accepts `examples/…/<name>.pdf` next to `<name>.typ`, so a versioned file fails `outputs.py check` and the suite. AGENTS.md sends agents to conventions.md "before writing code, docs or a commit message", so this drives the wrong behaviour.
   **Fix:** say that `Release` PDFs are named after their entry point (`engineer.pdf`) and carry the version in the `Title` of their `$examples` line in `scripts/build.ps1`, which becomes the `Meta File`'s `title`. Keep the `vNN` naming only for the `Frozen Reference`.

## Material

2. **`design-concepts/README.md:34-37` contradicts the settled rule.** It says to "re-stamp its PDFs with the new status (`status=chosen`, …)", meaning every PDF of the concept. The settled rule, as `idea-run/SKILL.md:122-125` states it, is that only the picked tier is re-stamped `chosen`.
   **Fix:** "re-stamp its PDFs with the new status (`parked`, `rejected`, `unresolved`); for `chosen`, only the `Design Tier` he picked", or point to idea-run.

## Minor

3. **"At `Export`" versus "at send" for `delivered`.**
   - `new-client/SKILL.md:75` and `client-workflow.md:297-298` say to re-stamp `delivered` "At `Export`".
   - `build-a-cv.md:120-122` and `:203-204` put it after the owner sends the PDF, which is the settled decision.
   - `pdf-workflow.md:90` ("status render, then approved") also omits `delivered`.

   **Fix:** align the first two on "once the owner has sent it".
4. **`verify-cv/SKILL.md:51-57` suggests a fix that fails for a fresh concept.** The suggested fix is `stamp <pdf> status=<status>`. A concept PDF with no `Meta File` at all is refused unless it also gets `candidate`, `style` and `domain`.
   **Fix:** point to the full command in `design-concepts/README.md` for a missing file.
5. **`AGENTS.md:209-213` ("Anything else goes to `builds/`") reads too broadly.** Read literally, it also covers `cv.py export` bundles and client `intake/` documents.
   **Fix:** "Scratch renders go to `builds/`."
6. **`docs/glossary.md:420` credits a term the lead named to the owner.** It dates `Output Contract` "2026-09-30, owner", but the term is the lead's name for the owner's request (proposal, Decision section). Other rows credit the owner only when he coined the word.
   **Fix:** drop ", owner".

## Notes

- **Stale `.gitignore:25-26` comment.** It still says "Tracked deliverables are only the named PDFs directly under exports/". This is agent-facing config outside the requested scope.
- **ADR 0010 still reads as current.** ADR 0010:41 still says "`exports/` remains a fictional gallery". `pdf-workflow.md:204-205` records the retirement and the approved proposal is the decision entry, so this is acceptable. A one-line pointer from `pdf-workflow.md`'s ADR 0010 status line to the proposal would help readers who start from the ADR.
- **Proposal state on merge.** `docs/proposals/output-contract.md` should move `approved -> applied`, with evidence, when this merges (`docs/proposals/README.md:45-46`).
- **Merge order matters (not the known conflict itself).** On this branch the editor writes `<folder>/<tier>.pdf`. `home_of()` returns no `kind` for that, so the `magazine-editor.md:154-163` stamp command ("its place … gives `kind`, `density` and `tier`") is refused. If `feat/output-contract` reaches `main` before `docs/idea-run-2026-09-29-editor`, an idea run on `main` in between would fail at stamping. Merge the Density branch first, or do not run an idea run in the gap.
- **`design-reviewer.md` was not changed.** The proposal's "Docs to update" list names it, but it has no stale reference and needs no change. Mention this in the task record so the list is not read as incomplete.
- **Placement of the owner's principle.** It went into `preferences.md:54-57` under "structure". That is a reasonable home and is not duplicated elsewhere.
- **Stale root `exports/` references.** After a grep, none remain in the reviewed scope beyond the history-style mentions (`git-workflow.md:106`, `glossary.md:419`, `pdf-workflow.md:148,205`, `verification.md:109`), which are correct. `proposals/vessel-particulars.md:151` is a dated record and was correctly left alone.

Verdict: FINDINGS

## Dispositions (lead, 2026-09-30)

Ran as a general-purpose stand-in acting exactly as `context-reviewer.md`
(from branch `docs/codex-visual-tools`).

- 1: fixed. conventions.md "Versioning of deliverables" now names `Release`
  PDFs after their entry point with the version in the build script's
  `Title` (the Meta File's `title`); only a frozen reference keeps `vNN`.
- 2: fixed; points to `idea-run` step 8 for `chosen`.
- 3: fixed in new-client and client-workflow ("once the owner has sent
  it"); pdf-workflow's tree comment adds `delivered`.
- 4: fixed; a stale PDF re-stamps with `stamp <pdf>`, a PDF without a Meta
  File points to the full command.
- 5: fixed ("Scratch renders go to `builds/`").
- 6: fixed; ", owner" dropped.
- Notes: `.gitignore` comment updated. ADR 0010 left as history. The
  proposal moves to `applied` on merge. Merge order: the Density branch is
  merged into this work before any idea run (the lead merges this branch,
  then merges `main` into the idea-run branch and stamps its 18 designs in
  the same session; no idea run in between). `design-reviewer.md` needed
  no change (no root `exports/` reference).

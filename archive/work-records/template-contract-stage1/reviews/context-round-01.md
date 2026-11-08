## Context review, round 1: P-0019 Stage 1 agent context (`feat/template-contract` at 6b12088)

I checked the docs against `contracts.py`, `render.py`, `output.schema.json`, `template.json`, the contracts and fixtures, and `tests/coverage.py`. These hold up:
- The new manual's "What is checked" section matches `choose` and `coverage`.
- Verification case 18 matches `tests/coverage.py`.
- `domainContract` appears in both marine schemas.
- The Meta File gained exactly the four fields `pdf-workflow.md` names.
- The glossary pointers resolve, and `atlas.py check` reports every page `ok`.
- No touched file has CRLF line endings, and no real client is named.

The ADR status-line update and the appended P-0019 Decisions entry follow house practice.

### Blocking

**B1. Unresolved merge-conflict markers were committed in the merge (6b12088).**
- `docs/decisions/README.md:44-49` has `<<<<<<< HEAD … >>>>>>> main`. The file now holds two contradicting 0016 rows ("Partly built" and "Not built yet"), and the 0017 row sits inside the conflict.
- `backlog/tasks/task-68 - template-contract-stage-2-version-comparison.md:6-12` has markers in its frontmatter. The YAML no longer parses, so the backlog skill and CLI cannot read the task.
- Fix: keep HEAD's 0016 row and main's 0017 row. For TASK-68, keep main's two date lines.
- Note: main has since moved to 35e3bb6, which touches the TASK-68 notes again. Resolve that one carefully on the next merge.

### Material

**M1. The Workflow Model does not show the new record.**
- `docs/workflow/05-design/stage.yaml:155-162` (`design.entry-point`) lists only `outputs: [art.cv-typ]`. Yet its action (`:588`) now writes `template` and `variation` into `envelope.json`.
- The model's own convention for writing a field into `envelope.json` is a separate artifact: `after.keep-record` outputs `art.envelope-keep` (`07-after/stage.yaml:54`).
- The guide paragraph that says how to write it (`build-a-cv.md:80-83`) is cited by `lead.write-candidate-json` (`:55-102`), not by `design.entry-point` (`:85-106`).
- Fix: add an artifact such as `art.envelope-choice` as that step's output, cite `build-a-cv.md:80-83`, then regenerate the README and the Atlas.

**M2. An edit outside the feedback.** `docs/engine/skills-component.md:35-37` reflows and rewords the `heading` slot line. Nothing in P-0019 reaches that text. Fix: revert it, or move it to its own commit.

### Minor

**m1. Two rules an author needs are documented nowhere.**
- In `typst/cv.typ`, `variation:` must be a quoted name or `none`, otherwise the render refuses (`contracts.py:122-124`).
- An `envelope.json` without `template` only warns, and a missing `variation` means the default (`contracts.py:117-118`).
- Fix: add one sentence to `docs/engine/template-contract.md:43-50`.
- Also, the "Record the choice" paragraph (`build-a-cv.md:80-83`) sits in section 2, which `design.fill-data` uses. Section 1 (the entry point) is where it belongs.

**m2. Input numbering in `docs/architecture.md:47-50`.** The `variation` paragraph sits between "The six inputs" table and "A seventh, optional input is `copy`", so `variation` has no number. Fix: give it a table row, or call it the eighth input.

**m3. Fixture paths are incomplete.** `docs/glossary.md:52` and `docs/architecture.md:139` give `fixtures/coverage-v<N>.json` "and its markers". The real files also include `coverage-v1-contracts.json`, and the markers are separate `*.markers.json` files (`tests/coverage.py:47,67`). Fix: write `coverage-v<N>[-<kind>].json` and name the `.markers.json` files.

**m4. Custom composition missing from `docs/pdf-workflow.md:137-139`.** A custom composition's Meta File also gets `domain_contract` (`contracts.py:113`), but the text covers only "a client PDF from a `Template`". Fix: add that case.

**m5. `designBar` values are not explained.** The manual (`template-contract.md:31-35`) names `designBar` but not its values. `template.json` uses `"showcase"`, and only `scan-first` is a glossary term. Fix: write "`showcase` (the bar in `docs/vision.md`) or `scan-first`".

**m6. Envelope descriptions do not match the code.**
- `.atlas/src/pages/system-map.json:34`: the `envelope.json` blurb was restamped but still lists only `Alias`, `Domain`, `Rank`.
- `client-workflow.md:88-89` says every envelope records a `Template` choice. Only a `Template` render records one; a custom composition or a one-off has none.

**m7. Unwrapped long lines.** Added lines at `constitution.md:20`, `vision.md:113`, `domains-and-roles.md:3` and `build-a-cv.md:81,134` run past the wrapping of the text around them.

### Notes
- ADR 0016's Status says "built 2026-11-04", but the round-2 fixes landed on 2026-11-08.
- Two edits beyond the brief are correct: `travel-and-tourism` becomes `travel` (the glossary id), and the `check-flagship-fit` pointer drops gaps that are now closed.
- `constitution.md:23` "Today that is Flagship" could name `showcase`.

Verdict: FINDINGS

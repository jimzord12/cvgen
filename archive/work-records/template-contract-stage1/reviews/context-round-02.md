## Context review, round 2: P-0019 Stage 1 agent context (`feat/template-contract` at 88b0e8b)

**All round 1 findings are fixed.**
- **B1:** no conflict markers remain anywhere in scope. The ADR index has a single 0016 row ("Partly built") and the 0017 row. The TASK-68 frontmatter is clean.
- **M1:** `art.envelope-choice` is an output of `design.entry-point` (`05-design/stage.yaml:418`). It is shaped like `art.envelope-keep` and cites `build-a-cv.md:55-61`, `client-workflow.md:89-91` and `contracts.py:103-129`; all three land on the right text. The README and Atlas are regenerated.
- **M2:** `skills-component.md` no longer differs from main.
- **m1:** the author rules in `template-contract.md:51-55` match `contracts.py:104-129`:
  - `template` and `variation` must be quoted names.
  - A missing `template` only warns.
  - A missing `variation` means the default.
  - `variation:` must be a quoted name or `none`; anything else is refused.
  - "Record the choice" now sits in section 1 of `build-a-cv.md`.
- **m2:** `variation` is now called the eighth input (`architecture.md:55-57`).
- **m3:** the fixture paths match the files on disk and `tests/coverage.py:47,67`.
- **m4:** `pdf-workflow.md` now covers custom compositions.
- **m5:** `designBar` values are explained.
- **m6:** the Atlas `system-map.json` and `client-workflow.md:89-91` are fixed.
- **m7:** the lines it named are rewrapped.
- **Notes:** the ADR status line now gives the 2026-11-08 fixes, and the constitution names `showcase`.

**Checks I ran:**
- `bun run check`, `render --check`, `atlas --check` and `anchors HEAD` all pass.
- `atlas.py check` reports every page `ok`.
- No touched file has CRLF line endings, and no real client appears in the diff.

**Anchor sample.** For every source anchor the branch changed, I compared the first and last cited lines at main and at HEAD. All land on their intended text except the two near-misses under Notes. Both still include the text they are meant to cite.

### Blocking
None.

### Material
None.

### Minor

**m1. One long line came in with the m5 fix.**
- `docs/engine/template-contract.md:36` runs to 111 characters, while the lines around it wrap near 80.
- `docs/architecture.md:113` (85 characters) is a smaller case of the same thing.
- Fix: rewrap both.

### Notes
- **Two anchors are off by one; both still include their target text.**
  - `05-design/stage.yaml:271` (`gate.template-exists`) cites `build-a-cv.md:130-139`. The REFUSED sentence starts at 131.
  - `01-open/stage.yaml:34,106` and `client-journey.json:103` cite `client-workflow.md:94-95`. The sentence "`alias` is the client's" is on 93.
  - This is the double-shift you expected. Fix it as `93-94` and `131-139` if you touch those files again.
- **`pdf-workflow.md:137-139` is slightly broader than the code.** A custom composition gets `domain_contract` only when its `Domain` has a contract; `choose` returns None for travel today. `template-contract.md:56-57` already says this, so nobody will be misled.
- **The rule is in two places.** "Record the choice" (`build-a-cv.md:57-59`) repeats the manual's `variation:` sentence. It points to the manual, so this is acceptable for a how-to guide.
- **The new-cv skill's pointer could be shorter.** `.claude/skills/new-cv/SKILL.md:41` says "BC sections 1 and 2". Section 2 is still right for the wording replacement, so "section 1" alone would also do.
- **Expect conflicts on the next merge.** Main is now at a8b03d6 and touches these files again:
  - TASK-68: main records that the Stage 2 trigger is met through TASK-80, and this branch adds its own Notes block.
  - The `template-contract.md` proposal Decisions list.
  - `vision.md`.
  - `05-design/stage.yaml`, `07-after/stage.yaml` and `catalog.yaml` anchors.
  - The Atlas.

  Two things to check after merging: re-anchor against the merge, not `main`. And check that the ADR 0016 status "Essential (TASK-67)" still fits main's TASK-67 scope, where TASK-79 builds Essential on Hanami first.

Verdict: PASS

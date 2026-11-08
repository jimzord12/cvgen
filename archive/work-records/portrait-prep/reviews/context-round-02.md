**Context review, round 2: portrait preparation docs (worktree `C:\Github\cvgen\.worktrees\portrait-prep`, b50bce7..0c23428)**

**Verdict: PASS.** All seven findings from round 1 are fixed. The one new item is Minor, and there are two Notes. No Blocking or Material findings remain.

**Round 1 items, checked one by one**
1. **Fixed: the rule now reaches designers and reviewers.**
   - Criterion 6 (Craft) carries the rule in both copies: `.claude/agents/design-reviewer.md:112-114` and `.codex/agents/design-reviewer.toml:142-144`. The wording is identical and points to the owner's section.
   - The magazine-editor step prepares `portrait.png` in both copies (`.claude/agents/magazine-editor.md:183-189`, `.codex/agents/magazine-editor.toml:209-214`). The two copies agree, apart from line wrapping.
   - `docs/conventions.md:59-65` sits in "Typst code" and uses the same lead-sentence bullet style as its neighbours. Its claims are true:
     - The Flagship's hero uses `fit: "cover"` on a centred clip (`hero.typ:7-9`).
     - `--face-y` exists, with the range 0.40 to 0.50 (`portrait.py:35`, `scripts/portrait.py:36`).
     - The Hanami template on `feat/hanami-essential` also uses `fit: "cover"` with no offset (`essential.typ:140`, `hero.typ:97`), so it complies when merged.
2. **Fixed: the stale examples.** Every `image(...)` example in `docs/guides/build-a-cv.md:71-77,259` and `docs/guides/client-workflow.md:96` now uses `portrait.png`. The schema field note (`docs/engine/candidate-schema.md:46-50`) names the prepared file and points to the owner's section. No `portrait.jpg` or `portrait.<ext>` is left outside the dated concept folders.
3. **Fixed: the repository maps.** `AGENTS.md:37,39`, `docs/architecture.md:169,172` and the Atlas system map node `n-portrait` all list the tool. The architecture text matches `cv_workflow/models/` in tech-stack.
4. **Fixed:** `docs/tech-stack.md:15` now only points to the rule.
5. **Fixed:** the guide says "the shape the design renders".
6. **Fixed:** the `--face-y` and `--replace` re-prepare is documented. The explanation of exit 2 matches `scripts/portrait.py:55-59` (the `CHECK FAILED` branch).
7. **Fixed:** the step description now reads "centred, a little high" (`docs/workflow/05-design/README.md:349`). The Atlas blurb says "centred in a square, a little high", which describes the tool's output correctly.

The round 1 Note about the guide's "describes no step" line is handled: the look-then-re-prepare judgement now lives in `docs/workflow/05-design/README.md:29-35`, and the guide keeps the commands and exit codes.

The two design-reviewer copies differ in one pre-existing place: `.claude` line 119 has "Codex-generated" where `.codex` has "generated". That difference is outside this diff, and nothing in `docs/review.md` conflicts with the change.

Hygiene checks:
- All 15 touched docs, agents and Atlas source files have LF endings (0 CRLF).
- No client identity appears anywhere.
- No new glossary term is needed.
- The anchor shifts in `stage.yaml` match the inserted lines (the README bullet adds 7 lines, the concepts README adds 2, the guide adds 5).

**Minor**

1. `studio/design-concepts/README.md:21-24`. The reflow leaves two problems:
   - **"earlier ones" now points to the wrong date.** The nearest date is now 2026-11-08, so "earlier ones" reads as "folders before 2026-11-08 hold `concept.typ`". That is false: the 2026-09-29 and 2026-10-02 folders use the two-density layout. Before the change, "Earlier folders" was read against "Since 2026-09-29" at the top of the file.
   - **A short ragged line:** line 23 ends at "instead. Each font family".

   Smallest fix: "...keep the unprepared `portrait.jpg`; folders before 2026-09-29 hold one `concept.typ`, `concept.pdf` and `page-1.png` instead." Then rewrap the paragraph.

**Notes**

- `scripts/portrait.py:3` advertises `--keep-background`, and no document mentions it. Criterion 6 now says a portrait has no background. If the flag is not meant for client or concept use, say so in its help text or drop it. That is a question for the code-reviewer, not a documentation finding.
- The rule's short form ("no background, the face in the centre of the shape or a little higher") now appears in six places, each pointing to the owner's section:
  - both design-reviewers
  - both magazine-editors
  - `docs/conventions.md`
  - the 05-design README

  The `new-cv` skill also points to the section. That is within the "brief, with a pointer" allowance, and the wording is identical everywhere. A future change to the rule has to update all of them.

Verdict: PASS

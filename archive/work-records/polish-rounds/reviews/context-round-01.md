**Context review, round 1: docs/polish-rounds, diff 09aa035..6d30ed4**

Verdict: FINDINGS. There is one Material finding: Codex is told to wait for crop instructions that no checklist tells the lead to give. Everything else is Minor or a Note.

Before opening the diff I set the principle as follows. Finish is not taste: seamless section joins and premium artwork are blocking for every CV design, in any `Domain`, and the gates must catch them without the owner asking. After a pass, two more improvement rounds run. A before/after pair calibrates the bar. Non-CV work stays out, and it must not become perfectionism on taste. The change captures this principle, not just the Guilloche example.

**Your four points**
1. **Bar.** There is no conflict. `idea-run/SKILL.md:147-150` and `design-reviewer.md:164-171` separate finish from taste explicitly.
   - **Renumbering.** No live file cites the old step 6, 7 or 8. Old numbers survive only in dated records (for example `archive/.../2026-11-08-editor/run.md:44`), which are correctly left unedited. The Atlas ranges were updated.
   - **Process.** It is mostly clear; the gaps are in the Minor findings below.
2. **Round-5 failures.** In round 5 the design-reviewer already cropped the header. It saw the veil stripe (D24), the wireframe globe (D22) and the plane outline, and graded them Nit or Note. Codex called the plane "a familiar pictogram silhouette". The new criterion 6 names "veil", "stock pictogram" and "the page's own visual language", and makes them Blocking. All three would now fail. Both failures sit in the top 40% crop that Codex now always gets.
3. **Client name.** The diff, the commit message and both PNGs are clean: the record is the fictional Nikos Kontos, and both cited commits are on main. I could not compare the fictional details with the real client, because `private/` is out of bounds.
4. **Open points.**
   - **No polish rounds at deliver:** acceptable. Deliver has no design-review gate (`docs/workflow/06-deliver/README.md:76-77`).
   - **`docs/vision.md` left alone:** acceptable. `vision.md:51` already says "never clip-art", and criterion 6 owns the craft bar.
   - **Token cost:** see the Notes.

**Material**
- `.claude/agents/codex-visual-reviewer.md:28-29, 41-43`: Codex expects "the seams and artwork beyond page 1's header to crop" from the lead's brief. Nothing tells the lead to provide them: not `idea-run/SKILL.md:64-73`, not the brief list in `docs/workflow/05-design/README.md:57-60`, not `new-cv/SKILL.md:63-66`. So Codex only ever judges finish on the top 40% of page 1. A seam on page 2 or a sidebar artwork goes unjudged by one of the two gates.
  - Smallest fix: one clause in `idea-run` step 4 and in the 05-design brief sentence. For example: "name the further seams and artwork to crop (page and region)". Or have Codex crop every page's section transitions itself, as the design-reviewer does.

**Minor**
- `idea-run/SKILL.md:89-92`: "after two such repeats" does not say whether that is per Polish Round or in total. It also lets a design that already passed reach the owner as `unresolved`, which step 9 then excludes from gate coverage. Fix: "two repeats per Polish Round; then return to the last passing snapshot and list the change in `run.md`".
- `idea-run/SKILL.md:88`: "owner-requested revision (step 7)". Step 7 covers edits after a PASS, not revisions the owner asks for. Fix: drop the pointer, or say "an owner-requested change that goes back through the quality gate (step 7)".
- `new-cv/SKILL.md:67-68`: "until both pass, or `design.cap-reached`; then the two `Polish Round`s" reads as if polish also follows the cap. Fix: move "then the two Polish Rounds" before "or `design.cap-reached`".
- `idea-run/SKILL.md:80-81` with `new-cv`: client CVs built on the Flagship path also get Polish Rounds. Most "Even better" proposals would push towards changing the frozen template or composing the page by hand. Fix: on the Flagship path, carry out only what the entry point and the data can change, and list the rest.
- `docs/workflow/05-design/stage.yaml:411`: the `art.run-message` format still leaves out the Polish Round line that `idea-run/SKILL.md:160-161` and the Atlas now add.
- `studio/archive/reference-pairs/README.md:27`: the pair is at 150 dpi, while both reviewers judge 300 dpi crops against it. Say that the pair shows the bar at 150 dpi, or render future pairs at 300 dpi.
- `AGENTS.md:43`: "reach each `Reference Pair`'s after unasked" is cryptic for a cold reader. Suggestion: "a `Reference Pair`'s after is the finish bar".

**Notes**
- **Token cost.** Each full run now adds two to six re-reviews of 18 designs by both judges. `codex-visual-reviewer.md:53-55` attaches every pair to every call, which grows without limit as pairs accumulate. Consider attaching only the latest few pairs.
- `design-reviewer.md:69-72`: the Zoom bullet is not limited to CV pages, so it reads oddly for a logo.
- `codex-visual-reviewer.md:41`: a fixed "top 40%" assumes a header across the top. It suits top headers but not sidebar layouts.
- Placement is sound. Criterion 6 owns the rule, the `.codex` mirrors are identical, and the glossary has both new terms. Six other files restate it briefly, each pointing back to criterion 6. That is acceptable, but it is the limit.
- All touched files use LF line endings.

Files: `C:\Github\cvgen\.worktrees\polish-rounds\.claude\agents\codex-visual-reviewer.md`, `C:\Github\cvgen\.worktrees\polish-rounds\.claude\skills\idea-run\SKILL.md`, `C:\Github\cvgen\.worktrees\polish-rounds\.claude\skills\new-cv\SKILL.md`, `C:\Github\cvgen\.worktrees\polish-rounds\docs\workflow\05-design\README.md`, `C:\Github\cvgen\.worktrees\polish-rounds\docs\workflow\05-design\stage.yaml`, `C:\Github\cvgen\.worktrees\polish-rounds\studio\archive\reference-pairs\README.md`, `C:\Github\cvgen\.worktrees\polish-rounds\AGENTS.md`

Verdict: FINDINGS

**Next:** the writer fixes the Material finding (and the Minor ones it chooses), then sends round 2.

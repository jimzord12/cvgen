## Context review, round 1: docs/polish-at-deliver (57fed39..b0f8ebf)

All paths are under `C:\Github\cvgen\.worktrees\polish-at-deliver\`. The verdict is FINDINGS: three Material findings, two Minor, two Notes.

### Material

**M1. Broken pointer.** `docs/workflow/GAPS.md:61` cites `docs/workflow/06-deliver/stage.yaml:309-315` for the `cmd.page-png` command.
- **What is wrong:** this diff made `lead.fix-inputs`'s `does` 5 lines longer. `cmd.page-png` now sits at lines 314-320, and 309-315 lands on the new `does` text.
- **Why it matters:** the next reader who follows the citation lands on the wrong action.
- **Fix:** change it to `:314-320`.

**M2. The line between a design change and a words-or-facts change is drawn on movement only.** `docs/workflow/06-deliver/README.md:89-93`
- **What is wrong:** the test for a words-only change is that nothing moved. Two kinds of change pass that test and still change the design:
  - A fact that changes what page 1 shouts, for example a new `Rank` or specialty in the header. Criterion 2 and rank-specific artwork depend on it, but the text sends it straight to `deliver.render`.
  - A local break that moves no section: a new collision, widow or orphan, or a line that now runs into the artwork. These are all criterion 6, and a 96 dpi `deliver.page-png` look will often miss them.
- **Why it matters:** the text lists "a word" and "a certificate" as safe. An agent will feel no doubt in these cases, so "when in doubt, it is one" never fires.
- **Fix:**
  - Add to the design list: "words that change what page 1 says at a glance (name, `Rank`, specialty)".
  - Make the check read: "nothing moved, and nothing new collides, breaks a line badly or touches the artwork".
  - Say what happens to a Revision where something did move: it is not reported to him and goes back to the design review.

**M3. The re-review does not protect the owner's own change.** `docs/workflow/06-deliver/README.md:84-88`
- **What is wrong:** the judges are fresh, and the two `Polish Round`s carry out their "Even better" proposals. Nothing tells either judge what the owner asked for.
- **Why it matters:** a judge may propose undoing his change, and a Polish Round would then carry that out. Criterion 6 itself fails a hard edge "unless that hard edge is clearly the design's idea". The owner decides design (`docs/preferences.md`).
- **Fix:** add one clause: "the brief names his change, which no judge's proposal or `Polish Round` reverses; a finding against it goes to him".

### Minor

**m1. The YAML copy of the rule uses different words from the README.** `docs/workflow/06-deliver/stage.yaml:307-312` (copied into the generated table at `06-deliver/README.md:259` and into the Atlas).
- **What is wrong:** the YAML says "new words that change … where a section sits". The README says "new words or facts that change … where the header or a section sits".
- **Fix:** make the two match, or shorten the `does` to the trigger plus "where the line is: README, Branches".

**m2. Line wrap.** `docs/workflow/06-deliver/README.md:86` is 88 characters long. The surrounding prose wraps at about 75. Rewrap it.

### Notes

- **`docs/vision.md:64-67` fits the section.** It quotes the owner's words exactly, his own "is to for you" slip included, which is right. It points to criterion 6 rather than restating it, so it does not duplicate the criterion.
  - The same point is now said in three places in nearly the same words: here, `docs/preferences.md:20-23` and `docs/workflow/05-design/README.md:24-27`. The vision bullet is now the natural owner of the principle. In a later pass the other two could shrink to a pointer to "Finished, unasked".
  - Small paraphrase: he said "high-quality SVGs/images"; the bullet says "premium". Harmless.
- **`docs/workflow/GAPS.md:38-41` agrees with the deliver README.** But the model still routes the output of every `deliver.fix` to `design.preview`. The words-only exemption lives only in `lead.fix-inputs`'s text. One clause saying so would let the entry describe the model accurately, which is what this file is for.

### Checked and fine

- **Ownership:** the rule is owned in one place, `06-deliver/README.md`, "Branches". The 05-design README, `docs/workflow/README.md` and the `new-cv` skill each say it briefly and point there.
- **Source anchors:** all the new and shifted ones are accurate: `new-cv` `77-104`, `93-97`, `98-101`, `102-103`, `104`; 05-design README `107-111`; deliver README `74-93`.
- **Fresh round cap:** "its round cap counted afresh" sits without conflict beside the 05-design "When to stop".
- **Records:** no ADR, history entry or review report was edited, and dating the decisions inline "(owner, 2026-11-08)" follows the earlier merge.
- **Line endings:** LF in every touched file.
- **Privacy:** no client is named, and no `Alias` or other identifying detail appears anywhere in the diff.

Verdict: FINDINGS

**Next:** the writer fixes M1-M3 (m1 and m2 are optional) and sends round 2.

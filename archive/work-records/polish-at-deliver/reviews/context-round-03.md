## Context review, round 3: docs/polish-at-deliver (57fed39..fea02a9)

**Verdict: PASS.** All three round-2 items are fixed. I found nothing Blocking or Material. Two Minor wording and wrapping slips and three Notes remain, and none of them blocks the merge.

All paths below are under `C:\Github\cvgen\.worktrees\polish-at-deliver\`.

### What the feedback means
When the owner changes the design at deliver, the change goes back through the client design review and both `Polish Round`s. The round cap counts afresh. His change is named in the brief and never reversed. A change to the words or facts alone skips that loop: it gets a 300 dpi check, and a failure sends it to design review. This should not catch a failed render, an example-wording fix, or non-client work.

### Round-2 findings
- **M1, fixed.** His change now reaches every place the brief is built:
  - `.claude/agents/codex-visual-reviewer.md:28-30` ("What you receive").
  - `.claude/agents/codex-visual-reviewer.md:81-83` (the Codex prompt in step 5). The quoted line tells Codex not to reverse or dilute the change and to name any finding against it.
  - `.claude/agents/design-reviewer.md:44-46`, mirrored word for word in `.codex/agents/design-reviewer.toml`.
  - `docs/workflow/05-design/README.md:59-61` (the brief's list).
  - No YAML `does` lists what a brief holds, so no copy is left behind there.
- **m1, fixed.** `.claude/skills/new-cv/SKILL.md:96-97` now names the 300 dpi check and where a failure goes, with the pointer to the deliver README.
- **Crops Note, fixed.** `docs/workflow/06-deliver/README.md:32` now says crops, and lines 31-34 still state the same fact.

### Minor
**m1. A line runs past the margin.** At `docs/workflow/05-design/README.md:61` the inserted clause leaves the line at 78 characters, while the lines around it stop at about 74.
- **Fix:** rewrap lines 59-62.

**m2. An awkward clause.** `docs/workflow/05-design/README.md:118-119` now reads "anything from `private/`: of the `Client`, briefs carry the `Alias`…". The added scope is right, since his change does not come from the `Client`. But the leading "of the `Client`," makes the reader stop and work it out.
- **Fix:** "briefs carry, of the `Client`, only the `Alias`, the `Domain`, specialty and `Rank`."

### Notes
- **The skill's cleanup step.** `.claude/skills/new-cv/SKILL.md:90` still says "Clear the page PNGs by path", but the 300 dpi crops of the words-only check now land in `builds/` too. The deliver README, which owns the rule, now says "crops". Adding "and crops" here would keep a checklist-only agent in step. Optional.
- **A stale Atlas anchor from before this branch.** `.atlas/src/site.json:113` cites `.claude/agents/design-reviewer.md:73-155`. At 57fed39 the rubric was already at lines 82-150, and this branch moves it 2 lines further to 84-151. The writer fixed every other anchor into that file. Correcting this one to `84-151` would be cheap, but it is optional.
- **A summary that does not list his change.** The `codex-visual-reviewer` frontmatter `description` (`:3`) summarises what to give it and does not name his change. It is a summary, not the intake list, so this is acceptable.

### Checked and fine
- **Placement:** each rule sits in the file that owns it.
  - The deliver README owns the line between a design change and a words-only one.
  - `05-design/README.md:108-112` restates it in brief and points back to the deliver README.
  - The agent profiles restate only the intake clause, with a pointer.
  - `lead.fix-inputs` names the trigger and points to the README.
  - `GAPS.md` and `docs/workflow/README.md` record that the gap is settled for the owner's changes and still open for a failed render or example wording.
- **Owner's and lead's decisions:**
  - `vision.md:64-67` quotes him; `preferences.md` points to it.
  - The fresh round cap, his change named and never reversed, and the 300 dpi check with its failure route are all present.
- **Anchors:** every shifted anchor into these files was moved:
  - `05-design/README.md`: `15-78`, `55-78`, `65-67`, `68-69`, `70-78`, `84-88`, `108-112`.
  - `design-reviewer.md`: `37-50`, `39-50`, `52-183`, `54-58`, `69-70`.
  - `GAPS.md` anchors: `stage.yaml:494-499` and `:311-317`.
  - The three EDITED anchors you named (`new-cv` `77-104` and `93-97`, deliver README `31-34`) still state their facts.
  - Old ranges survive only in ignored `builds/` test copies.
- **Terms:** `Polish Round`, `Revision`, `Rank`, `Client` and `Alias` are spelt as in the glossary. The step IDs match the YAML.
- **Records:** no ADR, history entry or old report was edited. The round-1 and round-2 reports were only added.
- **Line endings:** no CR bytes in any of the 21 changed files.
- **Privacy:** no client and no `Alias` appear anywhere in the diff.

Verdict: PASS

**Next:** you can merge `docs/polish-at-deliver`; fixing m1 and m2 first is optional.

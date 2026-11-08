**Context review, round 1: portrait preparation docs (worktree `C:\Github\cvgen\.worktrees\portrait-prep`, 8a684e7..b50bce7)**

**Verdict: FINDINGS.** I found no Blocking issues. There are four Material findings and three Minor ones.

The owner's rule has two parts. First, a portrait never keeps its background. Second, the face sits at the centre of whatever shape holds it, or a little higher when that looks better. It applies to any portrait in any `Domain`, in a concept and in a client CV. It is not a rule for logos or art, and it does not mean every CV needs a portrait.

The change covers the first part well, but only for a real client at `design.fill-data`. The second part only shows up as the tool's fixed 45% crop.

What checks out:
- Line endings are LF in all eight touched files.
- The other stage files and the Atlas only changed generated line anchors.
- Check 21 matches `tests/portrait.py` and the script's flags.
- No client identity appears anywhere in the diff.

**Material**

1. **Nothing tells a designer or reviewer the rule.** The places to fix:
   - `.claude/agents/design-reviewer.md:109-112` (criterion 6, Craft)
   - `.claude/agents/magazine-editor.md:183-185`
   - `docs/conventions.md` "Typst code"

   The magazine-editor still copies the fictional portrait "as `portrait.jpg` (converted to JPEG)", background and all. That is exactly what the owner objected to, and he picks from concepts. Nothing says how a template should place the image either. The Flagship is safe by luck: `hero.typ:7-9` clips a circle with `fit: "cover"`, centred. A custom composition such as Hanami, or a shape that isn't round, can move the face off-centre with its own offsets, and no reviewer is asked to look. `docs/vision.md` is too high-level for this.

   Smallest fix:
   - Add one clause to criterion 6: "a portrait has no background and its face sits centred in its shape, or slightly high (`client-workflow.md`, section 1, 'The portrait')".
   - In magazine-editor, prepare the concept portrait with `scripts/portrait.py prepare` (use `--fill` if it must stay a JPEG, or keep it a PNG).
   - In conventions: a portrait component clips the prepared square, centred, and never shifts it.

2. **Stale examples now contradict the new text.**
   - `docs/guides/client-workflow.md:91` and `docs/guides/build-a-cv.md:259` still show `image("../images/portrait/portrait.jpg")`. That is the raw photo's name, which `build-a-cv.md:75-77` now says never to point at. An agent copying the example uses the unprepared photo.
   - `docs/engine/candidate-schema.md:46-48` owns the meaning of `identity.portrait`. It and `build-a-cv.md:71,74` still say `portrait.<ext>, jpg or png`.

   Fix: change the examples to `portrait.png`, and in the schema field note name the prepared `portrait.png`, with the pointer.

3. **The repository maps miss the new modules.**
   - `AGENTS.md:39` lists the scripts but not `portrait.py`.
   - The module tree at `docs/architecture.md:160-170` has no `cv_workflow/portrait.py` or `scripts/portrait.py`.
   - The Atlas system map (`.atlas/src/pages/system-map.json`) lists `cv.py` and `outputs.py` as tools but not this one.

   Agents read these "before changing a module". Fix: add one entry to each.

4. **`docs/tech-stack.md:15` restates the rule in different words.** It says "the face centred in any shape". That drops "or a tiny bit higher", and "any shape" claims more than the tool can promise. Fix: "The owner's portrait rule (2026-11-08, `guides/client-workflow.md`, section 1)" and nothing more.

**Minor**

5. `docs/guides/client-workflow.md:85-86`: "look at it in the rendered circle" assumes the Flagship's circle, but the owner said "the shape". Fix: "in the shape the design renders".
6. `client-workflow.md:84-86`: the owner left room for judgement ("if that way it looks better"), but the tool fixes the face at 45% and has no flag to change it. The text says to look at the result but not what to do if it looks wrong. Add one clause naming the fix, such as moving it in the design's placement, or say there is no override.
7. The step descriptions in `docs/workflow/05-design/stage.yaml:340-342` (and the generated README:140 and Atlas summary) say "the face centred in a square", but the tool puts it slightly high on purpose. Fix: "the face centred, a little high".

**Note**

- `client-workflow.md:10` says "This file describes no step". The new paragraph's "prepare it once" and "before the design round" are step instructions. The command and the reference detail can stay. The look-before-the-round instruction belongs with `design.fill-data`'s judgement in `docs/workflow/05-design/README.md`.
- The restatement in `.claude/skills/new-cv/SKILL.md:27-31` is short and points back to the owner, which is fine.

Verdict: FINDINGS

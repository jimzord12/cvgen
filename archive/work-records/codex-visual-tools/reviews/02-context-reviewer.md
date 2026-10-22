## Context review round 1, TASK-4 (codex-visual-tools), snapshot 38da34d..872ef3f

Before reading the diff, this is what I expected the proposal to require. The Codex reviewer runs alongside the design-reviewer, on concept runs and client designs only, and both must pass. Its client reports stay private in the `Envelope`. Codex is isolated by flags, not by prompt wording. Image prompts never carry client data. Image provenance widens, with the record kept in one place. There is a fallback when Codex is unavailable. Not covered: brand assets, Flagship changes, portraits.

The core work is sound. The privacy flags (`--ephemeral`, `--ignore-user-config`, `project_doc_max_bytes=0`, read-only) are now always on rather than left to memory, image prompts are kept free of client data, and the rubric is read from the design-reviewer profile, not copied. `codex --version` reports 0.161.0, which matches what `docs/tech-stack.md` says. All 28 files are LF. AGENTS.md is 789 words. I found no real client identity anywhere in the diff.

### Material

**M1. The Workflow Model, and the guides it cites, still describe one reviewer and SVG-only art.**
- `docs/workflow/05-design/stage.yaml:69`: step name is still "A fresh design-reviewer judges every page".
- `:394`: only `NN-design-reviewer.md`.
- `:458`: format `art/*.svg`.
- `:494`: path `reviews/design-NN.md` only, format "design-reviewer report".
- `:642`: `lead.fix-design` stores only `design-NN.md`.
- `:650`: PNGs "the design-reviewer rendered".
- `catalog.yaml` has no `codex-visual-reviewer` actor, so the generated actors table and the Atlas client journey show one reviewer.
- Hand-written restatements that are now stale: `docs/workflow/README.md:18` and `:142`, `docs/guides/client-workflow.md:55` (`art/` "SVGs") and `:58` (`reviews/` holds `design-NN.md` only).

Why it matters: an agent following the model or the `Envelope` layout skips or misfiles the Codex report.
Smallest fix: update those paths, formats and `does:` lines, and add the actor. If the one-actor-per-step schema prevents showing two reviewers on one step, record that in `docs/workflow/GAPS.md`.

**M2. The Codex counterpart `.codex/agents/magazine-editor.toml` is only half synced.** The description and the artwork line changed. These did not:
- `:44-45`: the shell rule still has no pillow, which tech-stack's "Placing an image" step requires.
- `:172-176`: the layout has no `art/<name>.png` row.
- `:237`: the brief has no image record.
- `:247`: "When a review comes back" does not mention the Codex report.

Smallest fix: mirror the four Claude-profile edits.

**M3. Where Codex joins is stated three different ways.**
- `docs/review.md:30-33` keeps brand assets and Flagship changes with the design-reviewer alone.
- But `.claude/agents/codex-visual-reviewer.md:52-53` handles "a Flagship change", and `:65` handles non-CV assets ("Other assets").
- `idea-run/SKILL.md:63` pairs the reviewers for every "design concept" run, including the non-CV Idea Runs that `:26-28` describes.
- `docs/tech-stack.md:18` says Codex judges "every design round".

Smallest fix: say once, in `review.md`, whether a brand-asset Idea Run is paired. Drop the Flagship-change clause from the profile, and narrow the tech-stack row.

### Minor

- **m1.** `archive/work-records/codex-visual-tools/reviews/01-dispositions.md:14`: the file has no trailing newline. Also, the N2 disposition leaves out the ChatGPT data-control (training) question. That gap matters under the privacy lens: full client CVs, portraits included, go out through the owner's plan. Either state the setting or raise it to the owner.
- **m2.** `docs/review.md:146-148` says reviewers pin Opus at high effort, "as do the design-reviewer…". The wrapper runs on Sonnet, and that exception is not written there. A later model audit would flag it or "fix" it. One clause naming the exception is enough.
- **m3.** `docs/proposals/codex-visual-tools.md:156-159`: the `applied` evidence points at the task worktree's `builds/`, which is ignored and disappears when the worktree is removed. Store the small fictional evidence files under `archive/work-records/codex-visual-tools/`, or state the results inline.
- **m4.** Line-wrap drift: `design-reviewer.md:114` and the matching line in its TOML, `idea-run/SKILL.md:67`, `review.md:33`, `development.md:20`, `magazine-editor.md:179` and `:188`.

### Notes

- **N1.** In a client round, both reviewers render PNGs and make sheets in the same input folder at the same time, and neither profile names its files. A `codex/` subfolder or a file-name prefix would avoid collisions.
- **N2.** No glossary term is needed. Agent names are not glossary rows, and `design-reviewer` is not one either.
- **N3.** The Privacy line was rewritten inside the approved body. The 2026-10-14 note announced that, so I accept it. The decision entry labelling the lead's defaults answers F5.
- **N4.** The task's "Done when" still includes first use on the tour-leader Idea Run, but the acceptance criteria dropped it. Settle that explicitly.
- **N5.** `CLAUDE.md:7-8` still describes Codex's role narrowly. The pointer to `development.md` covers it, so no change is required.
- **N6.** The process slip in the main folder does not show in the diff, and it was restored.

Verdict: FINDINGS

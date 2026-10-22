# Dispositions of review round 1 (TASK-4, 2026-10-22)

The report `01.md` reviewed revision 1 of P-0014 on 2026-09-29. Each
finding was applied when the proposal was built (TASK-4).

| Finding | Disposition |
|---|---|
| F1 Material: pages persist in `~/.codex/sessions` | Fixed. Both commands pass `--ephemeral`; the Privacy line now says the pages carry the whole CV. Generated images still land in `~/.codex/generated_images/`, so an image prompt never carries client data (`docs/tech-stack.md`, "Codex CLI"). |
| F2 Material: isolation depends on a prompt and remembered flags | Fixed. `--ignore-user-config`, `-s read-only` and `-c project_doc_max_bytes=0` on both commands, with the prompt instruction as a second layer. Image generation also runs read-only (Codex then runs no shell at all), and the caller copies the image out, so no `-C` scope is needed. |
| F3 Minor: image location, compression, editor boundaries, batch sheets | Fixed. Images go to `<style>/art/` or the `Envelope`'s `typst/art/`, resized with pillow to print size; the editor's shell rule names the Codex command and pillow; the `codex-visual-reviewer` makes its own batch sheets unless the lead holds sheets of the snapshot. |
| F4 Minor: docs list incomplete | Fixed: `docs/review.md` says brand assets and Flagship changes keep the `design-reviewer` alone; client reports are `reviews/design-NN-codex.md` in the `Envelope`. The constitution is unchanged (owner-only): generated images never enter `packages/` or an `Artwork Pack` without the owner, so `docs/engine/artwork-pack.md` needs no change. |
| F5 Minor: owner decision and lead defaults mixed | Fixed: the proposal's Decisions list the lead defaults separately; the consent source is corrected. |
| N1 Note: no fallback | Applied: Codex `UNAVAILABLE` runs the round on the `design-reviewer` alone, recorded. |
| N2 Note: reviewer and closing phrase | Applied: later rounds go to the `context-reviewer`; the closing phrase is left in Codex's verdicts, as the agent says. |
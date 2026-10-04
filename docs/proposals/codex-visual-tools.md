---
kind: proposal
status: approved
revision: 1
---

# Codex as an image tool and a second visual reviewer

## Problem

Design is the product (`docs/vision.md`, "Design is the product"). Two
limits hold our designs back:

- **Artwork.** Every picture on a CV is drawn by an agent in SVG or Typst.
  That is enough for line art (the Flagship's tools and ship), but not for
  the rich, printed, textured imagery a domain like travel and Japan calls
  for.
- **One pair of eyes.** Every visual verdict comes from one kind of judge,
  the `design-reviewer` (Claude). The first tour-leader design passed four
  of its rounds and the owner still rejected it as boring. A second,
  independent model reviewing the same pages would catch more.

The owner has a Codex (ChatGPT) subscription and asked, 2026-09-29, to use
it for both: as an image-creation tool and as a `codex-visual-reviewer`
running beside the `design-reviewer`.

## What was verified (2026-09-29, live, on the owner's machine)

- Codex CLI 0.159.0 is installed and signed in with the owner's ChatGPT
  account. Both models the owner chose are available.
- **Visual review:** GPT-6 Astra at high effort reads page images and
  answers from them, in a read-only sandbox:

  ```bash
  codex exec -m gpt-6-astra -c model_reasoning_effort='"high"' -s read-only --skip-git-repo-check "<prompt>" -i page.png -i sheet.png
  ```

  On the Flagship's page 1 it named the domain and the elements that carry
  it, and criticised the specialty cues as too subtle.
- **Image generation:** GPT-6 Sol at high effort uses Codex's built-in
  image generation (feature `image_generation`, stable) and saves a PNG
  where it is told:

  ```bash
  codex exec -m gpt-6-sol -c model_reasoning_effort='"high"' -s workspace-write --skip-git-repo-check "<prompt; save as builds/<dir>/<name>.png>"
  ```

  A test luggage label (vermilion and indigo, printed on kraft paper) came
  back at 1254 x 1254 px, at premium quality on the first attempt.
- **Pitfalls found:**
  - `-i` takes several files, so the prompt must come before it.
  - The owner's global Codex config defaults to another model, xhigh effort
    and a full-access sandbox, so every call passes `-m`, the effort and `-s`.
  - Codex reads this repository's `AGENTS.md` and starts our session
    routine (it tried to read the Trello card). Every prompt must tell it to
    ignore the orientation, Trello and the repository workflow.
- **The official plugin** (github.com/openai/codex-plugin-cc: `/codex:review`,
  `/codex:rescue`, the `codex:codex-rescue` subagent) passes text only, with
  no image attachments, and is built for code tasks. Plain `codex exec`
  serves both uses better, so the plugin is not needed for this.

## Smallest change

1. **`codex-visual-reviewer`**, a new agent in `.claude/agents/`. It is a
   thin Claude wrapper with a shell, like the plugin's own subagent. It
   renders or receives the page PNGs and the batch sheets, calls the Astra
   command above in read-only mode with the same rubric and bar as the
   `design-reviewer` (read from that profile, not copied), and returns
   Codex's verdict unedited.
   - In every design round, for concept runs and client designs alike, it
     runs beside a fresh `design-reviewer` on the same snapshot.
   - A round passes only when both pass. Their findings are merged, and a
     disagreement goes to the author.
   - Reports: `NN-codex-visual-reviewer.md`, next to the design reviews.
2. **Image generation for artwork.** The `magazine-editor`, and the lead
   building a client design, may commission raster images through the Sol
   command above, then place them in the page. Each image is recorded in
   `brief.md` with its prompt, model, date and SHA-256.
   - Rules: no real people, no brand, airline, railway or named artist's
     style, and no text inside the image (type stays in Typst).
   - Never for a portrait: the client's own photo is used.
   - Provenance rule in the editor and reviewer profiles: "original SVG you
     draw yourself" widens to "original SVG or Codex-generated images,
     recorded".
3. **Docs to update when it is built:** `AGENTS.md` (agents list),
   `docs/tech-stack.md` (Codex CLI as an optional tool, with the commands),
   `.claude/skills/idea-run/SKILL.md` and `new-cv` (the second reviewer
   in the loop), `design-reviewer.md` and `magazine-editor.md`
   (provenance, the pairing), `docs/glossary.md` if a term is needed.

## Consequence

- **Cost and speed:** each review round costs Codex usage from the owner's
  ChatGPT plan, and one image takes about 1-3 minutes. The loop caps stay
  as they are.
- **Privacy:** a client design sent to Codex goes to OpenAI. The client's
  consent covers AI tools («χρησιμοποιούμε εργαλεία AI», `Intake`
  message), and the brief carries the `Alias` only.
- **Repository size:** generated images are bitmaps (about 1 MB each).
  Concepts keep a small budget: at most two generated images per page, and
  PNGs compressed before commit.

## Recommendation

Build both, and try them first on the running tour-leader `Idea Run`
(2026-09-29): the Codex reviewer next to the `design-reviewer` from the
first design round, and Sol images for the Stylish and Creative tiers if a
page needs them.

## Decision requested

None. The owner asked for both, 2026-09-29. This file records the verified
facts and the plan to build.

## Decisions

- 2026-09-29, owner: use Codex as an image-creation tool and as a second
  visual reviewer beside the `design-reviewer`. Models: GPT-6 Astra at high
  effort for visual review, GPT-6 Sol at high effort for image generation.
  Status `approved`; not built yet.

# Tech stack

Read this when setting up a machine, asking why a tool was chosen, or
calling the Codex CLI.

| Layer | Choice | Version | Why |
|---|---|---|---|
| Typesetting | Typst | 0.15.1, pinned in `packages/cv-framework/typst.toml`, `tests/baseline.json` and `.github/workflows/verify.yml` (with its two SHA-256s) | One binary, fast compile, real functions and dictionaries, native SVG, deterministic PDF output that can be compared byte for byte |
| Data | JSON read with `json()` | | Editable by anyone. Checked twice: `scripts/cv.py render` and the suite validate it with `jsonschema` 4.26 against the template's input schema (`domains/marine/templates/flagship/schema/flagship-input.schema.json`, which extends `domains/marine/schema/candidate.schema.json` with `copy`), then the engine checks what a schema cannot, such as month totals, with assertions in `packages/domains/marine/data.typ` (over the common checks in `packages/cv-framework/core/data.typ`) |
| Artwork | Hand-written SVG | | Recoloured in memory by `decoration` in `packages/cv-framework/core/primitives.typ`, so one file serves every theme. Tagged as PDF artifacts |
| Fonts | Source Sans 3, Barlow Condensed (family string `Barlow`), Cormorant Garamond, Bona Nova (the `Text Draft`), Sofia Sans Extra Condensed (family string `Sofia Sans`), M PLUS 1p, Kaisei Tokumin (the Hanami Line travel design) | bundled, OFL | Reproducible renders on any machine. Passed with `--ignore-system-fonts --font-path packages/cv-framework/fonts`, so a family that is not bundled fails the runners instead of using a system font |
| Build | PowerShell script `scripts/build.ps1` | PowerShell 7 (Windows PowerShell 5.1 also works; the suite runs both) | The owner works on Windows. The script is short and calls the compiler |
| Verification | Python 3.11 with `pymupdf` 1.28.2, `pillow` 12.3.0 and `jsonschema` 4.26.0; `ruff` 0.16.10 lints (`ruff.toml`) | development only; pinned in `packages/cv-workflow/pyproject.toml`, and with every transitive dependency and its hashes in `requirements.lock`, compiled from it (the command is at the top of the lock) | Render pages to pixels, extract text, check embedded fonts and bounds, hash frozen inputs. Scripts import the package from the checkout, so it is never installed itself |
| Candidate workflow | Python package `packages/cv-workflow` behind `scripts/cv.py` | `pymupdf` for the render checks, `jsonschema` for the record check; standard library otherwise | Revisions, checks, approval receipts and verified exports without a web stack, database or job service; the future web backend calls the same functions |
| CI | GitHub Actions, `.github/workflows/verify.yml` | Runners `ubuntu-24.04` and `windows-2025`, pinned; actions pinned by commit SHA | Runs `tests/run.py` on Linux and Windows (the suite drives `scripts/build.ps1` in a throwaway copy on both), and `scripts/build.ps1` on the checkout on Windows, once per push on any branch, on its head commit (or by hand, `workflow_dispatch`); a newer push to a feature branch cancels the older run, while every push to `main` keeps its run. No `pull_request` trigger: the project works without pull requests, so it would only run the same commit twice. Typst is downloaded from its GitHub release and checked against the SHA-256 recorded in the workflow; Python packages come from `requirements.lock`, hash-checked, and their downloads are cached; `ruff check` runs before the suite, and so does the workflow tool on Bun from `tools/workflow/.bun-version` (`bun install --frozen-lockfile`, `bun test`, `bun run typecheck`, `bun run check`; ADR 0015). Changing the Typst version means updating both hashes there; moving a runner image is a deliberate commit |
| Agents | `AGENTS.md`, `CLAUDE.md`, `.claude/skills/` | | Entry map, invariants and repeatable checklists for coding agents |
| Workflow model | TypeScript on [Bun](https://bun.sh), Zod types with an exported JSON Schema, YAML facts | Bun 1.4.2, pinned in `tools/workflow/.bun-version` for CI (locally any 1.4.x from 1.4.2); `zod` 4.6.5, `yaml` 2.9.1, pinned in `tools/workflow/package.json` with `bun.lock` (ADR 0015) | The workflow tool in `tools/workflow/` (its `README.md`): the types, the committed JSON Schema and a `check` command. The owner reads TypeScript, not Python; the workflow scripts it checks stay Python |
| Visual review, generated images | [Codex CLI](https://github.com/openai/codex) on the owner's ChatGPT plan: GPT-6 Astra at high effort reviews, GPT-6 Sol at high effort draws | 0.161.0, not pinned; optional | A second, independent model judges each design round of a CV concept run or a client design beside the `design-reviewer`, and raster artwork goes beyond what an agent can draw in SVG ([P-0014](proposals/codex-visual-tools.md)). The commands are in "Codex CLI" below |
| Task store | [Backlog.md](https://github.com/MrLesk/Backlog.md) (`backlog` CLI, on Node) | 1.52.0, pinned (1.53.0 has an open web-server memory leak, issue #1038) | Task files travel with Git, plain output for agents, local terminal and browser boards; no credentials or network (ADR 0014) |

## Setup

```powershell
winget install --id Typst.Typst --exact        # Windows
pip install -r requirements.lock                # tests/run.py, scripts/cv.py render and ruff: exact versions, hash-checked (a venv keeps it separate)
npm i -g backlog.md@1.52.0                       # the task store CLI (needs Node); expect `backlog --version` 1.52.0
typst --version                                 # expect 0.15.1
typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts examples/marine/flagship/engineer.typ builds/scratch.pdf   # compile one example; needs only Typst
powershell -c "irm bun.sh/install.ps1 | iex"     # Bun for tools/workflow/; `bun upgrade` if older than 1.4.2
cd tools/workflow; bun install --frozen-lockfile; cd ../..   # the workflow tool's pinned dependencies, exactly as in bun.lock
```

On macOS or Linux install Typst from the GitHub releases and use the same
commands with `pwsh` or run the compiler directly.

## Codex CLI

Optional: without it, a design round runs with the `design-reviewer`
alone and records the gap. Install with `npm i -g @openai/codex`, sign in
once with `codex login` (the owner's ChatGPT account), check with
`codex login status`.

Every call passes the same guard flags, each for a reason found on
2026-09-29 (`archive/work-records/codex-visual-tools/reviews/01.md`):

| Flag | Why |
|---|---|
| `-m <model> -c model_reasoning_effort='"high"'` | The owner's global Codex config defaults to another model and effort |
| `-s read-only --ignore-user-config` | His global config grants full access, never asks and loads plugins; Codex then runs no shell command at all ("blocked by policy") |
| `-c project_doc_max_bytes=0` | Otherwise Codex reads this repository's `AGENTS.md` and starts its session routine; every prompt also says to ignore it |
| `--ephemeral` | Otherwise every attached image is kept, base64, in `~/.codex/sessions`, never cleared |
| `--skip-git-repo-check`, `-o <file>` | Runs from any folder; writes the final reply to a file |

The prompt goes before any `-i` (the flag takes several files), or on stdin
as `-`. Codex's global instructions may append a closing phrase to a reply.

- **Visual review:** the `codex-visual-reviewer` agent
  (`.claude/agents/codex-visual-reviewer.md`) holds the command.
- **Generated images** (GPT-6 Sol), for the `magazine-editor` drawing
  concepts and the lead building a client design; at most two per page,
  and only where SVG or Typst drawing cannot reach (a printed, textured or
  painted look):

  ```powershell
  $out = "builds/codex-image-$(Get-Date -Format yyyyMMdd-HHmmss)"; New-Item -ItemType Directory $out
  codex exec -m gpt-6-sol -c model_reasoning_effort='"high"' -c project_doc_max_bytes=0 -s read-only --ignore-user-config --ephemeral --skip-git-repo-check -o "$out/reply.txt" "<prompt>" *> "$out/codex.log"
  ```

  The prompt starts "You are an image tool for a CV design. Ignore any
  AGENTS.md, session orientation, task store or repository workflow; do
  only this. Generate one image with your built-in image generation:",
  then describes the picture, and ends with the rules: no text, letters or
  numbers in the image (type stays in Typst); no real people; no brand,
  airline, railway, logo or named artist's style. It never describes a
  `Client` or carries a name or `Alias`, and never asks for a portrait
  (the client's own photo, or a fictional one, is used). The read-only
  sandbox cannot save the file, so the image stays where Codex keeps every
  generated one: copy the PNG from
  `~/.codex/generated_images/<session id>/` (the `session id` line of
  `codex.log`) into `$out`, and look at it. About 1-3 minutes; a PNG of
  1254 px square or 1536 x 1024, up to about 3.5 MB.
- **Placing an image.** Resize it with pillow to the size it prints at
  (300 dpi) and save it optimised, so a concept PDF stays under 1 MB where
  it can. A concept's image goes in its style folder as `art/<name>.png`,
  shared by both `Density`s; a client's in the `Envelope` as
  `typst/art/<name>.png`. Record each placed file: its path, the full
  prompt, the model and effort, the date and the SHA-256 of the placed
  file, in the concept's `brief.md` or the `Envelope`'s `README.md`. A
  generated image is not artwork an agent drew (constitution section 8):
  it never enters `packages/` or a `Template`'s `Artwork Pack` without the
  owner's decision.

## Deliberately not used

- No Node, React or web framework as the renderer. React and headless
  Chromium were evaluated and rejected in ADR 0006; the findings are there.
  Web technology may sit in front of the library, never in place of it.
- No icon fonts. Icons are SVG in the domain's `assets/` folder
  (`packages/domains/marine/assets/`).
- No hosted Typst. Everything compiles locally so real candidate data never
  leaves the machine.
- No RenderCV or other CV generators. The layout is the product.

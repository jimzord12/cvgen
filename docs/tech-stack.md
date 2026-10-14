# Tech stack

Read this when setting up a machine or asking why a tool was chosen.

| Layer | Choice | Version | Why |
|---|---|---|---|
| Typesetting | Typst | 0.15.1, pinned in `packages/cv-framework/typst.toml`, `tests/baseline.json` and `.github/workflows/verify.yml` (with its two SHA-256s) | One binary, fast compile, real functions and dictionaries, native SVG, deterministic PDF output that can be compared byte for byte |
| Data | JSON read with `json()` | | Editable by anyone. Checked twice: `scripts/cv.py render` and the suite validate it with `jsonschema` 4.26 against the template's input schema (`domains/marine/templates/flagship/schema/flagship-input.schema.json`, which extends `domains/marine/schema/candidate.schema.json` with `copy`), then the engine checks what a schema cannot, such as month totals, with assertions in `packages/domains/marine/data.typ` (over the common checks in `packages/cv-framework/core/data.typ`) |
| Artwork | Hand-written SVG | | Recoloured in memory by `decoration` in `packages/cv-framework/core/primitives.typ`, so one file serves every theme. Tagged as PDF artifacts |
| Fonts | Source Sans 3, Barlow Condensed (family string `Barlow`), Cormorant Garamond, Bona Nova (the `Text Draft`), Sofia Sans Extra Condensed (family string `Sofia Sans`), M PLUS 1p, Kaisei Tokumin (the Hanami Line travel design) | bundled, OFL | Reproducible renders on any machine. Passed with `--ignore-system-fonts --font-path packages/cv-framework/fonts`, so a family that is not bundled fails the runners instead of using a system font |
| Build | PowerShell script `scripts/build.ps1` | PowerShell 7 (Windows PowerShell 5.1 also works; the suite runs both) | The owner works on Windows. The script is short and calls the compiler |
| Verification | Python 3.11 with `pymupdf` 1.28, `pillow` 12.3 and `jsonschema` 4.26 | development only | Render pages to pixels, extract text, check embedded fonts and bounds, hash frozen inputs |
| Candidate workflow | Python package `packages/cv-workflow` behind `scripts/cv.py` | `pymupdf` for the render checks, `jsonschema` for the record check; standard library otherwise | Revisions, checks, approval receipts and verified exports without a web stack, database or job service; the future web backend calls the same functions |
| CI | GitHub Actions, `.github/workflows/verify.yml` | Runners `ubuntu-24.04` and `windows-2025`, pinned; actions pinned by commit SHA | Runs `tests/run.py` on Linux and Windows (the suite drives `scripts/build.ps1` in a throwaway copy on both), and `scripts/build.ps1` on the checkout on Windows, once per push on any branch, on its head commit (or by hand, `workflow_dispatch`); a newer push to a feature branch cancels the older run, while every push to `main` keeps its run. No `pull_request` trigger: the project works without pull requests, so it would only run the same commit twice. Typst is downloaded from its GitHub release and checked against the SHA-256 recorded in the workflow; the pip downloads are cached. Changing the Typst version means updating both hashes there; moving a runner image is a deliberate commit |
| Agents | `AGENTS.md`, `CLAUDE.md`, `.claude/skills/` | | Entry map, invariants and repeatable checklists for coding agents |
| Workflow model | TypeScript on [Bun](https://bun.sh), Zod types with an exported JSON Schema, YAML facts | Bun 1.4.2, pinned in `tools/workflow/.bun-version` for CI (locally any 1.4.x from 1.4.2); `zod` 4.6.5, `yaml` 2.9.1, pinned in `tools/workflow/package.json` with `bun.lock` (ADR 0015) | The workflow tool in `tools/workflow/` (its `README.md`): the types, the committed JSON Schema and a `check` command. The owner reads TypeScript, not Python; the workflow scripts it checks stay Python |
| Task store | [Backlog.md](https://github.com/MrLesk/Backlog.md) (`backlog` CLI, on Node) | 1.52.0, pinned (1.53.0 has an open web-server memory leak, issue #1038) | Task files travel with Git, plain output for agents, local terminal and browser boards; no credentials or network (ADR 0014) |

## Setup

```powershell
winget install --id Typst.Typst --exact        # Windows
pip install pymupdf pillow jsonschema           # tests/run.py and scripts/cv.py render
npm i -g backlog.md@1.52.0                       # the task store CLI (needs Node); expect `backlog --version` 1.52.0
typst --version                                 # expect 0.15.1
powershell -c "irm bun.sh/install.ps1 | iex"     # Bun for tools/workflow/; `bun upgrade` if older than 1.4.2
cd tools/workflow; bun install --frozen-lockfile; cd ../..   # the workflow tool's pinned dependencies, exactly as in bun.lock
```

On macOS or Linux install Typst from the GitHub releases and use the same
commands with `pwsh` or run the compiler directly.

## Deliberately not used

- No Node, React or web framework as the renderer. React and headless
  Chromium were evaluated and rejected in ADR 0006; the findings are there.
  Web technology may sit in front of the library, never in place of it.
- No icon fonts. Icons are SVG in the domain's `assets/` folder
  (`packages/domains/marine/assets/`).
- No hosted Typst. Everything compiles locally so real candidate data never
  leaves the machine.
- No RenderCV or other CV generators. The layout is the product.

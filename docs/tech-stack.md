# Tech stack

Read this when setting up a machine or asking why a tool was chosen.

| Layer | Choice | Version | Why |
|---|---|---|---|
| Typesetting | Typst | 0.15.1, pinned in `packages/cv-engine/typst.toml` and `tests/baseline.json` | One binary, fast compile, real functions and dictionaries, native SVG, deterministic PDF output that can be compared byte for byte |
| Data | JSON read with `json()` | | Editable by anyone, validated by `packages/cv-engine/domains/marine/schema/candidate.schema.json` and by assertions in `packages/cv-engine/core/data.typ` |
| Artwork | Hand-written SVG | | Recoloured in memory by `decoration` in `packages/cv-engine/core/primitives.typ`, so one file serves every theme. Tagged as PDF artifacts |
| Fonts | Source Sans 3, Barlow Condensed (family string `Barlow`), Cormorant Garamond | bundled, OFL | Reproducible renders on any machine. Passed with `--font-path packages/cv-engine/fonts` |
| Build | PowerShell script `scripts/build.ps1` | PowerShell 7 | The owner works on Windows. The script is thirty lines and calls the compiler |
| Verification | Python 3.11 with `pymupdf` 1.28 and `pillow` | development only | Render pages to pixels, extract text, check embedded fonts and bounds, hash frozen inputs |
| Candidate workflow | Python package `packages/cv-workflow` behind `scripts/cv.py` | `pymupdf` for the render checks; standard library otherwise | Revisions, checks, approval receipts and verified exports without a web stack, database or job service; the future web backend calls the same functions |
| CI | GitHub Actions, `.github/workflows/verify.yml` | | Runs `tests/run.py` on every push and pull request |
| Agents | `AGENTS.md`, `CLAUDE.md`, `.claude/skills/` | | Entry map, invariants and repeatable checklists for coding agents |

## Setup

```powershell
winget install --id Typst.Typst --exact        # Windows
pip install pymupdf pillow                      # tests/run.py and scripts/cv.py render
typst --version                                 # expect 0.15.1
```

On macOS or Linux install Typst from the GitHub releases and use the same
commands with `pwsh` or run the compiler directly.

## Deliberately not used

- No Node, React or web framework as the renderer. React and headless
  Chromium were evaluated and rejected in ADR 0006; the findings are there.
  Web technology may sit in front of the library, never in place of it.
- No icon fonts. Icons are SVG in the template's `assets/` folder.
- No hosted Typst. Everything compiles locally so real candidate data never
  leaves the machine.
- No RenderCV or other CV generators. The layout is the product.

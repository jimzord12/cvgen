---
name: new-theme
description: Create a new visual theme or artwork pack for the marine-cv library. Use when asked for a new look, colour scheme, typography variant, or a new role's illustrations. Keeps tokens in the template's themes/, pictures in its artwork/ and assets/, and proves the engineer reference is untouched.
---

# New theme or artwork pack

Read `docs/reference/theme.md` or `docs/reference/artwork-pack.md` first.

## Theme

1. Copy `packages/cv-engine/domains/marine/templates/flagship/themes/silver-bridge.typ` as the pattern: spread `golden-blue`'s
   theme, set `name`, replace `colors`, `fonts` and any `sizes`.
2. Every colour key must exist; `validate-theme` fails otherwise. Fonts must
   be one of the bundled family strings `Source Sans 3`, `Barlow` or
   `Cormorant Garamond` (the Barlow Condensed file registers as `Barlow`;
   check with `typst fonts --font-path packages/cv-engine/fonts`). An unknown name prints
   `warning: unknown font family` and substitutes; the suite does not catch it.
3. If the theme changes secondary SVG hues, add the hex values to
   `art-colors`.
4. Add an example under `examples/marine/flagship/` that differs from an existing one by the
   theme import only. Add it to `scripts/build.ps1` and `tests/run.py`.

## Artwork pack

1. Copy `packages/cv-engine/domains/marine/templates/flagship/artwork/captain.typ`. Draw SVGs under `packages/cv-engine/domains/marine/assets/<role>/` using
   `{{ink}}`, `{{accent}}`, `{{metal}}` for colours. Vector only.
2. Fill the required slots `background-first` and `background-continuation`;
   others may be `none`.
3. Tune `width`, `x`, `y`, `opacity` per slot by compiling and looking.
4. Add an example and register it as above.

## Prove nothing else moved

```powershell
python tests/run.py
```

The engineer example must still match v11. A new theme or pack never
changes that comparison; if it does, the change leaked into the core or the components.

## Report

Name the new files, the example entry, the evidence folder, and attach a
96 dpi PNG of page one and page two.

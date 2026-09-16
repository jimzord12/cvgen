# Artwork pack

Read this when creating or editing a file under `packages/cv-engine/templates/flagship/artwork/`. A pack maps
named slots to SVG files with optional placement tweaks. It is the only place
a role's identity lives visually.

```typst
#let artwork = (
  portrait-backdrop: (source: "/packages/cv-engine/templates/flagship/assets/spanners-refined.svg", width: 94mm, y: -18mm),
  portrait-frame: (source: "/packages/cv-engine/templates/flagship/assets/porthole.svg", width: 56mm, y: -2mm),
  hero-left: (source: "/packages/cv-engine/templates/flagship/assets/hero-coupling-left.svg", width: 33mm, y: 48mm),
  hero-right: (source: "/packages/cv-engine/templates/flagship/assets/hero-coupling-right.svg", width: 33mm, y: 48mm),
  background-first: (source: "/packages/cv-engine/templates/flagship/assets/workshop-background-1.svg"),
  background-continuation: (source: "/packages/cv-engine/templates/flagship/assets/workshop-background-2.svg"),
  profile-illustration: (source: "/packages/cv-engine/templates/flagship/assets/vessel-profile.svg"),
)
```

## Slots

| Slot | Where | Optional |
|---|---|---|
| `portrait-backdrop` | Behind the portrait, centred in the hero | yes, use `none` |
| `portrait-frame` | Over the portrait edge | yes |
| `hero-left`, `hero-right` | Flanking the identity plate | yes |
| `background-first` | Full-page background on page one, under the hero band | no |
| `background-continuation` | Full-page background on later pages | no |
| `profile-illustration` | Right of the profile paragraph on page one | yes |

## Descriptor keys

| Key | Meaning |
|---|---|
| `source` | Path from the project root, `/packages/cv-engine/templates/flagship/assets/...` |
| `width` | Rendered width. Backgrounds fill the page and `profile-illustration` uses `layout.profile.image-width`; both ignore it |
| `x`, `y` | Offset from the slot's anchor, hero slots only |
| `opacity` | 0 to 1, wraps the SVG in a group with that opacity |

Any descriptor also works as the `bullet` of the skills section.

## Drawing new SVGs

- Use `{{ink}}`, `{{accent}}` and `{{metal}}` for colours so every theme
  recolours the file. See `packages/cv-engine/templates/flagship/assets/captain/*.svg`.
- Keep the file small and vector only. Backgrounds are drawn at low opacity
  so faint detail reads as texture, not clutter.
- Everything placed through a pack is tagged as a PDF artifact, so it does
  not enter the reading order. Do not put information in artwork.
- Add every new SVG to `tests/baseline.json`. The manifest freezes all
  assets, fonts, example JSON and design studies, not only what the engineer
  example uses, so a pack cannot drift once it has been reviewed.

## Checks

The captain pack is compiled by `python tests/run.py` on both pages. A new
pack should get its own example under `examples/flagship/` and be added to the build
script and to the runner's compile list.

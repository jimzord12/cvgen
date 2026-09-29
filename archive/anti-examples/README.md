# Anti-examples

Designs the owner decided do **not** match his style, kept only so nobody
proposes them again (owner, 2026-09-30: "things that do not match my
style"). They are the opposite of `archive/design-studies/`, which holds
directions worth learning from.

## Rules

- Frozen. Never edit, re-render into `design-concepts/`, or build on one.
- Read this folder before proposing or reviewing a design: a new design that
  leans on one of these ideas needs a reason the owner would accept, or it
  fails review.
- Not part of the `Output Contract`: these PDFs have no `Meta File` and do not
  show in the `Design Review` app.
- Each entry keeps its original `brief.md`, `concept.typ`, PDFs and PNGs.
  Its fonts live in `fonts/` here, used by nothing else. To look again:
  `typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path archive/anti-examples/fonts archive/anti-examples/<folder>/concept.typ builds/<new-folder>/concept.pdf`

## Entries

| Anti-example | What it was | The device to avoid | Owner's verdict |
|---|---|---|---|
| [Stoichedon](2026-09-27-stoichedon/) | A `Text Draft` direction, 2026-09-27: every letter in its own square cell, as Attic inscriptions; facts rubricated in bold red ochre ([PDF](2026-09-27-stoichedon/concept.pdf)) | A letter-by-letter grid as the organising idea; an archaeological, epigraphic voice | Not picked 2026-09-28 (First Fitting chosen); archived as an anti-example 2026-09-30. His reason in his own words: not recorded yet |
| [Two Inks](2026-09-27-two-inks/) | A `Text Draft` direction, 2026-09-27: black is ours, orange is yours; facts overprint misregistered orange slabs, a giant orange draft number and OK ([PDF](2026-09-27-two-inks/concept.pdf)) | Small-press poster loudness: misregistered overprint, giant numerals, a hot orange as the second ink | Not picked 2026-09-28 (First Fitting chosen); archived as an anti-example 2026-09-30. His reason in his own words: not recorded yet |

When the owner says why one misses, write it into its row in his words; that
sentence is worth more to the next designer than the files.

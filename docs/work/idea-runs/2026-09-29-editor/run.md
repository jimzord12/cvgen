# Idea run 2026-09-29, magazine-editor: Travel & Tourism, Japan, tour escort

Branch `docs/idea-run-2026-09-29-editor`, no worktree (no other work running).
First run under the new brief (commits 53adb1f, 76a899b, cae0828: "Design is
the product"; three `Style`s, each in three `Design Tier`s; two `Density`s
added mid-run, see "Density added").

## Why

The owner rejected the first one-off design for client-2026-09-01 ("Line
Diagram": a thin rail line with numbered section stations, route diagrams, a
restrained palette) as "super boring! No character, no uniqueness, no Japan in
it", although it had passed four craft-only design reviews. He asked for a
stricter closed visual loop, design-review cap 10 rounds (owner, 2026-09-29),
and a more expensive editor job: three very distinct styles, each in Safe,
Stylish and Creative tiers.

## Steer given to the author and every design-reviewer

- `Domain`: Travel & Tourism. Specialty: Japan. Role: tour leader / escort
  (Αρχηγός-Συνοδός Εκδρομών) for Greek outbound agencies' group trips to
  Japan. Readers: Greek agency owners; their clients are mostly 40-65.
- The page must shout travel, Japan and escort before a word is read. The
  domain's and the destination's imagery is required, crafted.
- Greek is the primary language: fonts must cover Greek.
- Fictional data only, invented for the run (no client data in any brief).
- The floor never to pass: the rejected "Line Diagram", described above.

## Rounds

| Gate | Round | Verdict | Report |
|---|---|---|---|
| research-reviewer | - | not run yet | - |
| design-reviewer | - | not run yet | - |

The owner asked to wrap up and stop once the author returned (2026-09-29),
so neither gate has run. The run is **not integrated**: it stays on its
branch until both gates pass (cap 10 rounds, owner). The owner also asked
for a Codex `codex-visual-reviewer` beside the `design-reviewer`
(`docs/proposals/codex-visual-tools.md`, approved, not built): the next
session may build it first and use it from design round 1.

Author: `magazine-editor`, asked to wrap up early; it reports the Safe tiers
got less polish than the Stylish ones and Concourse Safe is the weakest.

## Styles (author's summary)

1. `design-concepts/2026-09-29-woodblock-road/`: "woodblock travel print".
   Fonts Alegreya, Kaisei Tokumin (kanji and kana).
2. `design-concepts/2026-09-29-stamp-rally/`: "tickets, tags, stamps".
   Fonts Sofia Sans Extra Condensed, M PLUS 1p, DejaVu Sans Mono.
3. `design-concepts/2026-09-29-concourse/`: "Japanese station wayfinding".
   Fonts Fira Sans, M PLUS 1p.

Each folder: `brief.md`, `sample.json`, `portrait.jpg` shared, the first
nine designs under `condensed/<tier>/condensed-<tier>.*`, the Spacious nine
under `spacious/<tier>/spacious-<tier>.*` (see "Density added" below).
Fictional data (`sample.json` per style: Μάρκος Ηλιάδης, Lazuli Travel).
Contact sheet: `builds/editor-2026-09-29/contact-sheet.png` (not committed).

## Density added (owner, 2026-09-29)

After seeing the nine pages, the owner asked for a second layout type beside
the three styles and three tiers: the dense one-page designs drawn so far
(Condensed) and a Spacious one that runs 1 to 3 pages depending on how much
the person has to say, 2 pages for this run's steer. Because the files
multiply, he asked to group them by `condensed/` and `spacious/`, then by
tier. New glossary term `Density`; a run is now 3 `Style`s × 2 `Density`s ×
3 `Design Tier`s = 18 designs. The nine existing designs were moved to
`condensed/<tier>/` (renamed `condensed-<tier>.*`, reading `../../sample.json`
and `../../portrait.jpg`), and the `magazine-editor` was commissioned to draw
the Spacious nine (2 pages each) under `spacious/<tier>/`. The agent files,
the `idea-run` and `new-cv` skills, the glossary, `design-concepts/README.md`
and `AGENTS.md` were updated to the new shape.

## Open for the next session

- Research gate, then design gate (with the Codex reviewer if built), on
  all 18 designs once the Spacious nine are drawn.
- Repository size: the new Japanese font families are large
  (`kaisei-tokumin` 4.4 MB, `m-plus-1p` 3.4 MB); consider subsetting
  before integration.
- Glossary terms the author proposed: `Station Board`, `Stamp Card`
  (add as pending with the concept paths if the styles pass).
- Unverified by the author: the katakana name, the Greek copy.

## What reached the owner

2026-09-29: the contact sheet of all nine pages, unreviewed, shown on his
screen at the end of the session. No decision yet; styles stay `proposed`.

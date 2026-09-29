# Idea run 2026-09-29, magazine-editor: Travel & Tourism, Japan, tour escort

Branch `docs/idea-run-2026-09-29-editor`, no worktree (no other work running).
First run under the new brief (commits 53adb1f, 76a899b, cae0828: "Design is
the product"; three `Style`s, each in three `Design Tier`s).

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

Fictional data (`sample.json` per style: Μάρκος Ηλιάδης, Lazuli Travel).
Contact sheet: `builds/editor-2026-09-29/contact-sheet.png` (not committed).

## Open for the next session

- Research gate, then design gate (with the Codex reviewer if built).
- Repository size: the new Japanese font families are large
  (`kaisei-tokumin` 4.4 MB, `m-plus-1p` 3.4 MB); consider subsetting
  before integration.
- Glossary terms the author proposed: `Station Board`, `Stamp Card`
  (add as pending with the concept paths if the styles pass).
- Unverified by the author: the katakana name, the Greek copy.

## What reached the owner

2026-09-29: the contact sheet of all nine pages, unreviewed, shown on his
screen at the end of the session. No decision yet; styles stay `proposed`.

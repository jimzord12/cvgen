# Timetable

**Idea:** the one-page CV set as one table of a printed travel timetable: dates are the departure times, every bullet is a row with its lead phrase as the station column, the availability is the table's "valid from" line, and a key of symbols names what he books. Three words: **printed timetable table**.

Run: idea run 2026-11-08 (editor), five one-page styles for a practical travel CV under the `scan-first` bar. `Domain` travel; specialty group and private travel; `Rank` Tour Leader / Travel Consultant. One design, `Condensed` density, `stylish` `Design Tier`, drawn twice: in its own palette and as a monochrome version.

## What the owner should notice first

The order. A black head strip ("TABLE 1 · CURRICULUM VITAE", five service pictograms, "VALID FROM APRIL 2027ᵃ"), a very tall condensed name, and then everything below is ruled table: yellow section bands, big condensed date numerals, lead phrases right-aligned in a station column, alternating tinted rows, hairlines. The portrait is cut out on a block of signal yellow, like a cell of the table, closed at its foot by the table's heavy rule so the white shirt never melts into the page (round 2, design D8).

## The two versions

- **Colour** (`condensed/stylish/condensed-stylish.pdf`): black and white with one signal yellow for the section bands and the portrait field, a warm table tint for alternate rows.
- **Monochrome** (`concept-mono.pdf`): the yellow bands become reversed black bands with white capitals, the portrait field light grey, rows tinted grey. It is the timetable printed in one ink, as most were.

Both are one A4 page.

## Scan Test

This is the most scan-first of the five.

- **Name:** 64 pt condensed capitals, top left.
- **Current title:** 22 pt condensed capitals directly under it.
- **Employers and dates:** "EXPERIENCE" band; each job opens with the start date in 22 pt numerals ("04/2022", "until present" under it) in the left column, role, employer and place beside it. Then one row per bullet.
- **Education:** its own band; years in 17 pt numerals left, qualification and school right.
- Contacts, including the passport line, are the table's column heads under the header.

Imagery stays small and functional: five pictograms (flights, ferries, coaches, hotels, guides) drawn as a timetable's symbol key, repeated with labels in the foot ("services he books and reconfirms"), from his Bookings bullet. The footnote mark "a" ties "valid from April 2027" in the head to the availability note in the foot.

## References and the principle taken from each

1. Bradshaw's Railway Companion, 1843, Science Museum Group, https://collection.sciencemuseumgroup.org.uk/objects/co8658721/bradshaws-railway-companion-timetable. **Principle:** the printed timetable as a reading machine: times in a fixed column, stations in another, everything ruled, nothing decorative.
2. Bradshaw Companion Timetable, October 1844, Internet Archive scan, https://archive.org/details/1844Bradshawtt. **Principle:** footnote marks and a key of symbols carry the conditions ("valid from", "a"), so the table itself stays clean.
3. Josef Müller-Brockmann, *Grid Systems in Graphic Design*, Niggli, ISBN 978-3-7212-0145-1. **Principle (my interpretation, not a claim the book makes in these words):** one grid of fields and rows for the whole page; bands and hairlines instead of boxes.
4. IBM Plex (IBM, OFL), https://github.com/IBM/plex. **Principle:** a grotesque with a true condensed width for dense rows that stay readable at body size; Sofia Sans Extra Condensed (bundled) for the big numerals and the name, as timetable departures are set.

## Why it differs

- **From the Flagship:** the Flagship's tenure column is a quiet side note; here the whole page is the table, with reversed bands and big numerals, and the art is a pictogram key, not a scene.
- **From the other four:** the only all-tabular page, the only condensed grotesque, the only one with no illustration beyond pictograms; the portrait is a hard-edged cell.
- **From earlier concepts:** Concourse was Japanese station wayfinding (station board in three scripts, LED departures, tactile paving); Timetable is printed matter (a table in a book), with no signage, no LED and no country. Stamp Rally had a small manifest table inside a boarding-pass page; here the table is the organising idea for every section. The rejected first tour-leader design's thin rail line with section dots is not used: there is no line of stations.
- **From the market:** builders use a sidebar plus stacked boxes; this has neither. Bands, rules and numerals carry the hierarchy.

## Fonts

| Family | File | Source | SHA-256 | Licence |
|---|---|---|---|---|
| IBM Plex Sans Condensed (added by this run; Typst names it "IBM Plex Sans") | `studio/design-concepts/fonts/ibm-plex-sans-condensed/IBMPlexSansCondensed-Regular.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/ibmplexsanscondensed/IBMPlexSansCondensed-Regular.ttf | `e7437c072eef2ef592ae6f2beb0000446287385907abb57ac1cf07bcbaa2aa33` | OFL 1.1 |
| | `IBMPlexSansCondensed-Italic.ttf` | same folder URL, `IBMPlexSansCondensed-Italic.ttf` | `a0320e60c17926c4e210dfdb3b1a346991f35f83b471daf55537ee79cbcb7c7f` | |
| | `IBMPlexSansCondensed-Medium.ttf` | same folder URL | `426350c298277f7f9d1a93956572799ca3d16e2d43e7f60eec8382bcd795ec30` | |
| | `IBMPlexSansCondensed-SemiBold.ttf` | same folder URL | `a081ca60548aea14100757a2d6fe71ca60fd90ebce779c9a8ae5a0c8fb4526d4` | |
| | `IBMPlexSansCondensed-Bold.ttf` | same folder URL | `b65492d86cdd5cd9d43d2671b55d5d36fec36859fc8b08bc6aba78e441d6c849` | |
| | `OFL.txt` | https://raw.githubusercontent.com/google/fonts/main/ofl/ibmplexsanscondensed/OFL.txt | `7e6b2818edbd8f6a01ae80641cc8f16a51080d08fb4e532be3a0b6f74adb07da` | |
| Sofia Sans Extra Condensed | bundled by the Framework | | | OFL |

## Generated images

None. Pictograms are Typst polygons drawn for this concept (no symbol set copied).

## Portrait

`portrait.png` and `portrait-mono.png`, prepared with `scripts/portrait.py prepare` (branch `feat/portrait-prep`) from `examples/candidates/fictional-engineer.png`: background removed, square, face centre at (0.503, 0.446); downscaled to 640 px (colour SHA-256 `6ef637049d7f4b18f99f3edd8680a3e27462df54861f2c383395bd08ef67396f`, mono `3889d936d3cd481439e4795f6e1754f0924cdb5f975fa5433610b1e8c4014c3a`). Placed in a 40 × 48 mm cell with `fit: "cover"`, centred horizontally; the cell is a little taller than wide, so the square is cropped evenly at the sides and the face stays centred and slightly high.

## Data

`sample.json` (the run's fictional record reshaped). Bullet text after the lead phrase is shown with its first letter capitalised, because the lead sits in its own column; the words are unchanged.

## Files

- `condensed/stylish/condensed-stylish.typ`, `.pdf`, `.png`: colour.
- `concept-mono.typ`, `.pdf`, `.png`: monochrome, at the style folder's root because of the `Output Contract`'s homes (see Rhumb Lines' brief). Generated from the colour `.typ`.

## What it would take to become a `Template`

- Components: `table-head(left, pictograms, right)`, `band(title, note)`, `row(station, text, shade)`, `job-row(from, to, role, employer)`, `key(services)`.
- Theme: signal colour (or reversed black), tint, the two faces.
- Data: everything is in the travel contract; the pictogram key would need a small list of service codes (flights, ferries, coaches, hotels, guides) rather than reading them out of the bullet.
- Fit rule: the page is dense; a third job or longer bullets must fail with a message naming what to cut, not shrink.

## Known weaknesses

- Least "illustrated" of the five; it wins on order and type, which suits the `scan-first` bar but may read as austere next to Poster Sun.
- The right-aligned lead phrases make a ragged left edge in the station column; that is the timetable convention, but some readers prefer left-aligned labels.
- "TABLE 1" is a playful device; the owner may prefer a plainer head strip.
- Running text binds its last three or four words together (a non-breaking tie) and the Skills column was widened, so no row ends in a lone "40." (round 2, Codex D1/D2). In round 3 the Languages and Skills bands got the same lead-in as every other band (D17).

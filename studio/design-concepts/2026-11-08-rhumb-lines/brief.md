# Rhumb Lines

**Idea:** the one-page CV laid out like an old sea chart: a 32-point wind rose holds the portrait, and its rhumb lines run faintly across the whole sheet. Three words: **portolan chart page**.

Run: idea run 2026-11-08 (editor), five one-page styles for a practical travel CV under the `scan-first` bar. `Domain` travel; specialty group and private travel; `Rank` Tour Leader / Travel Consultant. One design, `Condensed` density, `stylish` `Design Tier`, drawn twice: in its own palette and as a monochrome version.

## What the owner should notice first

The wind rose at top right: the portrait sits in its centre like the hemisphere on an old compass card, with the 32 points (8 principal winds in ink, 8 half-winds in green, 16 quarter-winds in vermilion) and a 128-tick ring around it. Then the name, set large in a display Garamond on two lines, and the faint web of rhumb lines behind everything.

## The two versions

- **Colour** (`condensed/stylish/condensed-stylish.pdf`): vellum paper, iron-gall ink, vermilion and verdigris green, the three colours the earliest charts used for their wind lines.
- **Monochrome** (`concept-mono.pdf`): ink on white. The chart-makers' colour code becomes a line code (principal winds solid, half-winds dashed, quarter-winds dotted; rose points black and grey), so the page keeps its logic without colour. Portrait in greyscale.

Both are one A4 page. No Spacious density in this run (owner's steer).

## Scan Test

- **Name:** top left, 50 pt, two lines.
- **Current title:** "Tour Leader / Travel Consultant" in vermilion bold capitals under the name, then the specialty.
- **Employers and dates:** each job is a two-column row: dates in a 27 mm margin column (vermilion bold italic, "04/2022 – present"), the role, employer (small caps) and place on one line beside it.
- **Education:** first column of the "Education, languages & skills" band, qualification bold, years in vermilion.
- Passport line in the contact legend; availability in the framed cartouche at the foot.

The domain is carried by imagery kept small and generic: the rose, the rhumb lines, the chart-maker's distance scale used as the section rule, and three recent journeys drawn as dashed sailing lines between stops. No country's iconography.

## References and the principle taken from each

1. Portolan chart (overview, Wikipedia), https://en.wikipedia.org/wiki/Portolan_chart. **Principle:** networks of rhumb lines radiating from wind roses across the whole chart, 32 directions; the web is the chart's texture, under everything.
2. Compass rose (Wikipedia), https://en.wikipedia.org/wiki/Compass_rose: the earliest portolan roses used "black for the eight main winds, green for the eight half-winds and red for the sixteen quarter-winds". **Principle:** the three-colour code of the rose and its lines, and (for the mono version) the idea that the hierarchy is in the line, not the hue.
3. "Rose of the Winds", compass card, about 1650, National Maritime Museum, https://rmg.co.uk/collections/objects/rmgc-object-42455: 32 bulbous points radiating from a hemisphere at the centre. **Principle:** something precious sits at the centre of the rose; here the portrait takes the hemisphere's place.
4. Compass in wooden case, G. Adams, Science Museum Group, https://collection.sciencemuseumgroup.org.uk/objects/co55550/compass-in-wooden-case-g-adams-fleet-street: a card ring divided into 128 parts with the 32 points named. **Principle:** the fine 128-tick ring that frames the rose.
5. Cormorant Garamond (Christian Thalmann, OFL), https://github.com/CatharsisFonts/Cormorant. **Principle:** a Garamond drawn for display sizes, used only for the name, job titles and the profile line; the text runs in Alegreya, a calligraphic text face made for long reading.

## Why it differs

- **From the Flagship:** no dark header band, no tools around a circle; the page is light vellum, serif-led, and the artwork is a chart instrument rather than equipment.
- **From the other four styles of this run:** the only serif, chart-based, light-paper style; the portrait sits in a rose, not a stamp (Airmail), a grid cell (Timetable), a sun (Poster Sun) or an ID photo frame (Guilloche).
- **From earlier concepts:** Woodblock Road, Stamp Rally, Concourse and Hanami are all Japan-specific; this uses a pan-Mediterranean, now generic, cartographic language with no country. Neither `Anti-example` (letter-grid inscription; misregistered overprint) is near.
- **From the market:** template sites put a compass icon in a header; here the rose is drawn as an instrument (point halves, 128-tick ring, north lozenge) and its lines organise the page's texture.

## Fonts

| Family | File | Source | SHA-256 | Licence |
|---|---|---|---|---|
| Cormorant Garamond | bundled by the Framework (`packages/cv-framework/fonts/`) | | | OFL |
| Alegreya | `studio/design-concepts/fonts/alegreya/Alegreya[wght].ttf` (already in the shared folder) | https://raw.githubusercontent.com/google/fonts/main/ofl/alegreya/Alegreya%5Bwght%5D.ttf | `ba5564634b93a8f8ba57b48cd4f1ae7417d2b4656fbac779028679b00de3cf12` | OFL 1.1 (`OFL.txt` beside it) |

No family added by this style.

## Generated images

None. The rose, rhumb lines, scale bars and routes are Typst drawing.

## Portrait

`portrait.png` (colour) and `portrait-mono.png` (greyscale with the same alpha), prepared on the lead's instruction with `scripts/portrait.py prepare` (branch `feat/portrait-prep`) from `examples/candidates/fictional-engineer.png` (source SHA-256 `262b1055967ece92f08ad0ada714e3e2b2f392f1816f433d6c8bc816ba1ee06a`): background removed, square, face centre at (0.503, 0.446) of the square. The tool's 1200 px output (SHA-256 `6b70c61aa5a852e688ae721b36f9ce6206ef2d04effd978a7576d68576bbed9c`) was downscaled to 640 px to keep the PDF near 0.5 MB; distributed `portrait.png` SHA-256 `6ef637049d7f4b18f99f3edd8680a3e27462df54861f2c383395bd08ef67396f`, `portrait-mono.png` `3889d936d3cd481439e4795f6e1754f0924cdb5f975fa5433610b1e8c4014c3a`. The image is placed centred in a circle with `fit: "cover"`, never shifted, so the face sits centred and a touch high.

## Data

`sample.json`, shared by both versions: the run's fictional record (`archive/work-records/idea-runs/2026-11-08-editor/fictional-record.json`) reshaped for the mock-up, substance unchanged: contacts with the passport line; five bullets on the current role and two on the previous, as lead phrase plus text; two education rows; three languages; "Skills & travel experience" with two lead-in items; availability; the three recent journeys. The specialty line adds "Europe and Asia", taken from the record's own travel-experience item. No month totals, no calendar arithmetic.

## Files

- `condensed/stylish/condensed-stylish.typ`, `.pdf`, `.png`: colour.
- `concept-mono.typ`, `.pdf`, `.png`: monochrome. It sits at the style folder's root, not beside the colour file as the brief asked, because the `Output Contract` (`packages/cv-workflow/cv_workflow/outputs.py`, `home_of`) only gives a home to `<density>-<tier>.pdf` inside a tier folder and to `concept-<variant>.pdf` at a run folder's root (the Hanami Line 2 palette precedent); a `condensed-stylish-mono.pdf` would be refused by `outputs.py stamp`. Its `Meta File` carries `variant: mono`, `density: condensed`, `tier: stylish`. The mono `.typ` is generated from the colour one (`mono` flag and root path switched), so the two never drift.

## What it would take to become a `Template`

- Artwork pack: `wind-rose(radius, portrait)`, `rhumb-field(centres)`, `scale-rule(width)`, `route-line(stops)`; all parametric Typst, no rasters.
- Theme: paper, ink, three wind colours (or the mono line code), display and text faces.
- Data: the travel contract already holds contacts, experience with bullets, education, languages, availability and trips; the journeys strip needs `trips[].stops` and `period`, which contract 2 has. The specialty's region suffix should become a field rather than a literal.
- Layout guard: the contact legend and the name block must leave the rose's 94 mm square free; a long name needs a check that fails with a message, not shrinking.

## Known weaknesses

- The rhumb lines are deliberately faint; on a poor photocopier they may vanish, leaving only the rose (the page still reads).
- Alegreya italics for dates are lively; a conservative reader may prefer upright dates.
- Under the rose's lower points the contact legend and profile line run close to the medallion; a longer email address would need the legend narrowed.
- The fictional portrait is a man and the record's name is a woman's; that is the run's shared fictional portrait, not a design choice.

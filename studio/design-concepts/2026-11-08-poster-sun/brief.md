# Poster Sun

**Idea:** the top of the one-page CV is a flat-colour travel poster, and the portrait is its sun rising over a generic coast; below, a calm two-column page in the poster's geometric type. Three words: **sunrise travel poster**.

Run: idea run 2026-11-08 (editor), five one-page styles for a practical travel CV under the `scan-first` bar. `Domain` travel; specialty group and private travel; `Rank` Tour Leader / Travel Consultant. One design, `Condensed` density, `stylish` `Design Tier`, drawn twice: in its own palette and as a monochrome version.

## What the owner should notice first

The sun: the cut-out portrait in a coral ring on a pale disc, with a burst of rays, sitting just above the horizon; its reflection breaks into glints on the sea. Around it a stepped sunrise sky, a headland and a distant coast, waves, a small ferry and a plane with a dashed trail. The name is the poster's headline in geometric capitals, the rank in a reversed ink label, and the poster ends in an ink band with the contacts.

## The two versions

- **Colour** (`condensed/stylish/condensed-stylish.pdf`): sunrise bands (apricot to cream), coral sun, two teals for the coast, deep sea; ink text.
- **Monochrome** (`concept-mono.pdf`): a one-ink linocut. White sky with black rays, the far coast in hairline tint, the headland and sea solid black with white waves and glints cut out of them, a black ring round the portrait on a light grey disc. It is drawn for one ink, not a greyscale of the colour page.

Both are one A4 page.

## Scan Test

- **Name:** top left of the poster, 46 pt capitals on two lines.
- **Current title:** reversed ink label right under it, then the specialty.
- **Employers and dates:** main right column; each role bold with dates flush right in coral (black in mono), employer in teal and place on the next line.
- **Education:** main column under Experience, years flush right.
- Left column: Profile, Personal (date of birth, nationality, passport validity), Languages, Skills & travel experience, Availability. Phone, email and base are in the poster's ink band.

## References and the principle taken from each

1. Federal Art Project, Poster Division (Wikipedia), https://en.wikipedia.org/wiki/Federal_Art_Project: production moved quickly from hand painting to "widespread adoption of the silkscreen process". **Principle:** a few flat inks, laid in bands; tone made by stepping colour, not gradients.
2. Library of Congress, Work Projects Administration Poster Collection, https://www.loc.gov/pictures/collection/wpapos/ (found by search; loc.gov refuses automated fetching): over 900 posters, mostly silkscreens, including travel posters. **Principle:** the travel poster's grammar: headline type over a simplified landscape with one strong focal shape.
3. Linocut (Wikipedia), https://en.wikipedia.org/wiki/Linocut: relief print, one ink on the raised surface. **Principle (mono version):** solid black masses with white lines cut out of them (waves, glints) instead of grey fills.
4. Jost* by indestructible type, https://indestructibletype.com/Jost.html: a digital revival of the attitude of a 1927 geometric sans, larger x-height. **Principle:** the poster's geometric capitals for the headline and section heads, the same family for the text so the page has one voice.

## Why it differs

- **From the Flagship:** both have a portrait in a circle in a strong header, but the Flagship's is a technical emblem (tools, gauge) on a dark band; here the header is an illustrated landscape and the circle is the sun in the picture.
- **From the other four:** the only illustrated scene and the only geometric-sans voice; the warmest palette; the left column holds personal facts, the right column the career (Rhumb Lines and Guilloche keep the career left).
- **From earlier concepts:** Woodblock Road's header was a Japanese woodblock print with a group on a bridge; Hanami uses a torii, sakura and Japan pieces. This is a generic coast with no landmark, no country, flat screenprint rather than woodblock.
- **From the market:** builders' "creative" templates use stock header photos or abstract blobs; this is a drawn scene whose focal point is the candidate.

## Fonts

| Family | File | Source | SHA-256 | Licence |
|---|---|---|---|---|
| Jost | `studio/design-concepts/fonts/jost/Jost[wght].ttf` (already in the shared folder) | https://raw.githubusercontent.com/google/fonts/main/ofl/jost/Jost%5Bwght%5D.ttf | `6343b70971000b04c5d401c96ae08ce371086135e999d5e1e1413039c0213076` | OFL 1.1 (`OFL.txt` beside it, `1af3438a4d5f0ed2bdbc5751a5a67ebf6d537334161184b7fbb68503ef0ea0c5`) |

No family added by this style.

## Generated images

None. The whole poster is Typst drawing: stepped bands, polygons, curves and line tilings. A Codex raster (a printed, grainy screenprint texture) could add tooth later; not needed for the idea.

## Portrait

`portrait.png` and `portrait-mono.png`, prepared with `scripts/portrait.py prepare` (branch `feat/portrait-prep`) from `examples/candidates/fictional-engineer.png`: background removed, square, face centre at (0.503, 0.446); downscaled to 640 px (colour SHA-256 `6ef637049d7f4b18f99f3edd8680a3e27462df54861f2c383395bd08ef67396f`, mono `3889d936d3cd481439e4795f6e1754f0924cdb5f975fa5433610b1e8c4014c3a`). Placed in the sun circle with `fit: "cover"`, centred; the pale disc behind the figure is drawn in the design.

## Data

`sample.json` (the run's fictional record reshaped). The "Personal" heading groups date of birth, nationality and passport; the specialty line adds "Europe and Asia" from the record's travel-experience item.

## Files

- `condensed/stylish/condensed-stylish.typ`, `.pdf`, `.png`: colour.
- `concept-mono.typ`, `.pdf`, `.png`: monochrome, at the style folder's root because of the `Output Contract`'s homes (see Rhumb Lines' brief). Generated from the colour `.typ`.

## What it would take to become a `Template`

- Artwork pack: `poster(sky-bands, coast-shapes, sea, sun(portrait), plane, ferry)` with the scene's shapes as data, so a client could get a different generic coast (or a city skyline) without new code; a mono variant built on tilings.
- Theme: sky bands, sun, coast, sea, ink; Jost.
- The name block sits over the sky at fixed size; a long name needs a check (two lines of at most about 10 characters at 46 pt).

## Known weaknesses

- The most decorative of the five; a very conservative employer may read the poster as holiday-like rather than professional.
- The coast is generic but sunny-southern in mood; for a client whose market is northern or city travel, the scene should change.
- The left column is fuller than the right, leaving air at the foot of the right column.

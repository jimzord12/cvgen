# Guilloche

**Idea:** the one-page CV opens as the data page of a travel document, engraved like security print: a woven rosette, a rainbow-tinted card, a ghost portrait, a globe and a machine-readable zone carrying her name; the engraved line stays as the body's section rule. Three words: **engraved security print**.

Run: idea run 2026-11-08 (editor), five one-page styles for a practical travel CV under the `scan-first` bar. `Domain` travel; specialty group and private travel; `Rank` Tour Leader / Travel Consultant. One design, `Condensed` density, `stylish` `Design Tier`, drawn twice: in its own palette and as a monochrome version.

## What the owner should notice first

The card at the top: a rounded data page tinted mint to peach to lilac, an underprint of woven wave lines, a two-ring rosette at right with a faded second portrait in its centre, the photo at left with an engraved globe under it, the fields in a calm grid, and two lines of machine-readable characters across the foot: `CV<KONTOU<<DAPHNE<<<…` and `TOUR<LEADER<<TRAVEL<CONSULTANT<<GRC<970504<<`. It is the passport-validity line made into the page's whole idea.

## The two versions

- **Colour** (`condensed/stylish/condensed-stylish.pdf`): deep green-black ink, engraved green and rose lines, the rainbow-tint card.
- **Monochrome** (`concept-mono.pdf`): a white card engraved in black and grey hairlines, as an intaglio proof; all accents black. The engraving carries it, so it does not need the tint.

Both are one A4 page.

## Scan Test

- **Name:** "KONTOU, Daphne" in 27 pt bold on the card, under a field label, as a document would print it.
- **Current title:** "Tour Leader / Travel Consultant" in 14 pt directly under it.
- **Employers and dates:** main left column of the body; role bold, dates in monospace flush right, employer in green with place.
- **Education:** main column under Experience, years flush right.
- The card's fields carry specialty, base, phone, date of birth, email, nationality, passport validity and the availability month. Right column: Languages, Skills & travel experience, Availability, Recent journeys.

## References and the principle taken from each

1. Guilloche and rainbow printing, EUIPO anti-counterfeiting technology guide, https://euipo.europa.eu/anti-counterfeiting-and-anti-piracy-technology-guide/marking-technologies/guillocherainbow-printing: repeating patterns of engraved lines, and offset colours that "blend gradually". **Principle:** the rainbow tint across the card and the woven underprint.
2. "Geometric and Floral Banknote Design", Stephen Gooden, 1954, Bank of England Museum, https://artsandculture.google.com/asset/geometric-and-floral-banknote-design/VgFBE3kAP4xNqQ. **Principle:** the rosette as a precise, engraved ornament whose intricacy is the point; drawn here from equations (phase-shifted lobed circles), not copied.
3. Geometric lathe (Wikipedia), https://en.wikipedia.org/wiki/Geometric_lathe. **Principle:** the patterns are made by a machine from a few parameters; the Typst functions do the same (lobes, amplitude, phase count), so the ornament is generated, not traced.
4. Machine-readable passport (Wikipedia), https://en.wikipedia.org/wiki/Machine-readable_passport: a TD3 data page's machine-readable zone has two lines of 44 characters, A–Z, 0–9 and the filler `<`, standardised by ICAO Doc 9303. **Principle:** the two 44-character lines as the card's foot, written honestly from her data (surname, given name, rank, nationality code, date of birth); it is a CV, so the document code is "CV", not a passport's.

## Why it differs

- **From the Flagship:** a light card instead of a dark band, an engraved document instead of tools, and the portrait in a rectangular ID frame.
- **From the other four:** the only document card, the only engraved (generated line) ornament, the only humanist sans plus monospace voice.
- **From earlier concepts:** Stamp Rally was "the escort's travel papers" through a boarding pass, rubber stamps and luggage tags; this takes one different object (the data page) and its craft (security engraving), with no stamps, tickets or tags, and no country emblem. Not near either `Anti-example`.
- **From the market:** online builders never use engraving; the nearest they come is a hairline. The rosette and bands here are drawn line by line.

## Fonts

| Family | File | Source | SHA-256 | Licence |
|---|---|---|---|---|
| Fira Sans | `studio/design-concepts/fonts/fira-sans/` (already in the shared folder): `FiraSans-Regular.ttf`, `-Medium`, `-Bold` used | https://raw.githubusercontent.com/google/fonts/main/ofl/firasans/FiraSans-Regular.ttf (and `-Medium`, `-Bold` beside it; first recorded in Concourse's brief) | Regular `c29556a2719bf613ef3d5e070e40d903a8965d9c081beca1375dc1e6e0f93c23`, Medium `cbc1842cbed8c1d1146ba7c9db97d8f28c9bedfd25f41c5b0e1259ca48622328`, Bold `a4d8e149ecdd4874a0726eb0af894488b3b31c423d6b0017c8f415ed1b795b45` | OFL 1.1 |
| IBM Plex Mono (added by this run) | `studio/design-concepts/fonts/ibm-plex-mono/IBMPlexMono-Regular.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/ibmplexmono/IBMPlexMono-Regular.ttf | `6a3412f058c7d8dfd9170c41e85ade48e5156ecb89356110ca57a0a27734af46` | OFL 1.1 |
| | `IBMPlexMono-Medium.ttf` | same folder URL | `a9b4c49bb299e05b5f6c481e7fb5e78943d2793249a0c8874ab574a2d1ea6755` | |
| | `IBMPlexMono-SemiBold.ttf` | same folder URL | `d3c38e55c78f5b0f28009fddba4834ec503278936a5986032424c9bd2d23aa46` | |
| | `OFL.txt` | https://raw.githubusercontent.com/google/fonts/main/ofl/ibmplexmono/OFL.txt | `7e6b2818edbd8f6a01ae80641cc8f16a51080d08fb4e532be3a0b6f74adb07da` | |

## Generated images

None. Rosettes, wave bands, globe and microprint are Typst drawing.

## Portrait

`portrait.png` and `portrait-mono.png`, prepared with `scripts/portrait.py prepare` (branch `feat/portrait-prep`) from `examples/candidates/fictional-engineer.png`: background removed, square, face centre at (0.503, 0.446); downscaled to 640 px (colour SHA-256 `6ef637049d7f4b18f99f3edd8680a3e27462df54861f2c383395bd08ef67396f`, mono `3889d936d3cd481439e4795f6e1754f0924cdb5f975fa5433610b1e8c4014c3a`). The main photo is a 36 × 48 mm frame on a pale fill with `fit: "cover"`, centred, so the face is centred and slightly high; the ghost is the same image at 16 × 20 mm under a white veil.

## Data

`sample.json` (the run's fictional record reshaped). The MRZ uses only record facts: surname, given name, the rank words, "GRC" for the Greek nationality and 970504 for 4 May 1997; no invented document number or check digits.

## Files

- `condensed/stylish/condensed-stylish.typ`, `.pdf`, `.png`: colour.
- `concept-mono.typ`, `.pdf`, `.png`: monochrome, at the style folder's root because of the `Output Contract`'s homes (see Rhumb Lines' brief). Generated from the colour `.typ`.

## What it would take to become a `Template`

- Artwork pack: `rosette(r, amp, lobes, phases)`, `waveband(width, height, lines, periods)`, `globe(r)`, `mrz(lines)`, `microprint(text)`; all parametric.
- A small function to build the MRZ from data (uppercase, A–Z only, `<` filler, 44 characters, length check for long names).
- Theme: ink, two engraving colours, the card tint (or white for mono), Fira Sans and Plex Mono.
- Performance: the rosettes are thousands of curve points; compile is still fast, and the PDF is about 0.65 MB with the portrait.

## Known weaknesses

- The document conceit could read as imitating an official ID; it carries no emblem, no country name and the code "CV", but the owner should judge whether a client would be comfortable.
- The card's travel signal is the document itself plus the globe; it is the least pictorial of the five apart from Timetable.
- The microprint line at the foot is ornament (4.2 pt), not content.

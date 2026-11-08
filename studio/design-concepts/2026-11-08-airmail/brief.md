# Airmail

**Idea:** the one-page CV sent as an airmail letter: the striped airmail border frames the sheet, the portrait is the postage stamp, the postmark carries the availability date, and every label is typed. Three words: **airmail letter border**.

Run: idea run 2026-11-08 (editor), five one-page styles for a practical travel CV under the `scan-first` bar. `Domain` travel; specialty group and private travel; `Rank` Tour Leader / Travel Consultant. One design, `Condensed` density, `stylish` `Design Tier`, drawn twice: in its own palette and as a monochrome version.

## What the owner should notice first

The border of slanted red and blue bars all round the page, known everywhere as "this came from abroad". Then the stamp at top right: the cut-out portrait on a sky-blue field inside a printed blue frame, with perforated edges and "TOUR LEADER" printed in its foot; a round cancellation beside it reads "AVAILABLE FROM · APR 2027 · TWO WEEKS' NOTICE", with wavy cancel lines running across the stamp's lower edge, below the face.

## The two versions

- **Colour** (`condensed/stylish/condensed-stylish.pdf`): airmail red and blue on pale blue letter paper; dates and levels in red, typed labels in blue.
- **Monochrome** (`concept-mono.pdf`): the bars become one dark grey alternating with white, on a pale grey sheet, so the white stamp still shows its perforations; labels in black, the stamp frame in grey. Round 2 dropped the earlier mid-grey bar, which read as hazard tape (design D7). Round 3 lightened the border bars to a mid-dark grey and drew the short bar runs at each section head as hairline outlines, so neither reads as hazard tape (design D16, Codex lineup D2).

Round 2 also made the border about 30 % thinner in both versions (a 4.4 mm band of 4.6 mm bars), so the frame competes less with the text (Codex lineup D2).

Both are one A4 page.

## Scan Test

- **Name:** top left, 35 pt typed capitals under the "PAR AVION · BY AIR MAIL" label.
- **Current title:** typed red capitals, underlined like a typed subject line, then the specialty.
- **Employers and dates:** a letter layout with hanging labels: "EXPERIENCE" in the left column; each job gives role (bold), employer (blue) and place on one line, with dates typed flush right on the same line.
- **Education:** its own hanging label; qualification and school left, years typed flush right.
- Passport validity sits in the typed address block with the other contacts; availability has its own row and the postmark.

Every row opens with a short length of the border's bars, so the body belongs to the envelope without decoration in the text.

## References and the principle taken from each

1. Airmail etiquette (Wikipedia), https://en.wikipedia.org/wiki/Airmail_etiquette: the usual label is "a plain blue oblong" with "AIR MAIL" and/or "PAR AVION" in white. **Principle:** the blue label at top left, the page's first signal.
2. Airmail stamped envelopes, Smithsonian National Postal Museum, https://postalmuseum.si.edu/exhibition/fad-to-fundamental-airmail-in-america-airmail-object-showcase-stamps-and-covers/us-1 (found by search; the page refuses automated fetching, so its wording is from the search summary): the red-and-blue border marked U.S. airmail stationery for most of the twentieth century. **Principle:** a border of slanted bars as the whole identity of a sheet; no picture needed. Drawn here as generic bars, no national stationery copied.
3. Postage stamp separation (Wikipedia), https://en.wikipedia.org/wiki/Postage_stamp_separation: rows of small holes, gauge about 11 to 14 per 2 cm. **Principle:** perforations at a believable gauge (one hole every 3.2 mm, about 12.5) make the portrait a stamp rather than a framed photo.
4. Courier Prime at Fonts In Use, https://fontsinuse.com/typefaces/232472/courier-prime: a 2013 redrawing of Courier with crisper serifs and a darker bold, OFL. **Principle:** the typed voice for labels, dates, the name and the address block, with a humanist sans for the long text so the bullets stay readable.

## Why it differs

- **From the Flagship:** no dark band or engineering artwork; the frame is the whole sheet's edge and the voice is typewritten.
- **From the other four:** the only bordered page, the only typewriter voice, the only single-column letter with hanging labels; the portrait is a perforated stamp.
- **From earlier concepts:** Stamp Rally used rubber station stamps, a boarding pass and luggage tags for Japan; Airmail is postal (envelope border, postage stamp, cancellation) and carries no country. Not near either `Anti-example`.
- **From the market:** online builders frame nothing; their "creative" templates use a coloured sidebar. Here the border is drawn geometry, the stamp is drawn paper, and the postmark text is set on a circle character by character.

## Fonts

| Family | File | Source | SHA-256 | Licence |
|---|---|---|---|---|
| Courier Prime (added by this run) | `studio/design-concepts/fonts/courier-prime/CourierPrime-Regular.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/courierprime/CourierPrime-Regular.ttf | `72f793376f8e2841656bf21d77a5de010f2929bd6956a22ee848ad0c7eb978af` | OFL 1.1 |
| | `CourierPrime-Bold.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/courierprime/CourierPrime-Bold.ttf | `ff1f38786c849d1c41fa8e447960abdb2bd75fdfb0cfcdeb524fad65a5af3638` | |
| | `CourierPrime-Italic.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/courierprime/CourierPrime-Italic.ttf | `f1b9a5829789f7e56432a9f3bc7665ef4531dbba1c112639e48bef39621a006b` | |
| | `OFL.txt` | https://raw.githubusercontent.com/google/fonts/main/ofl/courierprime/OFL.txt | `9a755af092b494944c99f471be6fddd19b006a448fefdc4717e4ee0aa09a97b0` | |
| Source Sans 3 | bundled by the Framework | | | OFL |

## Generated images

None. Border, stamp, perforations, postmark and cancel lines are Typst drawing.

## Portrait

`portrait.png` and `portrait-mono.png`, prepared with `scripts/portrait.py prepare` (branch `feat/portrait-prep`) from `examples/candidates/fictional-engineer.png`: background removed, square, face centre at (0.503, 0.446); downscaled from 1200 to 640 px (colour SHA-256 `6ef637049d7f4b18f99f3edd8680a3e27462df54861f2c383395bd08ef67396f`, mono `3889d936d3cd481439e4795f6e1754f0924cdb5f975fa5433610b1e8c4014c3a`). The stamp's picture area is drawn sky-blue (light grey in mono) behind the figure; the image fills it with `fit: "cover"`, centred, so the face sits centred and slightly high.

## Data

`sample.json`, the run's fictional record reshaped (see Rhumb Lines' brief for the shape); same content in both versions. The postmark repeats two facts from the record (available from April 2027, two weeks' notice); the full availability sentence is also in its row.

## Files

- `condensed/stylish/condensed-stylish.typ`, `.pdf`, `.png`: colour.
- `concept-mono.typ`, `.pdf`, `.png`: monochrome, at the style folder's root because the `Output Contract` gives a home only to `condensed-stylish.pdf` in the tier folder and to `concept-<variant>.pdf` at the run folder's root (Hanami Line 2 precedent). Generated from the colour `.typ` by switching the `mono` flag and root path.

## What it would take to become a `Template`

- Artwork pack: `airmail-border(band, colours)`, `stamp(portrait, caption)`, `postmark(top-arc, centre, bottom-arc)`, `cancel-waves(width, lines)`, `bar-rule`.
- Theme: paper, the two bar colours, label colour, typed and text faces.
- The postmark's text should come from data (availability month and notice) with a length check: the arc holds about 18 characters.
- The hanging-label column needs a rule for labels longer than two lines.

## Known weaknesses

- The border reads instantly as "abroad", but a very conservative reader may find it playful; the body itself is plain.
- In mono, slanted dark bars can still recall barrier tape on a heavy print; one grey on white and a thinner band keep it closer to airmail stationery.
- The two Skills items sit side by side in unequal columns so neither ends in a lone word; running text also binds its last three or four words together (a non-breaking tie).
- The postmark's small arc lettering (5.8 to 6.4 pt) is ornament; the same facts are set at body size in the Availability row.

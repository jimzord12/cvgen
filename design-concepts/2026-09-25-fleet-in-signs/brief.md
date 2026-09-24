# Fleet in Signs

**Idea: count the fleet in signs.** One equal-sized pictogram per vessel; its
silhouette gives the vessel class, its colour the rank held aboard. Rows are
companies, newest at the top, so the page shows the career rising from pale
cadet ships to the black ships of the current rank.

Files: `concept.pdf` / `page-1.png` (marine, fictional second engineer Alex
Morgan). Signs: `signs/*.svg`, drawn for this concept.

## What to notice first

1. The colour progression down the page: sand (cadet), blue-grey (fourth),
   red (third), black (second engineer). Promotion is visible without reading.
2. Rows of different length: more vessels are more signs, never bigger signs.
3. The key reads like an Isotype chart's: "each sign is one vessel".

## References and the principle taken from each

| Reference | Principle taken |
|---|---|
| Isotype, Otto Neurath and Gerd Arntz, Gerd Arntz Web Archive, http://gerdarntz.org/content/gerd-arntz.html | "More or less are not represented by bigger or smaller symbols, but by more or less symbols"; signs "instantly recognizable, without any distracting detail"; horizontal for quantity, vertical for time or comparison. Gave equal signs per vessel, rows per company, time running down the page. |
| US Navy ONI ship recognition manuals (1940s, public domain scans), https://www.coatneyhistory.com/drawings.htm | Side-view recognition drawings used to identify a ship's class. Gave one beam-view sign per class; reducing each sign to solid basic masses follows Isotype's rule above, not this source. The signs are drawn from scratch for merchant classes (tanker, gas carrier, bulk, container, ferry, general cargo); nothing traced, and the manuals show warships. |
| Karl Gerstner, Designing Programmes (1964), https://www.lars-mueller-publishers.com/designing-programmes-0 | Design as a rule set that produces different yet coherent results. Gave the page as a programme: vessel type to sign, rank to colour, company to row. Any record renders a coherent page with no hand drawing. |

## Why it differs

- **From Flagship:** Flagship decorates with engine-room artwork; here the
  pictures are the data and there is no decoration at all. No portrait, no
  dark band, cream paper, geometric sans.
- **From the design studies:** none of them charted the record.
- **From the market:** market templates put icons before contact lines and
  rate skills with dots. Here every sign is a counted fact (one vessel), and
  there are no ratings, no icons on contacts, no sidebar. Market galleries
  checked (vendor marketing): https://enhancv.com/resume-templates/ (sidebars,
  photos, skill bars, section icons) and https://novoresume.com/resume-templates
  ("rating styles" for skills, "creative backgrounds").

## Fonts and licences

- **Jost** (variable, weight 100-900), indestructible type*, SIL OFL 1.1, a
  geometric sans in the spirit of the faces Isotype used. From the Google Fonts
  repository, unmodified: `fonts/Jost[wght].ttf`, licence `fonts/OFL.txt`.

## Data it needs

All from the marine candidate schema: `identity`, `contacts`, `profile`,
`companies[].groups[].type`, `ships[].name/rank/months`, `certificates`,
`education_entries`, `language_entries`.

- **Vessel class is inferred from the group's `type` text** by keyword
  (tanker, LNG/LPG/gas, bulk, container, ferry/Ro-Pax/passenger, cargo);
  anything else gets a generic hull. A template should not guess: it needs a
  class field or a type-to-class table in the domain.
- Rank colours are assigned in the order ranks first appear in the record
  (newest first), four colours at most; a fifth rank reuses the palest.
- Totals are sums of vessel months; the vessel count is unique ship ids.

## What it would take to become a template

- An **artwork pack of vessel-class signs** (one SVG per class). Today packs
  recolour with `{{ink}}`, `{{accent}}`, `{{metal}}`; this needs a per-use fill
  (the mock-up replaces `{{fill}}`), a small extension to `decoration`.
- A theme token `rank-colours` and a page colour. Choose rank colours by
  luminance step first and hue second (here roughly dark, mid, light, pale), so
  each rank stays a distinct grey on a photocopy; hue alone is not enough.
- Option not drawn: move the key up beside the name, so the idea shows in the
  header too. Kept next to the chart here because the header's right side
  already holds the contacts, and the key reads best just above the rows it
  explains.
- A layout rule for rows: at this sign size one row holds six vessels plus a
  group gap; a company with seven or more needs a second sign row.
- Add Jost to `packages/cv-engine/fonts/` with its licence.
- The class names in the key come from the domain copy, so a travel domain
  could swap in property signs (resort, city hotel, cruise ship). Not drawn.

## Open weaknesses

- In black and white, red (third) and blue-grey (fourth) come out as similar
  mid greys. Mitigated: every group label also states its rank in text
  (7.5 pt, under the vessel type).
- Vessel names under the signs are 6.3 pt, small but legible.
- Tanker and bulk carrier signs differ in deck detail only; at the key's 12 mm
  they are close, at 19 mm in the chart they separate clearly.
- Cream paper (`#fcfaf5`) is a choice; white is a one-token change.

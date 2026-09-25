# Measured in Months

**Idea: the career drawn to scale.** Every vessel is one bar whose length is its
service months, all on one ruler, oldest to newest; the rest of the page is a
timetable-strict ledger in one grotesque family, black plus one signal red.

Files: `concept.pdf` / `page-1.png` (marine, fictional chief officer Eleni
Markou), `concept-travel.pdf` / `concept-travel-page-1.png` (the same render
function on a fictional hospitality record, `travel-sample.json`).

## What to notice first

1. The strip: 22 bars, 129 months, read in one glance. Long contracts are long
   bars; the red block is the current company.
2. The name set as one condensed line at poster size, then nothing decorative
   anywhere else: the data is the image.
3. The travel page: same code, different field, no marine words left.

## References and the principle taken from each

| Reference | Principle taken |
|---|---|
| Charles Ibry's graphical train schedule (Paris-Lyon), cited in E. J. Marey, *La méthode graphique*, https://en.wikipedia.org/wiki/Charles_Ibry | Time drawn as length on one shared proportional axis; you read durations by length before reading numbers. Gave the strip and the ruler in cumulative months. |
| Josef Müller-Brockmann's Tonhalle concert posters, https://www.thegraphicdesignschool.com/design-history/joseph-mueller-brockmann/ and https://en.wikipedia.org/wiki/Josef_M%C3%BCller-Brockmann | A strict column grid organising the type, with one grotesque carrying both title and programme text. Gave the single family doing every job through width and weight alone (62% condensed name, 125% expanded rank), and the rigid 180 mm measure. |
| Timetables archived by Fonts In Use, e.g. Northeast Airlines timetable 1969, https://fontsinuse.com/uses/44461/northeast-airlines-timetable-1969 (tag: https://fontsinuse.com/tags/9882/timetables) | Timetable order: one family (Kabel) in several weights with tight spacing, printed in two colours, black and yellow. Gave one family in several weights and the black-plus-one-signal-colour palette (the signal here is red, not yellow). The tabular figures, hairline ledger and totals row are my own addition, not taken from this source. |
| Eye magazine, "The front matter", https://www.eyemagazine.com/feature/article/the-front-matter | "Making a feature of huge numerals" as keys. Gave the three big figures (months, vessels, companies) set like a timetable header. |

No artifact is copied: no traced drawing, no logo, no copy text. The concept
takes structure (proportional axis, grid, palette logic), never a look.

## Why it differs

- **From Flagship:** no hero band, no portrait, no artwork, one page instead of
  two, light page. Flagship lists vessels as rows; this draws them to scale.
- **From the design studies:** no sidebar, no compass or hull drawing, no serif.
- **From the market (Canva, Enhancv, Zety, Novorésumé, Resume.io):** no
  sidebar, no photo, no skill bars or icons, no timeline dots. The only
  "chart" is the service record itself, drawn to scale; nothing is a rating.
  Market galleries checked (vendor marketing): https://enhancv.com/resume-templates/
  (sidebars, photos, skill bars, section icons) and
  https://novoresume.com/resume-templates ("rating styles" for skills,
  "creative backgrounds").

## Fonts and licences

- **Archivo** (variable, width 62-125 %, weight 100-900), Omnibus-Type, SIL OFL
  1.1. From the Google Fonts repository, unmodified: `design-concepts/fonts/archivo/Archivo[wdth,wght].ttf`,
  licence `design-concepts/fonts/archivo/OFL.txt`. One family for the whole page.

## Data it needs

All from the marine candidate schema: `identity.name`, `identity.rank`,
`contacts` (Based in, Telephone, Email, Discipline), `profile`,
`companies[].name/period/groups[].type/ships[].id/name/rank/months`,
`certificates` (title, scope, review), `education_entries`, `language_entries`.

- Needs **per-vessel `months` for every vessel**. A record with hidden
  durations and only `service-months` cannot draw per-vessel bars; the honest
  fallback is one bar per company. Not built.
- Totals are sums of `months` from the record; years are those months divided
  by 12, never calendar arithmetic. The ruler counts service months, not years.
- The strip runs oldest to newest, left to right. It assumes the record lists
  companies newest first and, inside each company, vessels newest first (the
  record convention), and reverses both. A record in any other order would draw
  a wrong sequence, so a template needs that order stated in the schema, or a
  per-vessel sequence field. The facts carry no per-vessel dates, so the order
  inside a company is only as good as the record's order.
- Travel and tourism: needs its own facts shape (employer, property type,
  placement or season, role, months). `travel-sample.json` is a sketch of one,
  not a schema proposal.

## What it would take to become a template

- A field-neutral **proportional strip** component in `core/` (it only needs
  entries with months and a grouping), so marine and a future travel domain
  share it. The ledger and credentials blocks are ordinary components.
- Theme tokens: `ink`, `ink-2`, `signal`, `rule`, one font family; layout
  tokens: bar height, gaps, tick step (6 and 12 months), name fringe depth
  (measured from the longest vessel name in this mock-up).
- Add Archivo to `packages/cv-framework/fonts/` with its licence.
- A page-plan rule for long careers: past about 30 vessels, or with contracts
  under 3 months, the strip needs two lines split at a company boundary.
- The marine words (months at sea, vessels, companies) come from the domain
  copy; the travel variant proves the render function holds no marine words.

## Open weaknesses

- Vessel names on the strip read sideways (7 pt); the ledger repeats the
  companies, not the vessel names. A recruiter who wants names reads the fringe.
- Company labels above the strip take two or three lines depending on name
  length; a template should give them a fixed two-line slot (name truncated
  or set narrower), which this mock-up does not do.
- In black and white the red company becomes the same grey as alternate
  companies; gaps and labels still separate them, and the ledger names it.
- Very short contracts (1-2 months) give bars too narrow for their number.
- Travel entry names must be short (for example "Lindos, 2025") to fit the
  fringe.

## Font files

Shared folder `design-concepts/fonts/`, unmodified, recorded 2026-09-25.

| File | Source | SHA-256 |
|---|---|---|
| `Archivo[wdth,wght].ttf` | https://github.com/google/fonts/tree/main/ofl/archivo | `0e094a7d3c7c4c25cf1310c4b30014f1dae9332220b1c2c88f4fa996f0b05053` |

# Feature Opener

**Idea: the CV as a magazine feature.** The first page of a long read: kicker,
a headline name at 112 pt, an italic standfirst, the career set as a contents
list with dot leaders, the service figures as a pull-quote, a tinted fact file
and certificates as back matter.

Files: `concept.pdf` / `page-1.png` (marine, fictional master Daniel Reed),
`concept-travel.pdf` / `concept-travel-page-1.png` (the same render function on
the fictional hospitality record in `travel-sample.json`).

## What to notice first

1. The headline: the name is the only image on the page, and it carries it.
2. The pull-quote: "138 months at sea" in oxblood, then the same figures spelled
   out the way a magazine sets numbers in text.
3. The vessel list reads like a table of contents: vessel, leaders, months.

## References and the principle taken from each

| Reference | Principle taken |
|---|---|
| Eye magazine, "Mondo magazines", https://eyemagazine.com/feature/article/mondo-magazines | Features "divided with extreme formalism into headline, stand-first and text". Gave the fixed sequence kicker, headline, standfirst, body. |
| Eye magazine, "That's art direction", https://www.eyemagazine.com/feature/article/thats-art-direction | Headline scale signals tone (small headlines read as serious, big ones as loud); a "tightly detailed typographic system (horizontal rules, tinted panels ...)" organises the page. Gave the double horizontal rules between zones and the single tinted fact-file panel. The source ties seriousness to small headlines, but the name here is 112 pt. That is deliberate: it is the only large element, set in a light serif with no bold and no colour, and everything else stays small and restrained, so the page gets the opener's impact without the loud tone. |
| Leaders in book contents pages, https://en.wikipedia.org/wiki/Leader_(typography) | Dot leaders connect an entry to its number across a wide measure. Gave the vessel list: name, leaders, months, as in a contents page. |
| Matthew Butterick, résumés chapter, https://practicaltypography.com/resumes.html | "Never assume a reader will get past the first page"; employers must be "immediately visible". Kept every fact on page one and set each company as a headed entry, however editorial the page. |

No artifact is copied: no masthead, no magazine's name, logo, layout or copy.
Principles only.

## Why it differs

- **From Flagship:** no dark hero, no portrait, no artwork; a serif voice
  instead of condensed caps; one page.
- **From the design studies:** Horizon used a serif name inside a conventional
  CV layout. Here the whole page is built as an editorial opener: scale jump
  from 112 pt to 8.8 pt, standfirst, pull-quote, back matter.
- **From the market:** no sidebar, no photo circle, no icons, no bars, nothing
  centred. It reads as a publication, not a form. Market galleries checked
  (vendor marketing): https://enhancv.com/resume-templates/ (sidebars, photos,
  skill bars, section icons) and https://novoresume.com/resume-templates
  ("rating styles" for skills, "creative backgrounds").

## Fonts and licences

- **Instrument Serif** (Regular, Italic), SIL OFL 1.1: display, pull-quote,
  company headings. `fonts/InstrumentSerif-*.ttf`, licence
  `fonts/OFL-InstrumentSerif.txt`.
- **Newsreader** (variable, optical size 6-72, weight 200-800), Production Type,
  SIL OFL 1.1: text, standfirst, labels. `fonts/Newsreader*.ttf`, licence
  `fonts/OFL-Newsreader.txt`. Typst registers it as `"Newsreader 16pt"` (the
  variable font's default instance name); a theme must use that string.
- Both from the Google Fonts repository, unmodified.

## Data it needs

All from the marine candidate schema: `identity.name` and `identity.rank`,
`contacts`, `profile` (it becomes the standfirst, verbatim), `companies` with
groups, ships, ranks and months, `certificates` (all four fields),
`education_entries`, `language_entries`.

- The name is title-cased from the upper-case record for the headline. That is
  wrong for names like "McDonald" or "van der Berg": a template needs a
  `display-name` field, or records stored in natural case.
- The pull-quote total is the sum of vessel months from the record; years are
  that total divided by 12. With hidden durations, `service-months` would feed
  the total and the leaders would end without a number.
- Rank is written once per vessel-type group ("Product tankers · Master"),
  listing every rank in that group; ranks are not repeated per vessel.

## What it would take to become a template

- Components: headline (kicker + name), standfirst with contact byline,
  contents list (a two-column split that never breaks inside a company; the
  mock-up picks the split point that balances the columns), pull-quote, fact
  file, certificate register, folio.
- Theme tokens: `ink`, `muted`, `accent`, `panel`, display and body fonts;
  add both families to `packages/cv-engine/fonts/`.
- **Headline size is a page-plan value, not automatic**: the constitution
  forbids automatic shrinking, so a long name needs a smaller size chosen by
  hand, plus an overflow check that fails loudly (the mock-up has none).
- Words (Sea service, months at sea, Certificates & endorsements) come from the
  domain copy; the travel variant shows the render function holds none of them.
- Careers above about 30 vessels need a continuation page with a running head.
- Keep the contents list and the pull-quote dominant in any template: they
  carry the facts. Headline, standfirst and fact file frame them and should
  never grow at their expense.
- Company headings keep name and period on one line when both fit; otherwise
  the period drops to its own line below the name (measured, not guessed).

## Open weaknesses

- The rank sits in a small kicker above the name; a recruiter sees it, but it
  is not large.
- No portrait slot. A rectangular photo could sit at the head of the right
  column if a client wants one; not drawn.
- The standfirst is the candidate's own profile; a weak profile weakens the
  page more here than in any other concept.

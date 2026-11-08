# Candidate schema (marine domain)

Read this when editing a marine candidate JSON. This is the marine domain's
facts contract (ADR 0011); another domain defines its own. Machine-checkable
version: `packages/domains/marine/schema/candidate.schema.json`
(candidate facts; the Flagship input refers to it and closes `copy`, see
`packages/domains/marine/templates/flagship/schema/flagship-input.schema.json`).
Runtime checks: `validate-candidate` in `packages/domains/marine/data.typ`,
which runs the domain-neutral `validate-common` from `packages/cv-framework/core/data.typ`
first (identity name, contacts, certificates, education, languages) and then the
marine rules (rank, companies, vessels, months).

Top-level shape. Required keys are `identity` and `companies`.

```json
{
  "identity":          { "name": "ALEX MORGAN", "rank": "SECOND ENGINEER",
                         "portrait": "/examples/candidates/fictional-engineer.png",
                         "portrait-alt": "AI-generated portrait" },
  "contacts":          { "left":  [ { "label": "Based in", "value": "Rotterdam, Netherlands" } ],
                         "right": [ { "label": "Email", "value": "a@example.com", "href": "mailto:a@example.com" } ] },
  "profile":           "Two or three sentences shown beside the vessel illustration.",
  "companies":         [ { "id": "northline", "name": "Northline Marine", "period": "2022 - 2026",
                           "groups": [ { "type": "Product tankers",
                                         "ships": [ { "id": "meridian", "name": "MV Meridian",
                                                      "rank": "Second Engineer", "months": 8 } ] } ] } ],
  "certificates":      [ ["Certificate of Competency", "Second Engineer / III/2", "15 Jul 2024", "14 Jul 2029"],
                         { "title": "...", "scope": "...", "issued": "...", "review": "..." } ],
  "education_entries": [ { "qualification": "Diploma in Marine Engineering",
                           "institution": "Merchant Marine Academy", "note": "optional" } ],
  "language_entries":  [ { "name": "Greek", "level": "Native" } ],
  "skill_groups":      [ ["Passage planning", "Cargo watch"], ["ECDIS"] ],
  "domainContract":    1,
  "disclosure":        "footer text; defaults to the fictional-example line, so a real CV sets it"
}
```

This is the candidate-facts record: what is true about the person, with no
template wording. The facts schema accepts an optional `copy` object without
checking its keys; the Flagship input schema is the same record with those keys
checked, and its adapter produces the Flagship input (see "Flagship wording"
below).

## Field notes

- **identity.portrait** is a path from the project root, or `null` for no
  photo. For a real person use the prepared portrait inside the candidate's
  folder, `/private/<candidate-folder>/images/portrait/portrait.png`, which
  `scripts/portrait.py prepare` writes from the photograph
  (`docs/guides/client-workflow.md`, section 1, "The portrait"); the workflow
  (`scripts/cv.py render`) also accepts a path relative to that folder and
  repoints the revision's snapshot at its own copy of the file.
- **contacts** are ordered. Remove an entry to hide it. `href` is optional
  and makes the value a link. Every value must fit `layout.hero.contacts-width`
  or the hero fails with a message.
- **companies[].id** is optional and defaults to the lower-cased name with
  spaces replaced by hyphens. Ids must be unique.
- **companies[].period** is display text. It is never parsed.
- **companies[].service-months** is the company total. Use it when
  per-vessel months are unknown, together with hidden durations. If every
  vessel also has `months`, the two must agree.
- **ships[].id** stays the same when the same vessel appears again under
  another rank or company. It counts once in the vessel total; months add.
- **ships[].months** are whole service months. Required when durations are
  shown, unless the vessel has a period.
- **ships[].period** is one contract's dates as display text, such as
  `03/2021 - 11/2021`, for a deck career recorded as contracts. It replaces
  `months` and `service-months`: every vessel of the record has a period or none
  does, and a mixed record fails the render. The same `id` on two rows is two
  contracts on one vessel; the same vessel, rank and period twice is refused. Each
  company then shows its contract count, and the synopsis counts contracts,
  vessels and companies. Periods cannot be hidden: `show-vessel-durations: false`
  refuses them. Never convert calendar periods into months (constitution
  section 6).
- **ships[].tonnage**, **ships[].engine**, **ships[].power** are optional
  vessel particulars: `"tonnage": { "value": 49990, "unit": "GT" }` (or
  `"DWT"`), `"engine": "MAN B&W"` (the maker), `"power": { "value": 9480,
  "unit": "kW" }` (or `"BHP"`). Values are whole numbers in the unit the
  candidate's documents use; they are printed as given and never converted.
  Flagship shows them after the vessel name on the same row
  ("MV Meridian · 49,990 GT · MAN B&W · 9,480 kW"); a vessel without them
  renders as before. A name plus particulars too wide for the row fails the
  render: leave out one particular for that vessel. A vessel that appears
  twice (same `id`) must state the same values or omit them.
- **domainContract** is the `Domain Contract` version the record follows;
  without it, version 1 (`template-contract.md`).
- **skill_groups** is one list of skills per column, text only. Flagship places
  them on the page whose plan has `skills: true`
  (`layout-and-pagination.md`).
- **certificates** accept either a four-string array in the order title,
  scope, issued, review, or an object with those keys, where `review` may be
  left out. With no `review` on any record, Flagship draws three columns; give
  it on all or none. Write an expiry
  (`review`) like `14 Jul 2029` to have it checked at render (`Certificate
  Warning`); free text such as `As required` is allowed and only counted.
- **education_entries[].note** is optional and renders small under the
  institution.

## Wording

Headings, captions and the footer brand are template input, not candidate
facts. The domain's words come from the marine domain
(`packages/domains/marine/domain.typ`, `domain.copy`):

```text
experience-subtitle   "Company / vessel type / vessel"
continuation          "Continued / earlier companies"
combined              "Combined service"
total                 "Total experience"
vessels               "Vessels"
contract, contracts   "Contract", "Contracts"
companies             "Companies"
vessel                "Vessel"     (the synopsis uses it when the total is one)
company               "Company"    (the same, for companies)
```

Override a singular and its plural together: a `copy` that sets only
`companies` still shows the domain's "Company" for a total of one.

The design's words come from Flagship's adapter
(`packages/domains/marine/templates/flagship/adapter/adapter.typ`, `flagship-copy`):

```text
experience            "Experience"
certificates          "Certificates & endorsements"
certificates-subtitle "Illustrative register - dates and credentials are fictional"
certificate-columns   ["Certificate", "Scope / record", "Issued", "Expires / review"]
education-languages   "Education & languages"
education             "Education"
languages             "Languages"
skills                "Professional skills"
page-caption          "EXPERIENCE / CREDENTIALS"
brand                 "FLAGSHIP"
```

To change any of them, pass only the keys you change; the adapter merges
them over the defaults. Preferred: the `copy` argument of `flagship`, for
example `flagship.with(..., copy: (brand: "GOLDEN BLUE"))`. Legacy: a `copy`
key inside the record, which the adapter also merges. The facts contract
accepts any `copy` object; `flagship-input.schema.json` checks its keys.
Merge order is domain, then role, then Flagship, then the record's `copy`,
then the argument; later wins (see `docs/engine/domains-and-roles.md`).
A role can only override the domain's words.

## Errors you will see

`scripts/cv.py render` first checks the record against the Flagship input
schema (this file's facts plus `copy`) and refuses with exit 2 before
anything is written, listing the problems with their field paths (the first
ten, then a count of the rest), for
example:

```text
REFUSED: candidate.json does not match /packages/domains/marine/templates/flagship/schema/flagship-input.schema.json:
  (top level): Additional properties are not allowed ('educaton_entries' was unexpected)
  certificates/0: 'issued' is a required property
  companies/0/groups/0/ships/1/months: is null; give a value, or leave the key out if it is optional
```

Fix the named field and render again. The engine's own checks below run
after that, during compilation, for what a schema cannot express.

| Message | Fix |
|---|---|
| `Candidate requires identity` or `... companies` | Add the missing top-level key |
| `Visible vessel durations require months: <ship>` | Add `months`, or hide durations and give `service-months` |
| `Company service-months does not match vessel months` | Make the total equal the sum |
| `Every vessel needs a contract period, or none does: <company>` | Give each row a `period`, or use `months` throughout |
| `A contract period replaces months; give one or the other: <company>` | Remove `months` or `service-months` from that company |
| `A record uses contract periods or service months, not both` | Use one way of recording service across the record |
| `Every certificate needs a review date, or none does` | Give `review` on all certificates or on none |
| `Skills need exactly one page with skills: true in the page plan` | Add `skills: true` to one page of the layout's plan |
| `Contract periods cannot be hidden; show vessel durations: <ship>` | Leave durations on for a record of periods |
| `A contract is listed twice: same vessel, rank and period` | Remove the duplicate, or give each contract its own dates |
| `certificate-columns needs <n> headings for these certificates` | Give a heading for each column: three, or four with `review` |
| `Known vessel months exceed company total` | With partial vessel months, the company total must be at least their sum |
| `Missing months: provide service-months for company <name>` | Durations hidden but neither every vessel's `months` nor a company `service-months` is given |
| `Rank exceeds identity plate` | Shorter rank, smaller `theme.sizes.rank`, or wider `layout.hero.plate-width` |
| `Contact group is too tall for the hero` | Fewer contact entries on that side, or smaller `layout.hero.contacts-gap` |
| `Company IDs must be unique` | Give the second company a different `id` |
| `Name exceeds identity plate` | Shorter name, smaller `theme.sizes.name`, or wider `layout.hero.plate-width` |
| `Contact exceeds hero column` | Shorter value or wider `layout.hero.contacts-width` |
| `Vessel <id> repeats with a different <tonnage/engine/power>` | A vessel listed twice states the same particulars both times, or leaves them out on one |
| `vessel.<tonnage/power>.unit must be one of ...` | Use `GT` or `DWT` for tonnage, `kW` or `BHP` for power, as the documents say; never convert |
| `vessel.<tonnage/power> needs exactly value and unit` or `... value must be a positive whole number` | Give `{ "value": 9480, "unit": "kW" }` with a whole number |
| `Vessel particulars do not fit on one row: <ship>` | Leave out one particular for that vessel (no shrinking) |

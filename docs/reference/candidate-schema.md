# Candidate schema

Read this when editing a candidate JSON. Machine-checkable version:
`packages/cv-engine/schema/candidate.schema.json` (candidate facts; the Flagship input adds
`copy`, see `packages/cv-engine/templates/flagship/schema/flagship-input.schema.json`).
Runtime checks: `validate-candidate` in `packages/cv-engine/core/data.typ`.

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
  "disclosure":        "optional footer text"
}
```

This is the candidate-facts record: what is true about the person, with no
template wording. The Flagship template reads a slightly wider shape, the
Flagship input, which is the same record plus an optional `copy` key; its
adapter produces it (see "Flagship wording" below).

## Field notes

- **identity.portrait** is a path from the project root, or `null` for no
  photo. For a real person use the path inside the candidate's folder,
  `/private/<candidate-folder>/portrait.<ext>`, jpg or png.
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
  shown.
- **Contract periods are not supported yet.** Deck careers are usually
  recorded as one date range per contract, not as service months. There is
  no per-contract field (`companies[].period` is company-level display
  text), and the synopsis counts months, vessels and companies.
  This is roadmap item one in `docs/vision.md` (ADR 0007). Until it lands, a
  deck CV with contract periods uses the custom-composition path in
  `docs/guides/build-a-cv.md`, section 7. Do not convert calendar periods
  into months to make the data fit; constitution section 6 forbids it.
- **certificates** accept either a four-string array in the order title,
  scope, issued, review, or an object with those keys.
- **education_entries[].note** is optional and renders small under the
  institution.
## Flagship wording

Headings, captions and the footer brand are Flagship input, not candidate
facts. Their defaults live in
`packages/cv-engine/templates/flagship/adapter/adapter.typ` (`flagship-copy`):

```text
experience            "Experience"
experience-subtitle   "Company / vessel type / vessel"
continuation          "Continued / earlier companies"
combined              "Combined service"
total                 "Total experience"
vessels               "Vessels"
companies             "Companies"
certificates          "Certificates & endorsements"
certificates-subtitle "Illustrative register - dates and credentials are fictional"
certificate-columns   ["Certificate", "Scope / record", "Issued", "Expires / review"]
education-languages   "Education & languages"
education             "Education"
languages             "Languages"
page-caption          "EXPERIENCE / CREDENTIALS"
brand                 "FLAGSHIP"
```

To change any of them, pass only the keys you change; the adapter merges
them over the defaults. Preferred: the `copy` argument of `flagship`, for
example `flagship.with(..., copy: (brand: "GOLDEN BLUE"))`. Legacy: a `copy`
key inside the record, which the adapter also merges, but such a record only
validates against `flagship-input.schema.json`, not the facts contract.
Merge order is defaults, then the record's `copy`, then the argument.

## Errors you will see

| Message | Fix |
|---|---|
| `Candidate requires identity` or `... companies` | Add the missing top-level key |
| `Visible vessel durations require months: <ship>` | Add `months`, or hide durations and give `service-months` |
| `Company service-months does not match vessel months` | Make the total equal the sum |
| `Known vessel months exceed company total` | With partial vessel months, the company total must be at least their sum |
| `Missing months: provide service-months for company <name>` | Durations hidden but neither every vessel's `months` nor a company `service-months` is given |
| `Rank exceeds identity plate` | Shorter rank, smaller `theme.sizes.rank`, or wider `layout.hero.plate-width` |
| `Contact group is too tall for the hero` | Fewer contact entries on that side, or smaller `layout.hero.contacts-gap` |
| `Company IDs must be unique` | Give the second company a different `id` |
| `Name exceeds identity plate` | Shorter name, smaller `theme.sizes.name`, or wider `layout.hero.plate-width` |
| `Contact exceeds hero column` | Shorter value or wider `layout.hero.contacts-width` |

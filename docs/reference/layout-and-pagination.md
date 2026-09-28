# Layout and pagination

Read this when a page is out of balance, content overflows, or a new
candidate needs a different page split. The geometry lives in the layout
profiles under `packages/domains/marine/templates/flagship/layouts/`, page plan validation in `packages/cv-framework/core/pagination.typ`,
and the overflow check in the page loop of `packages/domains/marine/templates/flagship/flagship.typ`.

## Choosing a profile

Flagship has two profiles. The agent or owner picks one per candidate;
nothing switches automatically.

| Profile | For | Page plan |
|---|---|---|
| `flagship-one-page.typ` | A cadet or junior officer whose record passes the capacity rule below, one page | Built from the record: `one-page(candidate)` |
| `flagship-v11.typ` | Everything else, from about four companies up: two pages or more | Written for six companies; any other count needs a `pages` override (below) |

Capacity rule, measured on the deck cadet record (a three-line profile,
one education entry, two languages): count 3 per company, 1 per vessel
row and 1 per certificate row. A total of 14 or less fits one page (two
companies, three vessels and five certificates; one company, one vessel
and ten certificates); 15 may fit; 16 or more did not in any
measured case. A longer profile
text or more education lowers it. The render decides: if a record
overflows the one-page profile, move to `flagship-v11.typ` with a
two-page `pages` override; never shrink type to make it fit.

The one-page profile is the v11 geometry with tighter vertical gaps in
the upper half (hero flow 5mm shorter, company and row gaps, the
Experience heading, certificate rows, synopsis and language boxes); the
hero band, its artwork, the margins (so the footer sits where v11 puts
it) and every type size are unchanged. It sets `spread: true`: the page
loop shares the free space equally above the certificates and above
education, each keeping its heading gap as a minimum, so a thin record
has two even gaps rather than one hole. Its `one-page` function returns
the profile with one page that lists every company and closes with the
synopsis, certificates and education, so it serves one, two or three
companies without an override:

```typst
#import "/packages/domains/marine/templates/flagship/layouts/flagship-one-page.typ": one-page
#let candidate = json("candidate.json")
#show: flagship.with(candidate: candidate, /* role, theme, artwork */ layout: one-page(candidate))
```

`examples/marine/flagship/deck-cadet.typ` is the working example. The
profile's own `layout` (without the function) plans three companies.

## The layout profile

`flagship-v11.typ` holds every geometric decision of the approved
design: paper size, opening and continuation margins, a spacing scale, and a
dictionary per component (`hero`, `experience`, `headings`, `profile`,
`synopsis`, `certificates`, `education`, `footer`, `header`). The template
passes the whole profile in `ctx.layout`; each component reads its own
slice, and a section reads the heading slice it places as well. An optional
`skills` slice overrides `skills-layout` for the skills block. Change a
value here and every example follows.

For one CV, prefer a small override in the entry point over a new file:

```typst
#import "/packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout as base
#let layout = (..base, pages: (
  (companies: (0, 1, 2)),
  (companies: (3, 4)),
  (companies: (5,), synopsis: true, certificates: true, education: true),
))
```

## The page plan

`pages` is an array, one entry per page. Each entry lists company indices
(zero-based, in candidate order) and flags for the sections that close the
document.

```typst
pages: (
  (companies: (0, 1, 2)),
  (companies: (3, 4, 5), synopsis: true, certificates: true, education: true),
)
```

Rules enforced by `validate-pages`:

- Every vessel row appears exactly once, in candidate order.
- Exactly one page has `synopsis: true`, and it is the last page with
  companies.
- `certificates` and `education` appear at most once, on or after that page.
  They are required when the candidate has that content.

## Splitting a large company

Replace the index with a fragment descriptor. Row indices count every vessel
of the company across its groups, end exclusive.

```typst
(companies: ((company: 0, rows: (0, 6)),)),
(companies: ((company: 0, rows: (6, 14)), 1, 2)),
```

The second fragment renders the company name with "(continued)". Company
duration and totals are unchanged because they come from the full candidate.
`tests/fixtures/pagination.typ` is a working three-page example.

## anchor-education and spread

When `anchor-education` is `true`, the template inserts flexible space
before the education section so it sits at the bottom of its page. Set
`false` for a compact finish. `spread: true` (default `false`) adds a
second, equal flexible space before the certificates and restates both
heading gaps as minimums; the one-page profile uses it.

## When something does not fit

| Message | Meaning | Fix |
|---|---|---|
| `Page plan company index out of bounds` | The plan names a company index the candidate does not have. The v11 plan assumes six | Write a `pages` override listing the candidate's own company indices, or use `one-page(candidate)` for a short record |
| `Content overflow on planned page N` | The page spilled onto an unplanned page | Move a company to the next page, split it with row ranges, or add a page. On the one-page profile: switch to `flagship-v11.typ` with a two-page override |
| `Page plan must cover each vessel row once` | A company or row range is missing or duplicated | Check indices against candidate order |
| `Synopsis must follow the final Experience page` | Flag on the wrong page | Move `synopsis: true` |
| `Missing page assignment: certificates` | The candidate has certificates but no page shows them | Add the flag to the last page |
| `Page plan requires exactly one synopsis` | No page, or more than one page, sets `synopsis: true` | Set it on exactly one page |
| `Credentials must follow Experience` | Certificates or education are placed before the last Experience page | Move the flag to that page or a later one |
| `Section assigned more than once: <key>` | Two pages set the same section flag | Keep the flag on one page |
| `Page plan vessel row range out of bounds` | A row range `(start, end)` exceeds the company's vessel rows | Use `0 <= start < end <= row count` |
| `Page plan cannot be empty` | `pages` is an empty array | List at least one page |
| `Row range must contain two integer indices` | A row range is not a pair of integers | Write it as `(start, end)` |
| `Experience requires at least one vessel` | The candidate has no vessel rows at all | Add at least one company with a vessel to `candidate.json` and list it in `pages` |

The system never shrinks fonts to fit. The certificate table repeats its
header when it continues onto another page.

## Visual check

After any plan change, compile and look at every page. The suite proves the
plan is consistent, not that it is beautiful.

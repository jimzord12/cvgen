# Layout and pagination

Read this when a page is out of balance, content overflows, or a new
candidate needs a different page split. The geometry lives in
`packages/cv-engine/domains/marine/templates/flagship/layouts/flagship-v11.typ`, page plan validation in `packages/cv-engine/core/pagination.typ`,
and the overflow check in the page loop of `packages/cv-engine/domains/marine/templates/flagship/flagship.typ`.

## The layout profile

`flagship-v11.typ` holds every geometric decision of the approved
design: paper size, opening and continuation margins, a spacing scale, and a
dictionary per component (`hero`, `experience`, `headings`, `profile`,
`synopsis`, `certificates`, `education`, `footer`, `header`). Components
receive only their own slice (the certificates and education sections are
the exception and get the whole `layout`). Change a value here and every
example follows.

For one CV, prefer a small override in the entry point over a new file:

```typst
#import "/packages/cv-engine/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout as base
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

## anchor-education

When `true`, the template inserts flexible space before the education
section so it sits at the bottom of its page. Set `false` for a compact
finish.

## When something does not fit

| Message | Meaning | Fix |
|---|---|---|
| `Page plan company index out of bounds` | The plan names a company index the candidate does not have. The default plan assumes six | Write a `pages` override listing the candidate's own company indices |
| `Content overflow on planned page N` | The page spilled onto an unplanned page | Move a company to the next page, split it with row ranges, or add a page |
| `Page plan must cover each vessel row once` | A company or row range is missing or duplicated | Check indices against candidate order |
| `Synopsis must follow the final Experience page` | Flag on the wrong page | Move `synopsis: true` |
| `Missing page assignment: certificates` | The candidate has certificates but no page shows them | Add the flag to the last page |
| `Page plan requires exactly one synopsis` | No page, or more than one page, sets `synopsis: true` | Set it on exactly one page |
| `Credentials must follow Experience` | Certificates or education are placed before the last Experience page | Move the flag to that page or a later one |
| `Section assigned more than once: <key>` | Two pages set the same section flag | Keep the flag on one page |
| `Page plan vessel row range out of bounds` | A row range `(start, end)` exceeds the company's vessel rows | Use `0 <= start < end <= row count` |
| `Page plan cannot be empty` | `pages` is an empty array | List at least one page |

The system never shrinks fonts to fit. The certificate table repeats its
header when it continues onto another page.

## Visual check

After any plan change, compile and look at every page. The suite proves the
plan is consistent, not that it is beautiful.

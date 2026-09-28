---
kind: proposal
status: approved
revision: 1
---

# Short-career layout: a one-page profile for cadets and juniors

Origin: roadmap item 6 in [the vision](../vision.md); the owner asked on
2026-09-25 for roadmap cards for it. Drafted on the night of 2026-09-28.

**Pitch:** a one-page `Layout` for Flagship, so a cadet or junior
officer with two or three vessels gets a full, confident page instead of a
thin two-page CV.

## Problem

Flagship is planned for two pages: its only layout profile,
`flagship-v11.typ`, puts three companies on page 1 and three more plus the
synopsis, certificates and education on page 2, sized for a long career. A
cadet with one company and three vessels fills only a small part of that
(not measured yet; the first step renders one to show it). The
result looks empty, which reads as "little experience" before the reader
has seen a single fact. Juniors are also the clients most likely to be
applying widely and most in need of a CV that looks professional.

## Who it helps

- **Cadets and junior officers** (deck and engine): a single page that looks
  deliberate, not short.
- **Crewing officers** reading many junior CVs: everything on one page.
- **The owner:** a product for the start of a career, not only for senior
  officers.

## Smallest suggested change

1. A second layout profile under
   `packages/domains/marine/templates/flagship/layouts/`, for example
   `flagship-one-page.typ`: one page, the same sections, geometry tuned so a
   short record fills the page (larger gaps, the hero and the experience
   given more room). It changes geometry and the page plan only, never type
   sizes (constitution rule 4: no shrinking), and overflow fails loudly as
   today.
2. One fictional cadet example candidate plus an entry point under
   `examples/marine/flagship/`, compiled in the suite with a one-page check.
3. `docs/reference/layout-and-pagination.md`: when to choose which profile.

Out of scope: an automatic switch between one and two pages (the agent or
owner chooses the profile per candidate), other templates (each future
template adds its own profile), and a separate cadet design.

## Consequence

- Small: one layout file, one example, one suite case. The engineer example
  and its frozen v11 reference are untouched, because the new profile is a
  separate file.
- Whether the one-page example also gets a frozen reference is the owner's
  call (recommended: yes, once he approves its look, as a public example).

## Recommendation

Approve after the travel domain, or before it if a junior client arrives
first: it is the smaller job and directly sellable.

## Decision requested

Approve, defer or reject revision 1.

## Decisions

- 2026-09-28, owner, in session: revision 1 approved ("I do get the
  Short-career layout and I do approve it"). Card short-career-layout.

## Correction for the implementer (2026-09-28, from review)

The Problem section describes today's behaviour loosely. In fact the
`flagship-v11.typ` page plan fails outright for fewer than six companies
("Page plan company index out of bounds", `core/pagination.typ`), and the
documented per-CV `pages` override (`docs/reference/layout-and-pagination.md`)
can already put a short record on one page with the v11 geometry. The real
gap is geometry tuned so a short record fills one page. A layout profile's
`pages` lists company indices, so the profile alone cannot serve records
with one, two or three companies: the implementation must also give the
page plan for those records (for example a per-CV `pages` override the
profile documents, or a plan built from the company count). The approved
scope (one layout, one fictional cadet example, one suite case, no
shrinking) stands.

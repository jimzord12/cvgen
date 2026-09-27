---
kind: proposal
status: pending
revision: 1
---

# Travel and tourism: the first non-marine domain

Origin: roadmap item 2 in [the vision](../vision.md); the owner asked on
2026-09-25 for roadmap cards for it. Drafted on the night of 2026-09-28.

**Pitch:** a `Travel & Tourism` `Domain` (folder `travel`) beside `Marine`, with its own facts shape and
one template, so a tour guide's CV runs through the Framework and
`scripts/cv.py` like a marine one, instead of as a one-off.

## Problem

Today only seafarers fit the product. A client from any other field, a tour
guide being the first expected one, gets a one-off `Template` hand-built in
their `Envelope` ([framework gap of 2026-09-25](../framework-gaps.md), "A
client whose domain does not exist yet"). That works once, but every such
client costs a full custom design, has no schema to catch typos, and teaches
the library nothing. The vision names travel and tourism as the next field,
and as the proof that the domain split of ADR 0011 and ADR 0012 actually
works: a second domain added without touching marine or the core.

## Who it helps

- **Tour guides, tour leaders, hotel and hospitality staff:** a premium CV
  shaped for their field (licences, languages, destinations, guest numbers,
  ratings), not a seafarer's shape bent to fit.
- **The owner:** a second product line with the same workflow (render,
  approve, export), no hand-built template per client.
- **The codebase:** the first real test that a domain can be added beside
  `marine` with the core untouched (`check_core_boundary()` in the suite).

## Smallest suggested change

1. `packages/domains/travel/`: `domain.typ` (id, meta, wording), `data.typ`
   (normalise and validate), `lib.typ` (the import surface), and
   `schema/candidate.schema.json`. The facts shape, kept small: identity,
   contacts, profile, licences (issuer, number, valid until), languages
   (with level), experience as roles (employer, title, period, places,
   highlights with numbers), education, certificates. Periods are printed
   as documented, never converted into service time (constitution rule).
2. One template, `packages/domains/travel/templates/<name>/`: two pages by
   default, its own theme and layout profile, reusing the Framework's page
   shell, pagination and ctx-first components; no artwork pack at first.
3. One fictional example candidate and entry point under `examples/`, a
   frozen reference PDF under the template's `tests/approved/`, and its
   hashes in `tests/baseline.json` (rule 1).
4. Docs: the domain added to `AGENTS.md`'s map and to
   `docs/reference/domains-and-roles.md`; the framework gap above closed.

Out of scope for the first version: roles inside travel (guide versus
hotel), more than one template, artwork, a second language of wording.

## Consequence

- About the size of the domains move (roadmap item 1): a few days of agent
  work plus one design round for the template's look, which the owner
  approves before its frozen reference is taken.
- Marine is untouched: the engineer example must stay pixel-identical to
  v11, and the suite already refuses a core file that imports a domain.
- Every future field (software, hospitality, health) follows the same path,
  so the cost of the second domain is partly paid for all later ones.

## Open questions for the owner

- **Look:** reuse one of the three new `Text Draft` or idea-run directions as
  the template's starting point, or brief the `magazine-editor` for a travel
  concept first (recommended: an `Idea Run` first, as with the `Text Draft`).
- **Scope of "travel":** guides only first, or hotel and hospitality staff
  too (recommended: guides only; hospitality becomes a role later).

## Recommendation

Approve, with an `Idea Run` for the template's look as the first step. It is
roadmap item 2 and the next real test of the architecture. Deck data support
(item 3) is independent and can run before or after it.

## Decision requested

Approve, defer or reject revision 1; answer the two open questions.

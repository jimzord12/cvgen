---
kind: proposal
status: deferred
revision: 2
---

# Travel and tourism: promote the first one-off into a Domain

Origin: roadmap item 2 in [the vision](../vision.md); the owner asked on
2026-09-25 for roadmap cards for it. Revision 1 (night of 2026-09-28)
proposed building the `Travel & Tourism` `Domain` up front from fictional
data; revision 2 (2026-09-28, owner's process) builds it from the first
real client's one-off CV instead.

**Pitch:** do not design the second `Domain` in advance. When the first
Travel & Tourism client arrives, deliver a one-off CV; then turn that proven
one-off into the `Domain` and its first `Template`.

## Problem

Today CVgen only knows seafarers: its facts shape is companies, vessels,
months at sea, ranks and sea certificates. A tour guide's CV needs other
facts (licences, guiding languages, employers, tours, guest numbers and
ratings). Building a whole `Domain` before any such client exists means
guessing what a guide's CV needs; building a one-off for every guide means
paying for a full custom design each time, with no schema to catch typos.

## The process (owner, 2026-09-28)

1. **A client of a new type arrives** (here: Travel & Tourism).
2. **No `Domain` supports it yet:** research the field and deliver a
   one-off CV. This step exists today: `docs/guides/client-workflow.md`
   and the `new-client` skill build a one-off `Template` in the client's
   `Envelope` (importing only the `Framework`) and record a
   `Framework Gap`.
3. **Study the one-off and create a `Template` from it:** a
   `packages/domains/travel/` `Domain` (facts shape, schema, wording) and
   its first `Template`. Its public example and frozen reference use a
   **fictional twin**: an invented guide modelled on the real client,
   because public content is fictional (constitution); the real client's
   data never leaves `private/`.
4. **Audit and extend lightly:** review it (the `code-reviewer`, the
   `design-reviewer`), research where the one-off guessed, split it into
   components, and record ideas for extension. Build only what the next
   client needs.

Steps 3 and 4 are one task, started after the first client's one-off is
signed off; the second Travel & Tourism client then validates the
`Template`.

## Consequence

- Nothing is built now. The first travel client costs a one-off (as any
  new field does today); every later one runs through the `Domain`.
- The `Template` reflects a real, delivered CV instead of a guess.
- Marine is untouched: the engineer example stays pixel-identical to v11,
  and the suite refuses a core file that imports a `Domain`.
- The same process applies to every later field (hotel staff, software,
  health).

## Revisit condition

Return to `pending` (or open the build task directly) when the first
Travel & Tourism client's one-off CV has its `Sign-off`. Card
travel-domain stays Queued with this trigger.

## Decisions

- 2026-09-28, owner, in session: revision 1 not approved as written; the
  owner set out the process above ("A type of client comes in… do
  research, create a one-off CV… study the one-off CV, create a template
  out of it… do auditing, maybe more research, decompose it into
  components, think of ways to extend it"). Revision 2 records it and is
  **deferred** until the revisit condition ("yes, rewrite and defer it").

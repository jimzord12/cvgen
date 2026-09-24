---
kind: proposal
status: pending
revision: 1
---

# Candidate intake questionnaire

Origin: ceo agent run 2026-09-25 ([run record](../work/idea-runs/2026-09-25-ceo/run.md)).

**Pitch:** one intake questionnaire that collects every fact the CV needs,
in the form the record needs it, before a client's CV is started: marine
now if the first client is marine, travel and tourism with item 2
otherwise. The paper precursor of item 8's hosted intake.

## Problem

A first real client is waiting. The guide for producing a real CV
(`docs/guides/build-a-cv.md`) starts at "fill the data": it assumes the
operator already holds every fact. In practice the facts arrive as a seaman's
book, an old CV and emails, and a missing fact shows up only when the record
is filled or the page is composed:

- months per vessel are required when durations are shown, and CVgen never
  converts calendar dates into service time (constitution section 6), so a
  missing month count means going back to the candidate or hiding
  durations;
- crew managers ask for facts CVgen does not collect today, such as
  tonnage and engine power per vessel and valid visas (Marlow, run record
  item 1);
- a need the template cannot hold yet (for example a career recorded as
  contract periods, `docs/framework-gaps.md`) is a template limit, not a
  missing fact, and a questionnaire does not remove it. It does surface it
  before composing starts, so the bypass or the wait for item 3 is planned
  instead of found at layout time.

The paid services checked (TopResume, The Writique) start with a
questionnaire: TopResume before a writer is assigned, The Writique after
payment (run record items 8 and 9); a vendor ranking reports some premium
services use an intake call instead (item 10, opinion).
CVgen has no intake at all.

## Who it helps

- **The owner**, running the first paid engagement: one message to the
  client, one set of answers, no round trips at layout time.
- **The client**: answers once, in their own terms, with an example beside
  each question, instead of a string of follow-up emails.
- **The agent building the CV**: converts answers into the record field by
  field and returns a short list of gaps instead of guessing.

## Evidence

Run record items 1 (what crew managers require), 8 and 9 (paid services'
own descriptions of their questionnaire intake), 10 (vendor opinion,
supporting only), 16 and 17 (facts the CV shows or omits). In-house: the
months rule (constitution section 6) and the build guide, which has no step
that gathers facts from the candidate.

## Smallest suggested change

1. `docs/guides/intake-marine.md`: a questionnaire in plain English, in
   the order of the CV, each question with a fictional example answer:
   identity and rank; which contacts to show; two or three facts for the
   profile; per company, each vessel with type, rank and **whole months on
   board** (or the company total if months are unknown, with the
   consequence stated: durations will be hidden); certificates with issued
   and expiry dates in `DD Mon YYYY`; education; languages with level;
   valid visas (for example "US C1/D, until 12 Mar 2029", mapped to a
   "Visas" entry in the contacts list); whether any service was recorded
   as contract dates only (so a template limit is known before
   composing); a portrait with written permission. Optional block: tonnage and engine
   power per vessel with the unit on the candidate's documents (GT or DWT,
   kW or BHP), and engine maker (asked now because agencies ask; shown on the CV only
   if `vessel-particulars` is approved).
2. An appendix for the agent mapping each question to its field in the
   marine candidate record.
3. `docs/guides/build-a-cv.md` gains a step 0: send the questionnaire,
   store the answers under `private/<candidate>/sources/` (the step adds
   `sources/` to the workspace tree in section 1), convert, send back the
   gap list once.

Sent by the owner as an email attachment or pasted into a message; the same
document serves as his script if he prefers a short call to email. No form
service, no web page, no new dependency. A travel and tourism version comes
with item 2, when that domain's record exists.

## Cost

About half a day of agent work, reviewed like any documentation change.
Owner time: reading the questionnaire once (5 minutes) before sending it to
the client.

## Risk

- Drift: the questionnaire can fall behind the schema. Mitigation: the
  appendix names the fields, and tonight's `candidate-validation` card
  rejects a converted record with unknown or misspelled fields.
- Real data: answers are real personal data and live only under `private/`,
  which Git ignores (constitution section 3). The questionnaire itself is
  blank and public.
- Clients may answer loosely ("about a year"). The gap list asks once; the
  rule against inventing months still holds.
- If the first client is not marine, a marine questionnaire does not serve
  them; hence the conditional slot below. The question-plus-appendix
  pattern carries over unchanged.

## Roadmap slot

Conditional on the first client's field. If that client is marine: now,
before their CV is started. Otherwise: with item 2, as the travel and
tourism questionnaire written against that domain's new record, with the
marine version following when a marine client comes. Either way it later
becomes the question list
of item 8's hosted intake form, so item 8 starts from tested questions
instead of a blank page. Not a duplicate: item 8 is the hosted web intake,
planned after the core is stable; nothing on the board, in proposals or in
the gaps log covers a questionnaire.

## Consequence

If approved: the first client engagement starts with one complete set of
facts, and the questions are proven before any web form is built. If
rejected: facts keep being gathered ad hoc, per client.

## Recommendation

Approve, and send it to the first client as soon as it exists if that client
is marine.

## Decision requested

Approve the smallest version (questionnaire with field appendix and a
step 0 in the build guide), written now if the first client is marine,
otherwise with item 2?

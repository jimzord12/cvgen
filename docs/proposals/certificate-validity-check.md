---
kind: proposal
status: pending
revision: 1
---

# Certificate dates checked at render

Origin: ceo agent run 2026-09-25 ([run record](../work/idea-runs/2026-09-25-ceo/run.md)).

**Pitch:** a CV that shows an expired certificate fails its render checks,
so it cannot be approved or exported, and one expiring within six months
gets a warning.

## Problem

Every Flagship CV prints a certificate table with an "Expires / review"
column. Nothing checks those dates. A seafarer's certificates run on a fixed
clock: a medical certificate is valid for at most two years (STCW Regulation
I/9), and officers must revalidate at intervals of at most five years
(Regulation I/11). A CV updated months after the last one can quietly show
a medical that ran out in the spring. A seafarer cannot serve without a
valid medical (I/9) or a revalidated certificate (I/11), and the crewing
officer reading the CV sees the expired date. Today that drift is silent,
against the vision's principle 4, "loud failure over silent drift": a
stale fact on a CV should stop the delivery with a message naming the fix,
as an overflowing page already does.

Today the product checks the PDF (pages, fonts, text inside the page) and,
from tonight's `candidate-validation` card, the record's shape (typos,
unknown fields). Neither looks at what a date means on the day the CV is
made.

## Who it helps

- **The owner as operator**: he approves a CV for a real client; the render
  tells him before he looks that a date on it is already past.
- **The candidate**: a warning at render ("medical expires in 4 months")
  lets them renew before applying, or state it on the CV.
- **The reader** (crewing officer; later a hotel HR desk): never sees an
  expired certificate presented as current.

## Evidence

- STCW I/9 medical validity (2 years) and I/11 five-year revalidation:
  research items 4 in the run record, primary legal text.
- Crew managers ask for certificates and valid visas with the CV (Marlow,
  26,000+ active seafarers): research items 1 and 2.
- Our own records hold dates as text in the fourth certificate field
  ("14 Jul 2029") next to free text ("As required", "See modules"): research
  item 16.

## Smallest suggested change

1. In the render workflow's checks, read the certificate list from the
   revision's snapshot record, in both shapes the schema allows: a
   four-element array (expiry is the fourth element) and an object with
   `title`, `scope`, `issued`, `review` (expiry is `review`). The
   certificate list is a common (field-neutral) fact, so the check serves
   marine now and travel and tourism later without change.
2. For each certificate whose expiry field is a date in the format the
   records already use (`DD Mon YYYY`):
   - before the render date: a check **error** naming the certificate and
     the fix ("renew and update the date, remove the row, or replace the
     date with text such as 'Renewal booked'"). The render still keeps the
     revision, as it does for any failed check; approval and export are
     refused while its checks fail, as they already are today;
   - within 180 days of the render date: a **warning**, printed by `render`
     and `status`, recorded in `checks.json`, not blocking. The 180 days
     are our judgement (enough time to book a renewal before a typical
     contract), not a sourced rule, and are one constant to change.
3. Any other text in that field is not checked; the output says how many
   certificates were not date-checked, so silence is never mistaken for a
   pass.
4. The check takes the reference date as a parameter, today by default.
   The suite's workflow case (`tests/workflow.py`) renders the fictional
   engineer record, whose medical expires 31 May 2028 and whose file is
   frozen by hash; the suite therefore passes a fixed reference date, so it
   never starts failing as the calendar moves. One added case: an expired
   date fails the checks and approval is refused, a near date warns, free
   text passes, and both certificate shapes are read.

No engine, template or frozen-reference change, and no edit to the frozen
example records.

## Cost

About half a day to one day of agent work: one function in
`packages/cv-workflow`, a `warnings` list in `checks.json`, the test case,
a paragraph in `docs/guides/build-a-cv.md`. No new dependency (Python's
standard date handling). Owner time: one minute to decide; none to run.

## Risk

- A date typed in another format (`2029-07-14`, `07/2029`) is silently
  skipped. Mitigation: the "not date-checked" count; the smallest version
  does not guess formats.
- A certificate table drawn by hand in a custom `cv.typ` (the bypass path
  in `docs/guides/build-a-cv.md` section 8) is not checked unless its rows
  also sit in the record's `certificates` list; the check reads the record,
  not the page.
- Approval happens after render. A certificate could expire between a
  render and a late approval; the check does not re-run at approval in this
  version.
- The render date makes the check time-dependent by design; it is recorded
  in `checks.json` (`checked_at` already exists). Forgetting the fixed
  reference date in the suite would make it warn from December 2027 and
  fail from June 2028; the fixed date in step 4 prevents that.

## Roadmap slot

Now, before item 2, as a small standalone task. It touches only the local
PDF workflow, not the engine, so it does not collide with tonight's
component work (item 4). It pairs naturally with the `candidate-validation`
card: that one checks the record's shape, this one checks its dates. Not a
duplicate of anything on the roadmap, the board, the proposals or
`framework-gaps.md`.

## Consequence

If approved: a real CV rendered after it lands cannot be approved or
exported while it shows a past expiry date, and dates within six months are
flagged. Nothing else changes.
If rejected: date validity stays a manual look at every render.

## Recommendation

Approve. It is the cheapest way to make certificate dates fail loudly
instead of drifting silently, and it is ready before the first real
client's CV is rendered.

## Decision requested

Approve this revision as the smallest version above (error on expired,
warning within 180 days, workflow only), to be built as a task now?

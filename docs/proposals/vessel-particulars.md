---
kind: proposal
status: pending
revision: 1
---

# Vessel particulars on the marine CV

Origin: ceo agent run 2026-09-25 ([run record](../work/idea-runs/2026-09-25-ceo/run.md)).

**Pitch:** optional tonnage, main engine maker and engine power per vessel,
shown on the experience rows, because Marlow Navigation asks every
applicant for these (in GT and kW; other agencies ask in DWT and BHP).

## Problem

A Flagship CV lists each vessel with its name, rank and months. A crewing
officer reading it cannot see how big the ship was or how powerful its
engine, and those two numbers decide what the candidate is qualified for:
STCW grades engineer certificates by propulsion power (III/2 at 3,000 kW or
more, III/3 at 750 to 3,000 kW) and deck certificates by tonnage (II/2
separates 3,000 GT or more from 500 to 3,000 GT). So the agency asks for
them anyway. Marlow Navigation, one of the large crew managers, asks every
applicant for "vessel name, type & IMO number; gross tonnage; engine
kilowatts & manufacturer (applicable for engine crew)" and accepts the
candidate's own CV only "if the essential information is documented".

A premium marine CV that omits the facts the agency asks for first sends the
candidate back to repeat them on the agency's form, and reads as less
expert than it is. The earlier design studies did carry the engine plant
("MAN B&W 6S50ME-B / 9,480 kW"); Flagship dropped it.

## Who it helps

- **Marine engineers** (the role of Flagship's frozen reference): kW and
  engine make are the numbers their certificate band depends on.
- **Deck officers**: tonnage shows which certificate band their
  service counts towards.
- **The crewing officer**: finds on the CV what the agency form would ask
  for.

## Evidence

Run record research items 1 to 3 (Marlow's application requirements and
size, STCW II/2, III/2, III/3 titles from the official convention text) and
items 17 and 18 (the studies showed the plant, Flagship does not; the
width measurement behind the same-row suffix).

## Smallest suggested change

1. Marine candidate schema: three optional fields per vessel, each keeping
   the unit the candidate's documents use, because agencies differ (Marlow
   asks GT and kW; the crewdata.com form asks DWT and BHP):
   `tonnage` (`{ "value": 49990, "unit": "GT" | "DWT" }`), `engine` (the
   maker, for example "MAN B&W" or "Wärtsilä") and `power`
   (`{ "value": 9480, "unit": "kW" | "BHP" }`). Values are printed in the
   unit given and never converted, in the spirit of the totals rule: the
   CV states the documented fact, not a derived one. The schema is closed
   to unknown fields, so they are added there and to
   `docs/reference/candidate-schema.md`. A vessel that appears twice (same
   `id`) must repeat the same values or omit them; conflicting values fail
   loudly. JSON Schema cannot compare two entries, so this rule lives in
   the marine domain's `validate-candidate` (`domains/marine/data.typ`),
   which already checks vessel ids, names and ranks; it therefore holds for
   every render, direct or through the workflow.
2. Flagship experience row: when a vessel has any particulars, a muted
   9 pt suffix after the vessel name in the same row, in the order given
   above, for example "MV North Passage · MAN B&W · 9,480 kW". Same row, so
   page length does not change. Measured on the v12 engineer PDF: the name
   column is about 208 pt wide; "MV North Passage" takes 80 pt, and the
   suffix about 90 pt, so an engineer's maker and power fit, as does a deck
   officer's tonnage. The longest name in the three examples, "MV Adriatic
   Express" (Chief Officer), measures 87 pt: with the suffix that is about
   177 of 208 pt, roughly 30 pt to spare. All three on one long name may
   not fit; then the
   render fails with a message (no shrinking, constitution section 4) and
   the fix is to leave out one field for that candidate. Full engine
   models ("6S50ME-C") are out of this version for the same reason.
3. Nothing renders when the fields are absent, so the frozen engineer
   reference and all three examples stay pixel-identical.
4. One test fixture that renders particulars (and one that fails on
   conflicting values for a repeated vessel), and one render for the owner
   to look at. No public example shows the feature: the three example
   records are frozen by hash, so a showcase would be a new fictional
   example (see the decision below).

Out of scope: flag, IMO number and sign-on/sign-off dates (the last belongs
to item 3's contract periods), and any change to totals.

## Cost

About 1.5 to 2 days of agent work: schema, the repeated-vessel check in
`validate-candidate` and its fixture (half a day),
the row suffix and its fit check (half a day to a day, after item 4 has
migrated the experience module), fixture, suite, review. No new dependency.
Owner time: one look at a rendered page to approve the look (a visual
change for every candidate who uses the fields is his decision).

## Risk

- Units differ between agencies (GT and kW at Marlow, DWT and BHP on the
  crewdata.com form, https://crewdata.com/application-form-seafarer-sea-going-experience.php?lang=eng,
  checked by the research reviewer 2026-09-25). A CV in one unit may not
  match a given agency's form; the record keeps the documented unit and
  CVgen never converts, so the candidate can hand the same figures to any
  form. Tonnage units are not convertible at all (GT measures volume, DWT
  carrying capacity).
- Width: long engine names on long vessel names may not fit one row. The
  loud failure handles it; the fix costs the operator a shortened string.
- A second visual element per row could make the experience section look
  busy. That is exactly the look decision the owner makes on the render.
- Interaction with tonight's `candidate-validation` card: that card rejects
  unknown fields, so these fields must be added to the schema it enforces,
  not bolted on.

## Roadmap slot

With item 3 (deck data support), which already reopens the marine schema
and the experience rows for contract periods; doing both together means one
schema change, one row change and one look to approve. It must come after
item 4 migrates the experience module (running tonight), or it would be
built twice. If the owner's first real client turns out to be a marine
engineer, pull this part forward ahead of item 2: it is independent of item
3's periods and is the fact that client's agency will ask for.

Not a duplicate: item 3 covers contract periods, synopsis metrics,
certificate columns and the skills slot; none of those adds vessel
particulars. Nothing in `framework-gaps.md`, the board or other proposals
covers it.

## Consequence

If approved: marine CVs can carry the size and power of every ship, in the
same two pages, and the candidate's facts match what agencies ask. Records
without the fields render exactly as today. If rejected: agencies keep
asking candidates for these facts separately.

## Recommendation

Approve, slotted with item 3, with the pull-forward rule above for a marine
engineer client.

## Decision requested

Approve the smallest version (three optional fields with the documented
unit, same-row suffix, nothing rendered when absent) in the slot with
item 3?

And one yes or no: should a new fictional public example (for instance a
second engineer record with particulars, added to the gallery in
`exports/`) showcase the feature? Recommended: no for now; the test fixture
and the render you approve are enough, and a gallery example can follow
when a client asks to see one. Yes adds about half a day.

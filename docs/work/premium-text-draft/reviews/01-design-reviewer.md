# Design review round 1: premium-text-draft (design-reviewer)

Lead's summary of the returned report (the original text was not kept).

Snapshot: eac00ec, 2026-09-28. Renders at 96, 150 and 200 dpi, 390 and
1170 px phone widths, greyscale, close-ups; stress copies (long names,
6-7 samples, longer intro, 3 content pages). Numbering continues the idea
run's D1-D18.

## The owner's four changes

- Quieter type: delivered (headline 106 to 38 pt, bold lines 24/30 to
  18/22 pt, body 21 to 16 pt; D13 stays fixed).
- Bigger, more special marker: delivered (a 20 mm copper needle with an
  eye and a thread tail).
- Generous spacing: delivered (headline, check, reply read as three
  groups; content sections 13 mm apart).
- Professional wording: delivered; Greek correct (tonos, «», ";",
  capitals without accents).

Soul kept: seam, stitch, tag and needle recognisable without the name;
greyscale works. The thread is now the weakest element.

## Findings

- **D19 Material:** the Check Page prints text over text: fixed 12 mm rows
  (a long legal company name wraps onto the next label), and the `place`d
  reply block is overprinted by extra rows or a longer intro.
- **D20 Minor:** on a phone the lines the client needs next are the
  smallest: reply-if-wrong line, "Τη διατύπωση…", the page number.
- **D21 Minor:** the knot reads as a hook or "?", not thread through the
  eyelet.
- **D22 Note:** route the thread's tail to the first needle's eye.
- **D23 Note:** a slimmer needle shaft reads more clearly as a needle.
- **D24 Note:** the fixture's page 2 should open with the stitched name,
  rank and contacts.
- **D25 Nit:** stitches end in half-dashes; `check-lang: "en"` errors.

## Verdict: FINDINGS

## Dispositions (lead)

- D19 fixed (grid rows, reply in the flow, overflow assert).
- D20 fixed (17pt, 15pt, 12pt ink; body 13pt).
- D21 fixed (a short stroke over the card's top edge).
- D22 deferred: the needle's position depends on the intro length, so a
  thread drawn in page coordinates cannot reach it reliably.
- D23 deferred to the owner's eye. D24 fixed. D25: half-dashes deferred;
  `check-lang: "en"` now fails with a message naming the missing keys.

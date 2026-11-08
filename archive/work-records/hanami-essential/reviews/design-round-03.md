# Design review round 3: Hanami `essential` (scan-first Template Variation), 2026-11-08

**Verdict: FINDINGS.** no-licence passes. The other seven renders fail on one new defect, D13: on every record with a licence, the highlights row now touches the top of the rail panel. The two Greek renders also fail on D14 (an English month inside a Greek label), and long-career-greek also on D15 (a red label splits across two lines). The round 2 findings are all fixed. Each new finding has a small fix.

Snapshot: `C:\Github\cvgen\.worktrees\hanami-essential\builds\hanami-essential-r3-20261108-131428\` (8 renders).

Batch sheets: `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1340\batch-{twin,no-portrait,long-career,long-career-greek,greek,indigo,sky,no-licence}.png`

## Round 2 findings, checked

- **D10 Resolved.** "Available on request." now clears the panel's bottom edge by about 5 mm.
- **D11 Resolved.** The Earlier roles block now clears the footer hairline by about 3.5 mm, and the long career keeps five roles in full.
- **D12 Resolved.** The rail reads as one piece.

## The new v2 elements

- **Licence block:** right content, right place. It puts a knockout fact in the first-scan zone (research claim 111).
- **Role labels on trips:** red "LED THE GROUP" against metal "ORGANISED" separates the two at a glance.
- **Seal words on the band** (tab | specialty | hairline | course): busy but orderly. In Greek, the row still clears the portrait ring by about 10 mm.
- **Native script dropped:** no loss.
- **Stops with known ones in bold:** reads well.

The Scan Test still passes on every render, the Batch Test still passes (the red tab and the licence's red rule help), and craft is still level with the Flagship.

## New findings

- **D13 Blocking (criterion 6, collision): every render with a licence.**
  - What happens: beside the licence, the lead statement wraps to two lines. That pushes the profile row down to the 5 mm assert limit. But the rail panel starts 4 mm above `main.y`, so the descenders of the last highlight cell ("Tour Leader course (TTI)", "2009") now touch the top edge of the wash. "01 Experience" is also squeezed to about 5 mm under the row.
  - Crops: `crop-twin-profile.png`, `crop-lc-profile.png`, `crop-profiles-all.png`.
  - **Fix (preferred):** set the licence block at the head of the rail, above availability. Both red-rule callouts then form one group instead of the same device appearing twice with a row between them. The lead returns to one line, as on no-licence.
  - **Alternative:** start the fields at `max(85mm, row end + 9mm)`, so the panel's 4 mm bleed always clears the row.
- **D14 Blocking (criterion 6, Greek typography): greek, long-career-greek.**
  - The licence headline reads "ΙΣΧΥΕΙ ΕΩΣ 31 MAR 2029" / "30 JUN 2028". The contract requires the date as `31 Mar 2029` (regex in `data.typ`), and the template prints it as stored. So a Greek page can never show a Greek date.
  - **Fix:** format the date in the template, either as figures (`31/03/2029`, in Barlow like the other dates) or with month names from `ctx.copy`.
- **D15 Blocking (criterion 6, line break): long-career-greek.**
  - After "16 ημέρες" and "14 ημέρες", the red label "ΟΔΗΓΗΣΕ ΤΗΝ ΟΜΑΔΑ" breaks across two lines, leaving "ΟΜΑΔΑ" or "ΤΗΝ ΟΜΑΔΑ" alone on the next line (`crop-lcg-dest.png`). A longer English period would break the same way.
  - **Fix:** wrap the label in a `box` so it moves to the next line whole, or give it its own line above the trip's kind.
- **D16 Note (content design): destinations.**
  - Every stop now appears twice: once in the trip line (bold or regular), and again in "Knows well" and "Has passed through". On the twin that costs about five rail lines.
  - **Fix:** keep one of the two. Either the bold stops plus a one-line key ("**bold**: knows well"), or the two lists with the stops in plain type.
- **D17 Nit: dots at line ends.** In the stop lists, a "·" is left at the end of a line ("Kumamoto ·", "Naoshima ·", "Nagano ·"). Keep each "·" with the stop that follows it.
- **D18 Note: long-career rail foot.** With the tighter gaps, about 34 mm of empty wash is left under References. That is acceptable. Recheck it after D13: if the licence moves onto the rail, it fills part of that space.
- **D19 Note: Greek fixture.** The seal words ("TOUR LEADER COURSE · TTI · 2024") are still in English. That is data, but the Greek fixture should translate them, to prove the band row fits in Greek.

## Per render

| Render | Result | Findings |
|---|---|---|
| twin | FINDINGS | D13 Blocking; D16, D17 |
| no-portrait | FINDINGS | D13 Blocking; D16, D17 |
| indigo | FINDINGS | D13 Blocking; D16, D17 |
| sky | FINDINGS | D13 Blocking; D16, D17 |
| greek | FINDINGS | D13, D14 Blocking; D16, D17, D19 |
| long-career | FINDINGS | D13 Blocking; D17, D18 |
| long-career-greek | FINDINGS | D13, D14, D15 Blocking; D17, D18 |
| no-licence | PASS | D16, D17 |

On no-licence, the lead stays on one line and the row clears the panel by about 8 mm, as in round 2. First impressions and Scan Test results are the same as in round 2: name under 1 s, each role about 1 s, Education about 3 to 5 s. The licence is now found in about 2 s on the right of the lead.

## Renders made
In `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1340\`:
- `<render>-96dpi.png` and `<render>-200dpi.png` for all eight
- the batch sheets `batch-*.png`
- the crops `crop-twin-profile.png`, `crop-lc-profile.png`, `crop-profiles-all.png`, `crop-lcg-dest.png`, `crop-twin-dest.png`, `crop-greek-bandrow.png`, `crop-lc-foot.png`, `crop-twin-railfoot.png`
- `plain.pdf` and `sheets.py`

## Verdict: FINDINGS
To pass: clear the profile row from the panel, preferably by moving the licence onto the rail (D13); format the licence date for the page's language (D14); keep the role label whole (D15). Then render again.

# Design review round 2: Hanami `essential` (scan-first Template Variation), 2026-11-08

**Verdict: FINDINGS.** greek, long-career and long-career-greek pass. twin, no-portrait, indigo and sky still fail on one new defect, D10: the last line of the rail ("Available on request.") now runs across the bottom edge of the rail panel. It has a one-line fix. All nine round 1 findings are resolved.

Snapshot: `C:\Github\cvgen\.worktrees\hanami-essential\builds\hanami-essential-r2-20261108-130022\` (7 PDFs and 144 dpi PNGs), source at b665f55 and after.

Batch sheets: `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1320\batch-{twin,no-portrait,long-career,long-career-greek,greek,indigo,sky}.png`. Each render sits among the same eight plain one-page CVs as in round 1.

## Round 1 findings, checked

| # | Status | What I see now |
|---|---|---|
| D1 Blocking: gaps | **Resolved** | On the twin, the gap from the 24/7 box to the intern role is about 10 mm and the gap before "02 Education" about 12 mm (both measured to the cap height, so they include line height). The spare 16 mm sits at the column's foot. No role floats. |
| D2 Blocking: specialty contrast | **Resolved** | White on the red tab measures 5.2:1. The specialty is now 7.2 to 13.8:1. The showcase's red tab is back, which strengthens the link to Hanami. |
| D3 Blocking: empty rail on long careers | **Resolved** | Education sits on the rail before References. The column now holds 5 roles in full and "Earlier roles · 3". The rail ends about 27 mm above the panel's foot, which reads as a bottom margin, not a hole. |
| D4 Note: education dates | Resolved | Education dates are in Barlow figures, in the column and on the rail. |
| D5 Nit: earlier-role years | Resolved | The years are muted (5.5:1). The span leads. |
| D6 Nit: repeated word | Resolved | "Earlier roles · 3" / "Παλαιότερες θέσεις · 3". |
| D7 Nit: employer size | Resolved | 8 pt. |
| D8 Note: plain band corner | Resolved | Without a portrait, the wider canopy fills the band's right half, on pink and on navy. |
| D9 Note: Greek fixture | Resolved | The band labels, the tab (ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ), the specialty and the availability are now in Greek. Capitals have no accents and the three-column contact grid fits. |

Unchanged from round 1: the Scan Test passes on every render, the Batch Test passes, and craft is level with the Flagship.

## New findings

- **D10 Blocking (criterion 6, collision): twin, no-portrait, indigo, sky.**
  - What happens: the twin's rail is full. The new rail spread fills its four gaps to the 11 mm cap, which brings the rail exactly to `L.rail.bottom`. That is also the bottom edge of the wash panel.
  - The measured height ignores the last line's descenders. So "Available on request." now sits on the panel edge: its lower half is on the cream page and its upper half on the wash. Crop: `builds\design-review-20261108-1320\crop-twin-railfoot.png`.
  - **Fix:** measure the rail against `R - 4mm`, so the panel gets a bottom inset equal to its 4 mm top bleed.
- **D11 Note (craft): long-career and long-career-greek.**
  - The Earlier roles block ends about 2 mm above the footer hairline. On the other renders the column ends at least 10 mm above it, so this foot looks cramped (crop: `crop-lc-foot.png`). It is not a collision.
  - **Fix (optional):** set `main.bottom` to about 279 mm, if the five full roles still fit. Otherwise leave it.
- **D12 Nit: rail gaps in the twin family.** At the 11 mm cap, the rail's section gaps are much looser than the 2.4 mm from a title to its content. A cap of about 9 mm would keep the rail as one piece once D10 is fixed.

## twin: FINDINGS
First impression: a pink band, the red tab, a bold name and the blossom; then an orderly two-column page.
Scan Test: name under 1 s, each role about 1 s, then Education at about 3 s.
- D10 Blocking. D12 Nit.

## no-portrait: FINDINGS
First impression: the same as the twin, with the large canopy as the band's right half.
Scan Test: the same as the twin.
- D10 Blocking. D12 Nit.

## indigo: FINDINGS
First impression: navy band, red tab, white specialty; calm and confident.
Scan Test: the same as the twin.
- D10 Blocking. D12 Nit.

## sky: FINDINGS
First impression: a light band with the red tab.
Scan Test: the same as the twin.
- D10 Blocking. D12 Nit.

## greek: PASS
First impression: the same as the twin, with Greek capitals in the band.
Scan Test: the same as the twin.
- Its rail is shorter, so the gaps stop at the cap and its last line clears the panel edge by about 3 mm. The D10 fix will also give it its inset.

## long-career: PASS
First impression: a navy band with a wide canopy, a full career column and a balanced rail.
Scan Test: five full roles at about 1 s each, then the earlier roles at about 4 s, then Education on the rail at about 4 to 5 s.
- D11 Note.

## long-career-greek: PASS
First impression: the same as long-career, in pink.
Scan Test: the same as long-career.
- D11 Note. The rail title "ΣΠΟΥΔΕΣ" is correctly set without accents.

## Renders made
In `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1320\`:
- `<render>-96dpi.png` and `<render>-200dpi.png` for all seven
- the batch sheets `batch-*.png`
- the crops `crop-twin-railfoot.png`, `crop-lc-foot.png`, `crop-lc-band.png`, `crop-twin-tab.png`
- `plain.pdf` and `sheets.py` (copied from the round 1 folder `design-review-20261108-1300`)

## Verdict: FINDINGS
The only thing left to fix is D10: inset the rail 4 mm from the panel's bottom edge, then render the four full-rail renders again.

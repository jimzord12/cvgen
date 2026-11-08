# Design review round 4: Hanami `essential` (scan-first Template Variation), 2026-11-08

**Verdict: FINDINGS.** twin, no-portrait, indigo, sky and greek pass. Two defects remain, and each has a small fix:
- **D21:** the D20 change brought back round 3's collision. On no-licence, long-career and long-career-greek, the highlights row touches the top of the rail panel again.
- **D22:** on sparse, the full-height empty rail panel makes the thin record look broken.

Snapshot: `C:\Github\cvgen\.worktrees\hanami-essential\builds\hanami-essential-r4-20261108-135312\` (9 renders).

Batch sheets: `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1400\batch-{twin,no-portrait,indigo,sky,greek,long-career,long-career-greek,no-licence,sparse}.png`

## Round 3 findings, checked

- **D13 Resolved only where the licence sits beside the lead** (twin, no-portrait, indigo, sky, greek). There, the fields start 8 mm under the row, leaving 3.6 mm of cream between the last highlight line and the panel. The renders where it came back are under D21.
- **D14 Resolved.** "ΙΣΧΥΕΙ ΕΩΣ 31 ΜΑΡ 2029" / "30 ΙΟΥΝ 2028".
- **D15 Resolved.** "ΟΔΗΓΗΣΕ ΤΗΝ ΟΜΑΔΑ" now moves to its own line whole. "LED THE GROUP" stays on the period line.
- **D17 Resolved.** Each "·" now starts the line with its stop ("· Kagoshima"). That reads cleanly.
- **D18 Resolved.** On long-career the licence heads the rail. The two red-rule callouts now form one group, and the wash under References is down to about 18 mm.
- **D19 Resolved.** "ΣΕΜΙΝΑΡΙΟ ΑΡΧΗΓΩΝ · TTI · 2024" fits the band row and clears the portrait ring.
- **D20 Works as intended.** The band shrinks to its name block (about 43 mm on sparse). But it causes D21.
- **D16 Note only, as agreed.** Every stop is still listed twice, once in its trip and again in "Knows well" / "Has passed through". This stays until a later contract version changes `destinations@2`.

The Scan Test, Batch Test and Flagship Parity results from round 3 still hold for every render except sparse.

## New findings

- **D21 Blocking (criterion 6, collision): no-licence, long-career, long-career-greek.**
  - What happens: under D20, a short profile row puts the fields only 5 mm under the row. The panel then starts 4 mm above the fields (its bleed), so it begins 1 mm under the row.
  - Measured at 200 dpi, from the last highlight line to the panel's top edge: no-licence 0.6 mm, long-career and long-career-greek 1.1 mm. The descenders of "Tour Leader course (TTI)" and "2009" sit on the wash.
  - No-licence passed in round 3, so this is a regression.
  - Crop: `builds\design-review-20261108-1400\crop-row-panel-all.png`.
  - **Fix:** use one rule for every row: the fields start 8 mm under the profile row, as they already do beside a licence. A short row still gains its height back.
- **D22 Blocking (criteria 1 and 6, balance): sparse.**
  - Both columns end by about 140 mm, but the washed rail panel still runs to the footer. That leaves about 130 mm of empty tinted column, which advertises the emptiness. On the batch sheet the page reads as unfinished.
  - The thinness itself is the record's content, and I do not hold it against the template.
  - **Fix:** when both columns end well short of their fields, end the wash 8 mm below the longer column's content.
  - Separately, the research says a thin page is a failure in its own right (claim 1). So when the fields are less than about 60% filled, the build should warn the operator, for example in the Meta File, so the record is filled out before anything reaches the owner.

## Per render

| Render | Result | Findings |
|---|---|---|
| twin | PASS | D16 Note |
| no-portrait | PASS | D16 Note |
| indigo | PASS | D16 Note |
| sky | PASS | D16 Note |
| greek | PASS | D16 Note; Greek capitals, the month and the seal words are all correct |
| no-licence | FINDINGS | D21 Blocking (regression); D16 Note |
| long-career | FINDINGS | D21 Blocking |
| long-career-greek | FINDINGS | D21 Blocking |
| sparse | FINDINGS | D22 Blocking |

Scan Test on sparse: name, then two roles at about 1 s each, then Education at about 2 s. The scan path itself is fine.

## Renders made
In `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1400\`:
- `<render>-96dpi.png` and `<render>-200dpi.png` for all nine
- the batch sheets `batch-*.png`
- `crop-row-panel-all.png`
- `plain.pdf` and `sheets.py`

## Verdict: FINDINGS
Both fixes are one-line layout rules:
1. Start the fields 8 mm under the profile row in every case (D21).
2. When both columns are short, end the wash at the content (D22), and add the operator warning for thin records.

Then render no-licence, long-career, long-career-greek and sparse again. The other five renders already pass.

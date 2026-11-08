# Design review round 5 (final): Hanami `essential` (scan-first Template Variation), 2026-11-08

**Verdict: PASS.** All nine renders pass and nothing Blocking remains. One Note stays open, D16 (stops listed twice), as agreed. One thing for the owner: the sparse render passes only as a test of how the template handles a thin record. The page itself is half empty and should not be delivered without more content (details below).

Snapshot: `C:\Github\cvgen\.worktrees\hanami-essential\builds\hanami-essential-r5-20261108-140140\` (9 renders).

Batch sheets: `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1410\batch-{twin,no-portrait,indigo,sky,greek,long-career,long-career-greek,no-licence,sparse}.png`

## Round 4 findings, checked

**D21 Resolved.** I measured at 200 dpi, from the last line of the profile row to the top of the panel, and from the rail's last line to the panel's foot:

| Render | Panel | Profile row clears panel by | Rail's last line to panel foot |
|---|---|---|---|
| twin, no-portrait, indigo, sky, greek | 87.4 to 280.9 mm | 3.6 mm | 3.4 mm |
| no-licence | 80.8 to 280.9 mm | 3.6 mm (regression fixed) | 3.4 mm |
| long-career | 80.8 to 280.9 mm | 4.1 mm | 14.7 mm |
| long-career-greek | 80.8 to 280.9 mm | 4.1 mm | 6.6 mm |

The profile row now clears the panel on every render, and every rail clears the panel's foot.

**D22 Resolved.** On sparse, the wash now ends 8 mm under the rail's content, at about 152 mm, not at the footer. The page reads as a finished top half instead of an empty grey column. I did not run the build, so I have not checked the thin-page warning (under 60% filled) myself. I am taking the lead's word that it is in the render's checks.

**Earlier rounds:** none of the earlier fixes has come back. They hold on every render:
- The gaps are capped.
- The red tab and the specialty have good contrast.
- On long careers, Education and the licence sit on the rail.
- Education dates are in Barlow.
- Greek capitals, months and seal words are correct.
- Role labels move to the next line whole.
- Each "·" stays with the stop after it.
- The band fits its name block.

## Per render

| Render | Result | Scan Test | Notes |
|---|---|---|---|
| twin | PASS | name under 1 s; each role about 1 s; Education about 3 s; licence beside the lead about 2 s | D16 |
| no-portrait | PASS | same as twin | D16 |
| indigo | PASS | same as twin | D16 |
| sky | PASS | same as twin | D16 |
| greek | PASS | same as twin; Greek capitals without accents, "ΙΣΧΥΕΙ ΕΩΣ 31 ΜΑΡ 2029" | D16 |
| no-licence | PASS | same as twin | D16 |
| long-career | PASS | five full roles, then "Earlier roles · 3" at about 4 s; licence and Education on the rail | – |
| long-career-greek | PASS | same as long-career | – |
| sparse | PASS (template behaviour) | two roles and Education within about 2 s | see below |

All nine pass the Batch Test on craft and order. Their craft is level with the Flagship. Every render still reads as Hanami: the sakura branch, the red tab with 添乗員, Barlow figures, and the numbered sections in metal.

## For the owner's decision

- **D16 Note (open, agreed).** Every stop is listed twice, once in its trip and again in "Knows well" / "Has passed through". `destinations@2` requires both, so this stays until a later contract version changes it.
- **Sparse is not a deliverable.** The template now handles a thin record well. But the page still ends at about the middle of the sheet, and on the batch sheet it reads as thin. The research says a thin one-page CV is a failure in its own right (claim 1). The fix is more content in the record, not more design. The operator warning is the right safeguard, and a record like this should not reach the owner's desk as it is.

## Renders made
In `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-1410\`:
- `<render>-96dpi.png` and `<render>-200dpi.png` for all nine
- the batch sheets `batch-*.png`
- `plain.pdf` and `sheets.py`

## Verdict: PASS

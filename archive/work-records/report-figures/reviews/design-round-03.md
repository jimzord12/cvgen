# Design review round 3: Report Template (studio/brand/report/), in-card pictures, lightbox, figure links

**Verdict: PASS.** No Blocking findings. D3 is fixed, and so are the round 2 Notes it was meant to fix. What is left is one Note and two Nits, all optional.

Snapshot: worktree `.worktrees/report-figures`, head ff82d46. I built `sample.json` with `report.py`, plus the compare-in-card variant: the same file with the decision's `figures` removed, so card 4 holds the Figure A compare. Screenshots are headless Chrome:
- 1100 px in dark and light;
- a true 390 px through an iframe;
- the lightbox opened by an injected click, then scrolled to the middle and the end, plus sideways on the phone.

DOM probes were run at both widths.

Batch sheets: n/a (brand asset).

## What happened to each round 2 item
- **D3 (card 4 ran off the phone): fixed.** The page measures 375/375 at 390 px. The card 4 options column is 311/311, and the "Figure A ↓" pill truncates with an ellipsis (`crops/phone-dark-card4.png`, `crops/phone-light-card4.png`).
- **Sticky bar: fixed.** At 1100 px, after scrolling 600 px the bar sits at the top of the dialog with Close in view (`crops/desk-lightbox-scrolled-bar.png`). For a compare it reads "Left: Classic · Right: Silver" in both themes, and the sides are correct, since the clipped top image (before) is on the left (`crops/desk-lightbox-compare-scrolled.png`, `crops/desk-lightbox-compare-end.png`). The slider still works: at 30 the probe gives `--x` = 30%.
- **A click inside closing the dialog: fixed.** Clicks at every inside edge and corner land on `.lb-frame`, and the dialog stays open. A backdrop click closes it, and focus returns to the picture. On the right edge the probe hit the box itself, but that is the dialog's own scrollbar, which never fires a click.
- **Lightbox on a phone: fixed for a page.** The dialog is edge to edge (390×844). The page inside is 734 px wide with sideways scroll, and it reads well (`crops/phone-lightbox-page-scrolled.png`, `crops/phone-lightbox-page-sideways.png`).
- **Half-and-half compare thumbnail: fixed.** The thumbnail has both images, a 50% split and the copper rule (`crops/cic-light-card4-compare-thumb.png`).
- **Back-link pill colour: fixed.** In light, "Card 4 ↑" and "Decision ↓" are near-black (#131210) on the light page (`crops/light-figures-head.png`).
- **"·" separator: fixed.** On a phone, "Figure A · One record…" now wraps as one piece (`crops/phone-dark-figures-head.png`).

## Desktop 1100, dark: PASS
First impression: the seal and headline, then card 2's page beside its options. Nothing has regressed. The lightbox's sticky bar is quiet and on-brand, and the copper Close button stays reachable.

## Desktop 1100, light: PASS
The page matches the dark theme, and the pill contrast is fixed. The compare-in-card thumbnail reads as two versions because of the copper split and the "⤢ Compare" chip (`crops/cic-light-card4.png`).

## Phone 390, dark and light: PASS
- **Note (fit for purpose): a compare in the lightbox gets almost no bigger on a phone.**
  - Only `.sheet` is set to 200%, so the compare shows at 382 px, against 311 px in the card. The dialog is 390×652 (`crops/phone-lightbox-compare.png`).
  - A colour change can be seen, but a text change cannot be read.
  - I accept this as a trade-off: the slider's range input covers the whole picture, so a 200% compare would turn a sideways swipe into a slider drag.
  - Fix, if wanted: in the phone lightbox, make the compare 200% wide, and let only a strip around the grip catch the drag (or rely on pinch-zoom).
- **Nit:** when you scroll a page sideways in the phone lightbox, the caption scrolls away with it ("…one-page cadet Layout" in `crops/phone-lightbox-page-sideways.png`). The bar's left span is empty for a page. Fix: put "Figure B · caption" in `#lb-sides` for a page too, or give the lightbox caption `position:sticky; left:0`. Either way the owner also knows which figure is open while scrolled.
- **Nit, still open from round 1:** a shared figure under Figures has no Enlarge, so on a phone the Figure A compare is 358 px with only pinch-zoom.

Not reviewed: numbered decision back links. This is out of scope, as the brief says.

Harness artifacts, not template faults:
- **Compare focus:** the probe reported `focusBack=false` for the compare because its synthetic `.click()` never focused the button first. The page case, which focused the button first, returns focus correctly.
- **Probe hits:** `null` hits at the phone's right edge fall under the iframe's scrollbar.

## Renders made
Everything is under `C:\Github\cvgen\.worktrees\report-figures\builds\design-review-report-r3-20261108-163649\`:
- **Builds:** `out\report.html` (the sample) and `cic\out\report.html` (the compare-in-card variant, built from `cic\sample-compare.json`).
- **Desktop full pages:** `d1100-{main,cic}-{dark,light}.png`.
- **Desktop lightbox, page:** `d1100-main-{dark,light}-{lb,lbmid,lbend}.png`.
- **Desktop lightbox, compare:** `d1100-cic-{dark,light}-{lbcmp,lbcmpmid,lbcmpend}.png`. The `lbcmpmid` shots have the slider at 30.
- **Phone full pages, true 390 px:** `p-{main,cic}-{dark,light}-plain.png`.
- **Phone lightbox:** `p-main-{dark,light}-lb.png`, `p-main-{dark,light}-lbside.png`, `p-main-dark-lbend.png`, `p-cic-{dark,light}-lbcmp.png`, `p-cic-dark-lbcmpmid.png`.
- **Crops:** in `crops\`, as cited above.
- **Probes:** `v-*-probe.html` checks the widths, the dialog size and scroll, the sticky bar, the inside and backdrop clicks, focus, the sides text and the slider. The phone frames are `f-*.html`.

## Verdict: PASS

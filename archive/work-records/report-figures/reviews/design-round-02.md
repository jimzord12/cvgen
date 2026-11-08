# Design review round 2: Report Template (studio/brand/report/), in-card pictures, lightbox, figure links

**Verdict: FINDINGS. 1 Blocking finding (D3, new, phone only, a one-line CSS fix). Round 1's D1 and D2 are fixed.**

Snapshot: worktree `.worktrees/report-figures`, head 39e507d. I built `sample.json` with `report.py`, plus the variant with the decision's `figures` removed, so card 4 holds the Figure A compare itself. Headless Chrome screenshots were taken at 1100 px in dark and light. Phone shots are a true 390 px through an iframe. The lightbox was opened by an injected auto-click, and its behaviour was checked with a DOM probe (`--dump-dom`).

Batch sheets: n/a (brand asset).

## What happened to each round 1 item
- **D1 (arrow direction): fixed.** Card 4 shows "Figure A ↓" and the decision row shows "Figure A ↑". Under Figures, the back links read "Card 4 ↑" and "Decision ↓". All are correct for the page order.
- **D2a (no visible cue): fixed.** The copper "⤢ Enlarge" and "⤢ Compare" chips read at a glance.
- **D2b (compare can't enlarge): fixed.** The compare opens in a 1000 px lightbox and its slider works there: I set it to 30 and `--x` became 30% (`crops/desk-lightbox-compare-slider30.png`).
- **D2c (no keyboard access): fixed.** Each picture is a real button. When the lightbox opens, focus goes to Close. When it closes, focus returns to the picture. The Close button and a backdrop click both close it, and a click on the image keeps it open. Esc could not be pressed headlessly, because synthetic key events are untrusted. It is the native `showModal` behaviour.
- **D2 on phone (click did nothing): fixed.** The thumbnail now takes the full width of the card.
- **Notes fixed:**
  - Card 2 now has the picture in a 200 px column beside its options (`crops/dark-card2.png`).
  - The card 4 link shows the start of the caption.
  - Shared figures have the name above and back links.
  - The README table is whole again.
  - The sample's Figure A caption now ties to its card.
- **Light-theme pill contrast: fixed for card and decision pills.** The back-link pills under Figures are still copper (see the Nit below).

## Desktop 1100, dark: PASS
**First impression:** the seal and headline, then card 2's page beside its options. The card no longer leaves an empty strip.

- **Note (fit for purpose):** in the lightbox a CV page is 1476 px tall in a 754 px dialog. Two things follow:
  - Scrolling to read the page moves Close out of sight (`crops/desk-lightbox-scrolled-close-gone.png`). Esc and a backdrop click still work.
  - For a compare, the "Classic" and "Silver" labels sit at the bottom of the page and start out of view, so the owner can't tell which side is which (`crops/desk-lightbox-compare-slider30.png`).
  - Fix: make `.lb-bar` `position:sticky; top:0`, and show the two labels in that bar, or at the top of `.compare`.

## Desktop 1100, light: PASS
- **Nit (contrast):** the back-link pills under Figures ("Card 4 ↑", "Decision ↓") are still copper: #a8602c on #fbfaf7, about 4.4:1 at 16 px. The `figcaption b{color:var(--thread)}` rule overrides the colour the pill inherits. Crop: `crops/light-figures-head.png`. Fix: add `.ref b{color:inherit}`.

## Phone 390, dark and light: FINDINGS
- **D3 Blocking (fit for purpose, craft): card 4 runs off the right edge.**
  - The "Figure A ↓" pill with its caption doesn't shrink, so the options column grows to 516 px inside a 311 px card. "No, one per Template" is cut off, and the whole page scrolls sideways: `scrollWidth` is 548 against a 375 px viewport.
  - Crops: `crops/phone-dark-card4.png`, `crops/phone-light-card4.png`.
  - This breaks any card that links a shared figure on any screen narrower than about 610 px. The cause is the caption added in this round. Decision rows are fine because they already use `minmax(0,1fr)`.
  - Fix: `.ask-main{grid-template-columns:minmax(0,1fr)}`. I tested it: the page becomes 375/375 and the pill truncates with an ellipsis at 307 px.
- **Note (fit for purpose):** on a phone the lightbox shows the page at 324 px, against 326 px inline (`crops/phone-lightbox-page.png`). The "Enlarge" chip promises more than it gives. The compare slider is still useful there (`crops/phone-lightbox-compare.png`).
  - Fix: below 760 px make the dialog edge to edge (`width:100vw; max-width:none; padding-inline:4px`), or add an "Open full size" link so the owner can pinch-zoom.
- **Nit:** in the Figures heading the "·" separator sits 12 px after "Figure A". On a phone it starts the next line: "· One record…" (`crops/phone-dark-figures.png`). Fix: wrap the name and caption in one span.
- **Nit:** the compare thumbnail shows only the Silver page (`crops/cic-dark-card4-compare-thumb.png`). A half-and-half thumbnail would say "two versions" before you read the chip.
- **Nit:** a click on the dialog's 14 px padding closes it (`ev.target===box`).

The round 1 Note on the full-width shared figure is still open and still optional.

## Renders made
Everything is under `C:\Github\cvgen\.worktrees\report-figures\builds\design-review-report-r2-20261108-162901\`:
- **Builds:** `out\report.html` (the sample) and `cic\out\report.html` (the compare-in-card variant, built from `cic\sample-compare.json`).
- **Desktop full pages:** `d1100-{dark,light}.png`, `d1100-cic-{dark,light}.png`.
- **Desktop lightbox:** `d1100-{dark,light}-lb-page.png`, `d1100-cic-{dark,light}-lb-compare.png`, `d1100-cic-dark-lb-slide30.png`, `d1100-dark-lb-scrolled.png`.
- **Phone, true 390 px:** `p-{dark,light}.png`, `p-cic-dark.png`, `p-{dark,light}-lb.png`, `p-cic-{dark,light}-lb.png`.
- **Crops:** in `crops\`, as cited above.
- **Probes:**
  - `v-*-close.html` checks the open and close behaviour and where focus goes.
  - `f-measure.html` measures the D3 overflow.
  - `f-measure-fix.html` confirms the D3 fix.
- **Harness artifacts:** the yellow probe strip in the lightbox shots, and the two-line "Close" button in the phone lightbox, come from my probe text, not the template.

## Verdict: FINDINGS
Fix D3, the one CSS line above. The Notes are recommended: a sticky Close bar with the compare labels in it, and a bigger lightbox on phones.

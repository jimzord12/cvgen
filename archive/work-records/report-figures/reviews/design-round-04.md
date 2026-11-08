# Design review round 4 (confirmation): Report Template, studio/brand/report/

**Verdict: PASS.** I found nothing Blocking. All three changes in eea6751 work as described in both themes and at both widths. I have two Notes and three Nits; all are optional.

Snapshot: worktree `.worktrees/report-figures`, head d9d7fd3. I built `sample.json` with `report.py` as you asked.

I also built a variant, `var/sample-long.json`, to test the new button on a page figure with a long caption:
- Figure B is also cited by decision 1, so it moves under Figures, beside A.
- Its caption is 190 characters.

I loaded every view through an iframe, so the widths are exact (1100×900 and 390×844). In each view I set the theme, scrolled to the heading, and clicked the new button inside `figcaption.head`. The lightbox was then scrolled down, sideways and to the end. A probe measured each view.

Batch sheets: n/a (brand asset).

## What happened to each round 3 item
- **Shared figure has no Enlarge: fixed.** "⤢ Compare" (A) and "⤢ Enlarge" (B) show in the heading in both themes. Each opens the right figure, and focus lands on Close. Crops: `crops/desk-dark-figures-head.png`, `crops/desk-light-figures-head.png`, `crops/phone-dark-figures-head.png`, `crops/phone-light-figures-head.png`, `crops/phone-dark-long-head.png`.
- **Bar names the open figure: fixed.**
  - For the compare it reads "Figure A · Left: Classic · Right: Silver" (`crops/desk-dark-lb-compare-bar.png`).
  - For the page it reads "Figure B · <caption>", and that stays readable when the page is scrolled down (`crops/desk-dark-lb-long-scrolled.png`).
  - On the phone it stays readable when the page is scrolled sideways (`crops/phone-light-lb-long-sideways.png`), which fixes the round 3 caption Nit.
- **Close wrapping on phones: fixed.** Close is one line (79×36) at every width, including beside a 4-line caption (`crops/phone-dark-lb-long-bar.png`).
- **Page width:** no overflow anywhere. The page measures 390/390 on the phone and 1078/1078 on desktop.

## Desktop 1100, dark and light: PASS
First impression: the Figures heading reads in order: the figure's name, then the back links, then the action.
- **D1 Note (fit for purpose): the new button looks exactly like a back link.**
  - It has the same copper outline and size as the links, and it sits inside the "Asked or told about in" run. So it reads as a third place the figure is cited, not as an action. The ⤢ glyph is the only difference.
  - The in-card thumbnails already use a filled copper "⤢ Compare" chip for the same action.
  - Fix: give `button.ref` the chip look: `background:var(--thread); color:var(--on-thread)`, keeping `.ref`'s outline.
- **Nit:** when one shared figure fills the width, the lightbox shows it at 972 px, against 1046 px inline. On desktop the button adds the sticky labels, not size. No fix needed.
- **Nit:** when two shared figures sit side by side, their headings differ in height, so the pictures' tops are 21 px apart (210 against 231; `crops/desk-dark-two-heads-long.png`, `crops/desk-light-two-heads-long.png`). Fix, if wanted: put each figure on `display:grid; grid-template-rows:subgrid`, or let the heading row stretch.

## Phone 390, dark and light: PASS
- **Nit (craft): a long caption makes the sticky bar tall and tight to the edge.**
  - The 190-character caption fills 4 lines, so the bar is 98 px, about 12% of the screen, on every scroll.
  - The caption starts 4 px from the screen edge, and the Close focus ring nearly touches the right edge.
  - The full caption already appears under the picture (`crops/phone-dark-lb-long-end.png`).
  - Fix: in the phone media query, clamp `#lb-sides` to 2 lines (`display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden`) and give `.lb-bar` about 8 px of side padding.
- **D2 Note, carried from round 3: on a phone the compare gets almost no bigger in the lightbox.** It shows at 382 px, against 358 px under Figures (`crops/phone-light-lb-compare.png`). The new "⤢ Compare" button therefore promises more than it gives on a phone. The round 3 trade-off still holds (making it bigger would turn a sideways swipe into a slider drag), so this is not Blocking.

**Harness artifact, not a template fault:** the dimmed backdrop does not render in my desktop iframe screenshots. The `::backdrop` CSS has not changed since round 3, where it showed, and it does render in the phone shots.

## Renders made
Everything is under `C:\Github\cvgen\.worktrees\report-figures\builds\design-review-20261108-164412\`:
- **Builds:** `report.html` (the sample); `var\sample-long.json` and `var\out\report.html` (the variant).
- **Desktop shots:** `d1100-{main,long}-{dark,light}-{head,lb,lbscroll,lbside,lbend}.png`.
- **Phone shots, true 390 px:** `p390-{main,long}-{dark,light}-{head,lb,lbscroll,lbside,lbend}.png`.
- **Probes:** `probes.json` holds the widths, heading and button boxes, dialog size, bar height, bar text, Close size and focus. The frame pages are `v-*.html`, `f-*.html` and `fd-*.html`.
- **Crops, in `crops\`:**
  - `desk-dark-figures-head.png`, `desk-light-figures-head.png`
  - `desk-dark-two-heads-long.png`, `desk-light-two-heads-long.png`
  - `phone-dark-figures-head.png`, `phone-light-figures-head.png`, `phone-dark-long-head.png`
  - `desk-dark-lb-compare-bar.png`, `desk-light-lb-long-bar.png`, `desk-dark-lb-long-scrolled.png`
  - `phone-dark-lb-long-bar.png`, `phone-light-lb-long-sideways.png`, `phone-dark-lb-long-end.png`, `phone-light-lb-compare.png`

## Verdict: PASS

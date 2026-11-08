# Design review round 1: Report Template (studio/brand/report/), figure ids and in-card pictures

**Verdict: FINDINGS. 2 Blocking findings, both small fixes.**

The change works. A card now names or shows its picture. The copper "Figure B" label and the "Figure A ↓" pill fit the page's language: Sofia Sans condensed, the copper thread colour, rounded like the stitch. Two things stop it passing:
- **D1:** the link arrow points the wrong way from one place.
- **D2:** you can't see that a picture enlarges, and in two cases it doesn't enlarge at all.

Snapshot: worktree `.worktrees/report-figures`, head 1097d95. I built the sample with `report.py` and took headless Chrome screenshots at 1100 px and at a true 390 px. Chrome won't make a window narrower than about 500 px, so the 390 px shots are taken through a 390 px iframe. Both themes are covered (I set `data-theme`).

To check the enlarge case the owner complained about, I built one extra variant: the decision's `figures` removed, so card 4 holds the Figure A compare slider itself.

Batch sheets: n/a (brand asset).

## Desktop 1100, dark: FINDINGS
**First impression:** the stitched band, the verdict seal and the headline. Card 2 is now the tallest block in "Needs you" because of its page picture.

Does a card make sense on its own?
- **Card 2:** yes. Question, picture and "Figure B · Closest thing today: the one-page cadet Layout" read together without scrolling.
- **Card 4:** partly. "Look at (Figure A ↓)" says there is a picture, but not what it shows.

Findings:
- **D1 Blocking (fit for purpose):** the "Figure A ↓" pill on the Major decision "Report lives in the brand folder" points down. The page order is Needs you → Figures → Reviews → Decided without you, so Figure A is above that row. Coming back after hours away, the owner scrolls the wrong way.
  - Crop: `crops/decision-row-link-points-down.png`
  - Fix: set the arrow by where the item sits (↑ for anything after Figures), or use a neutral glyph such as "Figure A ↗".
- **D2 Blocking (fit for purpose: the enlarge doesn't read, and fails in two cases):**
  - **(a) No visible cue.** The only hints are the zoom-in cursor and a hover-only `title` tooltip. A 260 px CV page can't be read, so if the owner doesn't know it enlarges, the thumbnail is useless.
  - **(b) Compare figures can't enlarge.** The click listener is bound only to `.shows .sheet`. A compare figure owned by one card therefore shows as a 260 px slider: the 44 px grip covers about a sixth of the width, and nothing enlarges it. "Approve this look" is exactly the case in the owner's feedback. Crop: `crops/compare-in-card.png`.
  - **(c) Not reachable by keyboard.** The thumbnail is a plain `img`, not a button.
  - **Fix:**
    - Wrap each in-card figure in a `<button>` with a small copper "⤢ Enlarge" chip in one corner, the same pill style as `.ref`.
    - Enlarge to the full card width (see D2 on phone), or into a `<dialog>`.
    - Apply this to `compare` figures too.
- **Note (craft):** card 2's picture is about 370 px tall and stacked above the options. About 800 px of the card to its right is empty, and the card is roughly three times the height of the others.
  - Crop: `crops/card2-in-card-figure.png`
  - Fix: on wide screens put the picture in a left column (about 220 px) with the options beside it; that also says "this is what you are judging".
- **Note (card makes sense on its own):** card 4's pill names the figure but not its subject.
  - Crop: `crops/card4-figure-link.png`
  - Fix: add the start of the caption after the pill ("Figure A ↓ Classic vs Silver").
- **Note:** after the jump to Figure A:
  - the copper `:target` outline marks it well (`crops/dark-target-figA-top.png`);
  - there is no way back to card 4, and the "Figure A" caption sits about 1,500 px further down, under a full-width page;
  - Fix: put the name above the figure and add "↑ back to card 4 · decision" (which also shows who cites it). Optionally cap a shared figure's width.
- **Nit:** the enlarged sheet stops at about 808 px (three 260 px grid tracks), leaving about 230 px of the card empty (`crops/dark-zoom-0.png`). It should fill the card.

## Desktop 1100, light: FINDINGS (same as dark)
D1 and D2 as above. Otherwise the colours carry over cleanly (`crops/light-1100-0.png`, `-1.png`).
- **Nit:** the copper pill text (#a8602c on #efebe3) is about 4.0:1 at 15 px bold, just under AA for that size. Darken the light-theme thread for `.ref` only, or make the pill text 1 px larger.

## Phone 390, dark: FINDINGS
No overflow, clipping or collisions anywhere. The options stack, the pills fit, the stitch path scrolls to "Your decision", and the decision rows wrap cleanly (`crops/phone-dark-0.png` to `-3.png`).
- **D2 (phone part), Blocking:** clicking the thumbnail does nothing. `auto-fill` with a 260 px maximum makes one track in a 326 px card, so `grid-column: 1/-1` still spans 260 px. The before and after screenshots are pixel-identical (`phone-dark.png` and `phone-dark-zoom.png` in the build folder). On a phone, where the thumbnail is hardest to read, it can't be enlarged.
  - Fix: give `.zoom` `grid-column: 1/-1` on a grid that has a full-width track, or set `width: 100%` and drop the 260 px cap when zoomed.
- **Nit:** the 260 px thumbnail sits off-centre in the 326 px card (`crops/phone-card2.png`). Let it take the full width at this size.
- D1 applies here as well.

## Phone 390, light: FINDINGS (same as dark)
Nothing beyond D1 and D2.

## Outside the rendered page
- **Note (README craft):** in `studio/brand/report/README.md`, the paragraph "Where a picture goes follows from `figures`…" sits inside the fields table, between the `decisions` and `changes` rows. The `changes` and `evidence_path` rows then fall out of the table as loose pipe text. Move the paragraph below the table.
- **Nit (sample):** Figure A compares two Themes but is cited by "Freeze one reference per Variation?". The sample teaches a loose citation; a caption that ties it to the question would model the rule better.

## Renders made
All under `C:\Github\cvgen\.worktrees\report-figures\builds\design-review-report-20261108-162131\`:
- **Full pages:**
  - Desktop: `shot-{dark,light}{,-zoom,-target}-1100.png`. The `shot-*-390.png` files are invalid (Chrome's minimum window width); ignore them.
  - Phone (true 390 px, cut down to the frame): `phone-{dark,light,dark-zoom,light-target}.png`
- **Evidence crops** in `crops\`:
  - `decision-row-link-points-down.png` (D1)
  - `compare-in-card.png` (D2b)
  - `card2-in-card-figure.png`
  - `card4-figure-link.png`
  - `dark-zoom-0.png`, `dark-zoom-1.png`
  - `dark-target-figA-top.png`
  - `phone-card2.png`
  - `phone-dark-0.png` to `-6.png`, `light-1100-0.png` to `-3.png`
- **Compare-in-card variant:** `compare-in-card\out\report.html` and `desk.png`

## Verdict: FINDINGS
Fix D1 and D2 (cue, compare, keyboard, phone). The Notes are recommended, not required.

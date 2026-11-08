# Design review round 3: Hanami `showcase` (head ded1f6e)

All eight pages pass; there are no Blocking findings, and every round 1 and 2 note is now fixed or accepted. One Note remains worth fixing before freezing: the role label sits almost on the stamp.

Snapshot: the renders in `C:\Github\cvgen\.worktrees\travel-contract-v2\builds\design-renders-20261108-r3\` (144 dpi), plus the test output `builds\tests-20261108-132031-123145\travel-led-long-period\travel-led-long-period.pdf`.

Batch sheets: one per page, in `C:\Github\cvgen\.worktrees\travel-contract-v2\builds\design-review-20261108-r3check\`, named `batch-sheet-<render name>.png` (8 files), with all eight together in `batch-sheets-overview.png`. Each puts the page among the same 10 plain CVs as round 2. Every Hanami page, page 2 included, is the one the eye lands on.

## Sakura, page 1: PASS
Unchanged since round 2. The Three-Second Test elements are the same: the travellers led by a flag (travel and Tour Leader), the torii, Fuji, sakura and 日本 seal (Japan), the red "TOUR LEADER 添乗員" tab, and SKG→FUK through the name plate.

## Sakura, page 2: PASS
**D14 is fixed.** The licence now sits in the subtitle's place: red LICENCE label, bold "Tour Leader", muted "Thermaic Tour Board · Valid until 31 Mar 2029". It has no rule and reads as the section's subtitle. Measured:
- The title ink runs 229.5 to 236.4 mm and the licence 237.1 to 239.4 mm, the same rhythm as the subtitles of 02 and 03.
- The 4.4 mm gap to the cards is back.
- The line ends at 120 mm on the page: clear of the languages column (which starts at 133 mm) and of the lanterns (150 mm).

The 104 mm limit, which you asked me to check:
- Your 104 mm is counted from the subtitle's start, 13 mm into the field. So it ends 117 mm into the field, which is 133 mm on the page: exactly the left edge of the languages column.
- My ~112 mm was counted from the field's left edge and stopped at the right edge of the education columns (111 mm into the field). Measured from the same start, your limit is about 6 mm wider than mine.
- D17 Nit: a licence long enough to reach the limit would end flush with the languages box, over the gutter, with nothing to align to. Fix: tighten the limit to 98 mm, so the line ends at the right edge of the education columns. Today's licence ends at 120 mm on the page, so nothing visible changes.

**D15 is fixed: the role label sits under the stamp.** The placement works. Under the stamp it reads like a caption to an eki stamp, every role word ends in the same place whatever the period's length, and the trip lines are clean again. In `led-long-period`, "LED THE GROUP" is in the accent colour and fits the 26 mm stamp column, with "September 2024 12 days" on one line.
- D18 Note (Craft): the label sits 0.4 mm below the stamp's outer ring (stamp ink 64.6 to 90.1 mm, label 90.5 to 92.1 mm). At arm's length the caption touches the rim and looks cramped next to the generous spacing elsewhere. Fix: add 1.2 to 1.5 mm of space above the label in `trip-card`. In the twin the April card's text column ends level with the label, so this costs at most about 1.5 mm of page 2. The page 2 overflow check will fail loudly if that space isn't there.

**D16 is fixed.** The kind lines now read "Private trip for three (himself and two cousins)" with no repetition.

## Indigo, page 1: PASS
**D11 is fixed.** The petals flying over the navy band are crisp; the blurred discs on the torii post, beside "Greek" and at the left of the page 2 band are gone.

## Indigo, page 2: PASS
Same fixes as Sakura page 2. D18 applies.

## Sky, page 1: PASS

## Sky, page 2: PASS
D18 applies. The red stamps keep it ahead of the market's blue-header templates.

## No portrait, page 1: PASS
**D13 is fixed.** The initials now sit on a disc with a hairline inner ring, matching the stamps, so the disc looks drawn rather than empty.

## No portrait, page 2: PASS
D18 applies.

**D12 is fixed:** every theme now renders the current record (FUK route, new Milos text, licence).

**Earlier notes:** D1 to D3, D5 to D7, D9 and the highlights assert were fixed in round 2. D4, D8 and D10 are accepted as matching the owner's pick.

## Renders made
In `C:\Github\cvgen\.worktrees\travel-contract-v2\builds\design-review-20261108-r3check\`:
- `r3-trips.png` and `r3-sec04.png`: enlarged crops of the trip cards and section 04
- `led-long-p2-200.png` and `led-long-trips.png`: the long-period test page
- `r3-indigo-bands-sky1.png`: the indigo bands with the Sky page 1 band below them
- the eight batch sheets and `batch-sheets-overview.png`

## Verdict: PASS
D18 (more space above the role label) is a Note I recommend applying before freezing, because freezing locks it in. D17 is optional.

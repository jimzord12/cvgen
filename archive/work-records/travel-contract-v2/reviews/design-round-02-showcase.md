# Design review round 2: Hanami `showcase`, Frozen Reference candidate (travel contract v2)

I can't recommend freezing this yet. Page 1 passes; page 2 has two blocking problems, both in the new contract v2 parts: the licence line and the trip role labels.

Snapshot: `C:\Github\cvgen\.worktrees\travel-contract-v2\packages\domains\travel\templates\hanami\tests\approved\Travel-Tour-Leader-CV-v01.pdf` (candidate PNGs in `builds\tests-20261108-130825-559180\travel-candidate\`)
Batch sheets:
- `C:\Github\cvgen\.worktrees\travel-contract-v2\builds\design-review-20261108-131014\batch-sheet-candidate-p1.png`
- `C:\Github\cvgen\.worktrees\travel-contract-v2\builds\design-review-20261108-131014\batch-sheet-candidate-p2.png`

## Page 1: PASS
First impression: as in round 1, the torii framing the portrait, the travellers led by a flag, and SKG ····✈ FUK through the name plate. It is still the page the eye lands on.
Three-Second Test:
- **Travel:** the travellers with suitcases, the airport codes and the plane.
- **Japan:** the torii, Fuji, the sakura and the 日本 seal.
- **Tour Leader:** the flag-bearer leading the group, and the red "TOUR LEADER 添乗員" tab.

D1 is fixed: "Passport valid / until 2 May 2033" no longer splits the date. D5 is fixed: the Milos case now says "put them … rebooked". No new findings.

## Page 2: FINDINGS
First impression: the pink band with the seal and SKG→FUK, then two red eki stamps. It is still the stop-on page in its batch sheet, and visibly page 1's sibling. The kanji all match their stops (福岡 岡山 直島 姫路 金沢 富山 長野 日光 仙台 函館 札幌; 鹿児島).

**D14 Blocking (Craft: spacing and grid). The licence line is squeezed into section 04 and breaks its rhythm.** Measured at 200 dpi:
- **Squeezed gaps.** The subtitle ends at 239.4 mm, the licence ink runs from 241.4 to 244.6 mm, and the education cards start at 246.3 mm. That leaves 2.0 mm above the licence and 1.65 mm below it. Sections 02 and 03 have about 4.4 mm or more of air between heading and content, so 04 is the only crammed block on the page.
- **Stacked rules.** The red licence rule sits 1.6 mm above the brass card rules and reads as one broken bar.
- **Outside the grid.** The line runs to about 159 mm, across the languages column. "Valid until 31 Mar 2029" sits 1.5 mm above the Greek box, so it reads as that column's header. It also ends about 0.4 mm under the lantern art.

Fix: when the record has a licence, put the licence line where the education subtitle goes, inside `heading()` (the subtitle "Tourism, Tour Leader course, English and Japanese" only repeats the cards). Then:
- Drop its left rule and keep the red LICENCE label.
- Restore the 4.4 mm gap to the cards. This recovers about 2.5 mm against today's 11.4 mm from title to cards.
- Keep the line within the education columns, about 112 mm, by moving "issuer · region · Valid until …" to a second line when needed.
- Add an assert so the line ends before the lanterns (134 mm into the field).

**D15 Blocking (Craft: robustness, and the freeze fixes this layout). The role label has no room for the contract's own key value.** "ORGANISED" fits only just: the October line ends 0.7 mm from the column edge, and the April line has about 6.5 mm free. The contract's word for a led trip is "Led the group" (`domain.typ`, line 13). Set the same way it measures about 22 mm, so it would wrap silently under the period on both cards, and nothing fails loudly. That is exactly the role a Tour Leader most wants to show. Freezing this reference fixes where that label sits, so the problem has to be solved first.

Fix: move the role label to its own line just above the period, as a small tracked label with the accent colour for a led trip. Its position then no longer depends on the period's length. Also assert that its width fits the card column. Test it with a record that has `role: led` and a long period such as "September 2024".

- D16 Nit (copy): with "ORGANISED" now shown, the kind line's "which he planned himself" says the same thing twice. The record could drop it.

**Round 1 notes:**
- **Fixed:**
  - D2: contact width assert (`hero.typ`, line 28).
  - D3: rank tab assert at 34 mm or less (`hero.typ`, line 121).
  - The 4-cell highlights assert (`sections.typ`, line 38).
  - D6: the route codes now start 6.98 mm from the top trim.
  - D7: the flag now clears the torii by about 2.5 mm.
  - D9: "Nikko and Sapporo".
- **Accepted as left:** D4, D8 and D10 (they match the owner's pick).
- **Not checked in this snapshot:** D11, D12 and D13. They concern the indigo and sky themes and the no-portrait record, and this candidate is Sakura with a portrait. Please send fresh renders of those from the current record.

## Renders made
`C:\Github\cvgen\.worktrees\travel-contract-v2\builds\design-review-20261108-131014\`:
- `candidate-p1/p2-96.png` and `-200.png`
- `crop-p2-section04.png`, `crop-p2-trips.png`, `crop-p2-band.png`
- `batch\plain.typ` and `plain-01..10.png`
- the two batch sheets above

## Verdict: FINDINGS
Fix D14 and D15 before freezing. Page 1 needs no changes.

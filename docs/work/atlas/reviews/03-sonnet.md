**Verdict: PASS** (round 3, Sonnet 5.5). No Blocking or Material left. I read all 48 PNGs. I also took 5 of my own Edge shots (the roster matrix with the idle toggle, mobile client-journey at native size, two system-map drawer attempts). They are in `...\scratchpad\r3-sonnet\`.

What works: the roster matrix is back, the phase strip and centred Map with cues and pin read at a glance, the paused state is honest, and light and dark are consistent.

**Round 1 and 2 Blocking and Material check**
- Resolved:
  - Roster "Who works where" (Sonnet R2 Blocking, Codex R2 Material). It is populated in all four shots, with 24 rows, 13px squares and a "8 not in any mapped flow" toggle. The 1600 dark shot shows the toggle and the footer cleanly.
  - Optional look drawn as a gate (Codex R1 Blocking): dashed, off-route, "optional".
  - Drawer smear.
  - Current step and overview: strip, "Now · Design · 13 of 20", "N earlier / N more" pills in their own bar.
  - Lane density: helper rows are 52px.
  - Route weight.
  - Mobile lane column: 62px icon column, pin in view at 500px.
  - Mobile strip now scrolled to the current phase (DESIGN, REVIEW, AI GATES).
  - Map starts at about y=495 (client-journey), 515 (design-run) and 475 (change-review).
  - "Paused at your request" now appears on both the change-review page and the index.
  - Walk-through opens on the NOW step.
  - Map header, hero and fold: fixed.
  - Footer wording is fine apart from item 11.
- Partly resolved: the system map is still a card directory at rest. The main-line strip and link counts are enough to answer "how do they feed each other?", and opt-in links were a declined disposition. I do not hold a PASS for it.

**Findings (all Minor or Note)**

1. **Minor. Mobile Maps, lane labels, all flows (500px, light and dark).** Helper-row labels are cut in half vertically. "Research rev.", "Editor", "Design rev." and "Client" are cropped at the bottom of their 52px rows (client-journey, design-run and change-review "Design rev.", "Context rev.", "Trello", "Cl"). Fix: on phones, drop the second label line and reduce the icon to 22px, or make helper rows at least 60px.

2. **Minor. Mobile phase strip, client-journey and change-review.** The "Now · …" chip still sits on top of the last phase. On client-journey it covers the AFTER label and its diamond (x≈300–470, y≈645–680 at 500px). On change-review it covers the CLOSE dots. Fix: make the chip a row item (sticky right with a fade) or move it to its own line under the strip.

3. **Minor. Desktop Maps, left edge of the lane column.** A card sliver or fragment still peeks out right of the lane column. change-review shows the text "ght" at x≈370–390, y≈738. client-journey shows an empty rounded sliver at x≈370–415 in the Claude lane. Faint dash marks sit at x≈170, y≈850 and y≈945 (client-journey). Fix: widen the fade or mask to about 60px, or clip cards at the lane edge.

4. **Minor. Mobile Map, client-journey.** A clipped fragment of the blue loop label ("Revise the draft") peeks out at the lane column, x≈17–60, y≈1068, with the blue dashed line ending at x≈135. Fix: hide loop labels whose box is not fully inside the visible track.

5. **Minor. Index, "Your moves".** The first card, "Fix Blocking and Material", sits in a gold "cannot move until you act" slot. Its text only says "you asked to stop that work for now". It does not say what he should do (resume or drop). The same flow also appears in the "Paused at your request" row below. Fix: give the card a verb and an owner decision, e.g. "Decide: resume the two reviews, or drop them".

6. **Minor. Desktop, current card below the fold on a laptop.** The pin is at y≈745 (client-journey), y≈900 (design-run) and y≈680 (change-review). On a 1440x800 laptop the design-run pin is under the fold. Fix: in a short viewport, scroll the page to the map on load, or shrink the hero further.

7. **Minor. Index desktop.** The first flow card still has about 70px of dead space between its miniature and the footer line. The 3 + 2 layout leaves two wide cards below, which is fine.

8. **Minor. Mobile roster matrix.** Steps wrap into a 5-column block. Their order is only readable because of the caption, and the gaps look random. Fix: keep one row per flow, scrolling horizontally, or number the first square.

9. **Minor. System map, lit state.** With a part selected, the dashed link lines cross card text. They run through "Frozen Reference", "design-concepts" and "Anti-examples", and the floating "Meta File" labels sit on card borders (x≈800–1015, y≈950–1170). It is transient and tolerable. Fix: route the lines in the gutters or give the labels a solid background and put them above text.

10. **Note. Roster.** "Session model" is shown as the model for Claude (lead), repo-auditor-lite and general-purpose but is never named, so the owner cannot tell which model that is. Fix: add the model name in the panel, e.g. "Session model (Fable)". A "Group by model" toggle would also use the data now shown.

11. **Note. Footer.** "Built … not yet checked against its sources" is still on every page in these shots. Your disposition says pages are stamped before delivery; do that.

12. **Note. Capture artifact, not a finding.** The system-map drawer shots (light and dark) and the change-review dark drawer shot caught the drawer mid-slide or not yet open. My own system-map drawer shot did too. The flow drawers render fully (panel x≈1025–1583, previous/next beside the title, "Next: …" in the footer). The code opens the drawer after a 60ms timeout with a 0.28s transition. I could not verify the final state of the system-map drawer visually, but round 1 saw the dark one correctly.

**Two changes that would most raise it:** (a) fix the mobile helper-lane labels and the Now chip overlap (items 1–2), so the phone Map has no clipped text; (b) give the index's first "Your moves" card a verb and an owner decision (item 5).

Files: live pages in `C:\Users\jimzord12\Documents\GitHub\cvgen.worktrees\atlas\.atlas\`; kit CSS and JS in `_kit\atlas.css` and `_kit\atlas.js`.

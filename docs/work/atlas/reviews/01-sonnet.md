**Verdict: FINDINGS** (no Blocking, 7 Material). Round 1. I looked at all 44 PNGs plus 5 of my own Edge shots. Those are in `...\scratchpad\r1-sonnet\`: `cj-facts.png`, `roster-full.png`, `roster-tall.png`, `sm-full.png`, `roster-bottom.png` (the last is not a usable image).

What works: the type scale, the gold/teal/violet semantics, the "You are here" pin, the walk-through progress strip and the dark theme are crafted and consistent. It does not read as a generic dashboard.

1. **Material. All pages, light theme, desktop and mobile. A grey smear on the right edge of every page.**
   - It runs the full page height, about 40px wide, from x≈1560 at 1600 and x≈400 at 500. It is the closed drawer's shadow leaking in.
   - The CSS is `.drawer { box-shadow: -24px 0 60px -20px rgba(0,0,0,.5); transform: translateX(102%) }` in `_kit/atlas.css` (about line 401). 102% is not enough to push a 60px blur off-screen.
   - Fix: only apply the shadow in `.drawer.on`, or add `visibility:hidden` when closed (with a transition delay), or use `translateX(calc(100% + 80px))`.

2. **Material. `system-map`, all widths. It is a directory of boxes, not a map.**
   - Statically there is no connector anywhere. The only cue is "Hover a box to light up what it feeds…". Hover does not exist on touch, and the 500px page still says "Hover a box".
   - The drawer for a part (`envelope.json + README`) shows only "What it does" and Sources. It does not list "Feeds / Fed by", so touch users cannot see links at all.
   - Result: the page's own question, "how do they feed each other?", is not answered at a glance.
   - Fixes:
     - Draw the main line always on, faintly: facts → engine → produce & approve → review. Use arrows between area cards and let hover add detail.
     - Default "Show all links" to on at desktop widths.
     - Add Feeds / Fed-by chips (clickable) to the drawer.
     - On mobile, change the copy to "Tap a box".

3. **Material. Flow Map views, desktop and mobile. They open scrolled into the middle, with no scroll cue.**
   - `client-journey` opens at phase 4 of 7: steps 1–11 are off-screen to the left, step 17 is cut ("Appro").
   - `change-review` opens at phase 3.
   - At 1600px only about 4–5 of 20 steps are visible.
   - Nothing says more exists. The only hint is a faint shadow on the lane-label column.
   - Fixes:
     - Add a fade and chevron on the scrolling edges, and a pill such as "← 11 earlier steps".
     - Add a minimap or a phase strip above the map. The Walk-through strip is already designed, so reuse it, clickable, to jump the map.

4. **Material. Flow pages, 1600. The Map starts too low and wastes its height.**
   - The map header sits at y≈600–650 on all three flows, under the long hero.
   - The three hero bullets repeat verbatim the bullets on the index cards.
   - Lane rows are 118px tall and about half are empty in the visible window. In `client-journey` four of seven lanes are empty (general-purpose, research-reviewer, magazine-editor, design-reviewer). Each holds only a stray ring far down. The lanes run past y=1500.
   - On a normal laptop height the owner sees the title and two lanes, not the flow.
   - Fixes:
     - Move the map above the three bullet cards, or collapse them to one line.
     - Cut lane height to about 80px.
     - Fold helper-only lanes (reviewers) into a single "Helpers" lane.

5. **Material. Flow pages, Walk-through view. It always opens at step 1, not at the current step.**
   - `client-journey` is at step 13 and the card says "Show me this step". Walk-through still lands on "A new client writes to you", step 1 of 20. The NOW badge is only in the left rail.
   - Fix: open Walk-through on the NOW step by default, with a "Back to start" link, or add a prominent "Resume at step 13" button.

6. **Material. Mobile (500px) Map. The lane column eats the screen.**
   - The sticky lane-label column is about 190px of 417px, which is 45%. That leaves about 220px, so one card shows and the next is cut ("A de…", "Fix I…", "Your Des…").
   - The "You are here" step is not in view on `client-journey` and `design-run`.
   - Also on mobile the top nav is cut off ("A ‹") and the active tab for "A change" is half-hidden, with no scroll cue.
   - Fixes:
     - On mobile, shrink the label column to an icon plus a 2-letter or short name (about 64px), or put the actor on the card instead.
     - Auto-scroll the map to the pin on first load.
     - Scroll the active tab into view in the nav, or use a bottom tab bar.

7. **Material. Where-it-stands is inconsistent between pages, so the owner can be misled about who is blocking.**
   - `client-journey` says "Waiting on Claude (lead)" at step 13 (design run).
   - The index and `design-run` say the real wait is you (look through 18 designs, step 5).
   - From the client page the owner thinks Claude is working, when he is the bottleneck.
   - Fix: when a step delegates to another flow, the card should show that flow's wait: "Waiting on you, in the Design run, step 5" with a link. At minimum add a gold chip.

8. **Minor. `design-run` drawer, step 5. Duplicate and empty blocks.**
   - Two gold boxes are stacked back to back, "Your move" and "Your decision". Merge them or put "Optional" as a tag on the first.
   - The "Takes" panel is an empty box showing only "• —". Hide it when empty.
   - A stray "!" glyph (about 8px) sits left of the command at x≈1085, y≈721, next to `python scripts/design_review/server.py`. It looks like a failed icon.

9. **Minor. `client-journey` Map. A loop-back label is clipped.**
   - The dashed loop-back label "…ft-02…" at x≈383–430, y≈1078 is cut by the sticky lane column and reads as "ft-02...".
   - Fix: raise its z-index above the lane column, or place it to the right (inside the track) and use the full text "draft-02".
   - Also the loop line from step 12 overlaps the step's own dotted vertical ring line. Offset it by 8px.

10. **Minor. Legend colours are not unique, in both themes.**
    - general-purpose, research-reviewer, magazine-editor, design-reviewer (and codex-visual-reviewer, a darker green) are the same teal. The legend dots say nothing.
    - Fix: drop per-actor legend entries and keep only kinds (Owner, Client, Lead, Subagent, External model, Service). The lane labels already name the actors. This also removes the legend wrap on mobile (three lines, with "loops back" alone on a fourth).

11. **Minor. `system-map` card grid, 1600.**
    - Cards stretch to row height, so there is dead space: Public examples is about 250px blank, Your review about 230px, The engine and Produce & approve about 130px each.
    - Fix: align-start, or a masonry layout, or fill the gaps with the connectors from #2.

12. **Minor. `roster`. 32 identical card shapes and a mostly invisible model signal.**
    - The model/effort pills ("Opus · high"), the thing the page is about ("on which model?"), are 11px low-contrast chips. Ten subagents read identically.
    - The "Who works where" matrix is at the very bottom (about y≈3900 at 1600). Its squares are about 8px, and most rows are empty strips.
    - Fixes:
      - Colour or enlarge the model chip, or add a "Group by model" toggle.
      - Make the matrix a sticky link at the top, or make the squares 14px.
      - Hide the empty rows behind a "Not used in any flow (9)" toggle. The roster already says "Not used in any mapped flow" on those cards.

13. **Minor. Index.**
    - Card 1 has about 70px of dead space above its mini-strip because the cards are equal height.
    - The second row has two cards and an empty third slot.
    - On mobile (light and dark) the decorative compass shows through behind the hero paragraph at x≈300–400, y≈140–260.
    - Fix: hide the compass under 700px or put it at 6% opacity, and span the last card across the third column.

14. **Minor. Light-theme small text contrast.**
    - "As of 2026-10-01", "Sources", the map footnote ("Each row is who acts…"), the footer and the legend are about #8b93a5 at 11–12px on near-white. That is likely under 4.5:1.
    - Darken by about 15%.

15. **Note. Every page footer says "this page has not been verified yet".**
    - On a finished deliverable it reads as unfinished. Make it a quiet "Unverified" chip, or hide it until the check mode has run.
    - The `system-map` light drawer screenshot caught the drawer mid-slide (its left edge at x≈1140 instead of 1040, so text is cut at the right). The dark one is correct, so this is a capture timing artifact, not a bug.

**Highest-leverage two changes:**
- (a) Make the Map and system-map answer the question at first glance: map first, an overview minimap or scroll cues, compact lanes, and always-visible links on the system map (#2–#4).
- (b) Fix the right-edge shadow (#1) and the Walk-through and where-it-stands current-step logic (#5, #7).

Files: live pages in `C:\Users\jimzord12\Documents\GitHub\cvgen.worktrees\atlas\.atlas\`. The shadow bug is in `_kit\atlas.css` around line 401.

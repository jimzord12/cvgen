**Verdict: FINDINGS** (1 Blocking, 0 Material otherwise, the rest Minor/Note). Round 2. I looked at all 48 PNGs plus 9 of my own Edge shots in `...\scratchpad\r2-sonnet\`. Everything else from round 1 is genuinely better.

What works: the drawer shadow smear is gone, the phase strip with a "Now · N" jump, centred Map with "N earlier / N more" cues, compact helper lanes, dashed "optional" step, floating drawer, system-map main-line strip, "Models in use" panel and the index miniatures. It now reads as crafted, not a generic dashboard.

**Round-1 check (Blocking and Material)**
- Resolved: Codex C1 (optional look is off-route, dashed, "Your move · optional"; its drawer has one gold box and a "You run" label). C2/S3 (Map opens on the pin, strip and pills). C3 (helper rows are 52px). C4 (route is stronger). C5/S5 (Walk-through opens on step 13; "Now" jump). C6 (short-version fold, map about 250px higher). S1 (no right-edge smear in any shot). S6 (62px icon column, pin in view at 500px). S7 (the wait is consistent across pages). S10, S11, S13, S14.
- Partly resolved: C7/S2. The main-line strip, link counts and the drawer's Feeds/Fed-by are good. The static card grid still has no connectors (see 9).
- **Not resolved:** S12, the "Who works where" matrix. It is blank (finding 1).

1. **Blocking. `roster`, "Who works where" tab (light, dark, 1600 and 500). The tab is empty.**
   - It shows only the caption "One square per step…" and then the footer. No table, no squares, no "N not in any mapped flow" button. The round-1 disposition says this was fixed; it is not.
   - I reproduced it in my own shot `r2-sonnet\matrix1.png`, and `--dump-dom` shows `matrixView` holds only the `<p>`.
   - Cause: `_kit/atlas.js` line 967 calls `add(matrixView, p, panel, more)`, but `add(el, kid)` (line 104) takes one child and ignores the rest.
   - Fix: call `add` three times (or pass one array). Then re-shoot both themes, including the idle-rows toggle.

2. **Minor. All flow Maps, desktop and mobile. The scroll pills sit on top of the phase headers.**
   - "9 earlier" covers the number badge and the start of "4 TEXT"; "4 more" leaves only a stray "E" of "DELIVER" at x≈1420 (client-journey).
   - The same happens in design-run ("2 earlier" over "2 DRAW") and change-review.
   - On mobile "4 earlier" cuts "3 YOU…" and "3 REV…".
   - Fix: put the pills in the empty strip above the phase headers, or on the vertical middle of the left and right edges.

3. **Minor. All Maps. Half-hidden cards stick out of the lane column.**
   - change-review shows a text fragment "ght" at x≈370–390, y≈769. client-journey and design-run show an empty 45px card sliver at x≈370–415.
   - It reads as a rendering bug.
   - Fix: mask or fade the first 60px right of the lane column, or let the sticky column fully cover its own width.

4. **Minor. Mobile, all flow pages. The phase strip's "Now · N" chip covers the strip.**
   - At 500px it sits on top of the "TEXT" label and the dots (x≈383–475, y≈785–815).
   - The strip does not scroll to the current phase: client-journey shows OPEN to TEXT, while the current phase DESIGN is off-screen. The same happens in design-run and change-review.
   - On mobile the strip is also the only step selector in Walk-through.
   - Fix: `scrollIntoView` the current phase on load, and make the chip part of the row (sticky right, with a fade) instead of an overlay.
   - Also: on desktop the strip shows only the "now" dot. Round-1 C2 promised a marker for "steps in view", and I see none. A small viewport bracket would finish the overview idea.

5. **Minor. Mobile Map, lanes. Icon-only lanes are indistinguishable.**
   - design-run shows four identical teal robots plus a green hex. change-review shows two robots and two cloud icons.
   - A ring in a helper lane (client-journey at 275,1135; change-review at 133,1055) cannot be tied to anyone.
   - Fix: add 2–3 letter initials under each icon, or a tap or long-press label. At minimum tint each subagent differently.

6. **Minor. Mobile Maps. Cards are cut at both edges with no fade.** "You pick Style, T…", "Merge, push, wa…", "own look (optional)" and so on. A right-edge fade like the left shadow would show "there is more". Related: the legend wraps with "loops back" alone on a line (all flows, 500px).

7. **Minor. Map details.**
   - The "YOU ARE HERE" pin touches the green REVIEW chip (design-run step 6, y≈948–968).
   - The gold bypass dashed line runs across the "YOU" chip of step 12 (client-journey).
   - The loop pill still reads "draft-02..." with an ellipsis (client-journey, x≈575–660, y≈888). Write what it does, e.g. "redo as draft-02".
   - Loop-line fragments leak around the lane column: a blue dot at (170,995) desktop, dashes at (240,890), and small marks at x=15–55 on mobile.

8. **Minor. "Where it stands" copy.**
   - change-review says "Waiting on Claude (lead)" while the text says "you asked to stop". Those contradict. Either state the pause ("Paused by you") or drop the wait chip.
   - It also quotes commit hashes (cae0828, b83795e), which is noise for the owner.
   - design-run says "Waiting on Claude (lead)" but "Show step 6" is a research-reviewer step.

9. **Minor. `system-map`, all widths.**
   - The grid is still a directory. The main-line strip is not tied to the cards below: "1 Facts, Client Envelopes" does not scroll to or highlight anything.
   - Fix: make each strip item a jump to and highlight of its part, and show the area-to-area arrows by default (the "Show every link" toggle is only visible on hover or click).
   - In the lit state (drawer shot) the floating "Meta File" labels sit on top of the "Design" header and card text (x≈800 and x≈1000, y≈1030–1250).
   - On mobile, the snake wrap puts the connector words ("imports", "writes") at the start of rows, so the arrows read ambiguously.

10. **Note. Drawers.**
    - The breadcrumb "Step 13 of 20" is repeated in the header row below it.
    - On open, the "←" button shows a heavy blue focus ring that looks like a selected state. Focus the dialog itself instead.
    - The part drawer repeats the title in a chip ("Design Review app" under "Design Review app").
    - Code: `atlas.js` line 768 has `hashState().open === '1' || true`, so `#focus=` always opens the drawer and the `open=1` key is meaningless.
    - My light-theme change-review drawer shot did not capture the drawer (timing); the dark one is correct.

11. **Minor. Index.**
    - The "Who does the work" card leaves about 80px of dead space between the quote and its icons (y≈1260–1340).
    - The colour key's second row has 3 items and 2 empty slots.
    - On desktop the three flow cards have about 40px dead space above their miniatures.

12. **Note. Footer.** "not yet checked against its sources" on every page still reads as unfinished. The brief's "stamped before delivery" will fix it. Do that, or hide the line.

13. **Note. Roster cards.** 32 same-shaped cards. The model strip helps, but "You" and "The client" have about 70px of blank body. A "Group by model" toggle would use the model data you now show.

**The one or two changes that matter most:**
- (a) Fix the matrix `add()` call (finding 1). It is a one-line bug and the page's second view is dead.
- (b) Make the overview strip finish its job: scroll it to the current phase on mobile, move the chip and pills off the content, and show a viewport marker (findings 2 and 4).

Files: `C:\Users\jimzord12\Documents\GitHub\cvgen.worktrees\atlas\.atlas\_kit\atlas.js` (line 967, line 768); my shots are in `C:\Users\jimzord12\AppData\Local\Temp\claude\C--Users-jimzord12-Documents-GitHub-cvgen\be4994e8-2265-42c9-b749-483128c8651e\scratchpad\r2-sonnet\`.

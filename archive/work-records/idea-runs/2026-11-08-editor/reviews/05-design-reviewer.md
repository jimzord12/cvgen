# Design review round 5 (owner revision): idea run 2026-11-08 (editor), Guilloche

Snapshot: e9e605b (branch docs/idea-run-2026-11-08-editor)
Bar: `scan-first`. Both PDFs are one A4 page (595 × 842 pt). Neither PDF's text still contains "Daphne", "Kontou" or "herself".
Batch sheets: C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-183604\batch\sheet-guilloche-colour.png and C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-183604\batch\sheet-guilloche-mono.png. Each page is placed among the eight plain CVs from the round-1 set, about 150 px wide.
Comparison: I compared against my round-3 renders in builds\design-review-20261108-180335. Round 4 changed only the two Nits, and its brief records them. I did not run git, as my rules forbid it.

## The owner's three changes, checked against the render
1. **Portrait ground: done, and it looks premium.**
   - The sage ground is a true mid tone (mid grey in mono), so the dark hair and the white shirt both separate cleanly from it.
   - The two white engraved rings behind the head keep the portrait in the security-print idea rather than a studio backdrop.
   - **Face:** the face sits on the arch's axis (both at about x 42 mm), and the nose sits at the middle of the arch's visible height. The eyes are about 6 mm above it, so the face is centred and a little high, as the rule asks.
2. **Arch behind the band: done.**
   - The arch and the shirt run on under the 6.8 mm twisted band.
   - The strands cross over the arch outline, and the outline shows faintly through the veil, so the band reads as in front. The face stays clear.
3. **Travel globe: done.**
   - It is 45 mm across and its outer rim is 4.6 mm from the right edge (measured), so the round-3 D21 Nit is closed.
   - The parallels are spaced correctly for a sphere, the equator is heavier, and the double rim is concentric.
   - Four dotted routes leave a ringed home dot. With the aircraft on one of them, they read as flights, not as a diagram.
   - **The airliner is self-drawn and not a stock glyph.** It has swept wings, engine pods, a tailplane and a fuselage line. It flies along its route into the eastern dot, and at 96 dpi it is clearly a plane in colour and in mono.

## Guilloche, colour: PASS
First impression: a tinted engraved header with the sage arch portrait at left, the bold name, and the globe with rose routes and a plane at right. On its sheet it is the page the eye lands on. The header now says "travel" at thumbnail size more plainly than the rosette did.
Scan Test: the name at once; each job's title, employer and the dates set flush right in about 2 s; education in about 3 s. Unchanged.
Regressions: none. The header grid is a balanced 3 × 2, the specialty line sits under the title, and the duplicate availability field is gone (that round-3 Nit is closed). The body, the centre rule and the foot match round 3.
- D22 Note (4, for the owner): the globe is now a plain line wireframe. It is the one header element no longer drawn as engraving: the guilloche now lives only in the halo, the ground pattern and the bands. Globe, plane and dotted routes together are also the stock travel-agency mark. The owner asked for exactly this and it is drawn with craft, so this is not a block. Fix, if wanted: a narrow (2 to 3 mm) guilloche band as the globe's bezel, or fine engraved shading on the sphere's shadow side. Keep the plane and the routes.
- D23 Nit (6): the band's thinnest point falls over the left half of the shirt, about 18 to 40 mm from the left edge. There, the veiled shirt shows as a pale strip with a straight bottom edge under a near-hairline band, so the "in front" reading comes mostly from the right half. Fix: shift the band's phase so a bulge crosses the shirt.
- D24 Nit (6): the veil's straight top edge is visible right across the header as a faint pale stripe at about 93 mm. Fix: confine the veil to the arch's width, or feather its top edge.
- Nit (6): there is a faint grey cutout fringe along the shirt's shoulders against the sage. It shows only at 300 dpi and above. Fix: erode the matte by one pixel when the portrait is prepared.

## Guilloche, mono: PASS
First impression: a grey arch with a white halo and a crisp black globe with routes. It holds as a one-ink design and still stands out on its sheet.
Scan Test: as in colour.
- D22 to D24 and the fringe Nit apply here too.
- Nit (6): the plane's thin outline is the weakest mark on the busy black grid. Fix: a slightly heavier outline, or a small white knockout around it.

## Renders made
- At 96, 200 and 300 dpi: C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-183604\guilloche-{colour,mono}-{96,200,300}.png
- Detail crops: C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-183604\zoom-guilloche-{colour,mono}-{globe,plane,portrait,cutout,archfoot,archfoot-left,archfoot-right,header,header-96}.png
- The two batch sheets listed at the top.

## Verdict: PASS
The three changes do what the owner asked and look premium. The face is centred and a little high, the band reads as in front of the arch, the airliner is self-drawn and legible, and the routes read as travel. Nothing elsewhere on the page regressed. What is left is one taste Note for the owner (D22: the globe is not engraved, and the motif is a common travel mark) and minor Nits on the band's phase, the veil's edge, the cutout fringe and the plane's outline in mono.

**Next:** the lead merges this with the Codex round-5 report. If both pass, the revised Guilloche goes back to the owner, with D22 flagged for his eye.

# Design review round 6 (owner revision): idea run 2026-11-08 (editor), Guilloche

**Verdict: PASS on both pages.** All three of the owner's requests are met, and met well. Nothing elsewhere on the page got worse. What is left is two Nits, both in the globe.

Snapshot: 76952fe (branch docs/idea-run-2026-11-08-editor). I did not run git.
Bar: `scan-first`. Both PDFs are one A4 page (595 × 842 pt).
Batch sheets: each page among ten plain Typst CVs from the round-1 set, about 150 px wide.
- C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-222455\batch\sheet-guilloche-colour.png
- C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-222455\batch\sheet-guilloche-mono.png

## The owner's three requests, checked on the render
1. **"Image background without the shape behind the head": done.**
   - The halo rings are gone. The arch is plain sage in colour and plain mid grey in mono.
   - The face sits on the arch's axis. The nose is at about the middle of the visible arch and the eyes are above it, so the face is centred and a little high.
   - The round-5 cutout fringe is gone, even at 600 dpi.
2. **"Helix more seamless": done, and it is the best change this round.**
   - The header tint fades to white before the helix, and there is no veil stripe any more. I sampled the pixels: the tint falls smoothly from about 232 to 255, with no step.
   - The arch's foot fades out as well. Inside the arch the value is 254 against the page's 255, which no one can see.
   - The helix now tapers to a hairline at both ends, about 3 mm from the page edges. It reads as one engraved ribbon coming out of the page, not as a strip glued on.
   - Its widest part sits over the shirt, below the chin. This closes D23 and D24.
3. **"Make the globe and airplane better": done. It now looks engraved and premium, not clip-art.**
   - **Globe:** shading lines whose weight builds towards the lower right, and a tilted graticule with a heavier equator. A zigzag guilloche bezel sits between two rims. The routes are true great-circle arcs, dotted.
   - **The globe now belongs to the idea:** it is drawn in the same engraving language as the band. That closes my round-5 D22 Note.
   - **Margin:** the outer rim is 5.5 mm from the right page edge (measured).
   - **Airliner:** a twin-engine top view with a hatched fill, a 0.6 pt outline, engine pods and a white knockout.
   - **Mono:** it reads clearly at 96 dpi and no longer sinks into the shading, which closes the round-5 mono Nit. The globe holds as black line work, like an intaglio proof.

## Guilloche, colour: PASS
**First impression:** a rainbow-tinted engraved band with the sage arch portrait, the bold name and the title in rose, and the engraved globe with a rose plane. On its sheet it is the page the eye lands on, and "travel" reads at thumbnail size.

**Scan Test:**
- The name and the title at once.
- Each job's title, employer and dates in about 2 s.
- Education in about 3 s.

The body is unchanged from round 5. Flagship Parity holds.

- **D25 Nit (6), the plane is wedged between two rose dots.**
  - At 14 mm it fills its whole route.
  - Its tail touches the home dot's ring, and its nose almost touches the north-east destination's ring.
  - None of its own dotted route shows, so it reads as parked between two dots rather than in flight.
  - Fix: scale the plane to about 10 to 11 mm (`airliner(14mm, …)`, line 176), or move it to the longer eastern route, so that two or three dots of trail show behind it and ahead of it.
- **D26 Nit (6), a stray tick at the north pole.**
  - The axis stub (line 120, `lift: 1.08`, 0.4 pt) pokes through the sphere's rim and runs into the guilloche bezel. It looks like a stray tick.
  - Fix: stop it at the rim, or drop it.
- **Note (taste, for the owner):** the four rose destination dots, each with a halo ring, are the heaviest marks on the globe. Smaller dots (radius about 1.1 mm) would let the engraving lead. The current dots are not wrong.

## Guilloche, mono: PASS
**First impression:** a grey arch, a crisp black engraved globe with a hatched plane, and the black helix. It holds as a one-ink design and still stands out on its sheet.

**Scan Test:** the same as in colour.

- D25 and D26 apply here too.

## Renders made
All in C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-222455\
- Full pages at 96, 200 and 600 dpi: `guilloche-{colour,mono}-{96,200,600}.png`
- Detail crops: `zoom-{colour,mono}-{header,globe,globe-96,globe-200,plane,pole,portrait,helix,helix-left,helix-right,shoulder}.png`
- The two batch sheets in `batch\`.

**Next:** the lead merges this with the Codex round-6 report. If both pass, the Guilloche goes back to the owner, with D25 and D26 as optional polish.

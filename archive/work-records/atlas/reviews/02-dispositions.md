# Round 2 dispositions (lead, 2026-10-01)

Reports: `02-sonnet.md` (FINDINGS: 1 Blocking, rest Minor/Note) and
`02-codex-gpt-6.1-sol.md` (FINDINGS: 5 Material, 3 Minor, 1 Note).

- Sonnet 1 Blocking / Codex 1 Material (roster matrix empty): fixed. The kit's `add()`
  helper took one child; it now takes any number, so no call can drop children again.
- Codex 2 Material / Sonnet 8 (change flow "moving without you" vs "you asked to stop"):
  fixed. Status can be `paused`: the card says "Paused at your request", the index lists it
  under its own line. Commit hashes removed from the note.
- Codex 3 Material / Sonnet 4 (mobile strip not at the current phase; Now chip): fixed.
  The strip scrolls to the current phase; the chip reads "Now · Design · 13 of 20"; steps
  in view on the Map carry an outline (the viewport marker).
- Codex 4 Material (map arrives too late on desktop): fixed. The summary moved into
  "The short version", the title is smaller, the status note is clamped to three lines
  (click to read all), main rows 96 px: the Map now starts around 490 px and the current
  card sits in the first laptop viewport.
- Codex 5 Material / Sonnet 5 (mobile helper lanes anonymous): fixed. Each lane on phones
  shows a short name under its icon; helper rings carry the helper's name.
- Sonnet 2 (scroll pills over phase headers): fixed. They live in their own bar above the
  lanes, with the step and row count between them.
- Sonnet 3, 7d (cards and loop fragments peeking at the lane column): fixed. Sticky corner
  cells cover the header and footer rows; a fade follows the lane column.
- Sonnet 6 (mobile edge fades): already present on the right; left fade added.
- Sonnet 7 (pin on the REVIEW chip; bypass across "YOU"; loop label): fixed (pin moves
  left and up on gated steps; bypass starts left of the chip; label "Revise the draft").
- Sonnet 8c (design run waits on Claude but shows a reviewer step): title now "Claude runs
  the research gate next".
- Sonnet 9 (system map strip not tied to cards; labels; mobile wrap): the strip items
  already jump to and open their part (click) and light its links (hover); on phones the
  strip stacks vertically with downward arrows. Area-to-area arrows by default: declined,
  they cut through text (tried in round 1); "Show every link" stays opt-in.
- Codex 6 (mobile nav discoverability): fixed with a fading edge and the active page
  scrolled into view.
- Codex 7 (loop label): fixed as above. Codex 8 ("Four questions"): now "Five".
- Sonnet 10 (drawer notes): fixed (crumb shows the phase; focus goes to the panel, no ring;
  no duplicate chip; dead `open=1` branch removed).
- Sonnet 11 (index dead space): flow and roster cards keep their picture right under the
  question; the footer takes the slack.
- Sonnet 12 (footer "not yet checked"): pages are stamped before delivery.
- Codex 9 / Sonnet 13 (visual identity; group by model): noted for the owner's iteration.

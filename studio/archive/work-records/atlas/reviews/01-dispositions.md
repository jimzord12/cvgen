# Round 1 dispositions (lead, 2026-10-01)

Reports: `01-sonnet.md` (Sonnet 5.5, FINDINGS, 7 Material) and
`01-codex-gpt-6.1-sol.md` (GPT-6.1 Sol high via Codex, FINDINGS, 1 Blocking, 7 Material).

## Codex

- C1 Blocking (optional look drawn as a required gate): fixed. Steps can be
  `optional`; the Map draws them dashed, off the main route (dashed side links), the
  card says "Your move · optional". The design-run status moved to the research gate,
  waiting on Claude; your look is an optional item under "Your moves" on the index.
- C2 Material (current step not visible, no overview): fixed. The phase strip now sits
  above both views as the overview, marks the steps in view, and has a "Now · N" jump;
  the Map opens centred on the current step; scroll cues show "N earlier" and "N more".
- C3 Material (lane density): fixed. Rows of actors that only help are 52 px "helps"
  rows; main rows 104 px (was 118).
- C4 Material (main route weak): fixed. Route lines are brighter and thicker with
  larger arrowheads; helper lines fainter; loops thinner.
- C5 Material (mobile navigation, walk-through position): fixed. The nav wraps to its own
  scrollable row with the current page scrolled into view; the strip's "Now" jump and a
  "Now: step N" link in every step card replace the hidden rail.
- C6 Material (too much before the mechanism): fixed. The three points fold into "The
  short version" (remembered per page); the hero is shorter; the Map starts about 250 px
  higher.
- C7 Material (system map shows no relations): fixed with a "main line" strip across the
  top (facts → candidate.json + cv.typ → Template → cv.py render → Revision → your review);
  every part shows its link count; hover or tap lights its links; "Show every link".
- C8 Material (familiar dashboard look): partly fixed. The index cards now show a miniature
  of each flow's swimlanes (the route, your gates in gold, a ring at "now") or of the
  system's areas instead of repeated text; the roster leads with a "Models in use" panel
  and a model line per agent. A deeper visual identity is left for the owner's iteration.
- C9 Minor (drawers): fixed. The drawer is a floating panel sized to its content, with
  previous/next beside the title (named in tooltips) and "Next: <step>" in the footer.
- C10 Minor (contrast, sources): fixed. Muted and faint text darker in light and lighter in
  dark; sources folded into a "Sources N" toggle.

## Sonnet

- S1 Material (drawer shadow leaking): fixed (shadow and visibility only when open).
- S2 Material (system map): fixed as C7; the drawer lists "Feeds into" and "Fed by" (it did
  for linked parts; the one unlinked part now has a link); mobile says "Tap a box".
- S3 Material (opens mid-flow, no cues): fixed as C2.
- S4 Material (map too low, tall empty lanes): fixed as C3 and C6.
- S5 Material (walk-through opens at step 1): the page already opened at "now"; the
  screenshot tool forced step 1. The tool no longer does; every card links to "Now".
- S6 Material (mobile lane column 45%): fixed. 62 px icon column on phones; the actor's
  name moves onto each card.
- S7 Material (inconsistent "where it stands"): fixed by C1: both pages now say the
  gates are next, waiting on Claude, and the client page links to the design-run step.
- S8 Minor (duplicate gold boxes, empty "Takes", stray "!"): fixed (one box; empty
  columns hidden; owner commands carry a "You run" label).
- S9 Minor (clipped loop label): fixed (labels never sit under the lane column).
- S10 Minor (legend colours not unique): fixed (legend lists kinds only).
- S11 Minor (card dead space): fixed (areas align to the top).
- S12 Minor (roster model signal, matrix): fixed ("Models in use" panel, model line on
  each card, "Who works where" as a tab with 13 px squares, idle rows folded).
- S13 Minor (index): fixed (compass hidden on phones; 3 + 2 card layout).
- S14 Minor (light contrast): fixed as C10.
- S15 Note (footer "not verified"): reworded; pages are stamped before delivery.

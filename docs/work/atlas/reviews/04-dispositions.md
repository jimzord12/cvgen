# Round 4 dispositions (lead, 2026-10-01)

Reports: `04-sonnet.md` (PASS, 10 Minor, 3 Notes) and `04-codex-gpt-6.1-sol.md`
(FINDINGS: 1 Material, 4 Minor, 2 Notes). Context review round 2 (`04-context.md`):
PASS, 3 Minor, Notes.

## Visual

- Codex 1 / Sonnet 5 (current card below an 800 px laptop fold): fixed. When the
  current card would land below the fold on desktop and the link names no view, the
  page scrolls on load so the Map's header sits under the top bar, or the current card
  sits at 40 % height, whichever scrolls less. Verified in real Chrome at 1440 x 800
  (viewport 758): "You are here" on the Research gate, the Design gate and "The author
  revises" all in view (`shots14/dr-laptop-chrome.jpg`). Headless Edge captures the
  page before that scroll, so its full-page shots still show the hero; the effect is
  for a person opening the page.
- Codex 3 / Sonnet 2 (matrix phase labels clipped, counting squares): fixed. Each
  phase header now shows its step range ("1–3", "4–7") at the width of its squares,
  with the phase name in the tooltip.
- Codex 4 (mobile arrow reads as "next"): fixed. A "Pages" button opens the palette,
  which lists every page.
- Codex 5 / Sonnet 4 (card remnants beside the lane column): fixed. A card whose left
  edge is under the lane column is hidden; the "N earlier" count carries it.
- Codex 7 / Sonnet 11 (footer "not yet checked"): fixed. Every page is checked against
  its sources by the context review and stamped; `atlas.lock.json` is committed.
- Sonnet 1 ("Your own look (optional)" cut): fixed. Title is "Your own look"; the card
  keeps its "optional" tag.
- Sonnet 8 (mobile legend wraps): fixed. Smaller type and shorter swatches on phones.
- Sonnet 12 ("Nothing is blocked" above a paused card): fixed. The line reads "Nothing
  is blocked on you right now; 1 decision parked by you."
- Codex 2 / Sonnet 10 (system-map lit links cross card text): accepted, as in round 3.
  It shows only while a node is hovered or open; routing every link through gutters is a
  layout engine of its own.
- Sonnet 7 ("marine: skip design" pill touches the phase header): accepted. Readable,
  one pill on one page.
- Sonnet 3 (mobile matrix, other flows off-screen), 6 (roster hero space), 9 (index
  dead space): accepted for this version; to revisit when the owner iterates.
- Codex 6 / Sonnet 13 (carry the route language into roster and system map): noted for
  the owner's first iteration.

## Context round 2

- Minor 1 (`n-concepts` shows Densities as current): fixed. "Styles and Tiers
  (Densities arrive with the 2026-09-29 run, on its branch)".
- Minor 2 (`n-ci` "every push to `main`"): fixed. "Every push and every pull request".
- Minor 3 ("my recommendation"): fixed. "Claude's recommendation".
- Note, Sweep step leaves out the `Atlas` line: fixed, and its citation widened to
  `docs/development.md:58-92`.
- Note, portrait unconditional: fixed ("a portrait when the idea needs one").
- Note, "Not my style" drops "keep it": fixed.
- Note, AGENTS.md row: fixed ("changed or were never checked").
- Notes on `git:` citations naming local branches, the Codex "approved" defaults, the
  deliver order and status refs: accepted for now. The run-branch citations are
  repointed to `main` when the run merges; `check` will report them then.

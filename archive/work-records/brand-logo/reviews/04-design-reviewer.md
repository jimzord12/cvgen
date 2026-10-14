# Design review: applying the needle's eye (design-reviewer)

Stored as returned, abridged to findings; dispositions at the end.
Snapshot: main at f91987f (previous 028689e), 2026-09-28.

## Checks

- Scope: 028689e..f91987f touches only the two SVGs, brand/README.md, the
  AGENTS map line and Night Shift history.
- Wordmark: only desc, the C (eye subpath plus evenodd) and the split first
  thread-over path changed; V, tail and "gen" 0 changed pixels; the CV area
  pixel-identical to the approved cvgen-mark-c-eye.svg.
- Reversed eye: renders identically to a recoloured eye mark (0 px);
  letters #F4EFE6, thread #C07B45; eye interior transparent.
- Even-odd and nonzero: 0 differing pixels in both files.

## cvgen-wordmark.svg: PASS
Layering correct at 6x and 24x. Inherited D8 (0.04-unit step, 24x only)
and D7 (eye reads as a highlight at 32 px).

## cvgen-mark-c-eye-reversed.svg: PASS
- D15 Nit: the desc drops the colour values and the font/OFL credit.

## brand/README.md: FINDINGS
- D12 Blocking: the "Still needed" list still said "owner to pick" for the
  redraw, wordmark, small variant and colours, contradicting the new top
  section. Say what is settled and what is actually open; if the owner has
  not approved the wordmark, small cut and colours as final, say so.
- D13 Nit: line 45 still in the future tense; the wordmark's history entry
  describes the plain-C file.
- D14 Note: no dark wordmark and no one-colour version yet.

## Verdict: FINDINGS

## Dispositions (lead)

- D12 fixed: the list is now a dated status: the C settled by the owner;
  wordmark, small, avatar and colours in use as drafted but not reviewed
  one by one by the owner; open items named (dark wordmark, one-colour,
  flattened outlines, 16 px cut).
- D13 fixed. D14 recorded in the open items. D15 fixed (desc restored with
  font credit and colours).

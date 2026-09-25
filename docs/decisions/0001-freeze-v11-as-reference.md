# 0001. Freeze v11 as the pixel-exact reference

Date: 2026-09-09
Status: Accepted. Paths amended by 0010 and 0011: the reference now lives at
`packages/cv-engine/domains/marine/templates/flagship/tests/approved/Marine-Engineer-CV-v11.pdf`
and the example at `examples/marine/flagship/engineer.typ`; the decision is unchanged.

## Context

Eleven design revisions were reviewed in one day. The owner approved revision
11. Extracting a component library from a moving target had already been
paused twice. A library that "looks about the same" would drift with every
refactor.

## Decision

`reference/Marine-Engineer-CV-v11.pdf` is frozen. `examples/engineer.typ`
must render pixel-identical to it at 144 dpi with identical normalised text
on every page. Every input the comparison depends on is hashed in
`tests/baseline.json`. Changing the reference requires a new ADR, a new
versioned PDF and a manifest regeneration.

## Consequences

- Any refactor of `src/` is safe to attempt: the suite says yes or no.
- Visual improvements to the engineer look are deliberate events, not side
  effects.
- New themes and roles are free to differ; only the engineer example is
  bound.
- The comparison is only meaningful under the pinned Typst and renderer
  versions recorded in the manifest.

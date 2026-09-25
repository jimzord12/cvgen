# 0012. The Framework and the domains are separate packages

Date: 2026-09-25
Status: Accepted. Amends 0011 (the domains leave the engine package; the
single `lib.typ` becomes two) and the paths of 0001, 0008 and 0010.

## Context

ADR 0011 made the core domain-neutral in its imports: `core/` never imports
from `domains/`, and the suite checks it. The packaging still tied them
together. The domains lived inside the engine package
(`packages/cv-engine/domains/`), and its one public surface, `lib.typ`,
exported the core together with marine and Flagship. Importing the shared
core meant importing marine.

On 2026-09-25 the owner decided to decouple the framework from the domains
("yes, it should not be that difficult"), and settled the words: the
shared core is the `Framework`, a career area is a `Domain`
(`docs/glossary.md`). The same day he approved a client workflow in which a
client whose domain does not exist yet gets a one-off `Template` in their
`Envelope`; such a design needs the core without marine.

## Decision

- **Two places.** `packages/cv-framework/` holds the Framework: `core/`,
  `fonts/`, `licenses/`, `typst.toml` and a `lib.typ` that exports core
  names only. `packages/domains/<domain>/` holds each domain, today only
  `marine`, with everything it held before.
- **One surface per domain.** `packages/domains/marine/lib.typ` exports
  every name the old `lib.typ` exported: the Framework's names (through
  `cv-framework/lib.typ`), marine, and Flagship with its deprecated wrappers.
  Marine entry points change only their paths; a one-off `Template` with no
  domain imports `packages/cv-framework/lib.typ`.
- **One direction.** Nothing in `cv-framework/` imports a file in, or names
  a path under, `domains/` (a domain passes its own SVG paths in at render
  time); a domain file reaches the core by a relative path through
  `cv-framework/core/`. `tests/run.py` asserts both, on imports and on file
  paths in code.
- **Schema choice.** `cv_workflow/validate.py` treats marine's `lib.typ` as
  the old `lib.typ` (Flagship's contract); the Framework's `lib.typ` alone
  names no contract.

## Consequences

- Easier: a new domain, or a client's one-off `Template`, builds on the
  Framework without importing marine; each domain's `lib.typ` is its own
  namespace, so the prefixed-names rule of 0011 is no longer needed.
- Harder: every path under `packages/cv-engine/` changed once. Examples,
  fixtures, scripts, the workflow, current docs and the hash keys in
  `tests/baseline.json` were rewritten; the hashes themselves did not change
  and the engineer example still matches the frozen v11 reference pixel for
  pixel. History records (`docs/work/`, earlier ADRs, `docs/history.md`,
  proposals) keep the paths they were written with.
- The two private compositions' engine paths (their import lines and one
  asset path) are rewritten when this change merges, with the owner's
  consent; copies with the same rewrite render pixel-identical to their
  approved `reference.pdf` at 144 dpi, and the real files are compared
  again after the rewrite. Revisions
  rendered before the split keep a snapshot of the old `cv.typ`; their PDFs
  stand, but recompiling such a snapshot needs the old layout (any commit
  before this ADR).
- A revision's `render.json` records `engine.packages` (a list: the
  Framework and the domains) instead of `engine.package`; revisions made
  before the split keep the old key. Nothing reads either key yet; a
  future reader must accept both. The schemas' `$id`s changed with their
  paths.
- `typst.toml` now describes the Framework (`cvgen-framework`); marine is not
  a standalone Typst package, because it imports the Framework by a relative
  path outside its folder. Publishing packages stays future work.

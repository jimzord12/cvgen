# 0005. Restructure the repository for coding agents

Date: 2026-09-12
Status: Amended by 0010 for the next repository layout. The historical cleanup remains valid.

## Context

The repository carried eleven design revisions, fifteen review PDFs, ten
per-revision verification files at the root, Greek documentation and a
README written as a changelog. The active library was correct but hard to
find. The owner intends to keep developing with coding agents and wants a
tree that is navigable without reading history.

## Decision

- Remove flagship iterations 04 to 10 with their renders and verification
  records. Keep the four distinct studies under `designs/` as frozen worked
  examples. Everything removed stays under tag `archive/pre-restructure`.
- Rename `roles/` to `artwork/`; fold the duplicate theme into
  `golden-blue.typ`; move fixtures under `tests/fixtures/`, the frozen PDF
  under `reference/`, deliverables under `exports/`.
- Remove the legacy flat-schema adapter and its data files. Tests use the
  native schema.
- Replace Greek guides with an English documentation set: vision,
  architecture, tech stack, constitution, conventions, git workflow, history,
  per-concept references, ADRs, a JSON Schema, a build guide.
- Add `AGENTS.md`, `CLAUDE.md`, three project skills and a CI workflow.
- Add `typst.toml` so the library is a proper package.

## Consequences

- The engineer example still matches v11 exactly; the suite passed before
  and after.
- Anyone needing an intermediate revision checks out the tag.
- Docs have one language and one place per concept. Adding a concept means
  adding a file and a row in `AGENTS.md`.
- The hash manifest went from 45 to 31 entries. It now covers every asset
  and font, both example JSON files, the reference PDF, and the four design
  studies with their data.

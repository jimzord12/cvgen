# 0007. A family of templates over one shared core

Date: 2026-09-12
Status: Amended by 0010 for ownership, schemas, and folder migration. Its amendment of 0002 and deck/engine variations remain valid.

## Context

The product is a set of polished CVs for merchant marine seafarers. The
owner's direction, stated 2026-09-12: several named templates, each able to
render a deck officer and an engineer, each with two to four themes, and a
one-page layout for cadets. The documentation written during the
restructure inferred "one template family" from the code and recorded it as
a principle.

Two real CVs produced with this library both bypass the Flagship template
and compose the modules by hand. The reason is data, not taste: real deck
careers are recorded as contract periods, which the schema cannot express;
the synopsis metrics differ; the approved designs use a three-column
certificate table and the skills section. The fictional captain example
only fits because its data carries service months.

## Decision

- **A template is a named design.** Flagship is the first. A template owns
  its section components, its layout profiles and its frozen reference
  render. Templates are named after the design, never after a role.
- **Deck and engine are variations of every template**, expressed through
  candidate data, the artwork pack and copy strings. No template is forked
  by role. Where a section must genuinely differ, the template offers a
  slot or a data-selected variant.
- **One shared core.** The candidate contract and schema, normalisation and
  totals, the page shell, page plan validation, SVG recolouring, the
  component contract and the verification suite are shared. Each template
  owns its page loop and the overflow assertion inside it. A template
  never defines its own data model, so a candidate can change template
  without re-entering a career.
- **Promotion by the rule of three.** A section moves from a template into
  the core when a third template needs it unchanged. Not before.
- **Folder split when the second template starts.** `src/core/` for the
  shared layers, `src/templates/<name>/` per template. Until then `src/`
  holds the core and Flagship's sections side by side, with the Flagship
  composition already under `src/templates/flagship.typ`.

Approved by the owner in conversation on 2026-09-12.

## Consequences

- Every approved template gets its own frozen reference and pixel gate;
  constitution section 1 is generalised accordingly.
- Roadmap item one is deck data: contract periods in the schema, synopsis
  metrics declared by data, a certificate table with configurable columns,
  the skills section available inside the template. Until that lands, real
  deck CVs use the custom-composition path in the build guide.
- Thirty CV variants from five templates, two roles and three themes cost
  five section sets, two artwork packs and three token files. A role fork
  would double the section sets forever.
- `AGENTS.md`, `README.md` and `docs/architecture.md` describe the current
  single template as current state, not as a rule.
- A `new-template` skill is written when the second template begins.

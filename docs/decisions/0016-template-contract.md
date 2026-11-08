# 0016. Template Contract: Template Variations and versioned Domain Contracts

Date: 2026-11-04
Status: Accepted. Stage 1 (contracts, manifest, suite and render checks) built
2026-11-04, review fixes 2026-11-08; Essential (TASK-67), the choice step
(TASK-66) and Stage 2 with the input schemas (TASK-68) are not. Amends 0002,
0007, 0010, 0011 and 0012.

## Context

A client's designed CV was called beautiful but not practical for ordinary
jobs, and the research in `docs/research/junior-roles-cv-format.md` agrees: one
full page and a strict hierarchy. The engine could not offer a calmer version of
a design. Nothing recorded a client's choice in a form a tool can read. A
`Domain` and a `Template` were tied field by field through two schemas, and
facts a design did not show dropped out unnoticed. The owner approved
[P-0019](../proposals/template-contract.md) with all its decisions on 2026-11-04;
that proposal holds the full design and its examples. This decision amends ADR
0007 and 0011 on what a `Template` is, ADR 0010 on `Template` input schemas, and
ADR 0012 on what the `Framework` owns; it adds an input to the list in ADR 0002.

## Decision

- **A `Template` is a design language** with a `Template Manifest` and at least
  one `Template Variation`. A `Template Variation` inherits and never copies: it allows
  `Layout`s, `Theme`s and `Artwork Pack`s, sets `copy`, overrides named slots,
  and has its own design bar, set by the owner when he approves the design, and
  its own `Frozen Reference`. Today's Flagship becomes `showcase`. A one-off
  `Template` has neither a manifest nor a `Template Variation`.
- **A `Domain Contract` extends the `Base Contract`.** Required in the base:
  `identity`, `contacts`, `experience`. Optional: `profile`, `education`,
  `languages`, `certificates`. A `Fact Group` is supported whole. Its
  `schemaVersion` rises on a breaking change; the contract's `version` rises on
  any change. The contract is closed and is the one statement of a `Domain`'s
  facts; a `Template`'s schema keeps only what it adds, today `copy`, and its
  adapter stays.
- **A record states its version** in `candidate.json`; none means 1.
- **A `Client`'s choice is recorded:** `template` and `variation` in
  `envelope.json`, written at `design.entry-point`.
- **Claims are proved.** Each `Template Variation` claims `Domain Contract`
  versions and optional groups; the suite renders a `Coverage Fixture` and looks
  for its markers. A render stops on a missing required group, warns on a dropped
  optional one, and the `Meta File` records what was dropped.
- **Built in two stages.** Stage 1 keeps every `Domain Contract` at version 1.
  Stage 2, the group-by-group comparison and `oldestSupported`, is built when a
  contract first reaches version 2.

## Consequences

- Most `Domain` changes need nothing from a `Template`'s author. There is still
  one live engine, so a breaking change costs its author a choice: keep reading
  the old shape, or raise `oldestSupported`, which cannot pass a version the
  frozen records use without a new `Frozen Reference`.
- The closed Flagship input schema and the suite's equal-definitions check go
  when Stage 1 reaches them; ADR 0010's "owns its input schema" narrows to what a
  `Template` adds.
- The contract was designed with one `Template` and one `Domain`, against
  constitution section 9's caution; the owner chose this investment. The travel
  `Domain` may revise it.
- A suite case proves coverage, not capacity. Whether a career fits stays with
  the `Frozen Reference`s and the overflow check.

# Architecture decision records

One file per decision that shapes the code and is expensive to reverse.
Numbered. After acceptance only the Status line changes, to record that a
later decision amends or supersedes this one; the later decision says so in
its own Status line and Context.

Template:

```markdown
# NNNN. Title

Date: YYYY-MM-DD
Status: Accepted | Amended by NNNN | Superseded by NNNN
(a short reason may follow the status word)

## Context
What was true and what forced a choice.

## Decision
What we do, in one or two sentences.

## Consequences
What becomes easier, what becomes harder, what the suite enforces.
```

| ADR | Decision |
|---|---|
| [0001](0001-freeze-v11-as-reference.md) | The approved v11 render is a frozen, pixel-exact contract |
| [0002](0002-five-independent-inputs.md) | Five independent inputs. Its "one template" clause is amended by 0007 |
| [0003](0003-explicit-pagination.md) | Page allocation is explicit and validated, never automatic |
| [0004](0004-hidden-durations-keep-geometry.md) | Hiding durations reserves geometry and emits no text |
| [0005](0005-restructure-for-agents.md) | Prune history, keep four studies, English docs, agent entry files |
| [0006](0006-typst-stays.md) | Typst stays as the page engine; React and headless Chromium rejected on evidence |
| [0007](0007-family-of-templates.md) | A family of templates over one shared core; deck and engine are variations, never forks. Amends 0002 |
| [0008](0008-component-contract.md) | One React-inspired component contract: ctx first, data, props, slots, scoped styles |
| [0009](0009-framework-not-a-cage.md) | The framework is the happy path, not a cage: bypass components freely, log every bypass, never bypass rules |
| [0010](0010-public-monorepo-and-pdf-workflow.md) | Public monorepo, template-owned input schemas and presentation, separate PDF workflow, private revisions and hash-based approval. Engine layout and local PDF workflow implemented 2026-09-16; web application pending. Amends 0005 and 0007. |
| [0011](0011-domains-roles-templates.md) | A CV library for any field: domain > role > template, dictionaries merged domain < role < template, neutral core, marine as the first domain, project renamed. Amends 0002, 0007 and 0010. |

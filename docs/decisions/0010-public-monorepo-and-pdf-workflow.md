# 0010. Public monorepo, template ownership, and PDF workflow

Date: 2026-09-15
Status: Accepted. Amends 0005's target folder organization and 0007's ownership,
schema, and folder-split decisions. Implementation is pending.

## Context

The owner approved a future public web application after the CV engine becomes
stable. With two real CVs and no market feedback yet, enforcing extensive
sharing between template implementations would commit to assumptions too early.
Candidate facts should remain portable, while each template controls its input
shape and presentation. Delivery also needs a programmatic record of the
owner's approval of an exact PDF.

The owner approved the complete layout and lifecycle in conversation on
2026-09-15 and requested its removal from proposals.

## Decision

Adopt the public monorepo and PDF lifecycle specified in
[PDF workflow and storage](../pdf-workflow.md). Keep candidate facts separate
from template inputs, rendering separate from approval and delivery, and each
generated candidate revision in a permanent private folder.

- `packages/cv-engine/` owns the candidate contract, rendering, fonts, and
  templates. Each template owns its input schema, adapter, components, themes,
  layouts, artwork, assets, and approved design references. Deck and engine
  remain variations of a design. Existing module conventions remain applicable
  during migration; this decision does not perform a component rewrite.
- `packages/cv-workflow/` owns revision creation, checks, approval, and export.
  Local commands call it first; `apps/web/` later supplies the hosted interface.
  These package boundaries do not require separate network services.
- `examples/` holds fictional candidate datasets and template examples. Root
  `exports/` remains a fictional gallery; historical studies move together into
  `archive/design-studies/`. Frozen content and comparisons are preserved.
- Candidate records, original sources, input snapshots, revision PDFs, and
  candidate exports stay in ignored `private/` workspaces locally. Future
  production storage is private, durable, and outside the source checkout.
- A PDF is reviewed in its revision folder. Explicit owner approval creates a
  sidecar bound to its SHA-256 and revision. Export verifies that approval and
  copies the same bytes; automated tests never grant approval. Signatures are
  deferred. Export and actual delivery are separate actions.

## Consequences

- Current implementation maps and commands remain accurate until migration;
  agents use the approved target when planning structural or workflow changes.
- The current top-level candidate schema describes Flagship inputs. Migration
  must separate that input contract from the central candidate-facts contract.
- Candidate runs will use fresh private revision folders instead of disposable
  root build folders. Public example/test runs continue using fresh `builds/`
  folders. The no-overwrite rule and explicit cleanup checkpoints remain.
- Frozen PDF bytes and visual comparisons survive path changes; the manifest,
  imports, packaging, and verification paths must change together and pass the
  suite. Approving this architecture grants no candidate PDF approval or merge.
- The target replaces the requirement to wait for a second template before
  reorganizing ownership. Implementation tasks and migration sequencing remain
  to be planned; the web application is not implemented by this decision.

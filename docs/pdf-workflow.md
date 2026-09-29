# PDF workflow and storage

Read when discussing the monorepo boundaries, where a candidate PDF lives,
or where any PDF someone will review goes (the `Output Contract`, below).
Status: Approved by the owner in conversation on 2026-09-15; recorded in
[ADR 0010](decisions/0010-public-monorepo-and-pdf-workflow.md). The source
tree below is implemented for the engine (`packages/cv-framework/` and
`packages/domains/` since ADR 0012, `examples/`, `archive/`) and for the local workflow (`packages/cv-workflow/`,
`scripts/cv.py`) since 2026-09-16; `apps/web/` is not implemented.
The commands are in `docs/guides/build-a-cv.md`; the package's own README
describes the records it writes.

## Ownership

Each PDF revision has one permanent home. Approval adds a sidecar [a companion
metadata file]; export copies the approved bytes into a delivery folder.

The approved target public source tree, with the engine organised by domain
since ADR 0011 (2026-09-21) and split into the Framework and the domains
since ADR 0012 (2026-09-25), is:

```text
apps/
  web/                          # Future submission, review, and download UI
packages/
  cv-framework/                 # The Framework; imports no domain
    lib.typ                     # Core exports only
    core/                       # Domain-neutral core
    fonts/
    licenses/
  domains/
    marine/
      lib.typ                   # Marine surface: Framework names, marine, Flagship
      domain.typ  data.typ      # Domain node; marine facts, totals, row model
      schema/                   # Marine candidate facts contract
      assets/                   # SVG files shared by the domain's templates
      roles/deck/ roles/engine/
      templates/
        flagship/
          schema/               # Flagship input contract
          adapter/              # Candidate facts -> Flagship input
          components/
          themes/
          layouts/
          artwork/
          tests/approved/       # Frozen fictional design reference
  cv-workflow/                  # Revision creation, checks, approval, export
scripts/                        # Local commands calling the workflow
examples/
  candidates/                   # 3-5 fictional datasets
  marine/flagship/              # Entry points using those datasets, each with its
                                #   Release PDF and Meta File beside it
builds/                         # Disposable public example/test output
docs/
archive/design-studies/          # Historical studies, inputs, and previews
archive/anti-examples/          # Designs the owner rejected as not his style (frozen)
design-concepts/                # Proposed template concepts (idea-run skill), each PDF
                                #   with its Meta File; fonts/ shared
private/                        # Local candidate workspaces; Git-ignored
```

The engine renders from supplied inputs and returns a PDF or structured errors.
It does not manage accounts, approval, storage policy, or delivery. The workflow
owns those document operations; local commands and the future web backend call
it. These are ordinary package boundaries, not separate network services.

## A local candidate workspace

This schematic candidate name does not identify a real person:

```text
private/<candidate>/
  envelope.json                 # Who the client is: alias, domain, candidate, rank;
                                #   render refuses without it
  candidate.json                # Working candidate record
  cv.typ                        # Entry point: template, theme, artwork, layout, page plan
  intake/ research/ draft/      # Client workflow drawers: messages and documents,
                                #   research, text drafts and Sign-off
                                #   (docs/guides/client-workflow.md)
  assets/                       # Optional: prepared portrait; a portrait at the
                                #   folder root works too (docs/guides/build-a-cv.md)
  revisions/<revision-id>/       # Fresh timestamp + unique suffix for each run
    inputs/
      cv.typ                    # Entry point as it was, verbatim
      candidate.json            # Snapshot used by this revision
      assets/                   # Copies of candidate assets actually used
    render.json                 # Selection, effective settings, versions, PDF hash
    render.log                  # Compiler output, including failed runs
    checks.json                 # Automated checks and their result
    cv.pdf                      # Created on successful rendering
    cv.meta.json                # Its Meta File: status render, approved, then delivered
    cv.approval.json            # Created only after explicit owner approval
  exports/<revision-id>/
    cv.pdf                      # Byte-identical delivery copy
    cv.approval.json            # Copy of the approval receipt for internal use
```

The revision snapshot is fixed before compilation and compiles on its own:
the entry point imports the engine by root-absolute path
(`/packages/domains/marine/...` for marine, `/packages/cv-framework/...` for
a one-off `Template` with no domain), and the snapshot record's `identity.portrait`
points at the copied asset under `inputs/assets/`, which `render.json`
records next to the original path and the working record's hash. Other
workspace files the entry point reads by a literal relative path (and its
local `.typ` helpers read) are copied to the same place under `inputs/` and
listed with their hashes in `render.json` (`inputs.files`). Rendering
never rewrites an existing revision PDF. A failed or corrected run gets a new
revision folder. `render.json` records the engine commit, the compiler
version, the entry point's imports (template, theme, artwork, layout) and the
compiler inputs, and flags uncommitted engine changes; recording a version
alone is not a guarantee that such a development run can be reproduced.

## Output Contract

Every PDF we show someone (a concept, the `Release`, a client's `Text Draft`
or CV) sits in the one home its kind has, with a `Meta File` beside it that
says what it is (owner, 2026-09-30; [the proposal](proposals/output-contract.md)).
`archive/` is outside the contract: its PDFs are frozen records, not review
targets, and carry no `Meta File`.
Nothing infers a PDF's meaning from where it happens to lie, and a PDF
without a valid, current `Meta File` shows up as a problem, never silently.

| `kind` | Home | `status` |
|---|---|---|
| `concept` | `design-concepts/<date>-<slug>/<density>/<tier>/<density>-<tier>.pdf` | `proposed`, `chosen`, `parked`, `rejected`, `unresolved` |
| `text-draft` (a `Text Draft` direction, earlier flat runs) | `design-concepts/<date>-<slug>/concept.pdf`, `concept-<variant>.pdf` | as `concept` |
| `example` (the `Release`) | `examples/<domain>/<template>/<name>.pdf`, beside `<name>.typ` | `release` |
| `client-draft` (a client's `Text Draft`) | `private/<envelope>/draft/draft-NN.pdf` | `sent`, `signed-off`, `superseded` |
| `client-cv` | `private/<envelope>/revisions/<id>/cv.pdf`; `private/<envelope>/reference.pdf` for a CV delivered before `cv.py` | `render`, `approved`, `delivered` |

- The `Meta File` is `<pdf-stem>.meta.json`, valid against
  `packages/cv-workflow/cv_workflow/output.schema.json` (`contract:
  cvgen.output/1`). It always holds `kind`, `domain`, `candidate`, `pages`,
  `date`, `status` and the PDF's `sha256`; a concept also `style`, `density`
  and `tier`, an example `style` and `source`, a client PDF `alias`.
  `domain` is an id from the glossary's `Domain` row (`marine`, `travel`).
- `python scripts/outputs.py stamp <pdf> status=<status> [key=value ...]`
  writes it. It computes `pages`, `sha256` and `date`, takes `kind` (and
  `density`, `tier`, `source`) from the PDF's place (a flat earlier run
  passes `kind=text-draft`), copies `alias`,
  `domain`, `candidate` and `rank` from the client's `envelope.json`, keeps
  an earlier `Meta File`'s other fields, and refuses a PDF outside a home.
- A `Meta File` whose hash no longer matches its PDF is stale. Every
  recompile needs a re-stamp (Typst embeds the compile time).
- Who stamps: `cv.py render` (`render`) and `cv.py approve` (`approved`);
  `scripts/build.ps1 -Release` (`release`); the `magazine-editor` after
  every compile (`proposed`); the lead for a client's `Text Draft` and for
  every later status change (an owner's verdict on a concept, a
  `Sign-off`, a delivery).
- `python scripts/outputs.py check` lists every PDF in `design-concepts/`
  and `examples/` (and a stray root `exports/`, which is retired) with no
  valid, current `Meta File` or outside a home; `--private` adds the client
  homes. `python tests/run.py` fails on any, and the `Design Review` app,
  which reads `Meta File`s only, lists them as unindexed with the reason.
  `builds/`, an `Envelope`'s `exports/` bundles and its `intake/` documents
  are not review targets and are never indexed.

## Lifecycle

1. **Prepare and render.** Snapshot the working inputs into a new revision and
   ask the engine to render there. Keep compiler errors with that revision.
   A workspace without `envelope.json` is refused before anything is
   written; a new PDF gets its `Meta File` (`status: render`).
2. **Check and review.** Automated checks must pass before approval. The owner
   reviews that revision's `cv.pdf`; review does not move or regenerate it.
3. **Approve.** An explicit owner action tied to the reviewed revision and hash
   creates `cv.approval.json`. It records revision ID, SHA-256, approver, and
   approval time. Before writing it, verify that the reviewed bytes still match.
   A passing test or an agent's quality judgment cannot grant approval. The
   revision's `Meta File` is re-stamped `approved`.
4. **Export.** Read the authoritative receipt from the revision, verify the PDF
   hash and passing checks, copy into a fresh export folder, and verify the copy.
   A missing receipt, failed check, or mismatch blocks export. Never recompile
   for export. Repeating a completed export verifies and returns the existing
   matching bundle; it never overwrites a different one or exposes a partial copy.
5. **Deliver.** Hand over the verified export PDF. The receipt is internal and
   need not be sent to the candidate. Export means ready for delivery; actual
   sending or downloading is a separate action. The future web backend checks
   the authoritative approval and exact stored bytes before making them available.

Editing the working candidate record starts a new revision; approval of an old
revision stays attached to its old bytes. The new revision inherits no approval.
An export folder name or a user-supplied receipt never establishes approval.
The local workflow trusts its controlled workspace; the web app must restrict
approval writes to the authenticated owner. Digital signatures are deferred.

## Local operation and future hosting

Initially the operator uses local render, approve, and export commands under
`scripts/`. The future web UI invokes the same workflow through its backend,
with compilation run as a background job. No hosting framework is selected here.

In production, candidate files and PDFs belong in private durable storage
[file storage that survives deployments], outside the public source checkout.
Database records can track jobs and approvals. The revision/hash contract stays
the same; the backend's controlled approval record is authoritative, and exported
sidecars are copies. The local `private/` tree illustrates the organization,
not a requirement to store customer files on a deployed application's local disk.

## Retention and migration

Retain approved revisions and their delivery copies. Failed or unapproved
revisions can be cleanup candidates; removing one needs the owner's go
([preferences.md](preferences.md#what-he-decides-and-what-agents-decide)).
They are not part of a general `builds/` cleanup.

The public fictional gallery is the `Release` beside its entry points in
`examples/` (the root `exports/` was retired on 2026-09-30); candidate
exports stay in `private/`. A template's `tests/approved/` protects its design against unintended
changes; a candidate's approval sidecar records authorization to deliver that PDF.

ADR 0010 approves a change to output locations: candidate runs use fresh
private revision folders, while public tests/examples retain fresh build folders.
The engine migration (imports, package manifest, documentation and the
frozen-reference path, with the frozen PDF bytes preserved and the suite
passing) and the local revision workflow (`packages/cv-workflow/`,
`scripts/cv.py`, exercised end to end by the suite on a fictional workspace)
both landed on 2026-09-16. Approval of this design does not grant candidate
PDF approval; only `scripts/cv.py approve`, run by the owner on a reviewed
revision, does.

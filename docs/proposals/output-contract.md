---
kind: proposal
status: approved
revision: 1
---

# Output Contract: one home and one meta file for every PDF we show

## Problem

The owner reviews designs in the `Design Review` app (`scripts/design_review/`).
On its first day it missed things he expected to see:

- **A delivered client CV.** One client's delivered CV is
  `private/<envelope>/reference.pdf`. It was made before the `cv.py render` workflow, so it has no `revisions/`
  folder, and the app never looks there.
- **"Marine" in the Domain filter.** No marine PDF records its `Domain`
  anywhere. The app reads the domain only from a concept's `brief.md`.
- **The one-page cadet CV.** `examples/marine/flagship/deck-cadet.typ` exists,
  but its PDF is only ever built into `builds/`, which is disposable.

The cause is the same each time: the app infers metadata from wherever a file
happens to sit, and every agent and script places and names its PDFs its own
way. The root `exports/` folder shows the same drift. Git tracks only the four
`Release` PDFs there, yet on disk it also held eight old renders (the owner:
"it seems like a dump to me"). Its name also collides with
`private/<client>/exports/`, where `cv.py export` puts a client's approved
copy.

The owner's principle (2026-09-30): "keep things nice, simple and clean. The
repo is obviously gonna evolve and change. We should not be afraid to
re-structure it to be in optimal state to maximize navigation, understanding
and DX."

## Change

Three pieces. No database, no editing of metadata inside the app.

### 1. One home per kind of PDF

| Kind (`kind`) | Home | File |
|---|---|---|
| `concept` | `design-concepts/<date>-<slug>/<density>/<tier>/` | `<density>-<tier>.pdf` |
| `text-draft` (a `Text Draft` direction concept) | `design-concepts/<date>-<slug>/` (earlier flat runs) | `concept.pdf`, `concept-<variant>.pdf` |
| `example` (the `Release`) | `examples/<domain>/<template>/`, beside its entry point | `<name>.pdf` next to `<name>.typ` |
| `client-draft` (a client's `Text Draft`) | `private/<envelope>/draft/` | `draft-NN.pdf` |
| `client-cv` (a render) | `private/<envelope>/revisions/<id>/` | `cv.pdf` |
| `client-cv` (delivered before `cv.py`) | `private/<envelope>/` | `reference.pdf` (left in place) |

- The root `exports/` goes. The four `Release` PDFs move beside their entry
  points, named after them (`engineer.pdf`, `captain.pdf`,
  `captain-silver.pdf`, `chief-officer.pdf`), and the one-page cadet joins them
  as `deck-cadet.pdf`. The old versioned names (`Marine-Engineer-CV-v12.pdf`)
  become a `title` field in the meta file.
- `private/<envelope>/exports/` keeps its name and its job (`cv.py export`):
  there it really is an export. It is not a review target.
- `builds/` stays disposable and is never indexed.

### 2. A meta file beside every PDF

Every PDF in the table above has `<pdf-stem>.meta.json` beside it:

```json
{
  "contract": "cvgen.output/1",
  "kind": "example",
  "domain": "marine",
  "rank": "Deck Cadet",
  "candidate": "Nikos Example",
  "title": "Marine Deck Cadet CV",
  "style": "Flagship",
  "density": null,
  "tier": null,
  "lang": "en",
  "pages": 1,
  "date": "2026-09-30",
  "status": "release",
  "source": "examples/marine/flagship/deck-cadet.typ",
  "sha256": "…",
  "producedBy": "scripts/build.ps1"
}
```

- **Required:** `contract`, `kind`, `domain`, `candidate`, `pages`, `date`,
  `status`, `sha256`. The rest are optional; `density` and `tier` are
  required for `kind: concept` from the 2026-09-29 run on.
- **Vocabularies:** `kind` as in the table. `domain` is a lowercase id: the
  folder name under `packages/domains/` (`marine`) or, for a domain with no
  package yet, the id the glossary's `Domain` row lists (`travel`).
  `status` per kind: concept `proposed | chosen | parked | rejected |
  unresolved` (as in `design-concepts/README.md`); client-cv `render |
  approved | delivered`; client-draft `sent | signed-off | superseded`;
  example `release`.
- **Clients** also carry `alias` (`client-2026-09-01`). `candidate` is the
  display name; it stays inside `private/`.
- `sha256` is the PDF's hash. A meta file whose hash no longer matches its
  PDF is **stale**: the PDF was re-rendered without re-stamping.
- One small file per client says who they are, once:
  `private/<envelope>/envelope.json` (`alias`, `domain`, `candidate`, `rank`).
  Writers copy from it, so a render never guesses the domain.

### 3. One tool, and checks that fail loudly

`scripts/outputs.py`, with two commands:

- `stamp <pdf> kind=… status=… [field=value …]`: writes or refreshes the meta
  file. It computes `pages`, `sha256` and `date` itself, fills `domain`,
  `candidate`, `rank` and `alias` from `envelope.json` for a client PDF, and
  validates against `packages/cv-workflow/cv_workflow/output.schema.json`.
- `check [--private]`: every PDF in its home has a valid, non-stale meta
  file, and no PDF sits outside the homes above. It prints each problem and
  exits non-zero.

Who stamps:

- `cv.py render` stamps each new revision (`status: render`); `cv.py approve`
  re-stamps it `approved`.
- `scripts/build.ps1 -Release` rebuilds the `Release` in place beside the
  entry points and stamps each PDF. Plain `build.ps1` keeps writing to a new
  `builds/` folder and stamps nothing (constitution rule 2 is unchanged for
  builds; the `Release` is refreshed on purpose, and Git keeps its history).
- The `magazine-editor` stamps each tier after every compile. The lead stamps
  a client's `Text Draft` after compiling it.

Enforcement:

- `python tests/run.py` runs `outputs.py check` on the public tree
  (`design-concepts/`, `examples/`). A missing, invalid or stale meta file
  fails the suite.
- The `Design Review` app indexes meta files only. Any PDF in a home without
  a valid meta file shows in an "Unindexed" strip with the reason, so drift is
  visible, never silent.

## Backfill (part of applying this)

- The `Release`: move and rename the four PDFs, build `deck-cadet.pdf`, stamp
  all five.
- The earlier concept runs (2026-09-27, three `Text Draft` directions) and,
  when that branch merges, the 2026-09-29 run's 18 designs.
- On this machine only: `envelope.json` for the three clients and meta files
  for two clients' `reference.pdf` (`delivered`) and the third client's two
  renders (`render`, the rejected "Line Diagram") and two `Text Draft`s.

## Docs to update

`AGENTS.md` (the "Where things are" rows for `examples/`, `exports/`,
`design-concepts/`, the new `scripts/outputs.py`, the commands),
`docs/glossary.md` (`Release` location; new terms `Output Contract` and
`Meta File`), `docs/constitution.md` (rule 2's note on the `Release`),
`docs/pdf-workflow.md`, `docs/guides/build-a-cv.md` and
`docs/guides/client-workflow.md` (`envelope.json`, stamping), the `new-cv`,
`new-client` and `idea-run` skills, the `magazine-editor` and
`design-reviewer` profiles, `README.md`, `design-concepts/README.md`.

## Consequences

- One more small file beside each PDF (about 30 today), and every writer must
  stamp. The suite and the app make a missed stamp visible at once.
- Typst embeds the compile time, so every recompile changes the hash and
  needs a re-stamp. That is intended: a stale meta file is exactly the drift
  this catches.
- Links to `exports/*.pdf` from outside the repository break. None are known.
- Frozen references are untouched: `F/tests/approved/` and
  `tests/baseline.json` hash sources and the frozen PDF, not `exports/`.

## Recommendation

Apply as described, in one branch: the tool and schema, the moves, the
writers, the app switch to meta files, the backfill, the docs, one review
round per `docs/review.md` (code and context).

## Decision

- 2026-09-30, owner: asked for "harden strict standards + contracts around
  how agents can generate and organize files", agreed to remove the root
  `exports/` and put the public PDFs beside their sources in `examples/`
  ("Good call"), and set the principle quoted above. Approved as the
  direction. Lead defaults inside it (reported to the owner): the file name
  `<pdf-stem>.meta.json`, `envelope.json`, the status vocabularies, and
  `build.ps1 -Release` as the one way to refresh the `Release`.

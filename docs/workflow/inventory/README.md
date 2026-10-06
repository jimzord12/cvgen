# Client workflow inventory (2026-10-04)

This is the first step toward `docs/workflow/`, a typed, machine-checked model of
the client workflow from first contact to deletion. It lists every entity
that exists **today**, each anchored to the file and line that defines it.
It designs nothing. Read from `main` at `1e684eb`. This checkout has no
`private/` folder, so no real `Envelope` was inspected: everything comes from
docs and code, and guesses are marked "(inferred)".

Superseded once the model in `docs/workflow/` is built; then this folder goes.

**Read with `main` as of 2026-10-06.** Since this inventory was taken, `main`
moved the task store from Trello to Backlog.md (ADR 0014), made `private/` its
own private Git repository with a delete-by history erase
(`docs/guides/client-workflow.md` section 9), and recorded one delete-by date
per client rather than per CV. The anchors below point at the docs as they
were at `1e684eb`; line numbers in `client-workflow.md`, `build-a-cv.md`,
`new-client` and `development.md` have shifted. Re-anchor before building
the model.

## The three lists

| File | Covers |
|---|---|
| [a-stages-1-4.md](a-stages-1-4.md) | `open`, `intake`, `research`, `text`: client arrives through `Sign-off` |
| [b-stages-5-7.md](b-stages-5-7.md) | `design`, `deliver`, `after`: design to retention; which steps `tests/workflow.py` really exercises |
| [c-catalog-and-drift.md](c-catalog-and-drift.md) | Shared catalog (actors, skills, commands, schemas, glossary terms, `Envelope` layout) and the drift report across sources |

## Counts

| Entity | Stages 1-4 | Stages 5-7 | Catalog |
|---|---|---|---|
| Stages | 4 | 3 | |
| Steps | 41 | 40 | |
| Artifacts (files, records, messages) | 42 | 43 | 27 `Envelope` sub-paths |
| Actions (commands, skills, agents, manual acts) | 31 | 27 | 19 commands |
| Gates | 23 | 23 | |
| Actors | 6 | 7 | 15 (7 take part in a client job) |
| Schemas / contracts | | | 13 (3 as JSON files, 10 only in code or prose) |
| Conflicts and gaps | 28 | 25 | 34 drift items |

Some entities appear in more than one list; the model will merge them.

## What the inventory shows

- **The workflow is written three times over.** The guide, the skills and the
  Atlas each restate every stage; each stage is described in 4 to 11 places.
  Only render, approval and export are enforced by code.
- **No missing files.** Every path and command the sources name exists
  (23 paths checked on disk, every `cv.py` flag found in its argument parser).
  The problems are disagreements and unnamed steps, not dead references.
- **Unnamed steps exist.** Updating `CV Decisions` after the `Deep Dive`s,
  porting a chosen concept into the `Envelope`, closing a client's record,
  and recording a "keep my data" request are done (or should be) but no
  source names them.
- **Only the end of the journey is tested.** `tests/workflow.py` runs render,
  approve (test-only), export and status with every refusal. No `open`,
  `intake`, `research`, `text`, `design` or `after` step is exercised.

## Decisions for the owner

These are the conflicts that change behaviour. Each has a recommendation;
the model will encode whatever is decided.

| # | Question | Where the sources disagree | Recommendation |
|---|---|---|---|
| 1 | When is "Delivered, delete by" written? | At `Export` (guide, `new-client`) vs after the owner sends (Atlas, `build-a-cv`) | When you confirm you sent it, together with `status=delivered`, so the 12 months count from delivery as the consent text promises |
| 2 | The `Text Draft` is stamped `sent` before it is sent | Compile and stamp `sent` happen together; sending is later; no status for "ready, not sent" | Add a `ready` status; `sent` only when you send it |
| 3 | How long is client data kept? | `pdf-workflow.md`: keep approved revisions and delivery copies (no limit) vs consent and guide: delete 12 months after delivery unless the client asks to keep | 12 months, as promised to clients; record a keep request as a field in `envelope.json` |
| 4 | Does a marine client's CV get a `design-reviewer` round? | `new-cv` puts the loop only under "no `Template` yet"; the Atlas applies it to every client | Yes, every client CV, since every one must pass the `Batch Test` |
| 5 | Who runs `Export`? | Atlas: Claude; `new-cv` and `build-a-cv`: nobody named | Claude, after your `Approval` |
| 6 | Can one client's job change the public engine? | The tour-leader build moved fonts into `packages/cv-framework/fonts/` with no step or review gate describing it | Allowed only through the normal code review; a one-off's own assets stay in its `Envelope` |
| 7 | Is a client tracked as a task, and is there a "closed" step? | The inventory predates the move to Backlog.md (ADR 0014); no source creates, moves or closes a client's record, and no step closes it after deletion | One Backlog.md task per `Alias` (alias only, `backlog/` is public); a final `after.close` step at deletion |
| 8 | Should the scripts enforce the order of states? | Stamping `approved`, `delivered` or `signed-off` succeeds with no receipt, export or screenshot | Yes: the model names the order and the stamp command checks it |
| 9 | The `reviews/text-NN.md` file | Named in the `Envelope` tree; nothing writes or reads it; no text reviewer exists | Remove it |

## Fixed without asking (agent-owned, reported later)

The other conflicts are wording and naming drift. The code wins, or the more
specific source does, and they get fixed when the model replaces the prose.
Examples:

- The `Envelope` placeholder has six spellings; use `<envelope>` everywhere.
- "Workspace" in code and CLI vs `Envelope` in prose.
- The Atlas says the `Intake Form` replaces the chat message; your decision says beside it.
- Two stall rules ("no progress" vs "no `Export`" after three months).
- `new-client` says a one-off lives "in one `cv.typ`"; code and the real build use files beside it.
- Meta File kind `text-draft` (a concept) vs the client's `Text Draft` (`client-draft`).
- Two state vocabularies for a `Revision` (`cv.py status` vs Meta File status) with no map.
- `Idea Run` vs "design run" for the same sub-flow.
- Client page renders left in `builds/` with no clearing rule.

## Model notes for the next step

- **A new action kind.** The ID scheme lacked one for Claude's own work
  (writing facts, drafting decisions, reading pages). The model adds
  `lead.<slug>`.
- **Loops.** The `Deep Dive`, design and draft-correction loops repeat by design. The
  model declares each loop with its round cap instead of forbidding cycles.
- **External artifacts.** Chat messages, the Google Form and Sheet live
  outside the repo; the model marks them `external` so the checker does not
  look for them on disk.

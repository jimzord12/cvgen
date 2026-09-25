# Night Shift binding: CVgen

CVgen follows the `Night Shift Protocol` v1
(https://github.com/jimzord12/night-shift; `night-shift docs protocol`
prints it). The protocol is generic; this page fills its slots for CVgen.
Adopted 2026-09-25 as a trial (owner).

| Slot | CVgen |
|---|---|
| Board and adapter | Trello board "CVgen" (https://trello.com/b/IPsBxAwf); adapter `trello`; label `Night-ready` |
| Stages | queued: Queued; working: Active; review: Review; blocked: label Blocked; done: Done (`docs/development.md`) |
| Test command | `python tests/run.py` |
| Review gate | independent `code-reviewer` per `docs/review.md`; reports in `docs/work/<id>/reviews/` |
| Branch and integration | `docs/git-workflow.md`: small verified changes to `main`, the rest on a branch merged after review |
| Owner-reserved actions | `docs/preferences.md`, "What he decides and what agents decide". Never at night: `scripts/cv.py approve`, anything under `private/`, replacing a `Frozen Reference` |
| Where evidence may go | Trello attachments: fictional renders only (examples, fixtures, concepts). Never a real `Client`'s data or PDF |
| End-of-night notification | a Pushover `done` message with the shipped / blocked counts |
| Worktrees | `../cvgen-<card-id>` per parallel card, removed after merge |
| Questions and images | `.night-shift/questions/`, `.night-shift/assets/` (git-ignored, local) |

## The Morning Review

```powershell
night-shift serve . --open
```

(from the repository root; needs the `TRELLO_API_KEY` / `TRELLO_API_TOKEN`
the `trello` skill uses.)

## Night-ready here

A CVgen card is `Night-ready` when it meets the protocol's contract and its
description starts with the header line, for example:

```text
night-shift: kind=build size=M touches=packages/cv-workflow,tests
```

A visual change to a `Template` is `explore` until the owner picks a render;
a change that would move a `Frozen Reference` is never `Night-ready`.

# 01 open: Open the Envelope

<!-- Hand-written text goes outside the generated blocks. `bun run render` (tools/workflow) rewrites only the lines between a block's start and end markers, from catalog.yaml and the stage.yaml files; edit the YAML, not a block. -->

<!-- generated:start summary -->

- **Stage:** 01 `open`, Open the Envelope. Facts: [`stage.yaml`](stage.yaml), 5 steps, 0 gates, 0 loops.
- **Purpose:** A new client gets one Envelope under private/, a neutral Alias, the envelope.json every Meta File copies, and one task record named by the Alias, before any question is asked.
- **Entry:** A client has written to the owner, and the owner tells the lead, naming the person, the Rank and the Domain.
- **Exit:** private/<envelope>/ holds its Drawers, a README.md that starts with the Alias and the intake date, and envelope.json; the client's Backlog.md task exists, titled by the Alias.
- **Reads from:** none. **Hands to:** [intake](../02-intake/README.md), [research](../03-research/README.md), [text-draft](../04-text-draft/README.md), [design](../05-design/README.md), [deliver](../06-deliver/README.md), [after](../07-after/README.md).

<!-- generated:end summary -->

## Judgement

This stage is short and has one path, but its mistakes are the expensive
kind: a real name that leaks into a public file stays in Git history.

- **The owner starts it.** A `Client` writes to the owner, never to the
  lead; the owner tells the lead, naming the person, the `Rank` and the
  `Domain` (`open.arrives`), and the lead does the rest of the stage.
- **The folder name is client data.** `open.envelope` names the folder
  after the person and the `Rank`; `open.alias` gives the `Alias`, and from
  then on the `Alias` is the only name that leaves `private/`: task titles,
  commit messages, briefs to agents, review reports.
- **`envelope.json` now, not later.** `open.envelope-json` writes it before
  any question is sent, because every later `Meta File` copies it (the
  `Text Draft` stamp in `text-draft.draft-compile`, every `Revision`).
- **The `Domain` id comes from the glossary.** `envelope.json` takes an id
  from the glossary's `Domain` row (`art.glossary`), even for a `Domain`
  with no package yet (a tour guide is `travel`). A `Domain` the glossary
  lacks gets its id there first, as the glossary's `Domain` row says; never
  invent one in the `Envelope`.
- **Done looks like this:** the `Drawer`s exist, `README.md` starts with
  the `Alias` and the intake date, `envelope.json` is valid, and the
  `Client`'s task exists in `backlog/` under the `Alias`. Then `intake`
  starts.

## Branches

None. The owner's word starts the stage (`open.arrives`) and the steps run
in order. When the task is created and what it is titled are inferences
(`open.task-create`; [`GAPS.md`](../GAPS.md), "Inferences"), waiting for
the owner in [P-0018](../../proposals/workflow-gaps.md) item 4.

## Common mistakes

- Opening the `Envelope` under `examples/` or `builds/`: it lives only
  under `private/`, the one `Envelope` tree.
- Committing `Envelope` files to this repository. `private/` is its own
  private repository; client work is committed from inside it, with the
  `Alias` in the message (`docs/git-workflow.md`, "The private repository").
- Naming the person in the task title or a commit message in the public
  repository.
- Writing `envelope.json` after the first draft: the draft's stamp then
  has nothing to copy and refuses.

## Reference detail

- `docs/guides/client-workflow.md` section 1: the `Envelope` tree, which
  that section owns, the `Alias` format and an example `envelope.json`.
- The `new-client` skill: the checklist, by step ID.

## Diagram

<!-- generated:start diagram -->

```mermaid
flowchart TD
  %% An arrow implied by a longer path is left out, unless that path runs through an optional step with another condition; the tables list every input and handover.
  s_open__arrives["open.arrives"]
  s_open__envelope["open.envelope"]
  s_open__alias["open.alias"]
  s_open__envelope_json["open.envelope-json"]
  s_open__task_create["open.task-create"]
  s_open__arrives --> s_open__envelope
  s_open__envelope --> s_open__alias
  s_open__alias --> s_open__envelope_json
  s_open__alias --> s_open__task_create
```

<!-- generated:end diagram -->

## Steps

<!-- generated:start steps -->

| ID | Name | Actor | Action | Inputs | Outputs | Gate | When |
|---|---|---|---|---|---|---|---|
| `open.arrives` | The owner names a new client | `actor.owner` | `manual.tell-new-client` | `art.client-first-message` | `art.owner-request` |  |  |
| `open.envelope` | Open the Envelope and its Drawers | `actor.lead` | `lead.open-envelope` | `art.owner-request` | `art.envelope-drawers` |  |  |
| `open.alias` | Give the client an Alias | `actor.lead` | `lead.write-alias` | `art.envelope-drawers` | `art.envelope-readme` |  |  |
| `open.envelope-json` | Write envelope.json | `actor.lead` | `lead.write-envelope-json` | `art.envelope-readme`, `art.owner-request`, `art.glossary` | `art.envelope-json` |  |  |
| `open.task-create` | Create the client's task, by Alias only | `actor.lead` | `lead.create-client-task` | `art.envelope-readme` | `art.client-task` |  |  |

<!-- generated:end steps -->

## Gates

<!-- generated:start gates -->

No gates in this stage.

<!-- generated:end gates -->

## Loops

<!-- generated:start loops -->

No loops in this stage.

<!-- generated:end loops -->

## Artifacts

<!-- generated:start artifacts -->

| ID | Name | Path | Visibility | Made by |
|---|---|---|---|---|
| `art.client-first-message` | The client's first message |  | third-party | given |
| `art.client-task` | The client's Backlog.md task | `backlog/tasks/` | public | `open.task-create`, `after.close` |
| `art.envelope-drawers` | The Envelope folder and its first Drawers | `private/<envelope>/` | private | `open.envelope` |
| `art.envelope-json` | envelope.json | `private/<envelope>/envelope.json` | private | `open.envelope-json` |
| `art.envelope-readme` | The Envelope's README.md (Alias and intake date) | `private/<envelope>/README.md` | private | `open.alias` |
| `art.glossary` | The glossary's Domain ids | `docs/glossary.md` | public | given |
| `art.owner-request` | The owner's "new client" in the session |  | ephemeral | `open.arrives` |

<!-- generated:end artifacts -->

## Actions

<!-- generated:start actions -->

| ID | Kind | Name | Runs |
|---|---|---|---|
| `lead.create-client-task` | lead | Create the client's task | Creates one Backlog.md task for the client, named by the Alias only, since backlog/ is public. |
| `lead.open-envelope` | lead | Open the Envelope | Creates private/<envelope>/, named after the person and the Rank, in the one Envelope tree with README.md, intake/ (messages.md, documents/), research/ (reviews/) and draft/; never under examples/. |
| `lead.write-alias` | lead | Write the Alias and intake date | Gives the client an Alias client-<yyyy>-<mm>-<nn> and writes it at the top of the Envelope's README.md with the date intake started; outside private/ the client is only ever the Alias. |
| `lead.write-envelope-json` | lead | Write envelope.json | Writes alias, domain (an id from the glossary's Domain row), candidate (the display name) and rank; every Meta File in the Envelope copies it and scripts/cv.py render refuses to run without it. |
| `manual.tell-new-client` | manual | Tell the lead about a new client | The owner tells the lead a new client has arrived, naming the person, the Rank and the Domain. |

<!-- generated:end actions -->

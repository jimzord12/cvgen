# AGENTS.md — map of CVgen

CVgen makes hand-crafted, premium CVs with AI on its own Typst framework,
for any `Domain` (`docs/vision.md`). The engine is the domain-neutral
Framework plus one package per `Domain`; `marine` is the first, with one
template, `flagship` (`docs/architecture.md`). Read this file and
`docs/preferences.md`, then open only what your task needs. A session
starts and ends as `docs/development.md` says.

## Hard rules

- The rules that never change, owned by `docs/constitution.md`; among them:
  frozen references, a new folder per output, public content fictional, no
  font shrinking, evidence before "done", bypasses recorded, the totals rule.
  Read it before changing a template, a layout, an output path or anything
  irreversible.
- **Design is the product.** A CV passes the `Batch Test` and the
  `Three-Second Test`; a well-crafted but quiet design fails. Whoever
  designs, reviews or proposes a CV design first reads `docs/vision.md`,
  "Design is the product".
- Approving a real client's PDF is the owner's act, never an agent's; what
  else he keeps: `docs/preferences.md`, "What he decides and what agents
  decide".
- Public content is fictional; real client data lives only in `private/`,
  its own private Git repository (`docs/git-workflow.md`, "The private
  repository").
- Claude Code implements, tests, reviews and integrates; Codex may discuss
  and design (`docs/development.md`, "Roles").

## Where things are

| Path | What it holds |
|---|---|
| `packages/cv-framework/` | The Framework: domain-neutral core, `lib.typ`, fonts, licences; imports no domain (`docs/architecture.md`) |
| `packages/domains/marine/` | The marine `Domain`: `lib.typ` (every marine entry point imports it), facts, schema, assets, roles, `templates/flagship/` with its frozen `tests/approved/` (`docs/architecture.md`, `docs/engine/`) |
| `packages/cv-workflow/` | Python package behind `scripts/cv.py`: revisions, approval, export, the `Output Contract` (its `README.md`) |
| `examples/` | Fictional candidate records; entry points with their `Release` PDFs and `Meta File`s |
| `scripts/` | `build.ps1`, `cv.py`, `outputs.py`, `proposals.py`, the `Intake Form` script, the `Text Draft` |
| `tests/` | The suite (`docs/engine/verification.md`) |
| `tools/workflow/` | The workflow tool for the `Workflow Model` in `docs/workflow/` (its `README.md`) |
| `apps/design-review/` | The owner's `Design Review` app (its `README.md`); `apps/web/` is not built |
| `studio/` | Design work: `brand/`, `design-concepts/`, frozen `archive/` (never repeat an `Anti-example`); `brand/`, `design-concepts/` and each `archive/` folder have a `README.md` |
| `archive/work-records/` | Review reports and dated task records, kept unchanged |
| `.atlas/` | The `Atlas`: open `index.html` (its `README.md`) |
| `backlog/` | Tasks and the `session-handoff` doc, through the backlog skill |
| `docs/` | Governance and reference, below |
| `.claude/`, `.codex/` | Skills and agents, below |
| `builds/` | Ignored; every build and test run writes a new folder |
| `.worktrees/` | Ignored; one checkout per parallel branch, never another session's (`docs/git-workflow.md`) |
| `private/` | Ignored; one `Envelope` per real client (`docs/guides/client-workflow.md`, section 1) |

## Commands

```powershell
python tests/run.py                  # the suite; evidence in builds/tests-<timestamp>/
ruff check                           # Python lint
./scripts/build.ps1                  # every example into builds/library-<timestamp>/
python scripts/cv.py render private/<envelope>   # a client's new revision
python scripts/outputs.py stamp <pdf> status=<status>   # a PDF's Meta File; `check` lists missing ones
python apps/design-review/server.py  # http://127.0.0.1:8765/
```

The rest: `docs/tech-stack.md` (setup), `docs/git-workflow.md` (release),
`docs/workflow/06-deliver/` (approve, export), `tools/workflow/README.md`,
`.atlas/README.md`.

## Documentation

| Read | When |
|---|---|
| `docs/preferences.md` | Before every reply to the owner |
| `docs/glossary.md` | Before writing to the owner, a proposal or a document |
| `docs/vision.md` | Whether a feature belongs; any CV design |
| `docs/constitution.md` | Before anything irreversible |
| `docs/development.md`, `docs/review.md` | Sessions, tasks, author checks; reviews |
| `docs/git-workflow.md`, `docs/conventions.md` | Git; writing code, docs or a commit |
| `docs/architecture.md`, `docs/engine/` | Before changing a module; one manual per engine concept |
| `docs/framework-gaps.md` | Before framework work; after any bypass |
| `docs/pdf-workflow.md` | Monorepo, revisions, every reviewed PDF's home |
| `docs/workflow/`, `docs/guides/` | A client from first message to deletion |
| `docs/tech-stack.md` | Setting up a machine; why Typst |
| `docs/proposals/README.md` | Proposal states, owner decisions |
| `docs/decisions/`, `docs/history.md`, `docs/research/` | ADRs, history, the `Research Library` |

## Skills and agents

Skills in `.claude/skills/`, subagents in `.claude/agents/`, Codex
counterparts in `.codex/`; each file says when to use it. Which reviewer
gates which change: `docs/review.md`.

## Working agreement

- Speak the glossary and keep it current (`docs/glossary.md`, "Rules").
- Understand the seam before editing; prefer the owning module
  (`docs/conventions.md`, "Before editing"), and follow the component
  contract ("Typst code").
- Every PDF someone will review gets a `Meta File` (`docs/pdf-workflow.md`,
  "Output Contract").
- Checks, evidence and an independent review before "done"
  (`docs/development.md`, "Author checks").
- Log every bypass in `docs/framework-gaps.md` before reporting done.
- Agents act as senior developers and ask nothing routine
  (`docs/preferences.md`, "What he decides and what agents decide").

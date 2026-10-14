# 0015. The Workflow Model: YAML facts checked by a TypeScript tool on Bun

Date: 2026-10-14
Status: Accepted (owner, 2026-10-05: data model, YAML facts, the `Atlas`
rebuilt from the model, "modern TypeScript on Bun 1.4.2+ or Node.js 24+";
the design approved 2026-10-14 in `docs/proposals/workflow-model.md`)

## Context

The client workflow, from first contact to deletion, is written in 4 to 11
places per stage: the guides, the `new-client` and `new-cv` skills, the
lifecycle half of `docs/pdf-workflow.md` and the `Atlas` client-journey
page. The 2026-10-05 inventory (removed by TASK-43: `git show 6e93bad:docs/workflow/inventory/README.md`) found
34 drift items and 53 conflicts or gaps among them; only render,
`Approval` and `Export` are enforced by code. The owner asked for one
anchored description in which every step, file, command and gate is a
named entity, the connections are explicit and checked, and the same
source generates the `Atlas`.

On 2026-10-05 he chose a data model over strict Markdown, YAML for the
facts, the `Atlas` rebuilt from the model, and TypeScript for the program
that reads them, on Bun 1.4.2+ or Node.js 24+ (the handoff,
`docs/work/workflow-model/handoff.md`, section 3). His reason: he knows
TypeScript and does not know Python. The lead recommended Bun. On
2026-10-14 he approved the design and answered the nine workflow
conflicts (the proposal above); those answers are what the facts encode.

Until now every tool here is Python 3.11 (the suite, `packages/cv-workflow`,
`scripts/outputs.py`, the `Atlas` kit) or PowerShell (`scripts/build.ps1`).
Node 24 is already on the owner's machine, but only to run the
Backlog.md CLI (ADR 0014); nothing in the repository runs on it and CI
does not install it.

## Decision

The client workflow is described once, as the `Workflow Model`: YAML
facts checked by a TypeScript tool on Bun (the workflow tool), and the old prose descriptions go once the model
covers them (TASK-43).

- **Facts.** `docs/workflow/catalog.yaml` (actors, actions, artifacts,
  schemas shared by all stages) and one `docs/workflow/NN-<stage>/stage.yaml`
  per stage. Edges are never written: a step whose input another step
  outputs is connected to it. A cycle is allowed only as a declared loop
  with a round cap.
- **Types.** Defined once in TypeScript with Zod. A JSON Schema is exported
  from them and committed, so the VS Code YAML language server underlines
  errors through a `# yaml-language-server: $schema=...` line without
  running anything; CI fails when the committed schema is stale.
- **Tool.** A Bun project in `tools/workflow/` (one `package.json`, one
  `bun.lock`, tests with `bun test`). Its `check` command proves shape,
  references and flow (levels 1 and 2) and fails with file, line and
  reason; its `render` command writes the generated blocks of
  `docs/workflow/**/README.md`, the Mermaid diagrams and the `Atlas`
  client-journey page facts. Generated output is committed and never
  hand-edited; CI regenerates it and fails on any diff.
- **Bun 1.4.2, pinned exactly for CI** in one file of `tools/workflow/`
  that CI reads through `oven-sh/setup-bun`, pinned by commit SHA like the
  other actions. Locally any 1.4.x at or above 1.4.2 is fine. 1.4.2 is the
  owner's floor; 1.4.3 came out on 2026-10-10 and has no track record
  here yet. A newer version is a deliberate commit, as for Typst.
- **Boundaries.** The tool describes and checks the workflow; it never
  renders a CV (ADR 0006 stands) and never reimplements a workflow
  script. `scripts/cv.py`, `scripts/outputs.py` and `packages/cv-workflow`
  stay Python, and the state guards the owner asked for (decision 8) go
  into them (TASK-44). The tool only calls them, for example `--help` to
  prove a subcommand exists, and level 3 (TASK-42) runs them.
- **The `Atlas`.** The model writes the client-journey page facts in the
  format the existing kit (`.atlas/_kit/atlas.py`, a copy of the owner's
  personal `/atlas` skill) already renders. Porting the kit itself is not
  part of this decision; a port would be a new ADR (TASK-41 may propose
  one).

## Alternatives considered

- **Python with pydantic, in the existing toolchain.** Pydantic types also
  export a JSON Schema, a YAML parser with positions gives file and line,
  and `tests/run.py` could call the checker directly: no second runtime, no
  second dependency set, no CI change. On technical grounds alone it is
  at least as good as the chosen design, and it is the cheaper one.
  Rejected by the owner's choice of language: the types are the part he
  will read (TASK-36, "show me at the end"), and he reads TypeScript, not
  Python. This ADR records that the reason is reader fit, not a
  capability Python lacks.
- **Node.js 24 instead of Bun.** Node 24 is already installed for the
  Backlog.md CLI, runs TypeScript files directly (type stripping, without
  enums or parameter properties) and has a built-in test runner. Bun
  was preferred for its built-in `bun test` with `expect` and snapshots,
  full TypeScript support and fast installs from one binary. The gap is
  small, so the tool uses standard and Node-compatible APIs wherever one
  exists and keeps any Bun-only call in one place: moving to Node 24 stays
  a small change if Bun causes friction.
- **Strict Markdown with an ID convention and a path-only checker.** Half
  the work, but the connections between steps stay hand-written and
  unchecked, which is where the 34 drift items came from. The owner chose
  the data model over it on 2026-10-05 (the handoff, section 3). Keeping
  today's hand-written docs as they are was never an option: his request
  for one anchored, checked description rules it out.
- **Pkl or CUE for the facts and types.** Purpose-built, but a third
  language to learn and to install. Rejected.
- **Hand-written JSON Schema beside hand-written types.** Two sources for
  one contract, which drift. Zod exports the schema from the types.

## Consequences

- One source for the workflow: a step changes once, `check` proves it,
  and the docs, diagrams and `Atlas` page regenerate. The skills shrink to
  pointers at step IDs.
- Two toolchains. Python stays for the suite and the workflow scripts;
  TypeScript on Bun is added for the model. Agents maintain both (all code
  here is agent-written); updates mean the pip pins in
  `.github/workflows/verify.yml` and `tools/workflow/bun.lock`, one lockfile
  for the JavaScript side.
- Every machine that runs the suite needs Bun once TASK-38 wires `check`
  into `tests/run.py`; the setup in `docs/tech-stack.md` gains a line with
  TASK-36. The owner's machine has Bun 1.4.0 today and needs `bun upgrade`
  to any 1.4.x at or above 1.4.2 before TASK-36.
- `tools/` is a new top-level folder while TASK-55 aims for fewer; TASK-55
  decides its final place.
- CI cost: a pinned setup step and a cached `bun install` on both runners,
  seconds per run, plus the `check` and the regenerate-and-diff steps.
- "Deliberately not used" in `docs/tech-stack.md` still holds: no Node,
  React or web framework renders a CV.
- Revisit Python if the owner later prefers one toolchain over reading the
  types; the facts and the JSON Schema would survive such a move, only the
  checker would be rewritten.

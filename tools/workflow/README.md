# tools/workflow: the workflow tool

The TypeScript program, on Bun, that holds the `Workflow Model`'s types and
checks its YAML facts (ADR 0015). Today it checks the shape of one file at a
time; the model-wide checks (references, flow) come with TASK-38 and
rendering with TASK-39.

| Path | What it holds |
|---|---|
| `src/model.ts` | The Zod types: Stage, Step, Artifact, Action, Actor, Gate, Loop, Catalog. The one source of the contract |
| `src/load.ts` | Reads a YAML file, checks it against the types, reports file, line, path and reason |
| `src/schema.ts` | Exports the JSON Schema files from the types |
| `src/cli.ts` | The command line |
| `schema/` | The exported JSON Schema files, committed, never hand-edited |
| `sample/stage.yaml` | A short sample stage, used by the tests |
| `.bun-version` | The Bun version CI installs (1.4.2); locally any 1.4.x from 1.4.2 |

Run every command from `tools/workflow/`. Once, after a clone:

```powershell
bun install            # installs the exact versions in bun.lock
```

Day to day:

```powershell
bun test                                  # all tests
bun run typecheck                         # TypeScript type check (tsc --noEmit)
bun run check sample/stage.yaml           # check files: exit 0 clean, 1 with problems, 2 usage
bun run check ../../docs/workflow/catalog.yaml   # a file named catalog.yaml is read as the catalog
bun run schema                            # regenerate schema/*.json after changing src/model.ts
bun run schema --check                    # exit 1 if the committed schema is stale (a test does the same)
```

A problem prints as `file:line: path: reason`, for example
`stage.yaml:34: steps[2].actors: unknown key (not part of the type; check the spelling)`.

For VS Code to underline mistakes while typing, install the Red Hat YAML
extension and start each file with the hint pointing at its schema,
relative to the file:

```yaml
# yaml-language-server: $schema=../../../tools/workflow/schema/stage.schema.json
```

## Review round 1: code-reviewer, 2026-10-14

Snapshot: `feature/task-36-workflow-schema` at 7cbfe05, base origin/main f6aebb4. Lead lenses: fitness of the model; correctness and tests.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Coverage: Zod is the single source, the JSON Schema is exported and committed, the CLI works; wiring into CI and the suite is TASK-38's. Spot-checked inventory steps `text.sign-off-record` (two actors), `research.deep-dive-review` (agent plus cmd, cap 5/10) and the shared `gate.research-enough` (its fail branch differs per step, so gates per stage is right); one actor and one action per step, and `third-party` for the old `external` visibility, are sound. Zod and the JSON Schema agree on 14 probes except duplicate keys (YAML parser only). Empty file, multi-document, duplicate keys, nulls, bad type and missing file exit 1 with a line; usage error exits 2. LF, exact pins, `bun.lock` committed, `node_modules/` ignored.

Material
- F1: AC #3 ticked without its VS Code evidence (task record AC #3 and notes: "VS Code itself not opened"); only ajv and Python jsonschema ran. Fix: show the editor's validation of the sample and a broken copy, or untick and raise it.

Minor
- F2: `tools/workflow/src/model.ts:22-23`: reserved prefixes are refused with "must be a kebab-case ID". Fix: name the reserved prefixes.
- F3: `tools/workflow/test/cli.test.ts:23`: `mkdtempSync` folders never removed (14 in %TEMP%). Fix: delete in `finally` or write under builds/.
- F4: `docs/glossary.md:87`: `Workflow Model` row still says the tool is planned. Fix: tool built, facts planned (TASK-37).
- F5: `model.ts:43-46`: source anchors refuse paths with spaces (every backlog task file) and accept reversed ranges (`a.md:30-12`). Fix: decide before TASK-37.
- F6: README and tech-stack setup use `bun install`, which can rewrite the lock. Fix: `--frozen-lockfile`.

Notes
- F7 for TASK-37: multi-outcome and decision gates read as pass/fail (ADR 0015), e.g. `gate.template-exists`, `gate.client-answered`; a per-item repeat exists only as `when` text; the sample's `text.sign-off-record` drops the `signed-off` stamp its `exit` promises.
- F8: a context-reviewer round is also needed (AGENTS.md, tech-stack.md).

Checks rerun: `bun test` 19 pass; `bun run typecheck` 0; 14 CLI probes (13 exit 1 with file, line, path; reversed range exits 0); `schema --check` 0; jsonschema agrees; mutations in a disposable copy all caught (type change without regenerating, description-only change, non-strict Step, action ID untied from kind, any anchor accepted, cap 0); outputs under `builds/review-task-36-r1/` in the worktree.

Limitations: VS Code not opened; suite not rerun (no Python or Typst path touched); Bun 1.4.2 pin and CI not checked.

## Dispositions (lead)

- F1: fix by running the same validator the VS Code YAML extension uses (yaml-language-server) headlessly on the sample and a broken copy, recording its diagnostics; the owner's own look in VS Code stays the final check (raised in the final report). F2-F6: fix (F5: allow spaces in paths, refuse reversed ranges). F7: fix the sample's sign-off step; the rest carried to TASK-37's record. F8: context round follows.

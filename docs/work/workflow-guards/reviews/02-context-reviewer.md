## Review round 2 (context round 1): context-reviewer, 2026-10-14

Snapshot: `origin/main...2b04293` in `.worktrees/task-44`. Lead lenses: one consistent story of the status order; the new term warranted, Atlas citations right.

Verdict: PASS. Recorded in substance (formatting condensed).

Checked: nothing tells an agent to stamp `sent` at compile; no `text-draft` kind left except dated records, the fixture name and Atlas step ids; refusals described as the code does them (`pdf-workflow.md:143-149`, `build-a-cv.md:207-209`, `client-workflow.md:268-269`, `new-client/SKILL.md:70`, the Atlas); new-cv and verify-cv do not stamp; `House Design` warranted (was used unnamed; no collision with `House Copy`); `atlas check --strict` exit 0; LF in the commit; no client identity.

Minor
1. `docs/glossary.md:57`: the `Text Draft` row copies the status list from `pdf-workflow.md:128`. Fix: point there.
2. `docs/glossary.md:58`: a proposal is a PDF whose `Meta File` has kind `house-design`; the `text-draft` history appears twice. Fix: wording; history in the code column only.
3. `docs/guides/client-workflow.md:266-267` vs `:275-276`: two triggers for `sent` in different words. Fix: one sentence ("confirms he sent").
4. Synonym left: "`Text Draft` direction" in `design-concepts/README.md:59-61`, `.claude/agents/magazine-editor.md:84`, `.codex/agents/magazine-editor.toml:109`. Fix: "`House Design` proposal".
5. `docs/guides/client-workflow.md:251`: "the house design of the `Text Draft`". Fix: `House Design`.

Notes
- `AGENTS.md:109`, `brand/README.md:156`, `.claude/agents/design-reviewer.md:113` say "house design" in lower case.
- `brand/README.md:156`: the `Intake Form` header also uses First Fitting; the glossary row understates where the `House Design` is used.
- `docs/pdf-workflow.md:126`: the table gives `concept-<variant>.pdf` as a home of `house-design` only, while Hanami Line 2's palette variants are kind `concept`.
- `build-a-cv.md:209`, `pdf-workflow.md:140` run past the wrap width.

## Dispositions (lead)

- Minors 1-5: fix. Notes: lower-case mentions and the glossary row's scope fixed with them; the pdf-workflow row clarified; long lines rewrapped.

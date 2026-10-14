## Review round 1, lens A (context): context-reviewer, 2026-10-14

Snapshot: base 6e93bad, head e9cf613. Lens A: nothing lost, nothing decided (a parallel reviewer covers sources).

Verdict: FINDINGS. Recorded in substance (no client named; the example is fictional).

Checked: 44 removed instructions sampled from the old client-workflow.md, build-a-cv.md, the pdf-workflow Lifecycle and both skills, weighted to consent and its hard stop, LinkedIn, search privacy, the `Alias`, the reviewer never reading `private/`, `Deep Dive` caps and inline SHA-256, the library note path, one batch per round, the Greek `Check Page`, `Fact Mark`, the ready/sent/signed-off/superseded stamps, never recompiling a sent draft, `Sign-off` before design, the design-reviewer gate for every CV (#4), brief and report storage, clearing previews, never shrinking type, the example-wording exception, no inherited approval, Approval the owner's only, the lead exporting (#5), "Exported <date>, delete by" (#1), 12-month retention (#3), the stall rule, the owner running deletions, erase commands, Drive Trash, the Release needing the owner's go: each now lives in a stage README, the YAML or the remaining guide. P-0018 untouched; prose citing #1-#6; glossary row, history entry, AGENTS rows (+1 line), inventory deletion, LF fine.

Material
1. Real client pages are still left in `builds/`, and the deleted inventory (drift 9) was the only record: `.claude/agents/design-reviewer.md:46-48` (and `.codex/agents/design-reviewer.toml:80`) renders page PNGs into `builds/design-review-<timestamp>/` on every client round; `design.clear-review-input` clears only `design-review-input-*`; `.claude/skills/verify-cv/SKILL.md:68-76` renders a client revision's PNG into `builds/` with no clearing. Fix: widen the clear step or brief the reviewer to render inside the input folder; point verify-cv's client case at `deliver.page-png` and its clearing; else a GAPS bullet.
2. Dated records edited against `docs/conventions.md:134-135`: `docs/decisions/0015-workflow-model-toolchain.md:13` (Context), `docs/proposals/workflow-model.md:14` (approved proposal), `docs/framework-gaps.md:31` (Built field), `:102` (an `Update:` line edited, not appended); `:68` still says "section 8". Fix: revert the record edits; add one new `Update:` line naming the renumbering.

Minor
3. The two owner questions (drift 11: the `preferences.md` edit list misses `messages.md`, `form-NN.gs`, `reviews/`; a17: `Check Page` language for a client who does not read Greek) survive only in TASK-43's notes; orientation will not surface them. Fix: GAPS bullets or a P-0018 item.
4. `docs/workflow/GAPS.md:13-14` "no prose can say otherwise" overclaims (verify-cv's client render).
5. "need not be sent" became "never the receipt" (`06-deliver/README.md:49-50`) and "is not sent" (`docs/pdf-workflow.md:184`) without a source. Fix: "the receipt stays internal; it need not be sent".

Notes
- `docs/guides/build-a-cv.md:166` stamp refusals are decision #8, not cited.
- The dropped "do not copy renders into `examples/`" line is covered by constitution section 3.

## Dispositions (lead)

- M1: fix: the design-reviewer renders its PNGs inside the `design-review-input-*` folder it is given, so `design.clear-review-input` removes them; verify-cv's client case points to `deliver.page-png` and its clearing.
- M2: fix as proposed.
- m3: both questions go to P-0018 as items 8 and 9 (pending, with recommendations), so orientation surfaces them.
- m4, m5, notes: fix (cite #8).

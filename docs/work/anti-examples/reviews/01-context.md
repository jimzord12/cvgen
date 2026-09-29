# Context review round 1: anti-examples (`git diff 760c823 1e3edb8`, worktree `cvgen.worktrees/anti-examples`)

What the feedback should mean (worked out before I read the diff): the two `Text Draft` directions the owner did not pick stop being "inspiration" and become frozen reference material for what is not his style. Agents that propose or review designs should read them and avoid them. What should not happen: agents inventing the owner's reasons, or turning single generic devices into repo-wide bans before he has said why.

Checked and clean:
- **Stale paths.** None. Outside `docs/work`, history and `.night-shift/history` (a dated record, rightly left alone), no file references `design-concepts/2026-09-27-{stoichedon,two-inks}`, `fonts/syne` or `fonts/gfs-neohellenic`.
- **Fonts.** Nothing else uses Syne or GFS Neohellenic. `design-concepts/fonts` still holds jost and bona-nova.
- **Output Contract.** `outputs.py` `PUBLIC_TREES` excludes `archive/`, so removing the Meta Files cannot break the suite.
- **Hygiene.** LF endings on every touched text file. No client data. Glossary row well formed and dated as the owner's term. Briefs and the header comments in `concept.typ` updated consistently.

## Material

**M1. `.claude/agents/design-reviewer.md:58-61`: the rule sends the check to the wrong test and overreaches.**
- **Wrong test, and it misses its own case.** `Flagship Parity` means "as confident, crafted and premium as the Flagship". Leaning on a rejected idea is a question of distinctness and the owner's taste, not of that. Both anti-examples are `Text Draft` directions, which this same file judges under "Other assets" (line 110), where `Flagship Parity` does not apply. So a new Text Draft proposal built on a letter grid would trip nothing.
- **Criterion 3 is Blocking by definition** (lines 116-117). The rule turns the lead's own reading of each brief ("the device to avoid", which the README admits is not the owner's reason) into a hard fail. Those devices include generic ones: "giant numerals", "a hot orange as the second ink", "an archaeological, epigraphic voice". The last could be exactly right for a Greek-destination travel CV.
- **"Unless its brief gives a reason the owner would accept"** asks the reviewer to guess the owner's mind. A client CV has no brief at all.
- **Smallest fix:** fold it into criterion 4 (Distinct), which already says "could not be mistaken for … an earlier concept". Add "or an `Anti-example`", judged on the organising idea, not single devices. Add one line to "Other assets" so it also fires for Text Draft and brand work. Until the owner's reasons are recorded, report a partial resemblance as a Note flagged for the owner. Only a near-repeat of the whole idea should be Blocking.
- **Same issue in `.claude/agents/magazine-editor.md:79`.** "Never repeat one of those ideas" is fine only if "idea" means the organising idea. Say so, so the editor does not treat the lead's device column as a ban list.

## Minor

- **m1. `AGENTS.md:100`** says the folder holds "his reasons". It does not yet: both rows say "not recorded yet". Say "with their fonts and, once given, his reasons".
- **m2. `docs/pdf-workflow.md:55` and the "Output Contract" section (line 114, "Every PDF we show someone").** The exemption for `archive/` lives only in `archive/anti-examples/README.md:14-15`, while the file that owns the contract still reads as covering every PDF. The layout tree there also omits `archive/anti-examples/`. Fix: one tree line, plus one sentence saying `archive/` is outside the contract.
- **m3. `archive/anti-examples/README.md:24-25`, "The device to avoid" column.** It is the lead's inference, but the header reads as the owner's. Rename it "What it leans on (lead's reading)", or similar, until his words replace it. This also supports the fix for M1.
- **m4. `design-concepts/README.md:45-46`.** "archived as an anti-example" uses the new glossary term without backticks, while the file backticks terms (`Text Draft`). Write `Anti-example`.

## Notes

- **N1. `idea-run/SKILL.md:132`.** The new branch of the Reject row is clear, and it rightly makes archiving the owner's choice ("wants it kept"). Nothing to change.
- **N2.** Any verdicts for these PDFs in `.local/design-review/state.json` now point at paths that no longer exist. I did not read `.local/`. Harmless, but the lead may want to confirm the app does not complain about them.

Verdict: FINDINGS

## Dispositions (lead, 2026-09-30)

Ran as a general-purpose stand-in acting exactly as `context-reviewer.md`.

- M1: fixed as suggested. The check moved into criterion 4 (Distinct),
  judged on the organising idea, never a single device; "Other assets" now
  checks against the `Anti-example`s too; only a repeat of the whole idea is
  Blocking, a partial resemblance is a Note for the owner until his reason is
  recorded. magazine-editor: "never repeat one's organising idea; a single
  device is not banned by that alone".
- m1-m4: fixed as suggested.
- N2: no state file exists yet (the owner has not recorded verdicts), so
  nothing is orphaned.

The fixes are the reviewer's own smallest fixes, checked by the lead; no
round 2.

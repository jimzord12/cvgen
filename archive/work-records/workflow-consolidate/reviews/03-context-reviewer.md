## Review round 2 (context): context-reviewer, 2026-10-14

Snapshot: `6e93bad..8258db8` (round delta `e9cf613..8258db8`).

Verdict: FINDINGS (one Material, from an incomplete A-M1 fix). Recorded in substance.

Checks out: A-M2 (ADR 0015 and `workflow-model.md` back to base; framework-gaps only the appended `Update:` line; `70631ed` holds the old section 8); A-m3 (P-0018 revision 2, items 8 and 9 with recommendation and undo, `proposals.py` 1 pending); A-m4, A-m5, the #8 citation, lens-B minors 1, 2 and note 4; verify-cv points to `deliver.page-png`, snippet matches; concept reviews and `idea-run` unaffected; anchors into the changed agent and skill files still read right; `bun run check`, `render --check`, `atlas --check`, `atlas check --strict` pass; LF; no client beyond the existing `Alias`.

Material
1. `.claude/agents/design-reviewer.md:52-58`, `.codex/agents/design-reviewer.toml:85-91`: batch sheets ("Keep the sheets in `builds/`") hold a thumbnail of the client's page outside the input folder; the leak survives; line 58 contradicts line 48's "write nowhere else". Fix: "(a client's: in the input folder you were given)" in both, re-stamp.

Minor
2. `docs/proposals/workflow-gaps.md:39` item 8: the owner downloads `answers-NN.csv` (`intake.form-download`, `actor.owner`); `reviews/` is written by the lead storing the report, not by `design.client-review`.
3. `workflow-gaps.md:40` "house copy" should be `House Copy`.
4. `design-reviewer.md:48`, `.toml:81` about 150 characters, unwrapped.
5. `verify-cv/SKILL.md:69-70` "at 96 dpi" dangles.

Notes
- `framework-gaps.md:104-105` "in the two above it": the two entries are not adjacent; "two earlier entries".
- Working-tree CRLF on the round-1 reports; blobs LF.

## Dispositions (lead)

- M1, minors 2-5 and the note: fixed by the lead (item 8 now names three files and `design.fix`, which stores each report). The rewrap moved `design-reviewer.md` lines: the model anchor `46-48` widened to `46-50`; Atlas `design-run` `44-136`, site.json `69-136`; the four stale pages verified and re-stamped, system-map last.

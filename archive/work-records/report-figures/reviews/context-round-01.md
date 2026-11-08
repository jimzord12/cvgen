Context review, round 1. Report figures (main..1097d95, worktree C:\Github\cvgen\.worktrees\report-figures)

The principle I expected before reading the diff: when a report asks the owner about something visual, the picture sits in that section, or the section names it plainly ("see Figure A"). A picture that several sections share gets a short id that each of them cites. The test is that an owner coming back cold can act on any section without scrolling. This should apply to every owner report (the chat summary, the document, the `Report Template` page). It should not apply to CV design rules or to reports with no pictures.

The diff captures that principle in the right owners: `docs/preferences.md` "Reports" has the owner-level rule, and `studio/brand/report/README.md` has the page mechanism. No skill or agent in `.claude/` or `.codex/` builds reports, and `docs/development.md` does not mention the `Report Template`, so nothing else has to carry the rule. The glossary `Report Template` row is still accurate. Both files use LF line endings (0 CRLF).

## Material

1. **studio/brand/report/README.md:44-50 — the new paragraph splits the fields table.** It sits after the `decisions` row (line 42), so the `changes` and `evidence_path` rows (lines 49-50) come after a paragraph. With no blank line before them, Markdown reads them as part of that paragraph, not as table rows. Readers lose two fields from the table, and in the raw file they look orphaned. **Fix:** move lines 44-48 below line 50, after the table, with a blank line before them.

## Minor

2. **studio/brand/report/README.md:45-47 — the placement rule leaves out one case and misplaces the Figures section.**
   - **The missing case:** in `report.html` (`owned`, line 238), a picture moves into a card only when exactly one `needs_you` card cites it. A picture cited by one *decision* stays under Figures, and the README does not say so.
   - **The position:** the README puts Figures "at the foot", but the page renders it right after Needs you, before Reviews, Decisions and Changes (report.html:255).
   - **Fix:** "A picture that one `needs_you` card cites sits inside that card, small, and a click enlarges it. Any other picture stays under Figures, below the cards, and each item that cites it carries a "Figure A" link."

3. **docs/preferences.md:113-116 — the rule is narrower than the feedback.** The owner said "whichever section" and "multiple sections". The bullet says "a question about a look" and "a picture several questions share". A section that reports a decision with a picture (the `decisions` rows that now take `figures`) falls outside the words. **Fix:** "so whatever he is asked about or told about a look shows that look beside it, and a picture several sections share has a short name ("Figure A") that each one cites."

4. **studio/brand/report/README.md:6-8 — the principle is stated a second time in different words.** This sentence restates the preferences bullet with its own wording ("shows it, or names it"), next to a pointer to "Reports" that already exists. A brief restatement is allowed, but two wordings of one rule will drift apart. **Fix:** keep "and every picture where it is needed (2026-11-08)" plus the existing pointer, and drop the sentence on lines 6-8, or cut it to its last clause.

5. **docs/engine/verification.md:221-229 — the manual for the Report check was not updated.** `tests/report.py` now asserts that the sample has one picture shown in its card and one cited twice. It also adds seven refusals: a missing or malformed `id`, two figures sharing one id, a citation of a missing figure from a card and from a decision, and `figures` that is not a list or is empty. The refusal list in the manual is introduced with "among them", so it is not wrong, but the sample's new placement check is not described anywhere. **Fix:** add "a sample with a figure in its card and one cited twice" and, in the refusal list, "a figure id missing, malformed, shared or cited but absent".

## Note

6. "Figure" is a section label and a field value on the page, not a domain concept, so I don't think it needs a glossary entry. Add one only if agents start using "Figure" in prose outside the report.

Verdict: FINDINGS

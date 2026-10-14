# Context review round 1: Density axis (working tree on e63292d)

What the feedback implies (written before reading the diff): every idea-run design now has a second axis, `Density`. Condensed is one dense page. Spacious has more room and runs 1 to 3 pages, each page still carrying the `Style`. So a run is 18 designs, and files are grouped `<density>/<tier>/`. The steer sets the Spacious page count. A client pick names the `Density` too. Earlier runs, Flagship and the engine are untouched. No client is named.

The diff captures this. The principle is carried, not just the example: the page count comes from the steer and is not hard-coded to 2. The glossary has the new term. The agent, skill, README, AGENTS and guide pointers are all updated. All nine touched files use LF line endings (0 CRLF). No client identity appears in the added lines.

Stale-mention sweep: I grepped for "nine", "three tiers", "safe.typ", "<tier>.typ", "one-page" and "tier" across `.claude/`, `docs/`, `AGENTS.md`, `CLAUDE.md` and the README. Every remaining hit is either about the Flagship one-page `Layout`, a historical record, or correct as written. Nothing is stale.

README links: all nine condensed PDFs exist at `condensed/<tier>/condensed-<tier>.pdf`. The nine spacious links point at `spacious/<tier>/spacious-<tier>.pdf`, which matches the documented shape. Those files are not drawn yet (expected). Every renamed `.typ` reads `../../sample.json` and `../../portrait.jpg`, and both shared files are present in each style folder.

## Minor

1. **`.claude/agents/design-reviewer.md:146`: the word cap is too tight.** A 2-page Spacious run has 27 pages, and the report shape at line 135 gives each page its own section with a First impression line and a Three-Second Test line. That boilerplate alone is about 1,350 words before any finding, so the old ~100 words per page drops to ~55. The next reviewer will either cut findings or ignore the cap.
   - Fix: raise it to about 2,500 for a full run. Alternatively, keep 1,500 and allow a passing later Spacious page one line.
2. **`.claude/agents/design-reviewer.md:135`: the heading pattern is hard to read.** `<style folder or CV>/<density>/<tier>[, page N] or <page>` mixes the concept and client-CV cases in one line.
   - Fix: split it into two alternatives, "concept: `<style>/<density>/<tier>[, page N]`" and "client CV: `<page>`".
3. **`.claude/skills/idea-run/SKILL.md:27`: the non-CV run wording lags.** It still says "follows the lead's brief for its styles and tiers", while `magazine-editor.md` now says "styles, densities and tiers".
   - Fix: add "densities".
4. **`.claude/skills/idea-run/SKILL.md:39-41`: "Give the same three to every `design-reviewer`" now follows the inserted page-count clause.** "Three" reads ambiguously, and the reviewer never receives the Spacious page count, so it cannot check the steer was met.
   - Fix: "Give the same three, and the page count, to every `design-reviewer`."
5. **`docs/glossary.md:78`: "The layout type of a `Style`'s pages" collides with the existing term `Layout` (line 45: margins, gaps, which content lands on which page).** The Flagship also has one-page and multi-page `Layout`s, so a reader could equate Spacious with a multi-page `Layout`.
   - Fix: reword to "How much room a `Style`'s design takes, one of two: …". Or add a line under "Words with two meanings".

## Note

- **`.claude/agents/magazine-editor.md:78` asks more than the glossary.** It says a later Spacious page "passes both tests on its own". The glossary and the settled decision say only that every page carries the `Style` and is never a plain continuation sheet. The reviewer (line 55) agrees with the editor. That is defensible, but it is stricter than the settled wording; confirm it is intended.
- **`.claude/agents/magazine-editor.md:167-169` names a PNG as a JPEG.** It suggests copying `examples/candidates/fictional-engineer.png` into the folder as `portrait.jpg`. The existing `portrait.jpg` files are real JPEGs (627x627), so this run is fine. A future run following the text literally would get a mis-extensioned file.
  - Fix: say "as `portrait.<ext>`" or "converted to JPEG".
- **`AGENTS.md:100` says every style folder has a `sample.json`.** The editor only uses one when the `Domain` has no record yet; a marine run reads `examples/candidates/`.
  - Fix: "and, when the `Domain` has no record yet, `sample.json`".
- **`docs/work/idea-runs/2026-09-29-editor/run.md:10` names the Alias `client-2026-09-01`.** The line is older than this change and uses only the Alias, so it is not a finding here. I flag it because the brief says no client should be referenced in these docs at all.
- Placement is right. The rule lives in `magazine-editor.md` (the owner of the run shape) and the glossary. The others point to it and restate briefly. No ADR, history or framework-gaps file was edited. The run record's "Density added" section is an appended dated entry, which is the right record.

Verdict: PASS

## Dispositions (lead, 2026-09-29)

Ran as a general-purpose stand-in acting exactly as
`.claude/agents/context-reviewer.md` (from branch `docs/codex-visual-tools`;
the agent loads only in a fresh session), with that file's tools as its limit.
The change was made by a stand-in acting as `context-maintainer`.

- Minor 1: applied, cap raised to about 2,500 words, and a passing later
  Spacious page may get one line.
- Minor 2: applied, heading split into concept and client-CV forms.
- Minor 3: applied ("styles, densities and tiers").
- Minor 4: applied ("the same three, and the page count").
- Minor 5: applied: "How much room a `Style`'s design takes (not a
  `Layout`)".
- Note 1: intended. The lead asked the editor for it: a page 2 pulled out of
  a batch must still pass the `Three-Second Test`. The glossary row stays
  short.
- Note 2: applied ("converted to JPEG").
- Note 3: applied.
- Note 4: no change; an Alias is allowed outside `private/`.

PASS verdict; the fixes are wording only, checked by the lead, no second round.

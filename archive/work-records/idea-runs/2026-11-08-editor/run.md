# Idea run 2026-11-08, editor: five one-page travel styles

## Brief

Owner, 2026-11-08: "Do create like 5 different styles (each should be
distinct not just a little different), so I have variety to choose from."
Context: a real client in the travel `Domain` wants "a more generic and
professional 1-page CV, and not so focused on Japan", and the owner asked
for "a monochrome that looks good". The run gives the owner five
distinct one-page styles to choose from for that client's practical
one-page CV. No client data enters the run: the record is fictional
(`fictional-record.json`, copied from `tests/fixtures/tour-leader-generic.json`
on `feat/hanami-essential` at 665df97), shaped like the client's.

Departures from the standard run, on the owner's steer:
- Five styles instead of three.
- One page each, under the `scan-first` bar (`Scan Test`, with the
  `Batch Test` and `Flagship Parity` judging craft); no Spacious density.
- One design per style, in the `stylish` `Design Tier`, drawn twice: its
  own palette and a monochrome version that must look good on its own.
  So 10 PDFs.

For every design: `Domain` travel; specialty: group and private travel
(travel consultant who also leads tours), generic, not one country;
`Rank` "Tour Leader / Travel Consultant". Page count: 1. A portrait slot
(optional per client); the fictional portrait is
`examples/candidates/fictional-engineer.png`.

Worktree `.worktrees/idea-run-2026-11-08-editor`, branch
`docs/idea-run-2026-11-08-editor`, cut from main at 8e4c1be.

## Rounds

(appended as the run goes)
- Round 1 author: magazine-editor drew five styles (rhumb-lines, airmail, timetable, poster-sun, guilloche), each in colour and monochrome; snapshot e3be504. The editor may not run Git, so the lead committed. Monochrome files sit at `<style>/concept-mono.*` (the Output Contract accepts one PDF per tier folder; Hanami Line 2 palette precedent).
- Portrait: prepared with `scripts/portrait.py` (branch feat/portrait-prep) from the fictional pinned image, after the owner's portrait rule reached the run mid-draw.
- Round 1 gates: research-reviewer on the five briefs, and design-reviewer with codex-visual-reviewer on e3be504, started together (the lead's choice, to save the owner's wait: a research fix changes brief text, not the pages; any change to a page goes back through both design gates).
- Round 1 verdicts: research PASS (Notes R1-R6). design-reviewer FINDINGS: 8 of 10 pass; Guilloche colour and mono Blocking D9 (reads as an imitation ID). Codex FINDINGS: Poster Sun and the lineup PASS; Rhumb Lines (lines cross the text), Airmail and Timetable (the lone "40." line), Guilloche (imitation ID; portrait backdrop) Blocking. Both judges agree on Guilloche; Codex alone blocks the rhumb lines and the "40." line, which the design-reviewer had as Notes and Nits. All go back to the author.
- Round 2 author: fixes for every round-1 Blocking item; snapshot 89fe559.
- Round 2 verdicts: research PASS (Note R7, an unsourced market remark). Codex PASS on all six calls. design-reviewer FINDINGS: 8 of 10 pass; Guilloche colour and mono Blocking D19 (the page ran 43 mm short, with a hanging centre rule), Nits D15, D17, D18. Run-level Note: the fictional portrait is a man on a record named "Daphne".
- Lead decision (fictional data): the record became "Nikos Kontos" (he/his) to match the only fictional portrait; the real client is also a man. The editor changed the five `sample.json` files; the lead changed `fictional-record.json` (the editor cannot write in archive/).
- Round 3 author: D19 fixed (rule ends with the longer column, header 15 mm deeper, body opened, closing engraved border, repeated microprint cut), D15, D17, D18 fixed, R7 marked as the author's observation, Airmail mono's hazard-tape echo removed (optional D16, taken); snapshot f1bc2bd. R7 is a removed claim, so the research gate is not rerun (lead check: the brief now says "in my own observation").
- Round 3 verdicts: design-reviewer PASS on all ten (Nits: Guilloche rosette 0.4 mm from the trim; the availability date shown twice). Codex PASS on all six calls; colour and mono ranking Timetable, Poster Sun, Airmail, Rhumb Lines, Guilloche. Open optional Note: Airmail colour stripe coverage.
- After the PASS: the two Guilloche Nits go to the editor as a layout-only change, checked by the lead against the render (idea-run skill, step 6).
- Round 4 (layout only, lead check against the render): Guilloche rosette pulled 4 mm inside the edge; the availability field left the header grid, the specialty became a line under the title. Checked at 96 dpi: one A4 page, no collision, date shown once. Airmail colour stripes left as they are (author's call: passed two rounds).
- Integration: the run adds only new files under studio/design-concepts/ (five style folders, three OFL font families), the run's rows and one sentence in studio/design-concepts/README.md, and this run folder, all covered by the idea gates (docs/review.md). outputs.py check: 29 PDFs, 0 problems. Concepts stay proposed until the owner answers.

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

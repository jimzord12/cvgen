# Report Template

The page for the final report of an unattended run. The owner's rules: easy
to scan, the easier the better; highly visual, with shapes and evidence in
place of text (2026-11-04); and every picture where it is needed
(2026-11-08). The chat summary and Recap stay (`docs/preferences.md`,
"Reports").

```powershell
python scripts/report.py studio/brand/report/sample.json   # builds/report-<timestamp>/report.html
```

An agent writes a JSON file and never edits the page; the page holds its
pictures, fonts and logo. `--fragment` leaves out the document skeleton, for a
page hosted on claude.ai, which is private until the owner shares it.

**Anything about a real client** stays out of a hosted page: the JSON file goes in
that client's `reviews/` `Drawer`, the report stays local, and the `builds/` copy
is cleared after use. `--fragment` refuses a report whose data file, evidence
folder or pictures sit under `private/`; a client's words in a JSON file kept
elsewhere stay the author's duty.

## The fields

`title`, `date`, `verdict` and `headline` are required, and every section is
optional; a section with no data does not appear. Inside a section the script
refuses a missing key or an unknown value rather than build a blank page. Words
are labels: a headline of about six words, a card title of about five.

| Field | Shows |
|---|---|
| `title`, `date` | The subject beside the logo |
| `verdict` | `done`, `needs-you`, `running` or `blocked`: the seal and the band |
| `headline`, `next_move` | The biggest line, and exactly one action for the owner |
| `meters` | Rings: `label`, `value`, optional `of`, optional `tone` (`ok`, `wait`, `stop`, `thread`). A ring closes and stays green only at the full count |
| `stages` | The stitch path: `label`, `state` (`done`, `active`, `waiting`, `blocked`) |
| `needs_you` | Decision cards the owner clicks: `title`; optional `figures`, the ids of the pictures the card is about; `options`, two to four, each `label`, optional `detail`, and `recommended: true` on exactly one (it gets the star); and the fold-outs, one to six sentences each: `context` (the refresher), `decision` (what is being decided), optional `example`. His picks fill a box with a copy button, ready to paste to an agent; a second click clears a pick, and Pick the rest never overwrites one |
| `evidence` | Rendered pages, each with an `id` that is a number from 1 to 999 (`"1"`, or `1`), shown as "Figure 1"; number them in reading order (owner, 2026-11-08: numbers are easier than letters): `kind` `page` with `src`, `caption`; or `compare` with `before`, `after`, `before_label`, `after_label`, `caption`. A picture is an image path from the repository root, or `{"pdf": path, "page": n}` (`page` counts from 1, default 1) |
| `reviews` | Bars per gate: `name`, `cap`, `rounds`, each with `verdict` (`findings`, `pass`, `running`), `hard` (blocking findings) and `soft` (all others) |
| `decisions` | What the agent decided alone, grouped by `Decision Grade`: `grade` (`Minor`, `Major`), `title`, `why` (one or two sentences), optional `figures` |
| `changes` | Stitched bars, longest first: `area`, optional `what` (what that area is), `lines` |
| `evidence_path` | The suite's evidence folder, in the footer |

Where a picture goes follows from `figures`, and the script decides it. A
picture that one `needs_you` card alone cites sits inside that card, beside its
options. Any other picture stays under Figures, below the cards, named above
it with links back to each item that cites it; each of those items carries a
"Figure 1" link with the start of the caption, its arrow pointing the way to
scroll. Every picture, in a card or under Figures, has an Enlarge button that
opens it full size (a comparison opens with its slider). Cite every picture a
card asks about or a decision shows; the script refuses an id that no picture
holds, or one item citing an id twice.

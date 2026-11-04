# Report Template

The page for the final report of an unattended run. The owner's two rules
(2026-11-04): easy to scan, the easier the better; and highly visual, with
shapes and evidence in place of text. The chat summary and Recap stay
(`docs/preferences.md`, "Reports").

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
| `needs_you` | Decision cards the owner clicks: `title`; `options`, two to four, each `label`, optional `detail`, and `recommended: true` on exactly one (it gets the star); and the fold-outs, one to six sentences each: `context` (the refresher), `decision` (what is being decided), optional `example`. His picks fill a box with a copy button, ready to paste to an agent; a second click clears a pick, and Pick the rest never overwrites one |
| `evidence` | Rendered pages: `kind` `page` with `src`, `caption`; or `compare` with `before`, `after`, `before_label`, `after_label`, `caption`. A picture is an image path from the repository root, or `{"pdf": path, "page": n}` (`page` counts from 1, default 1) |
| `reviews` | Bars per gate: `name`, `cap`, `rounds`, each with `verdict` (`findings`, `pass`, `running`), `hard` (blocking findings) and `soft` (all others) |
| `decisions` | What the agent decided alone, grouped by `Decision Grade`: `grade` (`Minor`, `Major`), `title`, `why` (one or two sentences) |
| `changes` | Stitched bars, longest first: `area`, optional `what` (what that area is), `lines` |
| `evidence_path` | The suite's evidence folder, in the footer |

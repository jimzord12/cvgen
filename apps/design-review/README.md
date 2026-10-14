# Design Review

The owner's local app for looking through every PDF someone will review and
recording his verdicts (the `Design Review`, `docs/glossary.md`).

```powershell
python apps/design-review/server.py                          # opens http://127.0.0.1:8765/ in the browser
python apps/design-review/server.py --port 8766 --no-browser
```

| File | Role |
|---|---|
| `server.py` | Indexes every PDF with a valid, current `Meta File` (concepts, the `Release`, client renders and `Text Draft`s; the `Output Contract`, `docs/pdf-workflow.md`) and lists the rest as unindexed with the reason; serves the page, page previews and the review state; opens a PDF in the operating system's default program. Binds to 127.0.0.1 only and never sends anything |
| `index.html` | The Board (a run in its `Style` × `Density` × `Design Tier` shape), the Loupe (one design at full size), filters, compare and the `Batch Test` pile |
| `plain-cvs.typ` | The generic market CVs the `Batch Test` pile mixes ours into, rendered once with this checkout's fonts |

The owner's review state (reviewed, verdict, star, notes) lives in
`.local/design-review/state.json`, on this machine only; read it for his
verdicts and notes.

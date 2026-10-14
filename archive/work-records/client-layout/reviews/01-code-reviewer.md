## Review round 1: code-reviewer, 2026-10-14

Snapshot: public `f6aebb4..6a35729` (85741ff, fcc720f, 6a35729); private `3c2fe4b..a0774b4` (d701319, a7a3ab4, a0774b4). Lead lenses: correctness and data safety; test strength.

Verdict: PASS. Recorded in substance (formatting condensed; no client content).

Coverage: `Workspace` gates all four commands and render uses `ENTRY` throughout; approve, export and status never read `inputs/`, so old flat-input revisions keep working; relative reads resolve in the mirrored snapshot; the portrait-collision check still holds; `../../x` refused; no change under `*/revisions/*` or `*/exports/*`; renames R100 except edited sources; each `candidate.json` diff is one `portrait` line; Meta `source` is `typst/cv.typ` and `outputs.py` does not depend on it; the flat-layout refusal comes before any write; one constant and one guard in the owning module; `git diff --check` clean.

Findings
- M1 Minor: `docs/workflow/inventory/b-stages-5-7.md:100,107,143-144` and `c-catalog-and-drift.md:63` name the flat paths; TASK-37 builds from this snapshot. Fix: one line in the inventory README naming the TASK-32 layout change.

Notes
- N1: client-2026-09-01's 2026-09-29 revisions do not reproduce, but that drift predates the migration (their recorded `cv.typ` and candidate hashes already differ at base 3c2fe4b); AC #4 is met by the 10-02 revisions. The task record should say which revisions the proof covers.
- N2: the marine portraits use root-absolute `/private/<folder>/images/portrait/...` paths; a copied or renamed Envelope breaks. Optional: relative paths.
- N3: art generators edited but not run (disclosed).

Checks rerun: read-only `workspace_status`/`workspace_files` on the three migrated workspaces (09-03: 1 revision; 09-02: 0; 09-01: 10, all rendered; no partial exports); `cv.py render` on staged copies then `tests/verify.py --mode exact`: 09-03 vs its last revision and `reference.pdf` equal; 09-02 vs `reference.pdf` equal; 09-01 two 10-02 variants equal; 09-01 default vs 09-29 differs (N1); `outputs.py check --private` exit 0, 34 PDFs, 0 problems; marine `typst/cv.typ` imports only ctx-first names.

Limitations: test strength judged by reasoning (no executed mutations); 09-01 checked through 2 of 8 variants; the reviewer's staged copies under the worktree's builds/ could not be deleted by it (permission refused) and were raised to the owner.

## Dispositions (lead)

- M1: fix. N1: record the proof's coverage in the task record. N2: switch the two marine portraits to relative paths and re-prove both renders. N3: accepted.

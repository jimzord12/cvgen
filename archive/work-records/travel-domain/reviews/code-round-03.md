# Review round 3: TASK-2 (travel-domain)

Snapshot: worktree `C:\Github\cvgen\.worktrees\travel-domain`, head `54cbd2c` (`54cbd2cd0899…`), tree clean. I read the fixes as `git diff 9b582dc..54cbd2c`, in commits `58fea84`, `f726e7a` and `54cbd2c`.
Lead lenses: (2+6) correctness and loud failure; (5) tests and visible evidence.
Coverage:
1. Wiring: unchanged and OK. `render.py` calls `decoration_errors` with the chosen template.
2. Correctness: R2-1 is fixed (verified below). Nothing new.
3. Integrity: the twin's totals are still 2 trips / 30 days / 14 stops. The script list has 11 entries, matching the 11 stops in their new order. "Has passed through" now names exactly the five stops not marked as known.
4. Contracts and privacy: no change to the contract. No old twin values came back.
5. Tests: R2-2 and R2-3 are fixed, and each new case would fail if the behaviour broke.
6. Failure handling: N-a is fixed. `decoration_errors` now turns an `OSError` or `AssertionError` into a check error.
7. Simplicity: OK. The kanji check sits in `stamp()`, so every stamp and seal gets it.
8. Repository and docs: the claims in `hanami.typ:5-8`, `architecture.md`, `verification.md` and `template-contract.md` match the code. LF endings, `ruff` clean. The Framework and marine diff is empty. One stale count: N-1.

## Round 2 findings
- **R2-1 fixed.**
  - `stamp.typ:60-64` limits the kanji to a third of the stamp's width. It measures the same text that is placed (same font, size and weight).
  - In `hero.typ:149-180`, the rank · region · native line is now an unbreakable `box`. It is checked against GX−19 mm, and the band-height measure uses the exact `block-body` that is placed.
  - My stress cases at this head:
    - The three overflows I showed in round 2 now fail with their own messages. That covers `日本・韓国・台湾`, `福岡・長崎・熊本`, and "Japan and Korea" with an 11-character native name; that last case raises both the page-2 error and the stamp error.
    - `日本列島` and `대한민국` (4 characters) fail loudly.
    - Three characters fit cleanly inside the inner ring: `北海道` on the 21 mm seal, and `鹿児島` and `北海道` on the 26 mm trip stamps (crops below).
- **R2-2 fixed.** `run.py:320-325` sets a word on a known petal on each page through `petal-probe.typ`. It then asserts that pages [1, 2] are reported, and that `decoration_errors` gives 2 errors.
- **R2-3 fixed.** `coverage.py:59-63` asserts that no marker sits inside another, for every fixture in every Domain. The travel route markers are now `ZQA` and `ZQB`, and the overlapping markers were renamed.
- **N-a** fixed (custom compositions are left unchecked on purpose; the docstring says so). **N-b** fixed: each page-2 line has its own message, and `many-links` tests the new wording. **N-c** is with the owner. **N-d** fixed.

## Findings
### N-1 Note: the petal-removal count in `docs/framework-gaps.md` is out of date
Anchor: `docs/framework-gaps.md:137`, item (3): "six that met the twin's words were removed".
This round removed two more from `petals-p2-field.svg` (41 to 39), so the count is now eight.
Fix: update the count, or say "those that met the twin's words".

### N-2 Note: the kanji message on a non-kanji native name
`대한민국` fails with "the kanji … use one place name of up to three characters". The failure is correct and loud; only the word "kanji" is off for Hangul. Optional rewording.

No Blocking, Material or Minor findings.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py` at `54cbd2c`: exit 0, PASS, 224 cases. Evidence in `C:\Github\cvgen\.worktrees\travel-domain\builds\tests-20261108-130437-369488`.
- Stress compiles (7 variants), with crops of the 3-character kanji stamps, in `C:\Github\cvgen\.worktrees\travel-domain\builds\review-travel-r3-20261108-130450`. Script at `C:\Users\jimzord12\AppData\Local\Temp\claude\0bad7b43ffb974fe\bd07fd7a-826f-4da0-ace1-f4e996f70146\scratchpad\r2\stress4.py`.
- `ruff check`: passed. CRLF check on the changed files: only the binary reference PDF matches.

## Evidence inspected
At `54cbd2c`:
- `hero.typ`, `stamp.typ`, `sections.typ` (the trip stamp call), `hanami.typ`;
- `decoration.py`;
- `tests/run.py`, `coverage.py`, `fixtures/travel.typ`, `fixtures/petal-probe.typ`;
- the coverage fixture and its markers, the twin JSON, the petal count in `petals-p2-field.svg`;
- the docs diffs, the task record's "Round 2 fixes", and the stored `code-round-02.md`.

## Limitations
- I did not read `private/`.
- I did not run `render_revision` end to end for a Hanami workspace.
- The visual verdict on the regenerated Frozen Reference candidate belongs to the design-reviewer, and the owner still has to approve it.

## Verdict: PASS

# Review round 1: TASK-2 (travel-domain, P-0013 steps 3 and 4)

Snapshot: worktree `C:\Github\cvgen\.worktrees\travel-domain`, base `114c6de` (merge-base) to head `9298891`, tree clean at head. Patch `git diff main...9298891`.
Lead lenses: (1) correctness and loud failure of the data model, contract and Hanami; (2) public content is fictional.

Coverage:
1. Wiring: OK. The entry point, `lib.typ`, the `release.json` row and the `build.ps1` style all reach Hanami.
2. Correctness: F1, F3.
3. Integrity: F3. The totals are computed once from the full record (`data.typ:21-26`, `hero.typ:97-100`), which is correct.
4. Contracts and privacy: F2, F4, F5.
5. Tests: F6, N3.
6. Failure handling: F1, F2.
7. Simplicity: the absolute placement and petal bypasses are logged in `framework-gaps.md`. OK.
8. Repository and docs: F1 (wrong doc claim), N1. Text files use LF. The Framework, marine and cv-workflow are untouched (`--stat` empty).

## Findings

### F1 Material: fields outside the two slots overflow silently (constitution 4)
Anchor: `templates/hanami/components/hero.typ:185-186` (rank tab), `:102-111,173-174` (contact columns), `:120,133` (route city labels), `:208-220` (page-2 band block), `:228-229` (seal guard). Also `hanami.typ:5` and `docs/architecture.md`, which both say "each field is a slot that fails loudly".
Scenario: I compiled the twin with ordinary longer values. Every compile exited 0 and rendered broken pages. Files are in `builds/review-travel-r1-20261108-123627/`:
- Rank "Senior Tour Leader and Escort": the text wraps out of the 38 mm tab, over the portrait ring and the plate (`rank-p1.png`).
- A 50-character email:
  - page 1: the address wraps into the torii post (`email-p1.png`);
  - page 2: it runs under the travellers drawing (`email-p2.png`).
- City "Thessaloniki Makedonia Airport": the label runs under the name plate (`city-p1.png`).

The seal guard at `:228` can never fail. Its second clause is always true: 6+17 = 23 mm < 35−18.9+8 = 24.1 mm.
Expected: a compile error that names the fix, as the plate name already gets (`:188`).
Fix: add measure-and-assert checks for:
- the tab text (width within 38 mm, one line);
- each contact value (width within 50 mm, or a line cap);
- each route label (it must end before the plate);
- the page-2 band block (height within the band, and width clear of the art at `GX`).

Make the seal guard real. Add failing cases to `tests/fixtures/travel.typ`, and correct both doc claims.

### F2 Material: the contract says `destinations` is optional, but Hanami refuses a record without it
Anchor: `contracts/v1.json:11`, `hanami.typ:44`, `tests/coverage.py` (`bare` assertion, new lines 139-140).
Scenario: a client record without `destinations`. `choose()` accepts it with `dropped: []`, and the suite asserts exactly that. The render then stops with "the record needs destinations".
Expected: the pre-render check refuses it, or Hanami can render it. Under `template-contract.md`, required groups follow only from the contract version, so a Template cannot require an optional group.
Fix: make `destinations` required in travel v1 (no client record follows v1 yet) and turn the `bare` assertion into a refusal. If you keep it optional, Hanami must render page 2 without it.

### F3 Material: a second `story` is dropped silently
Anchor: `hanami.typ:47` (`trips.find(t => "story" in t)`); the schema `$defs/trip.story` allows a story on every trip.
Scenario: I added a story to trip 1 (`story2.pdf`). The compile exits 0, and "Planning the 18-day trip" is missing from the PDF.
Impact: the candidate's facts are lost with no message. The contract check works per group and cannot see this.
Fix: one assertion in `validate-candidate`: at most one trip has a `story`. Note the same rule in the schema description.

### F4 Material (an evidence gap; no leak is proven): nothing shows the twin's facts are invented
Anchor: `examples/candidates/tour-leader-example.json`; task record "Result and evidence"; `docs/history.md` ("none of its facts").
I did not read `private/`. Within the diff:
- The twin's details come from no public source. The public Hanami Line 2 `sample.json` is a different person. The details: DOB 18 August 1999, JLPT N3 July 2023, two trips (April 2023 with "two cousins", October 2024 with "four colleagues"), the stop lists, the typhoon north of Sendai, the Shirakawa-go farmhouse, Erasmus+ in Ljubljana 2022, Amadeus/Sabre.
- Commit `868a82c` removed "Athens" from two incidents. That suggests the twin was made by editing the real text.

No field-by-field check is recorded.
Fix: the lead, who may read `private/`, records in the task record a field-by-field comparison with no client values in it: name, employers, institutions, dates, DOB, trips, stops, incidents, credentials. Replace any fact that matches.
If anything matches, also rewrite the branch history before merge. `3885252` and the first reference PDF keep the old text. The branch is unpushed: no remote ref contains `3885252`.

### F5 Minor: the phone number can be dialled
Anchor: `tour-leader-example.json:13`. "+30 699 000 0471" is a valid Greek mobile format; every other example uses "+00 000 000 000". It is also in the Frozen Reference candidate.
Fix: use the repository's precedent before the owner approves the reference.

### F6 Minor: some Coverage Fixture markers prove less than claimed
Anchor: `fixtures/coverage-v1.markers.json:14-15`.
- "Qxfrom" (route city) is also matched by the availability text "Qxfrom when".
- "Qxstop" is also matched by the rim word (`squeeze` casefolds).
- `portrait` ("image") is satisfied by the petal rasters (comment at `run.py`, new line 327), so `portrait@1` is proved vacuously.
- The seal words have no marker.

Fix: give each field a unique marker, and prove the portrait by image count against a fixture without a portrait.

### N1 Note: "fictional twin" is now a recurring term
It appears in the proposal, `history.md`, `domains-and-roles.md` and `verification.md`. Propose a glossary row.

### N2 Note: the petal check runs only on the twin in the suite
A client render through `cv.py` (TASK-81) does not run `petal_collisions`. This is logged as a gap. Consider wiring it in before TASK-81.

### N3 Note: the Frozen Reference candidate is self-generated
Until the owner approves it and it is pinned in `tests/baseline.json`, the pixel check proves the render is stable, not that it is right. This is already stated.

## Checks rerun
- `python tests/run.py` at `9298891`: exit 0, PASS, 214 cases. Evidence in `builds/tests-20261108-123538-064205`. The engineer and tour-leader references are raster- and text-equal; the Hanami coverage is 8 of 9.
- Stress compiles via `typst compile -` (six variants): all exit 0. Script at `C:\Users\jimzord12\AppData\Local\Temp\claude\0bad7b43ffb974fe\bd07fd7a-826f-4da0-ace1-f4e996f70146\scratchpad\stress.py`; output in `builds/review-travel-r1-20261108-123627`.
- `python scripts/outputs.py check`: 19 PDFs, 0 problems.
- `git diff --stat main...HEAD -- packages/cv-framework packages/domains/marine packages/cv-workflow`: empty.

## Evidence inspected
At `9298891`:
- the travel package: `data.typ`, `domain.typ`, `lib.typ`, contract, schema, fixtures;
- Hanami: `hanami.typ`, `components/*`, layout, theme, artwork, manifest;
- the twin and its entry point;
- the tests: `run.py`, `coverage.py`, `travel.py`, `fixtures/travel.typ`, `verify.py`;
- `build.ps1`, `release.json`, and the docs diffs;
- the SVG assets: no text, comments or metadata;
- commit `868a82c`;
- for comparison: `contracts.py`, `base-v1.json`, Flagship's manifest, and the Hanami Line 2 `sample.json` and brief.

## Limitations
- I did not read `private/`, so lens 2 rests on the diff alone (F4).
- The design and visual verdict is the design-reviewer's.
- One read-only helper command of mine (`python -` with a heredoc) went to the background and may still be running. It writes nothing.

## Verdict: FINDINGS

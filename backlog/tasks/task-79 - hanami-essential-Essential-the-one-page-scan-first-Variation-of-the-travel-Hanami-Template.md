---
id: TASK-79
title: >-
  hanami-essential: Essential, the one-page scan-first Variation of the travel
  Hanami Template
status: Active
assignee: []
created_date: '2026-11-08T10:07:00Z'
updated_date: '2026-11-08T15:51:00Z'
labels: []
milestone: m-2
dependencies: []
ordinal: 79000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: lead (Claude Code)
Branch/worktree: feat/hanami-essential
Integration target: main
Depends on: TASK-2 (the travel Domain and the Hanami Template)

## Outcome and boundaries
The first scan-first Template Variation (P-0019 section 9, owner 2026-11-04 and 2026-11-08): one full page, a practical CV chosen by the operator for any Rank, the portrait optional per Client, first-scan fields in fixed prominent places, no type shrinking, a light Hanami touch. Designed with design-reviewer and codex-visual-reviewer rounds on the fictional twin; judged by the Scan Test with Flagship Parity and the Batch Test judging craft. The owner approves the look and its Frozen Reference. Marine Flagship Essential is TASK-67, a later run.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 The essential Variation renders the fictional twin on one page and passes design-reviewer and codex-visual-reviewer
- [ ] #2 The owner approved the look; its Frozen Reference is in the suite
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read the contract, research, Hanami source and prior art.
2. Build layouts/essential.typ and an essential composition (components/essential.typ) inheriting Hanami theme, type and artwork; one A4 page, fixed slots, loud failures.
3. Long careers: recent roles in full, older summarised with totals from the data; fail loudly otherwise.
4. template.json: essential variation, designBar scan-first, supports travel upTo 1 with the groups it shows; coverage proves it.
5. Fixtures: twin, twin without portrait, long career, Greek copy; renders under builds/.
6. Frozen Reference candidate and suite pixel check; entry point with variation essential.
7. Docs: template-contract.md, Hanami docs, build-a-cv guide; Workflow anchors and Atlas.
8. tests/run.py and ruff pass; marine and showcase pixel-identical.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence (round 1, before design review)

- Built: layouts/essential.typ, essential.typ (composition), components/essential.typ; hanami.typ dispatches on the variation and checks the layout against the manifest; template.json essential (pages 1, designBar scan-first, travel upTo 1: profile, education, languages, portrait, availability, practical, references). Showcase unchanged (pixel check passes).
- Long careers: the newest roles in full, the older in one summary with experience-totals (data.typ, domain.typ); fails loudly when the newest role alone overflows or a summarised career is not newest first.
- destinations is shown as a summary (trips, stops, totals) but not claimed in v1 (no stamps, route or story): dropped with the warning by design; TASK-80 should split it.
- Entry point examples/travel/hanami/tour-leader-essential.typ (release.json); Frozen Reference candidate tests/approved/Travel-Tour-Leader-CV-Essential-v01.pdf, not pinned in baseline.json (owner approval pending).
- Fixtures: tests/fixtures/travel-essential.typ (no portrait, indigo, sky, greek, long career, long career Greek, no destinations; failures overflow, unsorted, long name, showcase layout), tests/fixtures/tour-leader-long-career.json.
- Docs: engine/template-contract.md, architecture.md, verification.md 6b, domains-and-roles.md, glossary, guides/build-a-cv.md (choose and record the Variation), Workflow Model lead.write-flagship-entry, anchors, Atlas.
- Evidence: python tests/run.py PASS (builds/tests-20261108-125057-630396), ruff clean; review renders builds/hanami-essential-r1-20261108-125152/.
- Open: design-reviewer and codex-visual-reviewer rounds; owner approval of the look, the scan-first bar and the Frozen Reference.

## Rounds 2 and 3, and contract version 2 (2026-11-08)

- Design round 1 (design-reviewer FINDINGS D1-D9, Codex PASS) fixed in b665f55; round 2 (D10-D12) fixed in the next commit. Review files in archive/work-records/hanami-essential/reviews/.
- Merged feat/travel-contract-v2 (TASK-80). Essential supports travel exactly [2] (version 1's required destinations holds the route, stamps and story, which one page cannot show), claims destinations@2 and licences@1, leaves travel-story out; licences beside the lead, each trip's role after its period, the areas, the rank's seal words on the band.
- Evidence: tests/run.py PASS (builds/tests-20261108-131156-155946), ruff clean, Workflow Model and Atlas checked.

## Rounds 3 to 5 and code review (2026-11-08)

- Design rounds 3-5: D13-D22 fixed (licence on the rail when the lead is full, fields 8 mm under the profile row, Greek dates from copy.months, whole role labels, the wash ends at short content, thin-page operator warning via <cvgen-warning>). Round 5 PASS on nine renders; D16 (stops listed twice) open as a Note until a later destinations version. Codex rounds 1-5, round 5 PASS (A, B, C).
- Code round 1 PASS with F1-F3 Minor, N1, N2: all fixed in 5eb12b7 (overflow names its cause, cv.py status lists template warnings, warning path and overflow asserts tested, explicit eval flags). The new workspace test found a real bug, fixed in c80f149: the petal check ran on essential and failed every essential client revision.
- Code round 2 PASS with F1, F2 Minor, N1-N3: F1 (petal check proved on 'showcase'), F2 (gap entry and docstring say showcase only) and N1 (PETAL_EXEMPT lists the exempt Variations, so a new one is checked) fixed; N3 left as a Note (both paths read correctly).
- Reviews verbatim in archive/work-records/hanami-essential/reviews/.

- Code round 3 PASS (no findings above a Note). Travel-domain code round 3 N-1, N-2 applied in 39f096a.

## Owner review of the look (2026-11-08)

Owner: more bold in the bullets; practical know-how hard to scan; for the client a generic, not Japan-focused page; a monochrome that looks good; the portrait tool is another branch. Built: the lead-in display rule (no contract change), know-how as a labelled list, themes/monochrome.typ, artwork/plain.typ (route arc, no kanji), the essential twin tour-leader-essential-example.json (showcase twin untouched, its reference approved), a generic client-shaped fixture. The essential Frozen Reference candidate is re-rendered.

## Round 7 fixes (2026-11-08)

R4-1 the plain arc measured from the name and rank row, left out under 30 mm; D23 the generic fixture at the client's real length, thin-page warning raised to 80%; D24 basics on their own line; D25 long-career lead-ins and the guide's all-or-none rule; Monochrome portrait plate d9d9d6; a prepared cut-out portrait (feat/portrait-prep's tool) as a fictional fixture, colour and grey; R4-2 artwork packs checked against the manifest; R4-3 generic-japan run, motif swap asserted; R4-4 time and URL lead-ins; R4-5 glossary Lead-in; D29 Monochrome drops the blurred petals; D28 heavier arc without a portrait. D26 (ink band) not built.

## Round 8 fixes (2026-11-08)

D30 the generic record gains a highlight row from its own facts, gaps may grow to 14/16 mm when the column still ends over 25 mm short, the thin-page warning judges each column (the smaller fill), a three-quarters case (64%) must warn; D31/R5-1 the route arc is left out under 45 mm with a <cvgen-warning>; Codex D1 a 2.4 mm gap between a trip's date and day count; long-career destinations headed Japan and Korea; R5-2 tests/fixtures/portraits/provenance.json; R5-4 the glossary's 40-character limit, every artwork pack needs a name, the arc weight's SVG strings asserted.

Depended on TASK-83 (feat/portrait-prep) merging into main first, for scripts/portrait.py prepare: satisfied, main merged in at 78b498e.

Round 9 (polish): roomy role gap capped at 11 mm (section stays 16 mm); fill judged at the ordinary caps before roomy growth, and a page under 80% is not stretched; the warning names the thinner column (career column or rail) with its own remedies; the arc warning names what binds (the rank row, with what to cut, or a long name, which needs nothing); when any trip tag would wrap, every tag takes its own line. New loud failures: unnamed artwork pack, route-arc SVG without the weight strings. Fixture data: generic availability reads first; twin consultant cell leads with '25 to 40 trips a year'. Essential reference candidate regenerated; showcase reference untouched.

## Code rounds 4 to 8 and the main merge (2026-11-08)

Reports: archive/work-records/hanami-essential/reviews/code-round-04.md to code-round-08.md.
- Code rounds 4 to 6 PASS; their Minors (R4-1 to R4-5, R5-1 to R5-4, R6-1 to R6-4) are fixed in the round 7 to 9 notes above.
- Code round 7 PASS: R7-1 (the arc remedy names what binds) and R7-2 (trip-tag count asserted) fixed in 78425ed; R7-3 (merge conflicts) handled in the merge.
- Merge of main (TASK-83, the portrait tool) at 78b498e: anchors regenerated against the merged tree, main's portrait wording kept, Atlas restamped.
- The generic fixture's fictional person is Nikos Kontos, to match the male fictional portrait (9306fa2, 330f0f5, b436a2d).
- Code round 8 PASS: R8-1 (two Atlas pages stale after 330f0f5) restamped; R8-2 (arc warning described as 'what to change') reworded here and in verification.md; R8-3 this entry. N-3 provenance.json now says the tool is on main. N-1, N-2, N-4 and N-5 stay Notes.
<!-- SECTION:NOTES:END -->

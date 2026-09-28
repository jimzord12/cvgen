# Review round 3: short-career-layout

Stored as returned by the `code-reviewer`; the lead's dispositions follow at
the end.

# Review round 3: short-career-layout

Snapshot: feat/short-career-layout, base 48933f5, head d3d98e9 (HEAD verified, working tree clean). I examined the fix diff `git diff 5470f43 d3d98e9` and the full change.
Lead lenses: (2) correctness, (5) tests
Coverage:
1. Wiring: nothing changed in the path from `deck-cadet.typ` to `one-page()`. The fix is in the only page loop, and `spread` is read with `default: false`.
2. Correctness: `has-certificates` and `has-education` are exactly the old conditions, under names. The only new behaviour is gated on `spread`, so v11 and every `spread: false` plan are unchanged, and my rerun kept the v11 exact match. With spread on, both-present, no-certificates and no-education all give two gaps. Edges with anchor-education off, multi-page plans and both sections missing are covered in N13 and N16.
3. Data integrity: n/a. Fictional fixtures only, and no data or workflow code changed.
4. Contracts: n/a beyond `spread` being optional. No schema changed.
5. Tests: the new assertions catch F5 and N10 regressions, but one gap remains (N14). The word anchors are unique on all four PDFs, and a missing anchor fails loudly (StopIteration).
6. Failure handling: the overflow case still fails with "Content overflow on planned page 1".
7. Simplicity: the change is 6 lines in the owning page loop. No scope creep.
8. Repo/docs: LF endings throughout, and the commit scope is coherent. The glossary row is well formed. Small wording points are in N15.

## Findings
### N13 Note: `spread` assumes anchor-education and a one-page plan
Anchor: `flagship.typ:50-61`; `layout-and-pagination.md` §anchor-education
Scenario: `spread: true` combined with `anchor-education: false`, or with a multi-page `pages` override.
Actual (from the code):
- anchor-education off, both sections present: one gap, above certificates.
- anchor-education off, education missing: two gaps.
- A page that holds only the synopsis: the synopsis now sinks to the page bottom. This is new behaviour.
No shipped layout combines these; the one-page profile inherits `anchor-education: true` and has one page.
Fix: one sentence saying `spread` assumes `anchor-education: true` and puts synopsis, certificates and education on the same page.

### N14 Note: the >15 mm floor does not separate the two cases, and a third gap goes unnoticed
Anchor: `tests/run.py:203-215`
Scenario 1: the no-spread gap between the "Grace" row and "TOTAL" is already 15.2 mm (one-page-one: 131.6 to 146.8 mm). Without the F5 fix, `first > 15` still passes. The regression is caught only by `abs(first-second) < 8`, because the other gap would be about 90 mm. So the F5 fix is protected, but only by the diff check.
Scenario 2: a regression that also adds a `v(1fr)` above the synopsis when both sections are present gives three shares. On `one` that is about 19.4 mm and 16.2 mm, which passes, while the synopsis drifts off the experience block.
Optional fix: on `one`, assert `top(TOTAL) - bottom(Grace) < 17`, meaning the synopsis stays attached to the experience block.

### N15 Note: small wording inaccuracies
- `architecture.md:169-170` says "[v(1fr)] before the synopsis **instead**". It is added, not a replacement: with no education, both the synopsis gap and the certificates gap render.
- `layout-and-pagination.md:113-115` says spread "adds a second … flexible space … (before the synopsis …)". With education missing, spread supplies both gaps.
- The glossary `Capacity Rule` row says "14 or less fits" but drops the reference doc's qualifier (measured on the cadet record; a longer profile or more education lowers the limit).

### N16 Note: with both closing sections missing, the synopsis sinks to the footer
Schema-valid (only identity and companies are required), but unrealistic, since every cadet holds STCW basic safety. The docs do not mention it. Optional.

## Checks rerun
- `python tests/run.py` at d3d98e9: exit 0, "PASS: 61 compilation cases plus PDF/data/layout assertions". The v11 exact check is included. Evidence: `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260928-143535-460253\`
- PyMuPDF word positions on the author's one-page PDFs, read-only (anchor uniqueness and the gap values below).

Gaps measured (first / second):

| Case | First gap | Second gap |
|---|---|---|
| one | 24.9 mm | 21.7 mm |
| no-education | 54.5 mm | 50.8 mm |
| no-certificates | 53.7 mm | 48.9 mm |

## Evidence inspected
At d3d98e9:
- `packages/domains/marine/templates/flagship/flagship.typ`, `components/sections.typ`, `layouts/flagship-one-page.typ`, `layouts/flagship-v11.typ`
- `tests/fixtures/one-page.typ`, `tests/run.py:140-216`
- `docs/architecture.md`, `docs/reference/layout-and-pagination.md`, `docs/reference/verification.md`, `docs/glossary.md`, `.claude/skills/new-cv/SKILL.md`

Author evidence in `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260928-143300-346332\`: the one-page PDFs and `one-page-no-education.png` (two even gaps, as the docs say). I also read the round-2 code and design reports and their dispositions.

## Limitations
- The Trello card was not read (external).
- Whether a synopsis floating mid-page on a no-education record is acceptable is a visual taste call, and no design-reviewer round covered the new no-education / no-certificates renders. The owner approved only the both-present cadet page.
- The N13 and N14 effects were derived from the code and the measurements, not rendered as probes.

## Verdict: PASS
There are no Blocking or Material findings; N13-N16 are optional.

## Dispositions (lead)
- PASS. After the round, the owner changed the missing-section behaviour: blocks stack from the top instead of two gaps (see 03-design-reviewer dispositions). The fix reworks the same lines.
- N13 fixed: the layout guide says `spread` is for one page with synopsis, certificates and education and `anchor-education: true`; with a section missing it now turns the anchor off.
- N14 fixed: on `one` the suite asserts the synopsis stays within 17mm of Experience; the missing-section cases assert every gap is under 17mm.
- N15 fixed: architecture.md and the layout guide describe the new behaviour; the glossary row carries the qualifier.
- N16: with both closing sections missing, the synopsis now stays under Experience (stacked); no further change.

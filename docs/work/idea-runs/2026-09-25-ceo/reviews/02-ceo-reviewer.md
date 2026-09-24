# CEO review round 1: 2026-09-25

Reviewer: ceo-reviewer brief, run as a general-purpose agent. Checked
against vision, proposals README (`rejected/` empty), framework gaps, the
build guide, `packages/cv-workflow`, the marine schema, example records and
the `feat/candidate-validation` diff (shape checks only; no duplication).

## certificate-validity-check.md: PASS
- C1 Note: "a render refuses" is loose; render keeps the revision, approval
  and export are refused while the check fails.
- C2 Note: the 180-day window is unsourced; mark it as judgement.
- C3 Note: a hand-drawn certificate table in a custom `cv.typ` is not
  checked; one Risk line.
- C4 Note: certificates come as 4-element arrays or objects; the check must
  read both.
- C5 Note: anchor on vision principle 4 (loud failure), not "premium,
  facts-checked".

## vessel-particulars.md: PASS
- C1 Note: quote the width margin on the longest example name ("MV Adriatic
  Express", about 15 pt wider, still fits).
- C2 Note: "same vessel id repeats the same values" cannot be JSON Schema;
  say where it lives.
- C3 Note (taste): no public example shows the feature; ask the owner about
  a showcase.

## candidate-intake.md: FINDINGS
- C1 Blocking (Real need): the framework-gaps entries are template limits,
  not late facts; an intake would not have prevented those bypasses. Reword
  (the intake surfaces such needs early so a bypass can be planned) or drop
  the log as evidence.
- C2 Note: make the slot conditional on the first client's field.
- C3 Note: the problem cites visas; add a question mapping to contacts.
- C4 Note (taste): the questionnaire could double as the owner's call script.

## Verdict: FINDINGS

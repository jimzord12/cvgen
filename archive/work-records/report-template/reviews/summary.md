# Report Template reviews, rounds 1 and 2

Date: 2026-11-04. Reviewers: design-reviewer and context-reviewer, each fresh every round.

## Round 1
Design, FINDINGS: seven blocking (mojibake without a charset; the verdict too small to see; a ring hiding the one open item; no legend for the recommended option; yellow with two meanings; Decisions with no shape; light-theme contrast), twelve notes.
Context, FINDINGS: one blocking (Critical did not match the owner's lists), nine material (vision missing from "He decides", grades as a paragraph, Major looser than his words, placement in "Reports", no `Decision Grade` term, README against template, no validation, a privacy rule too narrow), minors.
Response: all blocking and material findings fixed; fonts, logo and pictures embedded; `tests/report.py` added.

## Owner's review (2026-11-04)
He asked for three fold-outs per decision, two to four clickable options with the recommended one marked, a box collecting his picks with a copy button, legends on Reviews and Lines changed, and more context on decisions taken in a layout that holds many. All built.

## Round 2
Design, FINDINGS: six blocking (the answer box clipped its text; Copy with no picks copied the hint; Pick all overwrote hand picks and a pick could not be cleared; cards 4 and 5 lacked an example; Decided without you had no shape; the legend misreported a running gate), notes and nits.
Context, FINDINGS: four material (stale suite description, README against the script, validation short of the README, a grade table half duplicating the bullet), five minors.
Response: fixed. D23 in part: both examples added, and `example` stays optional, as the owner said ("if the decision does not make sense to have an example, just don't add it"). D27 (evidence still below the decisions) left as it is: he approved that section's place.

## Round 3 and the code review
Design, FINDINGS: D20 to D25 confirmed fixed in the browser. One blocking: stored picks keyed on title and date could turn into a decision he never made after a rebuild, or kill the box (D28). Notes: the box did not refit on resize; a gap under short titles.
Code, round 1, FINDINGS: six material (data that passed and rendered blank; `hard` and `soft` unescaped; evidence with no picture; stored picks becoming another answer; an out-of-range stored pick killing the box; tests that could detect none of it), five minors, two notes.
Response: `refusal()` checks types, per-`kind` keys and non-empty values; the store key holds the cards and stale picks are dropped at load; `total` is escaped; substitution is one pass; `--fragment` refuses a client's path; each refusal is tested on its exact message. The page's script is still not run by the suite: a design review drives it, and the verification manual says so.

## Code review, round 2
FINDINGS: four material (the private-path guard passed by absolute and climbing paths; a meter closing its ring on a non-count; `recommended` accepted as text; text fields not type-checked), four minors, one note. Picks, clearing, Pick the rest and Copy confirmed in Chrome 156.
Response: all fixed. Failures now end in a refusal, not a traceback, and a failed report leaves no folder. Each rule has a test on its exact message. This file holds summaries, not the reports verbatim as `docs/review.md` asks; the same holds for P-0019's and the research note's reviews. The owner is told in the final report.

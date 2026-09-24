# Research review round 2: docs/work/idea-agents/research.md

Reviewer: research-reviewer brief, run as a general-purpose agent.
Subject: research.md after round-1 fixes, plus the idea-run skill sentence
on why the lead runs the loops.

Claims checked: 11 load-bearing, 11 confirmed, 0 unreachable.

All seven round-1 findings resolved. R1: sub-agents.md confirms nesting is
on by default up to three layers and is stopped by omitting `Agent`; none
of the six agent files lists `Agent`. R2-R7 match their sources (effort
values, OFL FAQ 1.13 and 1.20, foundry clause D8, Compendium §906.5,
synthesis labels, the 1-5 scale caveat).

## Findings

### R1 Note: same-model reviewers go against guidance already cited
https://platform.claude.com/docs/en/test-and-evaluate/develop-tests says it
is generally best practice to evaluate with a different model than the one
that generated the output. All authors and reviewers use `opus`. Fix: cite
it, and either accept same-model reviewers deliberately or name another
model.

### R2 Note: Typst Universe line has no URL
Cite https://typst-community.github.io/extra-docs/packages/resources.html
[O, community docs].

## Coverage check
One search confirmed the Typst Universe line; develop-tests re-read.

## Verdict: PASS

## Disposition (lead, 2026-09-25)
R2 applied. R1 applied as a recorded, deliberate choice: reviewers stay on
Opus, the strongest judge available, because the owner's standing rule pins
Opus for reviewers and a weaker judge is the larger risk for premium work;
self-preference is mitigated by fresh contexts, a fixed rubric and the
owner's own verdict. Revisit if reviewers prove lenient on the owner's
rejections.

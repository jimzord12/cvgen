## Context review round 2: TASK-74 (plan-reviewer)

**Snapshot:** c7389f6..1e00f50, limited to `.claude`, `docs` and `backlog`. I read the touched files whole at 1e00f50. I used calibration 03 and its answer key as evidence only.

**What I expected before opening the diff:** the round 1 fixes stay inside their owners. Question 13 states a generic principle: before building, test a new model against the hardest real cases. It should fire on any new model, schema, format or vocabulary, and not on plans that introduce none. It should not be fitted to the one plan that prompted it.

### Round 1 fixes
- **M1 holds.** `docs/review.md:90-91` now says the reviewer's severities are its own, which matches `:246` and the agent's Bar.
- **M2 holds.** The same timing appears at `review.md:17-19`, `:42-43`, `:87-88` and `development.md:20-21`.
- **M3 holds.** There is one wording issue, m1 below.
- **M4 holds.** Question 12 now uses "such as" and lists the reviewer's added situations; the agent reads "and any others the routine meets".
- **m1 holds.** The rule now names who adopted it ("adopted by the lead"), and `:269-270` points to the pair.
- **m2 holds.** Question 12 is down to 8 lines, and the rationale is left to the agent file.
- **N1 and N2:** I accept the dispositions.

All four files use LF only; I counted with `python -c`. The agent's count now reads thirteen and 1-13, and no other file states the old count. Nothing identifies a real client.

### Material

**M1. Question 13 repeats round 1's M4 problem: its examples are a closed list taken from the answer key.** `.claude/skills/plan/SKILL.md:136-141`
- The question covers "a model, schema, format or vocabulary". But the cases after the colon are the calibration diagnosis almost word for word (`03-plan-reviewer-workflow-model.md:32-36`): a choice with more than two outcomes, a loop or an edit in place, an item with no inputs or no outputs, one word used two ways.
- Three of those four only make sense for a process graph. A plan that adds a data schema or a file format gets no case that fits it, so a reviewer may mark the question "n/a" or only check for loops.
- As in round 1 M4, the colon reads as a definition, not as examples.
- It holds nothing specific to CVgen, and the placement is right.
- **Smallest fix:**
  - "…before building, such as a choice with more than two outcomes, a loop or an edit in place, an item with no inputs or outputs, a value that is optional, repeated or missing, one word used two ways in the sources, and any other the sources hold."

### Minor

**m1. The list of when a plan is needed now appears a third time, and this copy drops a trigger.** `docs/development.md:17-18`
- The parenthetical repeats the skill (`SKILL.md:21-24`) and `review.md:83-85`, but leaves out "or the owner asks for one".
- The pointer to `review.md` lets a reader recover the missing trigger, so the risk is low. Still, it is the drift that a third copy invites.
- **Fix:** replace the parenthetical with a pointer: (the `plan` skill, "When a plan is needed").

**m2. Three edited passages were not re-wrapped.**
- `docs/review.md:43` is a new 130-character line, followed by a short `:44`.
- `docs/development.md:22` and `.claude/agents/plan-reviewer.md:55` are left as short lines.
- **Fix:** re-wrap the three paragraphs.

### Notes

- **N1.** "Real cases" in question 13: in this repository, the sources for client data are in `private/`, which the reviewer must not read. The bullet at `review.md:117-118` already covers this: the plan states how `Envelope`s are checked. No change needed.
- **N2.** `development.md:209` uses **Plan** for a task's Implementation Plan field (`--plan`), a third meaning beside the plan file and the plan's source. The `Plan` glossary term deferred to T5 should separate them.
- **N3.** Question 13 is unproven. The task notes say so honestly (it was added after seeing the key), and the score is not rewritten. Do not count it toward AC 3 until a later plan exercises it.

Verdict: FINDINGS

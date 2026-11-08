Context review, round 2: TASK-73, context placement (9b06670..f17ca23; fixes in e8a2558..f17ca23)

Before reading the diff, I wrote down the principle the feedback implies. Each rule has one home, chosen by four questions asked in order, and the first yes wins. A convention for an activity that more than one agent does or checks, the lead included, goes into that activity's skill rather than the reviewer's file. Agent files and skills should stay reusable in another repository. Nothing in the change should add `*.spec.*` as a rule.

**Round 1 fixes: all hold**
- Finding 1 holds. Question 1 (`context-maintainer.md:55-57`) now leaves out anything that another agent doing or checking the same work also needs. Read literally, the triggering case is no longer settled at question 1.
- Finding 2 holds. `docs/conventions.md:140-143` is on the lead's path ("writing code, docs or a commit"). It points to the owner and says to read the questions before writing an agent file or a skill.
- Findings 3, 4, 5 and 7 hold. `new-cv` and `backlog` exist in `.claude/skills/`. The new wording agrees with step 1 (lines 86-92) and with `context-reviewer.md:43-45`.
- Notes 8 to 10 are handled correctly. The plan is revised in place under D2, which its status line now states, so editing it is not editing a dated record.
- All six touched files are LF (0 CRLF). No client data appears anywhere in the range. Nothing touches `*.spec.*`.

**Minor**

1. `.claude/agents/context-reviewer.md:43`: the re-wrap for finding 6 moved the overlong line down one line instead of removing it. Line 43 is now 79 characters; its neighbours are 71 to 76. Fix: end line 43 at "…the essentials of a" and carry "rule" onto line 44, re-flowing the rest of the paragraph.

**Note**

2. `context-maintainer.md:58-60` against `:64-69`: nothing says where question 2 ("a CVgen … rule") ends and question 4 ("a convention of one activity") begins. The triggering example sits right on that line. A test-file suffix is a choice this repository makes, and `docs/conventions.md:102` already owns test-file naming (`model.test.ts`, "a role suffix stays dotted"). An agent following the questions literally would stop at question 2 and amend `docs/conventions.md`; the owner put the example in the test skill. Either home meets the owner's real concern, because the lead reads both before writing a test. Still, the maintainer and this reviewer could each pick a different home for the same rule. The plan's split for T2 (`plan.md:196`: CVgen-specific test rules stay in conventions, generic ones go to the skill) suggests the intended line: a choice this repository made goes to question 2, a practice that holds anywhere goes to question 4. Smallest fix, if the author agrees: one clause in the example paragraph at lines 71-74 saying that a naming choice this repository made stays in its owning document, and that the skill points to it. Changing "rule" in question 2's parenthetical to something narrower would also help, because every case being placed is a rule.

3. `archive/work-records/review-agents/plan.md:41-48`: the plan was synced with question 3 but not with question 1. Its question 1 still has no exclusion ("Is it this agent's own job (what it receives, its steps…)"), which is the reading round 1 finding 1 removed. Its question 2 also omits "or CVgen skill". The plan is revised in place and goes to the plan-reviewer in TASK-74, so a reader there will find two versions of D1. Fix: either add the exclusion, or replace the list with a pointer, since D1 already says the questions live in `context-maintainer.md`.

4. The task notes' disposition table does not mention the D6 edit at `plan.md:83-88`. The edit is correct: it matches the AC 3 row and the existing "One moved from the plan" note. Mentioning it in the "Found while fixing" line would complete the record.

No Blocking or Material findings. The pre-existing 83-character line at `context-maintainer.md:78` is outside the range and not raised.

Verdict: PASS

Context review, round 3: TASK-73, context placement (db7b106)

My reading of the feedback, written before I opened the diff. If the owner holds a convention for an activity in every project, it goes in that activity's skill (question 4). If only this repository chose it, it stays in the document that owns it (question 2). Question 3 is only about working with the owner, so it must not catch such a convention first. `*.spec.*` is not a rule anywhere.

**What holds**
- The principle is captured, not just the example. Each case reaches one stop in order:
  - A CVgen-only choice stops at question 2.
  - A preference about how to work with the owner stops at question 3.
  - The owner's cross-project activity convention passes question 3 because of the explicit exclusion at `context-maintainer.md:64`, and reaches question 4. That sends it to the skill, or to the agent file when only one agent does the activity.
- No gap or overlap between questions 2 and 4 now. "A choice only this repository made" (`:59`) draws the line round 2 Note 2 asked for.
- Narrowed question 3 matches the sections of `docs/preferences.md` ("How to talk to him", "What he decides and what agents decide", "Reports") and table row `:38`.
- The example paragraph (`:75-76`) is conditional ("would join them"). `docs/conventions.md:102` really does own test-file naming. `*.spec.*` appears nowhere in the diff.
- LF throughout (0 CRLF in both files). Lines run 41 to 76 characters, matching their neighbours. No client data. The task notes record the owner's words and the decision. No dated record was edited.

**Material**

1. `.claude/agents/context-reviewer.md:45-46`, plus `context-maintainer.md:39` (table row) and `:135-136` (hard rule). These still say, without qualification, that the owner's "personal preferences" or "personal detail" belong in `.local/preferences/` and never in the repository.
   - Question 4 now sends the owner's own cross-project conventions to a skill, which is tracked. The owner himself calls such a convention a preference ("I do not prefer it").
   - A reviewer applying `:45-46` literally would flag a correctly placed skill rule as a personal preference in the public repository. A maintainer reading the table before the questions could file it under `.local/`.
   - This is a pointer that should have changed with the narrowing and did not. It is also what `.local/preferences/` means in question 3 ("when personal"), and that is now unclear.
   - Smallest fix: narrow the three places to what is private. For example, table row: "The owner's private preferences and personal detail". Reviewer: "Personal detail about the owner belongs in `.local/preferences/`, never in the repository; his conventions for an activity are placed by question 4." Leave the hard rule at `:135-136` as it is if "personal detail" is read as private detail; the table row and the reviewer line are what need changing.

**Minor**

2. `archive/work-records/review-agents/plan.md:44`: D1's summary still reads "the owner as a person → preferences", which is the wording this commit narrowed. The plan is revised in place and goes to the plan-reviewer in TASK-74, so that reader meets two versions of question 3 (the same pattern as round 2 Note 3). Fix: "working with the owner → preferences; his conventions for an activity → question 4", or drop the clause and keep only the pointer.

**Note**

3. The task description at `backlog/tasks/task-73 - …md:26` also keeps "the owner as a person -> preferences". The owner-decision note records the change, so this is not a contradiction. Updating the description would stop a fresh reader of the task starting from the old split.
4. The redirect at `context-maintainer.md:64` ("His conventions for an activity are question 4") could make an agent hesitate over how the owner likes reports, since report-writing is also an activity. Question 3's "how he likes to be reported to" comes first in the order, so that case resolves correctly. No change needed unless it comes up in practice.

Round 2 Minor 1 (the line at `context-reviewer.md:43`) is fixed. Notes 3 and 4 are handled in the task notes.

Verdict: FINDINGS

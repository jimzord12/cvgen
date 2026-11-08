Context review, round 1: TASK-73, context placement (9b06670..e8a2558)

The principle I wrote down before reading the diff: every rule gets one home, picked by four questions asked in order, first yes wins. The question that matters most for the triggering case is this one: if any other agent writes or checks the work, the rule goes in the skill for that activity, not in the reviewer's file. Agent files and skills should be reusable in another repository.

The diff mostly captures this. Line endings are LF in all three files and no client data appears. Two Material findings remain.

**Material**

1. `.claude/agents/context-maintainer.md:54-55`: question 1 says yes to the very case the owner was talked out of.
   - It defines "own job" as "what it receives, its steps, what it returns, what it must not do". A reviewer's checks are its steps.
   - So an agent that follows "stop at the first yes" literally puts `*.spec.*` or the test principles into the tests-reviewer's file at question 1. Question 4 is never reached.
   - The fix currently sits after the list, in the "So a reviewer's file holds its own procedure…" paragraph (69-71), and in context-reviewer.md:39-41. In a stop-at-first-yes procedure, an exception that lives outside the question does not reliably fire.
   - Smallest fix: put the exclusion into question 1, e.g. "…what it must not do, and nothing another agent who does or checks the same work also needs?" Lines 69-71 can then shrink to the example.

2. `.claude/agents/context-maintainer.md:50-67`: the questions sit only in the maintainer's own file. Measured against question 4 itself, other agents need them too.
   - The context-reviewer points to them, which is fine.
   - But in TASK-74 to TASK-78 the lead writes the new agent files and skills (plan T1-T5), and nothing on the lead's reading path leads here. `AGENTS.md` "Skills and agents", `docs/development.md` and `docs/conventions.md` don't mention them; `docs/review.md:14` sends only owner feedback through the maintainer.
   - The lead will meet the questions first as a review finding. That is the wasted round the owner accepted the skill to avoid.
   - Smallest fix: one pointer where agent files and skills are written, e.g. after "each file says when to use it" in `AGENTS.md` "Skills and agents" add "where a rule goes: `.claude/agents/context-maintainer.md`, 'Where things live'". Check it against the word limit. `docs/conventions.md` is an alternative.

**Minor**

3. `context-maintainer.md:50`: "every other file points to it" is stricter than step 1 (88-91) and context-reviewer.md:43-45, which let a fresh-context profile restate the essentials. Fix: "…points to it, restating at most its essentials."

4. `context-maintainer.md:47`: the skills row now reads as generic method only. Six of the seven current skills are CVgen workflows (`backlog`, `new-client`, `new-cv`, `new-theme`, `verify-cv`, `idea-run`), and `CLAUDE.md:15` says "Repository-specific skills live in `.claude/skills/`". Read with question 2, a maintainer could start moving their content into `docs/`. Fix: keep CVgen workflows in the row, e.g. "A repeatable workflow, CVgen's or a generic activity's (planning, writing tests): its steps, conventions and checklist".

5. `context-maintainer.md:63`: "any agent other than this one" has no referent, since the reader is the maintainer. It should also say the lead counts. Fix: "any agent besides the one in question, the lead included".

6. `context-reviewer.md:42`: this line is 79 characters, longer than its neighbours (re-wrapped by hand). Re-wrap it.

**Note**

7. `context-maintainer.md:72-73`: question 1 content can name CVgen paths, so "hold only questions 1 and 4" does not by itself make an agent file reusable elsewhere. The claim is a little overstated; "the more of an agent file comes from question 4, the more it can be reused" would be accurate.

8. `archive/work-records/review-agents/plan.md:41-43`: question 3 there says "his user-level `CLAUDE.md` for every project". The change says `.local/preferences/`, which matches the standing table (line 39), so the change is right. The record now disagrees with what was built; say so in the task notes rather than editing the plan.

9. `plan.md:3-4`: "On approval it moves to `archive/work-records/review-agents/plan.md`", but it is already there. The status line is stale. If the plan is still being revised on this branch (D2), fix it there.

10. Task-73 notes: the "Opus at high" row (owner's standing choice) lands at question 1 only because model and effort have to be set in each agent file's header. That's fine, but the task notes could say so, since question 3 would otherwise apply.

Verdict: FINDINGS

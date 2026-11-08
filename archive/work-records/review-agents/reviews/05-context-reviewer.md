## Context review round 1: TASK-74 (plan-reviewer)

Snapshot: 8e3e65b, e321f3c and c7389f6 on `feat/review-agents`. 8e3e65b sits before d53f3b4, so the range `d53f3b4..c7389f6` leaves it out. I reviewed it with `git show 8e3e65b` and read the files whole at c7389f6. I read the calibration records (ee1ebe3) as evidence only.

What I expected before opening the diff: a reusable plan method that the planner and the reviewer share, with the blind map first. The gate should fire on complex or hard-to-undo work and when the owner asks, and not on small tasks. All CVgen-specific detail should live in `docs/review.md`.

Placement follows the four questions. The skill and the agent file hold no CVgen terms. Identifiers and glossary terms all check out: `examples/release.json`, `tests/baseline.json`, `tests/approved/`, CI on ubuntu and windows, and `Domain Contract`, `Template Variation`, `Release`, `Meta File`, `Envelope`, `Workflow Model`, `Atlas`. All four files use LF only. Nothing identifies a real client.

### Material

**M1. Severities are owned in two places, and they disagree.** `docs/review.md:87-88`
- The "Plan review" section says "the loop, severities, caps and storage are this file's".
- `docs/review.md:242-243` says the `plan-reviewer` follows the loop "with their own checks, severities and report shape", and `.claude/agents/plan-reviewer.md:62-77` defines its own Bar.
- The agent file also says "Where they differ from this file, the repository's rules win" (line 21). A reviewer that follows that would grade plans against the code table ("Data loss, unauthorized release…"), which barely fits a plan.
- **Fix:** drop "severities," from line 88.

**M2. The gate is timed to task creation, but tasks often exist already.** `docs/review.md:41`, `:86`; also `:17-18`
- Lines 41 and 86 say a plan is reviewed "before its tasks are created". Line 17 says "before any of it is built".
- Planned work often already has a Queued task: migrated tasks, a single task that turns out to change a contract, or TASK-74 itself. For such work the rule reads as already missed, or as not applying at all.
- The plan's own `docs/development.md` row uses a different timing: "before the first task of planned work goes Active".
- **Fix:** "before its tasks are created, or, for tasks that already exist, before the first goes Active", in both places, and line 17 to match.

**M3. "Plan" now has two meanings, and the planning paragraph has no pointer to the gate.** `docs/development.md:28-30`
- That paragraph still defines "a plan" as "a vision Direction item, an approved proposal or the owner's brief". The new gate uses "plan" for `archive/work-records/<slug>/plan.md` written in the skill's template.
- An agent planning from `development.md`, where the flow is owned, never learns the gate exists. It also cannot tell whether an approved proposal is the plan or needs a plan file.
- The plan defers this to T5 (development.md and a glossary `Plan` term). But the gate is live as soon as `review.md` changes.
- **Fix:** either now, one clause in `development.md:28` naming the plan file and pointing to `review.md`, "Plan review"; or a task note that TASK-74 does not reach `main` before T5.

**M4. Question 12 is fitted to the calibration answer key.** `.claude/skills/plan/SKILL.md:130-133`, `.claude/agents/plan-reviewer.md:52-54`
- The skill gives the situations as a closed list after a colon: "each situation it will meet: a fresh session, …".
- The agent then binds itself to "each situation the question names".
- The task notes admit the question was written knowing the key. Routines will not be walked through situations outside the list, such as a first run on empty state, a different OS or shell (CVgen's CI runs on two), a missing tool, or a run interrupted midway.
- **Fix:** "such as …, and any other it will meet" in the skill; "the situations the question names and any others the routine meets" in the agent.

### Minor

**m1. The two-reviewer rule has no owner and no link to the paragraph it overrides.** `docs/review.md:91-97`
- It names no one who adopted it. Elsewhere this file writes "adopted by the lead on …".
- `:262-265` still says "Prefer one reviewer". A reader of the loop never meets the mandatory pair.
- Its parenthetical counts "a contract other work depends on" as hard to undo. So every contract-change plan gets two reviewers, although the skill (`:21-23`) treats contract changes and hard-to-undo work separately. If that is intended, say so.
- **Fix:** add the attribution, and one clause at `:265` pointing to "Plan review".

**m2. Question 12 is out of shape with the rest of the checklist.** `.claude/skills/plan/SKILL.md:128-138`
- It runs 11 lines; the other questions run 2-3.
- Its last sentence is a rationale that the agent file already gives (line 56).
- **Fix:** trim the rationale.

### Notes

- **N1.** The brief is stated twice: in `review.md:99-101` and in `plan-reviewer.md:25-30`. The wording matches today. Acceptable as the agent's own "what it receives", but it will drift if one is edited.
- **N2.** Codex counterparts, the Atlas roster and glossary terms (`Plan`, `Impact Map`) are deferred to T5 by the plan. No suite check requires them; `check.ts` only validates agents named in the `Workflow Model`.

Checks: line endings counted with `python -c` (no CRLF). I ran no other checks.

Verdict: FINDINGS

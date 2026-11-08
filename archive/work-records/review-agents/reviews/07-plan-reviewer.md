# Plan review round 1: review-agents

Snapshot: `archive/work-records/review-agents/plan.md` at 1e00f50 (feat/review-agents). TASK-73 Ready and TASK-74 Active are treated as built.
Blind map: code/agent files 9 · data/contracts 6 · tests 5 · generated 6 · docs/context 14 · tooling/CI 5 · work in flight 6 · decisions 4 (full map below)

Checklist:
1. Impact: partly. The Workflow Model, the anchors, dependencies, other skills and the work in flight are missed (P2, P3, P5, P8).
2. Fit: OK against the vision and the constitution. Frozen-reference checks should be named as never removable through D6 (P8).
3. Facts: several false or incomplete (P2, P4, P5, P7).
4. Compatibility: queued and in-flight work under the new gates is not planned (P5). The task store does not fit plan_check (P2).
5. Reversibility: all docs and scripts, so revertible. Not irreversible.
6. Verification: the known-answer runs have no bar. The T5 checks miss moved anchors (P3, P6).
7. Failure: plan_check on Trello-era tasks, a fault run hit by an earlier assert, a copy that includes `private/` (P2, P4).
8. Sequencing: names only feat/template-contract (P5).
9. Unknowns: the reviewer's reliability (calibration 0/4, ~40%) is not used as a bar (P6).
10. Decisions: stated with reasons. Trigger cost is not listed for the owner (P11).
11. Proportion: the tests trigger is nearly universal (P11). D9 Codex counterparts are optional (P7).
12. Procedures: four of five routines fail or fork (below).
13. Model fit: fails for the task model (P2) and the Workflow step model (P3).

Procedures walked:
- **Plan → decompose → plan_check → decomposition-reviewer → create tasks:** fails at plan_check, because the tasks don't exist yet (P1). It forks on which milestone tasks are checked, and on other plans' or Done tasks in the same milestone (P2).
- **Deliberate fault:** fails. There is no way to run a single test, the copy's contents are not defined, Bun needs an install, and the review boundaries don't cover it (P4).
- **Doc edit → Atlas and Model:** fails silently on moved anchors (P3).
- **Codex counterpart use:** forks on copy vs pointer and on whether its verdict counts (P7).
- **tests-reviewer + code-reviewer on one snapshot (D10):** OK under the existing two-reviewer rule.

## Findings

### P1 Blocking: the decomposition loop cannot run in the order given
Anchor: D7, D8, the TASK-76 and TASK-77 outcomes; `docs/review.md:86-89`.
- The order given: D8 and TASK-77 run plan_check.py and then the decomposition-reviewer, and only after that create the tasks.
- The conflict: `scripts/plan_check.py <milestone>` checks "every task of a milestone" in the backlog. Before tasks are created there is nothing for it to read.
- review.md (built in T1) says a plan is reviewed "before its tasks are created", but it never says where the decomposition lives before tasks exist.
- Consequence: T3 builds a script whose input does not exist at the step where it runs, and T4 writes a loop nobody can follow.
- Smallest fix, pick one:
  - Tasks are created as Queued (or `--draft`) on `main`, and none goes Active until plan_check and the decomposition-reviewer pass. The plan skill, the backlog skill and review.md all say so.
  - Or plan_check parses the plan's task table instead of the backlog.

### P2 Material: plan_check's task model doesn't fit the real store
Anchor: D7, TASK-76 AC 2; `docs/development.md:223-226`; `backlog/tasks/*`.
- **m-8 can never pass.** m-8 holds 14 Done tasks with no header and no "Outcome and boundaries" section. They are Trello-migrated, and that text is "not reshaped" by rule. So `plan_check.py m-8` refuses forever, and this plan's own milestone fails. "The current milestones run" (TASK-76 AC 2) is undefined.
- **Dependencies have two sources.** The frontmatter `dependencies:` is `[]` on almost every task. The header's "Depends on:" is free text with decisions and prose. Example from main: TASK-81's header says "TASK-79, TASK-80, TASK-68" while its frontmatter says `[]`. Some dependencies cross milestones (TASK-81 in m-3 depends on TASK-79 in m-2).
- **Pre-rule tasks still in flight have no milestone** (TASK-65 on main).
- **Parsing:** titles use the folded `>-` form, and there is no YAML parser among the pinned dependencies (`packages/cv-workflow/pyproject.toml:11-14`). Adding one changes `pyproject.toml` and `requirements.lock`, and neither file is named in the plan.
- **CI:** if the suite checks the live backlog, CI fails on any later badly formed Queued task.
- Fix:
  - Scope the check to the plan's task IDs, not the milestone.
  - Name the dependency source (frontmatter, and the header must agree with it).
  - Exempt Done and migrated tasks.
  - Decide on the parser.
  - The suite tests only fixtures; the live check is a separate command.

### P3 Material: the Workflow Model change is bigger than planned, and anchors are already broken
Anchor: "Changed" rows for `05-design/stage.yaml` and the Atlas; T5 evidence.
- **The model can't hold a second reviewer on one step.** A step is "one actor doing one action" (`tools/workflow/src/model.ts:156-162`). Adding a tests-reviewer needs:
  - an actor in `catalog.yaml`
  - a step and an agent action
  - a report artifact, a gate and a revise loop
  - edits to `new-cv/SKILL.md:45-46`
  - render and atlas runs
- **The trigger doesn't match the plan's own table.** "When the engine change touches tests" leaves out "behaviour changed without a test".
- **TASK-74 already moved lines that anchors cite.** `docs/review.md:205-209` is cited 9 times in `stage.yaml`/`catalog.yaml` for the 5/10 round caps. Those lines now hold the effort paragraph; the caps sit at about 256-260.
  - 197-204, 229-232 and 192-209 drifted the same way.
  - `roster.json` (review.md:138-153), `change-review.json` and `site.json` cite review.md and development.md lines.
- **T5's checks can't see this.** `bun run check` "proves only that a cited line exists" (`tools/workflow/README.md:203`).
- Fix: add `bun run anchors 9b06670 --fix`, then `render`, `atlas` and a manual stamp to T5. Name every `stage.yaml` and `catalog.yaml` it touches, and the model's new entities.

### P4 Material: the deliberate-fault procedure (D5) can't run as written
Anchor: D5; `tests/run.py:163-166`; `docs/review.md:188-219`.
- **No single test can run.** `tests/run.py` takes only `--typst` and `--output`, and it is linear with bare asserts. "Runs that one test" means the whole suite, and an earlier assert can fail first. That also hits the memory pitfall in the handoff.
- **"Copies the repository" is undefined.** A copy of the main checkout includes `private/` (real clients; reviewers never read it), `builds/` (recursive) and `.worktrees/`.
- **Bun tests need `node_modules`.** Getting them means an install, which a reviewer may not do.
- **The review boundaries don't cover it.** They allow "vetted checks", not editing source in a copy.
- Fix:
  - Make the copy `git worktree add --detach` or `git archive` of the snapshot into `builds/`.
  - Give the runner a way to select one case, or use a scratch test.
  - Say what happens to Bun tests (INCOMPLETE, or reuse dependencies by path).
  - Amend the review boundaries, and say who cleans up.

### P5 Material: work in flight and the rollout
Anchor: "Sequencing", "Not in scope".
- **Other branches touch the same files.** feat/contract-stage-2 (Active, stacked on template-contract) also edits `verification.md`, the glossary, `tests/run.py`, every `stage.yaml`, `catalog.yaml` and the generated Atlas.
- **main has moved since the base 9b06670.** It changed `preferences.md`, `catalog.yaml`, `05-design/stage.yaml` and the Atlas, and queued TASK-79 to 81.
- **The gates will land on queued and in-review work:**
  - Once on main, the gates require a plan and plan review before TASK-79, 80 and 81 go Active (multi-task, none Active).
  - contract-stage-2 adds tests (`coverage.py`, `compatibility.py`). Does it need a tests-reviewer?
  - "Work already done" covers neither case.
- **"Rebases" is the wrong move for generated files.** `atlas.data.js`, `atlas.lock.json` and `client-journey.json` must be regenerated after merging, not textually merged.
- Fix:
  - Write a transition rule, for example: gates apply to tasks that go Active after the merge; name TASK-79 to 81.
  - List every branch.
  - Say "merge main, then regenerate".

### P6 Material: the known-answer runs have no bar and no held-out key
Anchor: T2 and T4 evidence, TASK-77 AC 3; calibration notes in TASK-74.
- **Scores so far are low.** Calibration 01 found 0 of 4 gaps; 03 found about 40%.
- **T4's acceptance can't fail.** TASK-77 AC 3 says "recorded", so any score passes.
- **The P-0019 split can't go through the loop.** TASK-63 to 68 would be refused by plan_check, which runs first.
- Fix:
  - Commit an answer key before each run, as ddebe24 did.
  - State a bar, or "record, and the lead decides with the reason".
  - Say whether the run skips plan_check.

### P7 Minor: Codex counterparts contradict `.codex/README.md`
Anchor: D1, D9; `.codex/README.md:3-5,42-50`.
- D1 says counterparts "copy nothing". The README says the TOML prompts "preserve each source agent's substantive brief, rubrics". It also says "every agent" (already false) and "All seven repo skills" (nine after this work).
- Whether a Codex verdict counts for these gates is unstated.
- Fix: update the README to the new pattern and say what a Codex verdict counts for, or drop D9.

### P8 Minor: the welcome misses some skills and files
- `new-theme/SKILL.md:42` (`baseline.json`) and `new-cv/SKILL.md:95-103` (`release.json`, `run.py` assertions) name their gates. They need the tests-reviewer.
- `.codex/agents/code-reviewer.toml` copies lens 5 (D10).
- `verification.md` should state that frozen-reference checks are never removed through D6.

### P9 Minor: two reviewers per round?
`docs/review.md:93-101` counts "a contract other work depends on" as hard to undo. This plan sets the task format plan_check enforces and the gates all later work goes through. The lead should state whether this round is one of two.

### P10 Minor: stale plan text and glossary timing
- The plan-reviewer rubric section lists 10 items; the built skill has 13. Point the section to the skill.
- Glossary Rule 4 adds a term in the same change, but "impact map" is already used repeatedly in T1 text while the plan defers terms to T5.

### P11 Note
- The trigger "behaviour change without a test" covers nearly every code change, so every code task gets a second reviewer. List this for the owner as a Major decision, since it adds friction.
- `.claude/repo-maintenance.md:150` is stale.
- There is no ADR or history entry for three new gates; ADR 0017 is the milestone precedent.

## Impact map
(C = covered, M = missed, X = excluded)
- **Code / agent files:** C: plan-reviewer.md, decomposition-reviewer.md, tests-reviewer.md, the plan skill, the test-principles skill, context-maintainer/context-reviewer, the backlog skill. M: new-theme and new-cv skills, code-reviewer.toml.
- **Data and contracts:** C: task template, report paths. M: frontmatter vs header dependencies, Trello-era tasks, milestone-less tasks, a YAML parser and `requirements.lock`.
- **Tests:** C: `tests/plan_check.py` wired into `run.py`. M: no case selection in `run.py`; Bun dependencies; live backlog vs fixtures.
- **Generated outputs:** C: `site.json`, `change-review.json`. M: anchors in every `stage.yaml` and `catalog.yaml`; `roster.json`; `client-journey.json` regeneration; the new Model entities.
- **Docs and agent context:** C: review.md, development.md, conventions.md, verification.md, glossary, `.codex/README.md`, AGENTS.md, the handoff. M: review.md boundaries, the README copy convention.
- **Tooling and CI:** C: ruff. M: the `bun run anchors` step.
- **Work in flight:** C: template-contract. M: contract-stage-2, travel-domain, main's drift, TASK-79 to 81, TASK-65/66.
- **People and decisions:** C: Opus/high, read-only, the skill instead of a decomposer, the four questions. M: transition rule, trigger cost.

## Facts checked
- TASK-69 merge 0562605 is in HEAD: true.
- template-contract changes `verification.md`, the glossary and `site.json`: true, but incomplete (contract-stage-2 and main also touch them).
- m-8 exists with "Agent-ready repository": true.
- `design.engine-review` exists: true. It can add a second actor: false.
- The task template header is in development.md: true (lines 204-221).
- tests-reviewer "runs that one test": false for `tests/run.py`.
- context-reviewer uses "before opening the diff": true (line 30).
- Codex counterparts copy nothing: contradicts the README.
- ruff is absent: true.
- The handoff's three-agents pitfall exists: true (line 41).

## Limitations
- The calibration reports were not read in full.
- `private/` was not read.
- Anchors were checked by `git show` line comparison, not by `bun run anchors`, because `node_modules` is absent.
- I ran as a general-purpose agent following the definition.

## Verdict: FINDINGS

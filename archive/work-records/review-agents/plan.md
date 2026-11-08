# Plan: review-agents — a plan-reviewer, a decomposition-reviewer and a tests-reviewer

Status: agreed with the owner 2026-11-08 in direction; revised in place on
`feat/review-agents` until its plan review passes (D2), then kept unchanged.

## Outcome

Three fresh-context review gates join the four everyday ones:

| Agent | Reviews | Runs when |
|---|---|---|
| `plan-reviewer` | A plan, before any task exists: gaps, blast radius, future problems | Work of more than one task, a contract or migration, anything irreversible, or the owner asks for a plan |
| `decomposition-reviewer` | The plan's split into `Milestone`s and tasks | Every reviewed plan that becomes tasks (after the plan's PASS) |
| `tests-reviewer` | Whether tests test real behaviour, and which are missing or should go | A change that adds, edits or deletes a test, fixture or baseline, **or** changes behaviour without touching a test |

All three: Opus at high (the owner's standing choice for reviewers, 2026-09-26),
read-only, fresh every round, never a fork, verdict PASS / FINDINGS / INCOMPLETE,
severities Blocking / Material / Minor / Note, round caps 5 attended / 10
unattended, reports stored verbatim as
`archive/work-records/<slug>/reviews/NN-<reviewer>.md`, exactly as `docs/review.md`
already runs the loop.

**Not in scope:** the work-board mod; the owner decision queue (P-0020); a
separate decomposer agent (a skill instead, see D8); running the new gates on
work already done.

## Sequencing

- **TASK-69 merged** (`0562605`, 2026-11-08): this work builds on its planning
  paragraph in `docs/development.md` and the milestone-aware backlog skill.
- **Mind `feat/template-contract`** (in flight): it changes
  `docs/engine/verification.md`, `docs/glossary.md` and `.atlas/src/site.json`.
  Whichever merges second rebases; T2 waits for it if it is close to merging.
- Branch `feat/review-agents` in `.worktrees/review-agents`, one milestone
  ("Review gates for plans and tests"), five tasks below.

## Decisions (Major; decided, listed for the owner)

- **D1. Placement by four questions (owner, 2026-11-08).** Every rule has one
  home; everything else points to it. The questions, in their reviewed
  wording, live in `.claude/agents/context-maintainer.md`, "Where things live"
  (TASK-73), and the `context-reviewer` checks placement against them; in
  short: an agent's own job → its file; repository-specific → the owning
  document or CVgen skill; the owner as a person → preferences; a generic
  method or one activity's convention → that activity's skill when more than
  one agent does or checks it, else the agent file. For this work:
  - **`plan` skill** (new, generic): the plan template, the plan checklist and
    the decomposition checklist; the planner and both plan reviewers load it.
  - **`test-principles` skill** (new, generic): what makes a test worth
    keeping; whoever writes a test and the tests-reviewer load it.
  - **CVgen-specific:** the gates, triggers, briefs, round caps and report
    storage in `docs/review.md`; the impact items peculiar to this repository
    (frozen references, `baseline.json`, `Release` PDFs, real records) in
    `docs/review.md`; the task template in `docs/development.md` (exists); what
    this suite's checks must do in `docs/engine/verification.md`.
  - **Agent files:** each reviewer's own procedure only (the blind pass, the
    deliberate fault, the report shape, its limits). Generic and self-contained,
    so an agent file and its skill can be copied to another repository.
  - **Codex counterparts** point to the Claude agent file and the skills; they
    copy nothing.
- **D2. A plan is a file with an identity.** `archive/work-records/<slug>/plan.md`,
  committed on the work's branch before each round, so the reviewer gets an exact
  snapshot (commit), like code. Revised in place until PASS; Git keeps the rounds.
- **D3. Tools:** Read, Grep, Glob, Bash, PowerShell for all three. The shell is
  for reading (`git log/diff/grep`, `git worktree list`, `backlog ... --plain`)
  and for checks that write only under `builds/`. Nothing else.
- **D4. Blind first pass (plan-reviewer).** Before reading the plan, it reads
  only the goal and builds its own **impact map** from the code. Then it reads
  the plan and diffs the two; every gap is a finding. The same discipline
  `context-reviewer` already uses ("before opening the diff, write down...").
- **D5. Deliberate faults (tests-reviewer).** For a test whose value is in
  doubt, it copies the repository into `builds/tests-review-<ts>/`, breaks the
  behaviour the test claims to guard, runs that one test, and records whether it
  failed. A test that survives the fault it exists to catch is a finding. No
  mutation tool is installed; this is targeted, by hand.
- **D6. Removal needs a reason.** A test is removed only by naming what it
  fails to catch (with a deliberate fault as evidence) or the test that
  already catches the same faults. "Useless" alone is not a finding. Guards
  against over-correcting to "fewer tests". Whoever removes a test follows
  it, the lead included, so it lives in the `test-principles` skill, not in
  the tests-reviewer's file (D1, question 4; moved during TASK-73).
- **D7. A script checks what has an exact answer.** `scripts/plan_check.py
  <milestone>` checks, before the decomposition-reviewer runs: the milestone
  exists (Backlog.md #919 makes virtual ones silently); every task has the
  `<slug>: <outcome>` title, the description header (Owner, Branch/worktree,
  Integration target, Depends on), an Outcome and boundaries section and at
  least one acceptance criterion; every dependency exists; the dependency graph
  has no cycle. The reviewer spends its judgement on what a script cannot judge.
- **D8. A `plan` skill, not a decomposer agent** (owner agreed, 2026-11-08).
  The planner holds the context; a fresh agent would get a summary, and the
  detail lost there is what the reviewer would then catch. The skill gives the
  plan template, the decomposition steps and the loop: plan → plan-reviewer →
  decompose → `plan_check.py` → decomposition-reviewer → create the tasks
  (backlog skill). A decomposer agent can be added later if planners run out of
  context.
- **D11. Milestone m-8, "Agent-ready repository".** Its done-condition is that
  any agent can orient, plan, work, review and integrate from the repository
  alone; review gates for plans and tests are part of that outcome, so no new
  milestone.
- **D9. Codex counterparts for all three** (`.codex/agents/*.toml`): Codex's
  role here includes reviewing designs, and a plan is one.
- **D10. `code-reviewer` keeps lens 5** ("Tests and visible evidence"). When a
  tests-reviewer ran on the same snapshot, the code-reviewer may rely on its
  report for test quality and says so in its coverage line.

## The three rubrics (generic parts in the skills, CVgen parts in the docs, D1)

### plan-reviewer
1. **Impact map, blind first** (D4): code and callers; the Framework vs a
   `Domain`; templates and `Template Variation`s; fixtures, `tests/baseline.json`,
   frozen references; examples, `Release` PDFs and `Meta File`s; real client
   records (named as affected or not; no client data copied into a report);
   docs, glossary, skills, agents, `.codex/`, the Atlas and the `Workflow
   Model`; CI.
2. **Fit:** outcome and non-goals against `docs/vision.md`; the constitution's
   rules (frozen references, a new folder per output, no font shrinking, public
   content fictional, the totals rule).
3. **Compatibility and migration:** existing examples and records keep working,
   or the plan says how they move.
4. **Reversibility:** what cannot be undone, and the rollback.
5. **Verification:** how we will know it works; the evidence each step leaves.
6. **Failure modes** the plan did not consider.
7. **Sequencing:** collisions with branches and worktrees in flight; order of
   steps; what must land first.
8. **Unknowns:** what should be a small experiment before committing.
9. **Owner decisions:** Critical choices raised, not assumed.
10. **Proportion:** a simpler alternative; what the plan makes harder later;
    any bypass that belongs in `docs/framework-gaps.md`.

### decomposition-reviewer (after `plan_check.py` passes)
1. **Traceability both ways:** every part of the plan has a task; every task
   traces to the plan.
2. **One outcome per task,** with its boundaries (what it excludes).
3. **Acceptance criteria** are observable and name their evidence.
4. **Size:** each task fits one branch and one review loop.
5. **Dependencies make sense:** every real ordering is a dependency (for example
   a glossary term before the docs that use it); no dependency is invented.
6. **Parallel safety:** tasks meant to run together touch no shared file.
7. **Milestone:** its done-condition is reached by its tasks.
8. **Gates and tests named:** each task names its review gate(s) and the tests
   it needs.
9. **Owner-blocked tasks** carry the `blocked` label and the unblock condition.
10. **Project rules:** task template, where task changes go (main vs branch),
    integration targets.

### tests-reviewer
Sources: Kent Beck's Test Desiderata; Software Engineering at Google, ch. 12
(test via public APIs, test state not interactions); Google's
"Change-Detector Tests Considered Harmful"; agent-specific failure reports
(assertions weakened, fixtures edited to pass, coverage gamed).
1. **Behavioural:** it checks behaviour through a real entry point (a render, a
   CLI, a public function), not internal calls or structure.
2. **Can fail:** it fails when the behaviour breaks (deliberate fault, D5); no
   tautology, no comparison against output the test itself regenerates.
3. **Structure-insensitive:** it survives a refactor that keeps the behaviour.
4. **Specific:** its failure message points at the cause.
5. **Deterministic and isolated:** same result every run and in any order.
6. **Honest changes:** no deleted or weakened assertion, no skip, no fixture or
   `baseline.json` hash changed without a reason the change itself requires.
7. **Not duplicated:** no second test catching the same faults as another.
8. **Missing tests:** every changed behaviour has a test for its likely faults;
   the report lists each missing one with the fault it should catch.
9. **Removal with a reason** (D6).
10. **Cost:** a slow test earns its time.
Applies to the Python suite (`tests/`) and the Bun tests in `tools/workflow/`.

## Files

### New
| File | What |
|---|---|
| `.claude/agents/plan-reviewer.md` | Procedure, brief, report shape, limits |
| `.claude/agents/decomposition-reviewer.md` | Same |
| `.claude/agents/tests-reviewer.md` | Same, with the deliberate-fault procedure |
| `.codex/agents/{plan,decomposition,tests}-reviewer.toml` | Codex counterparts |
| `.claude/skills/plan/SKILL.md` | Plan template, plan and decomposition checklists, the loop (D1, D8) |
| `.claude/skills/test-principles/SKILL.md` | What makes a test worth keeping (D1) |
| `scripts/plan_check.py` | The exact checks (D7) |
| `tests/plan_check.py` | Its tests, wired into `tests/run.py` like `proposals` |

### Changed
| File | Change |
|---|---|
| `docs/review.md` | Plans are reviewed before implementation; a "Plan, decomposition and tests gates" section with the trigger table, each gate's brief and rubric; the loop and report persistence name the new reviewers; D10 under lens 5 |
| `docs/development.md` | Roles list; the planning paragraph (after TASK-69's) points to the `plan` skill; a plan's PASS and its decomposition's PASS before the first task of planned work goes Active; the file map |
| `.claude/agents/context-maintainer.md` | "Where things live" gains the four placement questions (D1) |
| `.claude/agents/context-reviewer.md` | Its placement check names the four questions |
| `docs/engine/verification.md` | New section: what this suite's tests must do, beyond the `test-principles` skill it points to |
| `docs/conventions.md` | Its "Tests" section already holds test rules (real compiler, no mocks, "a test that would pass with the feature deleted is not written"): T2 keeps the CVgen-specific ones there, moves the generic ones to the skill, and points to it (found during TASK-73). "Documents" gains the pointer to the four placement questions (TASK-73) |
| `docs/glossary.md` | Candidate terms: `Plan`, `Impact Map`, `Deliberate Fault` (only those the text keeps using) |
| `.claude/skills/backlog/SKILL.md` | Tasks from a reviewed decomposition: pointer to the `plan` skill |
| `.codex/README.md` | Roles table and agent count |
| `.atlas/src/site.json` | Roster entries for the three agents and the skill |
| `.atlas/src/pages/change-review.json` | The flow gains the plan and decomposition steps and the tests gate; rebuild and stamp |
| `docs/workflow/05-design/stage.yaml` (+ generated README/Atlas) | `design.engine-review` adds a tests-reviewer when the engine change touches tests; `bun run render` and `bun run atlas` |
| `AGENTS.md` | Probably nothing ("Which reviewer gates which change: docs/review.md" already points there); checked against its word limit |
| `backlog/docs/doc-1 - session-handoff.md` | New gates in force; drop the "more than three agents" pitfall (owner, 2026-11-08) |

## Tasks (milestone m-8, Agent-ready repository)

```
T0 TASK-73 placement ─► T1 TASK-74 plan-reviewer ─► T2 TASK-75 tests-reviewer ─► T3 TASK-76 plan_check.py
                                                                                       │
                              T5 TASK-78 the welcome ◄─ T4 TASK-77 decomposition-reviewer ◄┘
```

T3's script can be written beside T2, but its gate is the tests-reviewer, so
it closes after T2 (found while creating the tasks: the kind of ordering the
decomposition-reviewer exists to catch).

| Task | Delivers | Gate | Evidence |
|---|---|---|---|
| **T0** context-placement | The four questions in `context-maintainer.md`; `context-reviewer` checks them | context-reviewer | The three agents' content sorted by the questions with no case left undecided |
| **T1** plan-reviewer | `plan` skill (template + plan checklist), the agent, its `docs/review.md` gate with the CVgen impact items | context-reviewer | Known-answer run: on `archive/work-records/backlog-migration/plan.md`, does it find what that work later found the hard way? Then **run it on this plan** before T2-T5 start |
| **T2** tests-reviewer | `test-principles` skill, the agent, verification.md's suite specifics, review.md trigger | context-reviewer | Known-answer runs: a seeded tautological test and a seeded change-detector test in a `builds/` copy must be flagged; `tests/proposals.py` reviewed for real |
| **T3** plan_check.py | Script and its tests | code-reviewer + **tests-reviewer** (its first real use) | Suite PASS; the script on the current milestones; a fixture with a cycle, a missing dep and a virtual milestone each refused |
| **T4** decomposition-reviewer | The agent, the `plan` skill's decomposition checklist and loop, review.md | context-reviewer | Known-answer run on the P-0019 split (TASK-63 to 68) |
| **T5** the welcome | development.md, glossary, backlog skill, `.codex/` ×3 + README, Atlas, Workflow Model, handoff | context-reviewer; code-reviewer for the model change | `atlas.py check`, `bun run check`, `bun test`, suite, ruff |

**Bootstrap, honestly:** this plan is reviewed by the plan-reviewer only after
T1 exists, and its split by the decomposition-reviewer only after T4. T1 is
small enough that its own context review is enough.

## Risks

- **Review churn:** three more gates can mean more rounds. Mitigation: exact
  triggers; the script takes the mechanical checks; the round caps hold.
- **Rubric drift:** rules restated in agent files go stale. Mitigation: D1;
  the context-reviewer checks that agents restate only essentials.
- **The deliberate-fault copy** must never touch the source tree: copy to
  `builds/`, run there, and the report names the copy.
- **`ruff` is not installed on this machine** (found 2026-11-08): install it
  before T3, or the author checks are incomplete.

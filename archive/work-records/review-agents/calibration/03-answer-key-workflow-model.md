# Calibration 03, answer key: the Workflow Model plan at f4af2c1

Built 2026-11-08 by a separate read-only agent from the later review reports,
task notes and commits, while the held-out plan-reviewer run was already in
progress and unable to see it. Stored before that run's report arrived, so the
key was not fitted to the result. The lead had not read the workflow reviews.

Scoring rule: an item counts as found when the reviewer names the same gap,
even with different wording or fix; "partly" when it names a narrower or
adjacent form of it.

1. **"external" means two things.** Handoff §3, level 2 uses "marked external" for an input no step produces; the inventory uses `external` for anything outside the repository, such as the Google Form a step creates (inventory README:107-109). Evidence: workflow-schema/reviews/03-context-reviewer.md M1; 74edd01 (`external` renamed `given`). Found TASK-36. Visible at f4af2c1: yes.
2. **Gates are pass/fail only.** The Gate entity cannot hold decisions with more than two outcomes (three build paths; "client answered" by chat and/or form). Evidence: workflow-schema/reviews/01-code-reviewer.md F7; TASK-37 notes. Found TASK-36. Visible: yes.
3. **"Edges are derived, never written" breaks.** Files edited in place create a 16-step cycle; order that carries no data goes unchecked (export without approval passes levels 1-2; render does not wait for the design review); steps with no inputs or outputs are unreachable. Evidence: task-38 notes :46-58; workflow-check/reviews/01-code-reviewer.md R1-5; TASK-42; f5ff0ad. Found TASK-37/38, confirmed TASK-42. Visible: partly.
4. **No place for refusals or preconditions, so the model cannot replace the guides.** Decision #8 is about refusals, yet an Action holds only its invocation; TASK-41 dropped facts; TASK-43 kept client-workflow.md and build-a-cv.md as reference. Evidence: atlas-from-model/reviews/01-context-reviewer.md M2; task-38 note (10); task-43 notes :43. Visible: yes.
5. **Line anchors with no drift policy, and no sequencing against the restructure tasks.** TASK-31, 47, 51, 52, 55 in the same batch moved cited files with no dependency on TASK-37 to 43; TASK-43 and TASK-51 both rewrite AGENTS.md; `bun run anchors` invented on the way. Evidence: 0654a73, 6f00e54, 2362f70, 775cbc6, 3eafcb7, 3e2c3b6; workflow-check/reviews/03-context-reviewer.md M1; task-38 :62. Visible: yes.
6. **The nine owner decisions did not cover running unattended.** Loops with no sourced cap, branches with no source; placeholder caps shipped; P-0018 carried nine more owner questions, answered 2026-10-22. Evidence: workflow-facts/reviews/01-context-reviewer.md M1, M4; docs/proposals/workflow-gaps.md:30-40; fb9bf73. Visible: partly.
7. **Level 3 assumed the real scripts work in a temporary Envelope.** `outputs.py stamp` refuses a PDF outside a home (scripts/outputs.py:9), so `--root` was added; concept stamps write into studio/, three cmd steps skipped; only the happy path walked. Evidence: task-42 decisions (3)-(4) :33; workflow-reality-check/reviews/01-context-reviewer.md M1. Visible: yes.
8. **TASK-41 did not name the consumers of the hand-written Atlas page:** its status panel, the Session Sweep "refresh the status of any flow" (development.md:95), the owner's `/atlas refresh`. Evidence: atlas-from-model/reviews/01-context-reviewer.md M1; db23bb9. Visible: yes.
9. **The new guards say nothing about records that already exist.** 8 delivered revisions without receipt or Export, one signed-off draft without its screenshot, can no longer be re-stamped. Evidence: task-44 :37; workflow-guards/reviews/01-code-reviewer.md R1-04. Visible: partly.
10. **Checks an unattended agent cannot run.** TASK-36 AC 3 ("validates in VS Code") and TASK-39 AC 2 ("diagrams render on GitHub") ticked without evidence. Evidence: workflow-schema/reviews/01-code-reviewer.md F1; workflow-render/reviews/02-code-reviewer.md F1; 0125212. Visible: yes.
11. *(weaker)* **Inventory deleted without a check** that each item landed somewhere; "client page renders left in builds/" (inventory README:98) was lost. Evidence: workflow-consolidate/reviews/01-context-reviewer-content.md M1, 03-context-reviewer.md M1. Visible: yes.

Excluded as implementation bugs (listed by the key's author): reserved-prefix message, temp folders, anchor parsing, `--frozen-lockfile`, a facts reachability slip, a wrong cap citation, code-fence markers, an `rmSync("")` risk, a no-op re-stamp, dated-record edits, receipt binding untested, name-only exemption, citation and wrapping slips. TASK-60, 61, 62 judged not caused by this plan.

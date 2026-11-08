**context-reviewer, round 1. TASK-69, branch docs/backlog-milestones, snapshot main..d9d99bb**

The milestone principle sits in the right file, `docs/development.md`, "The flow", and the orientation step was amended in place rather than added to. The pin is 1.55.3 everywhere live. ADR 0014 changed only on its Status line. I checked every CLI command shown against 1.55.3's `--help` and all exist. `milestone add`, `rename` and `archive` have no `--plain` option, and the text correctly leaves it off. All files are LF. No real client is named anywhere. I found four Material problems, listed first.

### Material

1. **The CLI's "completed" is not the done-condition** (`docs/development.md:34-36`). The text says a `Milestone` closes when its tasks are Done and the done-condition is met, and that "`backlog milestone list` then shows it as completed". But the CLI only counts tasks: m-0 (11/11) shows as completed whatever its done-condition says. An agent will treat "completed" as proof, and nothing tells it what to do when the last task is Done but the condition is not met.
   Fix: say the CLI counts tasks only, and that when a task's move to Done leaves its milestone at n/n, the agent records the done-condition evidence or queues the task that will meet it.

2. **New rules live only in the skill.** `.claude/skills/backlog/SKILL.md:86-87,105` says milestone files are record-keeping and are created on `main`. The files that own those rules were not changed:
   - `docs/development.md:176-185` still says "Two kinds of record commit" and "Create a task on `main` first".
   - The record-keeping list in `docs/review.md:54-61` does not include milestone files.
   - The skill's own "Two kinds… Both" at lines 101-104 is now wrong.

   Fix: add milestone files to the record-keeping list in `review.md` and to `development.md:177-183`, and leave the skill pointing at them. If the excluded plan-reviewer change is meant to gate creating milestones, check with that change rather than letting the skill grant the exemption.

3. **The roster page is STALE at HEAD.** `python .atlas/_kit/atlas.py check` reports `STALE roster docs/tech-stack.md`. Roster was stamped at ac27171, and 596701a changed `docs/tech-stack.md:19` again afterwards. Fix: re-stamp roster.

4. **The ceo's new instruction is in its reading list** (`.claude/agents/ceo.md:48`, `.codex/agents/ceo.toml:74`). "Name the milestone an idea would serve…" is something the ceo must produce, but it sits under "Read before thinking". The owner of that output is the bullet "A roadmap slot: before, after or replacing a Direction item" (`ceo.md:70`). Fix: merge it into that bullet in both files, writing `Milestone` in backticks as the rest of the file does with its terms.

### Minor

5. **Line wrap.** `SKILL.md:15` (~140 chars) and `:105` break the file's wrap.
6. **Rename paragraph contradicts itself** (`SKILL.md:83-86`). "Tasks store the id, so a rename leaves them pointing at the right milestone, but…" then warns about stale values, which by its own premise cannot be stale. Either drop the "but" clause or say which values do go stale.
7. **`-m` advice differs.** `docs/decisions/0017-backlog-md-1-55-3.md:30` says "pass its exact name or id"; `SKILL.md:53` and `development.md:196` say by id. Use "id" in the ADR; it is still unmerged, so it can be fixed now.
8. **No milestone check in orientation.** The brief asked for one in the skill. Only a progress command was added; nothing flags a task with no milestone, or a virtual milestone created by #919. TASK-63..66 have no `milestone:` field on main today; that is deliberate, since they change on feat/template-contract. One line in "Reading" would do it.
9. **Pointers not updated:**
   - The `backlog/` row in `AGENTS.md` ("Tasks and the `session-handoff` doc") does not mention milestones.
   - The tree at `development.md:151-152` has no `backlog/milestones/`.
   - `development.md:162` and the "Code name today" column of the glossary's `Task Store` row (`glossary.md:82`) name only ADR 0014.
10. **"Milestone" now means two things.** `docs/git-workflow.md:38,76` uses "milestones" in its generic sense, which now collides with the term `Milestone` (glossary rule 1). Use "checkpoints".
11. **Stray comma** at `.codex/README.md:39`: "`backlog/milestones/`, (or …".

### Notes

- "a plan" (`development.md:29`) is not defined, and the same file uses **Plan** to mean a task's Implementation Plan. Consider anchoring it (vision Direction, an approved proposal or the owner's brief), or leave it to the plan-reviewer change.
- `.atlas/src/pages/change-review.json:242` cites `development.md:122-136`, but the handoff paragraph is 126-138; `site.json` has it right. This drift was already on main, and the citation shift here carried it over.
- I could not check upstream issue numbers or their open/closed state offline.
- After my first read the branch gained d9d99bb, which changes only the TASK-69 file. That task file was the only record I reviewed.

Verdict: FINDINGS

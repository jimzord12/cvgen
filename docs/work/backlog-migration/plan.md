# Migration plan: Trello board "CVgen" -> Backlog.md

## Context

Every task record in CVgen is a card on the Trello board "CVgen", which was
adopted on 2026-09-16 after a trial (`docs/proposals/trello-free-trial.md`).
The owner now wants the task store to be **Backlog.md**: Markdown task files in
the repo (`backlog/`), with a CLI (command-line tool), a terminal board and a
local browser board. The earlier `docs/proposals/kanban-tooling-research.md`
already ranked Backlog.md first. The result: tasks travel with Git, agents
need no API keys or network, and review reports sit next to their tasks.

**The facts this plan rests on**
- The live board has 27 cards: Handoff 1 (`session-handoff`), Queued 4,
  Review 1 (`travel-recalibration`), Done 21. Only two cards have checklists
  (`monorepo-migration` 9/9, `pdf-workflow` 5/5). No card is labelled Blocked.
- Backlog.md **1.52.0** is installed. The latest is 1.53.0 (2026-09-24), with
  an open memory-leak issue #1038 in its web server. It supports custom
  statuses, labels, acceptance-criteria checkboxes, `--plain` output for
  agents, a terminal `board`, a `browser` (127.0.0.1:6420), docs, and has
  `autoCommit` off by default. There is no Trello import, so we write a
  one-off script.
- Trello is wired into:
  - the `trello` skill (`.claude/skills/trello/`) and its permission;
  - `AGENTS.md` and `docs/development.md` (the main protocol);
  - `review.md`, `git-workflow.md`, `preferences.md`, `glossary.md`,
    `framework-gaps.md` and `guides/client-workflow.md`, all under `docs/`;
  - `.claude/repo-maintenance.md` and `brand/README.md`;
  - the `idea-run` and `new-client` skills;
  - five Claude agents and their Codex mirrors;
  - five Atlas pages.
- `development.md:111-112` and `.claude/repo-maintenance.md:134` currently
  forbid "a second backlog". The migration rewrites them so that `backlog/`
  *is* the one store, not a second one.

## Pushback: you lose the phone board

Trello was chosen because you "want to check cards and progress from a
phone" (trial doc, line 60). Backlog.md's boards run on this PC only. On the
phone you would use GitHub's app or website. There, each task is a readable
page under `backlog/tasks/`, but there is no Kanban view, and a task's
status updates there only once its work is merged.

My recommendation is to accept this, because agents make every board change
and you mostly look at the desk. If the phone board matters, veto now. The
alternative is a hosted board, which is a different migration.

## Decisions taken on your behalf (veto any)

🧭 **Same columns.** Queued, Active, Review, Ready, Done. Blocked stays a
red-flag label, and Cancelled stays "Done, with a Cancelled note".

🧭 **Task names stay the same.** Each task keeps its Trello title
(`pdf-workflow: local revision…`) and gains a number (`task-7`), which
Backlog.md requires. Every old review report still links up.

🧭 **The session handoff note moves into the repo.** It becomes a document
under `backlog/docs/`, has the same content and format, and is visible in
the browser board's Docs tab. Agents always read and write the copy on
`main`.

🧭 **What you'll see as status.** On your PC's board, a task moves as soon as
an agent works on it. On GitHub, it moves when the work merges. Agents don't
need you for either.

🧭 **Backlog.md doesn't touch our agent instructions, and runs no
background server for agents.** Agents use its command-line tool through a
small new `backlog` skill, which replaces the `trello` skill.

🧭 **Version pinned to 1.52.0** (the one installed). Upgrade once the 1.53
memory bug is fixed.

🧭 **Trello is archived, not deleted.** It gets a full export into the repo,
then the board is closed. Closing can be undone; deleting can't. Deleting
it later is your call, any time.

🧭 **The `trello-cli` task gets cancelled.** It was a project CLI for
Trello and becomes pointless. Say so if you want it kept.

## Steps (agent detail)

Work in a worktree off `main` on branch `feature/backlog-migration`. The
current checkout, which holds someone else's uncommitted idea-run work, is
not touched. Everything up to the merge is committed on this branch.

1. **Init and config.**
   `backlog init "CVgen" --defaults --integration-mode none --agent-instructions none --check-branches true`.
   Then edit `backlog/config.yml`:
   - `statuses: [Queued, Active, Review, Ready, Done]`, `default_status: Queued`
   - `labels: [blocked]`
   - `auto_commit: false`, `bypass_git_hooks: false`
   - `remote_operations: false`. Confirm that this also stops the
     cross-branch check from fetching; if it doesn't, use `--include-remote
     false` at init.
   - Remove the default priorities and the definition of done.

   Read the generated files before committing, and check with `git status`
   that init did not commit anything by itself.

   **Plan-review record:** five rounds were run on this plan before
   execution: R1 5 Material, R2 3, R3 1, R4 1, R5 PASS. Copy the summary
   into `docs/work/backlog-migration/reviews/00-plan.md`.
2. **Migrate** with a one-off scratchpad script (`migrate-trello.ps1`). It
   reads the board through `trello.ps1` and creates one task per card, in
   Trello order: 26 tasks. The Handoff card becomes the doc instead.
   - Call `backlog task create "<card name>" -s <list> -d <description
     verbatim> --ref <card URL> --ac <item>… --no-dod-defaults --plain`.
     Add `-l blocked` where the card had the label (none today).
   - Then `backlog task edit <id> --check-ac N` for each checked item.
   - Card sections (Outcome / Acceptance / Plan / Result / Review / Handoff)
     stay inside the description as written. No `--plan` or `--notes`.
     Creation dates live only in the export (the CLI has no date flag).
   - Run `backlog doc create "session-handoff" --plain`, then write the
     card's description into the path the command returns.
   - The script refuses to run if `backlog/tasks/` already has files
     (constitution rule 2).
   - Confirm the slug survives Windows file-name cleaning of the `:`.
3. **Parity check, before anything else is added.**
   - `backlog task list --plain` shows exactly 26 tasks (Queued 4,
     Review 1, Done 21) with titles identical to Trello.
   - The acceptance states of `monorepo-migration` (9/9) and `pdf-workflow`
     (5/5) match, and each item's text matches its checklist item, since
     commas could split an `--ac` item.
   - A whitespace-trimmed diff of each task description against its card
     comes back clean. This also catches quotes and newlines mangled by
     PowerShell.
   - The handoff doc's `**Written:**` line matches the card.

   Then create task `backlog-migration` (Active, with this plan's
   acceptance list) and cancel `trello-cli`. The counts become Queued 3,
   Active 1, Review 1, Done 22.
4. **Rewrite rules and wiring.**
   - **`docs/development.md`:**
     - The fresh-session, ending-a-session, where-information-belongs and
       task-record sections now point to `backlog/` and the skill.
     - Template mapping: header fields + Outcome → Description; Acceptance
       → AC; Plan → Plan; Result / Review / Handoff → Notes; Final Summary
       at Done.
     - The "no second backlog" line names `backlog/` as the one store.
     - **Commit rule:** a task file a branch is working on changes only on
       that branch. Two kinds of record commit go straight to `main`: the
       handoff doc, and edits to idle tasks (new Queued, cancellations,
       the move to Done after a merge).
   - **New `.claude/skills/backlog/SKILL.md`:**
     - Commands: `task list --plain -s`, `task view --plain`,
       `task create --no-dod-defaults`.
     - `task edit` with `-s`, `--check-ac`, `--append-notes`, and
       `--add-label` / `--remove-label blocked`. Never `-l`, which replaces
       all labels.
     - `board`, and `browser --no-open`.
     - The handoff doc's real path:
       - read it with `git fetch` then `git show origin/main:<path>`;
       - write it in the main checkout only if that is on `main` and
         clean; otherwise in a short-lived worktree of `origin/main`
         (commit, push, remove).
       - Record commits on idle tasks take the same route.
     - Branches untouched for 30 or more days drop out of the cross-branch
       view.
     - Add `backlog *` read commands to the project's allowed commands.
     - Keep the `trello` skill until step 7.
   - **`docs/review.md:42-46`:** add the handoff doc and edits to idle tasks
     to the record-keeping exemptions.
   - **Swap Trello, card and board wording in:**
     - `AGENTS.md`, plus these under `docs/`: `git-workflow.md`,
       `preferences.md`, `glossary.md` (rename the terms and report them),
       `framework-gaps.md` and `guides/client-workflow.md`;
     - `.claude/repo-maintenance.md` and `brand/README.md:139`;
     - the skills: `idea-run` (`trello.ps1 -Cards` becomes
       `backlog task list --plain`) and `new-client`;
     - the agents `ceo`, `ceo-reviewer`, `code-reviewer`, `design-reviewer`
       and `magazine-editor`, plus their `.codex/agents/*.toml` mirrors and
       `.codex/README.md`.
   - **`docs/tech-stack.md`:** Backlog.md 1.52.0 and its install command.
   - **New ADR** `docs/decisions/0014-backlog-md-task-store.md` (context,
     decision, the phone tradeoff).
     - Mark `trello-free-trial.md` as superseded by 0014, and
       `kanban-tooling-research.md` as applied.
     - Add a dated entry to `docs/history.md`.
   - **Not rewritten (history):** `docs/work/**`, `docs/proposals/**`
     (apart from those two status lines), `.night-shift/**`, earlier ADRs
     and older `history.md` entries.
   - **Atlas:** update `site.json`, `system-map.json`, `change-review.json`,
     `client-journey.json` and `design-run.json` in `.atlas/src/`. Then run
     `atlas.py build`, then `stamp`, then `check`.
5. **Verify.**
   - The step 3 parity output.
   - `python tests/run.py` passes.
   - `atlas.py check` is clean.
   - `/repo-maintenance quick` is clean.
   - `scripts/outputs.py check` is unaffected.
   - A screenshot of `backlog browser` with the five columns, sent to you.
   - A Codex agent can run `backlog task list --plain` (`backlog` is on its
     PATH).
6. **Review loop, Trello still live.** Run the independent `code-reviewer`
   per `docs/review.md`, with these lenses: protocol consistency and agent
   wiring. Fix Blocking and Material findings, for up to **four** rounds;
   the step 7 round is the fifth, and `docs/review.md:184-188` caps the
   loop at five unless the owner says otherwise. If round 4 still isn't
   PASS, stop and bring it to the owner before freezing anything.
   Reports go to `docs/work/backlog-migration/reviews/`.
7. **Freeze and merge, back to back.**
   - Tell the owner to stop writing to Trello from this point on.
   - **Late-change check:** list the cards whose `dateLastActivity` is
     later than the step 2 run (the idea-run session may have written since).
     Port them by hand and re-run their parity lines. The counts adjust
     accordingly.
   - Export the board JSON to
     `docs/work/backlog-migration/trello-export-2026-10-06.json`, after a
     scan for real client data (anything real goes to `private/`).
   - Close the board through the API and verify `closed: true`.
   - Delete `.claude/skills/trello/`. Its permission entry is in the
     git-ignored `settings.local.json`; remove it there, which makes no
     commit.
   - **Wording check:** `rg -il "trello|\bcards?\b|board"` hits only:
     - `docs/work/**`, `docs/proposals/**`, `.night-shift/**`;
     - ADRs other than 0014, plus ADR 0014 itself;
     - the new history entry;
     - Atlas outputs that echo their sources.

     Read and judge every other hit. "board" meaning the Backlog board is
     fine.
   - Run one focused review round (round 5) over the step 7 diff only.
     If it isn't PASS, reopen the board, keep Trello authoritative and
     bring it to the owner. Otherwise merge to `main` right away. Push, confirm CI is green, and delete the branch and
     worktree.
   - As a record commit on `main`: move `backlog-migration` to Done (Queued
     3, Review 1, Done 23, plus any late ports), and rewrite the handoff doc.
     In it, warn the open branches (`fix/atlas-step-under-labels`,
     `docs/private-repo` and the idea-run branches) that their next merge
     must re-run the wording check.
   - Publish the HTML report.

## Rollback

- **Before step 7:** Trello is untouched and authoritative. Deleting the
  branch undoes everything.
- **Inside step 7** (minutes): reopen the board with one API call.
- **After the merge:** roll forward only. Going back to Trello would mean
  porting new tasks by hand.

## Critical files

- `docs/development.md` and `AGENTS.md`
- `.claude/skills/backlog/SKILL.md` (new) and `.claude/skills/trello/*`
  (removed)
- `backlog/config.yml` (new)
- `docs/decisions/0014-*.md` (new) and `docs/review.md`
- `.atlas/src/*.json` and `.codex/agents/*.toml`

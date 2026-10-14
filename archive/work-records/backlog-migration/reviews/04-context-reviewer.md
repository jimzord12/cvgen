Round 4 context review: snapshot 3db25c2..9765962, focused on `.claude/skills/backlog/SKILL.md`, the section "Which branch a task change goes on".

**Checks**
- `python .atlas/_kit/atlas.py check` is clean: every page is `ok`, verified 2026-10-06. The `site.json` source range (1-116) matches the file's length.
- `docs/development.md:147-156` ("Where a task file changes") and `docs/review.md:50-56` (the record-keeping exemption) match the skill word for word on the two kinds of record commit. "Ending a session" points to the skill's route. Nothing contradicts.
- `03-dispositions.md` maps every round 3 item to a fix or an acceptance.
- The file is LF only.
- The push command is correct: plain `git push origin main` from a `main` checkout avoids the `:main` deny pattern. The `git worktree add <scratch> main` line runs only when no checkout has `main`, so it cannot hit the "already checked out" error.

**Findings**

Minor 1, `.claude/skills/backlog/SKILL.md:80-81` and `:97`. Bullet 1 now allows a `main` checkout that already holds "this record edit". Line 97 says to pull with `git pull --rebase origin main` before editing. Git refuses to rebase over unstaged changes, so an agent that edited first stops there with no guidance. Smallest fix: on line 97, either "commit the record edit, then `git pull --rebase origin main`", or add `--autostash`.

Minor 2, `.claude/skills/backlog/SKILL.md:99-100`. The new check says what not to do when `git status -sb` shows other commits ahead of `origin/main`, but not what to do instead. A fresh agent with other people's unpushed commits on local `main` has no next step. `git pull --rebase` will also have replayed those commits under the record commit. Smallest fix: append "if it shows more, do not push; treat it like the third bullet above."

Note. "the only one ahead" depends on the agent reading the ahead count (`ahead 1`). Naming the count would make the check mechanical.

None of these would cause a wrong publish: the rule fails safe (the agent stops before pushing). The gaps are only missing next steps.

Verdict: PASS

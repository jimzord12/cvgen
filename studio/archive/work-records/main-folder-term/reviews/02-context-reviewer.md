## Review round 2: context-reviewer, 2026-10-14

Snapshot: `.worktrees/task-30`, `git diff b2a0dde..3db3197`.

Verdict: FINDINGS. Recorded in substance (formatting condensed). Round-1 fixes hold.

Material
1. .atlas/src/pages/change-review.json:70, 86, 87, 198, 225, 240 still cite old ranges (only site.json was shifted; git-workflow.md grew 13 lines after 50, development.md 1 line after 80): :87 cites git-workflow.md:69-73 (now Commits; no-PR text at 82-86); :198 74-87 -> 87-100; :225 development.md:58-88 -> 58-89; :240 90-104 -> 91-105; :70 106-194 -> 107-195; :86 40-50 -> 40-63 so the branch step cites the new rule; :83 "often in a worktree" -> "in a worktree". `atlas.py check` hashes whole files, so the page was stamped verified while pointing at wrong lines. Fix: shift the six ranges, reword, rebuild, stamp.

Minor
2. docs/git-workflow.md:58 vs :61 overlap: on `main`, behind, with another session's tracked changes matches both "fast-forward" and "leave it". Fix: "on `main` and behind, with no tracked changes", or open case 3 with "otherwise, or".
3. :59 vs :62: no signal separates an agent-left branch from an unclear one; a cautious agent leaves the triggering case alone. Fix: "(a branch already merged into `main` counts, unless the handoff or the owner says he chose it)".
4. :53 "clean" may invite deleting another session's untracked folders; :79-80 forbids only git clean -x/-X. Fix: case 2 parenthetical "(untracked files survive the switch; leave those that are not the session's)".
5. Review folder `main-folder-term` does not match the task title's id `glossary:`; backlog skill :56-57 says the id names the docs/work folder; the Session Sweep looks there. Fix: retitle TASK-30 `main-folder-term: …`.

Notes
6. Task record "Result and evidence" still says "git-workflow 84-97" and "never ended a session on a feature branch" (superseded by the Review paragraph); "Proposed term: Main Folder" now repeats the term. Tidy at close.
7. The removed local path survives in Git history; accepted (username already public).

Checked and clean: three cases replace the contradiction; owner-branch exception consistent (:54, :62); glossary row definition + pointer only; Session Sweep line points to the rule, anchor resolves; backlog skill :80-96 fits, nothing switches the Main Folder; site.json 87-100 correct; atlas check ok; LF; no client data; no dated record edited.

## Dispositions (lead)

- 1-6: sent to the author to fix.

## Review round 1: context-reviewer, 2026-10-14

Snapshot: worktree `.worktrees/task-30`, diff 298fc49..17f66e0.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Material
1. docs/git-workflow.md:55-60 — the recovery steps contradict each other. In the triggering case (Main Folder on an old merged branch, 48 commits behind, another session's untracked folders) the text says leave it alone and work in a worktree, so the problem stays; the same sentence says never end a session with it on a branch; "behind `main`" is in the leave-alone list while the last sentence says fast-forward; the Session Sweep (development.md:60-63) says act or name it; no way to tell an owner-chosen branch from a stale one. Fix: three cases — on `main` and behind: fast-forward; on a branch an agent left, no tracked changes: switch to `main` and fast-forward (untracked files survive); tracked changes not yours, an owner-chosen branch, or unclear: leave it, work in a worktree, name it in the Sweep and handoff. Narrow "never ends a session with it left on one" to "never leaves it on a branch the session put it on".
2. docs/glossary.md:86 and docs/development.md:80-82 restate the rule in different words and drop the "(or on the branch the owner chose for it)" exception. Fix: glossary keeps the definition and the pointer, deletes the rule sentence; the Sweep check points to the rule ("The `Main Folder` follows its rule (git-workflow.md#branches)").

Minor
3. docs/git-workflow.md:58-59 — the reason "(a stale checkout makes the project look older than it is)" belongs to the whole rule; move it or drop it.

Notes
4. glossary.md:86 Added "2026-10-14, owner": the owner asked for the concept, the lead proposed the name; "2026-10-14" alone is more accurate.
5. backlog/docs/doc-1:28, :36 say "main folder" lowercase; fix at the next handoff rewrite.
6. Task record: line 18 holds the owner's absolute local path (pre-existing, public; consider "the `Main Folder`"); AC #5 unchecked though the checks pass; AC #1 duplicates #3.
7. git-workflow.md:52 "every worktree under `.worktrees/` is an extra checkout" omits the backlog skill's scratchpad checkout; harmless (line 47 names it).

Checked and clean: Atlas check ok, shifted citations correct (git-workflow.md:84-97, backlog skill 1-118); backlog skill 80-82 matches the route to main and no doc switches the Main Folder; no other naming of the concept outside dated records; fits git-workflow.md:27 and the AGENTS.md row; LF; no owner path or client data added.

## Dispositions (lead)

- 1, 2, 3, 4, 6: sent to the author to fix. 5: done at the session-end handoff rewrite. 7: accepted.

# Round 1 dispositions (lead)

Two fresh reviewers on 1e684eb..0fbc85d: `context-reviewer` (general-purpose
agent, Opus, given `.claude/agents/context-reviewer.md` as its brief, since
this session's agent list predates that profile) for the rules and wiring,
and `code-reviewer` as the focused data-migration reviewer.

| Finding | Disposition |
|---|---|
| CR-1 Material: detached worktree cannot `git pull --rebase` | Fixed: the skill now fetches, rebases on `origin/main` and pushes |
| CR-2 Minor: handoff intro still says cards | Fixed now; the Trello pitfall goes at the step 7 rewrite |
| CR-3 Minor: framework-gaps status lines say card | Fixed (three lines) |
| CR-4 Minor: `--plain` missing from development.md examples | Fixed |
| CR-5 Minor: context-maintainer.md line not wrapped | Fixed, with the refinement note below |
| CR Note: ADR and history say exported and closed before step 7 | Accepted: true once step 7 runs; merge only after it |
| CR Note: remote branches only as fresh as `git fetch` | Fixed in the skill and the Session Sweep line |
| CR Note: sweep needs a checkout with `backlog/` | Fixed in the Session Sweep line |
| CR Note: refining migrated Queued tasks | Fixed: development.md and context-maintainer.md say refinements go in notes and acceptance |
| CR Note: unnamed "task store" | Fixed: glossary term `Task Store` added |
| CR Note: trello skill must not survive the merge | Planned: deleted in step 7 |
| DR-F1 Minor: parity script case-insensitive, no label or file-set check | Fixed in the scratchpad script (`-cne`, label and extra-file checks); rerun shows only the two deliberate deltas |
| DR-F2 Minor: same as CR-1 | Fixed |
| DR-F3 Minor: snapshot time only in the scratchpad | Fixed: snapshot time, parity summary and export scope appended to TASK-27's notes |
| DR-N4: export must include closed cards, actions, attachments | Adopted for step 7 |
| DR-N1, N2, N3 | Accepted as noted |

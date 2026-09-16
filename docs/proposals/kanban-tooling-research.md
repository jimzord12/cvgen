---
kind: reference
---

# Kanban tooling: first trial

Status: Research and recommendation, 2026-09-15. No tool selected, installed,
or run. Companion to the [development protocol](development-protocol.md).
The trial is optional follow-up work, not a prerequisite for the next CV task.
Recheck time-sensitive tooling facts if this research is used later.

## Recommendation

Try **Backlog.md** first. Its Git-based task storage fits this repository and
keeps a future tool change manageable. Use an existing board; build only the
process-decision capability described in [process evolution](process-evolution.md).

## Options checked

These are assessments for our small, Claude-first project. Repository claims
and source inspection establish advertised capabilities, not local reliability.

| Project | What we get | Assessment |
|---|---|---|
| [Backlog.md](https://github.com/MrLesk/Backlog.md) | MIT; Markdown tasks, local browser/terminal boards, acceptance criteria, dependencies, CLI and MCP integration; Windows supported. About 6.7k GitHub stars when checked. | Best first trial: task data travels with Git and agents have a direct interface. |
| [Kanboard](https://github.com/kanboard/kanboard) | MIT; focused Kanban application. Maintainer declares maintenance mode: small fixes and community releases continue. [JSON-RPC API](https://docs.kanboard.org/v1/api/) supports integrations. | Conservative fallback if we want a separately hosted board; adds hosting and agent integration work. |
| [WeKan](https://github.com/wekan/wekan) | MIT; collaborative self-hosted board, Docker deployment and database-backed storage. | Worth trying if a shared browser experience becomes more important than Git-native records. More infrastructure to maintain. |
| [Plane](https://github.com/makeplane/plane) | AGPL-3.0; work items, cycles, roadmaps, cloud and self-hosted deployment. | Broader than today's need. Revisit for cross-project product planning. |
| [Vibe Kanban](https://www.vibekanban.com/blog/shutdown) | On April 10, 2026, its company announced closure and a transition to community maintenance, with remote services being retired. Local workspaces continue. | Defer while that transition settles; company closure does not mean the open-source code disappeared. |
| [PLANKA](https://github.com/plankanban/planka) | Free self-hosted Community board with REST API; current README describes fair-code/source-available licensing. | Outside our strict open-source shortlist. Do not infer permissive licensing from its repository tagline. |

## What supports confidence in Backlog.md

Its checked-in [CI workflow](https://github.com/MrLesk/Backlog.md/blob/main/.github/workflows/ci.yml)
defines full behavior tests on Linux, platform-focused tests on Windows/macOS,
and compiled-binary smoke checks. That is useful testing evidence; it does not
establish that a particular release passes on this machine. Stars measure
attention, not correctness. Claude should pin and verify the trial version.

The [configuration reference](https://github.com/MrLesk/Backlog.md/blob/main/ADVANCED-CONFIG.md)
supports custom statuses and a custom backlog directory. It also exposes
automatic commits, remote Git operations, hook bypass, and status-change shell
callbacks. For the trial: disable automatic commits and remote operations,
retain Git hooks, and leave callbacks unset. Configure the agreed five stages;
verify how blocked/cancelled work is represented before adoption.

## Concrete trial for Claude Code

After owner authorization, run a bounded pilot:

1. Use a fresh, isolated local trial directory with fictional tasks. Pin a
   release; record installation/configuration changes. Start with the CLI and
   local board; test MCP only if it improves the actual Claude workflow.
2. Create two representative tasks: a small change and a migration-sized brief.
   Exercise acceptance criteria, dependencies, status changes, review links,
   interruption/resume, and reading records without the tool.
3. Have a fresh Claude session recover Goal / Now / Next / You from the records.
   Exercise separate-worktree task visibility and conflicting updates before
   using the board across implementation worktrees.
4. Show the owner the board and a short catch-up. Report setup cost, retrieval
   effort, missing fields, and any repeated/manual reconciliation.

Success means both tasks retain their scope, evidence and decision links;
resume works without chat history; the owner finds the board useful; and task
state needs one authoritative edit. This setup pilot ends after those two
tasks. Adoption then gets a separate owner decision; two real implementation
tasks provide the first follow-up evaluation.

Inspect generated agent instructions before integration. Upstream's suggested
[agent workflow](https://github.com/MrLesk/Backlog.md#working-with-ai-agents)
includes owner code review and additional planning checkpoints. Our owner
reviews outcomes; Claude reviews code. Preserve our authorization boundaries
and decision history when adapting that guidance.

If adopted, Backlog.md's native task files replace the proposed task briefs in
`docs/work/`; review evidence may remain there by task ID. Do not maintain two
task ledgers. Process decisions retain their separate portable records. If the
trial fails, stop using it, retain findings, and propose exact cleanup actions
under the existing confirmation checkpoint. No automatic deletion.

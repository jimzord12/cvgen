---
kind: proposal
status: trial
revision: 1
---

# Trial Trello Free for task tracking

Authorized 2026-09-16. The owner selected a Trello Free trial instead of Kanboard,
explicitly relaxing the open-source requirement. No paid subscription or paid
add-ons. This authorizes two fictional tasks, not permanent adoption or a task
migration. Claude Code owns setup and execution; Codex records the design decision.

## Why and scope

The owner already knows Trello and wants to check cards and progress from a phone.
Hosted task tracking avoids maintaining a Kanban server. The smallest useful
trial is one board using the existing five-stage workflow.

For the two trial tasks, this is a temporary amendment to the approved
[development protocol](development-protocol.md) and [work records](work-records.md):

- Lists: Queued, Active, Review, Ready, Done. Existing completion criteria apply;
  a card movement does not grant a design/PDF approval or prove verification.
- Each card owns its brief, acceptance criteria and current status. Use its
  description/checklists for the relevant work-record sections; no duplicate
  Markdown task brief or locally maintained task ledger.
- Blocked work keeps its stage and gains a Blocked label, reason and links to
  dependency cards. Removing the label requires resolving the stated blocker.
- Link proposals/decisions and review evidence at their existing locations.
  Use accessible repository/commit or CI artifact links for public evidence,
  rather than Windows-only paths that the owner cannot open on a phone.
- Generate orientation from the board and linked evidence. If access fails,
  report that limitation; do not invent current state from an old export.
- Preserve Claude's implementation/review role, worktree isolation, agent-owned
  Git and the no-PR policy. Trello does not decide when checks can be skipped.

## Two-task trial

1. Use the owner's intended Free Workspace and one dedicated trial board. Obtain
   only missing workspace/access information; trial permission is already given.
   Confirm the test uses Free features, not temporary Premium access. Identify
   both cards clearly as fictional trial work. Keep real candidates and credentials
   out of cards, exports and public repository records.
2. Connect Claude to the official Trello MCP first. Verify create, read, edit and
   move operations, checklists and labels. Use the REST API or Trello UI for a
   setup gap if needed; keep any integration small and within the Free constraint.
3. Exercise all five stages and a blocked dependency across the two cards. Read
   their updated state from a fresh Claude session and a separate worktree, using
   the same board. Confirm no duplicate cards or task ledgers are needed.
4. Show the owner the board on their phone and collect a brief usability verdict.
5. Export the board as JSON. Inspect that the two tasks' titles, descriptions,
   acceptance checklists, stages, labels and dependency/evidence links are usable.
   Describe what is missing and how much effort recovering task data would take.
   An export is a dated snapshot, not a second task store or proven full backup.

The trial ends after these checks on the two cards, or earlier if a required
capability cannot work within Free. Append the board link, tested access method,
results, export evidence and owner's phone verdict here when they exist. Then
return this proposal to `pending` with a short adopt/reject recommendation.
Permanent adoption needs the owner's decision; no trial extension or paid
upgrade is implied. Any cleanup follows existing confirmation rules.

## Verified documentation, not execution evidence

Checked 2026-09-16:

- [Free pricing](https://trello.com/pricing): up to 10 boards and 10 collaborators
  per Workspace, unlimited cards and 10 MB per attachment. Custom Fields belong
  to Standard. The trial uses ordinary descriptions, checklists, labels and links.
- [Official MCP support](https://support.atlassian.com/trello/docs/connect-trello-to-ai-assistants-with-trello-mcp/)
  says all Trello plans are supported and lists card create/read/update/move,
  checklists and label attachment. A connection covers one Workspace. Label
  creation and comments are listed as future capabilities; do not depend on them.
- [Card REST API](https://developer.atlassian.com/cloud/trello/rest/api-group-cards/)
  documents card operations as an alternative. Account authorization and the
  actual Claude setup have not been tested here.
- [Export documentation](https://support.atlassian.com/trello/docs/exporting-data-from-trello/)
  permits board JSON export, but includes only the latest 1,000 actions and has
  no built-in JSON/CSV import to recreate a board. Paid exports are outside scope.

## Execution evidence

No board, connector, API operation or export has been tested in this task.
The authorized trial is awaiting Claude setup; no execution outcome is claimed.

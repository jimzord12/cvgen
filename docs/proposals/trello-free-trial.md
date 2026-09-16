---
kind: proposal
status: trial
revision: 2
---

# Trial Trello Free for task tracking

Authorized 2026-09-16. The owner selected a Trello Free trial instead of Kanboard,
explicitly relaxing the open-source requirement. No paid subscription or paid
add-ons. This authorizes two fictional tasks, not permanent adoption or a task
migration. Claude Code owns setup and execution; Codex records the design decision.

## Owner amendment: skill and direct API

2026-09-16, revision 2: the owner confirmed proceeding with Trello and selected
an on-demand Agent Skill using direct HTTP requests for the initial integration.
This replaces revision 1's MCP-first setup instruction. The two-task validation
and adoption endpoint remain; no successful execution or permanent adoption is
claimed. Revision 1 is preserved in Git at
`614afd7a309dc85aaf3b496d3f8601e57fb551ac`.

Claude creates the repository skill at `.claude/skills/trello/SKILL.md`, with a
short discovery/routing instruction in the agent entry guidance. Load detailed
Trello instructions only when needed. Do not install or use a Trello MCP server.

The first version uses `curl` or a lightweight HTTP facility and concise request
recipes for the trial operations. Keep setup and request details in the skill;
link this proposal for workflow rules rather than copying them. A small helper
is acceptable if needed for reliable quoting, credentials or output handling;
no custom CLI, generated SDK or new package is a prerequisite.

- Keep tokens outside tracked files, prompts and request logs. Resolve local
  credentials consistently from separate worktrees; do not embed them in the skill.
- Select the intended board explicitly and resolve its list IDs. Return compact
  results (card ID, URL, status and relevant errors) rather than whole board dumps.
- Verify writes by reading their result. After an uncertain create response,
  inspect existing cards before retrying so a timeout does not create duplicates.
- Preserve the existing five stages, decision boundaries and evidence links.

If real use justifies it, the optional progression is:

```text
Agent -> Trello skill -> small project CLI -> TypeScript client -> Trello API
```

The skill owns agent guidance; the CLI exposes only useful project operations;
the client handles authentication, request construction and API failures.
Keep project workflow policy outside generated API code. Hey API is a candidate,
not a selected dependency: check Trello's available OpenAPI description and
generator compatibility when this work is justified. Generated types do not
replace runtime validation of inputs and responses.

After the trial and adoption decision, the approved template-layout migration
is the intended first real task to track. Create its authoritative brief on the
board then; do not maintain a duplicate task ledger here.

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
2. Claude creates and uses the Trello skill described in revision 2 above. Verify
   create, read, edit and move operations, checklists and labels through direct
   REST requests. Use the Trello UI for account/board setup if needed; keep the
   integration small and within the Free constraint.
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
- Historical research only; revision 2 excludes MCP:
  [Official MCP support](https://support.atlassian.com/trello/docs/connect-trello-to-ai-assistants-with-trello-mcp/)
  says all Trello plans are supported and lists card create/read/update/move,
  checklists and label attachment. A connection covers one Workspace. Label
  creation and comments are listed as future capabilities; do not depend on them.
- [Card REST API](https://developer.atlassian.com/cloud/trello/rest/api-group-cards/)
  documents card operations as an alternative. Account authorization and the
  actual Claude setup have not been tested here.
- [API introduction](https://developer.atlassian.com/cloud/trello/guides/rest-api/api-introduction/)
  documents direct HTTP requests using an API key and user token. Rechecked for
  revision 2; this is the selected integration route, still awaiting execution.
- [Export documentation](https://support.atlassian.com/trello/docs/exporting-data-from-trello/)
  permits board JSON export, but includes only the latest 1,000 actions and has
  no built-in JSON/CSV import to recreate a board. Paid exports are outside scope.

## Execution evidence

2026-09-16, Claude Code, skill at `.claude/skills/trello/` (commit `c39ca1e`):

- **Access:** key and token are user-scope environment variables on the
  owner's machine; the helper reads them and never prints them. Workspace
  "Jimzord12 Projects" is Free (feature list has no Custom Fields; 5 of 10
  boards were in use).
- **Board:** [Marine CV trial](https://trello.com/b/IPsBxAwf/marine-cv-trial),
  private, lists Queued/Active/Review/Ready/Done, label Blocked (red), all
  created through the API.
- **Operations, each verified by reading the result back:** create board,
  lists, label; create two fictional cards with Markdown descriptions
  (headings, bullets, double and single quotes, backslash, percent, multi-line
  block quote: byte-identical on read-back); checklists with items; tick
  items; edit description; move `trial-a` through all five stages; `trial-b`
  created Blocked with reason and a dependency attachment to `trial-a`, label
  removed and card moved to Active after `trial-a` reached Done, resolution
  recorded in its description. Cards:
  [trial-a](https://trello.com/c/SzIhlEhJ) (Done, 3/3),
  [trial-b](https://trello.com/c/6bqw9sW8) (Active, 0/2).
- **Fresh session, separate worktree:** a headless `claude -p` in a detached
  worktree of `c39ca1e`, given only the skill, reported both cards' stage,
  labels, checklist progress and urls correctly and quoted `trial-b`'s Blocked
  section verbatim. It also noticed the section was stale after unblocking,
  which was then corrected. No duplicate cards or local ledger were needed.
- **Uncertain-create handling:** documented in the skill (list cards by name
  before retrying); no timeout occurred during the trial, so untested live.
- **Export:** `GET boards/<id>` with cards, lists, labels, checklists,
  attachments and actions, saved as `builds/trello-20260916-154302/board.json`
  (55 KB, local). Contains both titles, full descriptions, both checklists
  with item states, current lists, labels, the dependency attachment and 22
  actions (creates, 7 card updates, 3 check-item updates). Not recorded as
  actions: label add/remove (Trello does not emit them). Recovery: no import
  exists, but every field needed to recreate the board is present; a script
  replaying the JSON through the same helper is roughly an hour of work.
- **Phone verdict:** pending from the owner.

### Review of the skill

Round 1 on `ec5c23d..045f68d`, in-session `code-reviewer`, lead lenses 4
and 1: [docs/work/trello-trial/reviews/01.md](../work/trello-trial/reviews/01.md).
Verdict **FINDINGS**.

| Finding | Disposition |
|---|---|
| T1-01 Blocking: key and token printed on 404 (Trello echoes the request URL) | Fixed: credentials now travel in an `Authorization: OAuth` header, never in the URL; error output additionally redacts both values. Verified: `GET nonexistent-path-for-review` prints `HTTP 404 Cannot GET /1/nonexistent-path-for-review`, nothing else. Rotation of the exposed key and token requested from the owner; the values also appeared once in the lead session through a variable-name slip (`$t` vs `$T`), recorded in SKILL.md as a rule. |
| T1-02 Minor: `exit` unreachable after `Write-Error` | Fixed: failures write to stderr via `[Console]::Error` and exit 1 (API/board) or 2 (usage/env). Verified `$LASTEXITCODE`. |
| T1-03 Minor: no timeout, empty diagnostics on no-response | Fixed: `-TimeoutSec 30`; message carries the exception text when there is no HTTP status. |
| T1-04 Note: export recipe could overwrite | Fixed: recipe creates a fresh timestamped folder and writes with `-NoClobber`. |
| T1-05 Note: store the report | Accepted: stored at the path above and linked here. |
| T1-06 Note: orientation bullet after adoption | Deferred to the adoption decision. |

Round 2 on `045f68d..eeeb24d`, lead lenses 4 and 6:
[reviews/02.md](../work/trello-trial/reviews/02.md). Verdict **FINDINGS**.

| Finding | Disposition |
|---|---|
| T2-01 Material: `-Debug` traces the Authorization header | Fixed: `$DebugPreference = 'SilentlyContinue'` in the helper. Verified: `GET members/me -Debug` with streams 4 and 5 captured yields 60 bytes containing neither value. The reviewer's capture file `builds/review-trello-r2-20260916-160037/debug.txt` was deleted; a sweep of `builds/` finds the token nowhere else. Rotation still requested from the owner. |
| T2-02 Minor: `$LASTEXITCODE` not reset on success; exit 2 undocumented | Fixed: `exit 0` at the end; SKILL.md documents exit 1/2 and recommends `$?`. |
| T2-03 Minor: export recipe writes an empty file on failure | Fixed: recipe captures the JSON, checks `$?`, and only then creates the folder and writes. |
| T2-04 Note: failure line bypasses PowerShell redirection | Fixed: one sentence in SKILL.md. |

Round 3 on `eeeb24d..ea4459b`, lead lenses 4 and 6:
[reviews/03.md](../work/trello-trial/reviews/03.md). Verdict **FINDINGS**.

| Finding | Disposition |
|---|---|
| T3-01 Material: failed request stays in `$Error` with its header; `Get-Error` prints it | Fixed: the catch block removes its own record from `$Error` before reporting. Verified live: after a 400 and a 404, `$Error.Count` is 0 and `Get-Error` prints nothing; exit codes and messages unchanged. |
| T3-02 Note: `Set-PSDebug -Trace 2` traces every script's secrets | Accepted as stated; not countered in the helper. |
| T3-03 Note: forced `-Debug` via `$PSDefaultParameterValues` in an interactive session | Fixed: `Debug = $false` passed explicitly on the request. |

Round 4 on `ea4459b..8d231af`, lead lenses 4 and 6:
[reviews/04.md](../work/trello-trial/reviews/04.md). Verdict **FINDINGS**.

| Finding | Disposition |
|---|---|
| T4-01 Material: `-ErrorVariable` receives the record with the Authorization header; malformed token surfaces the raw header | Fixed: the catch block removes the Authorization header from the shared request object (one instance behind `$Error`, `-ErrorVariable` and the response), and both credentials are validated against `^[A-Za-z0-9_-]+$` before any request. Verified live: after a 400 and a 404 with `-ErrorVariable`, `Get-Error`, `Format-List * -Force` and `.TargetObject.Headers` dumps (20 KB) contain neither value; a token with a quote exits 2 with an empty error variable. |
| T4-02 Note: SKILL.md diagnostics sentence | Fixed: states that `$Error`/`Get-Error` are empty by design and `-ErrorVariable` carries a scrubbed record. |

Remaining before the endpoint: the owner's phone verdict and the credential
rotation. Recommendation so
far: adopt for the migration task; the Free tier covered every operation the
protocol needs.

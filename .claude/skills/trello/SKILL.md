---
name: trello
description: Read and update this project's Trello board through the REST API with the bundled helper. Use when a task record lives on a Trello card - orientation from the board, creating or editing a card, moving it between the five stages, checklists, the Blocked label, or exporting the board. Trial scope only until adoption is decided.
---

# Trello

Direct HTTP through `trello.ps1` in this folder. No MCP server, no SDK.
Workflow rules (stages, what a card may and may not prove) are in
`docs/proposals/trello-free-trial.md`; this skill only covers mechanics.

## Credentials

`TRELLO_API_KEY` and `TRELLO_API_TOKEN` are user-scope environment variables
on the owner's machine, so every worktree and fresh session sees them. The
helper sends them in an `Authorization` header (never in the URL, which
Trello echoes back in 404 bodies), redacts them from its own error output,
and refuses to run without them. Never paste them into a card, a commit, a
log or the chat, and never copy them into a PowerShell variable in a tool
call: variable names are case-insensitive, so `$t` silently overwrites `$T`
and the shell prints the value in its error. If they are missing, ask the
owner to set them in his own shell; do not ask for the values.

## The board

Trial board: **Marine CV trial** (`https://trello.com/b/IPsBxAwf`), workspace
"Jimzord12 Projects" (Free). Lists in order: Queued, Active, Review, Ready,
Done. One label: **Blocked** (red). Always resolve ids by name, never hard-code
them in a card or a doc:

```powershell
./.claude/skills/trello/trello.ps1 -Lists 'Marine CV trial'   # board id, url, list name -> id
./.claude/skills/trello/trello.ps1 -Cards 'Marine CV trial'   # id, name, list, labels, n/m checklist, url
```

Board orientation is those two calls; no board dump. Read a single card fully
with `GET cards/<id> -Query @{ fields = 'name,desc,idList,labels'; checklists = 'all' }`.

## Requests

```powershell
./.claude/skills/trello/trello.ps1 <GET|POST|PUT|DELETE> <path> [-Query @{}] [-Body @{}] [-Pretty]
```

`-Body` is sent as JSON, so Markdown, quotes, backslashes and multi-line
descriptions pass through unchanged; build long descriptions in a PowerShell
here-string. Output is compact JSON on stdout. Failures print one line
straight to the console's stderr and exit 1 (API or board lookup) or 2
(usage or missing credentials); that line bypasses PowerShell's error
stream, so `2>$null`, `2>&1` and `try/catch` do not see it, `$Error` and
`Get-Error` stay empty by design, and `-ErrorVariable` receives the record
with its Authorization header removed. There is nothing more to dig for:
the stderr line is the whole diagnosis. Test success with `$?` right after
the call; `$LASTEXITCODE` also holds the code. Recipes
for cards, checklists, labels, moves and export are in
[recipes.md](recipes.md); load it only when you need one.

## Rules of use

- **Verify every write by reading it back** (the card's `idList`, `desc`,
  checklist state). A 200 on the write is not the evidence; the read is.
- **Uncertain create** (timeout, no body): before retrying, run `-Cards` and
  look for the name you tried to create. Reuse the existing card; never
  create a second one.
- Card names start with the task id (`trial-a: ...`). Fictional trial cards
  say so in name and description.
- Keep real candidate data and credentials out of cards and exports.
- Links on cards must open on a phone: GitHub blob/commit URLs and CI run
  URLs, never local Windows paths.
- A card moving to Done proves nothing by itself; completion criteria in
  `docs/development.md` still apply.

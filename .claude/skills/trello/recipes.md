# Trello recipes

Load on demand from `SKILL.md`. `$T = './.claude/skills/trello/trello.ps1'`.
All verified against the live API on 2026-09-16 (Trello REST v1).

## Cards

```powershell
# create (desc is a here-string; Markdown and quotes are safe)
$card = & $T POST cards -Body @{ idList = $listId; name = 'id: outcome'; desc = $desc; pos = 'bottom' } | ConvertFrom-Json
# read
& $T GET "cards/$($card.id)" -Query @{ fields = 'name,desc,idList,labels,shortUrl'; checklists = 'all' } -Pretty
# edit description / rename
& $T PUT "cards/$($card.id)" -Body @{ desc = $newDesc }
# move between stages
& $T PUT "cards/$($card.id)" -Body @{ idList = $targetListId }
# link another card or evidence (shows under Attachments; opens on a phone)
& $T POST "cards/$($card.id)/attachments" -Body @{ url = 'https://trello.com/c/xxxx'; name = 'Depends on monorepo-migration' }
```

## Session handoff card

```powershell
# find it (one card, list Handoff)
$hand = & $T -Cards 'Marine CV' | ConvertFrom-Json | Where-Object { $_.name -like 'session-handoff*' }
# read at the start of a session
(& $T GET "cards/$($hand.id)" -Query @{ fields = 'desc' } | ConvertFrom-Json).desc
# rewrite at the end (whole description; first lines carry the date and who wrote it)
& $T PUT "cards/$($hand.id)" -Body @{ desc = $desc }
(& $T GET "cards/$($hand.id)" -Query @{ fields = 'desc' } | ConvertFrom-Json).desc -match '\*\*Written:\*\* ' + (Get-Date -Format 'yyyy-MM-dd')
```

## Checklists

```powershell
$ck = & $T POST checklists -Body @{ idCard = $card.id; name = 'Acceptance' } | ConvertFrom-Json
& $T POST "checklists/$($ck.id)/checkItems" -Body @{ name = 'Observable behaviour and its evidence' }
& $T PUT "cards/$($card.id)/checkItem/$itemId" -Body @{ state = 'complete' }   # or 'incomplete'
```

## Labels

```powershell
& $T GET "boards/$boardId/labels" -Query @{ fields = 'name,color' }
& $T POST labels -Body @{ name = 'Blocked'; color = 'red'; idBoard = $boardId }   # once per board
& $T POST "cards/$($card.id)/idLabels" -Body @{ value = $labelId }               # add
& $T DELETE "cards/$($card.id)/idLabels/$labelId"                                  # remove
```

Blocked convention: keep the card in its stage, add the label, and put a
`## Blocked` section in the description with the reason, the dependency card
link and the unblock condition.

## Board setup (done once; kept for a future board)

```powershell
$b = & $T POST boards -Body @{ name = 'Marine CV'; idOrganization = $orgId; defaultLists = $false; prefs_permissionLevel = 'private' } | ConvertFrom-Json
foreach ($n in 'Queued','Active','Review','Ready','Done') { & $T POST lists -Body @{ name = $n; idBoard = $b.id; pos = 'bottom' } }
```

## Export

Full board JSON with the same content the Trello UI export gives (cards,
lists, labels, checklists, attachments, up to 1000 actions). Write it to a
fresh folder under `builds/`; it is a dated snapshot, not a backup store.

```powershell
$json = & $T GET "boards/$boardId" -Query @{ fields = 'all'; cards = 'all'; card_attachments = 'true'; card_checklists = 'all'; lists = 'all'; labels = 'all'; checklists = 'all'; actions = 'all'; actions_limit = 1000 } -Pretty
if (-not $?) { throw 'export failed; nothing written' }
$dir = New-Item -ItemType Directory ("builds/trello-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
$json | Out-File "$dir/board.json" -NoClobber -Encoding utf8
```

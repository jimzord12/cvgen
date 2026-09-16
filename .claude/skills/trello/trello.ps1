# Small Trello REST helper for the trello skill. Reads credentials from the
# TRELLO_API_KEY and TRELLO_API_TOKEN environment variables so it works the
# same from any worktree, and never prints them. Output is compact JSON.
#
#   ./trello.ps1 GET  members/me -Query @{ fields = 'username' }
#   ./trello.ps1 POST cards      -Body  @{ idList = $id; name = 'x'; desc = "multi`nline" }
#   ./trello.ps1 -Lists 'Board name'      # list name -> id for one board
#   ./trello.ps1 -Cards 'Board name'      # compact cards: id, list, labels, url
[CmdletBinding(DefaultParameterSetName = 'Request')]
param(
    [Parameter(ParameterSetName = 'Request', Position = 0)]
    [ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
    [string]$Method,
    [Parameter(ParameterSetName = 'Request', Position = 1)]
    [string]$Path,
    [Parameter(ParameterSetName = 'Request')]
    [hashtable]$Query = @{},
    [Parameter(ParameterSetName = 'Request')]
    [hashtable]$Body,
    [Parameter(ParameterSetName = 'Lists')]
    [string]$Lists,
    [Parameter(ParameterSetName = 'Cards')]
    [string]$Cards,
    [switch]$Pretty
)

$ErrorActionPreference = 'Stop'
$key = $env:TRELLO_API_KEY
$token = $env:TRELLO_API_TOKEN
if (-not $key -or -not $token) {
    Write-Error 'Set TRELLO_API_KEY and TRELLO_API_TOKEN as environment variables (user scope), then start a new shell.'
    exit 2
}

function Invoke-Trello([string]$Method, [string]$Path, [hashtable]$Query, [hashtable]$Body) {
    $pairs = @("key=$key", "token=$token")
    foreach ($k in $Query.Keys) { $pairs += "$k=" + [uri]::EscapeDataString([string]$Query[$k]) }
    $uri = 'https://api.trello.com/1/' + $Path.TrimStart('/') + '?' + ($pairs -join '&')
    $req = @{ Method = $Method; Uri = $uri }
    if ($Body) {
        $req.ContentType = 'application/json; charset=utf-8'
        $req.Body = [Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json -Depth 10 -Compress))
    }
    try {
        # Comma keeps a JSON array as one object so callers can foreach over it.
        return ,(Invoke-RestMethod @req)
    } catch {
        $status = $_.Exception.Response.StatusCode.value__
        $detail = $_.ErrorDetails.Message
        Write-Error "Trello $Method /$Path failed: HTTP $status $detail"
        exit 1
    }
}

function Find-Board([string]$Name) {
    $boards = @(Invoke-Trello GET 'members/me/boards' @{ fields = 'name,url,closed' } $null | ForEach-Object { $_ })
    $hit = @($boards | Where-Object { $_.name -eq $Name -and -not $_.closed })
    if ($hit.Count -ne 1) {
        Write-Error "Expected exactly one open board named '$Name', found $($hit.Count). Open boards: $(($boards | Where-Object { -not $_.closed } | ForEach-Object name) -join ' | ')"
        exit 1
    }
    return $hit[0]
}

function Out-Result($obj) {
    if ($Pretty) { ConvertTo-Json -InputObject $obj -Depth 10 } else { ConvertTo-Json -InputObject $obj -Depth 10 -Compress }
}

switch ($PSCmdlet.ParameterSetName) {
    'Lists' {
        $board = Find-Board $Lists
        $boardLists = Invoke-Trello GET "boards/$($board.id)/lists" @{ fields = 'name' } $null
        Out-Result ([ordered]@{ board = $board.id; url = $board.url; lists = @(foreach ($l in $boardLists) { [ordered]@{ name = $l.name; id = $l.id } }) })
    }
    'Cards' {
        $board = Find-Board $Cards
        $listNames = @{}
        foreach ($l in (Invoke-Trello GET "boards/$($board.id)/lists" @{ fields = 'name' } $null)) { $listNames[$l.id] = $l.name }
        $boardCards = Invoke-Trello GET "boards/$($board.id)/cards" @{ fields = 'name,idList,labels,shortUrl,badges' } $null
        Out-Result @(foreach ($c in $boardCards) {
            [ordered]@{
                id = $c.id; name = $c.name; list = $listNames[$c.idList]
                labels = @(foreach ($lb in @($c.labels)) { $lb.name })
                checklist = "$($c.badges.checkItemsChecked)/$($c.badges.checkItems)"
                url = $c.shortUrl
            }
        })
    }
    default {
        if (-not $Method -or -not $Path) { Write-Error 'Usage: trello.ps1 <GET|POST|PUT|DELETE> <path> [-Query @{}] [-Body @{}] | -Lists <board> | -Cards <board>'; exit 2 }
        Out-Result (Invoke-Trello $Method $Path $Query $Body)
    }
}

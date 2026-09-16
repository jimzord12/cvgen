param(
    [string]$OutputDirectory = ("builds/library-" + (Get-Date -Format 'yyyyMMdd-HHmmss-fff')),
    [string]$TypstExecutable = 'typst',
    [switch]$HideVesselDurations
)
$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Push-Location $projectRoot
try {
    if (Test-Path -LiteralPath $OutputDirectory) {
        throw 'Output directory already exists. Choose a new directory to preserve previous builds.'
    }
    $compiler = Get-Command $TypstExecutable -ErrorAction Stop
    New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
    $examples = @(
        @{ Source = 'examples/flagship/engineer.typ'; Name = 'Marine-Engineer-CV-v12.pdf' },
        @{ Source = 'examples/flagship/captain.typ'; Name = 'Marine-Captain-CV-Classic-v01.pdf' },
        @{ Source = 'examples/flagship/captain-silver.typ'; Name = 'Marine-Captain-CV-Silver-v01.pdf' }
    )
    $durationMode = if ($HideVesselDurations) { 'false' } else { 'true' }
    foreach ($example in $examples) {
        $destination = Join-Path $OutputDirectory $example.Name
        & $compiler.Source compile --root . --font-path packages/cv-engine/fonts --input "vessel-durations=$durationMode" $example.Source $destination
        if ($LASTEXITCODE -ne 0) { throw "Compilation failed: $($example.Source)" }
    }
    Write-Host "Three CVs created in $OutputDirectory"
}
finally {
    Pop-Location
}

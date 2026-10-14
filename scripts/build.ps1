param(
    [string]$OutputDirectory = ("builds/library-" + (Get-Date -Format 'yyyyMMdd-HHmmss-fff')),
    [string]$TypstExecutable = 'typst',
    [string]$PythonExecutable = 'python',
    [switch]$HideVesselDurations,
    # A deliberate release (constitution section 2): after the build, copy each PDF beside its
    # entry point in examples/ as the `Release` and stamp its Meta File (Output Contract).
    # It refuses while any `Release` PDF already exists: replacing one is the owner's go.
    [switch]$Release,
    # The owner's go (docs/preferences.md): -Release that replaces the existing `Release` PDFs.
    # An agent passes it only after the owner said yes to this exact command.
    [switch]$ReplaceRelease
)
$ErrorActionPreference = 'Stop'
if ($ReplaceRelease) { $Release = $true }
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Push-Location $projectRoot
try {
    if (Test-Path -LiteralPath $OutputDirectory) {
        throw 'Output directory already exists. Choose a new directory to preserve previous builds.'
    }
    # The one example list, shared with tests/run.py: every public example, its title (with version)
    # and the look it shows.
    $examples = @((Get-Content -LiteralPath 'examples/release.json' -Raw -Encoding UTF8 | ConvertFrom-Json).examples)
    if ($examples.Count -eq 0) { throw 'examples/release.json lists no examples.' }
    if ($Release) {
        if ($HideVesselDurations) { throw 'The Release shows vessel durations; drop -HideVesselDurations.' }
        # Never overwrite (constitution section 2): checked before anything is built or written.
        $existing = @($examples | ForEach-Object { [IO.Path]::ChangeExtension($_.source, '.pdf') } | Where-Object { Test-Path -LiteralPath $_ })
        if ($existing.Count -gt 0 -and -not $ReplaceRelease) {
            throw ("Refused: the Release already exists ($($existing -join ', ')). Replacing it needs the owner's " +
                "explicit go (docs/preferences.md); with it he runs ./scripts/build.ps1 -ReplaceRelease. " +
                'Nothing was built or written.')
        }
    }
    $compiler = Get-Command $TypstExecutable -ErrorAction Stop
    New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
    $durationMode = if ($HideVesselDurations) { 'false' } else { 'true' }
    foreach ($example in $examples) {
        $destination = Join-Path $OutputDirectory ([IO.Path]::GetFileNameWithoutExtension($example.source) + '.pdf')
        # Fonts strict (task-46): bundled fonts only; a family Typst cannot find is set in another font with
        # only a warning and exit code 0, so that warning fails the build.
        $ErrorActionPreference = 'Continue'   # stderr lines from a native command must not throw here
        $log = (& $compiler.Source compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --input "vessel-durations=$durationMode" $example.source $destination 2>&1 | ForEach-Object { "$_" }) -join "`n"
        $exitCode = $LASTEXITCODE
        $ErrorActionPreference = 'Stop'
        if ($log) { Write-Host $log }
        if ($exitCode -ne 0) { throw "Compilation failed: $($example.source)" }
        if ($log -match 'warning: unknown font family') { throw "A font family is not bundled, so Typst used another font: $($example.source)" }
    }
    Write-Host "$($examples.Count) CVs created in $OutputDirectory"
    if ($Release) {
        foreach ($example in $examples) {
            $name = [IO.Path]::GetFileNameWithoutExtension($example.source) + '.pdf'
            $target = Join-Path $projectRoot ([IO.Path]::ChangeExtension($example.source, '.pdf'))
            # File.Copy with overwrite false throws on an existing file: only -ReplaceRelease overwrites.
            [IO.File]::Copy((Join-Path (Resolve-Path -LiteralPath $OutputDirectory).Path $name), $target, [bool]$ReplaceRelease)
            & $PythonExecutable scripts/outputs.py stamp $target status=release style=Flagship "title=$($example.title)" "variant=$($example.variant)" producedBy=scripts/build.ps1 | Out-Null
            if ($LASTEXITCODE -ne 0) { throw "Stamping failed: $target" }
        }
        Write-Host 'Release written beside the entry points in examples/ and stamped; commit it as a deliberate release.'
    }
}
finally {
    Pop-Location
}

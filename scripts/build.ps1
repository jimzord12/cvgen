param(
    [string]$OutputDirectory = ("builds/library-" + (Get-Date -Format 'yyyyMMdd-HHmmss-fff')),
    [string]$TypstExecutable = 'typst',
    [string]$PythonExecutable = 'python',
    [switch]$HideVesselDurations,
    # A deliberate release (constitution section 2): after the build, copy each PDF beside its
    # entry point in examples/ as the `Release` and stamp its Meta File (Output Contract).
    [switch]$Release
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
    # The `Release`: every public example, its title (with version) and the look it shows.
    $examples = @(
        @{ Source = 'examples/marine/flagship/engineer.typ'; Title = 'Marine Engineer CV v12'; Variant = 'Golden Blue' },
        @{ Source = 'examples/marine/flagship/captain.typ'; Title = 'Marine Captain CV Classic v01'; Variant = 'Golden Blue' },
        @{ Source = 'examples/marine/flagship/captain-silver.typ'; Title = 'Marine Captain CV Silver v01'; Variant = 'Silver Bridge' },
        @{ Source = 'examples/marine/flagship/chief-officer.typ'; Title = 'Marine Chief Officer CV Silver v01'; Variant = 'Silver Bridge' },
        @{ Source = 'examples/marine/flagship/deck-cadet.typ'; Title = 'Marine Deck Cadet CV One-page v01'; Variant = 'Golden Blue, one page' }
    )
    $durationMode = if ($HideVesselDurations) { 'false' } else { 'true' }
    foreach ($example in $examples) {
        $destination = Join-Path $OutputDirectory ([IO.Path]::GetFileNameWithoutExtension($example.Source) + '.pdf')
        # Fonts strict (task-46): bundled fonts only; a family Typst cannot find is set in another font with
        # only a warning and exit code 0, so that warning fails the build.
        $ErrorActionPreference = 'Continue'   # stderr lines from a native command must not throw here
        $log = (& $compiler.Source compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --input "vessel-durations=$durationMode" $example.Source $destination 2>&1 | ForEach-Object { "$_" }) -join "`n"
        $exitCode = $LASTEXITCODE
        $ErrorActionPreference = 'Stop'
        if ($log) { Write-Host $log }
        if ($exitCode -ne 0) { throw "Compilation failed: $($example.Source)" }
        if ($log -match 'warning: unknown font family') { throw "A font family is not bundled, so Typst used another font: $($example.Source)" }
    }
    Write-Host "$($examples.Count) CVs created in $OutputDirectory"
    if ($Release) {
        if ($HideVesselDurations) { throw 'The Release shows vessel durations; drop -HideVesselDurations.' }
        foreach ($example in $examples) {
            $name = [IO.Path]::GetFileNameWithoutExtension($example.Source) + '.pdf'
            $target = Join-Path (Split-Path $example.Source) $name
            Copy-Item -LiteralPath (Join-Path $OutputDirectory $name) -Destination $target -Force
            & $PythonExecutable scripts/outputs.py stamp $target status=release style=Flagship "title=$($example.Title)" "variant=$($example.Variant)" producedBy=scripts/build.ps1 | Out-Null
            if ($LASTEXITCODE -ne 0) { throw "Stamping failed: $target" }
        }
        Write-Host 'Release written beside the entry points in examples/ and stamped; commit it as a deliberate release.'
    }
}
finally {
    Pop-Location
}

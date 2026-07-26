# Builds the Windows release and uploads it to Steam via SteamPipe.
#
# Prerequisites (one-time):
#   1. Steamworks SDK unpacked somewhere, steamcmd.exe inside
#      (sdk\tools\ContentBuilder\builder\steamcmd.exe).
#   2. YOUR_APP_ID / YOUR_DEPOT_ID replaced in steam\*.vdf.
#   3. First run of steamcmd asks for the Steam Guard code once; the
#      login token is cached next to steamcmd afterwards.
#
# Usage:
#   .\steam\build_steam.ps1 -SteamCmd "C:\sdk\tools\ContentBuilder\builder\steamcmd.exe" -Username your_builder_account
#   .\steam\build_steam.ps1 ... -SkipBuild     # upload the existing build only

param(
    [Parameter(Mandatory = $true)][string]$SteamCmd,
    [Parameter(Mandatory = $true)][string]$Username,
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot

# ---- 1. Build -------------------------------------------------------------
if (-not $SkipBuild) {
    Push-Location $repoRoot
    try {
        flutter pub get
        flutter build windows --release
    } finally {
        Pop-Location
    }
}

$releaseDir = Join-Path $repoRoot 'build\windows\x64\runner\Release'
if (-not (Test-Path $releaseDir)) {
    throw "Release build not found at $releaseDir - run without -SkipBuild first."
}

# Steam machines may lack the VC++ runtime; ship it like the installer does.
foreach ($dll in @('msvcp140.dll', 'vcruntime140.dll', 'vcruntime140_1.dll')) {
    $target = Join-Path $releaseDir $dll
    if (-not (Test-Path $target)) {
        Copy-Item "C:\Windows\System32\$dll" $target
        Write-Host "Bundled $dll"
    }
}

# ---- 2. Stage content root ------------------------------------------------
$contentDir = Join-Path $repoRoot 'build\steam_content\windows'
if (Test-Path $contentDir) { Remove-Item $contentDir -Recurse -Force }
New-Item -ItemType Directory -Path $contentDir -Force | Out-Null
Copy-Item "$releaseDir\*" $contentDir -Recurse
Write-Host "Staged $((Get-ChildItem $contentDir -Recurse -File).Count) files into $contentDir"

# ---- 3. Stamp version into the build description --------------------------
$version = (Select-String -Path (Join-Path $repoRoot 'pubspec.yaml') `
        -Pattern '^version:\s*(\S+)').Matches[0].Groups[1].Value.Split('+')[0]
$vdfTemplate = Get-Content (Join-Path $PSScriptRoot 'app_build.vdf') -Raw
if ($vdfTemplate -match 'YOUR_APP_ID') {
    throw 'Replace YOUR_APP_ID / YOUR_DEPOT_ID in steam\*.vdf with your real Steamworks ids first.'
}
$stampedVdf = Join-Path $repoRoot 'build\app_build_stamped.vdf'
$vdfTemplate.Replace('__VERSION__', "v$version") | Set-Content $stampedVdf

# ---- 4. Upload ------------------------------------------------------------
& $SteamCmd +login $Username +run_app_build $stampedVdf +quit
if ($LASTEXITCODE -ne 0) { throw "steamcmd exited with code $LASTEXITCODE" }

Write-Host ''
Write-Host "Uploaded GMH v$version. Set the build live in Steamworks:"
Write-Host '  App Admin -> SteamPipe -> Builds -> select the new build -> set on a branch.'

# reset-demo.ps1
# ----------------------------------------------------------------------------
# Reset the notebooklm-by-jack-vidal install state on Jack's Windows machine
# back to "fresh student" so the install + login flow can be re-recorded
# from scratch. Intended for the maintainer's class-recording workflow,
# NOT for student use.
#
# What this removes:
#   - The installed Claude Code skill (~/.claude/skills/notebooklm-by-jack-vidal/)
#   - The upstream NotebookLM skill copies installed by `notebooklm skill install`
#     (~/.claude/skills/notebooklm/ and ~/.agents/skills/notebooklm/)
#   - The saved authentication and browser profile (~/.notebooklm/)
#   - The notebooklm-py Python package
#
# What this KEEPS by default:
#   - Playwright itself (still installed via pip, just left alone)
#   - The downloaded Chromium build (~330 MB at %LOCALAPPDATA%\ms-playwright)
#     — kept so the demo's `playwright install chromium` step is instant.
#     Pass -FullWipe to remove this too if you want to demo the full
#     first-time download.
#
# Usage:
#   .\reset-demo.ps1               # interactive confirmation prompt
#   .\reset-demo.ps1 -Force        # skip prompt (for scripted re-runs)
#   .\reset-demo.ps1 -FullWipe     # also remove Playwright Chromium download
# ----------------------------------------------------------------------------

#requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$FullWipe
)

$ErrorActionPreference = 'Stop'

function Write-Step($msg) { Write-Host "  -> $msg" -ForegroundColor Cyan }
function Write-Skip($msg) { Write-Host "  -  $msg (already clean)" -ForegroundColor DarkGray }
function Write-Done($msg) { Write-Host "  OK $msg" -ForegroundColor Green }

$skillUserDir     = Join-Path $env:USERPROFILE '.claude\skills\notebooklm-by-jack-vidal'
$skillUpstreamDir = Join-Path $env:USERPROFILE '.claude\skills\notebooklm'
$skillAgentsDir   = Join-Path $env:USERPROFILE '.agents\skills\notebooklm'
$notebooklmHome   = Join-Path $env:USERPROFILE '.notebooklm'
$playwrightDir    = Join-Path $env:LOCALAPPDATA 'ms-playwright'

if (-not $Force) {
    Write-Host ""
    Write-Host "About to remove:" -ForegroundColor Yellow
    Write-Host "  - notebooklm-py Python package"
    Write-Host "  - $skillUserDir"
    Write-Host "  - $skillUpstreamDir"
    Write-Host "  - $skillAgentsDir"
    Write-Host "  - $notebooklmHome (cookies + browser profile + notebook context)"
    if ($FullWipe) {
        Write-Host "  - $playwrightDir (Playwright browsers, ~330 MB)" -ForegroundColor Red
    } else {
        Write-Host "  (Playwright Chromium download will be kept — pass -FullWipe to remove it too)" -ForegroundColor DarkGray
    }
    Write-Host ""
    $reply = Read-Host "Continue? [y/N]"
    if ($reply -notmatch '^(y|yes)$') {
        Write-Host "Aborted." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""
Write-Host "Resetting demo state..." -ForegroundColor White

Write-Step "Stopping any Playwright Chromium processes that might hold profile locks"
$pwChromes = Get-Process -Name chrome -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -and $_.Path.StartsWith($playwrightDir) }
if ($pwChromes) {
    $pwChromes | Stop-Process -Force
    Start-Sleep -Milliseconds 500
    Write-Done ("Stopped {0} Chromium process(es)" -f $pwChromes.Count)
} else {
    Write-Skip "No Playwright Chromium running"
}

foreach ($dir in @($skillUserDir, $skillUpstreamDir, $skillAgentsDir)) {
    Write-Step "Removing $dir"
    if (Test-Path $dir) {
        Remove-Item $dir -Recurse -Force
        Write-Done "Removed"
    } else {
        Write-Skip "Not present"
    }
}

Write-Step "Removing $notebooklmHome"
if (Test-Path $notebooklmHome) {
    Remove-Item $notebooklmHome -Recurse -Force
    Write-Done "Removed"
} else {
    Write-Skip "Not present"
}

Write-Step "Uninstalling notebooklm-py"
& python -m pip show notebooklm-py *> $null
if ($LASTEXITCODE -eq 0) {
    & python -m pip uninstall -y notebooklm-py | Out-Null
    Write-Done "Uninstalled"
} else {
    Write-Skip "Not installed"
}

if ($FullWipe) {
    Write-Step "Removing $playwrightDir (full wipe)"
    if (Test-Path $playwrightDir) {
        Remove-Item $playwrightDir -Recurse -Force
        Write-Done "Removed (~330 MB freed)"
    } else {
        Write-Skip "Not present"
    }
}

Write-Host ""
Write-Host "Demo state reset. Ready for a fresh recording." -ForegroundColor Green
Write-Host ""
Write-Host "Suggested demo steps:" -ForegroundColor White
Write-Host "  1. Start screen recording"
Write-Host "  2. Show https://notebooklm.google.com (the test account's notebooks)"
Write-Host "  3. Open Claude Code"
Write-Host "  4. Run: npx skills add jackvidal/notebooklm-by-jack-vidal"
Write-Host "  5. Say to Claude: 'Connect me to my NotebookLM.'"
Write-Host "  6. Approve the pip + playwright permission prompts"
Write-Host "  7. Sign in to Google in the Chromium window that opens"
Write-Host "  8. Demo a quick artifact: 'List my notebooks' then 'Generate a mind map for notebook X'"
Write-Host ""

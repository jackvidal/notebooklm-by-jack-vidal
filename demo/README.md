# Demo / recording helpers

Scripts in this folder are for the maintainer's class-recording workflow, **not** for students. Students should follow the install instructions in the [main README](../README.md).

## reset-demo.ps1

Wipes the install state on a Windows machine so the install + login flow can be re-recorded from a fresh "first time student" state.

```powershell
# From the repo root, in PowerShell:
.\demo\reset-demo.ps1                 # interactive confirmation
.\demo\reset-demo.ps1 -Force          # skip confirmation (between takes)
.\demo\reset-demo.ps1 -FullWipe       # also remove Playwright Chromium download
```

By default the Playwright Chromium download is kept (it's ~330 MB, takes 1–2 min to re-download — not great on camera). Pass `-FullWipe` if you want to demo the full first-time experience including that download.

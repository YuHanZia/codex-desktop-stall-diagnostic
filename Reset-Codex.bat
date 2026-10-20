@echo off
title Reset Codex background process
powershell.exe -NoProfile -Command "$p = Get-Process -Name 'codex' -ErrorAction SilentlyContinue; if ($p) { try { $p | Stop-Process -Force -ErrorAction Stop; Write-Host 'Codex background processes stopped. Return to Codex and retry.' } catch { Write-Host $_.Exception.Message; exit 1 } } else { Write-Host 'No codex process is running.' }"
echo.
pause

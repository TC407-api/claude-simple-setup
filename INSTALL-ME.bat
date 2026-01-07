@echo off
echo Starting Claude Code Setup...
echo.
echo This will open PowerShell as Administrator.
echo Please click "Yes" when prompted.
echo.
pause
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0install.ps1\"' -Verb RunAs"

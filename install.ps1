# Claude Code - Personal Assistant Setup
# Run this script in PowerShell as Administrator

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Claude Code - Personal Assistant" -ForegroundColor Cyan
Write-Host "  Setup Wizard" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    pause
    exit 1
}

# Step 1: Check/Install Node.js
Write-Host "[1/4] Checking for Node.js..." -ForegroundColor Yellow
$nodeVersion = node --version 2>$null
if ($nodeVersion) {
    Write-Host "      Node.js found: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "      Node.js not found. Installing..." -ForegroundColor Yellow

    # Download and install Node.js LTS
    $nodeInstaller = "$env:TEMP\node-installer.msi"
    Write-Host "      Downloading Node.js (this may take a minute)..." -ForegroundColor Gray
    Invoke-WebRequest -Uri "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi" -OutFile $nodeInstaller
    Write-Host "      Installing Node.js..." -ForegroundColor Gray
    Start-Process msiexec.exe -Wait -ArgumentList "/i $nodeInstaller /quiet"
    Remove-Item $nodeInstaller

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    Write-Host "      Node.js installed!" -ForegroundColor Green
}

# Step 2: Install Claude Code
Write-Host ""
Write-Host "[2/4] Installing Claude Code..." -ForegroundColor Yellow
npm install -g @anthropic-ai/claude-code 2>$null
Write-Host "      Claude Code installed!" -ForegroundColor Green

# Step 3: Create .claude folder and copy configs
Write-Host ""
Write-Host "[3/4] Setting up your personal assistant..." -ForegroundColor Yellow
$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -Path $claudeDir -ItemType Directory -Force | Out-Null
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item "$scriptDir\CLAUDE.md" "$claudeDir\CLAUDE.md" -Force
Copy-Item "$scriptDir\settings.json" "$claudeDir\settings.json" -Force
Write-Host "      Configuration complete!" -ForegroundColor Green

# Step 4: Create desktop shortcut
Write-Host ""
Write-Host "[4/4] Creating desktop shortcut..." -ForegroundColor Yellow
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = "$desktopPath\Claude Assistant.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "cmd.exe"
$shortcut.Arguments = "/k claude"
$shortcut.WorkingDirectory = "$env:USERPROFILE"
$shortcut.Description = "Claude Code Personal Assistant"
$shortcut.Save()
Write-Host "      Desktop shortcut created!" -ForegroundColor Green

# Done!
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your personal Claude assistant is ready!" -ForegroundColor Cyan
Write-Host ""
Write-Host "To start:" -ForegroundColor White
Write-Host "  - Double-click 'Claude Assistant' on your desktop" -ForegroundColor White
Write-Host "  - OR open any terminal and type: claude" -ForegroundColor White
Write-Host ""
Write-Host "First time? You'll need to log in with your account." -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

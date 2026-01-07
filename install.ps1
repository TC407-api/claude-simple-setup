# Claude Code Simple Setup
# Run this script in PowerShell as Administrator

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Claude Code Simple Setup" -ForegroundColor Cyan
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

# Step 1: Check if Node.js is installed
Write-Host "Checking for Node.js..." -ForegroundColor Yellow
$nodeVersion = node --version 2>$null
if ($nodeVersion) {
    Write-Host "  Node.js found: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "  Node.js not found. Installing..." -ForegroundColor Yellow

    # Download and install Node.js
    $nodeInstaller = "$env:TEMP\node-installer.msi"
    Invoke-WebRequest -Uri "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi" -OutFile $nodeInstaller
    Start-Process msiexec.exe -Wait -ArgumentList "/i $nodeInstaller /quiet"
    Remove-Item $nodeInstaller

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    Write-Host "  Node.js installed!" -ForegroundColor Green
}

# Step 2: Install Claude Code
Write-Host ""
Write-Host "Installing Claude Code..." -ForegroundColor Yellow
npm install -g @anthropic-ai/claude-code
Write-Host "  Claude Code installed!" -ForegroundColor Green

# Step 3: Create .claude folder
Write-Host ""
Write-Host "Setting up configuration..." -ForegroundColor Yellow
$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -Path $claudeDir -ItemType Directory -Force | Out-Null
}

# Step 4: Copy config files
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item "$scriptDir\CLAUDE.md" "$claudeDir\CLAUDE.md" -Force
Copy-Item "$scriptDir\settings.json" "$claudeDir\settings.json" -Force
Write-Host "  Configuration files copied!" -ForegroundColor Green

# Step 5: Done!
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "To start Claude Code:" -ForegroundColor Cyan
Write-Host "  1. Open a new terminal (Command Prompt or PowerShell)" -ForegroundColor White
Write-Host "  2. Type: claude" -ForegroundColor White
Write-Host "  3. Follow the login prompts" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit..."
pause

# Safe Write Guard - Blocks writes to protected folders
# Returns error if trying to modify system files

param(
    [string]$FilePath = $env:CLAUDE_FILE_PATH
)

# Protected paths - NEVER allow writes here
$protectedPaths = @(
    "C:\Windows",
    "C:\Program Files",
    "C:\Program Files (x86)",
    "$env:SystemRoot",
    "$env:ProgramFiles",
    "${env:ProgramFiles(x86)}",
    "System32",
    "SysWOW64"
)

# Check if the file path contains any protected paths
foreach ($protected in $protectedPaths) {
    if ($FilePath -like "*$protected*") {
        Write-Host ""
        Write-Host "BLOCKED: Cannot modify system files!" -ForegroundColor Red
        Write-Host "Path: $FilePath" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "This is a protected system folder. Modifying it could break Windows." -ForegroundColor White
        Write-Host "If you really need to change system files, please ask a tech expert." -ForegroundColor White
        Write-Host ""
        exit 1
    }
}

# Check for hidden/system files
if (Test-Path $FilePath) {
    $attrs = (Get-Item $FilePath -Force).Attributes
    if ($attrs -band [System.IO.FileAttributes]::System) {
        Write-Host ""
        Write-Host "BLOCKED: This is a system file!" -ForegroundColor Red
        Write-Host "Modifying system files can cause problems." -ForegroundColor Yellow
        Write-Host ""
        exit 1
    }
}

# All good
exit 0

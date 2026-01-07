# Backup Reminder - Reminds to backup before major changes
# Triggers on Edit operations

$filePath = $env:CLAUDE_FILE_PATH

# Check if this is an important file type
$importantExtensions = @(".doc", ".docx", ".xls", ".xlsx", ".pdf", ".txt", ".csv", ".tax", ".dat")
$extension = [System.IO.Path]::GetExtension($filePath).ToLower()

if ($importantExtensions -contains $extension) {
    # Check if a backup exists
    $backupPath = "$filePath.backup"
    if (-not (Test-Path $backupPath)) {
        Write-Host ""
        Write-Host "TIP: This looks like an important file." -ForegroundColor Cyan
        Write-Host "Consider making a backup first by copying it." -ForegroundColor Gray
        Write-Host ""
    }
}

exit 0

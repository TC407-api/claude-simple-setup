# Friendly Error Explainer
# Makes error messages understandable for non-technical users

$lastExitCode = $env:CLAUDE_TOOL_EXIT_CODE
$toolOutput = $env:CLAUDE_TOOL_OUTPUT

if ($lastExitCode -ne 0 -and $lastExitCode -ne $null) {
    Write-Host ""
    Write-Host "Something didn't work as expected." -ForegroundColor Yellow

    # Common error patterns and friendly explanations
    $friendlyMessages = @{
        "Access is denied" = "You don't have permission to do this. Try running as Administrator, or this file might be in use."
        "cannot find" = "The file or folder doesn't exist. Check the spelling or location."
        "not recognized" = "This program isn't installed, or Windows can't find it."
        "being used by another process" = "Another program is using this file. Close other programs and try again."
        "network" = "There might be an internet connection problem. Check your WiFi or network cable."
        "permission denied" = "You don't have permission. The file might be protected or in use."
        "disk full" = "Your hard drive is full! You need to delete some files to make room."
        "timeout" = "The operation took too long. Your internet might be slow, or the server isn't responding."
        "not found" = "Couldn't find what we were looking for. Double-check the name or location."
    }

    $explained = $false
    foreach ($pattern in $friendlyMessages.Keys) {
        if ($toolOutput -match $pattern) {
            Write-Host $friendlyMessages[$pattern] -ForegroundColor Cyan
            $explained = $true
            break
        }
    }

    if (-not $explained) {
        Write-Host "Don't worry - let me try to figure out what went wrong." -ForegroundColor Cyan
    }
    Write-Host ""
}

exit 0

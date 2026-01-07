# Session Logger - Keeps track of what Claude does
# Creates a simple log file in Documents\ClaudeLogs

param(
    [string]$Event = "unknown"
)

$logDir = "$env:USERPROFILE\Documents\ClaudeLogs"
$logFile = "$logDir\claude-log-$(Get-Date -Format 'yyyy-MM').txt"

# Create log directory if it doesn't exist
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
}

# Get session info
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$sessionId = $env:CLAUDE_SESSION_ID
if (-not $sessionId) { $sessionId = "unknown" }

# Log the event
$logEntry = "[$timestamp] Session: $sessionId | Event: $Event"
Add-Content -Path $logFile -Value $logEntry

exit 0

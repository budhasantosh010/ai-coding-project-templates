# log_user_message.ps1
# Claude Code "UserPromptSubmit" hook.
# Every time you send a message, Claude Code runs this script and pipes it a small JSON
# blob on stdin. We pull out your message + the project folder, and append the message
# (with a timestamp) to DOCS\_raw\user_messages.txt. This is your guaranteed transcript.

$ErrorActionPreference = 'Stop'

# Walk upward from a starting folder until we find one containing BOTH CLAUDE.md and .claude.
# That folder is the project root, no matter where the hook was launched from.
function Find-ProjectRoot {
    param([string]$StartPath)

    if ([string]::IsNullOrWhiteSpace($StartPath)) {
        $StartPath = (Get-Location).Path
    }

    $current = [System.IO.Path]::GetFullPath($StartPath)
    while ($true) {
        $rules = Join-Path $current 'CLAUDE.md'
        $dir   = Join-Path $current '.claude'
        if ((Test-Path -LiteralPath $rules) -and (Test-Path -LiteralPath $dir)) {
            return $current
        }

        $parent = Split-Path -Path $current -Parent
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $current) {
            return $null
        }
        $current = $parent
    }
}

# Pull a plain-text message out of whatever shape the hook payload uses
# (string, {content:...}, or an array of content blocks).
function Get-TextValue {
    param($Value)

    if ($null -eq $Value) { return $null }
    if ($Value -is [string]) { return [string]$Value }
    if ($Value.PSObject.Properties.Name -contains 'content') {
        return Get-TextValue $Value.content
    }
    if ($Value -is [System.Collections.IEnumerable]) {
        $parts = foreach ($item in $Value) {
            $text = Get-TextValue $item
            if (-not [string]::IsNullOrWhiteSpace($text)) { $text }
        }
        if ($parts) { return ($parts -join "`n") }
    }
    return $null
}

try {
    # 1) Read the JSON the hook sends on stdin
    $raw = [Console]::In.ReadToEnd()
    $data = $null
    if (-not [string]::IsNullOrWhiteSpace($raw)) {
        try { $data = $raw | ConvertFrom-Json } catch { $data = $null }
    }

    # 2) Work out the message text (try the common field names, then fall back to raw)
    $prompt = $null
    if ($data) {
        foreach ($name in @('prompt', 'user_prompt', 'input', 'message')) {
            if ($data.PSObject.Properties.Name -contains $name) {
                $prompt = Get-TextValue $data.$name
                if (-not [string]::IsNullOrWhiteSpace($prompt)) { break }
            }
        }
    }
    if ([string]::IsNullOrWhiteSpace($prompt)) { $prompt = $raw }
    if ([string]::IsNullOrWhiteSpace($prompt)) { exit 0 }

    # 3) Work out the project folder: payload cwd → CLAUDE_PROJECT_DIR → search upward → cwd
    $startPath = $null
    if ($data -and ($data.PSObject.Properties.Name -contains 'cwd')) {
        $startPath = [string]$data.cwd
    } elseif ($env:CLAUDE_PROJECT_DIR) {
        $startPath = $env:CLAUDE_PROJECT_DIR
    }
    $root = Find-ProjectRoot $startPath
    if (-not $root -and $env:CLAUDE_PROJECT_DIR) { $root = $env:CLAUDE_PROJECT_DIR }
    if (-not $root) { $root = Find-ProjectRoot (Get-Location).Path }
    if (-not $root) { $root = (Get-Location).Path }

    # 4) Make sure DOCS\_raw exists, then append the message with a timestamp + thread id
    $rawDir = Join-Path $root 'DOCS\_raw'
    [System.IO.Directory]::CreateDirectory($rawDir) | Out-Null
    $logFile = Join-Path $rawDir 'user_messages.txt'

    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss K'
    $thread = if ($data -and ($data.PSObject.Properties.Name -contains 'session_id')) {
        [string]$data.session_id
    } elseif ($data -and ($data.PSObject.Properties.Name -contains 'thread_id')) {
        [string]$data.thread_id
    } else {
        'unknown'
    }

    # Running message NUMBER: count existing "===== [" headers, add 1. Lets decisions cite
    # exactly which user message they came from (e.g. "msg 7").
    $msgNum = 1
    if (Test-Path -LiteralPath $logFile) {
        $existing = Select-String -LiteralPath $logFile -Pattern '^===== \[' -AllMatches
        $msgNum = (@($existing).Count) + 1
    }

    $entry = "`r`n===== [$stamp] session=$thread msg=$msgNum =====`r`n$prompt`r`n"
    [System.IO.File]::AppendAllText($logFile, $entry, [System.Text.UTF8Encoding]::new($false))
    exit 0
}
catch {
    [Console]::Error.WriteLine("Claude prompt logger failed: $($_.Exception.Message)")
    exit 1
}

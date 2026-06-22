# render_decision_tree.ps1
# Reads DOCS/_raw/decisions.jsonl and draws the decision tree as:
#   DOCS/decision_tree.mmd  (Mermaid source - renders natively on GitHub)
#   DOCS/decision_tree.svg  (rendered image - double-click to view offline; needs mmdc)
#
# Runs as the Stop hook (after each agent turn) and is also called by record_decision.ps1.
# Costs ZERO model tokens - it's pure scripting over the data file.
# Fails safe: any error => prints nothing, exits 0, never blocks the session.

$ErrorActionPreference = 'Stop'

function Find-ProjectRoot {
    param([string]$StartPath)
    if ([string]::IsNullOrWhiteSpace($StartPath)) { $StartPath = (Get-Location).Path }
    $current = [System.IO.Path]::GetFullPath($StartPath)
    while ($true) {
        if ((Test-Path -LiteralPath (Join-Path $current 'CLAUDE.md')) -and
            (Test-Path -LiteralPath (Join-Path $current '.claude'))) { return $current }
        $parent = Split-Path -Path $current -Parent
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $current) { return $null }
        $current = $parent
    }
}

function Esc([string]$s) {
    if (-not $s) { return "" }
    # Mermaid label-safe: drop quotes/brackets that break node text.
    return ($s -replace '["\[\]\(\)\{\}|<>]', ' ' -replace '\s+', ' ').Trim()
}

try {
    # Stop hook sends JSON on stdin with cwd; tolerate empty stdin too.
    $root = $null
    try {
        $raw = [Console]::In.ReadToEnd()
        if (-not [string]::IsNullOrWhiteSpace($raw)) {
            $d = $raw | ConvertFrom-Json
            if ($d -and ($d.PSObject.Properties.Name -contains 'cwd')) { $root = Find-ProjectRoot ([string]$d.cwd) }
        }
    } catch { }
    if (-not $root) { $root = Find-ProjectRoot $env:CLAUDE_PROJECT_DIR }
    if (-not $root) { $root = Find-ProjectRoot (Get-Location).Path }
    if (-not $root) { exit 0 }

    $data = Join-Path $root 'DOCS\_raw\decisions.jsonl'
    if (-not (Test-Path -LiteralPath $data)) { exit 0 }

    $rows = @()
    foreach ($ln in (Get-Content -LiteralPath $data)) {
        if ([string]::IsNullOrWhiteSpace($ln)) { continue }
        $o = $null; try { $o = $ln | ConvertFrom-Json } catch { continue }
        if (-not $o) { continue }
        if ($o.PSObject.Properties.Name -contains '_comment') { continue }   # skip header
        if (-not ($o.PSObject.Properties.Name -contains 'id')) { continue }
        $rows += $o
    }
    if ($rows.Count -eq 0) { exit 0 }

    # Build Mermaid. Top-down tree. Node text shows the message number + title (+ chosen).
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine('graph TD')
    [void]$sb.AppendLine('  %% Auto-generated from DOCS/_raw/decisions.jsonl - do not edit by hand.')

    $classChosen     = 'classDef chosen fill:#1f6f3f,stroke:#2ea043,color:#fff;'
    $classRejected   = 'classDef rejected fill:#5a1e1e,stroke:#f85149,color:#fff;'
    $classSuperseded = 'classDef superseded fill:#4a4a00,stroke:#d4a72c,color:#fff;'
    $classPending    = 'classDef pending fill:#1b3a5c,stroke:#388bfd,color:#fff;'
    $classRoot       = 'classDef root fill:#30363d,stroke:#8b949e,color:#fff;'
    [void]$sb.AppendLine("  $classRoot")
    [void]$sb.AppendLine("  $classChosen")
    [void]$sb.AppendLine("  $classRejected")
    [void]$sb.AppendLine("  $classSuperseded")
    [void]$sb.AppendLine("  $classPending")

    foreach ($r in $rows) {
        $id = Esc ([string]$r.id)
        $title = Esc ([string]$r.title)
        $msg = if ($r.msg) { [int]$r.msg } else { 0 }
        $chosen = Esc ([string]$r.chosen)
        $status = if ($r.status) { [string]$r.status } else { 'chosen' }

        $label = if ($msg -gt 0) { "msg $msg | $id<br/>$title" } else { "$id<br/>$title" }
        if ($chosen) { $label += "<br/>-> $chosen" }
        if ($r.commit) { $label += "<br/>[$($r.commit)]" }

        [void]$sb.AppendLine("  $id[""$label""]:::$status")
    }

    # Edges parent -> child. ROOT nodes have no incoming edge.
    foreach ($r in $rows) {
        $id = Esc ([string]$r.id)
        $parent = Esc ([string]$r.parent)
        if ($parent -and $parent -ne 'ROOT') {
            [void]$sb.AppendLine("  $parent --> $id")
        }
    }

    $mmd = Join-Path $root 'DOCS\decision_tree.mmd'
    [System.IO.File]::WriteAllText($mmd, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

    # Render SVG via mermaid-cli if available. Skip silently if not (mmd still renders on GitHub).
    $svg = Join-Path $root 'DOCS\decision_tree.svg'
    try {
        $null = & npx --yes @mermaid-js/mermaid-cli -i $mmd -o $svg 2>$null
    } catch { }

    exit 0
}
catch { exit 0 }

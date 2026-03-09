Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Set-Location $PSScriptRoot
pandoc --defaults pandoc-journal.yaml
Write-Host "Built: $PSScriptRoot\paper.pdf"

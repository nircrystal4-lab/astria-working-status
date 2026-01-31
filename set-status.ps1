param(
  [Parameter(Mandatory=$true)][ValidateSet('IDLE','WORKING','ERROR')]$State,
  [string]$Task = ''
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

$statusPath = Join-Path $repoRoot 'status.json'

$now = (Get-Date).ToString('o')
$obj = [ordered]@{
  state = $State
  task = $Task
  updatedAt = $now
}

($obj | ConvertTo-Json -Depth 5) + "`n" | Set-Content -Encoding UTF8 $statusPath

git add status.json
$msg = "status: $State" + ($(if($Task){" — $Task"} else {""}))
git commit -m $msg

git push

Write-Host "Updated status.json -> $State" -ForegroundColor Green

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "== OSS preflight scan =="

$suspiciousFilePattern = '(?i)(\.env($|\.)|\.pem$|\.p12$|\.pfx$|\.jks$|\.keystore$|id_rsa$|id_ed25519$|credentials|secret|secrets)'
$secretValuePattern = '(?i)(ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|AIza[0-9A-Za-z\-_]{35}|AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|-----BEGIN (RSA|EC|OPENSSH|PRIVATE) KEY-----|[A-Za-z]+:\/\/[^\s:@]+:[^\s@]+@[^\s]+)'

Write-Host ""
Write-Host "[1/4] Suspicious filenames"
try {
  rg --files -uu | rg -i $suspiciousFilePattern
} catch {
  Write-Host "No suspicious filenames found by pattern."
}

Write-Host ""
Write-Host "[2/4] Secret-like values"
try {
  rg -n -uu $secretValuePattern
} catch {
  Write-Host "No secret-like values found by pattern."
}

Write-Host ""
Write-Host "[3/4] Build artifacts and large files (>5MB)"
Get-ChildItem -Recurse -Force -File |
  Where-Object { $_.Length -gt 5MB } |
  Sort-Object Length -Descending |
  Select-Object @{Name="MB";Expression={[math]::Round($_.Length / 1MB, 2)}}, FullName |
  Format-Table -AutoSize

Write-Host ""
Write-Host "[4/4] Historical/archive folders"
Get-ChildItem -Recurse -Force -Directory |
  Where-Object { $_.Name -match '^(archive|archives|old|legacy|backup|backups)$' } |
  Select-Object FullName |
  Format-Table -AutoSize

Write-Host ""
Write-Host "Scan complete."

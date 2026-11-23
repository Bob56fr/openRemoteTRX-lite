# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
# Arrête la station factice d'openRemoteTRX Lite et elle seule : processus lancés par station_factice.py, et processus
# qui ÉCOUTENT sur ses ports à part (18443, 14532, 47910) ; jamais ceux d'une station installée (8443, 4532, 47810).
$ids = @()
$ids += (Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -match 'station_factice' }).ProcessId
$ids += (Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -in 18443, 14532, 47910 }).OwningProcess
foreach ($id in ($ids | Where-Object { $_ } | Sort-Object -Unique)) {
    $p = Get-Process -Id $id -ErrorAction SilentlyContinue
    if ($p) { Stop-Process -Id $id -Force -ErrorAction SilentlyContinue; "arrêté $id $($p.ProcessName)" }
}
Start-Sleep -Seconds 1
Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -in 18443, 14532, 47910 } |
    ForEach-Object { "ENCORE en écoute : port $($_.LocalPort), processus $($_.OwningProcess)" }

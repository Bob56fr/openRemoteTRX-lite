# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
# Arrête la station factice d'openRemoteTRX Lite (jamais une station installée : seulement les processus de lite-essai)
Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -match 'station_factice|fake_rigctld --port 14532|lite-essai\\station\.toml' } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue; "arrêté $($_.ProcessId) $($_.Name)" }
netstat -an | Select-String ":18443 |:14532 "

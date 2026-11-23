# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
param([string]$Dossier = "C:\dev\lite-essai-lan")
# État du PTT de la station factice : « état propriétaire cause »
$p = (Get-Content "$Dossier\etat\status.json" -Raw | ConvertFrom-Json).ptt
"$($p.state) $($p.owner) $($p.last_cut_reason)"

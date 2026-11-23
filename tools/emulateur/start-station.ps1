# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
param(
    [Parameter(Mandatory)][string]$MotDePasse,
    [string]$Ecoute = "127.0.0.1",          # 127.0.0.1 = émulateur ; adresse de la machine dans le réseau local = vrai téléphone
    [string]$Dossier = "C:\dev\lite-essai",
    [string]$Enregistrer = ""               # fichier WAV du son émis par le téléphone (mesure du micro)
)
# Lance la station factice hors de la session SSH (survit à sa fermeture), journal dans $Dossier\station.log
$py = "C:\dev\openRemoteTRX-tests\.venv\Scripts\python.exe"
$script = "C:\dev\openRemoteTRX-lite-build\openRemoteTRX-lite\tools\station_factice.py"
New-Item -ItemType Directory -Force $Dossier | Out-Null
$extra = ""
if ($Enregistrer) { $extra = "--enregistrer `"$Enregistrer`"" }
$cmd = "cmd /c `"`"$py`" `"$script`" --dossier `"$Dossier`" --mot-de-passe $MotDePasse --ecoute $Ecoute $extra > `"$Dossier\station.log`" 2>&1`""
$r = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = $cmd; CurrentDirectory = $Dossier }
"pid $($r.ProcessId) code $($r.ReturnValue)"
Start-Sleep -Seconds 12
Get-Content "$Dossier\station.log" -Tail 15
netstat -an | Select-String ":18443 |:14532 "

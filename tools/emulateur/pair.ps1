# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
param([Parameter(Mandatory)][string]$Empreinte, [Parameter(Mandatory)][string]$MotDePasse)
# Premier lancement de Lite : avertissement, fiche de la station factice, mot de passe mémorisé, connexion
$adb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
foreach ($ime in (& $adb shell ime list -s)) { & $adb shell ime disable $ime.Trim() | Out-Null }   # pas de correction automatique
function Tap($x, $y) { & $adb shell input tap $x $y; Start-Sleep -Milliseconds 700 }
function Saisir($t) { & $adb shell input text $t; Start-Sleep -Milliseconds 400 }
& $adb shell am start -n com.rfdiy.openremotetrx.lite/com.rfdiy.openremotetrx.app.MainActivity | Out-Null
Start-Sleep 5
Tap 775 1188                                   # « I understand »
Tap 540 390; Saisir "Factice"
Tap 540 530; Saisir "10.0.2.2:18443"
Tap 540 665; Saisir "lite"
Tap 540 803; Saisir $MotDePasse
Tap 330 1192                                   # empreinte et reconnexion
Tap 540 1340
for ($i = 0; $i -lt $Empreinte.Length; $i += 24) { Saisir $Empreinte.Substring($i, [math]::Min(24, $Empreinte.Length - $i)); Start-Sleep -Milliseconds 500 }
Tap 85 918                                     # mémoriser le mot de passe
Tap 160 1045                                   # Connecter
Start-Sleep 10
& $adb shell screencap -p /sdcard/s.png
& $adb pull /sdcard/s.png C:\dev\lite-essai\pair.png | Out-Null
& $adb logcat -d -b crash

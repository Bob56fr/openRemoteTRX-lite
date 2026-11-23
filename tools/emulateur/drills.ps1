# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
# Essais de panne d'openRemoteTRX Lite contre la station factice (état lu dans le fichier d'état de la station)
$adb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
$pkg = "com.rf_diy.openremotetrx_lite"
function P { Get-Content C:\dev\lite-essai\etat\status.json -Raw | ConvertFrom-Json | ForEach-Object { $_.ptt } }
function Tap($x, $y) { & $adb shell input tap $x $y; Start-Sleep -Milliseconds 600 }
function WaitRx($label) {
    $t = Get-Date
    do { Start-Sleep -Milliseconds 100; $p = P } while ($p.state -eq "TX" -and ((Get-Date) - $t).TotalSeconds -lt 15)
    "   $label : $($p.state) en $([math]::Round(((Get-Date) - $t).TotalSeconds, 1)) s (cause : $($p.last_cut_reason))"
}
function Open {
    & $adb shell am start -n "$pkg/com.rfdiy.openremotetrx.app.MainActivity" | Out-Null
    Start-Sleep 3; Tap 160 1192; Start-Sleep 8       # Connecter (mot de passe mémorisé)
}
function Transmit { Tap 110 1297; Tap 366 1545; Start-Sleep 2; "   émission : $((P).state) (propriétaire $((P).owner))" }

"Android $(& $adb shell getprop ro.build.version.release)"
"1. STOP pendant l'émission"
Open; Transmit; Tap 875 1545; WaitRx "après STOP"
"2. Application tuée pendant l'émission"
Start-Sleep 4; Tap 366 1545; Start-Sleep 2; "   émission : $((P).state) (propriétaire $((P).owner))"; & $adb shell am force-stop $pkg; WaitRx "après l'arrêt forcé"
"3. Réseau coupé pendant l'émission (Wi-Fi et données)"
Open; Transmit; & $adb shell svc wifi disable; & $adb shell svc data disable; WaitRx "après la coupure"
& $adb shell svc wifi enable; & $adb shell svc data enable
& $adb shell am force-stop $pkg

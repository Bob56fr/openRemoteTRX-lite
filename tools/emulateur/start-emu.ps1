# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
param([string]$Avd = "lite81")
# Émulateur sans fenêtre, hors de la session SSH ; attend la fin du démarrage puis installe Lite
$sdk = Join-Path $env:LOCALAPPDATA "Android\Sdk"
$emu = Join-Path $sdk "emulator\emulator.exe"
$adb = Join-Path $sdk "platform-tools\adb.exe"
$cmd = "`"$emu`" -avd $Avd -no-window -no-snapshot -no-boot-anim -gpu swiftshader_indirect -no-audio"
$r = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = $cmd }
"emulateur pid $($r.ProcessId)"
& $adb wait-for-device
$t0 = Get-Date
while ((& $adb shell getprop sys.boot_completed 2>$null) -notmatch "1") {
    if (((Get-Date) - $t0).TotalSeconds -gt 300) { "démarrage trop long"; exit 1 }
    Start-Sleep -Seconds 3
}
"démarré en $([int]((Get-Date) - $t0).TotalSeconds) s, Android $(& $adb shell getprop ro.build.version.release)"
& $adb install -r -g "C:\dev\openRemoteTRX-lite-build\openRemoteTRX-lite\app\build\outputs\apk\debug\app-debug.apk"

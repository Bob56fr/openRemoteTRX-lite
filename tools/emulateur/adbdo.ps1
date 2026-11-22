# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
param([string]$Steps, [string]$Shot = "s")
# Suite d'actions adb séparées par « | » : tap x y, text ..., key N, wait s, back ; puis capture d'écran $Shot.png
$adb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
foreach ($step in $Steps.Split("|")) {
    $p = $step.Trim().Split(" ", 2)
    switch ($p[0]) {
        "tap"  { & $adb shell input tap $p[1].Split(" ")[0] $p[1].Split(" ")[1] }
        "text" { & $adb shell input text $p[1] }
        "key"  { & $adb shell input keyevent $p[1] }
        "wait" { Start-Sleep -Milliseconds ([int]([double]$p[1] * 1000)) }
        "swipe" { $c = $p[1].Split(" "); & $adb shell input swipe $c[0] $c[1] $c[2] $c[3] 300 }
        "sh"   { & $adb shell $p[1] }
    }
    Start-Sleep -Milliseconds 400
}
& $adb shell screencap -p /sdcard/s.png
& $adb pull /sdcard/s.png "C:\dev\lite-essai\$Shot.png" | Out-Null

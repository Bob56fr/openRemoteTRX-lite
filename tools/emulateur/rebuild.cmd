@echo off
rem SPDX-License-Identifier: AGPL-3.0-or-later
rem Copyright (C) 2026 RF-DIY.COM
rem Recompile Lite (APK seul) puis réinstalle dans l'émulateur en marche
cd /d C:\dev\openRemoteTRX-lite-build\openRemoteTRX-lite
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
call gradlew.bat --no-daemon -q assembleDebug > rebuild.log 2>&1
if errorlevel 1 (type rebuild.log & exit /b 1)
"%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" install -r -g app\build\outputs\apk\debug\app-debug.apk

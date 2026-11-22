@echo off
rem SPDX-License-Identifier: AGPL-3.0-or-later
rem Copyright (C) 2026 RF-DIY.COM
rem Compilation d'openRemoteTRX Lite sur tour radio (priorité basse)
cd /d C:\dev\openRemoteTRX-lite-build\openRemoteTRX-lite
> local.properties echo sdk.dir=C\:\\Users\\chris\\AppData\\Local\\Android\\Sdk
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
call gradlew.bat --no-daemon test assembleDebug lintDebug --continue > build.log 2>&1
echo CODE %ERRORLEVEL%

#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
# Essais de Lite sur le Nexus 6P (Android 8.1) contre la station factice de tour radio (réseau local).
# Positions des boutons : écran 1440 x 2560 (Nexus 6P) ; adresse adb en Wi-Fi à adapter.
# Départ : Lite connectée et EN ÉMISSION (autorisation + PTT déjà faits).
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"; D="-s 192.168.1.69:5555"; PKG=com.rf_diy.openremotetrx_lite
t(){ "$A" $D shell input tap $1 $2; sleep 0.7; }
st(){ ssh -o LogLevel=ERROR chris@192.168.1.193 "powershell -NoProfile -ExecutionPolicy Bypass -File ptt.ps1" 2>/dev/null | tr -d '\r'; }
open(){ "$A" $D shell am start -n $PKG/com.rfdiy.openremotetrx.app.MainActivity >/dev/null; sleep 3; t 235 1584; sleep 10; }
mic(){ "$A" $D shell dumpsys media.audio_flinger | tr -d '\r' | awk '/Input thread/{f=1} f&&/Standby:/{print "   micro en veille :", $2; exit}'; }
waitrx(){ local t0=$(date +%s.%N) s; for i in $(seq 1 80); do s=$(st); [[ "$s" == RX* ]] && break; sleep 0.1; done; echo "   $1 : $s en $(python -c "import time;print(round(time.time()-$t0,1))") s"; }
echo "2. STOP"
t 1165 2061; waitrx "après STOP"; sleep 1; mic
echo "3. Application tuée pendant l'émission"
sleep 4; t 488 2061; sleep 3; echo "   station : $(st)"; "$A" $D shell am force-stop $PKG; waitrx "après l'arrêt forcé"
echo "4. Wi-Fi du téléphone coupé pendant l'émission (coupure programmée DANS le téléphone, 15 s)"
open; t 128 1733; t 488 2061; sleep 3; echo "   station : $(st)"
"$A" $D shell "nohup sh -c 'svc wifi disable; sleep 15; svc wifi enable' >/dev/null 2>&1 &"
waitrx "après la coupure du Wi-Fi"
sleep 30; "$A" disconnect >/dev/null; "$A" connect 192.168.1.69:5555 >/dev/null; echo "   adb revenu : $("$A" $D shell echo ok | tr -d '\r')"

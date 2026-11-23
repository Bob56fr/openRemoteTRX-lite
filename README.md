# openRemoteTRX Lite

Android client for an [openRemoteTRX](https://github.com/Bob56fr/openRemoteTRX) station, for phones running
**Android 8.0, 8.1 and 9** (the main app needs Android 10 or newer). Same station, same transmit safety; features
that these Android versions cannot support (Android Auto, phone radio details…) are removed.

Client Android d'une station [openRemoteTRX](https://github.com/Bob56fr/openRemoteTRX) pour les téléphones sous
**Android 8.0, 8.1 et 9** (l'application principale exige Android 10 ou plus récent). Même station, même sécurité
d'émission ; les fonctions que ces versions d'Android ne permettent pas (Android Auto, détail radio du téléphone…)
sont retirées. Cahier des charges : [`docs/android8-cahier-des-charges.md`](https://github.com/Bob56fr/openRemoteTRX/blob/main/docs/android8-cahier-des-charges.md).

## Structure

| Module | Origine | Android ? |
|---|---|---|
| `:protocol` | `upstream/android/protocol` (sous-module, dépôt principal) | non (Kotlin/JVM) |
| `:logic` | `upstream/android/logic` (sous-module, dépôt principal) : RigSession, battements, refus, textes | non (Kotlin/JVM) |
| `:core` | ce dépôt : service, WebRTC, son, Bluetooth | oui, `minSdk 26` |
| `:app` | ce dépôt : écrans Compose | oui, `minSdk 26` |

Identifiant : `com.rf_diy.openremotetrx_lite` (ne jamais le changer).

## Construire

```
git clone --recurse-submodules https://github.com/Bob56fr/openRemoteTRX-lite.git
cd openRemoteTRX-lite
gradlew.bat test assembleDebug        # JAVA_HOME = jbr d'Android Studio
```

Mettre à jour le code partagé : `git -C upstream pull origin main`, puis `gradlew.bat test` et commit du sous-module.

## Licence

AGPL-3.0-or-later (fichier `LICENSE`). Copyright (C) 2026 RF-DIY.COM.

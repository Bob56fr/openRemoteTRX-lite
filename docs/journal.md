# Journal d'openRemoteTRX Lite

1. [fait ; APK compilé ; version 0.1.0] 2026-11-22, PROJET MONTÉ (étape 365 du dépôt principal). `:core` et `:app`
   copiés de l'application principale 0.90.0 avec leur historique (`git subtree split --prefix=android`), `:protocol`
   et `:logic` pris dans le sous-module `upstream/` (chemins Gradle relatifs au module, changement neutre fait dans le
   dépôt principal), `com.rfdiy.openremotetrx.lite`, `minSdk 26`, nom « openRemoteTRX Lite ». Lint `minSdk 26` :
   16 erreurs dans `:core` (NetRadio, RigMedia), 12 dans `:app` (SelcallPanel, StationScreen, plus deux erreurs sans
   rapport avec la version, aussi présentes dans l'application principale) : liste au § 4 du cahier.
2. [fait ; tests et lint sans erreur, compilé sur tour radio ; version 0.2.0, versionCode 2] 2026-11-22, LOT 1
   (cahier § 4, § 5, § 7). SUPPRIMÉS : Android Auto (`RigAutoService`, `automotive_app_desc.xml`, icônes `ic_car_*`,
   actions de voiture, recherche vocale et navigation de la session média, `currentControllerInfo` ; la session média
   reste pour les touches du casque et du volant Bluetooth), mode conduite automatique (réglage retiré : manuel
   seulement), radio du téléphone (`NetRadio` : type de réseau et bascule seulement ; option « antenne-relais » et
   autorisation de localisation retirées), « Enregistrer dans Images » de la mesure de TOS (partage gardé), export
   SELCALL dans Téléchargements. GARDÉ avec une autre méthode : QR code lu dans une image (`BitmapFactory` avec
   `inSampleSize` au lieu d'`ImageDecoder`). AJOUTÉ : `LiteWarning.kt`, avertissement « téléphone sans mises à jour de
   sécurité » au premier lancement (textes `litewarning.*` du catalogue commun, étape 366 du dépôt principal). Défauts
   allégés : petit waterfall de l'onglet Station et spectre HF de la tablette éteints (égaliseur et effets déjà masqués
   par défaut). Lint : les deux erreurs sans rapport avec la version corrigées (`LocalActivity`, `collectAsState`) ;
   elles restent dans l'application principale. Sous-module `upstream` sur b4e13193.
3. [fait ; essais sur émulateurs Android 8.1 et 9 RÉUSSIS ; version 0.2.1, versionCode 3] 2026-11-22, LOT 2 (émulateurs).
   Sur tour radio : outils du SDK en ligne de commande, images `system-images/android-27/google_apis/x86` et
   `android-28/google_apis/x86_64` (le nouvel outil écrit les noms avec « / »), émulateurs `lite81` et `lite9` (WHPX).
   Station factice `tools/station_factice.py` : vraie passerelle du sous-module, faux rigctld, son `tone:600`, sortie
   `null` (aucune carte son), ports 18443 / 14532 / 47910 (jamais ceux d'une station installée). DÉFAUT TROUVÉ ET
   CORRIGÉ : plantage du service à la connexion sur Android 8.1 (`WIFI_MODE_FULL_LOW_LATENCY` = API 29, constante non vue
   par le lint) : `WIFI_MODE_FULL_HIGH_PERF` avant Android 10. RÉSULTATS (Android 8.1 puis 9) : avertissement au premier
   lancement, appairage par la fiche, connexion, afficheur, émission (« TRANSMITTING » et compte à rebours du TOT),
   STOP = réception en 0,1 s, application tuée pendant l'émission = réception en 1,9 / 2,2 s (battements), Wi-Fi et
   données coupés pendant l'émission = réception en 2,2 / 2,1 s (battements). NON essayé : son reçu et micro (émulateur
   sans audio), casque Bluetooth, écran éteint, spectre. Scripts : `tools/emulateur/` (`start-station.ps1`,
   `start-emu.ps1`, `pair.ps1`, `drills.ps1`, `adbdo.ps1`, `build-lite.cmd`, `rebuild.cmd`). Pièges : désactiver les claviers
   de l'émulateur (`ime disable`, sinon « F7 » devient « For »), « Type » est un alias de PowerShell, attendre 4 s entre
   STOP et une nouvelle prise (délai de la station).

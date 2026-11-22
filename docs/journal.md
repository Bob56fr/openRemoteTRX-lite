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

# Journal d'openRemoteTRX Lite

1. [fait ; APK compilé ; version 0.1.0] 2026-11-22, PROJET MONTÉ (étape 365 du dépôt principal). `:core` et `:app`
   copiés de l'application principale 0.90.0 avec leur historique (`git subtree split --prefix=android`), `:protocol`
   et `:logic` pris dans le sous-module `upstream/` (chemins Gradle relatifs au module, changement neutre fait dans le
   dépôt principal), `com.rfdiy.openremotetrx.lite`, `minSdk 26`, nom « openRemoteTRX Lite ». Lint `minSdk 26` :
   16 erreurs dans `:core` (NetRadio, RigMedia), 12 dans `:app` (SelcallPanel, StationScreen, plus deux erreurs sans
   rapport avec la version, aussi présentes dans l'application principale) : liste au § 4 du cahier.

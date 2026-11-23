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
4. [fait ; essais sur un VRAI téléphone Android 8.1 RÉUSSIS ; version 0.2.1] 2026-11-23, PREMIER TÉLÉPHONE RÉEL : Nexus 6P
   (angler) de l'utilisateur, rooté et sans système : bootloader déverrouillé, image d'usine Google 8.1.0
   OPM7.181205.001 (dernière du 6P, SHA-256 b75ce068…, téléchargée chez Google) écrite par `fastboot -w update` (système
   seul : bootloader 03.84 et modem 03.88 déjà à jour) ; démarrages en boucle = ALIMENTATION insuffisante (pas le défaut
   des gros cœurs : le contournement à 4 cœurs préparé n'a pas servi) ; adb par le Wi-Fi après un branchement USB
   (`adb tcpip 5555`). Station factice sur le RÉSEAU LOCAL de tour radio (`--ecoute 192.168.1.193`, certificat à cette
   adresse, règle de pare-feu TEMPORAIRE `tools/emulateur/pare-feu.ps1`, retirée ensuite). RÉSULTATS : appairage par la
   fiche (clavier du téléphone coupé le temps de la saisie, remis ensuite), connexion en Wi-Fi (19 à 37 ms), SON REÇU
   joué (lecteur audio actif, sortie hors veille), émission avec MICRO OUVERT (entrée audio active), STOP = réception,
   application tuée pendant l'émission = réception en ~2 s (battements), Wi-Fi du téléphone coupé pendant l'émission =
   réception en ~2 s puis RECONNEXION SEULE EN RÉCEPTION (autorisation d'émettre remise à zéro, cause « perte du signal de
   vie du client » affichée), ÉCRAN ÉTEINT 3 min (veille « Dozing ») : son toujours joué, service vivant, liaison
   entretenue. Temps mesurés à ~0,5 s près (lecture de l'état par SSH). RESTENT : écoute 30 min écran éteint, casque
   Bluetooth, 10 émissions sur charge fictive avec minix-bzh et l'IC-7300MK2 (l'utilisateur devant le poste). Script :
   `tools/telephone/essais-nexus6p.sh`. Remarque : l'APK essayé affichait encore « 0.2.0 » (numéro non reporté sur tour
   radio ; même code que 0.2.1).

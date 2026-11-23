# openRemoteTRX Lite : application Android 8 et 9

Langue de travail : français. Réponses concises, avis honnêtes.

Client Android d'une station openRemoteTRX pour Android 8.0 à 9 (API 26 à 28). Projet SÉPARÉ du dépôt principal
`Bob56fr/openRemoteTRX` (`C:\dev\openRemoteTRX`), décidé par l'utilisateur le 2026-11-22. Cahier des charges :
`upstream/docs/android8-cahier-des-charges.md` (il vit dans le dépôt principal).

## Règles

- **Sécurité d'émission** : celles du `CLAUDE.md` du dépôt principal (`upstream/CLAUDE.md`, section « Règles de
  sécurité d'émission »), sans exception : PTT en toggle, état de la station seul affiché, battements, RX à la
  reconnexion, STOP toujours visible. Tout code qui touche au PTT a des tests de panne.
- **`:protocol` et `:logic` ne se modifient JAMAIS ici** : ils viennent du sous-module `upstream/`. Un changement se
  fait dans le dépôt principal (règles de son CLAUDE.md), puis `git -C upstream pull origin main`, `gradlew.bat test`
  et commit du sous-module ici. Ne jamais laisser le sous-module sur un commit non poussé.
- **Fonction non supportée par Android 8 / 9 = SUPPRIMÉE** (décision de l'utilisateur), jamais masquée ni simulée.
  Une fonction supportée avec une API plus ancienne est gardée avec cette API.
- `minSdk 26` : le lint (`gradlew.bat lintDebug`) ne doit avoir AUCUNE erreur `NewApi` ; attention aux constantes
  (ex. `MediaStore.MediaColumns.RELATIVE_PATH`, API 29) que le lint ne voit pas.
- **Textes** : aucun texte en dur ; clés du catalogue commun `upstream/android/logic/src/main/resources/i18n/app.<langue>.json`
  (4 langues), un texte propre à Lite s'y ajoute dans le dépôt principal.
- **Identifiant** `com.rfdiy.openremotetrx.lite` : ne jamais le changer. Version propre (`versionName` / `versionCode`
  de `app/build.gradle.kts`) : +1 à chaque livraison.
- Licence AGPL-3.0-or-later : en-tête SPDX en tête de tout nouveau fichier de code (voir le dépôt principal).
- Commit et push à la fin de chaque étape ; `git add` seulement des fichiers de l'étape. Journal des étapes :
  `docs/journal.md` (une entrée numérotée par étape, jamais supprimée).
- Tableau de pilotage : fiche `openremotetrx-lite` (voir le CLAUDE.md du dépôt principal pour l'outil et les règles).

## État actuel (0.2.1, étape 4)

Lots 0, 1 et 2 FAITS (journal). Lot 2 RÉUSSI sur émulateurs Android 8.1 / 9 ET sur un VRAI téléphone : Nexus 6P de
l'utilisateur sous Android 8.1 d'origine Google (son reçu, micro, STOP, application tuée, Wi-Fi coupé, écran éteint
3 min). SUIVANT : écoute 30 min écran éteint, casque Bluetooth, 10 émissions sur charge fictive avec minix-bzh et
l'IC-7300MK2 (utilisateur devant le poste) ; puis lot 3 (publication). Le Nexus 6P manque d'ALIMENTATION (redémarrages
en boucle sur un port USB faible) : bon chargeur ou hub USB alimenté. Comparaison des fonctions : § 4 bis du cahier.

## Essais sur émulateur (tour radio)

`tools/emulateur/` : `start-station.ps1 -MotDePasse …` (station factice, port 18443 ; empreinte dans
`C:\dev\lite-essai\station.log`), `start-emu.ps1 lite81` ou `lite9` (démarre et installe l'APK), `pair.ps1 -Empreinte …
-MotDePasse …` (premier lancement), `drills.ps1` (STOP, application tuée, réseau coupé ; état lu dans le fichier d'état
de la station). Constante d'Android plus récente qu'Android 8 : le lint ne la voit pas, l'émulateur oui.

## Construire

`gradlew.bat test assembleDebug lintDebug` avec JAVA_HOME = jbr d'Android Studio. Sur le PC « tour radio »
(`chris@192.168.1.193`, Android Studio et SDK API 37, demande de l'utilisateur : y compiler pour ne pas charger le PC de
travail) : archive tar sans `.git` ni `build` envoyée par scp dans `C:\dev\openRemoteTRX-lite-build`, `local.properties`
= `sdk.dir=C\:\\Users\\chris\\AppData\\Local\\Android\\Sdk`, `gradlew.bat --no-daemon` en priorité basse (33 s).

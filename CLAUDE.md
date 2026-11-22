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

## État actuel (0.1.0, étape 1)

Copie de l'application principale 0.90.0 (`:core`, `:app`, historique gardé), `minSdk 26`, APK compilé. Lot 1 À FAIRE
(cahier § 4) : supprimer Android Auto, détail radio du téléphone, enregistrements MediaStore (image de TOS, export
SELCALL), `currentControllerInfo` ; QR code dans une image par `BitmapFactory` ; défauts allégés (§ 5).

## Construire

`gradlew.bat test assembleDebug lintDebug` avec JAVA_HOME = jbr d'Android Studio. Le PC « tour radio » n'a ni SDK
Android ni Java (2026-11-22).

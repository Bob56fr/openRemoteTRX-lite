// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright (C) 2026 RF-DIY.COM
// Application Android openRemoteTRX : docs/android-cahier-des-charges.md
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "openRemoteTRX-Lite"
// Kotlin pur, testé sans émulateur : protocole (contrat avec la station) et logique (PTT, battements, liaison).
// :protocol et :logic sont ceux du dépôt principal (sous-module upstream/, figé sur un commit) : jamais copiés
include(":protocol", ":logic")
project(":protocol").projectDir = file("upstream/android/protocol")
project(":logic").projectDir = file("upstream/android/logic")
// Android : service, WebRTC, audio, comptes (:core) ; écrans (:app).
include(":core", ":app")

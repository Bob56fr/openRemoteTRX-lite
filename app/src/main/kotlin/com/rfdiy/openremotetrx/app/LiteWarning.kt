// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright (C) 2026 RF-DIY.COM
package com.rfdiy.openremotetrx.app

import android.content.Context
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.LocalContext
import com.rfdiy.openremotetrx.logic.Tr

/** Préférence : avertissement lu (une seule fois par installation). */
private const val PREF_LITE_WARNING = "lite_warning_ok"

/**
 * openRemoteTRX Lite (décision de l'utilisateur du 2026-11-22, cahier docs/android8-cahier-des-charges.md § 7) :
 * Android 8 et 9 ne reçoivent plus de mises à jour de sécurité, et le mot de passe du compte opérateur est enregistré
 * sur le téléphone. Montré au premier lancement, avant toute connexion ; seul le bouton le ferme.
 */
@Composable
fun LiteWarning() {
    val context = LocalContext.current
    val prefs = remember { context.getSharedPreferences("ui", Context.MODE_PRIVATE) }
    var shown by remember { mutableStateOf(!prefs.getBoolean(PREF_LITE_WARNING, false)) }
    if (!shown) return
    AlertDialog(
        onDismissRequest = {},
        title = { Text(Tr.t("litewarning.title")) },
        text = { Text(Tr.t("litewarning.text")) },
        confirmButton = {
            TextButton(onClick = {
                prefs.edit().putBoolean(PREF_LITE_WARNING, true).apply()
                shown = false
            }) { Text(Tr.t("litewarning.ok")) }
        },
    )
}

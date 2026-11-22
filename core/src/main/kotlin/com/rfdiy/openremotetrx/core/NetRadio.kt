// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright (C) 2026 RF-DIY.COM
package com.rfdiy.openremotetrx.core

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import com.rfdiy.openremotetrx.logic.RadioSample

/**
 * Réseau du téléphone pour la sonde réseau (EF11, docs/netprobe-cahier-des-charges.md § 13). openRemoteTRX Lite
 * (Android 8 / 9) : type de réseau (Wi-Fi, mobile, réseau local) et bascule de réseau SEULEMENT ; puissance 4G / 5G et
 * changement de cellule retirés (API 28 à 30, cahier docs/android8-cahier-des-charges.md § 4).
 * Appelé sur le fil de la session : `sample()` toutes les 2 s, `take()` à chaque résumé (remet les faits à zéro).
 */
class NetRadio(private val context: Context) {
    private val cm = context.getSystemService(ConnectivityManager::class.java)
    private var transport: String? = null
    private var network: String? = null
    private var netSwitched = false
    private var last = RadioSample()

    private fun transportOf(caps: NetworkCapabilities?): String? = when {
        caps == null -> null
        caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
        caps.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "mobile"
        caps.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> "lan"
        else -> null
    }

    /** Réseau réellement utilisé : derrière un VPN, le réseau sous-jacent (Wi-Fi d'abord, puis mobile). */
    @Suppress("DEPRECATION")
    private fun current(): Pair<String?, String?> {
        val cm = cm ?: return null to null
        val active = cm.activeNetwork ?: return null to null
        transportOf(cm.getNetworkCapabilities(active))?.let { return it to active.toString() }
        val under = cm.allNetworks.mapNotNull { n ->
            val caps = cm.getNetworkCapabilities(n) ?: return@mapNotNull null
            if (caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN) || !caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)) null
            else transportOf(caps)?.let { it to n.toString() }
        }
        return (under.firstOrNull { it.first == "wifi" } ?: under.firstOrNull()) ?: ("unknown" to active.toString())
    }

    fun sample() {
        val (kind, net) = try { current() } catch (e: Exception) { null to null }
        if (transport != null && kind != null && (kind != transport || net != network)) netSwitched = true
        if (kind != null) { transport = kind; network = net }
        val type = kind
        last = RadioSample(type, null, null, null, false, netSwitched)
    }

    /** Dernier relevé (affichage). */
    fun shown(): RadioSample = last.copy(netSwitched = false)

    /** Relevé pour un résumé : les faits survenus depuis le précédent, puis remis à zéro. */
    fun take(): RadioSample {
        val out = last
        netSwitched = false
        last = last.copy(netSwitched = false)
        return out
    }
}

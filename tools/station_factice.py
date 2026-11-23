# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 RF-DIY.COM
"""Station factice pour essayer openRemoteTRX Lite dans un émulateur (lot 2).

Vraie passerelle du dépôt principal (sous-module upstream/), poste FACTICE (faux rigctld, jamais un vrai poste), son de
synthèse (`tone:600`) et sortie nulle : aucune carte son n'est ouverte. Ports à part (18443, 14532, 47910) pour ne
jamais gêner une station installée sur la même machine. L'émulateur voit la machine en 10.0.2.2.

    python tools/station_factice.py --dossier C:\\dev\\lite-essai --mot-de-passe ...
"""
from __future__ import annotations

import argparse
import os
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
UPSTREAM = ROOT / "upstream"
sys.path.insert(0, str(UPSTREAM))

from trxstation import config as cfgmod  # noqa: E402
from trxstation.config import ClientAuth  # noqa: E402
from trxstation.gateway.api.tls import certificate_fingerprint, generate_self_signed  # noqa: E402
from trxstation.passwords import hash_password  # noqa: E402
from trxstation.setup_wizard import dummy_config  # noqa: E402

GATEWAY_PORT = 18443
RIGCTLD_PORT = 14532
BUS_PORT = 47910


def build(folder: Path, password: str, account: str, bind: str = "127.0.0.1", sink: str = "null") -> Path:
    folder.mkdir(parents=True, exist_ok=True)
    cert, key = folder / "station.crt", folder / "station.key"
    if not cert.exists():
        hosts = ["127.0.0.1", "10.0.2.2", "localhost"] + ([bind] if bind not in ("127.0.0.1", "0.0.0.0") else [])
        generate_self_signed(hosts, cert, key)
    cfg = dummy_config()
    cfg.network.rigctld_port = RIGCTLD_PORT
    cfg.network.gateway_port = GATEWAY_PORT
    cfg.network.gateway_bind = bind
    cfg.network.tls_cert, cfg.network.tls_key = str(cert), str(key)
    cfg.network.ice_servers = []
    cfg.audio.capture_device = "tone:600"
    cfg.audio.playback_device = sink
    cfg.supervisor.state_dir = str(folder / "etat")
    cfg.supervisor.status_path = str(folder / "etat" / "status.json")
    cfg.modules.bus_port = BUS_PORT
    cfg.clients = [ClientAuth(id=account, password_hash=hash_password(password))]
    problems = cfgmod.validate(cfg)
    if problems:
        raise SystemExit("station.toml refusée :\n  - " + "\n  - ".join(problems))
    path = folder / "station.toml"
    path.write_text(cfgmod.render_toml(cfg), encoding="utf-8")
    cfgmod.load(path)
    return path


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--dossier", type=Path, required=True)
    ap.add_argument("--mot-de-passe", required=True)
    ap.add_argument("--compte", default="lite")
    ap.add_argument("--ecoute", default="127.0.0.1",
                    help="adresse d'écoute : 127.0.0.1 (émulateur) ou l'adresse de la machine dans le réseau local (vrai téléphone)")
    ap.add_argument("--enregistrer", type=Path, default=None,
                    help="fichier WAV où écrire le son ÉMIS par le téléphone (au lieu de la sortie nulle) : mesure du micro")
    args = ap.parse_args()
    sink = f"file:{args.enregistrer}" if args.enregistrer else "null"
    toml = build(args.dossier, args.mot_de_passe, args.compte, args.ecoute, sink)
    where = "10.0.2.2 (depuis l'émulateur)" if args.ecoute == "127.0.0.1" else args.ecoute
    print(f"Station factice : https://{where}:{GATEWAY_PORT}, compte {args.compte}", flush=True)
    print(f"Empreinte : {certificate_fingerprint(args.dossier / 'station.crt')}", flush=True)
    env = dict(os.environ, PYTHONPATH=str(UPSTREAM))
    rig = subprocess.Popen([sys.executable, "-m", "trxstation.devtools.fake_rigctld", "--port", str(RIGCTLD_PORT)], env=env)
    time.sleep(1.0)
    try:
        return subprocess.call([sys.executable, "-m", "trxstation.gateway.main", "--config", str(toml)], env=env)
    finally:
        rig.terminate()


if __name__ == "__main__":
    sys.exit(main())

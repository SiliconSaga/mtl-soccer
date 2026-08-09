#!/usr/bin/env bash
# Regenerates qr-hockey.png. Offline; requires: python -m pip install --user segno
set -euo pipefail
cd "$(dirname "$0")"
# Prefer python3, fall back to python — but verify it actually runs
# (on Windows a "python3" Microsoft Store stub can shadow the real install).
PY=""
for cand in python3 python; do
  if "$cand" --version >/dev/null 2>&1; then PY="$cand"; break; fi
done
if [ -z "$PY" ]; then echo "ERROR: no working python3/python found" >&2; exit 1; fi
"$PY" -c "import segno; segno.make('https://mountaintopleague.com/hockey/', error='m').save('qr-hockey.png', scale=12, border=2, dark='#071F42', light='#FFFFFF')"
echo "wrote $(pwd)/qr-hockey.png"

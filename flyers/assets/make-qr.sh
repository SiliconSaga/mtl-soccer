#!/usr/bin/env bash
# Regenerates qr-hockey.png. Offline; requires: python -m pip install --user segno
set -euo pipefail
cd "$(dirname "$0")"
python -c "import segno; segno.make('https://mountaintopleague.com/hockey/', error='m').save('qr-hockey.png', scale=12, border=2, dark='#071F42', light='#FFFFFF')"
echo "wrote $(pwd)/qr-hockey.png"

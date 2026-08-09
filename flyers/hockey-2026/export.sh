#!/usr/bin/env bash
# Renders all flyer variants to exports/ as print PDF + email/social PNG.
# Requires Microsoft Edge or Google Chrome. Run from anywhere: bash export.sh
set -euo pipefail
cd "$(dirname "$0")"

# Set BROWSER to a Chromium-based browser executable to override discovery.
BROWSER="${BROWSER:-}"
if [ -z "$BROWSER" ]; then
  for c in "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
           "/c/Program Files/Microsoft/Edge/Application/msedge.exe" \
           "/c/Program Files/Google/Chrome/Application/chrome.exe" \
           "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
           "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
           "/Applications/Chromium.app/Contents/MacOS/Chromium"; do
    if [ -x "$c" ]; then BROWSER="$c"; break; fi
  done
fi
if [ -z "$BROWSER" ]; then
  for cmd in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge msedge; do
    if command -v "$cmd" >/dev/null 2>&1; then BROWSER="$(command -v "$cmd")"; break; fi
  done
fi
if [ -z "$BROWSER" ]; then echo "ERROR: no Edge/Chrome found (set BROWSER to your browser executable)" >&2; exit 1; fi

HERE="$(cygpath -m "$(pwd)" 2>/dev/null || pwd)"
mkdir -p exports

render() { # html width height scale outbase want_pdf
  local html=$1 w=$2 h=$3 scale=$4 out=$5 want_pdf=$6
  "$BROWSER" --headless=new --disable-gpu --hide-scrollbars \
    --window-size="$w,$h" --force-device-scale-factor="$scale" \
    --screenshot="$HERE/exports/$out.png" "file:///$HERE/$html"
  if [ "$want_pdf" = "yes" ]; then
    "$BROWSER" --headless=new --disable-gpu --no-pdf-header-footer \
      --print-to-pdf="$HERE/exports/$out.pdf" "file:///$HERE/$html"
  fi
  echo "exported $out"
}

render index.html         816 1056 2 mtl-hockey-2026               yes
render middle-school.html 816 1056 2 mtl-hockey-2026-middle-school yes
render instagram.html    1080 1350 1 mtl-hockey-2026-instagram     no
echo "done: $(ls exports)"

#!/usr/bin/env bash
# Renders all flyer variants to exports/ as print PDF + email/social PNG.
# Requires Microsoft Edge or Google Chrome. Run from anywhere: bash export.sh
set -euo pipefail
cd "$(dirname "$0")"

BROWSER=""
for c in "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
         "/c/Program Files/Microsoft/Edge/Application/msedge.exe" \
         "/c/Program Files/Google/Chrome/Application/chrome.exe"; do
  if [ -x "$c" ]; then BROWSER="$c"; break; fi
done
if [ -z "$BROWSER" ]; then echo "ERROR: no Edge/Chrome found" >&2; exit 1; fi

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

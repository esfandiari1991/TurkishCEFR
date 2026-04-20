#!/usr/bin/env bash
# Build a lightweight drag-to-/Applications .dmg from a built .app.
# Usage: scripts/build_dmg.sh <path-to-TurkishCEFR.app> <output-dmg>
#
# No terminal commands for the end user — they double-click the .dmg,
# drag the icon onto /Applications, eject, done. Ad-hoc signed so the
# standard "Open Anyway" flow in System Settings → Privacy & Security
# works on any Mac without requiring the user to touch Terminal.
set -euo pipefail

APP_PATH=${1:?"Usage: $0 <path-to-TurkishCEFR.app> <output-dmg>"}
OUT_DMG=${2:?"Usage: $0 <path-to-TurkishCEFR.app> <output-dmg>"}

if [[ ! -d "$APP_PATH" ]]; then
  echo "::error::App bundle not found at $APP_PATH" >&2
  exit 1
fi

WORK=$(mktemp -d)
STAGING="$WORK/stage"
mkdir -p "$STAGING"

# Copy the app into the staging dir and add an alias to /Applications
# so the classic drag-to-install experience works without extra clicks.
ditto "$APP_PATH" "$STAGING/TurkishCEFR.app"
ln -s /Applications "$STAGING/ Applications"

# create-dmg is nicer-looking but not installed by default on every
# runner; we fall back to plain `hdiutil` which produces a clean,
# compressed DMG that any Mac can mount.
if command -v create-dmg >/dev/null 2>&1; then
  create-dmg \
    --volname "TurkishCEFR" \
    --window-size 560 380 \
    --icon-size 96 \
    --icon "TurkishCEFR.app" 150 200 \
    --app-drop-link 410 200 \
    --no-internet-enable \
    "$OUT_DMG" \
    "$STAGING" || true
fi

if [[ ! -f "$OUT_DMG" ]]; then
  TMP_DMG="$WORK/tmp.dmg"
  hdiutil create -volname "TurkishCEFR" -srcfolder "$STAGING" -ov -format UDRW "$TMP_DMG"
  hdiutil convert "$TMP_DMG" -format UDZO -imagekey zlib-level=9 -o "$OUT_DMG"
fi

# Ad-hoc sign the DMG so macOS treats it as coming from a known (if
# unverified) origin — users still see the first-run dialog but don't
# hit the harsher "cannot be opened at all" path.
codesign --force --sign - "$OUT_DMG" || true

echo "Built: $OUT_DMG ($(du -h "$OUT_DMG" | cut -f1))"

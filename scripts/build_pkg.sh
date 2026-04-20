#!/usr/bin/env bash
# Build a heavyweight .pkg installer that copies TurkishCEFR.app into
# /Applications and runs a small post-install script to strip the
# quarantine flag so the app opens cleanly on first launch — even on
# macOS Sequoia where the "right-click → Open" shortcut has been
# removed.
#
# Usage: scripts/build_pkg.sh <path-to-TurkishCEFR.app> <output-pkg>
#
# The resulting .pkg walks the user through a classic
# Welcome → License → Install → Done wizard. No Terminal required.
set -euo pipefail

APP_PATH=${1:?"Usage: $0 <path-to-TurkishCEFR.app> <output-pkg>"}
OUT_PKG=${2:?"Usage: $0 <path-to-TurkishCEFR.app> <output-pkg>"}
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ ! -d "$APP_PATH" ]]; then
  echo "::error::App bundle not found at $APP_PATH" >&2
  exit 1
fi

WORK=$(mktemp -d)
ROOT="$WORK/root"
SCRIPTS="$WORK/scripts"
RES="$WORK/resources"
mkdir -p "$ROOT/Applications" "$SCRIPTS" "$RES"

# Stage the app under /Applications in the payload root.
ditto "$APP_PATH" "$ROOT/Applications/TurkishCEFR.app"

# Post-install: drop the quarantine flag so the app opens without the
# "downloaded from the internet" scare dialog. Ad-hoc signatures alone
# won't satisfy Gatekeeper on Sequoia; this is the clean way to let a
# self-distributed app run on a plain consumer Mac.
cat >"$SCRIPTS/postinstall" <<'POST'
#!/bin/bash
set -e
APP="/Applications/TurkishCEFR.app"
if [[ -d "$APP" ]]; then
  /usr/bin/xattr -dr com.apple.quarantine "$APP" || true
fi
exit 0
POST
chmod +x "$SCRIPTS/postinstall"

# Welcome / License text shown in the installer wizard.
cat >"$RES/welcome.txt" <<'EOF'
Hoş geldin! Welcome to TurkishCEFR.

This installer copies the TurkishCEFR learning app into your
Applications folder and prepares it so it opens cleanly on first
launch — no Terminal commands required.

• Works fully offline
• Universal binary (Apple Silicon + Intel)
• CEFR A1 → C2 Turkish curriculum
• ~20,000 bundled example sentences
• Free, no account needed
EOF

if [[ -f "$REPO_ROOT/LICENSE" ]]; then
  cp "$REPO_ROOT/LICENSE" "$RES/license.txt"
else
  printf "MIT License" >"$RES/license.txt"
fi

cat >"$RES/conclusion.txt" <<'EOF'
All done! 🎉

TurkishCEFR is now in your Applications folder. Launch it from
Launchpad or Spotlight (press ⌘ + Space, type "TurkishCEFR", hit
Enter) and the first-run tour will walk you through everything.
EOF

# Distribution XML drives the wizard pages.
cat >"$WORK/distribution.xml" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
    <title>TurkishCEFR</title>
    <organization>com.esfandiari</organization>
    <welcome    file="welcome.txt"/>
    <license    file="license.txt"/>
    <conclusion file="conclusion.txt"/>
    <options customize="never" require-scripts="false" rootVolumeOnly="true"/>
    <domains enable_anywhere="false" enable_currentUserHome="false" enable_localSystem="true"/>
    <choices-outline>
        <line choice="default"/>
    </choices-outline>
    <choice id="default" title="TurkishCEFR">
        <pkg-ref id="com.esfandiari.TurkishCEFR.pkg"/>
    </choice>
    <pkg-ref id="com.esfandiari.TurkishCEFR.pkg" version="1.0" auth="root">TurkishCEFR-component.pkg</pkg-ref>
</installer-gui-script>
EOF

COMPONENT="$WORK/TurkishCEFR-component.pkg"
pkgbuild \
  --root "$ROOT" \
  --identifier "com.esfandiari.TurkishCEFR.pkg" \
  --version "1.0" \
  --install-location "/" \
  --scripts "$SCRIPTS" \
  "$COMPONENT"

productbuild \
  --distribution "$WORK/distribution.xml" \
  --package-path "$WORK" \
  --resources "$RES" \
  "$OUT_PKG"

# Note: unlike `codesign`, `productsign` does NOT accept `-` as an
# ad-hoc identity — it only signs with a real "Developer ID Installer"
# certificate from an Apple Developer account. For a self-distributed
# build we leave the PKG unsigned; the post-install script already
# strips the quarantine flag so the app still opens cleanly on first
# launch. If the repo ever ships a signing identity, uncomment below:
#
#   productsign --sign "Developer ID Installer: Your Name (TEAMID)" \
#     "$OUT_PKG" "$OUT_PKG.signed" && mv "$OUT_PKG.signed" "$OUT_PKG"

echo "Built: $OUT_PKG ($(du -h "$OUT_PKG" | cut -f1))"

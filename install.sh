#!/bin/bash
# Quick FX — one-line installer / updater for Adobe Premiere Pro (macOS).
#   install or update:  curl -fsSL https://raw.githubusercontent.com/gogamelia04/quickfx/main/install.sh | bash
#   remove:             curl -fsSL https://raw.githubusercontent.com/gogamelia04/quickfx/main/install.sh | bash -s -- uninstall
REPO="gogamelia04/quickfx"
BRANCH="main"
ZIP_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/quickfx-plugin.zip"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "  ✗ Quick FX-ის ეს ინსტალერი მხოლოდ Mac-ისთვისაა."
  exit 1
fi

TMP="$(mktemp -d)" || { echo "  ✗ დროებითი საქაღალდე ვერ შეიქმნა"; exit 1; }
trap 'rm -rf "$TMP"' EXIT

echo ""
echo "  Quick FX იწერება…"
if ! curl -fsSL --max-time 120 -o "$TMP/quickfx.zip" "$ZIP_URL"; then
  echo "  ✗ ჩამოტვირთვა ვერ მოხერხდა. ინტერნეტი შეამოწმე და თავიდან სცადე."
  exit 1
fi
if ! unzip -oq "$TMP/quickfx.zip" -d "$TMP/x"; then
  echo "  ✗ ჩამოტვირთული ფაილი დაზიანებულია. თავიდან სცადე."
  exit 1
fi

SCRIPT="install.command"
[ "$1" = "uninstall" ] && SCRIPT="uninstall.command"
TARGET="$(find "$TMP/x" -maxdepth 2 -name "$SCRIPT" | head -1)"
if [ -z "$TARGET" ]; then
  echo "  ✗ ინსტალერი არქივში ვერ მოიძებნა."
  exit 1
fi

bash "$TARGET"

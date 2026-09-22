#!/usr/bin/env bash
# Deploy the add-on in this repo into a local XenForo install and install or
# upgrade it there. For local end-to-end testing; see
# docs/guides/LOCAL_E2E_TESTING.md.
#
#   ./scripts/xf_dev_sync.sh /path/to/xenforo            # sync + install/upgrade
#   DRY_RUN=1 ./scripts/xf_dev_sync.sh /path/to/xenforo  # show what would change
#   PHP_BIN=/opt/homebrew/opt/php@8.2/bin/php ./scripts/xf_dev_sync.sh ...   # XF 2.2 needs PHP <= 8.2
#
# What it copies (mirrors the release ZIP layout under plugins/FC_XenForo2/upload):
#   src/addons/ForumCopilot/   -> $XF_ROOT/src/addons/ForumCopilot/   (mirror; keeps _releases/_output)
#   js/ForumCopilot/           -> $XF_ROOT/js/ForumCopilot/            (smart-banner assets)
#   src/addons/ForumCopilot/webroot_files/forumcopilot.php -> $XF_ROOT/forumcopilot.php
set -euo pipefail

XF_ROOT="${1:-${XF_ROOT:-}}"
PHP_BIN="${PHP_BIN:-php}"
DRY_RUN="${DRY_RUN:-0}"
ADDON_ID="ForumCopilot"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_ROOT/plugins/FC_XenForo2/upload"

if [[ -z "$XF_ROOT" || ! -f "$XF_ROOT/cmd.php" || ! -d "$XF_ROOT/src/addons" ]]; then
  echo "usage: $0 /path/to/xenforo   (a directory containing cmd.php and src/addons)" >&2
  exit 1
fi
if [[ ! -f "$SRC/src/addons/$ADDON_ID/addon.json" ]]; then
  echo "add-on source not found under $SRC" >&2
  exit 1
fi

VERSION=$(sed -n 's/.*"version_string": *"\([^"]*\)".*/\1/p' "$SRC/src/addons/$ADDON_ID/addon.json")
echo "Deploying $ADDON_ID $VERSION from $SRC"
echo "      into $XF_ROOT (php: $($PHP_BIN -r 'echo PHP_VERSION;'))"

RSYNC=(rsync -a --delete --exclude .DS_Store --exclude _releases --exclude _output)
if [[ "$DRY_RUN" == "1" ]]; then
  RSYNC+=(--dry-run --itemize-changes)
  echo "DRY RUN: nothing will be written"
fi

"${RSYNC[@]}" "$SRC/src/addons/$ADDON_ID/" "$XF_ROOT/src/addons/$ADDON_ID/"
mkdir -p "$XF_ROOT/js"
"${RSYNC[@]}" "$SRC/js/$ADDON_ID/" "$XF_ROOT/js/$ADDON_ID/"

ENTRY="$SRC/src/addons/$ADDON_ID/webroot_files/forumcopilot.php"
if [[ "$DRY_RUN" == "1" ]]; then
  if ! cmp -s "$ENTRY" "$XF_ROOT/forumcopilot.php" 2>/dev/null; then
    echo "would update $XF_ROOT/forumcopilot.php"
  fi
  exit 0
fi
cp "$ENTRY" "$XF_ROOT/forumcopilot.php"

cd "$XF_ROOT"
# What XenForo thinks is installed (version_id, or empty when not installed).
INSTALLED_ID=$("$PHP_BIN" -r 'require "src/XF.php"; XF::start(__DIR__); echo (string) XF::db()->fetchOne("SELECT version_id FROM xf_addon WHERE addon_id = ?", $argv[1]);' "$ADDON_ID" 2>/dev/null || true)
NEW_ID=$(sed -n 's/.*"version_id": *\([0-9]*\).*/\1/p' "src/addons/$ADDON_ID/addon.json")

if [[ -z "$INSTALLED_ID" ]]; then
  echo "Not installed here yet; installing $VERSION"
  "$PHP_BIN" cmd.php xf-addon:install "$ADDON_ID" -n
elif [[ "$INSTALLED_ID" == "$NEW_ID" ]]; then
  echo "Already at $VERSION ($NEW_ID); re-importing add-on data (xf-addon:rebuild)"
  "$PHP_BIN" cmd.php xf-addon:rebuild "$ADDON_ID" -n
else
  echo "Installed version_id $INSTALLED_ID -> $NEW_ID; upgrading"
  "$PHP_BIN" cmd.php xf-addon:upgrade "$ADDON_ID" -n
fi

BOARD=$("$PHP_BIN" -r 'require "src/XF.php"; XF::start(__DIR__); echo XF::options()->boardUrl;' 2>/dev/null || true)
echo "Done. Check: curl -s -X POST -H 'Content-Type: application/json' -d '{\"method\":\"getConfig\"}' '${BOARD:-http://127.0.0.1:8091}/forumcopilot.php' | head -c 300"

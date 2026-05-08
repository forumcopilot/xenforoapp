#!/bin/bash
# Build ForumCopilot release zip and inject public web assets at upload/js/.
#
# Why: XF's xf-addon:build-release only packs the addon directory. Public
# assets that need to land in the forum's webroot (under /js/ForumCopilot/)
# must:
#   1. Live at upload/js/ForumCopilot/ inside the release zip so XF's
#      zip-upload extractor places them correctly.
#   2. Be listed in src/addons/ForumCopilot/hashes.json with their SHA-256
#      digest, otherwise XF's installer skips them (it only copies files
#      whose hash entry differs from what's currently on disk).
#
# This wrapper runs xf-addon:build-release and then injects both.
set -euo pipefail

XF_ROOT="/Volumes/CRUCIAL/qhtt/xenforoweb"
ADDON_ID="ForumCopilot"
ASSETS_SRC="$XF_ROOT/js/ForumCopilot"

cd "$XF_ROOT"
php cmd.php xf-addon:build-release "$ADDON_ID"

RELEASE_DIR="src/addons/$ADDON_ID/_releases"
ZIP=$(ls -t "$XF_ROOT/$RELEASE_DIR"/${ADDON_ID}-*.zip 2>/dev/null | head -1)
if [[ -z "$ZIP" ]]; then
  echo "Could not find built release zip in $RELEASE_DIR" >&2
  exit 1
fi
echo "Injecting webroot assets into $ZIP"

STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/upload/js/ForumCopilot"
cp "$ASSETS_SRC"/smartbanner.js \
   "$ASSETS_SRC"/smartbanner.css \
   "$ASSETS_SRC"/smartbanner-icon.png \
   "$STAGE/upload/js/ForumCopilot/"
(cd "$STAGE" && zip -ur "$ZIP" upload/js)

# Patch hashes.json so XF's installer treats these as new files. Without this,
# the installer compares each file's hash against what's already on disk and
# silently skips anything not listed in hashes.json — so freshly-extracted
# assets in upload/ never make it to the webroot.
echo "Patching hashes.json with SHA-256 of injected assets..."
HASH_PATH="upload/src/addons/$ADDON_ID/hashes.json"
HASH_FILE="$STAGE/$HASH_PATH"
mkdir -p "$(dirname "$HASH_FILE")"
unzip -p "$ZIP" "$HASH_PATH" > "$HASH_FILE"

python3 - "$HASH_FILE" "$ASSETS_SRC" <<'PY'
import hashlib, json, os, sys

hashes_path, assets_src = sys.argv[1], sys.argv[2]
with open(hashes_path) as f:
    hashes = json.load(f)

for name in ("smartbanner.js", "smartbanner.css", "smartbanner-icon.png"):
    path = os.path.join(assets_src, name)
    with open(path, "rb") as f:
        digest = hashlib.sha256(f.read()).hexdigest()
    key = f"js/ForumCopilot/{name}"
    hashes[key] = digest
    print(f"  + {key}  {digest[:12]}…")

with open(hashes_path, "w") as f:
    json.dump(hashes, f, indent=2, sort_keys=True)
PY

(cd "$STAGE" && zip -u "$ZIP" "$HASH_PATH")

echo "Done."
echo "Final zip layout (upload/js + hashes):"
unzip -l "$ZIP" | grep -E "upload/js/|hashes.json" || true

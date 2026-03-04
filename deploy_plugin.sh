#!/bin/bash
# ForumCopilot XenForo Plugin Deployment Script (macOS/Linux)
# Copies plugin files to the XenForo server via SSH (rsync over SSH).
#
# Remote server: forum.example.com (edit REMOTE_HOST/REMOTE_USER if needed)
# XenForo path on server: DEST_BASE, e.g. /var/www/html/forums/xf2
#
# /var/www is usually owned by root, so we use sudo on the remote by default.
# To disable: USE_REMOTE_SUDO=0 ./deploy_plugin.sh
# Your user must have passwordless sudo for rsync on the server, or you'll be prompted.

REMOTE_HOST="${REMOTE_HOST:-forum.example.com}"
REMOTE_USER="${REMOTE_USER:-$USER}"
DEST_BASE="${DEST_BASE:-/var/www/html/forums/xf2}"
USE_REMOTE_SUDO="${USE_REMOTE_SUDO:-1}"

# With sudo on remote, use -t so ssh allocates a TTY and sudo can prompt for password.
SSH_CMD="ssh"
[ "$USE_REMOTE_SUDO" = "1" ] && SSH_CMD="ssh -t"
RSYNC_OPTS=(-av -e "$SSH_CMD")
[ "$USE_REMOTE_SUDO" = "1" ] && RSYNC_OPTS+=(--rsync-path="sudo rsync")

REMOTE_DEST="${REMOTE_USER}@${REMOTE_HOST}:${DEST_BASE}"

SOURCE_DIR="plugins/FC_XenForo2/upload/src/addons/ForumCopilot"
DEST_DIR="${DEST_BASE}/src/addons/ForumCopilot"
ROOT_PHP_SOURCE="plugins/FC_XenForo2/upload/forumcopilot.php"
ROOT_PHP_DEST="${DEST_BASE}/forumcopilot.php"

echo "ForumCopilot XenForo Plugin Deployment Script"
echo "Source:  ${SOURCE_DIR}"
echo "Remote:  ${REMOTE_USER}@${REMOTE_HOST}"
[ "$USE_REMOTE_SUDO" = "1" ] && echo "Mode:    rsync via sudo on remote"
echo "Dest:   ${DEST_DIR}"
echo ""

# Run from project root (directory that contains plugins/)
if [ ! -d "plugins" ]; then
    echo "ERROR: Directory 'plugins' not found."
    echo "Run this script from the project root (e.g. tapatalk_flutter)."
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source not found: ${SOURCE_DIR}"
    exit 1
fi

echo "Copying addon files to ${REMOTE_HOST}..."
rsync "${RSYNC_OPTS[@]}" --delete "$SOURCE_DIR/" "${REMOTE_USER}@${REMOTE_HOST}:${DEST_DIR}/" || exit 1

echo "Copying forumcopilot.php to XenForo root on ${REMOTE_HOST}..."
rsync "${RSYNC_OPTS[@]}" "$ROOT_PHP_SOURCE" "${REMOTE_USER}@${REMOTE_HOST}:${ROOT_PHP_DEST}" || exit 1

# Verify: both rsyncs returned 0, so check a file exists on the server.
if ssh -o BatchMode=yes "${REMOTE_USER}@${REMOTE_HOST}" "sudo test -f ${DEST_DIR}/addon.json && sudo test -f ${ROOT_PHP_DEST}" 2>/dev/null; then
    echo ""
    echo "Deploy succeeded. Addon and forumcopilot.php are on ${REMOTE_HOST}."
else
    echo ""
    echo "Deploy completed (rsync reported success). To verify on server: ssh ${REMOTE_USER}@${REMOTE_HOST} 'sudo ls -la ${DEST_DIR}/'"
fi


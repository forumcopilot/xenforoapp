#!/bin/bash

# Reset Local Storage for Forum App macOS App
# This script removes all app data including preferences, caches, and files

set -e

BUNDLE_ID="com.example.forumapp"
CONTAINER_PATH="$HOME/Library/Containers/$BUNDLE_ID"
PREFS_PATH="$HOME/Library/Preferences/${BUNDLE_ID}.plist"
CACHES_PATH="$HOME/Library/Caches/$BUNDLE_ID"
APP_SUPPORT_PATH="$HOME/Library/Application Support/$BUNDLE_ID"
SAVED_STATE_PATH="$HOME/Library/Saved Application State/${BUNDLE_ID}.savedState"

echo "🗑️  Forum App Storage Reset Utility"
echo "========================================"
echo ""

# Check if app is running
if pgrep -f "Forum App" > /dev/null; then
    echo "⚠️  WARNING: Forum App appears to be running!"
    echo "Please close the app before resetting storage."
    echo ""
    read -p "Do you want to continue anyway? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Cancelled. Please close the app and try again."
        exit 1
    fi
fi

echo "This will delete:"
echo "  - All app preferences and settings"
echo "  - All account credentials"
echo "  - All site visit history"
echo "  - All cached data"
echo "  - All application files"
echo "  - All saved application state"
echo ""

read -p "⚠️  Are you sure you want to reset ALL local storage? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled."
    exit 0
fi

echo ""
echo "🧹 Resetting storage..."

# Delete app container (includes preferences, caches, application support)
if [ -d "$CONTAINER_PATH" ]; then
    echo "  Deleting app container: $CONTAINER_PATH"
    rm -rf "$CONTAINER_PATH"
    echo "  ✅ App container deleted"
else
    echo "  ℹ️  App container not found (may already be deleted)"
fi

# Delete preferences file if it exists separately
if [ -f "$PREFS_PATH" ]; then
    echo "  Deleting preferences file: $PREFS_PATH"
    rm -f "$PREFS_PATH"
    echo "  ✅ Preferences file deleted"
else
    echo "  ℹ️  Preferences file not found (may already be deleted)"
fi

# Delete caches directory (if not sandboxed)
if [ -d "$CACHES_PATH" ]; then
    echo "  Deleting caches directory: $CACHES_PATH"
    rm -rf "$CACHES_PATH"
    echo "  ✅ Caches directory deleted"
else
    echo "  ℹ️  Caches directory not found (may already be deleted)"
fi

# Delete application support directory (if not sandboxed)
if [ -d "$APP_SUPPORT_PATH" ]; then
    echo "  Deleting application support: $APP_SUPPORT_PATH"
    rm -rf "$APP_SUPPORT_PATH"
    echo "  ✅ Application support deleted"
else
    echo "  ℹ️  Application support not found (may already be deleted)"
fi

# Delete saved application state
if [ -d "$SAVED_STATE_PATH" ]; then
    echo "  Deleting saved application state: $SAVED_STATE_PATH"
    rm -rf "$SAVED_STATE_PATH"
    echo "  ✅ Saved application state deleted"
else
    echo "  ℹ️  Saved application state not found (may already be deleted)"
fi

echo ""
echo "✅ Storage reset complete!"
echo ""
echo "The app will start fresh on next launch."
echo "All data (settings, accounts, history) has been removed."



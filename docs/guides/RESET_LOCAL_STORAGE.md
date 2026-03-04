# Reset Local Storage on macOS

This guide explains how to reset all local storage for the Forum App macOS app.

## Storage Locations

The app stores data in several locations:

### 1. SharedPreferences (Main Storage)
- **Location**: `~/Library/Containers/com.example.forumapp/Data/Library/Preferences/com.example.forumapp.plist`
- **Contains**:
  - User settings (theme, page size)
  - Site visit history
  - Account credentials (encrypted)
  - Site contexts
  - Search history
  - Cache data

### 2. Application Support Directory
- **Location**: `~/Library/Containers/com.example.forumapp/Data/Library/Application Support/com.example.forumapp/`
- **Contains**: Additional app-specific files

### 3. Temporary Files
- **Location**: System temp directory (varies)
- **Contains**: Cached images, link previews, YouTube previews

## Methods to Reset Storage

### Method 1: Delete App Container (Recommended - Complete Reset)

This removes **all** app data including preferences, caches, and files:

```bash
# Close the app first, then run:
rm -rf ~/Library/Containers/com.example.forumapp

# Optional: Also clear preferences if stored separately
rm -f ~/Library/Preferences/com.example.forumapp.plist
```

**What this does:**
- Deletes all SharedPreferences data
- Removes all cached files
- Clears all application support files
- Effectively resets the app to a fresh install state

### Method 2: Delete Only SharedPreferences

If you want to keep some app data but reset settings:

```bash
# Close the app first
rm -f ~/Library/Containers/com.example.forumapp/Data/Library/Preferences/com.example.forumapp.plist

# Or delete the entire Preferences directory
rm -rf ~/Library/Containers/com.example.forumapp/Data/Library/Preferences/
```

### Method 3: Using Finder (GUI Method)

1. Close the Forum App
2. Open Finder
3. Press `Cmd + Shift + G` (Go to Folder)
4. Enter: `~/Library/Containers/`
5. Find and delete the folder: `com.example.forumapp`
6. Empty Trash

### Method 4: Clear Cache Only

To clear only temporary cached files:

```bash
# Clear system temp files (may affect other apps, be careful)
# Or clear app-specific cache:
rm -rf ~/Library/Containers/com.example.forumapp/Data/Library/Caches/
```

## Verification

After resetting, verify the storage is cleared:

1. **Check SharedPreferences file:**
   ```bash
   ls -la ~/Library/Containers/com.example.forumapp/Data/Library/Preferences/
   ```
   Should show "No such file or directory" if container was deleted.

2. **Check container exists:**
   ```bash
   ls -la ~/Library/Containers/com.example.forumapp
   ```
   Should show "No such file or directory" if container was deleted.

## Programmatic Reset (Future Enhancement)

To add a "Reset All Data" feature in the app itself, you could:

1. Clear all SharedPreferences keys
2. Delete cache directories
3. Clear file caches

Example code would need to:
- Call `SharedPreferences.getInstance().then((prefs) => prefs.clear())`
- Delete cache directories using `path_provider`
- Clear image caches using `flutter_cache_manager`

## Important Notes

⚠️ **Warning**: 
- Always close the app before deleting storage files
- Deleting the app container will remove **all** data (accounts, settings, history)
- This cannot be undone
- Make sure to back up important data if needed

## Storage Contents

The app stores the following in SharedPreferences:

- **Settings**: `theme_mode`, `page_per_size`
- **Site Data**: `site_accounts`, `site_passwords`, `site_visit_history`
- **Site Contexts**: `site_context_<url>` (one per site)
- **Cache**: `CACHE_<siteKey>_<key>`, `CACHE_EXPIRATION_<key>`
- **Search**: `search_history`

All of these will be cleared when you delete the app container.






















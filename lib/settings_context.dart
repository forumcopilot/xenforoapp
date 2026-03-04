import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'theme/app_theme.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'dart:ui' as ui;

class SettingsContext {
  static SettingsContext? _instance;
  static SettingsContext get instance => _instance ??= SettingsContext();

  // Observable settings
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final RxInt pagePerSize = 20.obs; // Default page size for paging
  final Rx<Locale?> locale = Rx<Locale?>(null); // null = use system locale

  // Initialize settings from device
  Future<void> loadFromDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load theme mode
      final String? themeModeStr = prefs.getString('theme_mode');
      if (themeModeStr != null) {
        final ThemeMode loadedThemeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeStr,
          orElse: () => ThemeMode.system,
        );
        // Update both SettingsContext and AppTheme
        themeMode.value = loadedThemeMode;
        AppTheme.themeMode.value = loadedThemeMode;
      }

      // Load page_per_size
      final int? loadedPagePerSize = prefs.getInt('page_per_size');
      if (loadedPagePerSize != null && loadedPagePerSize > 0) {
        pagePerSize.value = loadedPagePerSize;
      }

      // Load locale
      final String? localeCode = prefs.getString('locale');
      if (localeCode != null && localeCode.isNotEmpty) {
        locale.value = Locale(localeCode);
        // Update GetX locale to match saved preference
        Get.updateLocale(Locale(localeCode));
      } else {
        locale.value = null; // Use system locale
        // Update GetX to use device locale
        final deviceLocale = ui.PlatformDispatcher.instance.locale;
        Get.updateLocale(deviceLocale);
      }

      AppLogger.debug('Settings loaded from device:');
      AppLogger.debug('- Theme Mode: ${themeMode.value}');
      AppLogger.debug('- Page Per Size: ${pagePerSize.value}');
      AppLogger.debug('- Locale: ${locale.value?.languageCode ?? "system"}');
    } catch (e) {
      AppLogger.debug('Error loading settings: $e');
    }
  }

  // Save settings to device
  Future<void> saveToDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save theme mode
      await prefs.setString('theme_mode', themeMode.value.toString());

      // Save page_per_size
      await prefs.setInt('page_per_size', pagePerSize.value);

      // Save locale
      if (locale.value != null) {
        await prefs.setString('locale', locale.value!.languageCode);
      } else {
        await prefs.remove('locale'); // Remove to use system locale
      }

      AppLogger.debug('Settings saved to device:');
      AppLogger.debug('- Theme Mode: ${themeMode.value}');
      AppLogger.debug('- Page Per Size: ${pagePerSize.value}');
      AppLogger.debug('- Locale: ${locale.value?.languageCode ?? "system"}');
    } catch (e) {
      AppLogger.debug('Error saving settings: $e');
    }
  }

  // Reset settings to defaults
  Future<void> resetToDefaults() async {
    themeMode.value = ThemeMode.system;
    pagePerSize.value = 20;
    locale.value = null; // Use system locale
    await saveToDevice();
  }
}

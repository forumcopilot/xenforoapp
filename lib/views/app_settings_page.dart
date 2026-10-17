import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../settings_context.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';
import '../l10n/generated/app_localizations.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.appSettings ?? 'App Settings',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: DesignTokens.paddingScreen,
        children: [
          _buildLanguageSection(colorScheme, textTheme),
          SizedBox(height: DesignTokens.spacingXL),
          _buildThemeSection(colorScheme, textTheme),
          SizedBox(height: DesignTokens.spacingXL),
          _buildVersionInfo(colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(ColorScheme colorScheme, TextTheme textTheme) {
    // Map of locale codes to display names
    final Map<String, String> languageNames = {
      'en': 'English',
      'es': 'Español',
      'it': 'Italiano',
      'pt': 'Português',
      'fr': 'Français',
      'de': 'Deutsch',
      'nl': 'Nederlands',
      'ja': '日本語',
      'ko': '한국어',
      'zh': '中文',
      'ru': 'Русский',
    };

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(
            alpha: DesignTokens.opacityLow,
          ),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingL),
            child: Text(
              AppLocalizations.of(context)?.language ?? 'Language',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: DesignTokens.fontWeightSemiBold,
              ),
            ),
          ),
          Obx(() {
            final currentLocale = SettingsContext.instance.locale.value;
            return RadioGroup<Locale?>(
              groupValue: currentLocale,
              onChanged: (value) {
                SettingsContext.instance.locale.value = value;
                SettingsContext.instance.saveToDevice();
                // Apply at once; System Default (null) follows the device.
                Get.updateLocale(value ?? Get.deviceLocale ?? const Locale('en'));
              },
              child: Column(
              children: [
                RadioListTile<Locale?>(
                  title: Text(
                    AppLocalizations.of(context)?.systemDefault ?? 'System Default',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)?.followSystemLanguage ?? 'Follow system language',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: null,
                ),
                ...languageNames.entries.map((entry) {
                  final locale = Locale(entry.key);
                  return RadioListTile<Locale?>(
                    title: Text(
                      entry.value,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    value: locale,
                  );
                }),
              ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildThemeSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(
            alpha: DesignTokens.opacityLow,
          ),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingL),
            child: Text(
              AppLocalizations.of(context)?.appearance ?? 'Appearance',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: DesignTokens.fontWeightSemiBold,
              ),
            ),
          ),
          Obx(() {
            final currentTheme = SettingsContext.instance.themeMode.value;
            return RadioGroup<ThemeMode>(
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  SettingsContext.instance.themeMode.value = value;
                  AppTheme.themeMode.value = value;
                  SettingsContext.instance.saveToDevice();
                }
              },
              child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context)?.systemDefault ?? 'System Default',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)?.followSystemTheme ?? 'Follow system theme',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context)?.light ?? 'Light',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context)?.dark ?? 'Dark',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  value: ThemeMode.dark,
                ),
              ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVersionInfo(ColorScheme colorScheme, TextTheme textTheme) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        final packageInfo = snapshot.data!;
        final version = packageInfo.version;
        final buildNumber = packageInfo.buildNumber;

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
            child: Text(
              AppLocalizations.of(context)?.version(version, buildNumber) ?? 'version $version ($buildNumber)',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }
}

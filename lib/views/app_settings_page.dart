import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../settings_context.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';
import '../l10n/generated/app_localizations.dart';
import 'widgets/sheet_title.dart';

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
          AppLocalizations.of(context).appSettings,
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

  /// The languages the app speaks, each in its own language.
  static const Map<String, String> _languageNames = {
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

  void _setLocale(Locale? value) {
    SettingsContext.instance.locale.value = value;
    SettingsContext.instance.saveToDevice();
    // Apply at once; System Default (null) follows the device.
    Get.updateLocale(value ?? Get.deviceLocale ?? const Locale('en'));
  }

  /// The language list in a sheet: twelve radio rows filled the page, and
  /// pushed Appearance and Posting below the fold.
  void _pickLanguage(ColorScheme colorScheme, TextTheme textTheme) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext);
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => RadioGroup<Locale?>(
            groupValue: SettingsContext.instance.locale.value,
            onChanged: (value) {
              Navigator.of(sheetContext).pop();
              _setLocale(value);
            },
            child: ListView(
              controller: scrollController,
              children: [
                SheetTitle(l10n.language),
                RadioListTile<Locale?>(
                  title: Text(l10n.systemDefault, style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
                  subtitle: Text(
                    l10n.followSystemLanguage,
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  value: null,
                ),
                for (final entry in _languageNames.entries)
                  RadioListTile<Locale?>(
                    title: Text(entry.value, style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
                    value: Locale(entry.key),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSection(ColorScheme colorScheme, TextTheme textTheme) {
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingL),
            child: Text(
              AppLocalizations.of(context).language,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: DesignTokens.fontWeightSemiBold,
              ),
            ),
          ),
          // The current choice; a tap opens the list.
          Obx(() {
            final current = SettingsContext.instance.locale.value;
            final l10n = AppLocalizations.of(context);
            final name = current == null ? null : _languageNames[current.languageCode];
            return ListTile(
              title: Text(
                name ?? l10n.systemDefault,
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
              ),
              subtitle: name == null
                  ? Text(
                      l10n.followSystemLanguage,
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    )
                  : null,
              trailing: Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
              onTap: () => _pickLanguage(colorScheme, textTheme),
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
              AppLocalizations.of(context).appearance,
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
                    AppLocalizations.of(context).systemDefault,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).followSystemTheme,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context).light,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context).dark,
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
              AppLocalizations.of(context).version(version, buildNumber),
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

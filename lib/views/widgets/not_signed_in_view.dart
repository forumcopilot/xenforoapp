import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_flutter/views/register_page.dart';
import '../../theme/design_tokens.dart';

class NotSignedInView extends StatelessWidget {
  final SiteContext siteContext;
  final String title;
  final String message;
  final IconData icon;
  final bool autoShowLogin;

  const NotSignedInView({
    super.key,
    required this.siteContext,
    required this.title,
    required this.message,
    this.icon = Icons.lock_outline_rounded,
    this.autoShowLogin = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (autoShowLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute != '/LoginPage') {
          Get.to(() => LoginPage(siteContext: siteContext));
        }
      });
    }

    return Center(
      child: SingleChildScrollView(
        padding: DesignTokens.paddingXXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: DesignTokens.avatarSizeXL, // 64px
              color: colorScheme.primary,
            ),
            SizedBox(height: DesignTokens.spacingXL - DesignTokens.spacingXS), // 20px
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: DesignTokens.fontWeightBold,
                fontSize: DesignTokens.fontSizeL, // Match forum header title size
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingS),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: DesignTokens.fontSizeS, // Match forum header description size
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingXL),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Get.to(() => LoginPage(siteContext: siteContext));
                    },
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingXL,
                        vertical: DesignTokens.spacingM,
                      ),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: DesignTokens.spacingM),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => RegisterPage(siteContext: siteContext));
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingXL,
                        vertical: DesignTokens.spacingM,
                      ),
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(
                        color: colorScheme.primary,
                        width: DesignTokens.borderWidthMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusM),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.register ?? 'Register',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

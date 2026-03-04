import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/utils/number_utils.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/design_tokens.dart';
import '../../utils/signature_processor.dart';

class ProfileInfoSection extends StatelessWidget {
  final FCUserInfoResult userInfo;
  final Widget? settingsButton;

  const ProfileInfoSection({
    Key? key,
    required this.userInfo,
    this.settingsButton,
  }) : super(key: key);

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingXS,
      ),
      leading: Icon(
        icon,
        size: DesignTokens.iconSizeM,
        color: colorScheme.primary,
      ),
      title: Text(
        title,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: textTheme.bodyMedium?.copyWith(
          color: onTap != null ? colorScheme.primary : colorScheme.onSurface,
          decoration: onTap != null ? TextDecoration.underline : null,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSignatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String signature,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final spans = SignatureProcessor.processSignature(signature, context);

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingXS,
      ),
      leading: Icon(
        icon,
        size: DesignTokens.iconSizeM,
        color: colorScheme.primary,
      ),
      title: Text(
        title,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(children: spans),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Display user's bio/description if available
        if (userInfo.displayText != null && userInfo.displayText!.isNotEmpty) ...[
          SizedBox(height: DesignTokens.spacingXS),
          Padding(
            padding: DesignTokens.paddingScreenHorizontal,
            child: Text(
              userInfo.displayText!,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        // Settings Button (if provided)
        if (settingsButton != null) ...[
          SizedBox(height: DesignTokens.spacingL),
          settingsButton!,
        ],
        SizedBox(height: DesignTokens.spacingM),

        // Combined Core and Additional Information Section
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            side: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
              width: DesignTokens.borderWidthThin,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Core Information
              if (userInfo.registrationTime != null)
                _buildInfoTile(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Member Since',
                  subtitle: DateFormat.yMMMMd().format(userInfo.registrationTime as DateTime),
                ),
              if (userInfo.customFieldsList != null)
                ...(() {
                  final birthdayField = userInfo.customFieldsList!.where((f) => f.name.toLowerCase() == 'birthday' && f.value.trim().isNotEmpty && f.value != '0').toList();
                  if (birthdayField.isEmpty) return <Widget>[];
                  final field = birthdayField.first;
                  DateTime? birthdayDate;
                  try {
                    birthdayDate = DateFormat('d MMM yyyy').parse(field.value);
                  } catch (_) {}
                  final now = DateTime.now();
                  if (birthdayDate == null || birthdayDate.year < 1900 || birthdayDate.isAfter(now)) {
                    return <Widget>[];
                  }
                  final locale = Localizations.localeOf(context).toString();
                  final formatted = DateFormat.yMMMMd(locale).format(birthdayDate);
                  return [
                    _buildInfoTile(
                      context,
                      icon: Icons.cake,
                      title: AppLocalizations.of(context)?.birthday ?? 'Birthday',
                      subtitle: formatted,
                    ),
                  ];
                })(),
              if (userInfo.lastActivityTime != null)
                _buildInfoTile(
                  context,
                  icon: Icons.access_time,
                  title: 'Last Activity',
                  subtitle: DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_jm().format(userInfo.lastActivityTime!.toLocal()),
                ),
              if (userInfo.postCount != null && userInfo.postCount != 0)
                _buildInfoTile(
                  context,
                  icon: Icons.post_add,
                  title: AppLocalizations.of(context)?.posts ?? 'Posts',
                  subtitle: formatNumber(context, userInfo.postCount),
                ),
              // Likes Received and Likes Given
              if (userInfo.customFieldsList != null)
                ...(() {
                  final likesReceivedField =
                      userInfo.customFieldsList!.where((f) => (f.name.toLowerCase() == 'likes' || f.name.toLowerCase() == 'likes_received') && f.value.trim().isNotEmpty && f.value != '0').toList();
                  final likesGivenField = userInfo.customFieldsList!.where((f) => f.name.toLowerCase() == 'liked' && f.value.trim().isNotEmpty && f.value != '0').toList();
                  final List<Widget> fields = [];
                  if (likesReceivedField.isNotEmpty) {
                    fields.add(_buildInfoTile(
                      context,
                      icon: Icons.thumb_up,
                      title: 'Likes Received',
                      subtitle: formatNumberFromString(context, likesReceivedField.first.value),
                    ));
                  }
                  if (likesGivenField.isNotEmpty) {
                    fields.add(_buildInfoTile(
                      context,
                      icon: Icons.thumb_up_outlined,
                      title: 'Likes Given',
                      subtitle: formatNumberFromString(context, likesGivenField.first.value),
                    ));
                  }
                  return fields;
                })(),
              if (userInfo.followingCount != null && userInfo.followingCount != 0)
                _buildInfoTile(
                  context,
                  icon: Icons.people_outline,
                  title: AppLocalizations.of(context)?.following ?? 'Following',
                  subtitle: userInfo.followingCount.toString(),
                ),
              if (userInfo.follower != null && userInfo.follower != 0)
                _buildInfoTile(
                  context,
                  icon: Icons.people,
                  title: AppLocalizations.of(context)?.followers ?? 'Followers',
                  subtitle: userInfo.follower.toString(),
                ),
              // About field (from direct API field)
              if (userInfo.bio != null && userInfo.bio!.isNotEmpty)
                _buildInfoTile(
                  context,
                  icon: Icons.person_outline,
                  title: AppLocalizations.of(context)?.about ?? 'About',
                  subtitle: userInfo.bio!,
                ),
              // Location field (from direct API field)
              if (userInfo.location != null && userInfo.location!.isNotEmpty)
                _buildInfoTile(
                  context,
                  icon: Icons.location_on,
                  title: AppLocalizations.of(context)?.location ?? 'Location',
                  subtitle: userInfo.location!,
                ),
              // Website field (clickable)
              if (userInfo.website != null && userInfo.website!.isNotEmpty)
                _buildInfoTile(
                  context,
                  icon: Icons.language,
                  title: AppLocalizations.of(context)?.website ?? 'Website',
                  subtitle: userInfo.website!,
                  onTap: () async {
                    final url = userInfo.website!;
                    final uri = Uri.parse(url.startsWith('http://') || url.startsWith('https://') ? url : 'https://$url');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              // Signature field (from direct API field)
              if (userInfo.signature != null && userInfo.signature!.isNotEmpty)
                _buildSignatureTile(
                  context,
                  icon: Icons.edit_note,
                  title: AppLocalizations.of(context)?.signature ?? 'Signature',
                  signature: userInfo.signature!,
                ),
              // Location field from customFields (fallback for older data)
              if (userInfo.location == null && userInfo.customFieldsList != null)
                ...(() {
                  final locationField = userInfo.customFieldsList!.where((f) => f.name.toLowerCase().contains('location') && f.value.trim().isNotEmpty && f.value != '0').toList();
                  if (locationField.isEmpty) return <Widget>[];
                  return [
                    _buildInfoTile(
                      context,
                      icon: Icons.location_on,
                      title: locationField.first.name,
                      subtitle: locationField.first.value,
                    ),
                  ];
                })(),
              // Signature field from customFields (fallback for older data)
              if (userInfo.signature == null && userInfo.customFieldsList != null)
                ...(() {
                  final signatureField = userInfo.customFieldsList!.where((f) => f.name.toLowerCase() == 'signature' && f.value.trim().isNotEmpty && f.value != '0').toList();
                  if (signatureField.isEmpty) return <Widget>[];
                  return [
                    _buildSignatureTile(
                      context,
                      icon: Icons.edit_note,
                      title: AppLocalizations.of(context)?.signature ?? 'Signature',
                      signature: signatureField.first.value,
                    ),
                  ];
                })(),
              // Additional Information Section (Expandable)
              if (userInfo.customFieldsList != null &&
                  userInfo.customFieldsList!.isNotEmpty &&
                  userInfo.customFieldsList!.any((f) =>
                      f.value.trim().isNotEmpty &&
                      f.value != "0" &&
                      f.name.toLowerCase() != 'birthday' &&
                      f.name.toLowerCase() != 'likes' &&
                      f.name.toLowerCase() != 'liked' &&
                      f.name.toLowerCase() != 'signature' &&
                      !f.name.toLowerCase().contains('location')))
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    title: Text(
                      'Show More',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                    children: [
                      ...userInfo.customFieldsList!
                          .where((f) =>
                              f.value.trim().isNotEmpty &&
                              f.value != "0" &&
                              f.name.toLowerCase() != 'birthday' &&
                              f.name.toLowerCase() != 'likes' &&
                              f.name.toLowerCase() != 'liked' &&
                              f.name.toLowerCase() != 'signature' &&
                              !f.name.toLowerCase().contains('location'))
                          .map((f) => _buildInfoTile(
                                context,
                                icon: Icons.info_outline,
                                title: f.name,
                                subtitle: f.value,
                              ))
                          .toList(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

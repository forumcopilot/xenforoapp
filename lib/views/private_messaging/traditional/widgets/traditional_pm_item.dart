import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_message_result.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:flutter_bbcode/flutter_bbcode.dart';
import '../../../../utils/bbcode_processor.dart';
import '../../../widgets/custom_bb_stylesheet.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import '../../../../utils/time_utils.dart';
import '../../../../utils/url_utils.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../theme/style_builders.dart';

class TraditionalPMItem extends StatelessWidget {
  final SiteContext siteContext;
  final FCMessageResult message;
  final String subject;

  const TraditionalPMItem({
    Key? key,
    required this.siteContext,
    required this.message,
    required this.subject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final processedText = BBCodeProcessor.processText(message.textBody, siteContext: siteContext).trimRight();

    final callbacks = BBCodeCallbacks(
      onUrlTap: (url) async {
        await UrlUtils.handleUrlTap(url, context);
      },
      onMentionTap: (username) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              siteContext: siteContext,
              userName: username,
            ),
          ),
        );
      },
      onUserTap: (username, userId) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              siteContext: siteContext,
              userId: userId,
              userName: username,
            ),
          ),
        );
      },
      // You can add onImageTap/onVideoTap if needed
    );

    final stylesheet = CustomBBStylesheet(
      siteContext: siteContext,
      callbacks: callbacks,
      context: context,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subject Section - Above the card
        if (subject.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.only(
              left: DesignTokens.spacingL,
              right: DesignTokens.spacingL,
              bottom: DesignTokens.spacingS,
              top: DesignTokens.spacingL,
            ),
            child: Text(
              subject,
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
                fontSize: DesignTokens.fontSizeTopicTitle,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        ],
        // Message Card
        Card(
          margin: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingM,
            vertical: DesignTokens.spacingM - DesignTokens.spacingXS,
          ),
          elevation: DesignTokens.elevationMedium,
          shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow * 0.33),
          color: colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            side: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
              width: DesignTokens.borderWidthThin,
            ),
          ),
          child: Padding(
            padding: DesignTokens.paddingL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // From Section
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                siteContext: siteContext,
                                userName: message.msgFrom ?? message.authorName,
                                profilePictureUrl: message.iconUrl,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UserAvatar(
                              username: message.msgFrom ?? message.authorName,
                              iconUrl: message.iconUrl,
                              radius: DesignTokens.spacingXL,
                              showOnlineIndicator: true,
                              isOnline: false, // Not available in FCMessageResult
                            ),
                            const SizedBox(width: DesignTokens.spacingM),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.msgFrom ?? message.authorName,
                                  style: StyleBuilders.titleTextStyle(
                                    colorScheme: colorScheme,
                                    textTheme: textTheme,
                                    fontWeight: DesignTokens.fontWeightMedium,
                                  ),
                                ),
                                Text(
                                  formatSmartDateTime(DateTime.tryParse(message.msgTime) ?? DateTime.now(), context),
                                  style: StyleBuilders.smallTextStyle(
                                    colorScheme: colorScheme,
                                    textTheme: textTheme,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingM),
                // To Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: DesignTokens.iconSizeXL + DesignTokens.spacingXS,
                      child: Text(
                        'To:',
                        style: StyleBuilders.bodyTextStyle(
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: DesignTokens.fontWeightMedium,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: DesignTokens.spacingS,
                        runSpacing: DesignTokens.spacingS,
                        children: (message.msgTo as List<String>? ?? []).map((recipient) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(
                                    siteContext: siteContext,
                                    userName: recipient,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacingM,
                                vertical: DesignTokens.spacingM - DesignTokens.spacingXS,
                              ),
                              decoration: StyleBuilders.badgeDecoration(
                                colorScheme: colorScheme,
                                backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
                                borderRadius: DesignTokens.radiusL,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UserAvatar(
                                    username: recipient,
                                    iconUrl: null,
                                    radius: DesignTokens.spacingM,
                                    showOnlineIndicator: false,
                                  ),
                                  const SizedBox(width: DesignTokens.spacingS),
                                  Text(
                                    recipient,
                                    style: StyleBuilders.bodyTextStyle(
                                      colorScheme: colorScheme,
                                      textTheme: textTheme,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingM),
                StyleBuilders.divider(
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: DesignTokens.spacingL),
                // Message Body (BBCode)
                Builder(
                  builder: (context) {
                    try {
                      final processor = BBCodeProcessor();
                      String textToRender = processor.getValidBBCodeText(processedText);
                      return BBCodeText(
                        data: textToRender,
                        stylesheet: stylesheet,
                      );
                    } catch (error, stackTrace) {
                      debugPrint('BBCode parsing error in message: \n$error\nStackTrace: $stackTrace');
                      debugPrint('Message content that caused error:\n$processedText');
                      // If BBCode parsing fails, display as plain text instead of rich text
                      return Text(
                        processedText,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          height: 1.2,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

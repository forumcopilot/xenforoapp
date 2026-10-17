import 'package:flutter/material.dart';
import '../widgets/attachment_item_widget.dart';
import '../widgets/attachment_big_thumbnail_grid.dart';
import '../widgets/full_screen_video_viewer.dart';
import '../../utils/file_utils.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import '../../theme/design_tokens.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/snackbar_helper.dart';

class PostListItemAttachment extends StatelessWidget {
  final List<FCAttachment> attachments;
  final dynamic actions;
  final BuildContext context;
  final bool isInline;
  final String title;

  const PostListItemAttachment({
    super.key,
    required this.attachments,
    required this.actions,
    required this.context,
    this.isInline = false,
    this.title = 'Attachments',
  });

  @override
  Widget build(BuildContext context) {
    // Check if all attachments are images
    final allImages = attachments.every((att) => isImageFile(att.filename));

    // If all attachments are images, use big thumbnail grid mode
    if (allImages) {
      return AttachmentBigThumbnailGrid(
        attachments: attachments,
        onImageTap: actions?.onShowImage,
        onLoginRequired: actions?.onLoginRequired,
      );
    }

    // Otherwise use the original list view
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: DesignTokens.spacingS),
        padding: DesignTokens.paddingS,
        decoration: BoxDecoration(
          color:
              colorScheme.surfaceContainerHighest.withValues(alpha: DesignTokens.opacityLow),
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          border: Border.all(
            color:
                colorScheme.outlineVariant.withValues(alpha: DesignTokens.opacityLow),
            width: DesignTokens.borderWidthThin,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...attachments.map((att) {
              final isImage = isImageFile(att.filename);

              return AttachmentItemWidget(
                attachment: att,
                isInline: isInline,
                showDownloadIcon: !isInline,
                onTap: isImage
                    ? (att.canViewUrl == true
                        ? () =>
                            actions?.onShowImage?.call(att.url, context, att.id)
                        : () => actions?.onLoginRequired?.call(context))
                    : isInline
                        ? null
                        : (att.canViewUrl == true
                            ? () {
                                if (isVideoFile(att.filename) ||
                                    isVideoFile(att.url)) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenVideoViewer(
                                        videoUrl: att.url,
                                        title: att.filename,
                                      ),
                                    ),
                                  );
                                } else {
                                  _downloadAttachment(
                                      context, att.url, att.filename);
                                }
                              }
                            : () => actions?.onLoginRequired?.call(context)),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAttachment(
      BuildContext context, String url, String filename) async {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(AppLocalizations.of(context).downloading(filename)),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final filePath = await downloadFileToDownloads(url, filename);

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // On iOS, filePath will be empty after sharing
        if (filePath.isEmpty) {
          SnackbarHelper.showSuccess(context, AppLocalizations.of(context).openingShareSheet(filename));
        } else {
          // Determine if file was saved to Downloads or Documents (fallback)
          final isInDownloads = filePath.contains('/Downloads/') ||
              (filePath.contains('Downloads') &&
                  !filePath.contains('Containers'));
          final locationMessage = isInDownloads
              ? AppLocalizations.of(context).fileSavedToDownloads(filename)
              : AppLocalizations.of(context).fileSavedToDocuments(filename);

          SnackbarHelper.showSuccess(context, locationMessage);
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, AppLocalizations.of(context)
                    .errorDownloading(filename, e.toString()));
      }
    }
  }
}

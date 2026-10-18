import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';

abstract class BaseForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseForumAppBar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate available width for the title
          // Subtract space for back button and actions
          final availableWidth = constraints.maxWidth - 80; // 40 for back button, 40 for actions

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: _buildAdaptiveTitle(title, colorScheme, textTheme, availableWidth),
              ),
            ],
          );
        },
      ),
      backgroundColor: colorScheme.surface,
      elevation: 3,
      shadowColor: colorScheme.shadow.withValues(alpha: DesignTokens.opacityLow),
      surfaceTintColor: colorScheme.surfaceTint,
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      actions: buildActions(context),
      centerTitle: false,
    );
  }

  Widget _buildAdaptiveTitle(String title, ColorScheme colorScheme, TextTheme textTheme, double availableWidth) {
    // Test if the title fits in one line with font size 20
    final textSpan = TextSpan(
      text: title,
      style: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w500,
        fontSize: DesignTokens.fontSizeL,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout(maxWidth: availableWidth);

    if (textPainter.didExceedMaxLines) {
      // Text is too long, use smaller font size for both lines
      return Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: DesignTokens.fontSizeM,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      // Text fits in one line, use regular font size
      return Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  List<Widget> buildActions(BuildContext context);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

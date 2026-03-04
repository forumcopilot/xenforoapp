import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/cached_redirect_image.dart';
import 'package:forumcopilot_flutter/utils/avatar_color_utils.dart';

class _ShimmerLoadingCircle extends StatefulWidget {
  final double size;
  final Color baseColor;
  final Color highlightColor;

  const _ShimmerLoadingCircle({
    required this.size,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<_ShimmerLoadingCircle> createState() => _ShimmerLoadingCircleState();
}

class _ShimmerLoadingCircleState extends State<_ShimmerLoadingCircle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double percent = _controller.value; // 0..1
        final Alignment begin = Alignment(-1.5 + 3.0 * percent, 0);
        final Alignment end = Alignment(1.5 + 3.0 * percent, 0);
        return ClipOval(
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: [
                  widget.baseColor,
                  widget.highlightColor,
                  widget.baseColor,
                ],
                stops: const [0.2, 0.5, 0.8],
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String username;
  final String? iconUrl;
  final double radius;
  final VoidCallback? onTap;
  final bool showOnlineIndicator;
  final bool isOnline;
  final double onlineIndicatorSizeMultiplier;
  final String? cacheKey;

  const UserAvatar({
    super.key,
    required this.username,
    this.iconUrl,
    this.radius = 20,
    this.onTap,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.onlineIndicatorSizeMultiplier = 0.4,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Get dynamic colors for the user
    final avatarColors = AvatarColorUtils.getUserAvatarColorScheme(
      username,
      isLightTheme: isLightTheme,
    );
    
    // Get gradient colors for the avatar background
    final gradientColors = AvatarColorUtils.getGradientColors(
      username,
      isLightTheme: isLightTheme,
    );

    // Calculate cache size based on display size and device pixel ratio
    final displaySize = radius * 2;
    final cacheSize = (displaySize * devicePixelRatio).round();

    Widget avatar = (iconUrl != null && iconUrl!.isNotEmpty)
        ? ClipOval(
            child: SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: CachedRedirectImage(
                imageUrl: iconUrl!,
                fit: BoxFit.cover,
                cacheKey: cacheKey,
                cacheWidth: cacheSize,
                cacheHeight: cacheSize,
                placeholder: (context, url) => _ShimmerLoadingCircle(
                  size: radius * 2,
                  baseColor: avatarColors['background']!,
                  highlightColor: avatarColors['background']!.withOpacity(0.6),
                ),
                errorWidget: (context, url, error) => Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: textTheme.titleMedium?.copyWith(
                      color: avatarColors['text']!,
                      fontWeight: FontWeight.w600,
                      fontSize: radius,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              username.isNotEmpty ? username[0].toUpperCase() : '?',
              style: textTheme.titleMedium?.copyWith(
                color: avatarColors['text']!,
                fontWeight: FontWeight.w600,
                fontSize: radius,
              ),
            ),
          );

    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    if (showOnlineIndicator) {
      return Stack(
        children: [
          avatar,
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: radius * onlineIndicatorSizeMultiplier,
                height: radius * onlineIndicatorSizeMultiplier,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    return avatar;
  }
}

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode/flutter_bbcode.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:html/dom.dart' as dom;

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import '../../utils/embed_links.dart';
import '../../utils/forum_links.dart';
import 'cached_redirect_image.dart';
import 'code_block.dart';
import 'custom_bb_stylesheet.dart';
import 'embed_cards.dart';
import 'link_preview_card.dart';
import 'quote_box.dart';
import 'twitter_card.dart';

/// The gap between consecutive blocks of a post: paragraphs, lists, quotes,
/// code, tables, spoilers. Blocks take it below themselves.
const double _blockGap = DesignTokens.spacingM;

/// A XenForo post or direct message as the forum renders it (add-on
/// 1.11.0's `contentHtml`), drawn with flutter_html as Flapp draws Flarum's
/// posts (adapted from flarum_ui's FlarumContent). The forum renders its own
/// BBCodes, so custom BBCodes, media sites and smilies look as they do on
/// the website.
///
/// The add-on marks the parts the app draws itself with data attributes;
/// those are drawn as BBCode posts draw them, through [stylesheet]: quotes as
/// [QuoteBox]es, attachments by the stylesheet's own attachment tag,
/// YouTube as a video card, mentions and links through its callbacks.
class XenForoContent extends StatelessWidget {
  const XenForoContent({
    super.key,
    required this.html,
    required this.siteContext,
    required this.stylesheet,
  });

  final String html;
  final SiteContext siteContext;

  /// The post's BBCode stylesheet: its text style, callbacks (links, images,
  /// profiles, attachments) and attachment lists.
  final CustomBBStylesheet stylesheet;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final callbacks = stylesheet.callbacks;
    final body = stylesheet.defaultTextStyle;
    // 'monospace' is Android's name; iOS and macOS have Menlo.
    final codeStyle = body.copyWith(
      fontFamily: 'monospace',
      fontFamilyFallback: const ['Menlo', 'Courier'],
      fontSize: (body.fontSize ?? 16) * 0.875,
      height: 1.4,
    );

    return Html(
      data: platformStyles(html, apple: _isApple),
      style: {
        'body': Style.fromTextStyle(body).copyWith(margin: Margins.zero, padding: HtmlPaddings.zero),
        'p': Style(margin: Margins.only(bottom: _blockGap)),
        'a': Style(color: colorScheme.primary, textDecoration: TextDecoration.none),
        // XenForo's [HEADING=1..3] are h2..h4.
        'h1': _heading(24, 32, body),
        'h2': _heading(22, 28, body),
        'h3': _heading(20, 28, body),
        'h4': _heading(18, 26, body),
        'h5, h6': _heading(16, 24, body),
        'ul, ol': Style(margin: Margins.only(bottom: _blockGap), padding: HtmlPaddings.only(left: DesignTokens.spacingXL)),
        'li': Style(margin: Margins.only(bottom: DesignTokens.spacingXS)),
        'pre, table, details, hr': Style(margin: Margins.only(bottom: _blockGap)),
      },
      onLinkTap: (url, attributes, element) {
        if (url == null || url.isEmpty || url.startsWith('#')) return;
        final userId = attributes['data-user-id'];
        if (userId != null && userId.isNotEmpty && callbacks?.onUserTap != null) {
          final name = (element?.text ?? '').trim().replaceFirst(RegExp(r'^@'), '');
          callbacks!.onUserTap!(name, userId);
          return;
        }
        callbacks?.onUrlTap?.call(url);
      },
      extensions: [
        const _BlockRhythm(),
        _QuoteExtension(onOpenPost: (postId) {
          final url = ForumLinks.postUrl(siteContext.site, postId);
          if (url != null) callbacks?.onUrlTap?.call(url);
        }),
        const _DetailsExtension(),
        const _InlineSpoilerExtension(),
        _TableExtension(colorScheme: colorScheme),
        // An attachment, drawn by the stylesheet's own attachment tag, as in a
        // BBCode post, when it is among the post's attachments; otherwise the
        // forum's own "View attachment" link stays.
        MatcherExtension(
          matcher: (c) =>
              c.elementName == 'span' &&
              c.attributes.containsKey('data-attachment-id') &&
              _hasAttachment(c.attributes['data-attachment-id'] ?? ''),
          builder: (c) {
            final id = c.attributes['data-attachment-id'] ?? '';
            final full = c.attributes['data-attachment-full'] == '1';
            return BBCodeText(
              data: full ? '[ATTACH type="full"]$id[/ATTACH]' : '[ATTACH]$id[/ATTACH]',
              stylesheet: stylesheet,
            );
          },
        ),
        // A media embed as Flapp and the Discourse app draw it: a video
        // (YouTube, Vimeo, Dailymotion, ...) as its picture with the title
        // and the site's play button, X as the tweet card, other sites as the
        // page's own preview, or a row naming the site when the page offers
        // none. A site the add-on gives no address for (its URL pattern isn't
        // a plain one) keeps the add-on's own text.
        MatcherExtension(
          matcher: (c) =>
              c.elementName == 'div' &&
              c.attributes.containsKey('data-media-site') &&
              _mediaUrl(c.attributes) != null,
          builder: (c) {
            final url = _mediaUrl(c.attributes)!;
            final site = c.attributes['data-media-site'] ?? '';
            final embed = EmbedLink.fromMediaSite(site, url);
            final Widget card = site == 'twitter'
                ? TwitterCard(url: url)
                : embed.provider.kind == EmbedKind.video
                    ? EmbedVideoCard(link: embed)
                    : LinkPreviewCard(
                        url: url,
                        siteContext: siteContext,
                        fallback: EmbedRow(link: embed, onOpen: (u) => callbacks?.onUrlTap?.call(u)),
                      );
            return Padding(padding: const EdgeInsets.only(bottom: DesignTokens.spacingS), child: card);
          },
        ),
        // A link preview the forum unfurled, as the app's preview card.
        MatcherExtension(
          matcher: (c) => c.elementName == 'div' && c.attributes.containsKey('data-unfurl'),
          builder: (c) {
            final url = c.attributes['data-url'] ?? '';
            if (url.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
              child: LinkPreviewCard(url: url, siteContext: siteContext),
            );
          },
        ),
        // Code blocks coloured by language, scrolling sideways, with a copy
        // button.
        TagExtension(
          tagsToExtend: {'pre'},
          builder: (c) {
            final code = (c.element?.text ?? '').replaceAll(RegExp(r'\n+$'), '');
            if (code.isEmpty) return const SizedBox.shrink();
            return _gap(
              c,
              CodeBlock(
                code: code,
                textStyle: codeStyle,
                language: c.attributes['data-lang'],
                background: _inQuote(c.node) ? colorScheme.surface : null,
              ),
            );
          },
        ),
        // Inline code as a small rounded chip.
        MatcherExtension.inline(
          matcher: (c) => c.elementName == 'code' && !_hasAncestor(c.node, const {'pre', 'a'}),
          builder: (c) => WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingXS),
              decoration: BoxDecoration(
                color: _inQuote(c.node) ? colorScheme.surface : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
              ),
              child: Text(c.element?.text ?? '', style: codeStyle),
            ),
          ),
        ),
        TagExtension(
          tagsToExtend: {'img'},
          builder: (c) => _image(c, body, callbacks),
        ),
        // A thin rule, as the website draws <hr>.
        TagExtension(
          tagsToExtend: {'hr'},
          builder: (c) => _gap(c, Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant)),
        ),
      ],
    );
  }

  bool _hasAttachment(String id) {
    final callbacks = stylesheet.callbacks;
    return [...?callbacks?.inlineAttachments, ...?callbacks?.attachments].any((a) => '${a.id}' == id);
  }

  /// Smilies inline at the text's size; pictures as in BBCode posts, opening
  /// the image viewer.
  Widget _image(ExtensionContext c, TextStyle body, BBCodeCallbacks? callbacks) {
    final src = (c.attributes['src'] ?? '').trim();
    if (src.isEmpty) return const SizedBox.shrink();
    final isSmilie = c.attributes.containsKey('data-smilie') || (c.attributes['class'] ?? '').contains('smilie');
    if (isSmilie) {
      final size = (body.fontSize ?? 16) * 1.3;
      return CachedRedirectImage(
        imageUrl: src,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorWidget: (_, __, ___) => Text(c.attributes['alt'] ?? '', style: body),
      );
    }
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
      child: CachedRedirectImage(imageUrl: src, fit: BoxFit.contain),
    );
    if (callbacks?.onImageTap == null) return image;
    return Builder(
      builder: (imageContext) => GestureDetector(
        onTap: () => callbacks!.onImageTap!(src, imageContext, src),
        child: image,
      ),
    );
  }
}

/// A heading on the type scale (h1 headlineSmall 24/32 down to bodyLarge
/// 16/24), never smaller than the text, medium weight, with more room above
/// than below (none above as a post's first block). From discourse_ui.
Style _heading(double size, double lineHeight, TextStyle body) => Style(
      fontSize: FontSize(math.max(size, body.fontSize ?? 16)),
      lineHeight: LineHeight(lineHeight / size),
      fontWeight: FontWeight.w500,
      margin: Margins.only(top: DesignTokens.spacingL, bottom: DesignTokens.spacingS),
    );

/// A media embed's address: the add-on's, or built from the key for sites it
/// sends none for (add-on 1.11.0 knows only sites with a plain URL pattern).
/// A post on X is always built: the add-on's `twitter.com/statuses/{id}` is
/// not an address the tweet card can read.
String? _mediaUrl(Map<String, String> a) {
  final key = (a['data-media-key'] ?? '').trim();
  final site = a['data-media-site'];
  if (site == 'twitter' && RegExp(r'^\d+$').hasMatch(key)) return 'https://x.com/i/status/$key';
  final url = (a['data-media-url'] ?? '').trim();
  if (url.isNotEmpty) return url;
  if (key.isEmpty) return null;
  return switch (site) {
    'youtube' => 'https://www.youtube.com/watch?v=$key',
    'vimeo' => 'https://vimeo.com/$key',
    'dailymotion' => 'https://www.dailymotion.com/video/$key',
    'instagram' => 'https://www.instagram.com/p/$key/',
    _ => null,
  };
}

bool get _isApple => defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;

final RegExp _styleAttribute = RegExp(r'style="([^"]*)"');
final RegExp _backgroundShorthand = RegExp(r'(^|;)\s*background\s*:\s*(#[0-9a-fA-F]{3,8}|rgba?\([^)]*\)|[a-zA-Z]+)\s*(?=;|$)');
final RegExp _fontFamily = RegExp(r'''font-family\s*:\s*(?:'|&#039;|&quot;)?([^;'"&]+)(?:'|&#039;|&quot;)?''');

const _monoFonts = {'courier new', 'courier', 'consolas', 'lucida console', 'monaco', 'menlo', 'monospace'};
const _serifFonts = {'georgia', 'times new roman', 'times', 'book antiqua', 'palatino', 'palatino linotype', 'serif'};
const _appleSerifFonts = {'georgia', 'times new roman', 'times', 'palatino'};

/// The post's inline styles as this platform can draw them:
/// - `background: <colour>` as `background-color`, the only form
///   flutter_html reads (a forum's custom BBCode boxes lost their fill, and
///   their dark text became unreadable in the dark theme);
/// - XenForo's font menu (Courier New, Georgia, ...) as fonts the device
///   has: Android only has its generic `monospace` and `serif`.
@visibleForTesting
String platformStyles(String html, {required bool apple}) {
  if (!html.contains('style="')) return html;
  return html.replaceAllMapped(_styleAttribute, (m) {
    var style = m.group(1)!;
    style = style.replaceAllMapped(_backgroundShorthand, (b) => '${b.group(1)} background-color: ${b.group(2)}');
    style = style.replaceAllMapped(_fontFamily, (f) {
      final name = f.group(1)!.split(',').first.trim().toLowerCase();
      final String? font;
      if (_monoFonts.contains(name)) {
        font = apple ? 'Courier New' : 'monospace';
      } else if (_serifFonts.contains(name)) {
        font = apple ? (_appleSerifFonts.contains(name) ? f.group(1)!.trim() : 'Georgia') : 'serif';
      } else {
        font = null;
      }
      return font == null ? f.group(0)! : "font-family: '$font'";
    });
    return 'style="$style"';
  });
}

/// [child] with the block gap its element was left with (flutter_html draws
/// only the margins of the boxes it builds itself).
Widget _gap(ExtensionContext context, Widget child) {
  final gap = context.styledElement?.style.margin?.bottom?.value ?? 0;
  if (gap <= 0) return child;
  return Padding(padding: EdgeInsets.only(bottom: gap), child: child);
}

/// Inside a quote, whose fill a code block's or chip's own would vanish into.
bool _inQuote(dom.Node? node) => _hasAncestor(node, const {'blockquote'});

bool _hasAncestor(dom.Node? node, Set<String> names) {
  for (var p = node?.parent; p != null; p = p.parent) {
    if (names.contains(p.localName)) return true;
  }
  return false;
}

/// Keeps the block gap between blocks: the first block in a post, quote,
/// spoiler or table cell starts flush and the last ends flush (from
/// flarum_ui's PostBlockRhythmExtension).
class _BlockRhythm extends HtmlExtension {
  const _BlockRhythm();

  @override
  Set<String> get supportedTags => const {};

  @override
  bool matches(ExtensionContext context) {
    if (context.currentStep != CurrentStep.preProcessing) return false;
    return const {'body', 'blockquote', 'details', 'td', 'th', 'li'}.contains(context.elementName);
  }

  @override
  void beforeProcessing(ExtensionContext context) {
    final element = context.styledElement;
    if (element == null) return;
    for (var e = _edge(element, last: false); e != null; e = _edge(e, last: false)) {
      e.style.margin = (e.style.margin ?? const Margins()).copyWith(top: Margin.zero());
      if ((e.style.padding?.top?.value ?? 0) > 0) break;
    }
    for (var e = _edge(element, last: true); e != null; e = _edge(e, last: true)) {
      e.style.margin = (e.style.margin ?? const Margins()).copyWith(bottom: Margin.zero());
      if ((e.style.padding?.bottom?.value ?? 0) > 0) break;
    }
  }

  static StyledElement? _edge(StyledElement parent, {required bool last}) {
    for (final c in last ? parent.children.reversed : parent.children) {
      if (c is TextContentElement) {
        if ((c.text ?? '').trim().isEmpty) continue;
        return null;
      }
      if (c is EmptyContentElement || c.style.display == Display.none) continue;
      return c;
    }
    return null;
  }
}

/// A quote (`<blockquote data-quote-name>`) as a [QuoteBox]; a nested
/// quote is one more box inside it.
class _QuoteExtension extends HtmlExtension {
  const _QuoteExtension({required this.onOpenPost});

  /// Opens the quoted post: a tap on the header of a quote of a post.
  final void Function(String postId) onOpenPost;

  @override
  Set<String> get supportedTags => const {'blockquote'};

  @override
  StyledElement prepare(ExtensionContext context, List<StyledElement> children) =>
      context.parser.prepareFromExtension(context, children, extensionsToIgnore: {this});

  @override
  InlineSpan build(ExtensionContext context) {
    final name = (context.attributes['data-quote-name'] ?? '').trim();
    final quotedPost = context.attributes['data-quote-type'] == 'post' ? context.attributes['data-quote-id'] : null;
    final children = context.inlineSpanChildren ?? const <InlineSpan>[];
    return WidgetSpan(
      child: _gap(
        context,
        QuoteBox(
          name: name,
          onOpen: quotedPost == null ? null : () => onOpenPost(quotedPost),
          child: Text.rich(TextSpan(children: children)),
        ),
      ),
    );
  }
}

/// A spoiler (`<details data-spoiler>`): its title, opening to the hidden
/// part on a tap.
class _DetailsExtension extends HtmlExtension {
  const _DetailsExtension();

  @override
  Set<String> get supportedTags => const {'details'};

  @override
  InlineSpan build(ExtensionContext context) {
    final element = context.styledElement!;
    final built = context.builtChildrenMap ?? const {};
    StyledElement? summary;
    for (final c in element.children) {
      if (c.name == 'summary') {
        summary = c;
        break;
      }
    }
    final title = (context.attributes['data-spoiler-title'] ?? '').trim();
    final rest = [
      for (final c in element.children)
        if (c != summary && built[c] != null) built[c]!,
    ];
    return WidgetSpan(
      child: SizedBox(
        width: double.infinity,
        child: _gap(context, _SpoilerBlock(title: title, content: rest)),
      ),
    );
  }
}

class _SpoilerBlock extends StatefulWidget {
  const _SpoilerBlock({required this.title, required this.content});

  final String title;
  final List<InlineSpan> content;

  @override
  State<_SpoilerBlock> createState() => _SpoilerBlockState();
}

class _SpoilerBlockState extends State<_SpoilerBlock> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final label = widget.title.isNotEmpty ? '${l10n.spoiler}: ${widget.title}' : l10n.spoiler;
    return Material(
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        side: BorderSide(color: colorScheme.outlineVariant, width: DesignTokens.borderWidthThin),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            button: true,
            expanded: _open,
            child: InkWell(
              onTap: () => setState(() => _open = !_open),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.all(DesignTokens.spacingM),
                  child: Row(
                    children: [
                      Icon(_open ? Icons.expand_more : Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: DesignTokens.spacingS),
                      Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_open && widget.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(DesignTokens.spacingM, 0, DesignTokens.spacingM, DesignTokens.spacingM),
              child: Text.rich(TextSpan(children: widget.content)),
            ),
        ],
      ),
    );
  }
}

/// An inline spoiler (`<span data-inline-spoiler>`): blurred until tapped.
class _InlineSpoilerExtension extends HtmlExtension {
  const _InlineSpoilerExtension();

  @override
  Set<String> get supportedTags => const {};

  @override
  bool matches(ExtensionContext context) =>
      context.elementName == 'span' && context.attributes.containsKey('data-inline-spoiler');

  @override
  InlineSpan build(ExtensionContext context) => WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: _InlineSpoiler(child: Text.rich(TextSpan(children: context.inlineSpanChildren))),
      );
}

class _InlineSpoiler extends StatefulWidget {
  const _InlineSpoiler({required this.child});
  final Widget child;

  @override
  State<_InlineSpoiler> createState() => _InlineSpoilerState();
}

class _InlineSpoilerState extends State<_InlineSpoiler> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    if (_revealed) return widget.child;
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).spoiler,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _revealed = true),
        child: ClipRect(
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: IgnorePointer(child: widget.child),
          ),
        ),
      ),
    );
  }
}

/// `<table>`: flutter_html 3 draws none. The cells, built by flutter_html like
/// the rest of the post, laid out with Flutter's Table, scrolling sideways
/// when wider than the post.
class _TableExtension extends HtmlExtension {
  const _TableExtension({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Set<String> get supportedTags => const {'table'};

  @override
  InlineSpan build(ExtensionContext context) {
    final table = context.element;
    if (table == null) return const TextSpan();
    final rows = table.querySelectorAll('tr');
    if (rows.isEmpty) return const TextSpan();
    final columns = rows.map((r) => r.children.where((c) => c.localName == 'td' || c.localName == 'th').length).fold<int>(0, (a, b) => a > b ? a : b);
    if (columns == 0) return const TextSpan();
    final border = BorderSide(color: colorScheme.outlineVariant, width: DesignTokens.borderWidthThin);
    return WidgetSpan(
      child: _gap(
        context,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            border: TableBorder(top: border, bottom: border, left: border, right: border, horizontalInside: border, verticalInside: border),
            children: [
              for (final row in rows)
                TableRow(
                  children: [
                    for (var i = 0; i < columns; i++)
                      _cell(row.children.where((c) => c.localName == 'td' || c.localName == 'th').elementAtOrNull(i)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cell(dom.Element? cell) {
    if (cell == null) return const SizedBox.shrink();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingS, vertical: DesignTokens.spacingXS),
        child: Html(
          data: cell.innerHtml,
          shrinkWrap: true,
          style: {
            'body': Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontWeight: cell.localName == 'th' ? FontWeight.w600 : null,
            ),
          },
        ),
      ),
    );
  }
}

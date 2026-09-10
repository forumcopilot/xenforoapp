// [ATTACH] tags on forums migrated from vBulletin carry a `.vB` suffix
// (`[ATTACH]92631.vB[/ATTACH]`), left there by XenForo's importer. XenForo's
// own renderer reads the leading integer and shows the attachment; the app
// must do the same, or every such tag renders as a nameless "0 B" card even
// though the API returned the attachment in full.

import 'package:flutter/material.dart';
import 'package:flutter_bbcode/flutter_bbcode.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'package:forumcopilot_flutter/views/widgets/cached_redirect_image.dart';
import 'package:forumcopilot_flutter/views/widgets/custom_bb_stylesheet.dart';

SiteContext _siteContext() => SiteContext(
      siteType: 'xenforo',
      site: Site(
        id: 1,
        name: 'Test',
        url: 'https://example.com',
        description: '',
        endpoint: 'forumcopilot.php',
        baseUrl: 'https://example.com',
        siteType: 'xenforo',
      ),
    );

/// An image attachment as the add-on returns it: id `92631`, full metadata.
FCAttachment _photo() {
  final att = FCAttachment(
    id: '92631',
    filename: 'img_0483.jpg',
    fileSize: 858652,
    url: 'https://example.com/attachments/img_0483-jpg.92631/',
    isImage: true,
  );
  att.thumbnailUrl = 'https://example.com/data/attachments/73/73930.jpg';
  att.canViewUrl = true;
  att.canViewThumbnailUrl = true;
  att.isInline = true;
  return att;
}

Future<void> _pump(WidgetTester tester, String bbcode) async {
  final att = _photo();
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => BBCodeText(
          data: bbcode,
          stylesheet: CustomBBStylesheet(
            siteContext: _siteContext(),
            context: context,
            contentId: '3304959',
            callbacks: BBCodeCallbacks(
              inlineAttachments: [att],
              attachments: [att],
            ),
          ),
        ),
      ),
    ),
  ));
  await tester.pump();
}

void main() {
  testWidgets('a bare [ATTACH] id resolves to the attachment image',
      (tester) async {
    await _pump(tester, '[ATTACH]92631[/ATTACH]');
    expect(find.byType(CachedRedirectImage), findsOneWidget);
    expect(find.text('Inline Attachments'), findsNothing);
  });

  testWidgets('a vBulletin-import [ATTACH] id (92631.vB) resolves the same way',
      (tester) async {
    await _pump(tester, '[ATTACH]92631.vB[/ATTACH]');
    expect(find.byType(CachedRedirectImage), findsOneWidget,
        reason: 'the leading integer names the attachment, as on the website');
    expect(find.text('Inline Attachments'), findsNothing,
        reason: 'no placeholder card for an attachment the API returned');
  });

  testWidgets('an id that is not an attachment still falls back',
      (tester) async {
    await _pump(tester, '[ATTACH]99999.vB[/ATTACH]');
    expect(find.byType(CachedRedirectImage), findsNothing);
  });
}

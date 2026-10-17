import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/utils/l10n_now.dart';
import 'package:get/get.dart';

/// Messages with counts and names render in every language: plural rules
/// (Russian has one/few/many) pick a form, and no placeholder is left as
/// `{name}` in what the reader sees.
void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    test('$locale: counts and names fill in', () {
      final l10n = lookupAppLocalizations(locale);
      final rendered = <String>[
        for (final n in [0, 1, 2, 5, 21, 112]) ...[
          l10n.participantCount(n),
          l10n.thanksCountLabel(n),
          l10n.filesReadyToAttach(n),
          l10n.onlyMoreAttachmentsAllowed(n),
          l10n.minimumAge(n),
          l10n.imagesCount(n),
          l10n.messagePositionOf(n, n + 1),
        ],
        l10n.iAcceptTheDocument(l10n.termsOfService),
        l10n.areYouSureUnban('Jane'),
        l10n.connectionTimedOutTo('Test Forum'),
        l10n.errorFeatureNotAvailable('Passkeys'),
        l10n.compressQuality(85),
        l10n.sizeReduction('42.0'),
        l10n.postsCountFormatted('12.3K'),
        l10n.translatedFromTo('Deutsch', '日本語'),
        l10n.pushEnabledFor('Test Forum'),
        l10n.fileTypeNotAllowed('heic', 'jpg, png'),
        l10n.fileSizeExceedsMaximum('12 MB', '5 MB'),
        l10n.cannotAccessImageFile('EACCES'),
        l10n.failedToOptimizeImage('bad data'),
      ];
      for (final text in rendered) {
        expect(text, isNot(contains('{')), reason: text);
        expect(text.trim(), isNotEmpty);
      }
      expect(l10n.participantCount(21), contains('21'));
      expect(l10n.iAcceptTheDocument(l10n.termsOfService), contains(l10n.termsOfService));
    });
  }

  group('l10nNow (code without a BuildContext)', () {
    tearDown(() => Get.locale = null);

    test('follows the app language', () {
      Get.locale = const Locale('de');
      expect(l10nNow().unableToOpenNotification, lookupAppLocalizations(const Locale('de')).unableToOpenNotification);
    });

    test('falls back to English for a language the app does not have', () {
      Get.locale = const Locale('sv');
      expect(l10nNow().unableToOpenNotification, 'Unable to open notification');
    });
  });

  test('the document link can sit anywhere in the sentence', () {
    // Japanese puts it first, English last; the page splits around it.
    const marker = '\u0000';
    final ja = lookupAppLocalizations(const Locale('ja')).iAcceptTheDocument(marker).split(marker);
    final en = lookupAppLocalizations(const Locale('en')).iAcceptTheDocument(marker).split(marker);
    expect(ja.first, isEmpty);
    expect(en.first, 'I accept the ');
    expect(en.last, isEmpty);
  });
}

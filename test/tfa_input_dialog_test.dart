import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/dialogs/tfa_input_dialog.dart';
import 'package:forumcopilot_sdk/models/entities/fc_tfa_provider.dart';
import 'package:get/get.dart';

/// The two-step verification screen, after a review on a Pixel 4a.
void main() {
  final providers = [
    FCTFAProvider(id: 'passkey', title: 'Passkeys', description: 'Use a passkey.', type: 'passkey'),
    FCTFAProvider(id: 'totp', title: 'Verification code via app', description: 'A code from an app.'),
    FCTFAProvider(id: 'backup', title: 'Backup codes', description: 'One of your backup codes.'),
  ];

  Future<List<TFADialogResult?>> open(WidgetTester tester, {String defaultProviderId = 'totp'}) async {
    final results = <TFADialogResult?>[];
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(GetMaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async =>
              results.add(await TFAInputDialog.show(providers: providers, defaultProviderId: defaultProviderId)),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return results;
  }

  testWidgets('one title, and a full-width button', (tester) async {
    // Tests run where passkeys are unsupported, so the passkey option is
    // left out, as on such a device.
    await open(tester, defaultProviderId: 'passkey');
    expect(find.text('Passkeys'), findsNothing);
    expect(find.text('Two-Factor Authentication'), findsOneWidget);
    final button = tester.getSize(find.widgetWithText(FilledButton, 'Verify'));
    expect(button.width, greaterThan(300), reason: 'it shrank to its label');
  });

  testWidgets('a complete code is sent at once, trusting the device by default', (tester) async {
    final results = await open(tester);
    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.pumpAndSettle();
    expect(results, hasLength(1));
    expect(results.single!.code, '123456');
    expect(results.single!.provider, 'totp');
    expect(results.single!.trustDevice, isTrue);
  });

  testWidgets('trust can be turned off; a backup code waits for its nine digits', (tester) async {
    final results = await open(tester);
    await tester.tap(find.text('Backup codes'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(SwitchListTile));
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.pumpAndSettle();
    expect(results, isEmpty, reason: 'six digits are not a backup code');
    await tester.enterText(find.byType(TextFormField), '123456789');
    await tester.pumpAndSettle();
    expect(results.single!.provider, 'backup');
    expect(results.single!.trustDevice, isFalse);
  });

  testWidgets('dragging after the keyboard closes raises nothing', (tester) async {
    await open(tester);
    tester.view.viewInsets = const FakeViewPadding(bottom: 800);
    await tester.pumpAndSettle();
    final gesture = await tester.startGesture(tester.getCenter(find.text('Backup codes')));
    await gesture.moveBy(const Offset(0, -40));
    tester.view.resetViewInsets();
    await tester.pump();
    await gesture.moveBy(const Offset(0, -40));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

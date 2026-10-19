import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The iOS app keeps its passkey domains twice: in its entitlements, where
/// iOS reads them, and in Info.plist (`AssociatedDomainsList`), where the
/// login page's own check reads them (an iOS app cannot read its
/// entitlements). A domain added to one only turns off Sign in with Passkey
/// ("code: 3") while iOS itself allows it; this happened in the official app.
void main() {
  List<String> domains(String path, String key) {
    final plist = File(path).readAsStringSync();
    final array = RegExp('<key>${RegExp.escape(key)}</key>\\s*<array>(.*?)</array>', dotAll: true).firstMatch(plist);
    expect(array, isNotNull, reason: '$key in $path');
    return [for (final m in RegExp('<string>([^<]*)</string>').allMatches(array!.group(1)!)) m.group(1)!]..sort();
  }

  test('Info.plist lists the same passkey domains as the entitlements', () {
    final entitled = domains('ios/Runner/Runner.entitlements', 'com.apple.developer.associated-domains');
    expect(entitled, isNotEmpty);
    expect(domains('ios/Runner/Info.plist', 'AssociatedDomainsList'), entitled);
  });
}

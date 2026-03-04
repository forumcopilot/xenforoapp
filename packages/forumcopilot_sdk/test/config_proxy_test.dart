import 'package:test/test.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCConfigProxy interface
///
/// These tests verify that all methods return result: true
void runConfigProxyTests(IFCConfigProxy configProxy, TestConfig config) {
  group('IFCConfigProxy Tests', () {
    late ProxyTestHelper helper;

    setUp(() {
      helper = ProxyTestHelper(config);
    });

    test('getConfig returns result: true', () async {
      final result = await configProxy.getConfig(config.testUrl, forceRefresh: false);
      helper.assertResultTrue(result, 'getConfig');
    });

    test('getConfig with forceRefresh returns result: true', () async {
      final result = await configProxy.getConfig(config.testUrl, forceRefresh: true);
      helper.assertResultTrue(result, 'getConfig with forceRefresh');
    });
  });
}

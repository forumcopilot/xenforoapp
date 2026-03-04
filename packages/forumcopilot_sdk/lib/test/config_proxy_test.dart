import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCConfigProxy interface
///
/// These tests verify that getConfig returns a valid configuration
void runConfigProxyTests(IFCConfigProxy configProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCConfigProxy');

  test('getConfig returns valid configuration', () async {
    final testName = 'getConfig returns valid configuration';
    try {
      final result = await configProxy.getConfig(config.testUrl, forceRefresh: false);
      expect(result, isNotNull, reason: 'getConfig should return a non-null result');
      expect(result.version, isNotEmpty, reason: 'getConfig should return a valid version');
      helper.tracker.recordSuccess(testName, proxyName: 'IFCConfigProxy', methodName: 'getConfig');
    } catch (e) {
      helper.tracker.recordFailure(testName, proxyName: 'IFCConfigProxy', methodName: 'getConfig', errorMessage: e.toString());
      rethrow;
    }
  });

  test('getConfig with forceRefresh returns valid configuration', () async {
    final testName = 'getConfig with forceRefresh returns valid configuration';
    try {
      final result = await configProxy.getConfig(config.testUrl, forceRefresh: true);
      expect(result, isNotNull, reason: 'getConfig with forceRefresh should return a non-null result');
      expect(result.version, isNotEmpty, reason: 'getConfig with forceRefresh should return a valid version');
      helper.tracker.recordSuccess(testName, proxyName: 'IFCConfigProxy', methodName: 'getConfig');
    } catch (e) {
      helper.tracker.recordFailure(testName, proxyName: 'IFCConfigProxy', methodName: 'getConfig', errorMessage: e.toString());
      rethrow;
    }
  });
}

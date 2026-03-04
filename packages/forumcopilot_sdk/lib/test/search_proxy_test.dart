import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCSearchProxy interface
/// 
/// These tests verify that all methods return result: true
void runSearchProxyTests(IFCSearchProxy searchProxy, IFCForumProxy forumProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCSearchProxy');

  test('searchTopicAsync returns result: true', () async {
      final testName = 'searchTopicAsync returns result: true';
      final result = await searchProxy.searchTopicAsync('test', 0, 10, null);
      helper.assertResultTrue(result, 'searchTopicAsync', testName: testName);
    });

    test('searchPostAsync returns result: true', () async {
      final testName = 'searchPostAsync returns result: true';
      final result = await searchProxy.searchPostAsync('test', 0, 10, null);
      helper.assertResultTrue(result, 'searchPostAsync', testName: testName);
    });

    test('advanceSearchPostAsync returns result: true', () async {
      final testName = 'advanceSearchPostAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await searchProxy.advanceSearchPostAsync(
        'test',
        1,
        20,
        null,
        false,
        null,
        null,
        forumId,
        null,
        null,
        null,
        false,
      );
      helper.assertResultTrue(result, 'advanceSearchPostAsync', testName: testName);
    });

    test('advanceSearchTopicAsync returns result: true', () async {
      final testName = 'advanceSearchTopicAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await searchProxy.advanceSearchTopicAsync(
        'test',
        1,
        20,
        null,
        false,
        null,
        null,
        forumId,
        null,
        null,
        null,
        false,
        null,
      );
      helper.assertResultTrue(result, 'advanceSearchTopicAsync', testName: testName);
    });
}


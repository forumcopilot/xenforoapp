/// Test result status codes
enum TestStatus {
  ok,
  noOk,
  error500,
  error403,
  notImplemented,
  skipped,
}

/// Test result information
class TestResult {
  final String testName;
  final String? proxyName;
  final String? methodName;
  final TestStatus status;
  final String? errorMessage;

  TestResult({
    required this.testName,
    this.proxyName,
    this.methodName,
    required this.status,
    this.errorMessage,
  });

  String get statusCode {
    switch (status) {
      case TestStatus.ok:
        return 'OK';
      case TestStatus.noOk:
        return 'NO';
      case TestStatus.error500:
        return '500';
      case TestStatus.error403:
        return '403';
      case TestStatus.notImplemented:
        return 'NI';
      case TestStatus.skipped:
        return 'SKIP';
    }
  }
}

/// Global test result tracker
class TestResultTracker {
  static final TestResultTracker _instance = TestResultTracker._internal();
  factory TestResultTracker() => _instance;
  TestResultTracker._internal();

  final List<TestResult> _results = [];

  /// Record a test result
  void recordResult(TestResult result) {
    _results.add(result);
  }

  /// Record a successful test
  void recordSuccess(String testName, {String? proxyName, String? methodName}) {
    recordResult(TestResult(
      testName: testName,
      proxyName: proxyName,
      methodName: methodName,
      status: TestStatus.ok,
    ));
  }

  /// Record a failed test
  void recordFailure(String testName,
      {String? proxyName, String? methodName, String? errorMessage}) {
    TestStatus status = TestStatus.noOk;
    
    // Detect specific error types
    if (errorMessage != null) {
      if (errorMessage.contains('status 500') || 
          errorMessage.contains('API request failed with status 500')) {
        status = TestStatus.error500;
      } else if (errorMessage.contains('403') ||
          errorMessage.contains('Forbidden') ||
          errorMessage.contains('permission') ||
          errorMessage.contains('Cannot')) {
        status = TestStatus.error403;
      } else if (errorMessage.contains('UnimplementedError') ||
          errorMessage.contains('not implemented')) {
        status = TestStatus.notImplemented;
      }
    }

    recordResult(TestResult(
      testName: testName,
      proxyName: proxyName,
      methodName: methodName,
      status: status,
      errorMessage: errorMessage,
    ));
  }

  /// Record a skipped test
  void recordSkipped(String testName, {String? proxyName, String? methodName, String? reason}) {
    recordResult(TestResult(
      testName: testName,
      proxyName: proxyName,
      methodName: methodName,
      status: TestStatus.skipped,
      errorMessage: reason,
    ));
  }

  /// Record a not implemented test
  void recordNotImplemented(String testName, {String? proxyName, String? methodName}) {
    recordResult(TestResult(
      testName: testName,
      proxyName: proxyName,
      methodName: methodName,
      status: TestStatus.notImplemented,
    ));
  }

  /// Get all results
  List<TestResult> get results => List.unmodifiable(_results);

  /// Clear all results
  void clear() {
    _results.clear();
  }

  /// Generate summary table
  void printSummary() {
    if (_results.isEmpty) {
      print('\n📊 No test results to display');
      return;
    }

    print('\n' + '=' * 80);
    print('📊 TEST SUMMARY TABLE');
    print('=' * 80);

    // Calculate column widths
    int maxTestName = _results.map((r) => r.testName.length).reduce((a, b) => a > b ? a : b);
    maxTestName = maxTestName > 60 ? maxTestName : 60;
    
    // Check if we have proxy names
    final hasProxyNames = _results.any((r) => r.proxyName != null && r.proxyName!.isNotEmpty);
    
    int maxProxy = 0;
    if (hasProxyNames) {
      maxProxy = _results
          .where((r) => r.proxyName != null && r.proxyName!.isNotEmpty)
          .map((r) => r.proxyName!.length)
          .fold(0, (a, b) => a > b ? a : b);
      maxProxy = maxProxy > 25 ? maxProxy : 25;
    }

    // Header
    if (hasProxyNames) {
      print('│ ${'Test Name'.padRight(maxTestName)} │ ${'Proxy'.padRight(maxProxy)} │ Status │');
      print('│${'-' * (maxTestName + 2)}│${'-' * (maxProxy + 2)}│${'-' * 8}│');
    } else {
      print('│ ${'Test Name'.padRight(maxTestName)} │ Status │');
      print('│${'-' * (maxTestName + 2)}│${'-' * 8}│');
    }

    // Results
    for (final result in _results) {
      final testName = result.testName.length > maxTestName
          ? result.testName.substring(0, maxTestName - 3) + '...'
          : result.testName;
      
      if (hasProxyNames) {
        final proxyName = result.proxyName ?? '';
        print('│ ${testName.padRight(maxTestName)} │ ${proxyName.padRight(maxProxy)} │ ${result.statusCode.padLeft(6)} │');
      } else {
        print('│ ${testName.padRight(maxTestName)} │ ${result.statusCode.padLeft(6)} │');
      }
    }

    print('=' * 80);

    // Statistics
    final stats = _calculateStats();
    print('\n📈 STATISTICS:');
    print('   ✅ OK:        ${stats[TestStatus.ok]}');
    print('   ❌ NO OK:     ${stats[TestStatus.noOk]}');
    print('   🔴 500:       ${stats[TestStatus.error500]}');
    print('   🚫 403:       ${stats[TestStatus.error403]}');
    print('   ⚠️  NI:       ${stats[TestStatus.notImplemented]}');
    print('   ⏭️  SKIP:     ${stats[TestStatus.skipped]}');
    print('   📊 TOTAL:     ${_results.length}');
    print('=' * 80 + '\n');
  }

  Map<TestStatus, int> _calculateStats() {
    final stats = <TestStatus, int>{};
    for (final status in TestStatus.values) {
      stats[status] = _results.where((r) => r.status == status).length;
    }
    return stats;
  }
}


import 'package:dart_mappable/dart_mappable.dart';

part 'fc_base_result.mapper.dart';

/// Base class for all Forum Copilot API results
/// Contains common fields that all results share
@MappableClass()
abstract class FCBaseResult with FCBaseResultMappable {
  /// Whether the operation was successful
  bool result;

  /// Result message or error text (only present when result = false)
  String? resultText;

  FCBaseResult({
    required this.result,
    this.resultText,
  });
}

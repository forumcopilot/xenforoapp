/// Generic API exception for network operations
class FCApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? responseBody;

  FCApiException(this.message, {this.statusCode, this.responseBody});

  @override
  String toString() => 'FCApiException: $message';
}

class FCSessionExpiredException implements Exception {
  final String message;

  FCSessionExpiredException([this.message = "Your session has expired. Please log in again."]);

  @override
  String toString() => message;
}

/// Generic HTTP call result
/// Contains response data, headers, cookies, and status information
class FCCallResult {
  int statusCode;
  String body;
  bool fcIsLogin;
  Map<String, String> headers;
  Map<String, String> cookies;

  FCCallResult({
    this.statusCode = 0,
    this.body = '',
    Map<String, String>? headers,
    Map<String, String>? cookies,
    this.fcIsLogin = false,
  })  : headers = headers ?? {},
        cookies = cookies ?? {};

  /// Whether the reply says anything about the session: only the forum's
  /// add-on sends fc_is_login. A request that never reached the forum
  /// (status 0) or an error page from a proxy in between has no such header,
  /// and its [fcIsLogin] false means "unknown", not "signed out".
  bool get hasLoginHeader => headers.keys.any((k) => k.toLowerCase() == 'fc_is_login');

  @override
  String toString() {
    var sb = StringBuffer();
    for (var header in headers.entries) {
      sb.writeln('${header.key}: ${header.value}');
    }
    sb.writeln();
    sb.writeln(body);
    return sb.toString();
  }
}

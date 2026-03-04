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

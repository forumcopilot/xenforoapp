import 'package:flutter/foundation.dart';

/// Debug-only logging for xenforo_core.
///
/// `print` and `debugPrint` both reach the device log in release builds. This
/// package used `print` for every request parameter (the sign-in password
/// included) and every pretty-printed API response, so release builds wrote
/// passwords, private messages and account data to logcat / os_log. Nothing
/// logged through here appears outside debug builds.
void xfDebug(Object? message) {
  if (kDebugMode) debugPrint('$message');
}

/// Request parameter names whose values are never logged, not even in debug
/// builds (compared case-insensitively, ignoring `_` and `-`).
const Set<String> _secretParams = {
  'password',
  'passwordconfirm',
  'oldpassword',
  'newpassword',
  'currentpassword',
  'tfacode',
  'code',
  'token',
  'trustcode',
  'webauthnpayload',
  'webauthnchallenge',
  'apikey',
  'secret',
};

/// Whether a request parameter named [key] carries a secret.
bool xfIsSecretParam(String key) =>
    _secretParams.contains(key.toLowerCase().replaceAll(RegExp('[_-]'), ''));

/// [value] as it may appear in a debug log line for parameter [key]: secrets
/// masked, long text shortened, lists summarised.
String xfLoggableParam(String key, Object? value) {
  if (value == null) return 'null';
  if (xfIsSecretParam(key)) return '<redacted>';
  if (value is String) {
    return value.length > 100
        ? '"${value.substring(0, 100)}…" (${value.length} chars)'
        : '"$value"';
  }
  if (value is List) return 'List with ${value.length} items';
  if (value is Map) return 'Map with ${value.length} keys';
  return '$value';
}

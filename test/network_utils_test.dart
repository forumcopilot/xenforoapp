import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/utils/network_utils.dart';

/// A send that never reached the forum gets a network message, not the
/// transport error the proxy put in the result text.
void main() {
  test('transport failures are recognised', () {
    for (final text in [
      'Error replying to conversation: Exception: API request failed with status 0: '
          '{"error":"The connection errored: Connection refused","type":"DioExceptionType.connectionError"}',
      'SocketException: Failed host lookup: forum.example (OS Error: No address associated with hostname)',
      'DioException [connection timeout]: The request connection took longer than 0:00:30.000000',
      'HandshakeException: Connection terminated during handshake',
    ]) {
      expect(NetworkUtils.isUnreachable(text), isTrue, reason: text);
    }
  });

  test("the forum's own messages are not", () {
    for (final text in [
      null,
      '',
      'You must wait at least 30 seconds before performing this action.',
      'Please enter a valid message.',
      'API request failed with status 500: Internal Server Error',
      'This conversation is closed (status 0f the thread)',
    ]) {
      expect(NetworkUtils.isUnreachable(text), isFalse, reason: text);
    }
  });
}

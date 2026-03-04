/// Passkey challenge result for passkey authentication flows
class FCPasskeyChallengeResult {
  /// Whether the operation was successful
  final bool result;

  /// Result message or error text (only present when result = false)
  final String? resultText;

  /// Base64url-encoded challenge
  final String? challenge;

  /// Relying party ID
  final String? rpId;

  /// Timeout in milliseconds
  final int? timeout;

  FCPasskeyChallengeResult({
    required this.result,
    this.resultText,
    this.challenge,
    this.rpId,
    this.timeout,
  });
}

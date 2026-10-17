import '../models/results/fc_user_result.dart';

/// A user proxy that can finish signing in through the forum's website
/// (any way the website signs members in: Google, Facebook, passkeys,
/// two-step). The app opens the forum's sign-in page in the system browser
/// sheet with a PKCE challenge; the page hands back a one-time code, which
/// this redeems with the verifier. Optional: check with `is`.
abstract class IFCBrowserLogin {
  /// Signs this forum's session in with [code] from the website and the PKCE
  /// [verifier] behind the challenge sent with the request.
  Future<FCLoginResult> completeBrowserLoginAsync({required String code, required String verifier});
}

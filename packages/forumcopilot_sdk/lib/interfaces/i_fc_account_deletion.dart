import '../models/results/fc_account_result.dart';

/// An account proxy that can delete the signed-in member's own account
/// (apps that let people sign up must let them delete the account in the
/// app too). Optional: a forum type supports it when its account proxy also
/// implements this; check with `is`.
abstract class IFCAccountDeletion {
  /// Deletes the signed-in member's account, confirmed with their
  /// [password], or with their [username] for an account without one. The
  /// forum signs the session out.
  Future<FCDeleteAccountResult> deleteAccount({String? password, String? username});
}

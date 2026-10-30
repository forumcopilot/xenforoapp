/// A config proxy that can close one of the forum's notices for the member
/// for good, as the close button on the website does. Optional: a forum type
/// supports it when its config proxy also implements this; check with `is`.
abstract class IFCNoticeDismissal {
  /// Closes notice [noticeId] (one of FCConfigResult.notices that is
  /// dismissible). Returns whether the forum did.
  Future<bool> dismissNoticeAsync(int noticeId);
}

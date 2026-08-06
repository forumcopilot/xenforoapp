import '../models/results/fc_group_result.dart';

/// Group operations exposed to the app (Discourse: bundles of users
/// with shared permissions).
///
/// Phase 5.40 — promoted out of `DiscourseGroupProxy.forCurrentSite()`
/// sidecar onto a proper IFC proxy.
///
/// Discourse endpoints used by the reference implementation:
///   * `GET    /groups.json`                       — directory of groups
///   * `GET    /groups/{name}.json`                — single group
///   * `GET    /groups/{name}/members.json`        — paginated members
///   * `PUT    /groups/{id}/join.json`             — self-join (Phase 5.44)
///   * `DELETE /groups/{id}/leave.json`            — self-leave (Phase 5.44)
///   * `POST   /groups/{name}/request_membership.json` — request (5.44)
abstract class IFCGroupProxy {
  /// List a page of groups (1-indexed).
  Future<FCGroupListResult> getGroupsAsync({int page = 1});

  /// Fetch a single group by slug name (`team`, `moderators`,
  /// `trust_level_2`).
  Future<FCGroupResult> getGroupAsync(String name);

  /// List the members of a group. [limit] caps the page size
  /// (Discourse accepts up to 200).
  Future<FCGroupMembersResult> getGroupMembersAsync(
    String name, {
    int offset = 0,
    int limit = 50,
  });

  /// Join the group identified by its numeric [groupId]. Only valid
  /// when the group's `publicAdmission` flag is set — backends reject
  /// the call otherwise. Rate-limited server-side (Discourse: 3/min
  /// for non-staff).
  Future<FCGroupMembershipResult> joinGroupAsync(int groupId);

  /// Leave the group identified by its numeric [groupId]. Only valid
  /// when the group's `publicExit` flag is set.
  Future<FCGroupMembershipResult> leaveGroupAsync(int groupId);

  /// Ask to join a request-to-join group ([FCGroup.allowMembershipRequests]).
  /// Discourse keys this endpoint on the group *name*, not id, and
  /// requires a non-empty [reason] shown to the approving admins.
  Future<FCGroupMembershipResult> requestMembershipAsync(
    String groupName,
    String reason,
  );
}

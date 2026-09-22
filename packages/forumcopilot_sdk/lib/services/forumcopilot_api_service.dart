import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:forumcopilot_sdk/network/fc_web_call_info.dart';
import '../models/domain/site.dart';
import '../network/fc_web_call.dart';
import '../network/fc_call_result.dart';

/// Centralized service for all ForumCopilot API calls
class ForumCopilotApiService {
  /// Production by default. Override for local development without editing this
  /// file, so the pointer cannot be committed or shipped by accident:
  ///
  ///   flutter run --dart-define=FC_API_BASE_URL=http://localhost:8082/api
  ///   flutter build apk --debug --dart-define=FC_API_BASE_URL=http://localhost:8082/api
  ///
  /// Reaching a host-machine backend from a device needs `adb reverse tcp:8082 tcp:8082`
  /// (emulators can use http://10.0.2.2:8082/api instead). Cleartext HTTP to loopback is
  /// permitted in debug builds only — see android/app/src/debug/res/xml/network_security_config.xml.
  static const String _baseUrl = String.fromEnvironment(
    'FC_API_BASE_URL',
    defaultValue: 'https://forumcopilot.com/api',
  );

  /// Fetches updated site information from the server by IDs
  static Future<List<Site>> getSitesByIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    try {
      final idsParam = ids.join(',');
      final uri = Uri.parse('$_baseUrl/get-sites-by-ids?ids=$idsParam');

      if (kDebugMode) {
        print('ForumCopilotApiService: GET ' + uri.toString());
      }

      final response = await _makeHttpCall(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List sitesJson = data['sites'] ?? [];

        return sitesJson.map<Site>((siteJson) => _siteFromApiJson(siteJson)).toList();
      } else {
        print('ForumCopilotApiService: API error ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('ForumCopilotApiService: Error fetching sites by IDs: $e');
      return [];
    }
  }

  /// Fetches explore sites from the server
  static Future<List<Site>> getExploreSites({
    required String language,
    required String country,
    bool debug = false,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/explore?language=$language&country=$country&debug=${debug ? 'true' : 'false'}');

      if (kDebugMode) {
        print('ForumCopilotApiService: GET ' + uri.toString());
      }

      final response = await _makeHttpCall(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List sitesJson = data['sites'] ?? [];

        return sitesJson.map<Site>((f) => _siteFromApiJson(f)).toList();
      } else {
        print('ForumCopilotApiService: Explore API error ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('ForumCopilotApiService: Error fetching explore sites: $e');
      return [];
    }
  }

  /// Searches sites from the server
  static Future<List<Site>> searchSites({
    required String query,
    required String language,
    required String country,
    bool debug = false,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/search-sites?q=${Uri.encodeComponent(query)}&language=$language&country=$country&debug=${debug ? 'true' : 'false'}');

      if (kDebugMode) {
        print('ForumCopilotApiService: GET ' + uri.toString());
      }

      final response = await _makeHttpCall(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List sitesJson = data['sites'] ?? [];

        return sitesJson.map<Site>((f) => _siteFromApiJson(f)).toList();
      } else {
        print('ForumCopilotApiService: Search API error ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('ForumCopilotApiService: Error searching sites: $e');
      return [];
    }
  }

  /// Fetches YouTube video data from the server
  static Future<Map<String, dynamic>?> getYouTubeVideoData(String videoId) async {
    try {
      final uri = Uri.parse('$_baseUrl/youtube?id=$videoId');

      if (kDebugMode) {
        print('ForumCopilotApiService: GET ' + uri.toString());
      }

      final response = await _makeHttpCall(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('ForumCopilotApiService: YouTube API error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('ForumCopilotApiService: Error fetching YouTube video data: $e');
      return null;
    }
  }

  /// Fetches Twitter tweet data from the server
  static Future<Map<String, dynamic>?> getTwitterTweetData(String tweetId) async {
    try {
      final uri = Uri.parse('$_baseUrl/twitter?id=$tweetId');

      if (kDebugMode) {
        print('ForumCopilotApiService: GET ' + uri.toString());
      }

      final response = await _makeHttpCall(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('ForumCopilotApiService: Twitter API error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('ForumCopilotApiService: Error fetching Twitter tweet data: $e');
      return null;
    }
  }

  /// Hands a notifications-scoped Discourse User API Key to the ForumCopilot backend,
  /// which polls the forum on this user's behalf and delivers what arrives.
  ///
  /// This is the fallback for forums whose owner has not allowlisted our push URL —
  /// Discourse will not push to us there, so nothing would ever reach the device. The
  /// key grants four routes (list notifications, totals, mark read, message bus) and
  /// cannot post or read messages.
  ///
  /// The server probes the forum with the key before storing it, so a 400 here means the
  /// forum rejected it, not that the request was malformed. Returns false on any failure;
  /// the caller has already completed the grant either way, so this is not fatal.
  static Future<bool> registerDiscourseNotificationKey({
    required int siteId,
    required String siteUrl,
    required String clientId,
    required String userApiKey,
    int? discourseUserId,
    String? discourseUsername,
    String? deviceToken,
    String? devicePlatform,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/discourse/notification-key');
      final body = jsonEncode({
        'site_id': siteId,
        'site_url': siteUrl,
        'client_id': clientId,
        'user_api_key': userApiKey,
        if (discourseUserId != null) 'discourse_user_id': discourseUserId,
        if (discourseUsername != null) 'discourse_username': discourseUsername,
        if (deviceToken != null) 'device_token': deviceToken,
        if (devicePlatform != null) 'device_platform': devicePlatform,
      });

      if (kDebugMode) {
        // Never log the body — it carries the key.
        print('ForumCopilotApiService: POST ' + uri.toString());
      }

      final response = await FCWebCall.makeHttpCall(
        uri.toString(),
        'POST',
        body,
        'application/json',
        FCWebCallInfo(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      print('ForumCopilotApiService: notification key rejected '
          '${response.statusCode}: ${response.body}');
      return false;
    } catch (e) {
      print('ForumCopilotApiService: Error registering notification key: $e');
      return false;
    }
  }

  /// Points a stored notifications grant at this device's current FCM token.
  ///
  /// Must be called separately from [registerDiscourseNotificationKey], and repeatedly:
  /// FCM initialization is often still in flight when the user approves the grant, and
  /// FCM rotates tokens afterwards. A token captured once at grant time goes stale and
  /// push stops with nothing to show for it.
  ///
  /// A false return usually just means no grant is stored for this forum, which is the
  /// normal case for most forums the user visits.
  static Future<bool> updateDiscourseNotificationDevice({
    required int siteId,
    required String clientId,
    required String deviceToken,
    String? devicePlatform,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/discourse/notification-key/device');
      final body = jsonEncode({
        'site_id': siteId,
        'client_id': clientId,
        'device_token': deviceToken,
        if (devicePlatform != null) 'device_platform': devicePlatform,
      });

      final response = await FCWebCall.makeHttpCall(
        uri.toString(),
        'POST',
        body,
        'application/json',
        FCWebCallInfo(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('ForumCopilotApiService: Error updating notification device token: $e');
      return false;
    }
  }

  /// Stops server-side polling for this install on this forum — call on sign-out.
  ///
  /// Identified by (siteId, clientId) rather than the key, because by sign-out the app
  /// has already discarded the key.
  static Future<bool> revokeDiscourseNotificationKey({
    required int siteId,
    required String clientId,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/discourse/notification-key');
      final body = jsonEncode({'site_id': siteId, 'client_id': clientId});

      if (kDebugMode) {
        print('ForumCopilotApiService: DELETE ' + uri.toString());
      }

      final response = await FCWebCall.makeHttpCall(
        uri.toString(),
        'DELETE',
        body,
        'application/json',
        FCWebCallInfo(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('ForumCopilotApiService: Error revoking notification key: $e');
      return false;
    }
  }

  /// Makes HTTP call using the generic WebCall
  static Future<FCCallResult> _makeHttpCall(Uri uri) async {
    try {
      return await FCWebCall.makeHttpCall(
        uri.toString(),
        'GET',
        '',
        'application/json',
        FCWebCallInfo(),
      );
    } catch (e) {
      throw Exception('HTTP call failed: $e');
    }
  }

  /// Converts API JSON to Site object
  static Site _siteFromApiJson(Map<String, dynamic> json) {
    String baseUrl = json['url'] ?? '';
    String endpoint = json['endpoint'] ?? '';

    return Site(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logo_url'],
      backgroundUrl: json['background_url'],
      endpoint: endpoint,
      baseUrl: baseUrl,
      siteType: json['provider'] ?? 'xenforo', // default to xenforo if not specified
      language: json['language'],
      country: json['country'],
    );
  }

  /// Updates an existing Site with fresh data from the server
  static Site updateSiteWithFreshData(Site existingSite, Site freshSite) {
    return Site(
      id: freshSite.id,
      name: freshSite.name,
      url: freshSite.url,
      description: freshSite.description,
      logoUrl: freshSite.logoUrl,
      backgroundUrl: freshSite.backgroundUrl,
      endpoint: freshSite.endpoint,
      baseUrl: freshSite.baseUrl,
      siteType: freshSite.siteType,
      language: freshSite.language,
      country: freshSite.country,
    );
  }
}

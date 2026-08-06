import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:forumcopilot_sdk/network/fc_web_call_info.dart';
import '../models/domain/site.dart';
import '../network/fc_web_call.dart';
import '../network/fc_call_result.dart';

/// Centralized service for all ForumCopilot API calls
class ForumCopilotApiService {
  static const String _baseUrl = 'https://forumcopilot.com/api';

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

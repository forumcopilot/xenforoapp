import '../models/domain/site.dart';

/// Legacy service kept for compatibility.
///
/// Standalone single-forum applications should not depend on ForumCopilot cloud
/// APIs. All remote discovery/enrichment methods are intentionally disabled.
class ForumCopilotApiService {
  static UnsupportedError _disabled(String methodName) {
    return UnsupportedError(
      'ForumCopilotApiService.$methodName is disabled in standalone mode.',
    );
  }

  static Future<List<Site>> getSitesByIds(List<int> ids) async {
    throw _disabled('getSitesByIds');
  }

  static Future<List<Site>> getExploreSites({
    required String language,
    required String country,
    bool debug = false,
  }) async {
    throw _disabled('getExploreSites');
  }

  static Future<List<Site>> searchSites({
    required String query,
    required String language,
    required String country,
    bool debug = false,
  }) async {
    throw _disabled('searchSites');
  }

  static Future<Map<String, dynamic>?> getYouTubeVideoData(String videoId) async {
    throw _disabled('getYouTubeVideoData');
  }

  static Future<Map<String, dynamic>?> getTwitterTweetData(String tweetId) async {
    throw _disabled('getTwitterTweetData');
  }

  /// Utility helper retained for callers that still merge local [Site] values.
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

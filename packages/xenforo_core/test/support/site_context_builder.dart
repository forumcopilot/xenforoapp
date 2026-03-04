import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'test_env.dart';

/// Builds a SiteContext configured for XenForo tests
SiteContext buildXenForoSiteContext() {
  final baseUrl = TestEnv.baseUrl();
  final pluginUrl = TestEnv.pluginUrl();
  
  // Extract endpoint from pluginUrl if it's different from baseUrl
  String? endpoint;
  if (pluginUrl != baseUrl && pluginUrl.startsWith(baseUrl)) {
    endpoint = pluginUrl.substring(baseUrl.length);
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }
  }
  
  final site = Site(
    id: null,
    name: 'XenForo Test',
    url: baseUrl,
    description: 'XenForo test site',
    endpoint: endpoint,
    baseUrl: baseUrl,
    logoUrl: null,
    backgroundUrl: null,
    siteType: 'xenforo',
  );

  final context = SiteContext(
    siteType: 'xenforo',
    site: site,
  );

  return context;
}


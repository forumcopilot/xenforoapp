import '../context/site_context.dart';

class FCWebCallInfo {
  bool isProboardForum = false;
  bool isProblematicUrl = false;
  bool isGZipSupported = true;
  Map<String, String> extraHeaders;

  FCWebCallInfo() : extraHeaders = {};

  FCWebCallInfo.fromSiteContext(SiteContext siteContext)
      : isGZipSupported = siteContext.configDataOutput?.isGzipSupported ?? false,
        isProblematicUrl = siteContext.loginDataOutput?.isProblematicUrl ?? false,
        isProboardForum = siteContext.configDataOutput != null && siteContext.configDataOutput?.version == "proboards",
        extraHeaders = {};
}

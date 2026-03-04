import 'package:forumcopilot_sdk/models/entities/fc_attachment_data.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';
import '../controllers/site_controller.dart';

/// Converts FCLoginResult to FCAttachmentConstraints
FCAttachmentConstraints? getAttachmentConstraintsFromLogin(FCLoginResult loginResult) {
  // Map maxAttachment to count (0 means unlimited, so use null)
  final count = loginResult.maxAttachment > 0 ? loginResult.maxAttachment : null;

  // Map maxAttachmentSize to size (0 means no limit, so use null)
  final size = loginResult.maxAttachmentSize > 0 ? loginResult.maxAttachmentSize : null;

  // Map allowedFileExtensions to extensions list
  List<String>? extensions;
  if (loginResult.allowedFileExtensions != null && loginResult.allowedFileExtensions!.isNotEmpty) {
    extensions = loginResult.allowedFileExtensions;
  } else if (loginResult.allowedExtensions != null && loginResult.allowedExtensions!.isNotEmpty) {
    // Fallback to comma-separated string
    extensions = loginResult.allowedExtensions!
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // Map maxImageWidth and maxImageHeight (0 means no limit, so use null)
  final width = loginResult.maxImageWidth > 0 ? loginResult.maxImageWidth : null;
  final height = loginResult.maxImageHeight > 0 ? loginResult.maxImageHeight : null;

  return FCAttachmentConstraints(
    extensions: extensions,
    size: size,
    width: width,
    height: height,
    count: count,
  );
}

/// Gets attachment constraints from current SiteContext
FCAttachmentConstraints? getAttachmentConstraintsFromSiteContext(SiteContext? siteContext) {
  if (siteContext == null) {
    return null;
  }

  final loginResult = siteContext.loginDataOutput;
  if (loginResult == null) {
    return null;
  }

  return getAttachmentConstraintsFromLogin(loginResult);
}

/// Helper to get current SiteContext
/// Uses Get.find<SiteController>() pattern
SiteContext? getCurrentSiteContext() {
  try {
    if (Get.isRegistered<SiteController>()) {
      final siteController = Get.find<SiteController>();
      return siteController.currentSiteContext.value;
    }
  } catch (e) {
    // SiteController not registered, return null
  }
  return null;
}

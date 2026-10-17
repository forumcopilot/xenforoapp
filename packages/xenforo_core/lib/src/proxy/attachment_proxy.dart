import 'dart:typed_data';
import 'dart:convert';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_attachment_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_attachment_result.dart';
import '../base_xenforo_proxy.dart';
import '../xf_debug.dart';

/// XenForo implementation of IFCAttachmentProxy
/// Handles attachment operations for XenForo forums
class XenForoAttachmentProxy extends BaseXenForoProxy implements IFCAttachmentProxy {
  XenForoAttachmentProxy(SiteContext context) : super(context);

  @override
  Future<FCAttachmentRemoveResult> removeAttachmentAsync(String attachmentId, String forumId, String groupId, String postId) async {
    xfDebug('✅ [XENFORO_ATTACHMENT] removeAttachment called - IMPLEMENTED');
    xfDebug('   📋 Parameters: attachmentId=$attachmentId, forumId=$forumId, groupId=$groupId, postId=$postId');

    try {
      // Build parameters map - only include non-empty optional parameters
      // For associated attachments (already attached to post), groupId should be omitted
      final params = <String, dynamic>{
        'attachmentId': attachmentId,
      };
      
      // Only include optional parameters if they're not empty
      // Note: groupId is only needed for temporary attachments, not associated ones
      if (forumId.isNotEmpty) {
        params['forumId'] = forumId;
      }
      // Only include groupId if it's not empty (for temporary attachments)
      // For associated attachments, omit groupId entirely
      if (groupId.isNotEmpty) {
        params['groupId'] = groupId;
      }
      if (postId.isNotEmpty) {
        params['postId'] = postId;
      }
      
      xfDebug('   📋 Final params: $params');
      
      // Call plugin API with removeAttachment method
      final response = await callPluginApi('removeAttachment', params);

      final result = response['result'] ?? false;
      // Handle both string and null resultText
      final resultText = response['resultText']?.toString().trim() ?? '';
      
      xfDebug('   📋 Response: result=$result, resultText="$resultText"');
      
      // If result is false but resultText is empty, provide a default message
      if (!result && resultText.isEmpty) {
        xfDebug('   ⚠️ Warning: API returned false with empty resultText');
      }
      
      return FCAttachmentRemoveResult(
        result: result,
        resultText: resultText,
      );
    } catch (e, stackTrace) {
      xfDebug('❌ [XENFORO_ATTACHMENT] removeAttachment error: $e');
      xfDebug('❌ [XENFORO_ATTACHMENT] Stack trace: $stackTrace');
      return FCAttachmentRemoveResult(
        result: false,
        resultText: 'Error removing attachment: $e',
      );
    }
  }

  @override
  Future<FCAttachmentUploadResult> uploadAttachmentAsync(String type, String id, String groupId, String attachmentName, Uint8List attachmentBytes) async {
    xfDebug('✅ [XENFORO_ATTACHMENT] uploadAttachment called - IMPLEMENTED');
    xfDebug('   📋 Parameters:');
    xfDebug('      - type: "$type" (isEmpty: ${type.isEmpty})');
    xfDebug('      - id: "$id" (isEmpty: ${id.isEmpty})');
    xfDebug('      - groupId: "$groupId" (isEmpty: ${groupId.isEmpty})');
    xfDebug('      - attachmentName: "$attachmentName" (isEmpty: ${attachmentName.isEmpty})');
    xfDebug('      - bytes: ${attachmentBytes.length}');

    try {
      // Map type to API-expected values
      // API expects "post" or "conversation_message", but we receive "pm" for private messages
      final apiType = type == 'pm' ? 'conversation_message' : type;
      xfDebug('🔍 [XENFORO_ATTACHMENT] Mapped type "$type" to API type "$apiType"');

      // Convert Uint8List to base64 string
      xfDebug('🔍 [XENFORO_ATTACHMENT] Encoding bytes to base64...');
      final base64String = base64Encode(attachmentBytes);
      xfDebug('🔍 [XENFORO_ATTACHMENT] Base64 string length: ${base64String.length}');

      xfDebug('🔍 [XENFORO_ATTACHMENT] Preparing API call parameters...');
      final params = {
        'type': apiType,
        'id': id,
        'groupId': groupId,
        'attachmentName': attachmentName,
        'attachmentData': base64String, // Use attachmentData to match PHP parameter name
      };
      
      xfDebug('🔍 [XENFORO_ATTACHMENT] API params:');
      params.forEach((key, value) {
        final valueStr = value.toString();
        if (valueStr.length > 100) {
          xfDebug('      - $key: "${valueStr.substring(0, 100)}..." (length: ${valueStr.length})');
        } else {
          xfDebug('      - $key: "$valueStr"');
        }
      });

      xfDebug('🔍 [XENFORO_ATTACHMENT] Calling callPluginApi...');
      final response = await callPluginApi('uploadAttachment', params);
      xfDebug('🔍 [XENFORO_ATTACHMENT] API response received:');
      xfDebug('      - response keys: ${response.keys.toList()}');
      xfDebug('      - result: ${response['result']}');
      xfDebug('      - resultText: "${response['resultText']}"');
      xfDebug('      - attachmentId: "${response['attachmentId']}"');
      xfDebug('      - fileName: "${response['fileName']}"');
      xfDebug('      - groupId: "${response['groupId']}"');
      xfDebug('      - fileSize: ${response['fileSize']}');

      // Check if result is true but attachmentId is missing (shouldn't happen, but handle gracefully)
      final apiResult = response['result'] ?? false;
      final attachmentId = response['attachmentId']?.toString();
      
      if (apiResult == true && (attachmentId == null || attachmentId.isEmpty)) {
        xfDebug('⚠️ [XENFORO_ATTACHMENT] Warning: API returned result=true but no attachmentId');
      }

      final result = FCAttachmentUploadResult(
        result: apiResult,
        resultText: response['resultText']?.toString() ?? '',
        attachmentId: attachmentId ?? '',
        fileName: response['fileName']?.toString() ?? attachmentName,
        groupId: response['groupId']?.toString(),
        fileSize: response['fileSize'] is int ? response['fileSize'] as int : (response['fileSize'] is String ? int.tryParse(response['fileSize']) : null),
      );
      
      xfDebug('🔍 [XENFORO_ATTACHMENT] Created FCAttachmentUploadResult:');
      xfDebug('      - result: ${result.result}');
      xfDebug('      - resultText: "${result.resultText}"');
      xfDebug('      - attachmentId: "${result.attachmentId}"');
      xfDebug('      - fileName: "${result.fileName}"');
      xfDebug('      - groupId: "${result.groupId}"');
      xfDebug('      - fileSize: ${result.fileSize}');
      
      return result;
    } catch (e, stackTrace) {
      xfDebug('❌ [XENFORO_ATTACHMENT] uploadAttachment error: $e');
      xfDebug('❌ [XENFORO_ATTACHMENT] Stack trace: $stackTrace');
      return FCAttachmentUploadResult(
        result: false,
        resultText: 'Error uploading attachment: $e',
        attachmentId: '',
        fileName: attachmentName,
        fileSize: null,
      );
    }
  }

  @override
  Future<FCAttachmentUploadResult> uploadAvatarAsync(String imageExtension, Uint8List attachmentBytes) async {
    xfDebug('✅ [XENFORO_ATTACHMENT] uploadAvatar called - IMPLEMENTED');
    xfDebug('   📋 Parameters: imageExtension=$imageExtension, bytes=${attachmentBytes.length}');

    try {
      // Convert Uint8List to base64 string
      final base64String = base64Encode(attachmentBytes);

      final response = await callPluginApi('uploadAvatar', {
        'imageExtension': imageExtension,
        'attachmentData': base64String, // Use attachmentData to match PHP parameter name
      });

      return FCAttachmentUploadResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        attachmentId: response['attachmentId'] ?? '',
        fileName: response['fileName'] ?? 'avatar.$imageExtension',
        fileSize: response['fileSize'],
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_ATTACHMENT] uploadAvatar error: $e');
      return FCAttachmentUploadResult(
        result: false,
        resultText: 'Error uploading avatar: $e',
        attachmentId: '',
        fileName: 'avatar.$imageExtension',
        fileSize: null,
      );
    }
  }
}

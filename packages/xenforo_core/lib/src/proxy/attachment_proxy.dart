import 'dart:typed_data';
import 'dart:convert';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_attachment_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_attachment_result.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of IFCAttachmentProxy
/// Handles attachment operations for XenForo forums
class XenForoAttachmentProxy extends BaseXenForoProxy implements IFCAttachmentProxy {
  XenForoAttachmentProxy(SiteContext context) : super(context);

  @override
  Future<FCAttachmentRemoveResult> removeAttachmentAsync(String attachmentId, String forumId, String groupId, String postId) async {
    print('✅ [XENFORO_ATTACHMENT] removeAttachment called - IMPLEMENTED');
    print('   📋 Parameters: attachmentId=$attachmentId, forumId=$forumId, groupId=$groupId, postId=$postId');

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
      
      print('   📋 Final params: $params');
      
      // Call plugin API with removeAttachment method
      final response = await callPluginApi('removeAttachment', params);

      final result = response['result'] ?? false;
      // Handle both string and null resultText
      final resultText = response['resultText']?.toString().trim() ?? '';
      
      print('   📋 Response: result=$result, resultText="$resultText"');
      
      // If result is false but resultText is empty, provide a default message
      if (!result && resultText.isEmpty) {
        print('   ⚠️ Warning: API returned false with empty resultText');
      }
      
      return FCAttachmentRemoveResult(
        result: result,
        resultText: resultText,
      );
    } catch (e, stackTrace) {
      print('❌ [XENFORO_ATTACHMENT] removeAttachment error: $e');
      print('❌ [XENFORO_ATTACHMENT] Stack trace: $stackTrace');
      return FCAttachmentRemoveResult(
        result: false,
        resultText: 'Error removing attachment: $e',
      );
    }
  }

  @override
  Future<FCAttachmentUploadResult> uploadAttachmentAsync(String type, String id, String groupId, String attachmentName, Uint8List attachmentBytes) async {
    print('✅ [XENFORO_ATTACHMENT] uploadAttachment called - IMPLEMENTED');
    print('   📋 Parameters:');
    print('      - type: "$type" (isEmpty: ${type.isEmpty})');
    print('      - id: "$id" (isEmpty: ${id.isEmpty})');
    print('      - groupId: "$groupId" (isEmpty: ${groupId.isEmpty})');
    print('      - attachmentName: "$attachmentName" (isEmpty: ${attachmentName.isEmpty})');
    print('      - bytes: ${attachmentBytes.length}');

    try {
      // Map type to API-expected values
      // API expects "post" or "conversation_message", but we receive "pm" for private messages
      final apiType = type == 'pm' ? 'conversation_message' : type;
      print('🔍 [XENFORO_ATTACHMENT] Mapped type "$type" to API type "$apiType"');

      // Convert Uint8List to base64 string
      print('🔍 [XENFORO_ATTACHMENT] Encoding bytes to base64...');
      final base64String = base64Encode(attachmentBytes);
      print('🔍 [XENFORO_ATTACHMENT] Base64 string length: ${base64String.length}');

      print('🔍 [XENFORO_ATTACHMENT] Preparing API call parameters...');
      final params = {
        'type': apiType,
        'id': id,
        'groupId': groupId,
        'attachmentName': attachmentName,
        'attachmentData': base64String, // Use attachmentData to match PHP parameter name
      };
      
      print('🔍 [XENFORO_ATTACHMENT] API params:');
      params.forEach((key, value) {
        final valueStr = value.toString();
        if (valueStr.length > 100) {
          print('      - $key: "${valueStr.substring(0, 100)}..." (length: ${valueStr.length})');
        } else {
          print('      - $key: "$valueStr"');
        }
      });

      print('🔍 [XENFORO_ATTACHMENT] Calling callPluginApi...');
      final response = await callPluginApi('uploadAttachment', params);
      print('🔍 [XENFORO_ATTACHMENT] API response received:');
      print('      - response keys: ${response.keys.toList()}');
      print('      - result: ${response['result']}');
      print('      - resultText: "${response['resultText']}"');
      print('      - attachmentId: "${response['attachmentId']}"');
      print('      - fileName: "${response['fileName']}"');
      print('      - groupId: "${response['groupId']}"');
      print('      - fileSize: ${response['fileSize']}');

      // Check if result is true but attachmentId is missing (shouldn't happen, but handle gracefully)
      final apiResult = response['result'] ?? false;
      final attachmentId = response['attachmentId']?.toString();
      
      if (apiResult == true && (attachmentId == null || attachmentId.isEmpty)) {
        print('⚠️ [XENFORO_ATTACHMENT] Warning: API returned result=true but no attachmentId');
      }

      final result = FCAttachmentUploadResult(
        result: apiResult,
        resultText: response['resultText']?.toString() ?? '',
        attachmentId: attachmentId ?? '',
        fileName: response['fileName']?.toString() ?? attachmentName,
        groupId: response['groupId']?.toString(),
        fileSize: response['fileSize'] is int ? response['fileSize'] as int : (response['fileSize'] is String ? int.tryParse(response['fileSize']) : null),
      );
      
      print('🔍 [XENFORO_ATTACHMENT] Created FCAttachmentUploadResult:');
      print('      - result: ${result.result}');
      print('      - resultText: "${result.resultText}"');
      print('      - attachmentId: "${result.attachmentId}"');
      print('      - fileName: "${result.fileName}"');
      print('      - groupId: "${result.groupId}"');
      print('      - fileSize: ${result.fileSize}');
      
      return result;
    } catch (e, stackTrace) {
      print('❌ [XENFORO_ATTACHMENT] uploadAttachment error: $e');
      print('❌ [XENFORO_ATTACHMENT] Stack trace: $stackTrace');
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
    print('✅ [XENFORO_ATTACHMENT] uploadAvatar called - IMPLEMENTED');
    print('   📋 Parameters: imageExtension=$imageExtension, bytes=${attachmentBytes.length}');

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
      print('❌ [XENFORO_ATTACHMENT] uploadAvatar error: $e');
      return FCAttachmentUploadResult(
        result: false,
        resultText: 'Error uploading avatar: $e',
        attachmentId: '',
        fileName: 'avatar.$imageExtension',
        fileSize: null,
      );
    }
  }

  @override
  Future<FCTapatalkImageUploadResult> uploadTapatalkImageAsync(String attachmentName, Uint8List attachmentBytes) async {
    print('✅ [XENFORO_ATTACHMENT] uploadTapatalkImage called - IMPLEMENTED');
    print('   📋 Parameters: attachmentName=$attachmentName, bytes=${attachmentBytes.length}');

    try {
      // Convert Uint8List to base64 string
      final base64String = base64Encode(attachmentBytes);

      final response = await callPluginApi('uploadTapatalkImage', {
        'attachmentName': attachmentName,
        'attachmentBytes': base64String,
      });

      return FCTapatalkImageUploadResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        imageId: response['imageId'] ?? '',
        imageUrl: response['imageUrl'] ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_ATTACHMENT] uploadTapatalkImage error: $e');
      return FCTapatalkImageUploadResult(
        result: false,
        resultText: 'Error uploading Tapatalk image: $e',
        imageId: '',
        imageUrl: '',
      );
    }
  }
}

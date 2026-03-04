import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_post_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_post_result.dart';
import 'package:forumcopilot_sdk/models/results/fc_topic_result.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment_data.dart';
import 'package:forumcopilot_sdk/models/entities/fc_poll.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of IFCPostProxy
/// Handles post operations for XenForo forums
class XenForoPostProxy extends BaseXenForoProxy implements IFCPostProxy {
  XenForoPostProxy(SiteContext context) : super(context);

  @override
  Future<FCQuotePostResult> getQuotePostAsync(String postId) async {
    print('✅ [XENFORO_POST] getQuotePost called - IMPLEMENTED');
    print('   📋 Parameters: postId=$postId');

    try {
      final response = await callPluginApi('getQuotePost', {
        'postId': postId,
      });

      print('   📥 [XENFORO_POST] getQuotePost response keys: ${response.keys.toList()}');
      print('   📥 [XENFORO_POST] getQuotePost quoteContent: ${response['quoteContent']}');

      return FCQuotePostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        quoteContent: response['quoteContent']?.toString(),
      );
    } catch (e) {
      print('❌ [XENFORO_POST] getQuotePost error: $e');
      return FCQuotePostResult(
        result: false,
        resultText: 'Error getting quote post: $e',
      );
    }
  }

  @override
  Future<FCRawPostResult> getRawPostAsync(String postId) async {
    print('✅ [XENFORO_POST] getRawPost called - IMPLEMENTED');
    print('   📋 Parameters: postId=$postId');

    try {
      final response = await callPluginApi('getRawPost', {
        'postId': postId,
      });

      // Parse attachments
      List<FCAttachment>? attachments;
      if (response['attachments'] != null && response['attachments'] is List) {
        attachments = (response['attachments'] as List)
            .map((item) {
              if (item is Map<String, dynamic>) {
                return FCAttachment(
                  id: item['id']?.toString() ?? '',
                  filename: item['fileName']?.toString() ?? '',
                  contentType: item['mimeType']?.toString(),
                  fileSize: item['fileSize'] is int ? item['fileSize'] as int : (item['fileSize'] is String ? int.tryParse(item['fileSize']) ?? 0 : 0),
                  url: item['url']?.toString() ?? '',
                  thumbnailUrl: item['thumbnailUrl']?.toString(),
                  isImage: item['isImage'] ?? false,
                  groupId: item['groupId']?.toString(),
                  width: item['width'] is int ? item['width'] as int : (item['width'] is String ? int.tryParse(item['width']) : null),
                  height: item['height'] is int ? item['height'] as int : (item['height'] is String ? int.tryParse(item['height']) : null),
                  icon: item['icon']?.toString(),
                  iconName: item['iconName']?.toString(),
                  isVideo: item['isVideo'] ?? false,
                  isAudio: item['isAudio'] ?? false,
                  link: item['link']?.toString(),
                  typeGrouping: item['typeGrouping']?.toString(),
                  fileSizePrintable: item['fileSizePrintable']?.toString(),
                  canViewUrl: item['canViewUrl'] is bool ? item['canViewUrl'] as bool : (item['canViewUrl'] == true || item['canViewUrl'] == 'true'),
                  canViewThumbnailUrl: item['canViewThumbnailUrl'] is bool ? item['canViewThumbnailUrl'] as bool : (item['canViewThumbnailUrl'] == true || item['canViewThumbnailUrl'] == 'true'),
                );
              }
              return null;
            })
            .whereType<FCAttachment>()
            .toList();
      }

      // Parse attachmentData
      FCAttachmentData? attachmentData;
      if (response['attachmentData'] != null && response['attachmentData'] is Map) {
        final data = response['attachmentData'] as Map<String, dynamic>;
        final context = data['context'] is Map ? data['context'] as Map<String, dynamic> : null;
        final constraints = data['constraints'] is Map ? data['constraints'] as Map<String, dynamic> : null;

        attachmentData = FCAttachmentData(
          type: data['type']?.toString() ?? 'post',
          hash: data['hash']?.toString() ?? '',
          context: context != null
              ? FCAttachmentContext(
                  nodeId: context['node_id'] is int ? context['node_id'] as int : (context['node_id'] is String ? int.tryParse(context['node_id']) : null),
                )
              : null,
          constraints: constraints != null
              ? FCAttachmentConstraints(
                  extensions: constraints['extensions'] is List ? (constraints['extensions'] as List).map((e) => e.toString()).toList() : null,
                  size: constraints['size'] is int ? constraints['size'] as int : (constraints['size'] is String ? int.tryParse(constraints['size']) : null),
                  width: constraints['width'] is int ? constraints['width'] as int : (constraints['width'] is String ? int.tryParse(constraints['width']) : null),
                  height: constraints['height'] is int ? constraints['height'] as int : (constraints['height'] is String ? int.tryParse(constraints['height']) : null),
                  count: constraints['count'] is int ? constraints['count'] as int : (constraints['count'] is String ? int.tryParse(constraints['count']) : null),
                )
              : null,
        );
      }

      // Parse prefix data
      String? prefixId;
      if (response['prefixId'] != null) {
        final prefixIdValue = response['prefixId'];
        // Handle null, empty string, "0", or the string "null"
        if (prefixIdValue == null || prefixIdValue == '' || prefixIdValue == 0 || prefixIdValue == '0' || prefixIdValue.toString().toLowerCase() == 'null') {
          prefixId = null;
        } else {
          prefixId = prefixIdValue.toString();
          // Convert empty string or "0" to null
          if (prefixId.isEmpty || prefixId == '0') {
            prefixId = null;
          }
        }
      }

      bool requirePrefix = response['requirePrefix'] is bool ? response['requirePrefix'] as bool : (response['requirePrefix'] == true || response['requirePrefix'] == 'true');

      // Parse prefixes list
      List<FCPrefix> prefixes = [];
      if (response['prefixes'] != null && response['prefixes'] is List) {
        prefixes = (response['prefixes'] as List).map((p) {
          final map = p.cast<String, dynamic>();
          // Prefix API now returns { id, title }
          final prefixIdStr = map['id'] ?? '';
          final prefixDisplayName = map['title'] ?? '';
          return FCPrefix(
            prefixId: prefixIdStr.toString(),
            prefixDisplayName: prefixDisplayName.toString(),
          );
        }).toList();
      }

      print('🔍 [XENFORO_POST] Parsed attachments: ${attachments?.length ?? 0}');
      print('🔍 [XENFORO_POST] Attachment data hash: ${attachmentData?.hash}');
      print('🔍 [XENFORO_POST] Can edit title: ${response['canEditTitle']}');
      print('🔍 [XENFORO_POST] Forum ID: ${response['forumId']}');
      print('🔍 [XENFORO_POST] Prefix ID: $prefixId');
      print('🔍 [XENFORO_POST] Require prefix: $requirePrefix');
      print('🔍 [XENFORO_POST] Available prefixes: ${prefixes.length}');

      return FCRawPostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        postTitle: response['postTitle'],
        postContent: response['postContent'] ?? '',
        canEditTitle: response['canEditTitle'] is bool ? response['canEditTitle'] as bool : (response['canEditTitle'] == true || response['canEditTitle'] == 'true'),
        forumId: response['forumId']?.toString(),
        attachments: attachments,
        attachmentData: attachmentData,
        prefixId: prefixId,
        requirePrefix: requirePrefix,
        prefixes: prefixes,
      );
    } catch (e, stackTrace) {
      print('❌ [XENFORO_POST] getRawPost error: $e');
      print('❌ [XENFORO_POST] Stack trace: $stackTrace');
      return FCRawPostResult(
        result: false,
        resultText: 'Error getting raw post: $e',
        postTitle: null,
        postContent: '',
        attachments: null,
        attachmentData: null,
        prefixId: null,
        requirePrefix: false,
        prefixes: const [],
      );
    }
  }

  @override
  Future<FCThreadResult> getThreadAsync(String topicId, int startNum, int lastNum, bool returnHtml) async {
    print('✅ [XENFORO_POST] getThread called - IMPLEMENTED');
    print('   📋 Parameters: topicId=$topicId, startNum=$startNum, lastNum=$lastNum, returnHtml=$returnHtml');

    try {
      return await callPluginApiTyped<FCThreadResult>('getThread', {
        'topicId': topicId,
        'startNum': startNum,
        'lastNum': lastNum,
        'returnHtml': returnHtml,
      }, (response) {
        // Ensure required fields are present - required by mapper
        final responseMap = response.cast<String, dynamic>();
        if (!responseMap.containsKey('totalPostNum')) {
          // If missing, try to get from posts length or set default
          final postsList = responseMap['posts'] as List?;
          responseMap['totalPostNum'] = postsList?.length ?? 0;
          print('   ⚠️ [XENFORO_POST] totalPostNum missing from response, using default: ${responseMap['totalPostNum']}');
        }

        // Map posts - convert 'position' to 'postNumber' for Flutter model
        final List<FCPost> fcPosts = ((responseMap['posts'] as List?) ?? []).whereType<Map>().map((p) {
          final postMap = p.cast<String, dynamic>();
          // Map 'position' field from API to 'postNumber' field expected by Flutter model
          if (postMap.containsKey('position') && !postMap.containsKey('postNumber')) {
            postMap['postNumber'] = postMap['position'];
          }

          // Debug: Log attachment data before mapping
          if (postMap.containsKey('attachments') && (postMap['attachments'] as List).isNotEmpty) {
            final attachments = postMap['attachments'] as List;
            for (var i = 0; i < attachments.length && i < 2; i++) {
              final att = attachments[i] as Map<String, dynamic>;
              print('   🔍 [XENFORO_POST] Attachment[$i] before mapping:');
              print('      id: ${att['id']}, fileName: ${att['fileName']}');
              print('      canViewThumbnailUrl (raw): ${att['canViewThumbnailUrl']} (type: ${att['canViewThumbnailUrl'].runtimeType})');
              print('      thumbnailUrl: ${att['thumbnailUrl']}');
            }
          }

          final fcPost = FCPostMapper.fromMap(postMap);

          // Debug: Log attachment data after mapping
          if (fcPost.attachments.isNotEmpty) {
            for (var i = 0; i < fcPost.attachments.length && i < 2; i++) {
              final att = fcPost.attachments[i];
              print('   🔍 [XENFORO_POST] Attachment[$i] after mapping:');
              print('      id: ${att.id}, filename: ${att.filename}');
              print('      canViewThumbnailUrl: ${att.canViewThumbnailUrl}');
              print('      thumbnailUrl: ${att.thumbnailUrl}');
            }
          }

          return fcPost;
        }).toList();

        // Use FCThreadResultMapper for automatic mapping including timestamp conversion
        return FCThreadResultMapper.fromMap(responseMap)..posts = fcPosts;
      });
    } catch (e) {
      print('❌ [XENFORO_POST] getThread error: $e');
      // Return minimal error result
      final now = DateTime.now();
      return FCThreadResult(
        result: false,
        resultText: 'Error getting thread: $e',
        posts: [],
        totalPostNum: 0,
        id: '',
        title: '',
        forumId: '',
        forumName: '',
        authorId: '',
        authorName: '',
        authorUserType: '',
        timestamp: now,
      );
    }
  }

  @override
  Future<FCThreadByPostResult> getThreadByPostAsync(String postId, int postsPerRequest, bool returnHtml) async {
    print('✅ [XENFORO_POST] getThreadByPost called - IMPLEMENTED');
    print('   📋 Parameters: postId=$postId, postsPerRequest=$postsPerRequest, returnHtml=$returnHtml');

    try {
      return await callPluginApiTyped<FCThreadByPostResult>('getThreadByPost', {
        'postId': postId,
        'postsPerRequest': postsPerRequest,
        'returnHtml': returnHtml,
      }, (response) {
        // Ensure required fields are present - required by mapper
        final responseMap = response.cast<String, dynamic>();
        if (!responseMap.containsKey('totalPostNum')) {
          // If missing, try to get from posts length or set default
          final postsList = responseMap['posts'] as List?;
          responseMap['totalPostNum'] = postsList?.length ?? 0;
          print('   ⚠️ [XENFORO_POST] totalPostNum missing from response, using default: ${responseMap['totalPostNum']}');
        }
        if (!responseMap.containsKey('position')) {
          // Position is required for FCThreadByPostResult - default to 1 if missing
          responseMap['position'] = 1;
          print('   ⚠️ [XENFORO_POST] position missing from response, using default: ${responseMap['position']}');
        }

        // Map posts - convert 'position' to 'postNumber' for Flutter model
        final List<FCPost> fcPosts = ((responseMap['posts'] as List?) ?? []).whereType<Map>().map((p) {
          final postMap = p.cast<String, dynamic>();
          // Map 'position' field from API to 'postNumber' field expected by Flutter model
          if (postMap.containsKey('position') && !postMap.containsKey('postNumber')) {
            postMap['postNumber'] = postMap['position'];
          }
          return FCPostMapper.fromMap(postMap);
        }).toList();

        // Use FCThreadByPostResultMapper for automatic mapping including timestamp conversion
        return FCThreadByPostResultMapper.fromMap(responseMap)..posts = fcPosts;
      });
    } catch (e) {
      print('❌ [XENFORO_POST] getThreadByPost error: $e');
      // Return minimal error result
      final now = DateTime.now();
      return FCThreadByPostResult(
        result: false,
        resultText: 'Error getting thread by post: $e',
        posts: [],
        totalPostNum: 0,
        id: '',
        position: 0,
        title: '',
        forumId: '',
        forumName: '',
        authorId: '',
        authorName: '',
        authorUserType: '',
        timestamp: now,
      );
    }
  }

  @override
  Future<FCThreadByUnreadResult> getThreadByUnreadAsync(String topicId, int postsPerRequest, bool returnHtml) async {
    print('✅ [XENFORO_POST] getThreadByUnread called - IMPLEMENTED');
    print('   📋 Parameters: topicId=$topicId, postsPerRequest=$postsPerRequest, returnHtml=$returnHtml');

    try {
      return await callPluginApiTyped<FCThreadByUnreadResult>('getThreadByUnread', {
        'topicId': topicId,
        'postsPerRequest': postsPerRequest,
        'returnHtml': returnHtml,
      }, (response) {
        // Ensure required fields are present - required by mapper
        final responseMap = response.cast<String, dynamic>();
        if (!responseMap.containsKey('totalPostNum')) {
          // If missing, try to get from posts length or set default
          final postsList = responseMap['posts'] as List?;
          responseMap['totalPostNum'] = postsList?.length ?? 0;
          print('   ⚠️ [XENFORO_POST] totalPostNum missing from response, using default: ${responseMap['totalPostNum']}');
        }
        if (!responseMap.containsKey('position')) {
          // Position is required for FCThreadByUnreadResult - default to 1 if missing
          responseMap['position'] = 1;
          print('   ⚠️ [XENFORO_POST] position missing from response, using default: ${responseMap['position']}');
        }

        // Map posts - convert 'position' to 'postNumber' for Flutter model
        final List<FCPost> fcPosts = ((responseMap['posts'] as List?) ?? []).whereType<Map>().map((p) {
          final postMap = p.cast<String, dynamic>();
          // Map 'position' field from API to 'postNumber' field expected by Flutter model
          if (postMap.containsKey('position') && !postMap.containsKey('postNumber')) {
            postMap['postNumber'] = postMap['position'];
          }
          return FCPostMapper.fromMap(postMap);
        }).toList();

        // Use FCThreadByUnreadResultMapper for automatic mapping including timestamp conversion
        return FCThreadByUnreadResultMapper.fromMap(responseMap)..posts = fcPosts;
      });
    } catch (e) {
      print('❌ [XENFORO_POST] getThreadByUnread error: $e');
      // Return minimal error result
      final now = DateTime.now();
      return FCThreadByUnreadResult(
        result: false,
        resultText: 'Error getting thread by unread: $e',
        posts: [],
        totalPostNum: 0,
        position: 0,
        id: '',
        title: '',
        forumId: '',
        forumName: '',
        authorId: '',
        authorName: '',
        authorUserType: '',
        timestamp: now,
      );
    }
  }

  @override
  Future<FCReplyPostResult> replyPostAsync(String forumId, String topicId, String subject, String textBody, List<String>? attachmentIds, String? groupId, bool returnHtml) async {
    print('✅ [XENFORO_POST] replyPost called - IMPLEMENTED');
    print('   📋 Parameters: forumId=$forumId, topicId=$topicId, subject=$subject, textBody=${textBody.length} chars, attachmentIds=$attachmentIds, groupId=$groupId, returnHtml=$returnHtml');

    try {
      final response = await callPluginApi('replyPost', {
        'forumId': forumId,
        'topicId': topicId,
        'subject': subject,
        'textBody': textBody,
        'attachmentIds': attachmentIds,
        'groupId': groupId,
        'returnHtml': returnHtml,
      });

      return FCReplyPostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        postId: response['postId']?.toString(),
        state: response['state'] ?? 0,
        postContent: response['postContent']?.toString(),
        canEdit: response['canEdit'] ?? false,
        canDelete: response['canDelete'] ?? false,
        canReport: response['canReport'] ?? false,
      );
    } catch (e) {
      print('❌ [XENFORO_POST] replyPost error: $e');
      return FCReplyPostResult(
        result: false,
        resultText: 'Error replying to post: $e',
      );
    }
  }

  @override
  Future<FCReportPostResult> reportPostAsync(String postId, String reason) async {
    print('✅ [XENFORO_POST] reportPost called - IMPLEMENTED');
    print('   📋 Parameters: postId=$postId, reason=$reason');

    try {
      final response = await callPluginApi('reportPost', {
        'postId': postId,
        'reason': reason,
      });

      return FCReportPostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_POST] reportPost error: $e');
      return FCReportPostResult(
        result: false,
        resultText: 'Error reporting post: $e',
      );
    }
  }

  @override
  Future<FCSaveRawPostResult> saveRawPostAsync(
      String postId, String postTitle, String postContent, bool returnHtml, String? reason, List<String>? attachmentIds, String? groupId, String? prefix) async {
    print('✅ [XENFORO_POST] saveRawPost called - IMPLEMENTED');
    print(
        '   📋 Parameters: postId=$postId, postTitle=$postTitle, postContent=${postContent.length} chars, returnHtml=$returnHtml, reason=$reason, attachmentIds=$attachmentIds, groupId=$groupId, prefix=$prefix');

    try {
      final Map<String, dynamic> params = {
        'postId': postId,
        'postTitle': postTitle,
        'postContent': postContent,
        'returnHtml': returnHtml,
        'reason': reason,
        'attachmentIds': attachmentIds,
        'groupId': groupId,
      };

      // Include prefix parameter if provided (can be null, "0", or prefix ID string)
      if (prefix != null) {
        params['prefix'] = prefix;
      }

      final response = await callPluginApi('saveRawPost', params);

      return FCSaveRawPostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_POST] saveRawPost error: $e');
      return FCSaveRawPostResult(
        result: false,
        resultText: 'Error saving raw post: $e',
      );
    }
  }

  /// Submits the user's vote to the Forum Copilot plugin votePoll API.
  /// Returns the updated [FCPoll] on success, or null on failure or invalid response.
  @override
  Future<FCPoll?> votePollAsync(String topicId, List<String> responseIds) async {
    try {
      final response = await callPluginApi('votePoll', {
        'topicId': topicId,
        'responseIds': responseIds,
      });
      if (response['result'] != true) {
        return null;
      }
      final pollJson = response['poll'];
      if (pollJson == null || pollJson is! Map) {
        return null;
      }
      return FCPollMapper.fromMap(Map<String, dynamic>.from(pollJson));
    } catch (_) {
      return null;
    }
  }
}

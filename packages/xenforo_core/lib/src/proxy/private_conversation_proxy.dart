import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_private_conversation_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'package:forumcopilot_sdk/models/entities/fc_like.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of IFCPrivateConversationProxy
/// Handles private conversation operations for XenForo forums
class XenForoPrivateConversationProxy extends BaseXenForoProxy implements IFCPrivateConversationProxy {
  XenForoPrivateConversationProxy(SiteContext context) : super(context);

  @override
  Future<FCNewConversationResult> newConversationAsync(
    List<String> userName,
    String subject,
    String textBody, {
    List<String>? attachmentIds,
    String? groupId,
    bool? openInvite,
    bool? conversationLocked,
  }) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] newConversationAsync called via plugin API');
    print('   📋 Parameters: userName=$userName, subject=$subject, textBody length=${textBody.length}');
    if (attachmentIds != null && attachmentIds.isNotEmpty) {
      print('   📋 Attachment IDs: $attachmentIds');
    }
    if (groupId != null && groupId.isNotEmpty) {
      print('   📋 Group ID: $groupId');
    }
    if (openInvite != null) {
      print('   📋 Open Invite: $openInvite');
    }
    if (conversationLocked != null) {
      print('   📋 Conversation Locked: $conversationLocked');
    }

    try {
      final params = <String, dynamic>{
        'userName': userName,
        'subject': subject,
        'textBody': textBody,
      };
      if (attachmentIds != null && attachmentIds.isNotEmpty) {
        params['attachmentIds'] = attachmentIds;
      }
      if (groupId != null && groupId.isNotEmpty) {
        params['groupId'] = groupId;
      }
      if (openInvite != null) {
        params['openInvite'] = openInvite;
      }
      if (conversationLocked != null) {
        params['conversationLocked'] = conversationLocked;
      }

      final response = await callPluginApi('newConversation', params);
      
      print('📥 [XENFORO_PRIVATE_CONVERSATION] newConversationAsync raw response: $response');
      
      final result = response['result'] ?? false;
      final resultText = response['resultText']?.toString() ?? '';
      final convId = response['convId']?.toString() ?? '';
      
      print('📥 [XENFORO_PRIVATE_CONVERSATION] Parsed result: result=$result, resultText=$resultText, convId=$convId');
      
      if (result && convId.isEmpty) {
        print('⚠️  [XENFORO_PRIVATE_CONVERSATION] WARNING: result is true but convId is empty!');
      }
      
      if (!result) {
        print('❌ [XENFORO_PRIVATE_CONVERSATION] Server returned result=false, resultText=$resultText');
      }

      return FCNewConversationResult(
        result: result,
        resultText: resultText,
        convId: convId,
      );
    } catch (e, stackTrace) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] newConversationAsync error: $e');
      print('❌ [XENFORO_PRIVATE_CONVERSATION] Stack trace: $stackTrace');
      return FCNewConversationResult(
        result: false,
        resultText: 'Error creating conversation: $e',
        convId: '',
      );
    }
  }

  @override
  Future<FCReplyConversationResult> replyConversationAsync(String conversationId, String textBody, List<String>? attachmentIds, String? groupId) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] replyConversationAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId');

    try {
      final params = <String, dynamic>{
        'conversationId': conversationId,
        'textBody': textBody,
      };
      if (attachmentIds != null && attachmentIds.isNotEmpty) {
        params['attachmentIds'] = attachmentIds;
      }
      if (groupId != null && groupId.isNotEmpty) {
        params['groupId'] = groupId;
      }

      final response = await callPluginApi('replyConversation', params);

      return FCReplyConversationResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] replyConversationAsync error: $e');
      return FCReplyConversationResult(
        result: false,
        resultText: 'Error replying to conversation: $e',
      );
    }
  }

  @override
  Future<FCInviteParticipantResult> inviteParticipantAsync(List<String> userName, String conversationId, String? reason) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] inviteParticipantAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId, userName=$userName');

    try {
      final params = <String, dynamic>{
        'userName': userName,
        'conversationId': conversationId,
      };
      if (reason != null && reason.isNotEmpty) {
        params['reason'] = reason;
      }

      final response = await callPluginApi('inviteParticipant', params);

      return FCInviteParticipantResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] inviteParticipantAsync error: $e');
      return FCInviteParticipantResult(
        result: false,
        resultText: 'Error inviting participant: $e',
      );
    }
  }

  @override
  Future<FCInboxStatResult> getInboxStatAsync() async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] getInboxStatAsync called via plugin API');

    try {
      final response = await callPluginApi('getInboxStat', {});

      // PHP returns getInboxStat which uses FCConversationInboxStatResult
      // Map to FCInboxStatResult
      return FCInboxStatResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        totalConversations: response['totalConversations'] ?? response['total'] ?? 0,
        unreadConversations: response['unreadConversations'] ?? response['unread'] ?? 0,
        unreadMessages: response['unreadMessages'] ?? response['unread_messages'] ?? 0,
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] getInboxStatAsync error: $e');
      return FCInboxStatResult(
        result: false,
        resultText: 'Error getting inbox stats: $e',
        totalConversations: 0,
        unreadConversations: 0,
        unreadMessages: 0,
      );
    }
  }

  /// Get inbox statistics including unread alerts
  /// Returns a map with both FCInboxStatResult and unreadAlerts
  Future<Map<String, dynamic>> getInboxStatWithAlertsAsync() async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] getInboxStatWithAlertsAsync called via plugin API');

    try {
      final response = await callPluginApi('getInboxStat', {});

      final inboxStat = FCInboxStatResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        totalConversations: response['totalConversations'] ?? response['total'] ?? 0,
        unreadConversations: response['unreadConversations'] ?? response['unread'] ?? 0,
        unreadMessages: response['unreadMessages'] ?? response['unread_messages'] ?? 0,
      );

      final unreadAlerts = response['unreadAlerts'] ?? response['unread_alerts'] ?? 0;

      return {
        'inboxStat': inboxStat,
        'unreadAlerts': unreadAlerts,
      };
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] getInboxStatWithAlertsAsync error: $e');
      return {
        'inboxStat': FCInboxStatResult(
          result: false,
          resultText: 'Error getting inbox stats: $e',
          totalConversations: 0,
          unreadConversations: 0,
          unreadMessages: 0,
        ),
        'unreadAlerts': 0,
      };
    }
  }

  @override
  Future<FCConversationsResult> getConversationsAsync(int startNum, int lastNum) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] getConversationsAsync called via plugin API');
    print('   📋 Parameters: startNum=$startNum, lastNum=$lastNum');

    try {
      final response = await callPluginApi('getConversations', {
        'startNum': startNum,
        'lastNum': lastNum,
      });

      // Parse conversation list - PHP returns array with conversation data
      final List<FCConversationSummary> conversationList = [];
      if (response['list'] != null && response['list'] is List) {
        for (var convData in response['list'] as List) {
          if (convData is Map<String, dynamic>) {
            // Convert timestamps to ISO8601 strings
            final startTime = convData['startTime'];
            final lastMessageTime = convData['lastMessageTime'];
            
            String? startTimeStr;
            if (startTime != null) {
              if (startTime is int) {
                startTimeStr = DateTime.fromMillisecondsSinceEpoch(startTime).toIso8601String();
              } else if (startTime is String) {
                startTimeStr = startTime;
              }
            }
            
            String? lastReplyTimeStr;
            if (lastMessageTime != null) {
              if (lastMessageTime is int) {
                lastReplyTimeStr = DateTime.fromMillisecondsSinceEpoch(lastMessageTime).toIso8601String();
              } else if (lastMessageTime is String) {
                lastReplyTimeStr = lastMessageTime;
              }
            }
            
            // Build participants list
            // Note: API's participants array does NOT include starter
            // Starter info is in startUserId/startUsername/startUserIconUrl
            final List<FCParticipant> participants = [];
            
            // 1. Add conversation starter first (not in API's participants array)
            if (convData['startUserId'] != null && convData['startUsername'] != null) {
              participants.add(FCParticipant(
                userId: convData['startUserId']?.toString() ?? '',
                username: convData['startUsername']?.toString() ?? '',
                iconUrl: convData['startUserIconUrl']?.toString(),
                isOnline: null,
              ));
            }
            
            // 2. Add all participants from API's participants array
            // Note: These do NOT have iconUrl (for performance - not included in API)
            if (convData['participants'] != null && convData['participants'] is List) {
              for (var partData in convData['participants'] as List) {
                if (partData is Map<String, dynamic>) {
                  final participantId = partData['id']?.toString() ?? '';
                  final participantUsername = partData['username']?.toString() ?? '';
                  
                  // Skip if already added (starter)
                  if (participantId.isNotEmpty && 
                      participantId != convData['startUserId']?.toString()) {
                    participants.add(FCParticipant(
                      userId: participantId,
                      username: participantUsername,
                      iconUrl: null, // Not available in API for performance
                      isOnline: null,
                    ));
                  }
                }
              }
            }
            
            // 3. Ensure last message author is in participants list with avatar
            // API provides lastMessageAuthorId and lastMessageAuthorIconUrl
            final lastMessageAuthorId = convData['lastMessageAuthorId']?.toString() ?? 
                                       convData['lastMessageAuthor']?.toString(); // Fallback for backward compatibility
            
            if (lastMessageAuthorId != null && lastMessageAuthorId.isNotEmpty) {
              // Check if last message author is already in participants list
              final existingIndex = participants.indexWhere(
                (p) => p.userId == lastMessageAuthorId
              );
              
              if (existingIndex >= 0) {
                // Update existing participant with avatar from lastMessageAuthorIconUrl
                final lastMessageAuthorIconUrl = convData['lastMessageAuthorIconUrl']?.toString();
                if (lastMessageAuthorIconUrl != null && lastMessageAuthorIconUrl.isNotEmpty) {
                  participants[existingIndex] = FCParticipant(
                    userId: participants[existingIndex].userId,
                    username: participants[existingIndex].username,
                    iconUrl: lastMessageAuthorIconUrl,
                    isOnline: participants[existingIndex].isOnline,
                  );
                }
              } else {
                // Add last message author if not already in list
                final lastMessageAuthorUsername = convData['lastMessageAuthor']?.toString() ?? 'Unknown';
                final lastMessageAuthorIconUrl = convData['lastMessageAuthorIconUrl']?.toString();
                participants.add(FCParticipant(
                  userId: lastMessageAuthorId,
                  username: lastMessageAuthorUsername,
                  iconUrl: lastMessageAuthorIconUrl,
                  isOnline: null,
                ));
              }
            }
            
            // Map PHP response structure to FCConversationSummary
            // Standardize on newPost as the primary field (hasUnread is computed from newPost)
            final isUnread = convData['isUnread'] ?? false;
            conversationList.add(FCConversationSummary(
              convId: convData['id']?.toString() ?? '',
              replyCount: (convData['messageCount'] ?? 0).toString(),
              participantCount: convData['participantCount'] ?? participants.length,
              startUserId: convData['startUserId']?.toString(),
              startTime: startTimeStr,
              subject: convData['title']?.toString(),
              // Use lastMessageAuthorId (user ID) instead of lastMessageAuthor (username)
              // Fallback to lastMessageAuthor for backward compatibility
              lastUserId: convData['lastMessageAuthorId']?.toString() ?? 
                         convData['lastMessageAuthor']?.toString(),
              lastReplyTime: lastReplyTimeStr, // Last message timestamp from API
              lastConvTime: lastReplyTimeStr, // Compatibility field (same as lastReplyTime)
              newPost: isUnread, // Primary field - hasUnread is computed from this
              participants: participants.isNotEmpty ? participants : null,
              messageId: convData['messageId']?.toString(),
              unreadMessageCount: convData['unreadMessageCount'] is int 
                  ? convData['unreadMessageCount'] as int
                  : (convData['unreadMessageCount'] != null 
                      ? int.tryParse(convData['unreadMessageCount'].toString()) 
                      : null),
            ));
          }
        }
      }

      return FCConversationsResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        conversationCount: response['conversationCount'] ?? 0,
        unreadCount: response['unreadCount'] ?? 0,
        canUpload: response['canUpload'] ?? false,
        list: conversationList,
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] getConversationsAsync error: $e');
      return FCConversationsResult(
        result: false,
        resultText: 'Error getting conversations: $e',
        conversationCount: 0,
        unreadCount: 0,
        canUpload: false,
        list: [],
      );
    }
  }

  /// Parse likes info from API response
  List<FCLike> _parseLikesInfo(dynamic likesInfoData) {
    if (likesInfoData == null || likesInfoData is! List) {
      return [];
    }
    
    return likesInfoData.map((likeData) {
      if (likeData is Map<String, dynamic>) {
        return FCLike(
          userId: likeData['userId']?.toString() ?? '',
          username: likeData['username']?.toString() ?? '',
          avatarUrl: likeData['avatarUrl']?.toString() ?? '',
          timestamp: likeData['timestamp'] != null
              ? DateTime.fromMillisecondsSinceEpoch(likeData['timestamp'] as int)
              : null,
        );
      }
      return null;
    }).whereType<FCLike>().toList();
  }

  /// Parse attachments from API response
  List<FCAttachment> _parseAttachments(dynamic attachmentsData) {
    if (attachmentsData == null || attachmentsData is! List) {
      return [];
    }
    
    return attachmentsData.map((attData) {
      if (attData is Map<String, dynamic>) {
        return FCAttachment(
          id: attData['id']?.toString() ?? '',
          filename: attData['fileName']?.toString() ?? '',
          contentType: attData['mimeType']?.toString() ?? '',
          fileSize: attData['fileSize'] is int ? attData['fileSize'] as int : (int.tryParse(attData['fileSize']?.toString() ?? '0') ?? 0),
          url: attData['url']?.toString() ?? '',
          thumbnailUrl: attData['thumbnailUrl']?.toString(),
          isImage: attData['isImage'] ?? false,
          forumId: '', // Not available in conversation message attachments
          postId: '', // Not available in conversation message attachments
          canViewUrl: attData['canViewUrl'] ?? false,
          canViewThumbnailUrl: attData['canViewThumbnailUrl'] ?? false,
          groupId: attData['groupId']?.toString(),
          width: attData['width'] is int ? attData['width'] as int? : (attData['width'] != null ? int.tryParse(attData['width'].toString()) : null),
          height: attData['height'] is int ? attData['height'] as int? : (attData['height'] != null ? int.tryParse(attData['height'].toString()) : null),
        );
      }
      return null;
    }).whereType<FCAttachment>().toList();
  }

  @override
  Future<FCConversationResult> getConversationAsync(String conversationId, int startNum, int lastNum, bool returnHtml) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] getConversationAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId, startNum=$startNum, lastNum=$lastNum');

    try {
      final response = await callPluginApi('getConversation', {
        'conversationId': conversationId,
        'startNum': startNum,
        'lastNum': lastNum,
        'returnHtml': returnHtml,
      });

      // Parse participants - PHP returns array with participant data
      final List<FCParticipant> participants = [];
      if (response['participants'] != null && response['participants'] is List) {
        for (var partData in response['participants'] as List) {
          if (partData is Map<String, dynamic>) {
            participants.add(FCParticipant(
              userId: partData['id']?.toString() ?? '',
              username: partData['username']?.toString() ?? '',
              iconUrl: partData['iconUrl']?.toString(),
            ));
          }
        }
      }

      // Parse messages - PHP returns array with message data
      final List<FCConversationMessage> messages = [];
      if (response['messages'] != null && response['messages'] is List) {
        for (var msgData in response['messages'] as List) {
          if (msgData is Map<String, dynamic>) {
            // Convert API response structure to match FCConversationMessage field names
            final messageMap = <String, dynamic>{
              'messageId': msgData['id']?.toString() ?? '',
              'userId': msgData['authorId']?.toString() ?? '',
              'username': msgData['authorName']?.toString() ?? '',
              'iconUrl': msgData['authorIconUrl']?.toString(),
              'textBody': msgData['messageContent']?.toString() ?? '',
              'messageTime': msgData['timestamp']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
              'canLike': msgData['canLike'] ?? false,
              'isLiked': msgData['isLiked'] ?? false,
              'likeCount': msgData['likeCount'] ?? 0,
              'likesInfo': _parseLikesInfo(msgData['likesInfo']),
              'attachments': _parseAttachments(msgData['attachments']),
              'isUnread': msgData['isUnread'],
              'isFirstMessage': msgData['isFirstMessage'],
              'canReport': msgData['canReport'],
              'isIgnored': msgData['isIgnored'],
              'canEdit': msgData['canEdit'],
              'messageNumber': msgData['messageNumber'],
            };
            
            // Use mapper to create FCConversationMessage with proper field mapping
            messages.add(FCConversationMessageMapper.fromMap(messageMap));
          }
        }
      }

      return FCConversationResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        convId: response['convId']?.toString() ?? conversationId,
        subject: response['subject']?.toString(),
        convTitle: response['convTitle']?.toString() ?? response['subject']?.toString(),
        participants: participants,
        messages: messages,
        participantCount: response['participantCount'] != null ? int.tryParse(response['participantCount'].toString()) : participants.length,
        canReply: response['canReply'] as bool?,
        canInvite: response['canInvite'] as bool?,
        canEdit: response['canEdit'] as bool?,
        canClose: response['canClose'] as bool?,
        isClosed: response['isClosed'] as bool?,
        totalMessageNum: response['totalMessageNum'] != null ? int.tryParse(response['totalMessageNum'].toString()) : null,
        lastRead: response['lastRead'] != null ? int.tryParse(response['lastRead'].toString()) : null,
        canUpload: response['canUpload'] as bool?,
        position: response['position'] != null ? int.tryParse(response['position'].toString()) : null,
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] getConversationAsync error: $e');
      return FCConversationResult(
        result: false,
        resultText: 'Error getting conversation: $e',
        participants: [],
        convId: conversationId,
        messages: [],
      );
    }
  }

  @override
  Future<FCConversationResult> getConversationByMessageAsync(String messageId, {int messagesPerRequest = 20}) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] getConversationByMessageAsync called via plugin API');
    print('   📋 Parameters: messageId=$messageId, messagesPerRequest=$messagesPerRequest');

    try {
      final response = await callPluginApi('getConversationByMessage', {
        'messageId': messageId,
        'messagesPerRequest': messagesPerRequest,
      });

      // Parse participants - PHP returns array with participant data
      final List<FCParticipant> participants = [];
      if (response['participants'] != null && response['participants'] is List) {
        for (var partData in response['participants'] as List) {
          if (partData is Map<String, dynamic>) {
            participants.add(FCParticipant(
              userId: partData['id']?.toString() ?? '',
              username: partData['username']?.toString() ?? '',
              iconUrl: partData['iconUrl']?.toString(),
            ));
          }
        }
      }

      // Parse messages - PHP returns array with message data
      final List<FCConversationMessage> messages = [];
      if (response['messages'] != null && response['messages'] is List) {
        for (var msgData in response['messages'] as List) {
          if (msgData is Map<String, dynamic>) {
            // Convert API response structure to match FCConversationMessage field names
            final messageMap = <String, dynamic>{
              'messageId': msgData['id']?.toString() ?? '',
              'userId': msgData['authorId']?.toString() ?? '',
              'username': msgData['authorName']?.toString() ?? '',
              'iconUrl': msgData['authorIconUrl']?.toString(),
              'textBody': msgData['messageContent']?.toString() ?? '',
              'messageTime': msgData['timestamp']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
              'canLike': msgData['canLike'] ?? false,
              'isLiked': msgData['isLiked'] ?? false,
              'likeCount': msgData['likeCount'] ?? 0,
              'likesInfo': _parseLikesInfo(msgData['likesInfo']),
              'attachments': _parseAttachments(msgData['attachments']),
              'isUnread': msgData['isUnread'],
              'isFirstMessage': msgData['isFirstMessage'],
              'canReport': msgData['canReport'],
              'isIgnored': msgData['isIgnored'],
              'canEdit': msgData['canEdit'],
              'messageNumber': msgData['messageNumber'],
            };
            
            // Use mapper to create FCConversationMessage with proper field mapping
            messages.add(FCConversationMessageMapper.fromMap(messageMap));
          }
        }
      }

      final result = FCConversationResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        convId: response['convId']?.toString() ?? '',
        subject: response['subject']?.toString(),
        convTitle: response['convTitle']?.toString() ?? response['subject']?.toString(),
        participants: participants,
        messages: messages,
        participantCount: response['participantCount'] != null ? int.tryParse(response['participantCount'].toString()) : participants.length,
        canReply: response['canReply'] as bool?,
        canInvite: response['canInvite'] as bool?,
        canEdit: response['canEdit'] as bool?,
        canClose: response['canClose'] as bool?,
        isClosed: response['isClosed'] as bool?,
        totalMessageNum: response['totalMessageNum'] != null ? int.tryParse(response['totalMessageNum'].toString()) : null,
        lastRead: response['lastRead'] != null ? int.tryParse(response['lastRead'].toString()) : null,
        canUpload: response['canUpload'] as bool?,
        position: response['position'] != null ? int.tryParse(response['position'].toString()) : null,
      );
      
      return result;
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] getConversationByMessageAsync error: $e');
      return FCConversationResult(
        result: false,
        resultText: 'Error getting conversation by message: $e',
        participants: [],
        convId: '',
        messages: [],
      );
    }
  }

  @override
  Future<FCQuoteConversationResult> getQuoteConversationAsync(String conversationId, String messageId) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] getQuoteConversationAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId, messageId=$messageId');

    try {
      // API only requires messageId
      final response = await callPluginApi('getQuoteConversation', {
        'messageId': messageId,
      });

      print('   📥 [XENFORO_PRIVATE_CONVERSATION] getQuoteConversation response keys: ${response.keys.toList()}');
      print('   📥 [XENFORO_PRIVATE_CONVERSATION] getQuoteConversation quote: ${response['quote']}');
      print('   📥 [XENFORO_PRIVATE_CONVERSATION] getQuoteConversation quote type: ${response['quote']?.runtimeType}');
      print('   📥 [XENFORO_PRIVATE_CONVERSATION] getQuoteConversation quoteContent: ${response['quoteContent']}');

      // PHP API returns 'quote' in the JSON response, but the result class uses 'quoteContent'
      // Try both 'quote' and 'quoteContent' for compatibility
      String? quoteText;
      final quoteValue = response['quote'];
      if (quoteValue != null) {
        quoteText = quoteValue is String ? quoteValue : quoteValue.toString();
      } else {
        final quoteContentValue = response['quoteContent'];
        if (quoteContentValue != null) {
          quoteText = quoteContentValue is String ? quoteContentValue : quoteContentValue.toString();
        }
      }
      
      print('   📥 [XENFORO_PRIVATE_CONVERSATION] getQuoteConversation quoteText (after processing): $quoteText');
      print('   📥 [XENFORO_PRIVATE_CONVERSATION] getQuoteConversation quoteText is null: ${quoteText == null}');
      print('   📥 [XENFORO_PRIVATE_CONVERSATION] getQuoteConversation quoteText isEmpty: ${quoteText?.isEmpty ?? true}');
      
      final result = FCQuoteConversationResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        quoteText: quoteText,
      );
      print('   📥 [XENFORO_PRIVATE_CONVERSATION] getQuoteConversation result.quoteText: ${result.quoteText}');
      return result;
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] getQuoteConversationAsync error: $e');
      return FCQuoteConversationResult(
        result: false,
        resultText: 'Error getting quote: $e',
      );
    }
  }

  @override
  Future<FCLeaveConversationResult> leaveConversationAsync(String conversationId, int mode) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] leaveConversationAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId, mode=$mode');

    try {
      final response = await callPluginApi('leaveConversation', {
        'conversationId': conversationId,
        'mode': mode,
      });

      return FCLeaveConversationResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] leaveConversationAsync error: $e');
      return FCLeaveConversationResult(
        result: false,
        resultText: 'Error leaving conversation: $e',
      );
    }
  }

  @override
  Future<FCMarkConversationUnreadResult> markConversationUnreadAsync(String conversationId) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] markConversationUnreadAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId');

    try {
      final response = await callPluginApi('markConversationUnread', {
        'conversationId': conversationId,
      });

      print('📥 [XENFORO_PRIVATE_CONVERSATION] markConversationUnreadAsync response: $response');
      
      final result = response['result'] ?? false;
      final resultText = response['resultText']?.toString() ?? '';
      
      print('📥 [XENFORO_PRIVATE_CONVERSATION] Parsed result: result=$result, resultText=$resultText');

      return FCMarkConversationUnreadResult(
        result: result,
        resultText: resultText,
      );
    } catch (e, stackTrace) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] markConversationUnreadAsync error: $e');
      print('❌ [XENFORO_PRIVATE_CONVERSATION] Stack trace: $stackTrace');
      return FCMarkConversationUnreadResult(
        result: false,
        resultText: 'Error marking conversation as unread: $e',
      );
    }
  }

  @override
  Future<FCMarkConversationReadResult> markConversationReadAsync(String conversationId) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] markConversationReadAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId');

    try {
      final response = await callPluginApi('markConversationRead', {
        'conversationId': conversationId,
      });

      return FCMarkConversationReadResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] markConversationReadAsync error: $e');
      return FCMarkConversationReadResult(
        result: false,
        resultText: 'Error marking conversation as read: $e',
      );
    }
  }

  @override
  Future<FCCloseConversationResult> closeConversationAsync(String conversationId) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] closeConversationAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId');

    try {
      final response = await callPluginApi('closeConversation', {
        'conversationId': conversationId,
      });

      return FCCloseConversationResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] closeConversationAsync error: $e');
      return FCCloseConversationResult(
        result: false,
        resultText: 'Error closing conversation: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCCloseConversationResult> uncloseConversationAsync(String conversationId) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] uncloseConversationAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId');

    try {
      final response = await callPluginApi('uncloseConversation', {
        'conversationId': conversationId,
      });

      return FCCloseConversationResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] uncloseConversationAsync error: $e');
      return FCCloseConversationResult(
        result: false,
        resultText: 'Error opening conversation: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCRawConversationResult> getRawConversationAsync(String conversationId) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] getRawConversationAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId');

    try {
      final response = await callPluginApi('getRawConversation', {
        'conversationId': conversationId,
      });

      return FCRawConversationResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        conversationTitle: response['conversationTitle']?.toString(),
        openInvite: response['openInvite'] as bool?,
        conversationOpen: response['conversationOpen'] as bool?,
        canEdit: response['canEdit'] as bool?,
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] getRawConversationAsync error: $e');
      return FCRawConversationResult(
        result: false,
        resultText: 'Error getting raw conversation: $e',
      );
    }
  }

  @override
  Future<FCSaveRawConversationResult> saveRawConversationAsync(
    String conversationId, {
    String? conversationTitle,
    bool? openInvite,
    bool? conversationOpen,
  }) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] saveRawConversationAsync called via plugin API');
    print('   📋 Parameters: conversationId=$conversationId, conversationTitle=$conversationTitle, openInvite=$openInvite, conversationOpen=$conversationOpen');

    try {
      final params = <String, dynamic>{
        'conversationId': conversationId,
      };
      if (conversationTitle != null && conversationTitle.isNotEmpty) {
        params['conversationTitle'] = conversationTitle;
      }
      if (openInvite != null) {
        params['openInvite'] = openInvite;
      }
      if (conversationOpen != null) {
        params['conversationOpen'] = conversationOpen;
      }

      final response = await callPluginApi('saveRawConversation', params);

      return FCSaveRawConversationResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        conversationTitle: response['conversationTitle']?.toString(),
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] saveRawConversationAsync error: $e');
      return FCSaveRawConversationResult(
        result: false,
        resultText: 'Error saving raw conversation: $e',
      );
    }
  }

  @override
  Future<FCRawMessageResult> getRawMessageAsync(String messageId) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] getRawMessageAsync called via plugin API');
    print('   📋 Parameters: messageId=$messageId');

    try {
      final response = await callPluginApi('getRawMessage', {
        'messageId': messageId,
      });

      // Parse attachments if present (using same pattern as getConversationAsync)
      List<FCAttachment>? attachments;
      if (response['attachments'] != null && response['attachments'] is List) {
        final attachmentsData = response['attachments'] as List;
        attachments = attachmentsData.map((attData) {
          if (attData is Map<String, dynamic>) {
            return FCAttachment(
              id: attData['attachmentId']?.toString() ?? attData['id']?.toString() ?? '',
              filename: attData['fileName']?.toString() ?? '',
              contentType: attData['mimeType']?.toString() ?? '',
              fileSize: attData['fileSize'] is int ? attData['fileSize'] as int : (int.tryParse(attData['fileSize']?.toString() ?? '0') ?? 0),
              url: attData['url']?.toString() ?? '',
              thumbnailUrl: attData['thumbnailUrl']?.toString(),
              isImage: attData['isImage'] ?? false,
              forumId: '', // Not available in conversation message attachments
              postId: '', // Not available in conversation message attachments
              canViewUrl: attData['canViewUrl'] ?? false,
              canViewThumbnailUrl: attData['canViewThumbnailUrl'] ?? false,
              groupId: attData['groupId']?.toString(),
              width: attData['width'] is int ? attData['width'] as int? : (attData['width'] != null ? int.tryParse(attData['width'].toString()) : null),
              height: attData['height'] is int ? attData['height'] as int? : (attData['height'] != null ? int.tryParse(attData['height'].toString()) : null),
              fileSizePrintable: attData['fileSizePrintable']?.toString(),
            );
          }
          return null;
        }).whereType<FCAttachment>().toList();
      }

      return FCRawMessageResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        messageContent: response['messageContent']?.toString(),
        attachments: attachments,
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] getRawMessageAsync error: $e');
      return FCRawMessageResult(
        result: false,
        resultText: 'Error getting raw message: $e',
      );
    }
  }

  @override
  Future<FCSaveRawMessageResult> saveRawMessageAsync(
    String messageId,
    String messageContent, {
    List<String>? attachmentIds,
    String? groupId,
  }) async {
    print('✅ [XENFORO_PRIVATE_CONVERSATION] saveRawMessageAsync called via plugin API');
    print('   📋 Parameters: messageId=$messageId, messageContent length=${messageContent.length}');
    if (attachmentIds != null && attachmentIds.isNotEmpty) {
      print('   📋 Attachment IDs: $attachmentIds');
    }
    if (groupId != null && groupId.isNotEmpty) {
      print('   📋 Group ID: $groupId');
    }

    try {
      final params = <String, dynamic>{
        'messageId': messageId,
        'messageContent': messageContent,
      };
      if (attachmentIds != null && attachmentIds.isNotEmpty) {
        params['attachmentIds'] = attachmentIds;
      }
      if (groupId != null && groupId.isNotEmpty) {
        params['groupId'] = groupId;
      }

      final response = await callPluginApi('saveRawMessage', params);

      return FCSaveRawMessageResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        messageContent: response['messageContent']?.toString(),
      );
    } catch (e) {
      print('❌ [XENFORO_PRIVATE_CONVERSATION] saveRawMessageAsync error: $e');
      return FCSaveRawMessageResult(
        result: false,
        resultText: 'Error saving raw message: $e',
      );
    }
  }
}

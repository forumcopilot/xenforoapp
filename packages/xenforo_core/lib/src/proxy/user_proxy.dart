import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_user_proxy.dart';
import 'package:forumcopilot_sdk/models/entities/fc_user.dart';
import 'package:forumcopilot_sdk/models/entities/fc_tfa_provider.dart';
import 'package:forumcopilot_sdk/models/results/fc_passkey_result.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import 'package:forumcopilot_sdk/services/fc_http_overrides.dart';
import '../base_xenforo_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_directory_result.dart';

/// XenForo implementation of IFCUserProxy
/// Handles user operations and profile management for XenForo forums
class XenForoUserProxy extends BaseXenForoProxy implements IFCUserProxy {
  XenForoUserProxy(SiteContext context) : super(context);

  @override
  Future<String> getAvatarAsync(String userId, String username) {
    // TODO: implement getAvatarAsync
    throw UnimplementedError();
  }

  @override
  Future<FCIgnoredUserResult> getIgnoredUsersAsync(int page, int perpage) {
    // TODO: implement getIgnoredUsersAsync
    throw UnimplementedError();
  }

  @override
  Future<FCInboxStatResult> getInboxStatAsync(DateTime pmLastCheckedTime, DateTime subscribedTopicLastCheckedTime) {
    // TODO: implement getInboxStatAsync
    throw UnimplementedError();
  }

  @override
  Future<FCOnlineUserResult> getOnlineUsersAsync(int page, int perpage, String? id, String? area) async {
    print('✅ [XENFORO_USER] getOnlineUsersAsync called via plugin API');

    try {
      final params = <String, dynamic>{
        'page': page,
        'perpage': perpage,
      };
      if (id != null && id.isNotEmpty) {
        params['id'] = id;
      }
      if (area != null && area.isNotEmpty) {
        params['area'] = area;
      }

      final response = await callPluginApi('getOnlineUsers', params);

      // Parse user list
      final List<FCOnlineUser> userList = [];
      if (response['list'] != null && response['list'] is List) {
        for (var userData in response['list'] as List) {
          if (userData is Map<String, dynamic>) {
            userList.add(FCOnlineUser(
              id: userData['id']?.toString() ?? '',
              username: userData['username']?.toString() ?? '',
              iconUrl: userData['iconUrl']?.toString(),
              isOnline: userData['isOnline'] ?? false,
              currentActivity: userData['currentActivity']?.toString(),
              currentActivityUrl: userData['currentActivityUrl']?.toString(),
              currentTopicId: userData['currentTopicId']?.toString(),
              lastActivityTime: userData['lastActivityTime'] != null ? DateTime.fromMillisecondsSinceEpoch(userData['lastActivityTime'] as int) : null,
            ));
          }
        }
      }

      return FCOnlineUserResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        total: response['total'] ?? 0,
        list: userList,
      );
    } catch (e) {
      print('❌ [XENFORO_USER] getOnlineUsersAsync error: $e');
      return FCOnlineUserResult(
        result: false,
        resultText: 'Error getting online users: $e',
        total: 0,
        list: [],
      );
    }
  }

  @override
  Future<FCRecommendedUserResult> getRecommendedUsersAsync(int page, int perpage, int mode) {
    // TODO: implement getRecommendedUsersAsync
    throw UnimplementedError();
  }

  @override
  Future<FCUserInfoResult> getUserInfoAsync(String? username, String? userId) async {
    print('✅ [XENFORO_USER] getUserInfo called - IMPLEMENTED');
    print('   📋 Parameters: username=$username, userId=$userId');

    try {
      final response = await callPluginApi('getUserInfo', {
        'username': username,
        'userId': userId,
      });

      // Parse registrationTime and lastActivityTime from milliseconds
      DateTime? registrationTime;
      if (response['registrationTime'] != null) {
        registrationTime = DateTime.fromMillisecondsSinceEpoch(int.tryParse(response['registrationTime'].toString()) ?? 0);
      }

      DateTime? lastActivityTime;
      if (response['lastActivityTime'] != null) {
        lastActivityTime = DateTime.fromMillisecondsSinceEpoch(int.tryParse(response['lastActivityTime'].toString()) ?? 0);
      }

      // Parse customFields from array
      // Can be: array of objects with name/value, or associative array (Map)
      List<FCUserCustomField> customFields = [];
      if (response['customFields'] != null) {
        if (response['customFields'] is List) {
          for (var field in response['customFields'] as List) {
            if (field is Map<String, dynamic>) {
              // Handle object format: {name: "...", value: "..."}
              if (field.containsKey('name') && field.containsKey('value')) {
                customFields.add(FCUserCustomField(
                  name: field['name']?.toString() ?? '',
                  value: field['value']?.toString() ?? '',
                ));
              }
            }
          }
        } else if (response['customFields'] is Map) {
          // Handle associative array format: {fieldName: fieldValue, ...}
          final fieldsMap = response['customFields'] as Map;
          fieldsMap.forEach((key, value) {
            customFields.add(FCUserCustomField(
              name: key.toString(),
              value: value?.toString() ?? '',
            ));
          });
        }
      }

      // Parse userGroups from array
      List<String> userGroups = [];
      if (response['userGroups'] != null && response['userGroups'] is List) {
        userGroups = (response['userGroups'] as List).map((e) => e.toString()).toList();
      }

      return FCUserInfoResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        // FCUser required fields
        id: response['id']?.toString() ?? '',
        username: response['username']?.toString() ?? '',
        // FCUser optional fields
        loginName: response['loginName']?.toString(),
        userType: response['userType']?.toString(),
        iconUrl: response['iconUrl']?.toString(),
        postCount: response['postCount'] != null ? int.tryParse(response['postCount'].toString()) ?? 0 : 0,
        registrationTime: registrationTime,
        lastActivityTime: lastActivityTime,
        isOnline: response['isOnline'] ?? false,
        // New fields replacing canPM/canSendPM
        acceptsPM: response['acceptsPM'] ?? false,
        // Deprecated fields (set to false for backward compatibility)
        canSendPM: false, // Removed from API - use acceptsPM instead
        canPM: false, // Removed from API - use acceptsPM instead
        // Following relationships
        isFollowing: response['isFollowing'] ?? false,
        isFollowingMe: response['isFollowingMe'] ?? false,
        acceptsFollowers: response['acceptsFollowers'] ?? false,
        followingCount: response['followingCount'] != null ? int.tryParse(response['followingCount'].toString()) ?? 0 : 0,
        followerCount: response['followerCount'] != null ? int.tryParse(response['followerCount'].toString()) ?? 0 : 0,
        // Moderation fields
        canBan: response['canBan'] ?? false,
        isBanned: response['isBanned'] ?? false,
        isIgnored: response['isIgnored'] ?? false,
        canSpamClean: response['canSpamClean'] ?? false,
        canBeReported: response['canBeReported'] ?? false,
        userGroups: userGroups,
        customFields: customFields,
        // Removed fields (set to defaults)
        canModerate: false, // Removed from API
        canSearch: false, // Removed from API
        currentActivity: null, // Removed from API
        currentTopicId: null, // Removed from API
        displayText: response['displayText']?.toString(),
        email: null, // Removed from API
        // Profile fields
        location: response['location']?.toString(),
        website: response['website']?.toString(),
        signature: response['signature']?.toString(),
        bio: response['about']?.toString(), // Map 'about' from API to 'bio' field
      );
    } catch (e) {
      print('❌ [XENFORO_USER] getUserInfo error: $e');
      return FCUserInfoResult(
        result: false,
        resultText: 'Error getting user info: $e',
        id: '',
        username: '',
      );
    }
  }

  @override
  Future<FCUserReplyResult> getUserReplyPostAsync(int startNum, int lastNum, String? searchId, String? username, String? userId) async {
    print('✅ [XENFORO_USER] getUserReplyPostAsync called via plugin API');

    try {
      final params = <String, dynamic>{
        'startNum': startNum,
        'lastNum': lastNum,
      };
      if (searchId != null && searchId.isNotEmpty) {
        params['searchId'] = searchId;
      }
      if (username != null && username.isNotEmpty) {
        params['username'] = username;
      }
      if (userId != null && userId.isNotEmpty) {
        params['userId'] = userId;
      }

      final response = await callPluginApi('getUserReplyPost', params);

      // Parse reply list
      final List<FCUserReply> replyList = [];
      if (response['list'] != null && response['list'] is List) {
        for (var replyData in response['list'] as List) {
          if (replyData is Map<String, dynamic>) {
            replyList.add(FCUserReply(
              postId: replyData['postId']?.toString() ?? '',
              topicId: replyData['topicId']?.toString() ?? '',
              topicTitle: replyData['topicTitle']?.toString() ?? '',
              forumId: replyData['forumId']?.toString() ?? '',
              forumName: replyData['forumName']?.toString() ?? '',
              authorId: replyData['authorId']?.toString() ?? '',
              authorName: replyData['authorName']?.toString() ?? '',
              authorIconUrl: replyData['authorIconUrl']?.toString(),
              postTime: replyData['postTime'] != null ? DateTime.fromMillisecondsSinceEpoch(replyData['postTime'] as int) : DateTime.now(),
              replyNumber: replyData['replyNumber'] ?? 0,
              postContent: replyData['postContent']?.toString(),
              shortContent: replyData['shortContent']?.toString(),
            ));
          }
        }
      }

      return FCUserReplyResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        total: response['total'] ?? 0,
        list: replyList,
      );
    } catch (e) {
      print('❌ [XENFORO_USER] getUserReplyPostAsync error: $e');
      return FCUserReplyResult(
        result: false,
        resultText: 'Error getting user reply posts: $e',
        total: 0,
        list: [],
      );
    }
  }

  @override
  Future<FCUserTopicResult> getUserTopicAsync(String? username, String? userId) {
    // TODO: implement getUserTopicAsync
    throw UnimplementedError();
  }

  @override
  Future<FCIgnoreUserResult> ignoreUserAsync(String userId, int mode) {
    // TODO: implement ignoreUserAsync
    throw UnimplementedError();
  }

  @override
  Future<FCLoginResult> loginAsync(
    String loginname,
    String password,
    bool anonymous,
    String? trustCode, {
    bool remember = true,
    String? tfaCode,
    String? tfaProvider,
    String? webauthnChallenge,
    Map<String, String>? webauthnPayload,
    bool trustDevice = false,
  }) async {
    print('✅ [XENFORO_USER] login called - IMPLEMENTED');
    print(
        '   📋 Parameters: loginname=$loginname, password=***, anonymous=$anonymous, trustCode=$trustCode, tfaCode=${tfaCode != null ? '***' : null}, tfaProvider=$tfaProvider, trustDevice=$trustDevice');

    try {
      final cookieCountBefore = await FCDioClient.instance.cookieCountForUrl(Uri.parse(siteContext.site.pluginUrl));
      print('🍪 [XENFORO_USER] Cookie count before login: $cookieCountBefore');

      final params = <String, dynamic>{
        'loginname': loginname,
        'password': password,
        'anonymous': anonymous,
        'remember': remember,
      };

      if (trustCode != null) {
        params['trustCode'] = trustCode;
      }

      // Add TFA parameters if provided
      if (tfaCode != null) {
        params['tfaCode'] = tfaCode;
      }
      if (tfaProvider != null) {
        params['tfaProvider'] = tfaProvider;
      }
      if (webauthnChallenge != null) {
        params['webauthn_challenge'] = webauthnChallenge;
      }
      if (webauthnPayload != null) {
        params['webauthn_payload'] = webauthnPayload;
      }
      if (trustDevice) {
        params['trustDevice'] = true;
      }

      final response = await callPluginApi('login', params);
      final setCookieHeader = siteContext.lastCallResponse?.headers['set-cookie'] ?? siteContext.lastCallResponse?.headers['Set-Cookie'];
      print('🍪 [XENFORO_USER] Login response Set-Cookie present: ${setCookieHeader != null && setCookieHeader.isNotEmpty}');
      final loginResult = _buildLoginResult(
        response,
        password: password,
        trustCode: trustCode,
      );

      // Clear cache after successful login
      // This ensures fresh data is loaded after authentication
      // Note: Cookies are NOT cleared - they are maintained for session persistence
      if (loginResult.result) {
        siteContext.setLoginData(loginResult);
        siteContext.resetOnLogin();
        print('✅ [XENFORO_USER] Login data saved to SiteContext');
        final cookieCountAfter = await FCDioClient.instance.cookieCountForUrl(Uri.parse(siteContext.site.pluginUrl));
        print('🍪 [XENFORO_USER] Cookie count after login: $cookieCountAfter');
      }

      return loginResult;
    } catch (e) {
      print('❌ [XENFORO_USER] login error: $e');
      return FCLoginResult(
        result: false,
        resultText: 'Error logging in: $e',
        user: null,
        canWhosonline: false,
        canProfile: false,
        canUploadAvatar: false,
        maxAttachment: 0,
        maxPngSize: 0,
        maxJpgSize: 0,
        postCountdown: 0,
      );
    }
  }

  FCLoginResult _buildLoginResult(
    Map<String, dynamic> response, {
    String? password,
    String? trustCode,
  }) {
    // Parse user from response
    FCUser? user;
    if (response['user'] != null && response['user'] is Map<String, dynamic>) {
      final userData = response['user'] as Map<String, dynamic>;
      user = FCUser(
        id: userData['id']?.toString() ?? '',
        username: userData['username']?.toString() ?? '',
        loginName: userData['loginName']?.toString() ?? userData['username']?.toString() ?? '',
        email: userData['email']?.toString(),
        userType: userData['userType']?.toString(),
        iconUrl: userData['iconUrl']?.toString(),
        postCount: userData['postCount'] ?? 0,
        registrationTime: userData['registrationTime'] != null ? DateTime.fromMillisecondsSinceEpoch(userData['registrationTime'] as int) : null,
        lastActivityTime: userData['lastActivityTime'] != null ? DateTime.fromMillisecondsSinceEpoch(userData['lastActivityTime'] as int) : null,
        isOnline: userData['isOnline'] ?? true,
        canPM: userData['canPM'] ?? false,
        canSendPM: userData['canSendPM'] ?? false,
        canModerate: userData['canModerate'] ?? false,
        canSearch: userData['canSearch'] ?? true,
        userGroups: userData['userGroups'] != null ? (userData['userGroups'] as List).map((e) => e.toString()).toList() : [],
        userState: userData['userState']?.toString() ?? 'valid',
      );
    }

    // Parse allowedFileExtensions - can be array or comma-separated string
    List<String>? allowedFileExtensionsList;
    if (response['allowedFileExtensions'] != null) {
      if (response['allowedFileExtensions'] is List) {
        allowedFileExtensionsList = (response['allowedFileExtensions'] as List).map((e) => e.toString().toLowerCase()).toList();
      } else if (response['allowedFileExtensions'] is String) {
        final extensionsStr = response['allowedFileExtensions'] as String;
        allowedFileExtensionsList = extensionsStr.split(',').map((e) => e.trim().toLowerCase()).where((e) => e.isNotEmpty).toList();
      }
    }
    // Fallback to allowedExtensions string if allowedFileExtensions not present
    if (allowedFileExtensionsList == null && response['allowedExtensions'] != null) {
      final extensionsStr = response['allowedExtensions'].toString();
      allowedFileExtensionsList = extensionsStr.split(',').map((e) => e.trim().toLowerCase()).where((e) => e.isNotEmpty).toList();
    }

    // Parse maxAttachmentSize - use maxAttachmentSize if present, otherwise fallback to maxPngSize
    final maxAttachmentSize = response['maxAttachmentSize'] != null
        ? (response['maxAttachmentSize'] is int ? response['maxAttachmentSize'] as int : int.tryParse(response['maxAttachmentSize'].toString()) ?? 0)
        : (response['maxPngSize'] ?? 0);

    // Parse TFA providers if present
    List<FCTFAProvider>? providers;
    if (response['providers'] != null && response['providers'] is List) {
      providers = [];
      for (var providerData in response['providers'] as List) {
        if (providerData is Map<String, dynamic>) {
          providers.add(FCTFAProvider(
            id: providerData['id']?.toString() ?? '',
            title: providerData['title']?.toString() ?? '',
            description: providerData['description']?.toString() ?? '',
            type: providerData['type']?.toString(),
          ));
        }
      }
    }

    // Parse TFA fields
    final tfaRequired = response['tfaRequired'] ?? response['twoStepRequired'] ?? false;
    final providerId = response['providerId']?.toString();

    final availableTfaMethods = response['availableTfaMethods'];
    bool passkeyAvailable = false;
    bool codeAvailable = false;
    if (availableTfaMethods is Map) {
      passkeyAvailable = availableTfaMethods['passkey'] == true;
      codeAvailable = availableTfaMethods['code'] == true;
    }
    if (providers != null) {
      passkeyAvailable = passkeyAvailable || providers.any((provider) => provider.id == 'passkey' || provider.type == 'passkey');
      codeAvailable = codeAvailable || providers.any((provider) => provider.type == 'code' || provider.id == 'totp' || provider.id == 'backup' || provider.id == 'email');
    }

    final passkeyTimeout = response['passkeyTimeout'] != null ? (response['passkeyTimeout'] is int ? response['passkeyTimeout'] as int : int.tryParse(response['passkeyTimeout'].toString())) : null;

    return FCLoginResult(
      result: response['result'] ?? false,
      resultText: response['resultText']?.toString() ?? '',
      user: user,
      canWhosonline: response['canWhosonline'] ?? false,
      canProfile: response['canProfile'] ?? false,
      canUploadAvatar: response['canUploadAvatar'] ?? false,
      maxAttachment: response['maxAttachment'] ?? 0,
      maxPngSize: response['maxPngSize'] ?? 0,
      maxJpgSize: response['maxJpgSize'] ?? 0,
      ignoredUids: response['ignoredUids']?.toString(),
      allowedExtensions: response['allowedExtensions']?.toString(),
      canUploadAttachment: response['canUploadAttachment'] ?? false,
      canUploadConversationAttachment: response['canUploadConversationAttachment'] ?? false,
      maxAttachmentSize: maxAttachmentSize,
      allowedFileExtensions: allowedFileExtensionsList,
      maxImageWidth: response['maxImageWidth'] != null ? (response['maxImageWidth'] is int ? response['maxImageWidth'] as int : int.tryParse(response['maxImageWidth'].toString()) ?? 0) : 0,
      maxImageHeight: response['maxImageHeight'] != null ? (response['maxImageHeight'] is int ? response['maxImageHeight'] as int : int.tryParse(response['maxImageHeight'].toString()) ?? 0) : 0,
      postCountdown: response['postCountdown'] ?? 0,
      trustCode: response['trustCode']?.toString() ?? trustCode,
      twoStepRequired: response['twoStepRequired'] ?? false,
      tfaRequired: tfaRequired,
      providers: providers,
      providerId: providerId,
      passkeyAvailable: passkeyAvailable,
      codeAvailable: codeAvailable,
      passkeyChallenge: response['passkeyChallenge']?.toString(),
      passkeyRpId: response['passkeyRpId']?.toString(),
      passkeyTimeout: passkeyTimeout,
      userpassword: password, // Store password for internal use
      isProblematicUrl: response['isProblematicUrl'] ?? false,
    );
  }

  @override
  Future<FCPasskeyChallengeResult> getPasskeyChallengeAsync() async {
    print('✅ [XENFORO_USER] getPasskeyChallengeAsync called - IMPLEMENTED');

    final response = await callPluginApi('getPasskeyChallenge', {});
    final timeout = response['timeout'] != null ? (response['timeout'] is int ? response['timeout'] as int : int.tryParse(response['timeout'].toString())) : null;

    return FCPasskeyChallengeResult(
      result: response['result'] ?? true,
      resultText: response['resultText']?.toString(),
      challenge: response['challenge']?.toString(),
      rpId: response['rpId']?.toString(),
      timeout: timeout,
    );
  }

  @override
  Future<FCLoginResult> loginWithPasskeyAsync({
    required String webauthnChallenge,
    required Map<String, String> webauthnPayload,
  }) async {
    print('✅ [XENFORO_USER] loginWithPasskeyAsync called - IMPLEMENTED');

    final response = await callPluginApi('login', {
      'webauthn_challenge': webauthnChallenge,
      'webauthn_payload': webauthnPayload,
      'remember': true,
    });

    final loginResult = _buildLoginResult(response);
    if (loginResult.result) {
      siteContext.setLoginData(loginResult);
      siteContext.resetOnLogin();
      print('✅ [XENFORO_USER] Login data saved to SiteContext (passkey)');
    }

    return loginResult;
  }

  @override
  Future<FCLoginTwoStepResult> loginTwoStepAsync(String codeTwoStep, bool trust) {
    // TODO: implement loginTwoStepAsync
    throw UnimplementedError();
  }

  @override
  Future<void> logoutUserAsync() async {
    print('✅ [XENFORO_USER] logoutUser called - IMPLEMENTED');
    print('   📋 Parameters: none');

    try {
      final cookieCountBefore = await FCDioClient.instance.cookieCountForUrl(Uri.parse(siteContext.site.pluginUrl));
      print('🍪 [XENFORO_USER] Cookie count before logout: $cookieCountBefore');
      await callPluginApi('logout', {});
      final setCookieHeader = siteContext.lastCallResponse?.headers['set-cookie'] ?? siteContext.lastCallResponse?.headers['Set-Cookie'];
      print('🍪 [XENFORO_USER] Logout response Set-Cookie present: ${setCookieHeader != null && setCookieHeader.isNotEmpty}');
      print('✅ [XENFORO_USER] Logout successful');
    } catch (e) {
      print('❌ [XENFORO_USER] logout error: $e');
      // Don't throw - logout should be best effort
    }
    siteContext.resetOnLogout();
    final cookieCountAfter = await FCDioClient.instance.cookieCountForUrl(Uri.parse(siteContext.site.pluginUrl));
    print('🍪 [XENFORO_USER] Cookie count after logout: $cookieCountAfter');
  }

  @override
  Future<FCSearchUserResult> searchUserAsync(String keywords, int page, int perpage) async {
    print('✅ [XENFORO_USER] searchUserAsync called via plugin API');
    print('   📋 Parameters: keywords=$keywords, page=$page, perpage=$perpage');

    try {
      final response = await callPluginApi('searchUser', {
        'keywords': keywords,
        'page': page,
        'perpage': perpage,
      });

      print('📥 [XENFORO_USER] searchUserAsync raw response: $response');

      // Parse total
      final total = response['total'] != null ? int.tryParse(response['total'].toString()) ?? 0 : 0;
      print('📥 [XENFORO_USER] Parsed total: $total');

      // Parse user list
      final List<FCSearchUser> userList = [];
      if (response['list'] != null && response['list'] is List) {
        print('📥 [XENFORO_USER] Parsing ${(response['list'] as List).length} users from response');
        for (var userData in response['list'] as List) {
          if (userData is Map<String, dynamic>) {
            try {
              final user = FCSearchUser(
                id: userData['id']?.toString() ?? '',
                username: userData['username']?.toString() ?? 'Unknown',
                iconUrl: userData['iconUrl']?.toString(),
                postCount: userData['postCount'] != null ? int.tryParse(userData['postCount'].toString()) ?? 0 : 0,
                registrationTime: userData['registrationTime'] != null ? DateTime.fromMillisecondsSinceEpoch(int.tryParse(userData['registrationTime'].toString()) ?? 0) : null,
                isOnline: userData['isOnline'] ?? false,
              );
              userList.add(user);
              print('   ✅ Parsed user: id=${user.id}, username=${user.username}, iconUrl=${user.iconUrl}');
            } catch (e) {
              print('   ❌ Error parsing user: $e, userData: $userData');
            }
          }
        }
      } else {
        print('⚠️  [XENFORO_USER] No list field in response or list is not an array');
      }

      print('📥 [XENFORO_USER] Final result: total=$total, userCount=${userList.length}');

      return FCSearchUserResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        total: total,
        list: userList,
      );
    } catch (e, stackTrace) {
      print('❌ [XENFORO_USER] searchUserAsync error: $e');
      print('❌ [XENFORO_USER] Stack trace: $stackTrace');
      return FCSearchUserResult(
        result: false,
        resultText: 'Error searching users: $e',
        total: 0,
        list: [],
      );
    }
  }

  @override
  Future<FCReportUserResult> reportUserAsync(String userId, String reason) async {
    print('✅ [XENFORO_USER] reportUserAsync called - IMPLEMENTED');
    print('   📋 Parameters: userId=$userId, reason=$reason');

    try {
      final response = await callPluginApi('reportUser', {
        'userId': userId,
        'reason': reason,
      });

      return FCReportUserResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
      );
    } catch (e) {
      print('❌ [XENFORO_USER] reportUserAsync error: $e');
      return FCReportUserResult(
        result: false,
        resultText: 'Error reporting user: $e',
      );
    }
  }

  @override
  Future<FCDirectoryItemResult> getDirectoryItemsAsync(
          String period, String order, int page) async =>
      FCDirectoryItemResult(
          result: false,
          resultText: 'Member directory is not supported on XenForo',
          total: 0,
          items: const []);

  @override
  Future<FCBadgeResult> getAllBadgesAsync() async => FCBadgeResult(
      result: false, resultText: 'Badges are not supported on XenForo');

  @override
  Future<FCBadgeResult> getUserBadgesAsync(String username) async =>
      FCBadgeResult(
          result: false, resultText: 'Badges are not supported on XenForo');
}

# Method Usage Checklist

This document tracks which methods from the test suite are actually used in the Flutter application.

## Legend
- ✅ **USED** - Method is used in the application (included in basic tests)
- ❌ **NOT USED** - Method is tested but not used in the application (NOT in basic tests)
- 🔍 **NEEDS REVIEW** - Method usage unclear or needs verification

---

## IFCForumProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `getForumAsync` | ✅ Tested | ✅ USED | Used in `site_manager.dart`, `forum_list_tab.dart` |
| `getParticipatedForumAsync` | ✅ Tested | ❌ NOT USED | - |
| `markAllAsRead` | ✅ Tested | ✅ USED | Used in `forum_actions.dart` |
| `loginForum` | ✅ Tested | ✅ USED | Used in `forum_actions.dart` |
| `getIdByUrl` | ✅ Tested | ❌ NOT USED | - |
| `getUrlById` | ✅ Tested | ❌ NOT USED | - |
| `getBoardStatAsync` | ✅ Tested | ✅ USED | Used in `forum_list_tab.dart`, `topic_list_tab.dart` |
| `getForumStatusAsync` | ✅ Tested | ❌ NOT USED | - |

---

## IFCTopicProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `markTopicReadAsync` | ✅ Tested | ❌ NOT USED | - |
| `getTopicStatusAsync` | ✅ Tested | ❌ NOT USED | - |
| `newTopic` | ✅ Tested | ✅ USED | Used in `new_topic_page.dart` |
| `getTopTopicAsync` | ✅ Tested | ✅ USED | Used in `forum_topic_list.dart` |
| `getAnnTopicAsync` | ✅ Tested | ✅ USED | Used in `forum_topic_list.dart` |
| `getTopicAsync` | ✅ Tested | ✅ USED | Used in `forum_topic_list.dart` |
| `getUnreadTopicAsync` | ✅ Tested | ✅ USED | Used in `topic_controller.dart`, `unread_topics_list.dart` |
| `getParticipatedTopicAsync` | ✅ Tested | ✅ USED | Used in `topic_controller.dart`, `participated_topics_list.dart` |
| `getLatestTopicAsync` | ✅ Tested | ✅ USED | Used in `topic_controller.dart`, `latest_topics_list.dart` |
| `getNewTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `getTopicByIds` | ✅ Tested | ❌ NOT USED | - |

---

## IFCPostProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `reportPostAsync` | ✅ Tested | ✅ USED | Used in `post_actions.dart` |
| `replyPostAsync` | ✅ Tested | ✅ USED | Used in `reply_page.dart` |
| `getQuotePostAsync` | ✅ Tested | ✅ USED | Used in `reply_page.dart` |
| `getRawPostAsync` | ✅ Tested | ✅ USED | Used in `edit_post_page.dart` |
| `saveRawPostAsync` | ✅ Tested | ✅ USED | Used in `edit_post_page.dart` |
| `getThreadAsync` | ✅ Tested | ✅ USED | Used in `post_controller.dart`, `posts_list.dart` |
| `getThreadByUnreadAsync` | ✅ Tested | ✅ USED | Used in `post_controller.dart`, `posts_list.dart` |
| `getThreadByPostAsync` | ✅ Tested | ✅ USED | Used in `post_controller.dart`, `posts_list.dart` |

---

## IFCUserProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `getAvatarAsync` | ✅ Tested | ❌ NOT USED | - |
| `loginAsync` | ✅ Tested | ✅ USED | Used in `login_controller.dart` |
| `loginTwoStepAsync` | ✅ Tested | ❌ NOT USED | - |
| `getInboxStatAsync` | ✅ Tested | ❌ NOT USED | - |
| `logoutUserAsync` | ✅ Tested | ❌ NOT USED | - |
| `getOnlineUsersAsync` | ✅ Tested | ✅ USED | Used in `online_users_page.dart` |
| `getUserInfoAsync` | ✅ Tested | ✅ USED | Used in `profile_tab.dart`, `user_profile_page.dart`, `profile_picture_section.dart` |
| `getUserTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `getUserReplyPostAsync` | ✅ Tested | ✅ USED | Used in `profile_tab.dart`, `user_replied_posts.dart` |
| `getRecommendedUsersAsync` | ✅ Tested | ❌ NOT USED | - |
| `searchUserAsync` | ✅ Tested | ✅ USED | Used in `member_search_page.dart`, `user_search_page.dart` |
| `ignoreUserAsync` | ✅ Tested | ❌ NOT USED | - |
| `getIgnoredUsersAsync` | ✅ Tested | ❌ NOT USED | - |

---

## IFCSearchProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `searchTopicAsync` | ✅ Tested | ✅ USED | Used in `search_results_page.dart` |
| `searchPostAsync` | ✅ Tested | ✅ USED | Used in `search_results_page.dart` |
| `advanceSearchPostAsync` | ✅ Tested | ✅ USED | Used in `search_results_page.dart` |
| `advanceSearchTopicAsync` | ✅ Tested | ✅ USED | Used in `search_results_page.dart` |

---

## IFCSubscriptionProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `getSubscribedForumAsync` | ✅ Tested | ✅ USED | Used in `forum_list_tab.dart` |
| `subscribeForumAsync` | ✅ Tested | ✅ USED | Used in `forum_list_tab.dart`, `forum_topics_page.dart` |
| `unsubscribeForumAsync` | ✅ Tested | ✅ USED | Used in `forum_list_tab.dart`, `forum_topics_page.dart` |
| `getSubscribedTopicAsync` | ✅ Tested | ✅ USED | Used in `topic_controller.dart`, `subscribed_topics_list.dart` |
| `subscribeTopicAsync` | ✅ Tested | ✅ USED | Used in `post_page.dart` |
| `unsubscribeTopicAsync` | ✅ Tested | ✅ USED | Used in `post_page.dart` |

---

## IFCSocialProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `thankPostAsync` | ✅ Tested | ✅ USED | Used in `post_actions.dart` |
| `followAsync` | ✅ Tested | ❌ NOT USED | - |
| `unfollowAsync` | ✅ Tested | ❌ NOT USED | - |
| `likePostAsync` | ✅ Tested | ✅ USED | Used in `post_actions.dart` |
| `unlikePostAsync` | ✅ Tested | ✅ USED | Used in `post_actions.dart` |
| `getAlertAsync` | ✅ Tested | ✅ USED | Used in `notification_list_tab.dart` |
| `getActivityAsync` | ✅ Tested | ❌ NOT USED | - |

---

## IFCAttachmentProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `uploadAttachmentAsync` | ✅ Tested | ✅ USED | Used in multiple files: `edit_post_page.dart`, `reply_page.dart`, `new_topic_page.dart`, `attachment_upload_mixin.dart`, etc. |
| `uploadAvatarAsync` | ✅ Tested | ✅ USED | Used in `profile_picture_section.dart` |
| `removeAttachmentAsync` | ✅ Tested | ❌ NOT USED | - |
| `uploadTapatalkImageAsync` | ✅ Tested | ❌ NOT USED | - |

---

## IFCAccountProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `signinRegister` | ✅ Tested | ❌ NOT USED | - |
| `signinLoginWithEmail` | ✅ Tested | ❌ NOT USED | - |
| `signinLoginWithUsername` | ✅ Tested | ❌ NOT USED | - |
| `signinLogin` | ✅ Tested | ❌ NOT USED | - |
| `forgetPassword` | ✅ Tested | ❌ NOT USED | - |
| `updatePassword` | ✅ Tested | ❌ NOT USED | - |
| `updateProfile` | ✅ Tested | ❌ NOT USED | - |
| `updatePasswordSSO` | ✅ Tested | ❌ NOT USED | - |
| `register` | ✅ Tested | ❌ NOT USED | - |
| `updateEmail` | ✅ Tested | ❌ NOT USED | - |
| `prefetchAccount` | ✅ Tested | ❌ NOT USED | - |

---

## IFCModerationProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `doLoginModAsync` | ✅ Tested | ❌ NOT USED | - |
| `stickTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `unstickTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `closeTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `uncloseTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `deleteTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `deletePostAsync` | ✅ Tested | ❌ NOT USED | - |
| `undeleteTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `undeletePostAsync` | ✅ Tested | ❌ NOT USED | - |
| `moveTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `renameTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `movePostAsync` | ✅ Tested | ❌ NOT USED | - |
| `mergeTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `getModerateTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `getModeratePostAsync` | ✅ Tested | ❌ NOT USED | - |
| `getDeletedTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `getDeletedPostAsync` | ✅ Tested | ❌ NOT USED | - |
| `getReportedPostAsync` | ✅ Tested | ❌ NOT USED | - |
| `approveTopicAsync` | ✅ Tested | ❌ NOT USED | - |
| `approvePostAsync` | ✅ Tested | ❌ NOT USED | - |
| `banUserAsync` | ✅ Tested | ❌ NOT USED | - |
| `unbanUserAsync` | ✅ Tested | ❌ NOT USED | - |
| `markAsSpamAsync` | ✅ Tested | ❌ NOT USED | - |

---

## IFCPrivateConversationProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `newConversationAsync` | ✅ Tested | ✅ USED | Used in `new_direct_message_page.dart` |
| `replyConversationAsync` | ✅ Tested | ✅ USED | Used in `reply_direct_message_page.dart` |
| `inviteParticipantAsync` | ✅ Tested | ✅ USED | Used in `add_members_page.dart` |
| `getInboxStatAsync` | ✅ Tested | ❌ NOT USED | - |
| `getConversationsAsync` | ✅ Tested | ✅ USED | Used in `privatemessage_list_tab.dart` |
| `getConversationAsync` | ✅ Tested | ✅ USED | Used in `direct_message_page.dart` |
| `getQuoteConversationAsync` | ✅ Tested | ✅ USED | Used in `reply_direct_message_page.dart` |
| `leaveConversationAsync` | ✅ Tested | ✅ USED | Used in `conversation_page.dart`, `privatemessage_list_tab.dart` |
| `markConversationUnreadAsync` | ✅ Tested | ✅ USED | Used in `direct_message_page.dart` |
| `markConversationReadAsync` | ✅ Tested | ❌ NOT USED | - |

---

## IFCPrivateMessageProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `reportPmAsync` | ✅ Tested | ❌ NOT USED | - |
| `createMessageAsync` | ✅ Tested | ❌ NOT USED | - |
| `getBoxInfoAsync` | ✅ Tested | ❌ NOT USED | - |
| `getBoxAsync` | ✅ Tested | ❌ NOT USED | - |
| `getMessageAsync` | ✅ Tested | ❌ NOT USED | - |
| `getQuotePmAsync` | ✅ Tested | ✅ USED | Used in `reply_private_message_page.dart` |
| `deleteMessageAsync` | ✅ Tested | ❌ NOT USED | - |
| `markPmUnreadAsync` | ✅ Tested | ✅ USED | Used in `private_message_page.dart` |
| `markPmReadAsync` | ✅ Tested | ❌ NOT USED | - |

---

## IFCConfigProxy

| Method | Test Status | Used in App | Notes |
|--------|-------------|-------------|-------|
| `getConfig` | ✅ Tested | ✅ USED | Used in `site_manager.dart` |

---

## Summary

### Methods NOT USED in Application (but tested):

**IFCForumProxy (4 methods):**
- `getParticipatedForumAsync`
- `getIdByUrl`
- `getUrlById`
- `getForumStatusAsync`

**IFCTopicProxy (3 methods):**
- `markTopicReadAsync`
- `getTopicStatusAsync`
- `getNewTopicAsync`
- `getTopicByIds`

**IFCUserProxy (8 methods):**
- `getAvatarAsync`
- `loginTwoStepAsync`
- `getInboxStatAsync`
- `logoutUserAsync`
- `getUserTopicAsync`
- `getRecommendedUsersAsync`
- `ignoreUserAsync`
- `getIgnoredUsersAsync`

**IFCSocialProxy (3 methods):**
- `followAsync`
- `unfollowAsync`
- `getActivityAsync`

**IFCAttachmentProxy (2 methods):**
- `removeAttachmentAsync`
- `uploadTapatalkImageAsync`

**IFCAccountProxy (11 methods):**
- `signinRegister`
- `signinLoginWithEmail`
- `signinLoginWithUsername`
- `signinLogin`
- `forgetPassword`
- `updatePassword`
- `updateProfile`
- `updatePasswordSSO`
- `register`
- `updateEmail`
- `prefetchAccount`

**IFCModerationProxy (23 methods):**
- All 23 moderation methods are not used in the application

**IFCPrivateConversationProxy (2 methods):**
- `getInboxStatAsync`
- `markConversationReadAsync`

**IFCPrivateMessageProxy (7 methods):**
- `reportPmAsync`
- `createMessageAsync`
- `getBoxInfoAsync`
- `getBoxAsync`
- `getMessageAsync`
- `deleteMessageAsync`
- `markPmReadAsync`

---

## Total Count

- **Total methods tested**: ~71
- **Methods used in app**: ~35
- **Methods NOT used in app**: ~36

---

## Notes

1. Some methods may be used indirectly or through other means not captured in the search
2. Some methods may be planned for future use
3. Moderation methods are typically admin-only features and may not be exposed in the mobile app
4. Account management methods may be handled through web interfaces or other flows
5. This analysis is based on static code analysis; runtime usage may differ

---

Last updated: Generated from test files and app codebase analysis


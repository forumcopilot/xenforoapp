# Forum Copilot API Documentation

This document is the full API reference for the Forum Copilot add-on endpoint
`forumcopilot.php`. It includes method signatures, parameter descriptions, and
cookie requirements. This file is intended for MCP server discovery.

## Base endpoint

`POST /forumcopilot.php`

## Request envelope

```json
{
  "method": "methodName",
  "params": { }
}
```

## Response envelope (common)

```json
{
  "result": true,
  "resultText": null
}
```

On error:

```json
{
  "result": false,
  "resultText": "Error message"
}
```

## Authentication categories

- `required`: Must be logged in (session cookies required). Methods call `assertRegisteredUser()`.
- `optional`: Works for guests if forum permissions allow; login cookies enable personalized data.
- `none`: No login cookies required.

## Config

### `getConfig`

- **Auth:** `none`
- **Description:** Returns public config and environment info.
- **Params:** none

## Account

### `getPasskeyChallenge`

- **Auth:** `none`
- **Description:** Get a WebAuthn challenge for passkey-only login or passkey 2FA. Must be called in the same session (with cookies) as the subsequent `login` call.
- **Params:** none
- **Response:**
  - `challenge` (string) — Challenge string for `credentials.get()`.
  - `rpId` (string) — Relying Party ID (forum domain).
  - `timeout` (int) — Timeout in milliseconds (60000).

### `login`

- **Auth:** `none`
- **Description:** Login and set session cookies. Supports three flows: (1) password-based, (2) passkey-only, (3) password + 2FA (including passkey as 2FA).
- **Params:**

**Password-based login:**
  - `loginname` (string, required) — Username or email.
  - `password` (string, required) — Password.
  - `tfaCode` (string, optional) — 2FA code if required (for code-based providers).
  - `tfaProvider` (string, optional) — 2FA provider id (`totp`, `email`, `backup`, `passkey`). When `tfaCode` is omitted and 2FA is required, this can be used to trigger a specific provider on the first step.
  - `trustDevice` (bool, optional) — Trust device if 2FA succeeds.

**Passkey-only login:**
  - `webauthn_challenge` (string, required) — Challenge from `getPasskeyChallenge`.
  - `webauthn_payload` (object, required) — WebAuthn assertion:
    - `id` (string) — Base64-encoded credential ID.
    - `clientDataJSON` (string) — Base64-encoded client data.
    - `authenticatorData` (string) — Base64-encoded authenticator data.
    - `signature` (string) — Base64-encoded signature.

**Password + Passkey 2FA (second request):**
  - `loginname` (string, required) — Username or email.
  - `password` (string, required) — Password.
  - `tfaProvider` (string, required) — Must be `"passkey"`.
  - `webauthn_challenge` (string, required) — Challenge from first response.
  - `webauthn_payload` (object, required) — WebAuthn assertion (same structure as above).
  - `trustDevice` (bool, optional) — Trust device permanently.

- **Response (when 2FA required):**
  - `result` (bool) — `false` when 2FA required.
  - `resultText` (string) — "Two-factor authentication required".
  - `tfaRequired` (bool) — `true`.
  - First-step behavior: the API triggers the selected/default TFA provider before returning this response. This means providers such as `email` will generate and send their code at this point.
  - `providers` (array) — List of available 2FA providers:
    - `id` (string) — Provider ID (`totp`, `email`, `backup`, `passkey`).
    - `title` (string) — Display name.
    - `description` (string) — Provider description.
    - `type` (string) — `"passkey"` or `"code"` (indicates how to complete 2FA).
  - `providerId` (string) — Provider ID that was triggered for this 2FA step.
  - `availableTfaMethods` (object) — Summary of available methods:
    - `passkey` (bool) — `true` if passkey is available.
    - `code` (bool) — `true` if code-based methods are available.
  - `passkeyChallenge` (string, optional) — Challenge for passkey 2FA (only if passkey is available).
  - `passkeyRpId` (string, optional) — Relying Party ID for passkey.
  - `passkeyTimeout` (int, optional) — Timeout for passkey in milliseconds.

### `logout`

- **Auth:** `required`
- **Description:** Logs out current session.
- **Params:** none

### `register`

- **Auth:** `none`
- **Description:** Create a new user.
- **Params:** (registration fields depend on XenForo config)
  - `username` (string, required)
  - `email` (string, required)
  - `password` (string, required)
  - `customFields` (object, optional)
  - `profile` (object, optional)

### `prefetchAccount`

- **Auth:** `none`
- **Description:** Returns registration requirements and custom fields.
- **Params:** none

### `forgotPassword`

- **Auth:** `none`
- **Description:** Initiate password reset.
- **Params:**
  - `loginname` (string, required) — Username or email.

### `updatePassword`

- **Auth:** `required`
- **Description:** Change password.
- **Params:**
  - `oldPassword` (string, required)
  - `newPassword` (string, required)

### `updateEmail`

- **Auth:** `required`
- **Description:** Change email.
- **Params:**
  - `password` (string, required)
  - `newEmail` (string, required)

### `updateProfile`

- **Auth:** `required`
- **Description:** Update profile fields for a user.
- **Params:**
  - `userId` (string, required)
  - `profile` (object, optional)
  - `user` (object, optional)
  - `option` (object, optional)
  - `customFields` (object, optional)
  - `dobDay` (int, optional)
  - `dobMonth` (int, optional)
  - `dobYear` (int, optional)
  - `enableActivitySummaryEmail` (bool, optional)

## User

### `getUserInfo`

- **Auth:** `optional`
- **Description:** Returns user profile details.
- **Params:**
  - `userId` (string, optional) — User id.
  - `username` (string, optional) — Username if `userId` not provided.

### `searchUser`

- **Auth:** `optional`
- **Description:** Search users by keywords or list.
- **Params:**
  - `keywords` (string, optional) — Search keywords.
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20)

### `getInboxStat`

- **Auth:** `required`
- **Description:** Returns unread counts for conversations and alerts.
- **Params:** none

### `getOnlineUsers`

- **Auth:** `optional`
- **Description:** Returns online users list (requires member list permission).
- **Params:**
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20)
  - `unreadOnly` (bool, optional)

### `getUserReplyPost`

- **Auth:** `optional`
- **Description:** Returns replies by a user.
- **Params:**
  - `userId` (string, optional)
  - `username` (string, optional)
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20)

### `reportUser`

- **Auth:** `required`
- **Description:** Report a user.
- **Params:**
  - `userId` (string, optional)
  - `username` (string, optional)
  - `reason` (string, required)

## Forum

### `getForum`

- **Auth:** `optional`
- **Description:** List forums, or a subtree under `forumId`. May include link subforums (external links): entries with `isLinkForum: true` have only `name` and `url` meaningful; the app should open `url` (e.g. in browser or webview).
- **Params:**
  - `forumId` (string, optional)
  - `returnDescription` (bool, optional, default false)

### `markAllAsRead`

- **Auth:** `required`
- **Description:** Marks forum(s) as read.
- **Params:**
  - `forumId` (string, optional)
  - `date` (int, optional) — Unix timestamp.

### `getForumStatus`

- **Auth:** `required`
- **Description:** Returns status for multiple forums.
- **Params:**
  - `forumIds` (array<int>, required)

### `getBoardStat`

- **Auth:** `none`
- **Description:** Returns board stats.
- **Params:** none

### `getParticipatedForum`

- **Auth:** `required`
- **Description:** Forums where the user posted.
- **Params:** none

### `loginForum`

- **Auth:** `none`
- **Description:** Mapped but not implemented (no `actionLoginForum`).
- **Params:** none

## Topic

### `getTopic`

- **Auth:** `optional`
- **Description:** List threads in a forum.
- **Params:**
  - `forumId` (string, required)
  - `startNum` (int, optional, default 0)
  - `lastNum` (int, optional, default 19)
  - `searchId` (string, optional)

### `getTopTopic`

- **Auth:** `optional`
- **Description:** Sticky topics in a forum.
- **Params:** same as `getTopic`

### `getAnnTopic`

- **Auth:** `optional`
- **Description:** Announcement topics in a forum.
- **Params:** same as `getTopic`

### `getLatestTopic`

- **Auth:** `optional`
- **Description:** Latest topics across the forum.
- **Params:**
  - `startNum` (int, optional, default 0)
  - `lastNum` (int, optional, default 19)
  - `searchId` (string, optional)
  - `filters` (array, optional)

### `getUnreadTopic`

- **Auth:** `required`
- **Description:** Unread topics for current user.
- **Params:** same as `getLatestTopic`

### `getParticipatedTopic`

- **Auth:** `required`
- **Description:** Topics the user participated in.
- **Params:**
  - `userId` (string, optional)
  - `username` (string, optional)
  - `startNum` (int, optional, default 0)
  - `lastNum` (int, optional, default 19)
  - `searchId` (string, optional)

### `getTopicByIds`

- **Auth:** `optional`
- **Description:** Fetch topics by ids.
- **Params:**
  - `topicIds` (array<string>, required)

### `newTopic`

- **Auth:** `required`
- **Description:** Create a new topic.
- **Params:**
  - `forumId` (string, required)
  - `subject` (string, required)
  - `textBody` (string, required)
  - `prefixId` (string, optional)
  - `attachmentIds` (array<string>, optional)
  - `groupId` (string, optional) — attachment temp hash.

### `markTopicRead`

- **Auth:** `required`
- **Description:** Mark topics as read.
- **Params:**
  - `topicIds` (array<string>, required)

## Post

**Poll (view & vote):** See [API-Poll.md](API-Poll.md) for full poll object schema, `hasPoll`/`poll` in thread responses, and `votePoll`.

### `getThread`

- **Auth:** `optional`
- **Description:** Get posts for a thread.
- **Params:**
  - `topicId` (string, required)
  - `startNum` (int, optional, default 1)
  - `lastNum` (int, optional, default 20)
  - `searchId` (string, optional)
- **Response:**
  - `hasPoll` (bool) — Whether the thread has a poll.
  - `poll` (object|null) — Full poll data when the thread has a poll; otherwise `null`. See [API-Poll.md](API-Poll.md).

### `getThreadByPost`

- **Auth:** `optional`
- **Description:** Get thread by a post id.
- **Params:**
  - `postId` (string, required)
  - `postsPerRequest` (int, optional, default 20)
  - `searchId` (string, optional)
- **Response:** Same thread shape as `getThread`; includes `hasPoll` and `poll` when the thread has a poll. See [API-Poll.md](API-Poll.md).

### `getThreadByUnread`

- **Auth:** `required`
- **Description:** Get thread starting from first unread post.
- **Params:**
  - `topicId` (string, required)
  - `postsPerRequest` (int, optional, default 20)
- **Response:** Same thread shape as `getThread`; includes `hasPoll` and `poll` when the thread has a poll. See [API-Poll.md](API-Poll.md).

### `votePoll`

- **Auth:** `required`
- **Description:** Vote on a poll attached to a thread. See [API-Poll.md](API-Poll.md) for full details and poll schema.
- **Params:**
  - `topicId` (string, required)
  - `responseIds` (array<string>, required) — IDs of selected options from `poll.responses[].id`.
- **Response:**
  - `poll` (object) — Updated poll data (same schema as in thread responses).

### `replyPost`

- **Auth:** `required`
- **Description:** Reply to a thread.
- **Params:**
  - `topicId` (string, required)
  - `textBody` (string, required)
  - `attachmentIds` (array<string>, optional)
  - `groupId` (string, optional)

### `getRawPost`

- **Auth:** `required`
- **Description:** Get raw post content for editing.
- **Params:**
  - `postId` (string, required)

### `saveRawPost`

- **Auth:** `required`
- **Description:** Save raw post content.
- **Params:**
  - `postId` (string, required)
  - `textBody` (string, required)

### `getQuotePost`

- **Auth:** `required`
- **Description:** Get quoted post content.
- **Params:**
  - `postId` (string, required)

### `reportPost`

- **Auth:** `required`
- **Description:** Report a post.
- **Params:**
  - `postId` (string, required)
  - `reason` (string, required)

## Search

### `searchTopic`

- **Auth:** `optional`
- **Description:** Keyword search for topics.
- **Params:**
  - `searchString` (string, required)
  - `startNum` (int, optional, default 0)
  - `lastNum` (int, optional, default 19)
  - `searchId` (string, optional)

### `searchPost`

- **Auth:** `optional`
- **Description:** Keyword search for posts.
- **Params:** same as `searchTopic`

### `advanceSearchTopic`

- **Auth:** `optional`
- **Description:** Advanced topic search.
- **Params:**
  - `keywords` (string, required)
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20)
  - `searchId` (string, optional)
  - `titleOnly` (bool, optional)
  - `userId` (string, optional)
  - `searchUser` (string, optional)
  - `forumId` (string, optional)
  - `topicId` (string, optional)
  - `onlyIn` (array<string>, optional)
  - `notIn` (array<string>, optional)
  - `startedBy` (bool, optional)
  - `searchTime` (int, optional) — Unix timestamp (newer than).

### `advanceSearchPost`

- **Auth:** `optional`
- **Description:** Advanced post search.
- **Params:** same as `advanceSearchTopic`

## Attachment

### `uploadAttachment`

- **Auth:** `required`
- **Description:** Upload an attachment for a post or thread.
- **Params:**
  - `contentType` (string, required) — e.g., `post` or `thread`.
  - `contentId` (string, optional)
  - `hash` (string, optional) — temp hash.
  - `attachment` (file, required)

### `removeAttachment`

- **Auth:** `required`
- **Description:** Remove an attachment by id.
- **Params:**
  - `attachmentId` (string, required)

### `uploadAvatar`

- **Auth:** `required`
- **Description:** Upload avatar for current user.
- **Params:**
  - `avatar` (file, required)

## Social

### `likePost`

- **Auth:** `required`
- **Description:** React (like) a post.
- **Params:**
  - `postId` (string, required)
  - `like` (bool, optional, default true)

### `unlikePost`

- **Auth:** `required`
- **Description:** Remove reaction from a post.
- **Params:** same as `likePost` with `like=false`

### `follow`

- **Auth:** `required`
- **Description:** Follow a user.
- **Params:**
  - `userId` (string, required)
  - `follow` (bool, optional, default true)

### `unfollow`

- **Auth:** `required`
- **Description:** Unfollow a user.
- **Params:** same as `follow` with `follow=false`

### `getAlert`

- **Auth:** `required`
- **Description:** List alerts.
- **Params:**
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20)
  - `unreadOnly` (bool, optional, default false)

### `thankPost`

- **Auth:** `required`
- **Description:** Legacy reaction endpoint (maps to like/unlike).
- **Params:** same as `likePost`

## Subscription

### `getSubscribedForum`

- **Auth:** `required`
- **Description:** List watched forums.
- **Params:** none

### `subscribeForum`

- **Auth:** `required`
- **Description:** Watch a forum.
- **Params:**
  - `forumId` (string, required)
  - `notifyType` (string, optional) — e.g., `watch_no_email`, `watch_email`.

### `unsubscribeForum`

- **Auth:** `required`
- **Description:** Unwatch a forum.
- **Params:** same as `subscribeForum`

### `getSubscribedTopic`

- **Auth:** `required`
- **Description:** List watched topics.
- **Params:** none

### `subscribeTopic`

- **Auth:** `required`
- **Description:** Watch a topic.
- **Params:**
  - `topicId` (string, required)
  - `notifyType` (string, optional)

### `unsubscribeTopic`

- **Auth:** `required`
- **Description:** Unwatch a topic.
- **Params:** same as `subscribeTopic`

## Moderation

### `doLoginMod`

- **Auth:** `required`
- **Description:** Moderator login (elevated).
- **Params:** none

### `stickTopic` / `unstickTopic`

- **Auth:** `required`
- **Params:** `topicId` (string, required)

### `closeTopic` / `uncloseTopic`

- **Auth:** `required`
- **Params:** `topicId` (string, required)

### `deleteTopic` / `undeleteTopic`

- **Auth:** `required`
- **Params:** `topicId` (string, required)

### `deletePost` / `undeletePost`

- **Auth:** `required`
- **Params:** `postId` (string, required)

### `moveTopic`

- **Auth:** `required`
- **Params:**
  - `topicId` (string, required)
  - `forumId` (string, required)

### `renameTopic`

- **Auth:** `required`
- **Params:**
  - `topicId` (string, required)
  - `title` (string, required)

### `approveTopic` / `approvePost`

- **Auth:** `required`
- **Params:** `topicId` or `postId` (string, required)

### `banUser` / `unbanUser`

- **Auth:** `required`
- **Params:** `userId` (string, required)

### `spamCleanUser`

- **Auth:** `required`
- **Params:** `userId` (string, required)

## Private Conversation

### `newConversation`

- **Auth:** `required`
- **Params:**
  - `recipientIds` (array<string>, required)
  - `title` (string, required)
  - `textBody` (string, required)

### `replyConversation`

- **Auth:** `required`
- **Params:**
  - `conversationId` (string, required)
  - `textBody` (string, required)

### `getConversations`

- **Auth:** `required`
- **Params:**
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20)

### `getConversation`

- **Auth:** `required`
- **Params:**
  - `conversationId` (string, required)
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20)

### `getConversationByMessage`

- **Auth:** `required`
- **Params:**
  - `messageId` (string, required)

### `getRawConversation` / `saveRawConversation`

- **Auth:** `required`
- **Params:** `conversationId` (string, required), plus `textBody` for save.

### `getRawMessage` / `saveRawMessage`

- **Auth:** `required`
- **Params:** `messageId` (string, required), plus `textBody` for save.

### `closeConversation` / `uncloseConversation`

- **Auth:** `required`
- **Params:** `conversationId` (string, required)

### `markConversationRead` / `markConversationUnread`

- **Auth:** `required`
- **Params:** `conversationId` (string, required)

### `leaveConversation`

- **Auth:** `required`
- **Params:** `conversationId` (string, required)

### `inviteParticipant`

- **Auth:** `required`
- **Params:**
  - `conversationId` (string, required)
  - `recipientIds` (array<string>, required)

### `getQuoteConversation`

- **Auth:** `required`
- **Params:** `messageId` (string, required)

### `likeConversationMessage` / `unlikeConversationMessage`

- **Auth:** `required`
- **Params:** `messageId` (string, required)

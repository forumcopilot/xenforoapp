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

Every reply is JSON (`Content-Type: application/json`) with `result`. A
successful reply has no `resultText`:

```json
{
  "result": true
}
```

A refused or failed call answers **HTTP 200** with `result: false` (the app
reads `resultText` only from 2xx replies). Only a request that isn't a JSON
POST with the media type `application/json` gets HTTP 400.

```json
{
  "result": false,
  "resultText": "The requested thread could not be found.",
  "errorCode": "not_found"
}
```

- `resultText` — XenForo's own message where there is one (in the member's
  language), plain text. Several form errors come one per line.
- `errorCode` (add-on 1.11.0+) — what kind of error it is:

  | errorCode | Meaning |
  |---|---|
  | `login_required` | The method needs a signed-in member |
  | `guest_denied` | Guests may not see or do this; signing in may help |
  | `no_permission` | The member may not see or do this |
  | `not_found` | The thread, post, member, message... doesn't exist or isn't visible |
  | `validation` | Input was refused; see `errors` |
  | `flood` | Too soon after the last action of this kind |
  | `board_closed` | The board is closed |
  | `banned` | Banned account or IP address |
  | `account_pending` | Account waiting for email confirmation or approval |
  | `account_disabled` | Rejected or disabled account |
  | `tfa_required` | The member's groups require two-step verification |
  | `security_locked` | The account is security locked |
  | `bad_request` | Malformed call: bad JSON, unknown method, missing or invalid parameters |
  | `server_error` | Unexpected failure; logged in XenForo's server error log under `errorId` |
  | `error` | Any other refusal |

- `errors` (object, field => message) — form errors XenForo keys by field
  (`register`, new thread, new conversation, follow, search...).
- `errorId` (string) — with `server_error`: the reference to look for in
  Admin CP → Logs → Server error log ("Forum Copilot API [id] ...").

## Authentication categories

- `required`: Must be logged in (session cookies required). Methods call `assertRegisteredUser()`.
- `optional`: Works for guests if forum permissions allow; login cookies enable personalized data.
- `none`: No login cookies required.

## Board access checks

Before any method runs, the endpoint applies the checks XenForo's own pages
apply to every request: banned IP, banned / rejected / disabled account, the
**View the board** permission, closed board (admins pass), required two-step
verification and security lock. A refused call returns HTTP 200 with
`result: false` and XenForo's message in `resultText`.

- `getConfig`, `login`, `register`, `prefetchAccount`, `forgotPassword`,
  `getPasskeyChallenge`, `completeBrowserLogin` and `resendEmailConfirmation`
  only refuse banned IPs, like XenForo's login page.
- `logout` and `unregisterDevice` are never refused.
- `login` and `completeBrowserLogin` themselves refuse an account without
  **View the board**, except a new member waiting for email confirmation or
  approval (XenForo gives them the guests' permissions until then). They sign
  in; the methods above answer them, and the others say why they cannot
  (XenForo's "awaiting confirmation" or "awaiting approval" message).

## Config

### `getConfig`

- **Auth:** `none`
- **Description:** Returns public config and environment info.
- **Params:**
  - `dismissNoticeId` (int, optional, 1.11.0) — dismiss this notice for the member, as XenForo's notice close button does.
- **Response** (among others):
  - `browserLoginSchemes` (string[]) — App schemes the website may hand a sign-in to (see "Signing in and up on the website"); empty when that is off.
  - `userState` (string) — The signed-in member's XenForo state (`valid`, `email_confirm`, `moderated`, ...); empty for a guest.
  - `guestOkay`, `guestSearch`, `guestWhosOnline` (bool) — what guests may do (view some forum, search, see the online list).
  - `conversation` and `alert` are always `true`; `ignoreUser`, `multiQuote`, `getTopicStatus`, `advancedMerge`, `advancedMove`, `modApprove`, `modDelete` and `modReport` are `false` because the API has no method behind them. `hookVersion`, `apiLevel`, `pushSlug`, `apiKey` and `releaseTimestamp` are kept for older apps and mean nothing.
  - Added in 1.11.0:
    - `advancedSearch` (true: search with `advanceSearchTopic`/`advanceSearchPost`), `minSearchLength`, `disableSearch`.
    - `boardInactiveMessage` (string) — why the board is closed; empty when open.
    - `canSearch`, `canStartConversation`, `canUploadAvatar`, `isModerator` (bool) — the visitor's.
    - `notices` (array) — the notices XenForo shows the visitor on pages without page criteria: `id`, `type` (`block`, `floating`, `scrolling`, `bottom_fixer`), `title`, `message` (text), `messageHtml`, `dismissible`, `displayStyle`.
    - `tosUrl`, `privacyPolicyUrl`, `contactUrl` (string) — empty when the forum has no such page.
    - `helpPages` (array) — `id`, `title`, `url` of the active help pages.
    - `policyAcceptance` — `required`, `termsRequired`, `privacyRequired`, `acceptUrl`: the member still has to accept updated terms or privacy policy on the website. Reported only; the app isn't refused.

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
- **Description:** Create a new user with the app's own form, through XenForo's
  registration service and its spam checks. Refused when `prefetchAccount`
  says `canRegisterViaAPI: false` (among others, whenever guests are shown a
  captcha: those forums sign up on the website), for discouraged IP addresses
  when the forum keeps them from registering, and until XenForo's
  registration timer has run since `prefetchAccount` in the same session
  (session cookie required; one `prefetchAccount` per account).
- **Params:** (registration fields depend on XenForo config)
  - `username` (string, required)
  - `email` (string, required)
  - `password` (string, required)
  - `passwordConfirm` (string, optional) — Must match when sent.
  - `dateOfBirth` (string, optional) — `YYYY-MM-DD`.
  - `location`, `timezone` (string, optional) — `timezone` is a PHP time zone name.
  - `customFields` (object, optional) — Field id to value (a list for multiple choices).
  - `emailChoice` (bool, optional) — Used when the forum asks; sets both staff emails and the activity summary.
  - `acceptTerms`, `acceptPrivacy` (bool) — Each required only when the forum has that policy.
- **Response:** `userId`, `username`, `userState`, `requiresEmailConfirmation`,
  `requiresManualApproval`, and `message` (XenForo's own "Thanks for
  registering" text). On error, `resultText` has every message, one per line,
  and `errors` maps a field to its message: `username`, `email`, `password`,
  `dob`, `location`, `timezone`, `custom_field_<id>`, `acceptTerms`,
  `acceptPrivacy`.

### `prefetchAccount`

- **Auth:** `none`
- **Description:** Returns whether registration is open and possible in the
  app, its requirements and custom fields (those a new member may fill in),
  and starts XenForo's registration timer for `register`.
- **Params:** none
- **Response:** `registrationOpen`, `canRegisterViaAPI`, `registerViaWebUrl`
  (the canonical register page), `customRegisterFields`, and
  `registrationRequirements` (when possible): `dateOfBirth.minimumAge` (0 when
  none), `privacyPolicy` / `termsOfService` (`required` when the forum has it,
  `url` as a full address), `emailChoice`, `location`, `username`.

### `resendEmailConfirmation`

- **Auth:** `required`
- **Description:** Sends the confirmation email again, for a member waiting to
  confirm their email address. At most once every ten minutes (XenForo's own
  page asks for a captcha instead).
- **Params:** none
- **Response:** `message` — XenForo's "The confirmation email has been resent."

### `completeBrowserLogin`

- **Auth:** `none`
- **Description:** Signs the app in with the one-time code the website handed
  to the app's scheme (see below), remembered. A member with two-step gets a
  `tfa_trust` cookie too, so the remember cookie can sign the app back in
  after its session lapses.
- **Params:**
  - `code` (string, required) — From `<scheme>://login?code=…&state=…`.
  - `verifier` (string, required) — The PKCE verifier whose S256 challenge the app sent.

### Signing in and up on the website

Not API methods: pages of the forum the app opens in the system browser sheet.

- `index.php?forumcopilot-app-login/&scheme=…&state=…&challenge=…` — a guest
  goes to XenForo's login page and comes back; a signed-in member confirms
  "Continue as {name}" (or "Not you? Sign out", which signs the browser out
  and returns here), and the page hands a code to `<scheme>://login`.
- `index.php?register/&_xfRedirect=<that address>` — XenForo's register page.
  The request is kept in XenForo's session for half an hour (also when a
  guest goes from the login page to Register, or signs up with Google or
  Facebook), and `register/complete` then shows "Continue in the app", which
  hands over a code the same way. A member already signed in on the website
  goes straight to the confirmation page.

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
- **Description:** Kept for older apps: XenForo has no password-protected forums, so it always answers success.
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

All four run on XenForo's own search (its index, minimum word length, result
limit and per-member result cache), with permissions applied before results
are counted. `searchId` in a reply names that search: send it back with the
same words for the next page. Pages are at most 100 results.

### `searchTopic`

- **Auth:** `optional`
- **Description:** Keyword search for topics: posts and threads, one result per thread (XenForo's "Search threads").
- **Params:**
  - `searchString` (string, required)
  - `startNum` (int, optional, default 0) — first result, 0-based.
  - `lastNum` (int, optional, default 19) — last result, inclusive.
  - `searchId` (string, optional)
- **Response:** `totalTopicNum`, `searchId`, `topics` (topic rows as in topic lists).

### `searchPost`

- **Auth:** `optional`
- **Description:** Keyword search for posts, newest first.
- **Params:** same as `searchTopic`.
- **Response:** `totalPostNum`, `searchId`, `posts`.

### `advanceSearchTopic`

- **Auth:** `optional`
- **Description:** Advanced topic search, one result per thread; the app's Search tab.
- **Params:**
  - `keywords` (string, required)
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20, at most 100)
  - `searchId` (string, optional) — reuse the member's own earlier search for the same words.
  - `titleOnly` (bool, optional)
  - `userId` (string, optional) or `searchUser` (string, optional) — member names, comma-separated (names only).
  - `forumId` (string, optional), `onlyIn` (array<string>, optional) — forums to search (not their sub-forums).
  - `notIn` (array<string>, optional) — forums to leave out (used when no forums are given).
  - `topicId` (string, optional) — only this thread.
  - `startedBy` (bool, optional) — with a member: threads they started.
  - `searchTime` (int, optional) — Unix time; newer than.
- **Response:** `totalTopicNum`, `searchId`, `topics` (topic rows as in topic lists).

### `advanceSearchPost`

- **Auth:** `optional`
- **Description:** Advanced post search, newest first.
- **Params:** same as `advanceSearchTopic` (`startedBy` doesn't apply).
- **Response:** `totalPostNum`, `searchId`, `posts`.

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
- **Description:** React to a post, as XenForo's reaction button: adds the reaction, switches to it, or takes it off when it is the member's current one. The reaction must exist and be active.
- **Params:**
  - `postId` (string, required)
  - `reactionId` (int, optional, default 1) — from `getConfig`'s `availableReactions`.
- **Response:** `isLiked`, `likeCount` (number of reactions), `visitorReactionId` (null when taken off).

### `unlikePost`

- **Auth:** `required`
- **Description:** Take the member's reaction off a post, whichever it is.
- **Params:**
  - `postId` (string, required)
- **Response:** `isLiked` (false), `likeCount`.

### `follow`

- **Auth:** `required`
- **Description:** Follow a member, as XenForo's Follow button (their profile must be viewable).
- **Params:**
  - `userId` (string, required) — an id, or a user name.

### `unfollow`

- **Auth:** `required`
- **Description:** Stop following a member.
- **Params:**
  - `userId` (string, required) — an id, or a user name.

### `getAlert`

- **Auth:** `required`
- **Description:** List the member's alerts, newest first. By default it works like XenForo's alert list: the shown alerts that read themselves (reactions, follows...) are marked read, and all alerts are marked viewed (the badge) when page 1 loads.
- **Params:**
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20, at most 100)
  - `skipMarkRead` (bool, optional, 1.11.0) — mark nothing, like XenForo's `skip_mark_read`.
  - `unreadOnly` (bool, optional, 1.11.0) — only alerts not read yet.
  - `markReadIds`, `markUnreadIds` (int[], optional, 1.11.0) — mark the member's own alerts read or unread before listing.
  - `markAllRead` (bool, optional, 1.11.0) — mark all the member's alerts read before listing.
- **Response:** `total` (all the member's alerts, for paging), `items` (alerts), `visitor` (`conversations_unread`, `alerts_unviewed`, `total_unread`). Each alert: `id`, `type`, `message`, `timestamp`, `isRead` (viewed), `actionUrl`, `fromUserId`, `fromUsername`, `fromUserIconUrl`, `action`, `contentId`, ids by type (`postId`, `topicId`, `conversationId`...), and from 1.11.0 `isUnread` (XenForo's read state), `isUnviewed`, `readDate`, `viewDate`, `autoRead`.

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

XenForo's direct messages. Every method works on the member's own copy of a
conversation: a conversation the member isn't in is "not found".

### `newConversation`

- **Auth:** `required`
- **Description:** Start a direct message, as XenForo's form: XenForo checks the recipients (names who don't exist or don't accept messages from the member come back in `errors.recipients`), the maximum number of recipients and the flood limit.
- **Params:**
  - `userName` (array<string> or comma-separated string, required) — recipient user names.
  - `subject` (string, required)
  - `textBody` (string, required) — BBCode.
  - `groupId` (string, optional) — the upload hash of files uploaded for it (type `pm`), when the member may attach files to direct messages.
  - `openInvite` (bool, optional) — anyone in it may invite others.
  - `conversationLocked` (bool, optional) — no replies.
- **Response:** `convId`.

### `replyConversation`

- **Auth:** `required`
- **Description:** Reply, as XenForo's form: flood limit, and the reply draft is deleted.
- **Params:**
  - `conversationId` (string, required)
  - `textBody` (string, required)
  - `groupId` (string, optional) — upload hash.
- **Response:** `messageId`.

### `getConversations`

- **Auth:** `required`
- **Params:**
  - `startNum` (int, optional, default 0), `lastNum` (int, optional, default 19) — at most 100 rows.
- **Response:** `conversationCount`, `unreadCount` (the member's unread conversations), `canUpload` (may attach files to direct messages), `list`. Each row: `id`, `title`, starter and last-message author fields, `isUnread`, `messageId` (first unread, or latest), `unreadMessageCount`, `messageCount`, `participantCount`, `participants` (1.11.0: `id`, `username`, everyone but the starter), `canReply`, `canInvite`, `canEdit`, `canClose`, `isClosed`.

### `getConversation`

- **Auth:** `required`
- **Description:** Messages, oldest first; marks the conversation read up to the last one shown, and the alerts about them read.
- **Params:**
  - `conversationId` (string, required)
  - `startNum` (int, optional, default 0) — first message number (1-based).
  - `lastNum` (int, optional, default 19) — last message number, inclusive; at most 100 messages.
- **Response:** `convId`, `convTitle`, `messages`, `participants`, `totalMessageNum`, `lastRead`, `canReply`, `canInvite`, `canEdit`, `canClose`, `isClosed`, `canUpload`.

### `getConversationByMessage`

- **Auth:** `required`
- **Description:** The page around one message.
- **Params:**
  - `messageId` (string, required)
  - `messagesPerRequest` (int, optional, default 20, at most 100)

### `getRawConversation` / `saveRawConversation`

- **Auth:** `required` (the starter)
- **Params:** `conversationId` (string, required); for save, optional `conversationTitle`, `conversationOpen` (bool), `openInvite` (bool).

### `getRawMessage` / `saveRawMessage`

- **Auth:** `required` (the author, within XenForo's edit time limit)
- **Params:** `messageId` (string, required); for save, `messageContent` (string, required) and optional `groupId` (upload hash of new files). Attachments the message already has stay as they are.

### `closeConversation` / `uncloseConversation`

- **Auth:** `required` (the starter)
- **Params:** `conversationId` (string, required)

### `markConversationRead` / `markConversationUnread`

- **Auth:** `required`
- **Params:** `conversationId` (string, required)

### `leaveConversation`

- **Auth:** `required`
- **Params:**
  - `conversationId` (string, required)
  - `mode` (int, optional) — 2: leave and ignore future messages; otherwise it comes back on a new reply.
  - `ignore` (bool, optional, 1.11.0) — the same as mode 2.

### `inviteParticipant`

- **Auth:** `required`
- **Params:**
  - `conversationId` (string, required)
  - `userName` (array<string> or comma-separated string, required)

### `getQuoteConversation`

- **Auth:** `required` (the member can reply in it)
- **Params:** `messageId` (string, required)
- **Response:** `quote` (BBCode).

### `likeConversationMessage` / `unlikeConversationMessage`

- **Auth:** `required`
- **Description:** As `likePost` / `unlikePost`, for a direct message.
- **Params:** `messageId` (string, required); for like, `reactionId` (int, optional, default 1).


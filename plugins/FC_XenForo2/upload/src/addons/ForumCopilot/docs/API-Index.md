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
- `updateEmail`, `updatePassword`, `deleteAccount`, `updateProfile`,
  `getUserSettings`, `updateUserSettings` and `getUserSettingsCategories` are
  XenForo's account section: like its own account pages, they skip the
  **View the board** and required two-step checks (a new member waiting for
  email confirmation can still correct the address). The other checks apply.
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
- **Description:** A WebAuthn challenge for a passkey sign-in or a passkey answer to two-step. Call it in the same session (with cookies) as the `login` call that uses it; one challenge answers one sign-in. Needs XenForo 2.3 (passkeys): refused with `no_permission` on 2.2.
- **Params:** none
- **Response:**
  - `challenge` (string) — Challenge for `credentials.get()` (base64url).
  - `rpId` (string) — Relying Party ID (the forum's host name).
  - `timeout` (int) — 60000 (milliseconds).

### `login`

- **Auth:** `none`
- **Description:** Signs the app in and sets XenForo's session cookies, as the forum's login page: XenForo's login limits, the login log and two-step verification apply. Two ways in: name and password (then two-step, when the member has it), or a passkey. Refused: a wrong name, password or passkey (`validation`); XenForo's login limits (`flood`; from 1.11.0 with `signInOnWebsite: true` where the forum shows a captcha at that point instead, which the app can't show: the member can still sign in on the website); a banned account (`banned`); a rejected or disabled account (`account_disabled`); a locked account; an account without **View the board** (`error`), except a new member waiting for email confirmation or approval.
- **Params:**

**Name and password:**
  - `loginname` (string, required) — User name or email.
  - `password` (string, required)
  - `remember` (bool, optional, default true) — XenForo's remember cookie.
  - `tfaCode` (string, optional) — The two-step code, in the second request.
  - `tfaProvider` (string, optional) — Two-step method (`totp`, `email`, `backup`...). In the first request it picks the method to start (an `email` code is sent then); in the second, the method `tfaCode` is for (default: the member's first one).
  - `trustDevice` (bool, optional, default false) — With `tfaCode`: trust this device, so the remember cookie can sign the app back in without two-step (for the forum's app trust period, 365 days by default). Signing out ends it.
  - `anonymous`, `trustCode` — accepted and ignored.

**Passkey:**
  - `webauthn_challenge` (string, required) — From `getPasskeyChallenge`, or `passkeyChallenge` of a two-step reply.
  - `webauthn_payload` (object, required) — WebAuthn assertion:
    - `id` (string) — Base64-encoded credential ID.
    - `clientDataJSON` (string) — Base64-encoded client data.
    - `authenticatorData` (string) — Base64-encoded authenticator data.
    - `signature` (string) — Base64-encoded signature.
  - `remember` (bool, optional, default true)

  A request with `webauthn_payload` is always a passkey sign-in: the passkey's account signs in, and `loginname` and `password` are not needed. A passkey answers a two-step reply the same way. A passkey sign-in also trusts the device for two-step.

- **Response:**
  - `user` (object) — `id`, `username`, `userType` (primary group id), `iconUrl`, `postCount`, `registrationTime`, `lastActivityTime` (ms), `userState`, `acceptsPM`, `canSendPM`, and from 1.11.0 `email`, `canPM`, `canModerate`, `canSearch`.
  - `canWhosonline`, `canProfile`, `canUploadAvatar`, `canUploadAttachment`, `canUploadConversationAttachment` (bool).
  - `maxAttachment` (files per message), `maxAttachmentSize`, `maxPngSize`, `maxJpgSize` (bytes; XenForo has one size limit for all files), `allowedFileExtensions`, `maxImageWidth`, `maxImageHeight`.

- **Response (when two-step is required):** the member uses two-step, it is on for the forum, and this device holds no trust. The method in `tfaProvider` (or the member's default) is started first: an `email` code is sent now.
  - `result` (bool) — `false`, without `resultText` or `errorCode`.
  - `tfaRequired` (bool) — `true`.
  - `providers` (array) — The member's methods: `id`, `title`, `description`, `type` (`passkey` or `code`).
  - `providerId` (string) — The method that was started.
  - `availableTfaMethods` (object) — `passkey`, `code` (bool).
  - `passkeyChallenge`, `passkeyRpId`, `passkeyTimeout` — When the member has a passkey, as `getPasskeyChallenge` gives them.

  Then send the same request again with `tfaCode` (and `tfaProvider`), or sign in with the passkey. A wrong code is refused (`validation`) and counts towards XenForo's two-step attempt limit (`flood`).

### `logout`

- **Auth:** `none` (never refused)
- **Description:** Signs the app out, as XenForo's logout does, and ends this device's two-step trust. With `deviceId` it also removes this device's push registration, as `unregisterDevice` does.
- **Params:**
  - `deviceId` (string, optional, 1.11.0)
  - `fcmToken` (string, optional, 1.11.0) — The device's token. With it, the device is removed even when the session has already ended.

### `register`

- **Auth:** `none`
- **Description:** Create a new user with the app's own form, through XenForo's
  registration service and its spam checks. Refused for a signed-in visitor,
  when the board is closed or registration is off, when `prefetchAccount`
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
  `requiresManualApproval` (each only when true), and `message` (XenForo's own
  "Thanks for registering" text). On error, `resultText` has every message,
  one per line, and `errors` maps a field to its message: `username`,
  `email`, `password`, `dob`, `location`, `timezone`, `custom_field_<id>`,
  `acceptTerms`, `acceptPrivacy`. An account XenForo's spam check rejects
  (1.11.0): `result: false`, `errorCode: account_disabled`, XenForo's
  rejection text, `userState: "rejected"` and `userId`.

### `prefetchAccount`

- **Auth:** `none`
- **Description:** Returns whether registration is open and possible in the
  app, its requirements and custom fields (those a new member may fill in),
  and starts XenForo's registration timer for `register`.
- **Params:** none
- **Response:**
  - `registrationOpen` (bool) — The board is open, registration is on, and XenForo would let this visitor sign up.
  - `canRegisterViaAPI` (bool) — `register` can be used.
  - `registerViaWebUrl` (string) — The canonical register page.
  - `customRegisterFields` (array) — The custom fields XenForo's register form shows: `fieldId`, `title`, `description`, `fieldType`, `required`, `displayOrder`, `matchType`, `maxLength`, `choices` (value => label), `matchParams`.
  - `registrationRequirements` (object, only when `canRegisterViaAPI`) — `username` (`minLength`, `maxLength`), `email`, `password`, `dateOfBirth` (`required`, `minimumAge`: 0 when none), `location` (`required`), `emailChoice` (`required`), `customFields`, `privacyPolicy` / `termsOfService` (`required` when the forum has it, `url` as a full address).

### `resendEmailConfirmation`

- **Auth:** `required`
- **Description:** Sends the confirmation email again, for a member waiting to
  confirm their email address; refused when there is none to send. At most
  once every ten minutes (XenForo's own page asks for a captcha instead).
- **Params:** none
- **Response:** `message` — XenForo's "The confirmation email has been resent."

### `completeBrowserLogin`

- **Auth:** `none`
- **Description:** Signs the app in with the one-time code the website handed
  to the app's scheme (see below), remembered. A member with two-step gets a
  `tfa_trust` cookie too, so the remember cookie can sign the app back in
  after its session lapses. Refused as `login` refuses an account (banned,
  rejected, no **View the board**...), and when the code has expired or was
  used.
- **Params:**
  - `code` (string, required) — From `<scheme>://login?code=…&state=…`.
  - `verifier` (string, required) — The PKCE verifier whose S256 challenge the app sent.
- **Response:** as `login`.

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
- **Description:** Sends a password reset email, as XenForo's lost password page does. Answers success whether or not the account exists. Refused for a signed-in visitor. Where the forum asks guests for a captcha on that page, the app can't show it: refused, with `resetViaWebUrl` (1.11.0), the website's lost password page. One IP address may ask 5 times in 30 minutes (`flood`), on top of XenForo's own limit per member.
- **Params:**
  - `usernameOrEmail` (string, required) — User name or email.

### `updatePassword`

- **Auth:** `required`
- **Description:** Changes the member's password, as XenForo's password page does: the current password is checked with XenForo's login limits, the new one with the forum's password rules, and the member gets the "password changed" email. The member's other devices are signed out (this session stays), and their push registrations are removed.
- **Params:**
  - `oldPassword` (string, required)
  - `newPassword` (string, required)
  - `deviceId` (string, optional, 1.11.0) — This device, whose push registration stays. Without it every push registration of the member goes, and the app registers again on its next start.

### `updateEmail`

- **Auth:** `required`
- **Description:** Changes the member's email address, as XenForo's account page does: the password is checked with XenForo's login limits, the address with XenForo's email checks (format, banned addresses, typos). Refused when XenForo doesn't let the member change it now.
- **Params:**
  - `password` (string, required)
  - `newEmail` (string, required)
- **Response:** `confirmationRequired` (bool) — XenForo sent a confirmation email to the new address; the account waits for it.

### `updateProfile`

- **Auth:** `required`
- **Description:** Saves the member's own profile and preferences, as XenForo's account details, privacy, preferences and signature pages do; never another member's. Refused without XenForo's permission to edit one's profile. Every part is optional: only what is sent changes. XenForo's checks apply (among them the spam check of `about`); errors tied to a field come in `errors`.
- **Params:**
  - `userId` (string, optional) — Must be the member's own id.
  - `user` (object, optional) — `customTitle` (with XenForo's custom title permission; ignored otherwise), `visible` (show online status), `activityVisible` (show current activity), `timezone` (PHP time zone name).
  - `option` (object, optional) — `receiveAdminEmail`, `showDobYear`, `showDobDate` (bool).
  - `profile` (object, optional) — `location`, `website`, `about`, `signature` (BBCode; needs XenForo's signature permission, refused otherwise).
  - `customFields` (object, optional) — Field id to value, for the personal and contact fields the member may edit. When sent (even empty), the required ones are checked.
  - `dobDay`, `dobMonth`, `dobYear` (int, optional) — Date of birth, only while it is incomplete, as on XenForo's page (`dobYear` may be left out).
  - `enableActivitySummaryEmail` (bool, optional) — Where XenForo has the activity summary email.

### `deleteAccount`

- **Auth:** `required`
- **Description:** Deletes the member's own account, as when an administrator deletes a member: the account, profile and settings go; posts stay under the name, as a guest's. The member's push registrations go with it, and the app is signed out. Refused when the forum turned it off (`getConfig`'s `accountDeletion` is false), and for staff accounts (administrators, moderators, staff members), which are removed in the admin control panel.
- **Params:**
  - `password` (string) — Required for an account with a password; checked with XenForo's login limits.
  - `username` (string) — For an account without a password (signed up with Google, Facebook...): the member's user name, typed in.

### `getUserSettingsCategories`

- **Auth:** `required`
- **Description:** The settings pages the app can show.
- **Params:** none
- **Response:** `categories` (array) — `key` (`push_notifications`, `email_privacy`), `displayName`, `description`, `enabled` (for `push_notifications`: the forum has push notifications on).

### `getUserSettings`

- **Auth:** `required`
- **Description:** The member's settings in one category, with their current values.
- **Params:**
  - `category` (string, required) — A category `key`.
- **Response:** `category`, `enabled`, `settings` (array, in display order). Each setting: `fieldId`, `title`, `description`, `fieldType`, `dataType`, `value`, `default`, `choices` (value => label), `required`, `readOnly`, `maxLength`, `matchType`, `matchParams`, `min`, `max`, `pattern`, `placeholder`, `displayOrder`, `group`, `dependsOn`.
  - `push_notifications` — One toggle per alert type (`{contentType}_{action}`). From 1.11.0 a type the member turned off as an alert on the website is `readOnly`, and its `description` says so.
  - `email_privacy` — `receive_admin_email`, `email_on_conversation`, `creation_watch_state` and `interaction_watch_state` (`""`, `watch_no_email`, `watch_email`), `content_show_signature`, `visible`, `activity_visible`, with XenForo's labels and the forum's defaults for new members.

### `updateUserSettings`

- **Auth:** `required`
- **Description:** Saves settings of one category. Unknown keys and wrong values are refused (`validation`); `push_notifications` is refused when the forum has push notifications off.
- **Params:**
  - `category` (string, required)
  - `settings` (object, required) — Setting key to value. `email_privacy` also takes `creation_watch_email` and `interaction_watch_email` (bool, older apps).
- **Response:** as `getUserSettings`, with the saved values.

## User

### `getUserInfo`

- **Auth:** `optional`
- **Description:** A member's profile, as XenForo's member page shows it to the visitor. Location, website, about, signature, custom fields and follow counts only when the visitor may view the full profile. Online status and last activity follow the member's privacy, unless the visitor may override it. Viewing another member's profile marks their "followed you" alert read.
- **Params:**
  - `userId` (string, optional) — A number (a JSON number is accepted too).
  - `username` (string, optional) — Used when there is no `userId`.
- **Response:** `id`, `username`, `userType`, `iconUrl`, `postCount`, `registrationTime`, `lastActivityTime` (ms; null when hidden), `isOnline`, `displayText` (user title), `location`, `website`, `about`, `signature`, `customFields` (field id => value), `followingCount`, `followerCount`, `isFollowing`, `isFollowingMe`, `isIgnored`; `userState` and `userGroups` (real values only for the member themself and administrators who manage members), `isBanned` (also for moderators who can ban); what the visitor may do: `acceptsPM` (start a direct message with them), `canFollow` and `acceptsFollowers` (the same), `canIgnore`, `canBan`, `canSpamClean`, `canBeReported`; from 1.11.0 `canPostOnProfile` and `customFieldsDisplay` (`id`, `title`, `value` as text, in display order, empty ones left out).

### `searchUser`

- **Auth:** `optional`
- **Description:** Members by name, or the member list. With keywords: needs XenForo's search permission and at least 2 characters; names containing them. Without keywords: the member list, when the forum has it on and the visitor may view it. Valid members only, by name.
- **Params:**
  - `keywords` (string, optional)
  - `match` (string, optional, 1.11.0) — `prefix`: names starting with the keywords, as XenForo's member finder.
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20, at most 50, or the forum's members per page when larger)
- **Response:** `total`, `list` — `id`, `username`, `iconUrl`, `isOnline`, `postCount`, `registrationTime`.

### `getInboxStat`

- **Auth:** `required`
- **Description:** Unread direct messages and new alerts, for the app's badges.
- **Params:** none
- **Response:** `totalConversations`, `unreadConversations`, `unreadMessages` (the same as `unreadConversations`), `unreadAlerts` (alerts not viewed yet).

### `getOnlineUsers`

- **Auth:** `optional`
- **Description:** Members online now, most recent first, as XenForo's online list: needs the permission to view the member list. Members who hide their online status are left out, unless the visitor may override privacy.
- **Params:**
  - `page` (int, optional, default 1)
  - `perpage` (int, optional, default 20, at most 50, or the forum's members per page when larger)
  - `id` (string, optional) — Only this member.
  - `area` (string, optional) — Only members on this XenForo controller (the class name XenForo stores with the activity).
- **Response:** `total`, `list` — `id`, `username`, `iconUrl`, `isOnline` (true), `lastActivityTime` (ms), `currentActivity` (text, e.g. "Viewing thread"), `currentActivityUrl`, `currentTopicId` (only for a thread the visitor may view). The last three are null when the member hides their activity.

### `getUserReplyPost`

- **Auth:** `optional`
- **Description:** A member's posts, newest first, as their profile's postings: refused when the visitor may not view the member's full profile. Visible posts in threads the visitor may view; for the member themself, also their posts awaiting approval.
- **Params:**
  - `userId` (string, optional) or `username` (string, optional) — one is required.
  - `startNum` (int, optional, default 0) — First row, 0-based.
  - `lastNum` (int, optional, default 10) — Last row, inclusive; at most 50 rows.
- **Response:** `total`, `list` (also as `posts`) — `postId`, `topicId`, `topicTitle`, `forumId`, `forumName`, `replyNumber` (the thread's reply count), `authorId`, `authorName`, `authorIconUrl`, `postTime` (ms), `shortContent`.

### `reportUser`

- **Auth:** `required`
- **Description:** Reports a member to the staff, as XenForo's report form: needs the permission to report, and staff members can't be reported. Flood limit.
- **Params:**
  - `userId` (string, optional) or `username` (string, optional) — one is required.
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
- **Description:** A page of a thread's posts, oldest first, with the thread. As XenForo's thread page: the thread is marked read up to the last post shown, the alerts about the posts shown are marked read, and a view is counted when the page starts at the first post.
- **Params:**
  - `topicId` (string, required)
  - `startNum` (int, optional, default 1) — Number of the first post, 1-based (0 is read as 1).
  - `lastNum` (int, optional, default 19) — Number of the last post, inclusive; at most 100 posts.
  - `includeHidden` (bool, optional, default false, 1.11.0) — Also the moderated and deleted posts the visitor may see, and the member's own posts awaiting approval, as XenForo's thread page lists them. Such a post comes with the page of the visible post before it and shares its number.
- **Response:**
  - `totalPostNum` (int) — Visible posts in the thread.
  - `posts` (array) — Each post: `id`, `topicId`, `authorId`, `authorName`, `authorUserType`, `authorIconUrl`, `timestamp` (ms), `title` (first post only), `content` (BBCode, with the forum's censored words replaced and images through its image proxy), `position` (the post's number), `isFirstPost`, `isApproved`, `isDeleted`, `canEdit`, `canDelete`, `canReport`, `canLike`, `isLiked`, `likeCount`, `likesInfo`, `attachments`. From 1.11.0: `isAuthorOnline`, `isIgnored` (the visitor ignores the author), `canApprove`, `canUndelete`, `signature` (BBCode; null when there is none or the visitor hides signatures), `isSolution`, `voteScore`, `visitorVote` (`up`, `down` or null), `canContentVote`.
  - Each attachment: `id`, `fileName`, `fileSize`, `mimeType`, `url` (empty without the permission to view attachments), `thumbnailUrl`, `isImage`, `width`, `height`, `isInline`, `canViewUrl`, `canViewThumbnailUrl`, and from 1.11.0 `fileSizePrintable`, `isVideo`, `isAudio`, `typeGrouping`, `icon`, `iconName` (where the XenForo version has them).
  - The thread, as in topic rows: `id`, `title`, `forumId`, `forumName`, `prefix`, `authorId`, `authorName`, `authorIconUrl`, `timestamp`, `replyCount`, `viewCount`, `url`, `isClosed`, `isPinned`, `isApproved`, `isDeleted`, `isSubscribed`, `canSubscribe`, `canReply`, `canReport`, `canUpload`, `canRename`, `canDelete`, `canClose`, `canApprove`, `canStick`, `canMove`, `canMerge`, `isMoved` and `realTopicId` (a redirect left by a move, and the thread it points to), `canLike`, `isLiked`, `likeCount` (of the first post). From 1.11.0: `threadType` (`discussion`, `question`, `suggestion`, `article`, `poll`, `redirect`...), `solutionPostId` (a question's solution), `voteScore`, `visitorVote`, `canContentVote`.
  - `hasPoll` (bool) — Whether the thread has a poll.
  - `poll` (object|null) — Full poll data when the thread has a poll; otherwise `null`. See [API-Poll.md](API-Poll.md).

### `getThreadByPost`

- **Auth:** `optional`
- **Description:** The page of a thread around one post, with the post in the middle; otherwise as `getThread`.
- **Params:**
  - `postId` (string, required)
  - `postsPerRequest` (int, optional, default 20, from 1 to 100)
  - `includeHidden` (bool, optional, default false, 1.11.0) — As in `getThread`.
- **Response:** as `getThread`, plus `position` (the post's number; a hidden post shares the number of the visible post before it), `canReply`, `canReport`, `canUpload`.

### `getThreadByUnread`

- **Auth:** `required`
- **Description:** The page of a thread with the member's first unread post, as XenForo's "unread" link (posts by members they ignore are skipped). Pages are `postsPerRequest` posts from the start of the thread. When all is read, the last page.
- **Params:**
  - `topicId` (string, required)
  - `postsPerRequest` (int, optional, default 20, from 1 to 100)
  - `includeHidden` (bool, optional, default false, 1.11.0) — As in `getThread`.
- **Response:** as `getThreadByPost`; `position` is the first unread post's number (the last post's when all is read).

### `votePoll`

- **Auth:** `required`
- **Description:** Votes on a thread's poll, or changes the member's vote, as XenForo's poll form: refused where XenForo says the member can't vote. See [API-Poll.md](API-Poll.md) for full details and poll schema.
- **Params:**
  - `topicId` (string, required)
  - `responseIds` (array<string>, required) — IDs of selected options from `poll.responses[].id`.
- **Response:**
  - `poll` (object) — Updated poll data (same schema as in thread responses).

### `replyPost`

- **Auth:** `required`
- **Description:** Replies to a thread, as XenForo's reply form: needs the permission to reply there, and XenForo's spam check and flood limit apply. The reply may be held for approval. Afterwards the member watches the thread as their preference says, the thread is marked read, and the member's reply draft for it is deleted.
- **Params:**
  - `topicId` (string, required)
  - `textBody` (string, required) — BBCode.
  - `groupId` (string, optional) — The upload hash of files uploaded for it (`uploadAttachment`), where the member may attach files.
  - `forumId`, `attachmentIds` — accepted and not needed.
- **Response:** `postId`, `state` (1: awaiting approval, 0: visible), `postContent` (BBCode), `canEdit`, `canDelete`, `canReport`.

### `getRawPost`

- **Auth:** `required` (the member may edit the post)
- **Description:** A post's BBCode for the edit form, as XenForo's edit page: refused with XenForo's reason when the member can't edit it (edit time limit passed, thread closed...).
- **Params:**
  - `postId` (string, required)
- **Response:** `postContent` (BBCode), `postTitle` (the thread title for the first post; otherwise empty), `canEditTitle`, `prefixId`, `requirePrefix`, `prefixes` (`id`, `title`: those the member may use), `attachments` (as in `getThread`), and from 1.11.0 `forumId` and `attachmentData` (where the member may attach files: `type`, `hash` (a new upload hash), `context`, `constraints`, as XenForo's editor gets them).

### `saveRawPost`

- **Auth:** `required`
- **Description:** Saves an edited post, as XenForo's edit form: refused when the member can't edit it; XenForo's spam check and validation apply. Files already on the post stay; remove one with `removeAttachment`.
- **Params:**
  - `postId` (string, required)
  - `postContent` (string, required) — BBCode.
  - `postTitle` (string, optional) — New thread title (first post, where the member may edit the thread).
  - `prefix` (string, optional) — Prefix id (first post, where the prefix is editable); a prefix the forum doesn't allow is removed.
  - `groupId` (string, optional) — Upload hash of new files.
  - `silent` (bool, optional, 1.11.0) — No "last edited" mark, where XenForo allows a silent edit (moderators).
  - `authorAlert` (bool, optional, 1.11.0) — Alert the author, where XenForo allows it (a moderator editing another member's post).
  - `reason` (string, optional) — The alert's reason.
- **Response:** `postContent` (the saved BBCode).

### `getQuotePost`

- **Auth:** `optional` (the visitor may reply in the thread)
- **Description:** A post as a quote for a reply, as XenForo's quote button makes it: quotes inside the post left out, censored words replaced, in `[QUOTE="name, post: id, member: id"]`.
- **Params:**
  - `postId` (string, required)
- **Response:** `quoteContent` (BBCode).

### `reportPost`

- **Auth:** `required`
- **Description:** Reports a post to the staff, as XenForo's report form: needs the permission to report. Flood limit.
- **Params:**
  - `postId` (string, required)
  - `reason` (string, required)

## Drafts

XenForo's own drafts, shared with the forum's editor on the website: a reply
started in the app is there on the web, and the other way round. Every method
needs a signed-in member and works on the member's own drafts. Draft keys are
XenForo's:

- `thread-{id}` — a reply in a thread.
- `forum-{id}` — a new thread in a forum (extra: `title`, `prefix_id`).
- `conversation-reply-{id}` — a reply in a direct message.
- `conversation` — a new direct message (extra: `title`, `recipients`).

A draft: `draftKey`, `message` (BBCode), `extra` (object: `title`,
`prefix_id`, `recipients`), `lastUpdate` (Unix time).

### `getDraft`

- **Auth:** `required`
- **Params:**
  - `draftKey` (string, required)
- **Response:** `draft` (a draft, or null).

### `saveDraft`

- **Auth:** `required`
- **Description:** Saves a draft. Refused for a thread, forum or direct message the member can't see (for `conversation`: when they may not start direct messages). An empty message with no extra deletes the draft. What the website's editor stored with the draft (files, tags, poll...) is kept. When the forum's **Save drafts** option is off, nothing is saved.
- **Params:**
  - `draftKey` (string, required)
  - `message` (string, optional) — BBCode.
  - `extra` (object, optional) — `title`, `prefix_id`, `recipients`; other keys are ignored.
- **Response:** `draft` (the saved draft, or null when deleted or not saved); `saved: false` (1.11.0) when drafts are off.

### `deleteDraft`

- **Auth:** `required`
- **Params:**
  - `draftKey` (string, required)

### `getDrafts`

- **Auth:** `required`
- **Description:** The member's drafts of the four kinds above, newest first.
- **Params:**
  - `page` (int, optional, default 0) — 0-based.
  - `perPage` (int, optional, default 20, at most 100, 1.11.0)
- **Response:** `total`, `drafts`.

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

## Devices

Push notifications sent by the forum: the app registers its Firebase token
for the signed-in member.

### `registerDevice`

- **Auth:** `required`
- **Description:** Registers this device for the member's push notifications, or updates it (the app calls it on every start). A token that another device held moves to this one.
- **Params:**
  - `deviceId` (string, required) — At most 100 characters.
  - `fcmToken` (string, required) — At most 500 characters.
  - `platform` (string, optional) — `ios`, `android`, `macos` or `web`; any other value is stored as `android`.
  - `source` (string, optional, default `direct`) — `direct` (the forum's own Firebase project) or `forumcopilot` (the official app); other values are refused.
  - `appVersion` (string, optional)
- **Response:** `device` — `deviceId`, `platform`, `source`.

### `unregisterDevice`

- **Auth:** `required`, or `none` with `fcmToken` (never refused by the board access checks)
- **Description:** Stops push notifications to a device. It is removed when it belongs to the member, or when `fcmToken` is the token it holds, so a phone whose session already ended can still stop them. Otherwise nothing happens (still success).
- **Params:**
  - `deviceId` (string, required)
  - `fcmToken` (string, optional, 1.11.0)

### `updateDeviceToken`

- **Auth:** `required`
- **Description:** Gives a registered device its refreshed token. Refused when the device isn't registered (`not_found`) or belongs to another member (`no_permission`).
- **Params:**
  - `deviceId` (string, required)
  - `fcmToken` (string, required) — At most 500 characters.

## Attachment

### `uploadAttachment`

- **Auth:** `required`
- **Description:** Uploads a file for a new thread, a reply, a post being edited or a direct message, as XenForo's editor does. Files uploaded together share an upload hash (`groupId`): send it with `newTopic`, `replyPost`, `saveRawPost`, `newConversation`, `replyConversation` or `saveRawMessage`. Refused where the member may not attach files there, and by XenForo's checks (allowed file types, size, image dimensions, files per message).
- **Params:**
  - `type` (string, required) — `pm` or `conversation_message` for a direct message; any other value (`post`) for a forum post.
  - `id` (string) — For a post: the forum id (required unless `postId` or `threadId` is sent). For a direct message: the conversation id, or empty for a new one.
  - `postId` (int, optional, 1.11.0) — The post being edited: the files-per-message limit counts its files too.
  - `threadId` (int, optional, 1.11.0) — The thread being replied to.
  - `groupId` (string, optional) — The upload hash to add to (letters and digits, at most 32); a new one is made when absent.
  - `attachmentName` (string, required) — The file name; its extension must be one the forum allows.
  - `attachmentData` (string, required) — The file, base64-encoded (`attachmentBytes` is read too).
- **Response:** `attachmentId`, `fileName`, `groupId` (the upload hash), `fileSize`.

### `removeAttachment`

- **Auth:** `required`
- **Description:** Removes an uploaded file. A file not attached to a message yet: only the member's own upload, with its upload hash. An attached file: where the member may manage the message's files (for a post: may edit it).
- **Params:**
  - `attachmentId` (string, required)
  - `groupId` (string) — The upload hash; required for a file not attached yet.
- **Response:** `groupId` (for a file not attached yet).

### `uploadAvatar`

- **Auth:** `required`
- **Description:** Sets the member's avatar, as XenForo's avatar page: needs the permission to upload one (`getConfig`'s `canUploadAvatar`), and XenForo's image checks apply.
- **Params:**
  - `imageExtension` (string, required) — `gif`, `jpg`, `jpeg`, `jpe`, `png` or `webp`.
  - `attachmentData` (string, required) — The image, base64-encoded (`attachmentBytes` is read too).
- **Response:** `imageUrl` (the full-size avatar, 1.11.0), `thumbnailUrl` (the small avatar), `imageId` (the member's id, 1.11.0), and from 1.11.0 `attachmentId` (the member's id), `fileName`, `fileSize`.

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

As XenForo's own moderator tools: each method needs a signed-in member with
XenForo's permission for that action on that thread, post or member (or, for
the member's own posts and threads, what XenForo lets authors do), and the
thread or post must be visible to them. Refused with `no_permission`
otherwise. Replies have `isLoginMod: true`, except `spamCleanUser`.

### `doLoginMod`

- **Auth:** `none`
- **Description:** Kept for older apps: always refused (`bad_request`). Moderators sign in with `login`; the methods below follow the signed-in account's permissions.
- **Params:** none

### `stickTopic` / `unstickTopic`

- **Auth:** `required`
- **Description:** Sticks or unsticks a thread: needs the permission to stick threads.
- **Params:** `topicId` (string, required)

### `closeTopic` / `uncloseTopic`

- **Auth:** `required`
- **Description:** Locks or unlocks a thread: needs the permission to lock threads. Refused for a redirect left by a move.
- **Params:** `topicId` (string, required)

### `deleteTopic`

- **Auth:** `required`
- **Description:** Deletes a thread with XenForo's thread deleter: needs the permission to delete it (and to delete permanently, for `hardDelete`).
- **Params:**
  - `topicId` (string, required)
  - `hardDelete` (bool, optional, default false) — Delete permanently instead of soft-deleting.
  - `reason` (string, optional) — The deletion reason.
  - `starterAlert` (bool, optional) — Alert the thread starter.
  - `starterAlertReason` (string, optional)
  - `mode` (int, optional) — Older apps: 2 is a permanent delete. Read only without `hardDelete`.

### `deletePost`

- **Auth:** `required`
- **Description:** Deletes a post with XenForo's post deleter: needs the permission to delete it (and to delete permanently, for `hardDelete`). Deleting a thread's first post deletes the thread.
- **Params:**
  - `postId` (string, required)
  - `hardDelete` (bool, optional, default false)
  - `reason` (string, optional)
  - `authorAlert` (bool, optional, 1.11.0) — Alert the author, where XenForo allows it.
  - `authorAlertReason` (string, optional, 1.11.0)
  - `mode` (int, optional) — As in `deleteTopic`.
- **Response:** `threadDeleted` (bool, 1.11.0) — The whole thread went with its first post.

### `undeleteTopic` / `undeletePost`

- **Auth:** `required`
- **Description:** Restores a soft-deleted thread or post: needs the permissions to view and undelete deleted content. `undeleteTopic` is refused for a thread that isn't deleted (`validation`); `undeletePost` leaves such a post as it is.
- **Params:** `topicId` or `postId` (string, required)

### `moveTopic`

- **Auth:** `required`
- **Description:** Moves a thread to another forum, as XenForo's move form: needs the permission to move it, and the target forum must be visible to the member.
- **Params:**
  - `topicId` (string, required)
  - `forumId` (string, required) — The target forum.
  - `redirect` (bool, optional) — Leave a redirect in the old forum.
  - `redirectLength` (int, optional, 1.11.0) — How long the redirect stays, in seconds; 0 or absent: permanent.
  - `starterAlert` (bool, optional, 1.11.0) — Alert the thread starter.
  - `starterAlertReason` (string, optional, 1.11.0)
  - `notifyWatchers` (bool, optional, 1.11.0) — Notify the target forum's watchers.
  - `prefixId` (string, optional, 1.11.0) — The thread's prefix in the new forum.

### `renameTopic`

- **Auth:** `required`
- **Description:** Changes a thread's title: needs the permission to edit the thread. XenForo checks the title.
- **Params:**
  - `topicId` (string, required)
  - `title` (string, required)

### `approveTopic` / `approvePost`

- **Auth:** `required`
- **Description:** Approves a thread or post awaiting approval, as XenForo's approval queue: needs the permission to approve. Watchers and the members mentioned or quoted are then notified, as on the website. Approving a thread's first post approves the thread. A visible thread or post is left as it is; a deleted thread is refused (use `undeleteTopic`).
- **Params:** `topicId` or `postId` (string, required)

### `banUser`

- **Auth:** `required`
- **Description:** Bans a member, as XenForo's ban form: needs a moderator with the permission to ban; administrators and moderators can't be banned. The end must be in the future.
- **Params:**
  - `userName` (string, required) — The member's user name (not an id).
  - `reason` (string, optional)
  - `banLength` (string, optional) — `permanent` or `temporary`. Default: `temporary` when an end is sent, otherwise `permanent`.
  - `endTime` (int, optional, 1.11.0) — The end, as Unix time.
  - `endDate` (string, optional) — The end as `YYYY-MM-DD` or `YYYY-MM-DD HH:MM:SS`, in `timeZone`, or else in the moderator's XenForo time zone.
  - `timeZone` (string, optional, 1.11.0) — A PHP time zone name (e.g. `Europe/Paris`).
  - `banExpires` (int, optional) — Older apps: the end as Unix time, or a number of seconds from now.

### `unbanUser`

- **Auth:** `required`
- **Description:** Lifts a member's ban: needs the permission to ban them. Refused when the member isn't banned.
- **Params:**
  - `userId` (string, optional) or `userName` (string, optional) — one is required. A `userId` that isn't a number is read as a user name.

### `spamCleanUser`

- **Auth:** `required`
- **Description:** Runs XenForo's spam cleaner on a member: needs the spam cleaner permission, and the member must be one XenForo lets it clean (not an administrator or moderator, and within the forum's spam cleaner limits: messages, account age, reaction score).
- **Params:**
  - `userId` (string, optional) or `username` (string, optional) — one is required.
  - `actionThreads` (bool, optional, default false) — Remove their threads (deleted or moved, as the forum's spam cleaner options say).
  - `deleteMessages` (bool, optional, default false) — Delete their messages.
  - `deleteConversations` (bool, optional, default false) — Delete their direct messages.
  - `banUser` (bool, optional, default false) — Ban them.
- **Response:** `userId`, `username`, `actions` (`action_threads`, `delete_messages`, `delete_conversations`, `ban_user`: what was asked).

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


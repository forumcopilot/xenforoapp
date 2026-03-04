# Forum Copilot API — Poll (view & vote)

This document describes the **Poll** features in the Forum Copilot API: viewing poll data on threads and submitting votes. Use it to implement poll UI and voting in your app.

**Scope:** Viewing polls and voting only. Creating or editing polls via the API is not supported.

---

## Base request

All methods use the same endpoint and envelope as the rest of the API:

- **Endpoint:** `POST /forumcopilot.php` (or your board’s base URL + `forumcopilot.php`)
- **Request body:** JSON `{ "method": "<methodName>", "params": { ... } }`
- **Response:** JSON with `result: true` and method-specific data on success, or `result: false` and `resultText` on error.

---

## 1. Topic lists — `hasPoll` flag

Any endpoint that returns a **topic/thread list** now includes a boolean **`hasPoll`** on each topic.

Use it to show a “has poll” indicator in topic lists without opening the thread.

### Affected methods

- `getTopicByIds`
- `getTopic` (and topic list methods that return the same topic shape)

### Topic object (relevant field)

| Field     | Type  | Description                          |
|----------|--------|--------------------------------------|
| `hasPoll` | bool  | `true` if the thread has a poll.     |

**Example:** In `getTopicByIds`, each item in the returned topic list may look like:

```json
{
  "id": "622",
  "title": "Which feature next?",
  "forumId": "2",
  "hasPoll": true,
  ...
}
```

If the thread has no poll, `hasPoll` is `false`.

---

## 2. Thread responses — full poll object

When you load a **single thread** (get thread + posts), the response includes both **`hasPoll`** and **`poll`**.

### Affected methods

- **`getThread`** — get thread by `topicId`
- **`getThreadByPost`** — get thread by `postId`
- **`getThreadByUnread`** — get thread from first unread (auth required)

### Response fields (top level)

| Field     | Type         | Description                                      |
|----------|--------------|--------------------------------------------------|
| `hasPoll` | bool         | `true` if the thread has a poll.                 |
| `poll`    | object \| null | Full poll data when `hasPoll` is true; else `null`. |

If the thread has no poll, `hasPoll` is `false` and `poll` is `null`. Both fields are always present so the app can rely on a stable shape.

---

## 3. Poll object schema

When `poll` is not `null`, it has the following shape. The same structure is returned by **thread methods** and by **`votePoll`**.

### Top-level poll fields

| Field               | Type    | Description |
|---------------------|---------|-------------|
| `pollId`            | string  | Poll ID. |
| `topicId`            | string  | Thread (topic) ID. |
| `question`          | string  | Poll question text. |
| `responses`         | array   | List of choices (see below). |
| `voterCount`       | int \| null | Total number of voters. **`null`** when the user is not allowed to see results. |
| `maxVotes`         | int     | Max options a user can select. **`0`** = unlimited. |
| `changeVote`       | bool    | Whether the user can change their vote. |
| `publicVotes`      | bool    | Whether votes are public. |
| `viewResultsUnvoted` | bool  | Whether results are visible before voting. |
| `closeDate`        | int     | Close time in **milliseconds** (Unix timestamp × 1000). `0` if no close time. |
| `isClosed`         | bool    | Whether the poll is closed. |
| `canVote`          | bool    | Whether the current user can vote (login + permissions + poll open). |
| `hasVoted`         | bool    | Whether the current user has already voted. |
| `canViewResults`   | bool    | Whether the current user can see vote counts. |

### `responses` array

Each element:

| Field           | Type    | Description |
|-----------------|---------|-------------|
| `id`            | string  | Response (choice) ID. Use these in `votePoll` as `responseIds`. |
| `text`          | string  | Choice text. |
| `voteCount`     | int \| null | Number of votes for this choice. **`null`** when the user cannot view results. |
| `viewerVotedFor`| bool    | Whether the current user selected this option. |

**Note:** The API does **not** return `votePercent`; compute percentages client-side from `voteCount` and `voterCount` when `canViewResults` is true.

### Example poll object

```json
{
  "pollId": "5",
  "topicId": "622",
  "question": "Which feature next?",
  "responses": [
    { "id": "1", "text": "Search", "voteCount": 12, "viewerVotedFor": true },
    { "id": "2", "text": "Polls", "voteCount": 8, "viewerVotedFor": false }
  ],
  "voterCount": 20,
  "maxVotes": 1,
  "changeVote": true,
  "publicVotes": false,
  "viewResultsUnvoted": true,
  "closeDate": 1738694321000,
  "isClosed": false,
  "canVote": true,
  "hasVoted": true,
  "canViewResults": true
}
```

When results are hidden for the user, `voterCount` and each `voteCount` will be `null`; `canViewResults` will be `false`.

---

## 4. Voting — `votePoll`

Submit or change the current user’s vote and get the updated poll.

### Method

**`votePoll`**

### Auth

**Required.** User must be logged in (session cookies).

### Params

| Param        | Type           | Required | Description |
|-------------|----------------|----------|-------------|
| `topicId`   | string         | Yes      | Thread (topic) ID that has the poll. |
| `responseIds` | array&lt;string&gt; | Yes   | IDs of the chosen options (from `poll.responses[].id`). Must not be empty. |

- For single-choice polls (`maxVotes === 1`), send one ID.
- For multi-choice, send up to `maxVotes` IDs (or more if `maxVotes === 0`).
- If `changeVote` is true, sending a new list replaces the previous vote.

### Success response

- `result`: `true`
- `poll`: **object** — same poll schema as above, with updated counts and `hasVoted: true`.

### Error cases

- Not logged in → `result: false`, `resultText` with an auth message (or HTTP 401).
- Missing or empty `topicId` → error.
- Missing or empty `responseIds` → error.
- Invalid or non-existent `topicId` → error.
- Thread has no poll → error.
- User cannot vote (e.g. poll closed, already voted and `changeVote` false, or no permission) → error with message.
- Invalid `responseIds` (not belonging to this poll or too many) → error.

### Example request

```json
{
  "method": "votePoll",
  "params": {
    "topicId": "622",
    "responseIds": ["1"]
  }
}
```

### Example success response

```json
{
  "result": true,
  "poll": {
    "pollId": "5",
    "topicId": "622",
    "question": "Which feature next?",
    "responses": [
      { "id": "1", "text": "Search", "voteCount": 13, "viewerVotedFor": true },
      { "id": "2", "text": "Polls", "voteCount": 8, "viewerVotedFor": false }
    ],
    "voterCount": 21,
    "maxVotes": 1,
    "changeVote": true,
    "publicVotes": false,
    "viewResultsUnvoted": true,
    "closeDate": 1738694321000,
    "isClosed": false,
    "canVote": true,
    "hasVoted": true,
    "canViewResults": true
  }
}
```

---

## 5. App implementation checklist

- [ ] In **topic lists**, read `hasPoll` and show a poll icon/badge when `true`.
- [ ] When opening a thread via **getThread** / **getThreadByPost** / **getThreadByUnread**, read `hasPoll` and `poll`; if `poll` is non-null, render the poll (question, options, and optionally results if `canViewResults`).
- [ ] Use `poll.canVote` to show/hide the vote button; use `poll.hasVoted` and `viewerVotedFor` to show the user’s current choices.
- [ ] If `voteCount` / `voterCount` are `null`, do not show numeric results (or show a “vote to see results” message when appropriate).
- [ ] To submit a vote, call **votePoll** with `topicId` and `responseIds` (array of option IDs from `poll.responses[].id`).
- [ ] After a successful **votePoll**, replace the in-memory poll with the returned `poll` object (updated counts and `hasVoted: true`).
- [ ] Handle errors (auth, invalid params, cannot vote) and show `resultText` to the user when appropriate.

---

## 6. Summary table

| Feature           | Where                    | Fields / method      |
|-------------------|--------------------------|----------------------|
| Topic has a poll  | Topic list responses     | `hasPoll` (bool)     |
| Full poll data    | getThread, getThreadByPost, getThreadByUnread | `hasPoll`, `poll` (object or null) |
| Submit vote       | —                        | Method `votePoll` (params: `topicId`, `responseIds`) |
| Updated poll      | votePoll success         | `poll` (same schema) |

All timestamps in the poll object (e.g. `closeDate`) are in **milliseconds**. Poll data is at **thread level** only, not per post.

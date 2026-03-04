# Forum Copilot API — Advanced Search

Simple reference for the two advanced search methods.

**Base:** Same as Forum Copilot API (GET `?method=...` or POST JSON with `method` and `params`).  
**Auth:** Session/cookies; user must have search permission.

---

## 1. advanceSearchTopic

Search threads (topics) with filters: keywords, forums, user, date, title-only.

### Request

| Method | `method` | Description |
|--------|----------|-------------|
| GET    | `advanceSearchTopic` | All other params as query string. |
| POST   | `advanceSearchTopic` | In JSON body: `{ "method": "advanceSearchTopic", "params": { ... } }`. |

### Parameters

| Parameter   | Type    | Required | Default | Description |
|------------|---------|----------|---------|-------------|
| `keywords` | string  | Yes      | —       | Search phrase. Matches thread title and/or post content. |
| `page`     | int     | No       | 1       | Page number (1-based). |
| `perpage`  | int     | No       | 20      | Results per page. |
| `searchId` | string  | No       | `""`    | Client-defined search ID, echoed in response. |
| `titleOnly`| bool    | No       | false   | If true, match only thread titles. |
| `userId`   | string  | No       | `""`    | Filter by user ID. |
| `searchUser` | string | No       | `""`    | Filter by username (alternative to `userId`). |
| `forumId`  | string  | No       | `""`    | Restrict to one forum (node) ID. |
| `topicId`  | string  | No       | `""`    | Restrict to one thread ID. |
| `onlyIn`   | array   | No       | `[]`    | Forum IDs to include (combined with `forumId`). |
| `notIn`    | array   | No       | `[]`    | Forum IDs to exclude. |
| `startedBy`| bool    | No       | false   | If true and user set, only threads started by that user. |
| `searchTime` | int   | No       | 0       | Only threads created after this Unix timestamp. |

### Success response

```json
{
  "result": true,
  "totalTopicNum": 42,
  "searchId": "optional-client-id",
  "topics": [
    {
      "id": "123",
      "title": "Thread title",
      "forumId": "5",
      "forumName": "General",
      "authorId": "1",
      "authorName": "admin",
      "authorUserType": "1",
      "timestamp": 1706457600000,
      "authorIconUrl": "https://example.com/avatars/s/1.jpg",
      "shortContent": "Preview of matching post...",
      "url": "https://example.com/threads/123/"
    }
  ]
}
```

### Error response

```json
{
  "result": false,
  "resultText": "Search keywords are required"
}
```

Common errors: `Search keywords are required`, `Search is not allowed`, `User not found: <name>`.

---

## 2. advanceSearchPost

Search posts with filters: keywords, forums, thread, user, date, title-only.

### Request

| Method | `method` | Description |
|--------|----------|-------------|
| GET    | `advanceSearchPost` | All other params as query string. |
| POST   | `advanceSearchPost` | In JSON body: `{ "method": "advanceSearchPost", "params": { ... } }`. |

### Parameters

| Parameter   | Type   | Required | Default | Description |
|------------|--------|----------|---------|-------------|
| `keywords` | string | Yes      | —       | Search phrase. |
| `page`    | int    | No       | 1       | Page number (1-based). |
| `perpage` | int    | No       | 20      | Results per page. |
| `searchId`| string | No       | `""`    | Client-defined search ID, echoed in response. |
| `titleOnly` | bool  | No       | false   | If true, match only in titles (of threads). |
| `userId`  | string | No       | `""`    | Filter by user ID (posts by that user). |
| `searchUser` | string | No     | `""`    | Filter by username. |
| `forumId` | string | No       | `""`    | Restrict to one forum ID. |
| `topicId` | string | No       | `""`    | Restrict to one thread ID. |
| `onlyIn`  | array  | No       | `[]`    | Forum IDs to include. |
| `notIn`   | array  | No       | `[]`    | Accepted but not applied (engine limitation). |
| `startedBy` | bool  | No       | false   | Accepted but not applied for post search. |
| `searchTime` | int   | No       | 0       | Only posts newer than this Unix timestamp. |

### Success response

```json
{
  "result": true,
  "totalPostNum": 15,
  "searchId": "optional-client-id",
  "posts": [
    {
      "id": "456",
      "topicId": "123",
      "title": "Thread title",
      "authorId": "2",
      "authorName": "user",
      "authorIconUrl": "https://example.com/avatars/s/2.jpg",
      "timestamp": 1706461200000,
      "content": "Preview of post content...",
      "url": "https://example.com/posts/456/",
      "isBanned": false
    }
  ]
}
```

### Error response

```json
{
  "result": false,
  "resultText": "Search keywords are required"
}
```

Common errors: `Search keywords are required`, `Search is not allowed`, `User not found: <id or name>`.

---

## Examples

**GET — advance topic search (keywords + one forum):**

```
GET /?method=advanceSearchTopic&keywords=hello&forumId=5&page=1&perpage=10
```

**POST — advance post search:**

```json
POST /
Content-Type: application/json

{
  "method": "advanceSearchPost",
  "params": {
    "keywords": "example",
    "page": 1,
    "perpage": 20,
    "searchUser": "admin",
    "searchTime": 1704067200
  }
}
```



# XenForo API - Profile Posts

## POST profile-post-comments/

Creates a new profile post comment.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| profile_post_id | integer | **Required** The ID of the profile post this comment will be attached to. |
| message | string | **Required** |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be profile_post_comment with context[profile_post_id] set to this profile post ID. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| comment | [ProfilePostComment](#type_ProfilePostComment) | |

## GET profile-post-comments/{id}/

Gets information about the specified profile post comment.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| comment | [ProfilePostComment](#type_ProfilePostComment) | |

## POST profile-post-comments/{id}/

Updates the specified profile post comment.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| message | string | |
| author_alert | bool | |
| author_alert_reason | string | |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be profile_post_comment with context[profile_post_comment_id] set to this profile post comment ID. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| comment | [ProfilePostComment](#type_ProfilePostComment) | |

## DELETE profile-post-comments/{id}/

Deletes the specified profile post comment. Default to soft deletion.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| hard_delete | bool | |
| reason | string | |
| author_alert | bool | |
| author_alert_reason | string | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## POST profile-post-comments/{id}/react

Reacts to the specified profile post comment

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| reaction_id | integer | **Required** ID of the reaction to use. Use the current reaction ID to undo. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

## POST profile-posts/

Creates a new profile post.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| user_id | integer | **Required** The ID of the user whose profile this will be posted on. |
| message | string | **Required** |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be profile_post with context[profile_user_id] set to this user ID. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| profile_post | [ProfilePost](#type_ProfilePost) | |

## GET profile-posts/{id}/

Gets information about the specified profile post.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| with_comments | bool | If specified, the response will include a page of comments. |
| page | integer | The page of comments to include |
| direction | string | Request a particular sort order for comments - default 'desc' (newest first) also allows 'asc' (oldest first) |

### Response

| Output | Type | Description |
|--------|------|-------------|
| profile_post | [ProfilePost](#type_ProfilePost) | |
| comments | [ProfilePostComment](#type_ProfilePostComment)[] | List of comments on the requested page |
| pagination | pagination | Pagination details |

## POST profile-posts/{id}/

Updates the specified profile post.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| message | string | |
| author_alert | bool | |
| author_alert_reason | string | |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be profile_post with context[profile_post_id] set to this profile post ID. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| profile_post | [ProfilePost](#type_ProfilePost) | |

## DELETE profile-posts/{id}/

Deletes the specified profile post. Default to soft deletion.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| hard_delete | bool | |
| reason | string | |
| author_alert | bool | |
| author_alert_reason | string | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## GET profile-posts/{id}/comments

Gets a page of comments on the specified profile post.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| page | integer | |
| direction | string | Request a particular sort order for comments - default 'desc' (newest first) also allows 'asc' (oldest first) |

### Response

| Output | Type | Description |
|--------|------|-------------|
| comments | [ProfilePostComment](#type_ProfilePostComment)[] | List of comments on the requested page |
| pagination | pagination | Pagination details |

## POST profile-posts/{id}/react

Reacts to the specified profile post

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| reaction_id | integer | **Required** ID of the reaction to use. Use the current reaction ID to undo. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |
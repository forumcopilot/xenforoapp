# XenForo API - Posts

## POST posts/

Adds a new reply to a thread.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| thread_id | integer | **Required** ID of the thread to reply to. |
| message | string | **Required** |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be post with context[thread_id] set to this thread ID. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| post | [Post](#type_Post) | |

## GET posts/{id}/

Gets information about the specified post

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| post | [Post](#type_Post) | |

## POST posts/{id}/

Updates the specified post

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| message | string | |
| silent | bool | If true and permissions allow, this edit will not be updated with a "last edited" indication |
| clear_edit | bool | If true and permissions allow, any "last edited" indication will be removed. Requires "silent". |
| author_alert | bool | |
| author_alert_reason | string | |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be post with context[post_id] set to this post ID. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| post | [Post](#type_Post) | |

## DELETE posts/{id}/

Deletes the specified post. Default to soft deletion.

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

## POST posts/{id}/mark-solution

Toggle the specified post as the solution to its containing thread. If a post is marked as a solution when another is already marked, the existing solution will be unmarked.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| true | mixed | Success |
| new_solution_post | [Post](#type_Post)\|null | A post that was marked as the solution |
| old_solution_post | [Post](#type_Post)\|null | A post that was un-marked as the solution |

## POST posts/{id}/react

Reacts to the specified post

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| reaction_id | integer | **Required** ID of the reaction to use. Use the current reaction ID to undo. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

## POST posts/{id}/vote

Votes on the specified post (if applicable)

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| type | string | **Required** Type of vote, "up" or "down". Use the current type to undo. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

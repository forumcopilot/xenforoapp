# XenForo API - Threads

## GET threads/

Gets a list of threads

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| page | integer | |
| prefix_id | integer | Filters to only threads with the specified prefix. |
| starter_id | integer | Filters to only threads started by the specified user ID. |
| last_days | integer | Filters to threads that have had a reply in the last X days. |
| unread | bool | Filters to unread threads only. Ignored for guests. |
| thread_type | string | Filters to threads of the specified thread type. |
| order | string | Method of ordering: last_post_date, post_date. When in a specific forum context: title, reply_count, view_count, vote_score, first_post_reaction_score. |
| direction | string | Either "asc" or "desc" for ascending or descending. Applies only if an order is provided. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| threads | Thread[] | |
| pagination | pagination | |

---

## POST threads/

Creates a thread. Thread type data can be set using additional input specific to the target thread type.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| node_id | integer | **Required** ID of the forum to create the thread in. |
| title | string | **Required** Title of the thread. |
| message | string | **Required** Body of the first post in the thread. |
| discussion_type | string | The type of thread to create. Specific types may require additional input. |
| prefix_id | integer | ID of the prefix to apply to the thread. If not valid in the selected forum, will be ignored. |
| tags | string[] | Array of tag names to apply to the thread. |
| custom_fields[&lt;name&gt;] | string | Value to apply to the custom field with the specified name. |
| discussion_open | bool | |
| sticky | bool | |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be post with context[node_id] set to the ID of the forum this is being posted in. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| thread | Thread | |

### Errors

| Error key | Description |
|-----------|-------------|
| no_permission | No permission error. |

---

## GET threads/{id}/

Gets information about the specified thread.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| with_posts | bool | If specified, the response will include a page of posts. |
| page | integer | The page of posts to include |
| with_first_post | bool | If specified, the response will contain the first post in the thread. |
| with_last_post | bool | If specified, the response will contain the last post in the thread. |
| order | string | Request a particular sort order for posts from the available options for the thread type |

### Response

| Output | Type | Description |
|--------|------|-------------|
| thread | Thread | |
| first_unread | Post | *Conditionally returned* If the thread is unread, information about the first unread post. |
| first_post | Post | *Conditionally returned* If requested, information about the first post in the thread. |
| last_post | Post | *Conditionally returned* If requested, information about the last post in the thread. |
| pinned_post | Post | *Conditionally returned* The pinned first post of the thread, if specified by the thread type. |
| highlighted_posts | Post[] | *Conditionally returned* A list of highlighted posts, if relevant to the thread type. The reason for highlighting depends on thread type. |
| posts | Post[] | List of posts on the requested page. Note that even if the first post is pinned, it will be included here. |
| pagination | pagination | Pagination details |

---

## POST threads/{id}/

Updates the specified thread

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| prefix_id | integer | |
| title | string | |
| discussion_open | bool | |
| sticky | bool | |
| custom_fields[&lt;name&gt;] | string | |
| add_tags | array | |
| remove_tags | array | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| thread | Thread | |

---

## DELETE threads/{id}/

Deletes the specified thread. Default to soft deletion.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| hard_delete | bool | |
| reason | string | |
| starter_alert | bool | |
| starter_alert_reason | string | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

---

## POST threads/{id}/change-type

Converts a thread to the specified type. Additional thread type data can be set using input specific to the new thread type.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| new_thread_type_id | string | **Required** |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| thread | Thread | |

---

## POST threads/{id}/mark-read

Marks the thread as read up until the specified time. This cannot mark a thread as unread or

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| date | integer | Unix timestamp to mark the thread read to. If not specified, defaults to the current time. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

---

## POST threads/{id}/move

Moves the specified thread to a different forum. Only simple title/prefix updates are supported at the same time

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| target_node_id | integer | **Required** |
| prefix_id | integer | If set, will update the thread's prefix. Prefix must be valid in the target forum. |
| title | string | If set, updates the thread's title |
| notify_watchers | bool | If true, users watching the target forum will receive a notification as if this thread were created in the target forum |
| starter_alert | bool | If true, the thread starter will receive an alert notifying them of the move |
| starter_alert_reason | bool | The reason for the move to include with the thread starter alert |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| thread | Thread | |

---

## GET threads/{id}/posts

Gets a page of posts in the specified conversation.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| page | integer | |
| order | string | Request a particular sort order for posts from the available options for the thread type |

### Response

| Output | Type | Description |
|--------|------|-------------|
| pinned_post | Post | *Conditionally returned* The pinned first post of the thread, if specified by the thread type. |
| highlighted_posts | Post[] | *Conditionally returned* A list of highlighted posts, if relevant to the thread type. The reason for highlighting depends on thread type. |
| posts | Post[] | List of posts on the requested page. Note that even if the first post is pinned, it will be included here. |
| pagination | pagination | Pagination details |

---

## POST threads/{id}/vote

Votes on the specified thread (if applicable)

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| type | string | **Required** Type of vote, "up" or "down". Use the current type to undo. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |
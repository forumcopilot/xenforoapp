# XenForo API - Forums

## GET forums/{id}/

Gets information about the specified forum

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| with_threads | bool | If true, gets a page of threads in this forum |
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
| forum | [Forum](#type_Forum) | |
| threads | [Thread](#type_Thread)[] | Threads on this page |
| pagination | pagination | Pagination information |
| sticky | [Thread](#type_Thread)[] | If on page 1, a list of sticky threads in this forum. Does not count towards the per page limit. |

## POST forums/{id}/mark-read

Marks the forum as read up until the specified time. This cannot mark a forum as unread or

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| date | integer | Unix timestamp to mark the forum read to. If not specified, defaults to the current time. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## GET forums/{id}/threads

Gets a page of threads from the specified forum.

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
| threads | [Thread](#type_Thread)[] | Threads on this page |
| pagination | pagination | Pagination information |
| sticky | [Thread](#type_Thread)[] | If on page 1, a list of sticky threads in this forum. Does not count towards the per page limit. |
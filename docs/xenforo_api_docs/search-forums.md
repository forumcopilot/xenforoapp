

# XenForo API - Search Forums

## GET search-forums/{id}/

Gets information about the specified search forum

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| with_threads | bool | If true, gets a page of threads in this search forum |
| page | integer | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| search_forum | SearchForum | |
| threads | [Thread](#type_Thread)[] | Threads on this page. Note: this will always respect viewing user permissions regardless of whether the API is set to bypass permissions. |
| pagination | pagination | Pagination information |
| sticky | [Thread](#type_Thread)[] | If on page 1, a list of sticky threads in this forum. Does not count towards the per page limit. |

## GET search-forums/{id}/threads

Gets a page of threads from the specified search forum.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| threads | [Thread](#type_Thread)[] | Threads on this page. Note: this will always respect viewing user permissions regardless of whether the API is set to bypass permissions. |
| pagination | pagination | Pagination information |
| sticky | [Thread](#type_Thread)[] | If on page 1, a list of sticky threads in this forum. Does not count towards the per page limit. |
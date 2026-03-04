
# XenForo API - Search

## POST search/

Creates a new search

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| search_type | string | |
| keywords | string | |
| c | array | |
| order | string | |
| grouped | bool | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| search | [Search](#type_Search) | |

## POST search/member

Retrieves search results for a specific member

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| user_id | integer | **Required** |
| content | string | |
| type | string | |
| before | integer | |
| thread_type | string | |
| grouped | bool | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| search | [Search](#type_Search) | |

## GET search/{id}/

Retrieves search results for a given search

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| page | integer | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| search | [Search](#type_Search) | |
| results | array | |
| pagination | pagination | |
| get_older_results_date | integer|null | |

## POST search/{id}/older

Retrieves older search results for a given search

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| search_id | integer | **Required** |
| before | integer | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| search | [Search](#type_Search) | |
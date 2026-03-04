# XenForo API - Index

## GET index/

Gets general information about the site and the API

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| version_id | integer | XenForo version ID |
| site_title | string | Title of the site this API relates to |
| base_url | string | The base URL of the XenForo install this API relates to |
| api_url | string | The base API URL |
| key[type] | string | Type of the API key accessing the API (guest, user or super) |
| key[user_id] | integer\|null | If a user key, the ID of the user the key is for; null otherwise |
| key[allow_all_scopes] | bool | If true, all scopes can be accessed |
| key[scopes] | string[] | A list of scopes this key can access (if not allowed to access all scopes) |

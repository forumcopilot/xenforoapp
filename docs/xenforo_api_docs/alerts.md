
# XenForo API - Alerts

## GET alerts/

Gets the API user's list of alerts

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| page | integer | |
| cutoff | integer | Unix timestamp of oldest alert to include. Note that unread or unviewed alerts are always included. |
| unviewed | bool | If true, gets only unviewed alerts. Unviewed alerts have not been seen (in the standard UI). |
| unread | bool | If true, gets only unread alerts. Unread alerts may have been seen but the content they relate to has not been viewed. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| alerts | UserAlert[] | |
| pagination | pagination | |

## POST alerts/

Sends an alert to the specified user. Only available to super user keys.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| to_user_id | integer | **Required** ID of the user to receive the alert |
| alert | string | **Required** Text of the alert. May use the placeholder "{link}" to have the link automatically inserted. |
| from_user_id | integer | If provided, the user to send the alert from. Otherwise, uses the current API user. May be 0 for an anonymous alert. |
| link_url | string | URL user will be taken to when the alert is clicked. |
| link_title | string | Text of the link URL that will be displayed. If no placeholder is present in the alert, will be automatically appended. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## POST alerts/mark-all

Marks all of the API user's alerts as read or viewed. Must specify "read" or "viewed" parameters.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| read | bool | If specified, marks all alerts as read. |
| viewed | bool | If specified, marks all alerts as viewed. This will remove the alert counter but keep unactioned alerts highlighted. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## GET alerts/{id}/

Gets information about the specified alert

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| alert | UserAlert | |

## POST alerts/{id}/mark

Marks the alert as viewed/read/unread. (Marking as unviewed is not supported.)

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| read | bool | If specified, marks the alert as read. |
| unread | bool | If specified, marks the alert as unread. |
| viewed | bool | If specified, marks all alerts as viewed. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

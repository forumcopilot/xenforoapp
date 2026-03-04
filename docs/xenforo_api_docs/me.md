# XenForo API - Me

## GET me/

Gets information about the current API user

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| me | [User](#type_User) | |

## POST me/

Updates information about the current user

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| option[creation_watch_state] | string | |
| option[interaction_watch_state] | string | |
| option[content_show_signature] | bool | |
| option[email_on_conversation] | bool | |
| option[push_on_conversation] | bool | |
| option[receive_admin_email] | bool | |
| option[show_dob_year] | bool | |
| option[show_dob_date] | bool | |
| profile[location] | string | |
| profile[website] | string | |
| profile[about] | string | |
| profile[signature] | string | |
| privacy[allow_view_profile] | string | |
| privacy[allow_post_profile] | string | |
| privacy[allow_receive_news_feed] | string | |
| privacy[allow_send_personal_conversation] | string | |
| privacy[allow_view_identities] | string | |
| visible | bool | |
| activity_visible | bool | |
| timezone | string | |
| custom_title | string | |
| custom_fields[<name>] | string | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## POST me/avatar

Updates the current user's avatar

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| avatar | file | **Required** The uploaded new avatar |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## DELETE me/avatar

Deletes the current user's avatar

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## POST me/email

Updates the current user's email address

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| current_password | string | **Required** |
| email | string | **Required** |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| confirmation_required | bool | True if email confirmation is required for this change |

## POST me/password

Updates the current user's password

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| current_password | string | **Required** |
| new_password | string | **Required** |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

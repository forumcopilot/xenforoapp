# XenForo API - Users

## GET users/

Gets a list of users (alphabetically)

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| page | integer | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| users | User[] | |
| pagination | pagination | |

---

## POST users/

Creates a user.

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
| option[is_discouraged] | bool | |
| username | string | |
| email | string | |
| user_group_id | integer | |
| secondary_group_ids | integer[] | |
| user_state | string | |
| is_staff | bool | |
| message_count | integer | |
| reaction_score | integer | |
| trophy_points | integer | |
| username_change_visible | bool | If true and the username is changed, the change will be visible (shown in the public list of previous usernames). |
| password | string | |
| dob[day] | integer | |
| dob[month] | integer | |
| dob[year] | integer | |
| custom_fields[&lt;name&gt;] | string | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| user | User | |

---

## GET users/find-email

Finds users by their email. Only available to admin users (or when bypassing permissions).

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| email | string | **Required** |

### Response

| Output | Type | Description |
|--------|------|-------------|
| user | User\|null | The user that matched the given email exactly |

---

## GET users/find-name

Finds users by a prefix of their user name.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| username | string | **Required** |

### Response

| Output | Type | Description |
|--------|------|-------------|
| exact | User\|null | The user that matched the given username exactly |
| recommendations | User[] | A list of users that match the prefix of the username (but not exactly) |

---

## GET users/{id}/

Gets information about the specified user.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| with_posts | bool | If specified, the response will include a page of profile posts. |
| page | integer | The page of comments to include |

### Response

| Output | Type | Description |
|--------|------|-------------|
| user | User | |
| profile_posts | ProfilePost[] | List of profile posts on the requested page |
| pagination | pagination | Pagination details |

---

## POST users/{id}/

Updates an existing user.

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
| option[is_discouraged] | bool | |
| username | string | |
| email | string | |
| user_group_id | integer | |
| secondary_group_ids | integer[] | |
| user_state | string | |
| is_staff | bool | |
| message_count | integer | |
| reaction_score | integer | |
| trophy_points | integer | |
| username_change_visible | bool | If true and the username is changed, the change will be visible (shown in the public list of previous usernames). |
| password | string | |
| dob[day] | integer | |
| dob[month] | integer | |
| dob[year] | integer | |
| custom_fields[&lt;name&gt;] | string | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| user | User | |

---

## DELETE users/{id}/

Deletes the specified user

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| rename_to | string | If specified, the user will be renamed before deletion |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

---

## POST users/{id}/avatar

Updates the specified user's avatar

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| avatar | file | **Required** The uploaded new avatar |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

---

## DELETE users/{id}/avatar

Deletes the specified user's avatar

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| None. | | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

---

## GET users/{id}/profile-posts

Gets a page of profile posts on the specified user's profile.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| page | integer | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| profile_posts | ProfilePost[] | List of profile posts on the requested page |
| pagination | pagination | Pagination details |
### Data type: Conversation

| Column | Type | Description |
|--------|------|--------------|
| username | string | Name of the user that started the conversation |
| recipients | object | Key-value pair of recipient user IDs and names |
| is_starred | bool | True if the viewing user starred the conversation |
| is_unread | bool | If accessing as a user, true if this conversation is unread |
| can_edit | bool |  |
| can_reply | bool |  |
| can_invite | bool |  |
| can_upload_attachment | bool |  |
| view_url | string |  |
| conversation_id | integer |  |
| title | string |  |
| user_id | integer |  |
| start_date | integer |  |
| open_invite | bool |  |
| conversation_open | bool |  |
| reply_count | integer |  |
| recipient_count | integer |  |
| first_message_id | integer |  |
| last_message_date | integer |  |
| last_message_id | integer |  |
| last_message_user_id | integer |  |
| Starter | User |  |
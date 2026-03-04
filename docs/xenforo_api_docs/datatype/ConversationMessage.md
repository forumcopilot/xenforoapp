### Data type: ConversationMessage

| Column | Type | Description |
|--------|------|--------------|
| username | string |  |
| is_unread | bool | If accessing as a user, true if this conversation message is unread |
| message_parsed | string | HTML parsed version of the message contents. |
| can_edit | bool |  |
| can_react | bool |  |
| view_url | string |  |
| Conversation | Conversation | If requested by context, the conversation this message is part of. |
| Attachments | Attachment[] | If there are attachments to this message, a list of attachments. |
| is_reacted_to | bool | True if the viewing user has reacted to this content |
| visitor_reaction_id | integer | If the viewer reacted, the ID of the reaction they used |
| message_id | integer |  |
| conversation_id | integer |  |
| message_date | integer |  |
| user_id | integer |  |
| message | string |  |
| attach_count | integer |  |
| reaction_score | integer |  |
| User | User |  |
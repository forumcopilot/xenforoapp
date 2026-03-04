### Data type: ProfilePostComment

| Column | Type | Description |
|--------|------|--------------|
| username | string |  |
| message_parsed | string | HTML parsed version of the message contents. |
| can_edit | bool |  |
| can_soft_delete | bool |  |
| can_hard_delete | bool |  |
| can_react | bool |  |
| can_view_attachments | bool |  |
| Attachments | Attachment[] | Attachments to this profile post, if it has any. |
| ProfilePost | ProfilePost | If requested by context, the profile post this comment relates to. |
| is_reacted_to | bool | True if the viewing user has reacted to this content |
| visitor_reaction_id | integer | If the viewer reacted, the ID of the reaction they used |
| profile_post_comment_id | integer |  |
| profile_post_id | integer |  |
| user_id | integer |  |
| comment_date | integer |  |
| message | string |  |
| message_state | string |  |
| warning_message | string |  |
| reaction_score | integer |  |
| User | User |  |
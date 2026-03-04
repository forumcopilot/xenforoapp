### Data type: ProfilePost

| Column | Type | Description |
|--------|------|--------------|
| username | string |  |
| message_parsed | string | HTML parsed version of the message contents. |
| can_edit | bool |  |
| can_soft_delete | bool |  |
| can_hard_delete | bool |  |
| can_react | bool |  |
| can_view_attachments | bool |  |
| view_url | string |  |
| ProfileUser | User | If requested by context, the user this profile post was left for. |
| Attachments | Attachment[] | Attachments to this profile post, if it has any. |
| LatestComments | ProfilePostComment[] | If requested, the most recent comments on this profile post. |
| is_reacted_to | bool | True if the viewing user has reacted to this content |
| visitor_reaction_id | integer | If the viewer reacted, the ID of the reaction they used |
| profile_post_id | integer |  |
| profile_user_id | integer |  |
| user_id | integer |  |
| post_date | integer |  |
| message | string |  |
| message_state | string |  |
| warning_message | string |  |
| comment_count | integer |  |
| first_comment_date | integer |  |
| last_comment_date | integer |  |
| reaction_score | integer |  |
| User | User |  |
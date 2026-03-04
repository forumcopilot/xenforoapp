### Data type: Post

| Column | Type | Description |
|--------|------|--------------|
| username | string |  |
| is_first_post | bool |  |
| is_last_post | bool |  |
| is_unread | bool | If accessing as a user, true if this post is unread |
| message_parsed | string | HTML parsed version of the message contents. |
| can_edit | bool |  |
| can_soft_delete | bool |  |
| can_hard_delete | bool |  |
| can_react | bool |  |
| can_view_attachments | bool |  |
| view_url | string |  |
| Thread | Thread | If requested by context, the thread this post is part of. |
| Attachments | Attachment[] | Attachments to this post, if it has any. |
| is_reacted_to | bool | True if the viewing user has reacted to this content |
| visitor_reaction_id | integer | If the viewer reacted, the ID of the reaction they used |
| vote_score | integer | The content's vote score (if supported) |
| can_content_vote | bool | True if the viewing user can vote on this content |
| allowed_content_vote_types | string[] | List of content vote types allowed on this content |
| is_content_voted | bool | True if the viewing user has voted on this content |
| visitor_content_vote | string | If the viewer reacted, the vote they case (up/down) |
| post_id | integer |  |
| thread_id | integer |  |
| user_id | integer |  |
| post_date | integer |  |
| message | string |  |
| message_state | string |  |
| attach_count | integer |  |
| warning_message | string |  |
| position | integer |  |
| last_edit_date | integer |  |
| reaction_score | integer |  |
| User | User |  |
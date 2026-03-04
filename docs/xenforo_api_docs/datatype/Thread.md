### Data type: Thread
| Column | Type | Description |
|--------|------|--------------|
| username | string |  |
| is_watching | bool | If accessing as a user, true if they are watching this thread |
| visitor_post_count | integer | If accessing as a user, the number of posts they have made in this thread |
| is_unread | bool | If accessing as a user, true if this thread is unread |
| custom_fields | object | Key-value pairs of custom field values for this thread |
| tags | array |  |
| prefix | string | Present if this thread has a prefix. Printable name of the prefix. |
| can_edit | bool |  |
| can_edit_tags | bool |  |
| can_reply | bool |  |
| can_soft_delete | bool |  |
| can_hard_delete | bool |  |
| can_view_attachments | bool |  |
| view_url | string |  |
| is_first_post_pinned | bool |  |
| highlighted_post_ids | array |  |
| is_search_engine_indexable | bool |  |
| index_state | string | Present for members with permission to change the search index state of this thread. |
| Forum | Node | If requested by context, the forum this thread was posted in. |
| vote_score | integer | The content's vote score (if supported) |
| can_content_vote | bool | True if the viewing user can vote on this content |
| allowed_content_vote_types | string[] | List of content vote types allowed on this content |
| is_content_voted | bool | True if the viewing user has voted on this content |
| visitor_content_vote | string | If the viewer reacted, the vote they case (up/down) |
| thread_id | integer |  |
| node_id | integer |  |
| title | string |  |
| reply_count | integer |  |
| view_count | integer |  |
| user_id | integer |  |
| post_date | integer |  |
| sticky | bool |  |
| discussion_state | string |  |
| discussion_open | bool |  |
| discussion_type | string |  |
| first_post_id | integer |  |
| last_post_date | integer |  |
| last_post_id | integer |  |
| last_post_user_id | integer |  |
| last_post_username | string |  |
| first_post_reaction_score | integer |  |
| prefix_id | integer |  |
| User | User |  |
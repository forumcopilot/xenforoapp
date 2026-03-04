### GET alerts/

Gets the API user's list of alerts

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |
| cutoff | integer | Unix timestamp of oldest alert to include. Note that unread or unviewed alerts are always included. |
| unviewed | bool | If true, gets only unviewed alerts. Unviewed alerts have not been seen (in the standard UI). |
| unread | bool | If true, gets only unread alerts. Unread alerts may have been seen but the content they relate to has not been viewed. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| alerts | UserAlert[] |     |
| pagination | pagination |     |

### POST alerts/

Sends an alert to the specified user. Only available to super user keys.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| to_user_id | integer | ID of the user to receive the alert |
| alert | string | Text of the alert. May use the placeholder "{link}" to have the link automatically inserted. |
| from_user_id | integer | If provided, the user to send the alert from. Otherwise, uses the current API user. May be 0 for an anonymous alert. |
| link_url | string | URL user will be taken to when the alert is clicked. |
| link_title | string | Text of the link URL that will be displayed. If no placeholder is present in the alert, will be automatically appended. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST alerts/mark-all

Marks all of the API user's alerts as read or viewed. Must specify "read" or "viewed" parameters.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| read | bool | If specified, marks all alerts as read. |
| viewed | bool | If specified, marks all alerts as viewed. This will remove the alert counter but keep unactioned alerts highlighted. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### GET alerts/{id}/

Gets information about the specified alert

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| alert | UserAlert |     |

### POST alerts/{id}/mark

Marks the alert as viewed/read/unread. (Marking as unviewed is not supported.)

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| read | bool | If specified, marks the alert as read. |
| unread | bool | If specified, marks the alert as unread. |
| viewed | bool | If specified, marks all alerts as viewed. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### GET attachments/

Gets the attachments associated with the provided API attachment key. Only returns attachments that have not been associated with content.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| key | string | The API attachment key |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| attachments | [Attachment](#type_Attachment)[] | List of matching attachments. |

### POST attachments/

Uploads an attachment. An API attachment key must be created first. Must be submitted using multipart/form-data encoding.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| key | string | The API attachment key to associated with |
| attachment | file | The attachment file |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| attachment | [Attachment](#type_Attachment) | The attachment record of the successful upload |

#### Errors

| Error key | Description |
| --- | --- |
| attachment_key_user_wrong | Triggered if the user making the request does not match the user that created the attachment key. |

### POST attachments/new-key

Creates a new attachment key, allowing attachments to be uploaded separately from the related content.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| type | string | The content type of the attachment. Default types include post, conversation_message. Add-ons may add more. |
| context | string[] | Key-value pairs representing the context of the attachment. This will vary depending on content type and the action being taken. See relevant actions for further details. |
| attachment | file | The first attachment to be associated with the new key. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| key | string | The attachment key created. This should be used to upload additional files or to associate uploaded attachments with other content. |
| attachment | [Attachment](#type_Attachment) | If a file was provided and the upload was successful, this will describe the new attachment. |

### GET attachments/{id}/

Gets information about the specified attachment.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| attachment | [Attachment](#type_Attachment) |     |

### DELETE attachments/{id}/

Delete's the specified attachment.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### GET attachments/{id}/data

Gets the data that makes up the specified attachment. The output is the raw binary data.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| data | binary | The binary data is output directly, not JSON. |

### GET attachments/{id}/thumbnail

Gets the URL to the attachment's thumbnail, if it has one. URL returned via a 301 redirect.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| url | string | The URL to the thumbnail is returned via a 301 redirect's Location header. |

#### Errors

| Error key | Description |
| --- | --- |
| not_found | Not found if the attachment does not have a thumbnail |

### POST auth/

Tests a login and password for validity. Only available to super user keys. We strongly recommend the login and password parameters are passed into the request body rather than the query string.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| login | string | The username or email address of the user to test |
| password | string | The password of the user |
| limit_ip | string | The IP that should be considered to be making the request. If provided, this will be used to prevent brute force attempts. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| user | [User](#type_User) | If successful, the user record of the matching user |

### POST auth/from-session

Looks up the active XenForo user based on session ID or remember cookie value. This can be used to help with seamless SSO with XF, assuming the session or remember cookies are available to your page. At least one of session_id and remember_cookie must be provided. Only available to super user keys.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| session_id | string | If provided, checks for an active session with that ID. |
| remember_cookie | string | If provided, checks to see if this is an active "remember me" cookie value. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | bool | If false, no session or remember cookie could be found |
| user | [User](#type_User) | If successful, the user record of the matching user. May be a guest. |

### POST auth/login-token

Generates a token that can automatically log into a specific XenForo user when the login URL is visited. If the visitor is already logged into a XenForo account, they will not be logged into the specified account. Only available to super user keys.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| user_id | integer |     |
| limit_ip | string | If provided, locks the token to the specified IP for additional security |
| return_url | string | If provided, after logging the user will be returned to this URL. Otherwise they'll go to the XenForo index. |
| force | bool | If provided, the login URL will forcibly replace the currently logged in user if a user is already logged in and different to the currently logged in user. Defaults to false. |
| remember | bool | Controls whether the a "remember me" cookie will be set when the user logs in. Defaults to true. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| login_token | string |     |
| login_url | string | Direct user to this URL to trigger a login |
| expiry_date | integer | Unix timestamp of when the token expires. An error will be displayed if the token is expired or invalid |

### POST conversation-messages/

Replies to a conversation

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| conversation_id | integer |     |
| message | string |     |
| attachment_key | string | API attachment key to upload files. Attachment key content type must be conversation_message with context[conversation_id] set to this conversation ID. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| message | [ConversationMessage](#type_ConversationMessage) | The newly inserted message |

### GET conversation-messages/{id}/

Gets the specified conversation message.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| message | [ConversationMessage](#type_ConversationMessage) |     |

### POST conversation-messages/{id}/

Updates the specified conversation message.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| message | string | The new message content |
| attachment_key | string | API attachment key to upload files. Attachment key content type must be conversation_message with context[message_id] set to this message ID. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| message | [ConversationMessage](#type_ConversationMessage) |     |

### POST conversation-messages/{id}/react

Reacts to the specified conversation message

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| reaction_id | integer | ID of the reaction to use. Use the current reaction ID to undo. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

### GET conversations/

Gets the API user's list of conversations.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |
| starter_id | integer |     |
| receiver_id | integer |     |
| starred | bool | Only gets starred conversations if specified |
| unread | bool | Only gets unread conversations if specified |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| conversations | [Conversation](#type_Conversation)[] |     |
| pagination | pagination |     |

### POST conversations/

Creates a conversation

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| recipient_ids | integer[] | List of user IDs to send the conversation to |
| title | string | Conversation title |
| message | string | Conversation message body |
| attachment_key | string | API attachment key to upload files. Attachment key content type must be conversation_message with no context. |
| conversation_open | bool | If false, no replies may be made to this conversation. |
| open_invite | bool | If true, any member of the conversation may add others |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| conversation | [Conversation](#type_Conversation) |     |

### GET conversations/{id}/

Gets information about the specified conversation.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| with_messages | bool | If specified, the response will include a page of messages. |
| page | integer | The page of messages to include |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| conversation | [Conversation](#type_Conversation) |     |
| messages | [ConversationMessage](#type_ConversationMessage)[] | List of messages on the requested page |
| pagination | pagination | Pagination details |

### POST conversations/{id}/

Updates the specified conversation

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| title | string | Conversation title |
| open_invite | bool | If true, any member of the conversation can add others |
| conversation_open | bool | If false, no further replies are allowed. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| conversation | [Conversation](#type_Conversation) |     |

### DELETE conversations/{id}/

Deletes the specified conversation from the API user's list. Does not delete the conversation for other receivers.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| ignore | bool | If true, further replies to this conversation will be ignored. (Otherwise, replies will restore this conversation to the list.) |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST conversations/{id}/invite

Invites the specified users to this conversation.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| recipient_ids | integer[] | List of user IDs to invite |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST conversations/{id}/mark-read

Marks the conversation as read up until the specified time. This cannot move the

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| date | integer | Unix timestamp to mark the conversation read to. If not specified, defaults to the current time. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST conversations/{id}/mark-unread

Marks a conversation as unread. This will mark all messages in the conversation as unread.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### GET conversations/{id}/messages

Gets a page of messages in the specified conversation.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| messages | [ConversationMessage](#type_ConversationMessage)[] | List of messages on the requested page |
| pagination | pagination | Pagination details |

### POST conversations/{id}/star

Sets the star status of the specified conversation

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| star | bool | If provided, sets the star status as specified. If not provided, toggles the status. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### GET forums/{id}/

Gets information about the specified forum

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| with_threads | bool | If true, gets a page of threads in this forum |
| page | integer |     |
| prefix_id | integer | Filters to only threads with the specified prefix. |
| starter_id | integer | Filters to only threads started by the specified user ID. |
| last_days | integer | Filters to threads that have had a reply in the last X days. |
| unread | bool | Filters to unread threads only. Ignored for guests. |
| thread_type | string | Filters to threads of the specified thread type. |
| order | string | Method of ordering: last_post_date, post_date. When in a specific forum context: title, reply_count, view_count, vote_score, first_post_reaction_score. |
| direction | string | Either "asc" or "desc" for ascending or descending. Applies only if an order is provided. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| forum | [Forum](#type_Forum) |     |
| threads | [Thread](#type_Thread)[] | Threads on this page |
| pagination | pagination | Pagination information |
| sticky | [Thread](#type_Thread)[] | If on page 1, a list of sticky threads in this forum. Does not count towards the per page limit. |

### POST forums/{id}/mark-read

Marks the forum as read up until the specified time. This cannot mark a forum as unread or

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| date | integer | Unix timestamp to mark the forum read to. If not specified, defaults to the current time. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### GET forums/{id}/threads

Gets a page of threads from the specified forum.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |
| prefix_id | integer | Filters to only threads with the specified prefix. |
| starter_id | integer | Filters to only threads started by the specified user ID. |
| last_days | integer | Filters to threads that have had a reply in the last X days. |
| unread | bool | Filters to unread threads only. Ignored for guests. |
| thread_type | string | Filters to threads of the specified thread type. |
| order | string | Method of ordering: last_post_date, post_date. When in a specific forum context: title, reply_count, view_count, vote_score, first_post_reaction_score. |
| direction | string | Either "asc" or "desc" for ascending or descending. Applies only if an order is provided. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| threads | [Thread](#type_Thread)[] | Threads on this page |
| pagination | pagination | Pagination information |
| sticky | [Thread](#type_Thread)[] | If on page 1, a list of sticky threads in this forum. Does not count towards the per page limit. |

### GET index/

Gets general information about the site and the API

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| version_id | integer | XenForo version ID |
| site_title | string | Title of the site this API relates to |
| base_url | string | The base URL of the XenForo install this API relates to |
| api_url | string | The base API URL |
| key[type] | string | Type of the API key accessing the API (guest, user or super) |
| key[user_id] | integer\|null | If a user key, the ID of the user the key is for; null otherwise |
| key[allow_all_scopes] | bool | If true, all scopes can be accessed |
| key[scopes] | string[] | A list of scopes this key can access (if not allowed to access all scopes) |

### GET me/

Gets information about the current API user

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| me  | [User](#type_User) |     |

### POST me/

Updates information about the current user

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| option[creation_watch_state] | string |     |
| option[interaction_watch_state] | string |     |
| option[content_show_signature] | bool |     |
| option[email_on_conversation] | bool |     |
| option[push_on_conversation] | bool |     |
| option[receive_admin_email] | bool |     |
| option[show_dob_year] | bool |     |
| option[show_dob_date] | bool |     |
| profile[location] | string |     |
| profile[website] | string |     |
| profile[about] | string |     |
| profile[signature] | string |     |
| privacy[allow_view_profile] | string |     |
| privacy[allow_post_profile] | string |     |
| privacy[allow_receive_news_feed] | string |     |
| privacy[allow_send_personal_conversation] | string |     |
| privacy[allow_view_identities] | string |     |
| visible | bool |     |
| activity_visible | bool |     |
| timezone | string |     |
| custom_title | string |     |
| custom_fields[<name>] | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST me/avatar

Updates the current user's avatar

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| avatar | file | The uploaded new avatar |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### DELETE me/avatar

Deletes the current user's avatar

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST me/email

Updates the current user's email address

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| current_password | string |     |
| email | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| confirmation_required | bool | True if email confirmation is required for this change |

### POST me/password

Updates the current user's password

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| current_password | string |     |
| new_password | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### GET nodes/

Gets the node tree.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| tree_map | array | A mapping that connects node parent IDs to a list of their child node IDs |
| nodes | [Node](#type_Node)[] | List of all nodes |

### POST nodes/

Creates a new node

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| node[title] | string |     |
| node[node_name] | string |     |
| node[description] | string |     |
| node[parent_node_id] | integer |     |
| node[display_order] | integer |     |
| node[display_in_list] | bool |     |
| type_data | array | Type-specific node data. The available options will vary based on the node type involved. |
| node_type_id | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| node | [Node](#type_Node) | Information about the created node |

### GET nodes/flattened

Gets a flattened node tree. Traversing this will return a list of nodes in the expected order.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| nodes_flat | array | An array. Each entry contains keys of "node" and "depth" |

### GET nodes/{id}/

Gets information about the specified node

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| node | [Node](#type_Node) |     |

### POST nodes/{id}/

Updates the specified node

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| node[title] | string |     |
| node[node_name] | string |     |
| node[description] | string |     |
| node[parent_node_id] | integer |     |
| node[display_order] | integer |     |
| node[display_in_list] | bool |     |
| type_data | array | Type-specific node data. The available options will vary based on the node type involved. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| node | [Node](#type_Node) | The updated node information |

### DELETE nodes/{id}/

Deletes the specified node

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| delete_children | bool | If true, child nodes will be deleted. Otherwise, they will be connected to this node's parent. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST posts/

Adds a new reply to a thread.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| thread_id | integer | ID of the thread to reply to. |
| message | string |     |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be post with context[thread_id] set to this thread ID. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| post | [Post](#type_Post) |     |

### GET posts/{id}/

Gets information about the specified post

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| post | [Post](#type_Post) |     |

### POST posts/{id}/

Updates the specified post

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| message | string |     |
| silent | bool | If true and permissions allow, this edit will not be updated with a "last edited" indication |
| clear_edit | bool | If true and permissions allow, any "last edited" indication will be removed. Requires "silent". |
| author_alert | bool |     |
| author_alert_reason | string |     |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be post with context[post_id] set to this post ID. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| post | [Post](#type_Post) |     |

### DELETE posts/{id}/

Deletes the specified post. Default to soft deletion.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| hard_delete | bool |     |
| reason | string |     |
| author_alert | bool |     |
| author_alert_reason | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST posts/{id}/mark-solution

Toggle the specified post as the solution to its containing thread. If a post is marked as a solution when another is already marked, the existing solution will be unmarked.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| true | mixed | Success |
| new_solution_post | [Post](#type_Post)\|null | A post that was marked as the solution |
| old_solution_post | [Post](#type_Post)\|null | A post that was un-marked as the solution |

### POST posts/{id}/react

Reacts to the specified post

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| reaction_id | integer | ID of the reaction to use. Use the current reaction ID to undo. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

### POST posts/{id}/vote

Votes on the specified post (if applicable)

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| type | string | Type of vote, "up" or "down". Use the current type to undo. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

### POST profile-post-comments/

Creates a new profile post comment.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| profile_post_id | integer | The ID of the profile post this comment will be attached to. |
| message | string |     |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be profile_post_comment with context[profile_post_id] set to this profile post ID. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| comment | [ProfilePostComment](#type_ProfilePostComment) |     |

### GET profile-post-comments/{id}/

Gets information about the specified profile post comment.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| comment | [ProfilePostComment](#type_ProfilePostComment) |     |

### POST profile-post-comments/{id}/

Updates the specified profile post comment.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| message | string |     |
| author_alert | bool |     |
| author_alert_reason | string |     |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be profile_post_comment with context[profile_post_comment_id] set to this profile post comment ID. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| comment | [ProfilePostComment](#type_ProfilePostComment) |     |

### DELETE profile-post-comments/{id}/

Deletes the specified profile post comment. Default to soft deletion.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| hard_delete | bool |     |
| reason | string |     |
| author_alert | bool |     |
| author_alert_reason | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST profile-post-comments/{id}/react

Reacts to the specified profile post comment

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| reaction_id | integer | ID of the reaction to use. Use the current reaction ID to undo. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

### POST profile-posts/

Creates a new profile post.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| user_id | integer | The ID of the user whose profile this will be posted on. |
| message | string |     |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be profile_post with context[profile_user_id] set to this user ID. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| profile_post | [ProfilePost](#type_ProfilePost) |     |

### GET profile-posts/{id}/

Gets information about the specified profile post.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| with_comments | bool | If specified, the response will include a page of comments. |
| page | integer | The page of comments to include |
| direction | string | Request a particular sort order for comments - default 'desc' (newest first) also allows 'asc' (oldest first) |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| profile_post | [ProfilePost](#type_ProfilePost) |     |
| comments | [ProfilePostComment](#type_ProfilePostComment)[] | List of comments on the requested page |
| pagination | pagination | Pagination details |

### POST profile-posts/{id}/

Updates the specified profile post.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| message | string |     |
| author_alert | bool |     |
| author_alert_reason | string |     |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be profile_post with context[profile_post_id] set to this profile post ID. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| profile_post | [ProfilePost](#type_ProfilePost) |     |

### DELETE profile-posts/{id}/

Deletes the specified profile post. Default to soft deletion.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| hard_delete | bool |     |
| reason | string |     |
| author_alert | bool |     |
| author_alert_reason | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### GET profile-posts/{id}/comments

Gets a page of comments on the specified profile post.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |
| direction | string | Request a particular sort order for comments - default 'desc' (newest first) also allows 'asc' (oldest first) |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| comments | [ProfilePostComment](#type_ProfilePostComment)[] | List of comments on the requested page |
| pagination | pagination | Pagination details |

### POST profile-posts/{id}/react

Reacts to the specified profile post

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| reaction_id | integer | ID of the reaction to use. Use the current reaction ID to undo. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

### POST search/

Creates a new search

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| search_type | string |     |
| keywords | string |     |
| c   | array |     |
| order | string |     |
| grouped | bool |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| search | [Search](#type_Search) |     |

### POST search/member

Retrieves search results for a specific member

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| user_id | integer |     |
| content | string |     |
| type | string |     |
| before | integer |     |
| thread_type | string |     |
| grouped | bool |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| search | [Search](#type_Search) |     |

### GET search/{id}/

Retrieves search results for a given search

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| search | [Search](#type_Search) |     |
| results | array |     |
| pagination | pagination |     |
| get_older_results_date | integer\|null |     |

### POST search/{id}/older

Retrieves older search results for a given search

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| search_id | integer |     |
| before | integer |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| search | [Search](#type_Search) |     |

### GET search-forums/{id}/

Gets information about the specified search forum

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| with_threads | bool | If true, gets a page of threads in this search forum |
| page | integer |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| search_forum | SearchForum |     |
| threads | [Thread](#type_Thread)[] | Threads on this page. Note: this will always respect viewing user permissions regardless of whether the API is set to bypass permissions. |
| pagination | pagination | Pagination information |
| sticky | [Thread](#type_Thread)[] | If on page 1, a list of sticky threads in this forum. Does not count towards the per page limit. |

### GET search-forums/{id}/threads

Gets a page of threads from the specified search forum.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| threads | [Thread](#type_Thread)[] | Threads on this page. Note: this will always respect viewing user permissions regardless of whether the API is set to bypass permissions. |
| pagination | pagination | Pagination information |
| sticky | [Thread](#type_Thread)[] | If on page 1, a list of sticky threads in this forum. Does not count towards the per page limit. |

### GET stats/

Gets site statistics and general activity information

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| totals[threads] | integer |     |
| totals[messages] | integer |     |
| totals[users] | integer |     |
| latest_user[user_id] | integer |     |
| latest_user[username] | string |     |
| latest_user[register_date] | integer |     |
| online[total] | integer |     |
| online[members] | integer |     |
| online[guests] | integer |     |

### GET threads/

Gets a list of threads

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |
| prefix_id | integer | Filters to only threads with the specified prefix. |
| starter_id | integer | Filters to only threads started by the specified user ID. |
| last_days | integer | Filters to threads that have had a reply in the last X days. |
| unread | bool | Filters to unread threads only. Ignored for guests. |
| thread_type | string | Filters to threads of the specified thread type. |
| order | string | Method of ordering: last_post_date, post_date. When in a specific forum context: title, reply_count, view_count, vote_score, first_post_reaction_score. |
| direction | string | Either "asc" or "desc" for ascending or descending. Applies only if an order is provided. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| threads | [Thread](#type_Thread)[] |     |
| pagination | pagination |     |

### POST threads/

Creates a thread. Thread type data can be set using additional input specific to the target thread type.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| node_id | integer | ID of the forum to create the thread in. |
| title | string | Title of the thread. |
| message | string | Body of the first post in the thread. |
| discussion_type | string | The type of thread to create. Specific types may require additional input. |
| prefix_id | integer | ID of the prefix to apply to the thread. If not valid in the selected forum, will be ignored. |
| tags | string[] | Array of tag names to apply to the thread. |
| custom_fields[<name>] | string | Value to apply to the custom field with the specified name. |
| discussion_open | bool |     |
| sticky | bool |     |
| attachment_key | string | API attachment key to upload files. Attachment key context type must be post with context[node_id] set to the ID of the forum this is being posted in. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| thread | [Thread](#type_Thread) |     |

#### Errors

| Error key | Description |
| --- | --- |
| no_permission | No permission error. |

### GET threads/{id}/

Gets information about the specified thread.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| with_posts | bool | If specified, the response will include a page of posts. |
| page | integer | The page of posts to include |
| with_first_post | bool | If specified, the response will contain the first post in the thread. |
| with_last_post | bool | If specified, the response will contain the last post in the thread. |
| order | string | Request a particular sort order for posts from the available options for the thread type |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| thread | [Thread](#type_Thread) |     |
| first_unread | [Post](#type_Post) | If the thread is unread, information about the first unread post. |
| first_post | [Post](#type_Post) | If requested, information about the first post in the thread. |
| last_post | [Post](#type_Post) | If requested, information about the last post in the thread. |
| pinned_post | [Post](#type_Post) | The pinned first post of the thread, if specified by the thread type. |
| highlighted_posts | [Post](#type_Post)[] | A list of highlighted posts, if relevant to the thread type. The reason for highlighting depends on thread type. |
| posts | [Post](#type_Post)[] | List of posts on the requested page. Note that even if the first post is pinned, it will be included here. |
| pagination | pagination | Pagination details |

### POST threads/{id}/

Updates the specified thread

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| prefix_id | integer |     |
| title | string |     |
| discussion_open | bool |     |
| sticky | bool |     |
| custom_fields[<name>] | string |     |
| add_tags | array |     |
| remove_tags | array |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| thread | [Thread](#type_Thread) |     |

### DELETE threads/{id}/

Deletes the specified thread. Default to soft deletion.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| hard_delete | bool |     |
| reason | string |     |
| starter_alert | bool |     |
| starter_alert_reason | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST threads/{id}/change-type

Converts a thread to the specified type. Additional thread type data can be set using input specific to the new thread type.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| new_thread_type_id | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| thread | [Thread](#type_Thread) |     |

### POST threads/{id}/mark-read

Marks the thread as read up until the specified time. This cannot mark a thread as unread or

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| date | integer | Unix timestamp to mark the thread read to. If not specified, defaults to the current time. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST threads/{id}/move

Moves the specified thread to a different forum. Only simple title/prefix updates are supported at the same time

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| target_node_id | integer |     |
| prefix_id | integer | If set, will update the thread's prefix. Prefix must be valid in the target forum. |
| title | string | If set, updates the thread's title |
| notify_watchers | bool | If true, users watching the target forum will receive a notification as if this thread were created in the target forum |
| starter_alert | bool | If true, the thread starter will receive an alert notifying them of the move |
| starter_alert_reason | bool | The reason for the move to include with the thread starter alert |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| thread | [Thread](#type_Thread) |     |

### GET threads/{id}/posts

Gets a page of posts in the specified conversation.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |
| order | string | Request a particular sort order for posts from the available options for the thread type |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| pinned_post | [Post](#type_Post) | The pinned first post of the thread, if specified by the thread type. |
| highlighted_posts | [Post](#type_Post)[] | A list of highlighted posts, if relevant to the thread type. The reason for highlighting depends on thread type. |
| posts | [Post](#type_Post)[] | List of posts on the requested page. Note that even if the first post is pinned, it will be included here. |
| pagination | pagination | Pagination details |

### POST threads/{id}/vote

Votes on the specified thread (if applicable)

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| type | string | Type of vote, "up" or "down". Use the current type to undo. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

### GET users/

Gets a list of users (alphabetically)

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| users | [User](#type_User)[] |     |
| pagination | pagination |     |

### POST users/

Creates a user.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| option[creation_watch_state] | string |     |
| option[interaction_watch_state] | string |     |
| option[content_show_signature] | bool |     |
| option[email_on_conversation] | bool |     |
| option[push_on_conversation] | bool |     |
| option[receive_admin_email] | bool |     |
| option[show_dob_year] | bool |     |
| option[show_dob_date] | bool |     |
| profile[location] | string |     |
| profile[website] | string |     |
| profile[about] | string |     |
| profile[signature] | string |     |
| privacy[allow_view_profile] | string |     |
| privacy[allow_post_profile] | string |     |
| privacy[allow_receive_news_feed] | string |     |
| privacy[allow_send_personal_conversation] | string |     |
| privacy[allow_view_identities] | string |     |
| visible | bool |     |
| activity_visible | bool |     |
| timezone | string |     |
| custom_title | string |     |
| option[is_discouraged] | bool |     |
| username | string |     |
| email | string |     |
| user_group_id | integer |     |
| secondary_group_ids | integer[] |     |
| user_state | string |     |
| is_staff | bool |     |
| message_count | integer |     |
| reaction_score | integer |     |
| trophy_points | integer |     |
| username_change_visible | bool | If true and the username is changed, the change will be visible (shown in the public list of previous usernames). |
| password | string |     |
| dob[day] | integer |     |
| dob[month] | integer |     |
| dob[year] | integer |     |
| custom_fields[<name>] | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| user | [User](#type_User) |     |

### GET users/find-email

Finds users by their email. Only available to admin users (or when bypassing permissions).

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| email | string | [required] |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| user | [User](#type_User)\|null | The user that matched the given email exactly |

### GET users/find-name

Finds users by a prefix of their user name.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| username | string | [required] |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| exact | [User](#type_User)\|null | The user that matched the given username exactly |
| recommendations | [User](#type_User)[] | A list of users that match the prefix of the username (but not exactly) |

### GET users/{id}/

Gets information about the specified user.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| with_posts | bool | If specified, the response will include a page of profile posts. |
| page | integer | The page of comments to include |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| user | [User](#type_User) |     |
| profile_posts | [ProfilePost](#type_ProfilePost)[] | List of profile posts on the requested page |
| pagination | pagination | Pagination details |

### POST users/{id}/

Updates an existing user.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| option[creation_watch_state] | string |     |
| option[interaction_watch_state] | string |     |
| option[content_show_signature] | bool |     |
| option[email_on_conversation] | bool |     |
| option[push_on_conversation] | bool |     |
| option[receive_admin_email] | bool |     |
| option[show_dob_year] | bool |     |
| option[show_dob_date] | bool |     |
| profile[location] | string |     |
| profile[website] | string |     |
| profile[about] | string |     |
| profile[signature] | string |     |
| privacy[allow_view_profile] | string |     |
| privacy[allow_post_profile] | string |     |
| privacy[allow_receive_news_feed] | string |     |
| privacy[allow_send_personal_conversation] | string |     |
| privacy[allow_view_identities] | string |     |
| visible | bool |     |
| activity_visible | bool |     |
| timezone | string |     |
| custom_title | string |     |
| option[is_discouraged] | bool |     |
| username | string |     |
| email | string |     |
| user_group_id | integer |     |
| secondary_group_ids | integer[] |     |
| user_state | string |     |
| is_staff | bool |     |
| message_count | integer |     |
| reaction_score | integer |     |
| trophy_points | integer |     |
| username_change_visible | bool | If true and the username is changed, the change will be visible (shown in the public list of previous usernames). |
| password | string |     |
| dob[day] | integer |     |
| dob[month] | integer |     |
| dob[year] | integer |     |
| custom_fields[<name>] | string |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |
| user | [User](#type_User) |     |

### DELETE users/{id}/

Deletes the specified user

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| rename_to | string | If specified, the user will be renamed before deletion |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### POST users/{id}/avatar

Updates the specified user's avatar

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| avatar | file | The uploaded new avatar |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### DELETE users/{id}/avatar

Deletes the specified user's avatar

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| None. |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| success | true |     |

### GET users/{id}/profile-posts

Gets a page of profile posts on the specified user's profile.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| page | integer |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| profile_posts | [ProfilePost](#type_ProfilePost)[] | List of profile posts on the requested page |
| pagination | pagination | Pagination details |

### POST oauth2/revoke

Revokes an access token or refresh token.

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| client_id | string |     |
| client_secret | string |     |
| token | string |     |
| token_type_hint | string | Defaults to 'access_token' but can be 'refresh_token' to revoke a refresh token. |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| None. |     |     |

### GET oauth2/token

[Incomplete]

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| Unknown, documentation incomplete |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| Unknown, documentation incomplete |     |     |

### POST oauth2/token

[Incomplete]

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| Unknown, documentation incomplete |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| Unknown, documentation incomplete |     |     |

### GET oembed/

[Incomplete]

#### Parameters

| Input | Type | Description |
| --- | --- | --- |
| Unknown, documentation incomplete |     |     |

#### Response

| Output | Type | Description |
| --- | --- | --- |
| Unknown, documentation incomplete |     |     |

### Data type: Attachment

| Column | Type | Description |
| --- | --- | --- |
| filename | string |     |
| file_size | integer |     |
| height | integer |     |
| width | integer |     |
| thumbnail_url | string |     |
| direct_url | string |     |
| is_video | bool |     |
| is_audio | bool |     |
| attachment_id | integer |     |
| content_type | string |     |
| content_id | integer |     |
| attach_date | integer |     |
| view_count | integer |     |

### Data type: Conversation

| Column | Type | Description |
| --- | --- | --- |
| username | string | Name of the user that started the conversation |
| recipients | object | Key-value pair of recipient user IDs and names |
| is_starred | bool | True if the viewing user starred the conversation |
| is_unread | bool | If accessing as a user, true if this conversation is unread |
| can_edit | bool |     |
| can_reply | bool |     |
| can_invite | bool |     |
| can_upload_attachment | bool |     |
| view_url | string |     |
| conversation_id | integer |     |
| title | string |     |
| user_id | integer |     |
| start_date | integer |     |
| open_invite | bool |     |
| conversation_open | bool |     |
| reply_count | integer |     |
| recipient_count | integer |     |
| first_message_id | integer |     |
| last_message_date | integer |     |
| last_message_id | integer |     |
| last_message_user_id | integer |     |
| Starter | [User](#type_User) |     |

### Data type: ConversationMessage

| Column | Type | Description |
| --- | --- | --- |
| username | string |     |
| is_unread | bool | If accessing as a user, true if this conversation message is unread |
| message_parsed | string | HTML parsed version of the message contents. |
| can_edit | bool |     |
| can_react | bool |     |
| view_url | string |     |
| Conversation | [Conversation](#type_Conversation) | If requested by context, the conversation this message is part of. |
| Attachments | [Attachment](#type_Attachment)[] | If there are attachments to this message, a list of attachments. |
| is_reacted_to | bool | True if the viewing user has reacted to this content |
| visitor_reaction_id | integer | If the viewer reacted, the ID of the reaction they used |
| message_id | integer |     |
| conversation_id | integer |     |
| message_date | integer |     |
| user_id | integer |     |
| message | string |     |
| attach_count | integer |     |
| reaction_score | integer |     |
| User | [User](#type_User) |     |

### Data type: Forum

| Column | Type | Description |
| --- | --- | --- |
| forum_type_id | string |     |
| allow_posting | bool |     |
| require_prefix | bool |     |
| min_tags | integer |     |

### Data type: LinkForum

| Column | Type | Description |
| --- | --- | --- |
| link_url | string |     |
| redirect_count | integer |     |

### Data type: Node

| Column | Type | Description |
| --- | --- | --- |
| breadcrumbs | array | A list of breadcrumbs for this node, including the node_id, title, and node_type_id |
| type_data | object | Data related to the specific node type this represents. Contents will vary significantly. |
| view_url | string |     |
| node_id | integer |     |
| title | string |     |
| node_name | string |     |
| description | string |     |
| node_type_id | string |     |
| parent_node_id | integer |     |
| display_order | integer |     |
| display_in_list | bool |     |

### Data type: Page

| Column | Type | Description |
| --- | --- | --- |
| publish_date | integer |     |
| view_count | integer |     |

### Data type: Poll

| Column | Type | Description |
| --- | --- | --- |
| can_vote | bool |     |
| has_voted | bool |     |
| responses | array | List of possible responses with text, vote count (if visible) and whether the API user has voted for each |
| poll_id | integer |     |
| question | string |     |
| voter_count | integer |     |
| public_votes | bool |     |
| max_votes | integer |     |
| close_date | integer |     |
| change_vote | bool |     |
| view_results_unvoted | bool |     |

### Data type: Post

| Column | Type | Description |
| --- | --- | --- |
| username | string |     |
| is_first_post | bool |     |
| is_last_post | bool |     |
| is_unread | bool | If accessing as a user, true if this post is unread |
| message_parsed | string | HTML parsed version of the message contents. |
| can_edit | bool |     |
| can_soft_delete | bool |     |
| can_hard_delete | bool |     |
| can_react | bool |     |
| can_view_attachments | bool |     |
| view_url | string |     |
| Thread | [Thread](#type_Thread) | If requested by context, the thread this post is part of. |
| Attachments | [Attachment](#type_Attachment)[] | Attachments to this post, if it has any. |
| is_reacted_to | bool | True if the viewing user has reacted to this content |
| visitor_reaction_id | integer | If the viewer reacted, the ID of the reaction they used |
| vote_score | integer | The content's vote score (if supported) |
| can_content_vote | bool | True if the viewing user can vote on this content |
| allowed_content_vote_types | string[] | List of content vote types allowed on this content |
| is_content_voted | bool | True if the viewing user has voted on this content |
| visitor_content_vote | string | If the viewer reacted, the vote they case (up/down) |
| post_id | integer |     |
| thread_id | integer |     |
| user_id | integer |     |
| post_date | integer |     |
| message | string |     |
| message_state | string |     |
| attach_count | integer |     |
| warning_message | string |     |
| position | integer |     |
| last_edit_date | integer |     |
| reaction_score | integer |     |
| User | [User](#type_User) |     |

### Data type: ProfilePost

| Column | Type | Description |
| --- | --- | --- |
| username | string |     |
| message_parsed | string | HTML parsed version of the message contents. |
| can_edit | bool |     |
| can_soft_delete | bool |     |
| can_hard_delete | bool |     |
| can_react | bool |     |
| can_view_attachments | bool |     |
| view_url | string |     |
| ProfileUser | [User](#type_User) | If requested by context, the user this profile post was left for. |
| Attachments | [Attachment](#type_Attachment)[] | Attachments to this profile post, if it has any. |
| LatestComments | [ProfilePostComment](#type_ProfilePostComment)[] | If requested, the most recent comments on this profile post. |
| is_reacted_to | bool | True if the viewing user has reacted to this content |
| visitor_reaction_id | integer | If the viewer reacted, the ID of the reaction they used |
| profile_post_id | integer |     |
| profile_user_id | integer |     |
| user_id | integer |     |
| post_date | integer |     |
| message | string |     |
| message_state | string |     |
| warning_message | string |     |
| comment_count | integer |     |
| first_comment_date | integer |     |
| last_comment_date | integer |     |
| reaction_score | integer |     |
| User | [User](#type_User) |     |

### Data type: ProfilePostComment

| Column | Type | Description |
| --- | --- | --- |
| username | string |     |
| message_parsed | string | HTML parsed version of the message contents. |
| can_edit | bool |     |
| can_soft_delete | bool |     |
| can_hard_delete | bool |     |
| can_react | bool |     |
| can_view_attachments | bool |     |
| Attachments | [Attachment](#type_Attachment)[] | Attachments to this profile post, if it has any. |
| ProfilePost | [ProfilePost](#type_ProfilePost) | If requested by context, the profile post this comment relates to. |
| is_reacted_to | bool | True if the viewing user has reacted to this content |
| visitor_reaction_id | integer | If the viewer reacted, the ID of the reaction they used |
| profile_post_comment_id | integer |     |
| profile_post_id | integer |     |
| user_id | integer |     |
| comment_date | integer |     |
| message | string |     |
| message_state | string |     |
| warning_message | string |     |
| reaction_score | integer |     |
| User | [User](#type_User) |     |

### Data type: Search

| Column | Type | Description |
| --- | --- | --- |
| search_id | integer |     |
| result_count | integer |     |
| search_type | string |     |
| search_query | string |     |
| search_constraints | array |     |
| search_order | string |     |
| search_grouping | bool |     |
| warnings | array |     |
| user_id | integer |     |
| search_date | integer |     |
| query_hash | string |     |

### Data type: Thread

| Column | Type | Description |
| --- | --- | --- |
| username | string |     |
| is_watching | bool | If accessing as a user, true if they are watching this thread |
| visitor_post_count | integer | If accessing as a user, the number of posts they have made in this thread |
| is_unread | bool | If accessing as a user, true if this thread is unread |
| custom_fields | object | Key-value pairs of custom field values for this thread |
| tags | array |     |
| prefix | string | Present if this thread has a prefix. Printable name of the prefix. |
| can_edit | bool |     |
| can_edit_tags | bool |     |
| can_reply | bool |     |
| can_soft_delete | bool |     |
| can_hard_delete | bool |     |
| can_view_attachments | bool |     |
| view_url | string |     |
| is_first_post_pinned | bool |     |
| highlighted_post_ids | array |     |
| is_search_engine_indexable | bool |     |
| index_state | string | Present for members with permission to change the search index state of this thread. |
| Forum | [Node](#type_Node) | If requested by context, the forum this thread was posted in. |
| vote_score | integer | The content's vote score (if supported) |
| can_content_vote | bool | True if the viewing user can vote on this content |
| allowed_content_vote_types | string[] | List of content vote types allowed on this content |
| is_content_voted | bool | True if the viewing user has voted on this content |
| visitor_content_vote | string | If the viewer reacted, the vote they case (up/down) |
| thread_id | integer |     |
| node_id | integer |     |
| title | string |     |
| reply_count | integer |     |
| view_count | integer |     |
| user_id | integer |     |
| post_date | integer |     |
| sticky | bool |     |
| discussion_state | string |     |
| discussion_open | bool |     |
| discussion_type | string |     |
| first_post_id | integer |     |
| last_post_date | integer |     |
| last_post_id | integer |     |
| last_post_user_id | integer |     |
| last_post_username | string |     |
| first_post_reaction_score | integer |     |
| prefix_id | integer |     |
| User | [User](#type_User) |     |

### Data type: ThreadField

| Column | Type | Description |
| --- | --- | --- |
| field_id | string |     |
| title | string |     |
| description | string |     |
| display_order | integer |     |
| field_type | string |     |
| field_choices | object | For choice types, an ordered list of choices, with "option" and "name" keys for each. |
| match_type | string |     |
| match_params | array |     |
| max_length | integer |     |
| required | bool |     |
| display_group | string | If this field type supports grouping, the group this field belongs to. |

### Data type: ThreadPrefix

| Column | Type | Description |
| --- | --- | --- |
| prefix_id | integer |     |
| title | string |     |
| description | string |     |
| usage_help | string |     |
| is_usable | bool | True if the acting user can use (select) this prefix. |
| prefix_group_id | integer |     |
| display_order | integer |     |
| materialized_order | integer | Effective order, taking group ordering into account. |

### Data type: User

Information about the user. Different information will be included based on permissions and verbosity.

| Column | Type | Description |
| --- | --- | --- |
| about | string |     |
| activity_visible | bool |     |
| age | integer | The user's current age. Only included if available. |
| alert_optout | array |     |
| allow_post_profile | string |     |
| allow_receive_news_feed | string |     |
| allow_send_personal_conversation | string |     |
| allow_view_identities | string |     |
| allow_view_profile | string |     |
| avatar_urls | object | Maps from size types to URL. |
| profile_banner_urls | object | Maps from size types to URL. |
| can_ban | bool |     |
| can_converse | bool |     |
| can_edit | bool |     |
| can_follow | bool |     |
| can_ignore | bool |     |
| can_post_profile | bool |     |
| can_view_profile | bool |     |
| can_view_profile_posts | bool |     |
| can_warn | bool |     |
| content_show_signature | bool |     |
| creation_watch_state | string |     |
| custom_fields | object | Map of custom field keys and values. |
| custom_title | string | Will have a value if a custom title has been specifically set; prefer user_title instead. |
| dob | object | Date of birth with year, month and day keys. |
| email | string |     |
| email_on_conversation | bool |     |
| gravatar | string |     |
| interaction_watch_state | bool |     |
| is_admin | bool |     |
| is_banned | bool |     |
| is_discouraged | bool |     |
| is_followed | bool | True if the visitor is following this user. Only included if visitor is not a guest. |
| is_ignored | bool | True if the visitor is ignoring this user. Only included if visitor is not a guest. |
| is_moderator | bool |     |
| is_super_admin | bool |     |
| last_activity | integer | Unix timestamp of user's last activity, if available. |
| location | string |     |
| push_on_conversation | bool |     |
| push_optout | array |     |
| receive_admin_email | bool |     |
| secondary_group_ids | array |     |
| show_dob_date | bool |     |
| show_dob_year | bool |     |
| signature | string |     |
| timezone | string |     |
| use_tfa | bool |     |
| user_group_id | integer |     |
| user_state | string |     |
| user_title | string |     |
| visible | bool |     |
| warning_points | integer | Current warning points. |
| website | string |     |
| view_url | string |     |
| user_id | integer |     |
| username | string |     |
| message_count | integer |     |
| question_solution_count | integer |     |
| register_date | integer |     |
| trophy_points | integer |     |
| is_staff | bool |     |
| reaction_score | integer |     |
| vote_score | integer |     |

### Data type: UserField

| Column | Type | Description |
| --- | --- | --- |
| field_id | string |     |
| title | string |     |
| description | string |     |
| display_order | integer |     |
| field_type | string |     |
| field_choices | object | For choice types, an ordered list of choices, with "option" and "name" keys for each. |
| match_type | string |     |
| match_params | array |     |
| max_length | integer |     |
| required | bool |     |
| display_group | string | If this field type supports grouping, the group this field belongs to. |

### Data type: XFMG_Album

| Column | Type | Description |
| --- | --- | --- |
| album_id | integer |     |
| category_id | integer |     |
| title | string |     |
| description | string |     |
| create_date | integer |     |
| last_update_date | integer |     |
| view_privacy | string |     |
| add_privacy | string |     |
| album_state | string |     |
| user_id | integer |     |
| media_count | integer |     |
| view_count | integer |     |
| warning_message | string |     |
| last_comment_date | integer |     |
| last_comment_id | integer |     |
| last_comment_user_id | integer |     |
| last_comment_username | string |     |
| comment_count | integer |     |
| rating_count | integer |     |
| rating_avg | float |     |
| rating_weighted | float |     |
| reaction_score | integer |     |
| User | [User](#type_User) |     |

### Data type: XFMG_Category

| Column | Type | Description |
| --- | --- | --- |
| category_id | integer |     |
| title | string |     |
| description | string |     |
| category_type | string |     |
| media_count | integer |     |
| album_count | integer |     |
| comment_count | integer |     |
| allowed_types | array |     |
| min_tags | integer |     |
| category_index_limit | integer |     |
| parent_category_id | integer |     |
| display_order | integer |     |

### Data type: XFMG_MediaField

| Column | Type | Description |
| --- | --- | --- |
| field_id | string |     |
| title | string |     |
| description | string |     |
| display_order | integer |     |
| field_type | string |     |
| field_choices | object | For choice types, an ordered list of choices, with "option" and "name" keys for each. |
| match_type | string |     |
| match_params | array |     |
| max_length | integer |     |
| required | bool |     |
| display_group | string | If this field type supports grouping, the group this field belongs to. |

### Data type: XFMG_MediaItem

| Column | Type | Description |
| --- | --- | --- |
| media_id | integer |     |
| title | string |     |
| description | string |     |
| media_date | integer |     |
| last_edit_date | integer |     |
| media_type | string |     |
| media_state | string |     |
| album_id | integer |     |
| album_state | string |     |
| category_id | integer |     |
| user_id | integer |     |
| view_count | integer |     |
| warning_message | string |     |
| last_comment_date | integer |     |
| last_comment_id | integer |     |
| last_comment_user_id | integer |     |
| last_comment_username | string |     |
| comment_count | integer |     |
| rating_count | integer |     |
| rating_avg | float |     |
| rating_weighted | float |     |
| reaction_score | integer |     |
| User | [User](#type_User) |     |

### Data type: XFRM_Category

| Column | Type | Description |
| --- | --- | --- |
| resource_category_id | integer |     |
| title | string |     |
| description | string |     |
| resource_count | integer |     |
| last_update | integer |     |
| last_resource_title | string |     |
| last_resource_id | integer |     |
| allow_local | bool |     |
| allow_external | bool |     |
| allow_commercial_external | bool |     |
| allow_fileless | bool |     |
| min_tags | integer |     |
| enable_versioning | bool |     |
| enable_support_url | bool |     |
| parent_category_id | integer |     |
| display_order | integer |     |

### Data type: XFRM_ResourceField

| Column | Type | Description |
| --- | --- | --- |
| field_id | string |     |
| title | string |     |
| description | string |     |
| display_order | integer |     |
| field_type | string |     |
| field_choices | object | For choice types, an ordered list of choices, with "option" and "name" keys for each. |
| match_type | string |     |
| match_params | array |     |
| max_length | integer |     |
| required | bool |     |
| display_group | string | If this field type supports grouping, the group this field belongs to. |

### Data type: XFRM_ResourceItem

| Column | Type | Description |
| --- | --- | --- |
| resource_id | integer |     |
| title | string |     |
| tag_line | string |     |
| user_id | integer |     |
| resource_state | string |     |
| resource_type | string |     |
| resource_date | integer |     |
| resource_category_id | integer |     |
| external_url | string |     |
| price | float |     |
| currency | string |     |
| view_count | integer |     |
| download_count | integer |     |
| rating_count | integer |     |
| rating_avg | float |     |
| rating_weighted | float |     |
| last_update | integer |     |
| alt_support_url | string |     |
| prefix_id | integer |     |
| Category | [XFRM_Category](#type_XFRM_Category) |     |
| User | [User](#type_User) |     |

### Data type: XFRM_ResourcePrefix

| Column | Type | Description |
| --- | --- | --- |
| prefix_id | integer |     |
| title | string |     |
| description | string |     |
| usage_help | string |     |
| is_usable | bool | True if the acting user can use (select) this prefix. |
| prefix_group_id | integer |     |
| display_order | integer |     |
| materialized_order | integer | Effective order, taking group ordering into account. |

### Data type: XFRM_ResourceReviewField

| Column | Type | Description |
| --- | --- | --- |
| field_id | string |     |
| title | string |     |
| description | string |     |
| display_order | integer |     |
| field_type | string |     |
| field_choices | object | For choice types, an ordered list of choices, with "option" and "name" keys for each. |
| match_type | string |     |
| match_params | array |     |
| max_length | integer |     |
| required | bool |     |
| display_group | string | If this field type supports grouping, the group this field belongs to. |

### Data type: XFRM_ResourceVersion

| Column | Type | Description |
| --- | --- | --- |
| resource_version_id | integer |     |
| resource_id | integer |     |
| version_string | string |     |
| release_date | integer |     |
| download_count | integer |     |
| rating_count | integer |     |
| version_state | string |     |
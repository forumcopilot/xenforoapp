


# XenForo API - Conversations

## POST conversation-messages/

Replies to a conversation

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| conversation_id | integer | **Required** |
| message | string | **Required** |
| attachment_key | string | API attachment key to upload files. Attachment key content type must be conversation_message with context[conversation_id] set to this conversation ID. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| message | [ConversationMessage](#type_ConversationMessage) | The newly inserted message |

## GET conversation-messages/{id}/

Gets the specified conversation message.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| message | [ConversationMessage](#type_ConversationMessage) | |

## POST conversation-messages/{id}/

Updates the specified conversation message.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| message | string | The new message content |
| attachment_key | string | API attachment key to upload files. Attachment key content type must be conversation_message with context[message_id] set to this message ID. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| message | [ConversationMessage](#type_ConversationMessage) | |

## POST conversation-messages/{id}/react

Reacts to the specified conversation message

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| reaction_id | integer | **Required** ID of the reaction to use. Use the current reaction ID to undo. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| action | string | "insert" or "delete" based on whether the reaction was added or removed. |

## GET conversations/

Gets the API user's list of conversations.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| page | integer | |
| starter_id | integer | |
| receiver_id | integer | |
| starred | bool | Only gets starred conversations if specified |
| unread | bool | Only gets unread conversations if specified |

### Response

| Output | Type | Description |
|--------|------|-------------|
| conversations | [Conversation](#type_Conversation)[] | |
| pagination | pagination | |

## POST conversations/

Creates a conversation

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| recipient_ids | integer[] | **Required** List of user IDs to send the conversation to |
| title | string | **Required** Conversation title |
| message | string | **Required** Conversation message body |
| attachment_key | string | API attachment key to upload files. Attachment key content type must be conversation_message with no context. |
| conversation_open | bool | If false, no replies may be made to this conversation. |
| open_invite | bool | If true, any member of the conversation may add others |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| conversation | [Conversation](#type_Conversation) | |

## GET conversations/{id}/

Gets information about the specified conversation.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| with_messages | bool | If specified, the response will include a page of messages. |
| page | integer | The page of messages to include |

### Response

| Output | Type | Description |
|--------|------|-------------|
| conversation | [Conversation](#type_Conversation) | |
| messages | [ConversationMessage](#type_ConversationMessage)[] | List of messages on the requested page |
| pagination | pagination | Pagination details |

## POST conversations/{id}/

Updates the specified conversation

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| title | string | Conversation title |
| open_invite | bool | If true, any member of the conversation can add others |
| conversation_open | bool | If false, no further replies are allowed. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
| conversation | [Conversation](#type_Conversation) | |

## DELETE conversations/{id}/

Deletes the specified conversation from the API user's list. Does not delete the conversation for other receivers.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| ignore | bool | If true, further replies to this conversation will be ignored. (Otherwise, replies will restore this conversation to the list.) |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## POST conversations/{id}/invite

Invites the specified users to this conversation.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| recipient_ids | integer[] | **Required** List of user IDs to invite |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## POST conversations/{id}/mark-read

Marks the conversation as read up until the specified time. This cannot move the

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| date | integer | Unix timestamp to mark the conversation read to. If not specified, defaults to the current time. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## POST conversations/{id}/mark-unread

Marks a conversation as unread. This will mark all messages in the conversation as unread.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## GET conversations/{id}/messages

Gets a page of messages in the specified conversation.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| page | integer | |

### Response

| Output | Type | Description |
|--------|------|-------------|
| messages | [ConversationMessage](#type_ConversationMessage)[] | List of messages on the requested page |
| pagination | pagination | Pagination details |

## POST conversations/{id}/star

Sets the star status of the specified conversation

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| star | bool | If provided, sets the star status as specified. If not provided, toggles the status. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |


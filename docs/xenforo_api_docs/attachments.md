# XenForo API - Attachments

## GET attachments/

Gets the attachments associated with the provided API attachment key. Only returns attachments that have not been associated with content.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| key | string | **Required** The API attachment key |

### Response

| Output | Type | Description |
|--------|------|-------------|
| attachments | [Attachment](#type_Attachment)[] | List of matching attachments. |

## POST attachments/

Uploads an attachment. An API attachment key must be created first. Must be submitted using multipart/form-data encoding.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| key | string | **Required** The API attachment key to associated with |
| attachment | file | **Required** The attachment file |

### Response

| Output | Type | Description |
|--------|------|-------------|
| attachment | [Attachment](#type_Attachment) | The attachment record of the successful upload |

### Errors

| Error key | Description |
|-----------|-------------|
| attachment_key_user_wrong | Triggered if the user making the request does not match the user that created the attachment key. |

## POST attachments/new-key

Creates a new attachment key, allowing attachments to be uploaded separately from the related content.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| type | string | **Required** The content type of the attachment. Default types include post, conversation_message. Add-ons may add more. |
| context | string[] | Key-value pairs representing the context of the attachment. This will vary depending on content type and the action being taken. See relevant actions for further details. |
| attachment | file | The first attachment to be associated with the new key. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| key | string | The attachment key created. This should be used to upload additional files or to associate uploaded attachments with other content. |
| attachment | [Attachment](#type_Attachment) | If a file was provided and the upload was successful, this will describe the new attachment. |

## GET attachments/{id}/

Gets information about the specified attachment.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| attachment | [Attachment](#type_Attachment) | |

## DELETE attachments/{id}/

Delete's the specified attachment.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |

## GET attachments/{id}/data

Gets the data that makes up the specified attachment. The output is the raw binary data.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| data | binary | The binary data is output directly, not JSON. |

## GET attachments/{id}/thumbnail

Gets the URL to the attachment's thumbnail, if it has one. URL returned via a 301 redirect.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| url | string | The URL to the thumbnail is returned via a 301 redirect's Location header. |

### Errors

| Error key | Description |
|-----------|-------------|
| not_found | Not found if the attachment does not have a thumbnail |

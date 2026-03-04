
# XenForo API - Authentication

## POST auth/

Tests a login and password for validity. Only available to super user keys. We strongly recommend the login and password parameters are passed into the request body rather than the query string.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| login | string | **Required** The username or email address of the user to test |
| password | string | **Required** The password of the user |
| limit_ip | string | The IP that should be considered to be making the request. If provided, this will be used to prevent brute force attempts. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| user | [User](#type_User) | If successful, the user record of the matching user |

## POST auth/from-session

Looks up the active XenForo user based on session ID or remember cookie value. This can be used to help with seamless SSO with XF, assuming the session or remember cookies are available to your page. At least one of session_id and remember_cookie must be provided. Only available to super user keys.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| session_id | string | If provided, checks for an active session with that ID. |
| remember_cookie | string | If provided, checks to see if this is an active "remember me" cookie value. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | bool | If false, no session or remember cookie could be found |
| user | [User](#type_User) | If successful, the user record of the matching user. May be a guest. |

## POST auth/login-token

Generates a token that can automatically log into a specific XenForo user when the login URL is visited. If the visitor is already logged into a XenForo account, they will not be logged into the specified account. Only available to super user keys.

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| user_id | integer | **Required** |
| limit_ip | string | If provided, locks the token to the specified IP for additional security |
| return_url | string | If provided, after logging the user will be returned to this URL. Otherwise they'll go to the XenForo index. |
| force | bool | If provided, the login URL will forcibly replace the currently logged in user if a user is already logged in and different to the currently logged in user. Defaults to false. |
| remember | bool | Controls whether the a "remember me" cookie will be set when the user logs in. Defaults to true. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| login_token | string | |
| login_url | string | Direct user to this URL to trigger a login |
| expiry_date | integer | Unix timestamp of when the token expires. An error will be displayed if the token is expired or invalid |

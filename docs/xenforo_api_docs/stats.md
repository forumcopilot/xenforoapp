
# XenForo API - Stats

## GET stats/

Gets site statistics and general activity information

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| totals[threads] | integer | |
| totals[messages] | integer | |
| totals[users] | integer | |
| latest_user[user_id] | integer | |
| latest_user[username] | string | |
| latest_user[register_date] | integer | |
| online[total] | integer | |
| online[members] | integer | |
| online[guests] | integer | |

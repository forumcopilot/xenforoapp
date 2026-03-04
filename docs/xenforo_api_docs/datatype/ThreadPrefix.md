### Data type: ThreadPrefix

| Column | Type | Description |
|--------|------|--------------|
| prefix_id | integer |  |
| title | string |  |
| description | string |  |
| usage_help | string |  |
| is_usable | bool | True if the acting user can use (select) this prefix. |
| prefix_group_id | integer |  |
| display_order | integer |  |
| materialized_order | integer | Effective order, taking group ordering into account. |
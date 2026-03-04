# getForum: Link Subforums (External Links)

## Summary

The **getForum** API now returns **link subforums** (XenForo “Link forums”) in the same tree as categories and forums. These are nodes that redirect to an external URL (e.g. a support site). The app can show them in the forum list and open the URL when the user taps the item.

## Identifying link subforums

Each forum/category object in the response includes:

- **`isLinkForum`** (boolean)  
  - `true` → this node is a link subforum (external link).  
  - `false` → normal forum or category.

## Fields to use for link subforums

For entries with **`isLinkForum: true`**, only these fields are meaningful:

| Field   | Use |
|--------|-----|
| **`id`**   | Node ID (e.g. for hierarchy / parentId). |
| **`name`** | Display title (e.g. “Support”, “Documentation”). |
| **`url`**  | External URL to open (e.g. `https://example.com/support`). |

All other fields (threadCount, postCount, lastPost*, etc.) are zero/empty for link subforums and should be ignored.

## App behavior

1. When rendering the forum list, include nodes with `isLinkForum: true` like any other subforum (use `name` for the label).
2. When the user selects a link subforum (`isLinkForum: true`), open **`url`** instead of navigating to a forum/topic list, e.g.:
   - Open in the device browser, or  
   - Open in an in-app web view.
3. Do not call getTopic or other thread APIs for a link subforum; it has no threads.

## Example link subforum object

```json
{
  "id": "155",
  "name": "Link Forum 1",
  "url": "https://apple.com",
  "isLinkForum": true,
  "parentId": "1",
  "displayOrder": 1,
  "subForums": [],
  "threadCount": 0,
  "postCount": 0,
  ...
}
```

Same response shape as other forums; use **`name`** and **`url`** (and **`id`** if needed for hierarchy).

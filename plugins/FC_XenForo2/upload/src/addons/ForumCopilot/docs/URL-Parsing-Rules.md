# XenForo URL Parsing Rules

This document describes how to detect and parse XenForo thread and post URLs. Use it when implementing direct link detection in apps, bots, or integrations.

---

## Overview

XenForo uses several URL formats for threads and posts. All share the same structure:

- **Route prefix**: `threads` or `posts`
- **Thread segment**: Either `{id}` or `{slug}.{id}` (the ID is always the numeric part)
- **Post segment** (when present): `post-{post_id}`

---

## URL Types Reference

| Type | Path Pattern | thread_id Source | post_id Source |
|------|--------------|------------------|----------------|
| Thread | `/threads/{thread}/` | Path | — |
| Direct post | `/threads/{thread}/post-{id}` | Path | Path |
| Short post | `/posts/{id}/` | — | Path |
| Thread + anchor | `/threads/{thread}/...#post-{id}` | Path | URL fragment |

---

## Path Structure

### Thread segment (`{thread}`)

The thread segment can appear in two forms:

| Format | Example | Extraction |
|--------|---------|------------|
| ID only | `123` | `thread_id = 123` |
| Slug + ID | `my-thread-title.123` | `thread_id = 123` (digits after the last `.`) |

**Rule**: The `thread_id` is always the numeric value. If a dot is present, it is the part after the last dot; otherwise, the entire segment.

### Base path

Sites may use a base path (e.g. `/community/`, `/forum/`). The path after the domain may look like:

- `https://example.com/threads/123/`
- `https://example.com/community/threads/123/`

When parsing, locate the `/threads/` or `/posts/` segment within the full path; the preceding segments are the base path.

---

## Regex Patterns

### 1. Direct post URL (canonical)

Use this first to detect direct post links.

```
/threads/(?:[^/]+\.)?(\d+)/post-(\d+)
```

- **Group 1**: `thread_id`
- **Group 2**: `post_id`

### 2. Short post URL

```
/posts/(\d+)/?
```

- **Group 1**: `post_id`
- **Note**: `thread_id` is not in the URL; resolve via post-to-thread lookup if needed.

### 3. Thread URL

Use this when the URL is not a post URL.

```
/threads/(?:[^/]+\.)?(\d+)(?:/|$|(?=page-))
```

- **Group 1**: `thread_id`

### 4. Thread URL with post anchor

- **Path**: Use the thread regex above.
- **Fragment**: `#post-(\d+)`
- **Group 1** (path): `thread_id`
- **Group 1** (fragment): `post_id`

---

## Detection Algorithm

Apply rules in this order (post URLs before thread URLs):

```
1. If path matches: /threads/.../post-{digits}
   → Type: direct_post
   → Extract thread_id and post_id from path

2. If path matches: /posts/{digits}
   → Type: short_post
   → Extract post_id from path (thread_id = null)

3. If path matches: /threads/... AND fragment matches: #post-{digits}
   → Type: thread_with_anchor
   → Extract thread_id from path, post_id from fragment

4. If path matches: /threads/...
   → Type: thread
   → Extract thread_id from path (post_id = null)

5. Otherwise
   → Not a thread/post URL
```

---

## Example URLs

| URL | Type | thread_id | post_id |
|-----|------|-----------|---------|
| `/threads/123/` | thread | 123 | — |
| `/threads/my-topic.123/` | thread | 123 | — |
| `/threads/my-topic.123/page-2` | thread | 123 | — |
| `/threads/123/post-456` | direct_post | 123 | 456 |
| `/threads/my-topic.123/post-456` | direct_post | 123 | 456 |
| `/posts/456/` | short_post | — | 456 |
| `/threads/123/#post-456` | thread_with_anchor | 123 | 456 |
| `/community/threads/slug.789/post-101` | direct_post | 789 | 101 |

---

## Implementation Notes

1. **Matching order**: Check direct post URLs before thread-only URLs, since both start with `/threads/`.

2. **Optional title in URLs**: XenForo can be configured to omit the title slug (`includeTitleInUrls`). URLs may be `/threads/123/` instead of `/threads/my-topic.123/`. The regex patterns handle both.

3. **URL fragment**: The fragment (`#post-123`) is not sent to the server in HTTP requests. For thread-with-anchor detection, the full URL including fragment must be available.

4. **Case and encoding**: Path segments are typically lowercase and URL-encoded. Match case-insensitively if needed; decode percent-encoded characters before displaying.

5. **Short post URLs**: `/posts/{id}/` usually redirects to the full thread view. For link detection, `post_id` is sufficient; use the API or database to resolve the thread if required.

---

## Pseudo-code

```python
def parse_xenforo_url(url):
    path = url.path
    fragment = url.fragment or ""

    # 1. Direct post
    m = re.search(r'/threads/(?:[^/]+\.)?(\d+)/post-(\d+)', path)
    if m:
        return {"type": "direct_post", "thread_id": int(m[1]), "post_id": int(m[2])}

    # 2. Short post
    m = re.search(r'/posts/(\d+)/?', path)
    if m:
        return {"type": "short_post", "post_id": int(m[1]), "thread_id": None}

    # 3. Thread with anchor
    m_path = re.search(r'/threads/(?:[^/]+\.)?(\d+)', path)
    m_frag = re.match(r'^post-(\d+)$', fragment)
    if m_path and m_frag:
        return {"type": "thread_with_anchor", "thread_id": int(m_path[1]), "post_id": int(m_frag[1])}

    # 4. Thread only
    m = re.search(r'/threads/(?:[^/]+\.)?(\d+)(?:/|$|(?=page-))', path)
    if m:
        return {"type": "thread", "thread_id": int(m[1]), "post_id": None}

    return None
```

---

## Source

These rules are derived from XenForo's route definitions in `XF/_data/routes.xml` and the router logic in `XF/Mvc/Router.php`.

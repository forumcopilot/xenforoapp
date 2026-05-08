# Releasing

This document describes how to publish a new version of the xenForo app and keep the marketing site (`forumcopilot.com/app-changelog`) in sync.

A release lives in two places:
- The **canonical** GitHub Release at `https://github.com/forumcopilot/xenforoapp/releases` (this repo)
- A **curated** entry on the marketing site at `https://forumcopilot.com/app-changelog`, sourced from `frontend/src/data/xenforoAppReleases.js` in the [`forumcopilot/siteowners`](https://github.com/forumcopilot/siteowners) repo

Both must be updated together. Total time per release: ~10 minutes.

## Versioning

We follow [Semantic Versioning](https://semver.org/). Pre-1.0 (which we are):

| Bump | When |
|---|---|
| **Patch** (`v0.6.0` → `v0.6.1`) | Bug fixes, small UX tweaks, documentation |
| **Minor** (`v0.6.x` → `v0.7.0`) | New features, breaking config changes |
| **Major** (`v0.x.x` → `v1.0.0`) | When we're ready to commit to backward compatibility going forward |

We do not tag every commit. Tag when at least one of these is true:
- A user-visible feature has landed
- A real bug has been fixed
- ~5+ commits have accumulated and someone cloning `main` would see meaningfully old code

Casual rhythm: every 1–2 weeks if active, every month-ish if not.

## Step-by-step

### 1. In this repo (`forumcopilot/xenforoapp`)

```bash
# 1. Make sure main is clean and up to date
git checkout main
git pull origin main

# 2. Bump the Flutter version in pubspec.yaml
#    e.g. 0.6.0+34 → 0.6.1+35
$EDITOR pubspec.yaml

# 3. Append a new entry to CHANGELOG.md, just below `## [Unreleased]`
#    Use Keep-a-Changelog format with Added / Fixed / Changed / Documentation sections.
#    Look at the previous v0.6.0 entry as a template.
$EDITOR CHANGELOG.md

# 4. Commit + push the bump
git add pubspec.yaml CHANGELOG.md
git commit -m "chore(release): v0.6.1"
git push origin main

# 5. Cut the GitHub Release. Save your release notes to /tmp/release-notes.md first
#    (you can copy them from the new CHANGELOG entry, with a brief intro paragraph
#    and a "Get started" snippet at the bottom — see /tmp/v0.6.0-notes.md as reference).
gh release create v0.6.1 \
  --title "v0.6.1 — <one-line summary>" \
  --notes-file /tmp/release-notes.md \
  --target main
```

GitHub creates the tag, the Release page, and (by default) attaches a source tarball / zipball. No manual artifact upload needed — this is a build-from-source project.

### 2. In the marketing repo (`forumcopilot/siteowners`)

```bash
cd /path/to/siteowners
git checkout main
git pull origin main

# Add a new entry to the TOP of the array in xenforoAppReleases.js
$EDITOR frontend/src/data/xenforoAppReleases.js
```

Each entry follows this shape (copy-paste from the existing v0.6.0 entry and adjust):

```js
{
  version: '0.6.1',
  date: '2026-XX-XX',
  releaseUrl: 'https://github.com/forumcopilot/xenforoapp/releases/tag/v0.6.1',
  sourceUrl: 'https://github.com/forumcopilot/xenforoapp/tree/v0.6.1',
  summary: 'One-paragraph human-readable summary.',
  sections: [
    { title: 'Added', items: ['...'] },
    { title: 'Fixed', items: ['...'] },
    { title: 'Changed', items: ['...'] },
  ],
},
```

Then:

```bash
git add frontend/src/data/xenforoAppReleases.js
git commit -m "Publish xenForo app v0.6.1"
git push origin main
```

The site redeploys automatically (CI/CD). Within a few minutes:
- `https://forumcopilot.com/app-changelog` — shows the new release at the top, latest-version overview cards refresh
- `https://forumcopilot.com/github-notice` — "View Changelog" button still routes to the same page

## Drafting release notes from the commit log

The fastest way to draft notes:

```bash
git log v0.6.0..HEAD --oneline
```

Group the output by conventional-commit prefix:
- `feat:` / `feat(scope):` → **Added**
- `fix:` / `fix(scope):` → **Fixed**
- `refactor:` / `chore:` / `build:` / `port:` → **Changed**
- `docs:` → **Documentation**

Then write each line as a user-facing sentence (not the commit subject — describe the *outcome*).

Example: a commit `fix(ui): remove phantom back arrow from top-level tab app bars` becomes a CHANGELOG bullet:
> Removed a phantom back arrow that briefly appeared in top-level tab app bars during navigation transitions.

## Things to watch out for

- **Don't tag from a feature branch** — `gh release create` defaults to the current branch. Pass `--target main` explicitly if you're not on `main`.
- **`releaseUrl` must match the actual tag** — typo there breaks the "View Release" button silently. Test by clicking it after deploy.
- **Date format is `YYYY-MM-DD`** — both in CHANGELOG.md and `xenforoAppReleases.js`. The marketing page renders it as-is.
- **`sections.title === 'Developer Notes'`** is filtered out of the highlights (top 3 bullets shown above the fold). Use it for noisy implementation details that shouldn't lead the page.
- **Don't auto-publish APKs/IPAs** — this is a build-from-source project on purpose. Only the source tag and release notes go up.

## When release notes are wrong

Both can be fixed without a new tag:

| Where | How |
|---|---|
| GitHub Release page | `gh release edit v0.6.1 --notes-file <new-notes.md>` |
| Marketing site | Edit `xenforoAppReleases.js` and push — site redeploys |

If the *tag itself* points at the wrong commit, that's a destructive action — check with the team before re-tagging.

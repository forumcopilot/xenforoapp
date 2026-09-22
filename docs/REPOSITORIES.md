# Related repositories and where releases flow

Forum Copilot for XenForo is spread over four repositories plus a few
non-git working trees on the development Mac. This page says what each one
owns, which local checkout is the one to use, and how a change or a release
travels between them. Last updated 2026-09-22.

## The repositories

| Purpose | GitHub | Local checkout (the only one to use) |
|---|---|---|
| **This repo: open-source single-forum app template + the XenForo add-on** | `forumcopilot/xenforoapp` (public) | `/Volumes/CRUCIAL/byo/xenforoapp` |
| **Canonical multi-forum app and the SDK packages** | `MoleDJ/tapatalk_flutter` (private, default branch `master`) | `/Volumes/CRUCIAL/tapatalk_flutter` |
| **Marketing site, owner console, add-on downloads, hosted push** | `forumcopilot/siteowners` (private) | `/Users/tung/siteowners` |
| **A customer's single-forum fork** | private | outside this document; carries customer-only features and is never upstream |

Other copies of these checkouts that used to exist on `/Volumes/CRUCIAL`
were deleted on 2026-09-22 so that nobody edits a stale tree by accident.
If you find another copy, it is stale.

## What is owned where

- **The XenForo add-on** (`plugins/FC_XenForo2/` here) is owned by this repo
  and nowhere else. The canonical multi-forum repo dropped its copy on
  2026-09-15; its deploy scripts read the add-on from this checkout. The
  customer fork carries a customer-specific superset that is downstream of
  this one. Details: `plugins/FC_XenForo2/README.md`.
- **The SDK packages** (`packages/forumcopilot_sdk`, `packages/xenforo_core`)
  are owned by the canonical repo and synced into `packages/` here. The
  sync is meant to be byte-identical; as of 2026-09-22 it is not (this repo
  has the keystore password fix and the device proxy, canonical has newer
  model fields and a Cloudflare fix), and a deliberate two-way sync is
  pending. The shared test suite under `packages/forumcopilot_sdk/lib/test`
  was fixed in canonical and synced here on 2026-09-22.
- **The app** (`lib/`) here is the open-source template. Portable fixes are
  made here first and cherry-picked outward; single-forum bootstrap code
  stays here, multi-forum features stay in the canonical repo.
- **The website and the add-on ZIPs** are owned by the marketing repo.
  Downloads live in `frontend/public/downloads/` there, the add-on changelog
  in `frontend/src/data/xenforoAddonReleases.js`, the app release history in
  `frontend/src/data/xenforoAppReleases.js`.

## How releases flow

**App release** (`RELEASING.md`): bump `pubspec.yaml`, write `CHANGELOG.md`,
tag and create the GitHub release here, then add the entry to
`xenforoAppReleases.js` in the marketing repo and push.

**Add-on release** (`plugins/FC_XenForo2/README.md`): bump `addon.json`,
regenerate `hashes.json`, verify by upgrading the local test forums and
running the live suites (`docs/guides/LOCAL_E2E_TESTING.md`), build the ZIP,
attach it to a GitHub release here (`addon-vX.Y.Z`, or the next app
release), copy it into the marketing repo's downloads, add the entry to
`xenforoAddonReleases.js`, push.

**Marketing site deployment**: a push to `main` of `forumcopilot/siteowners`
triggers its `Deploy to AWS Server` workflow, which runs on a self-hosted
runner on the production server and rebuilds the site in place. There is no
staging branch or staging deployment as of 2026-09-22; `main` is production.
An old `master` branch still exists on GitHub, 39 commits behind, and is not
deployed.

## Local test infrastructure (not git)

`/Volumes/CRUCIAL/xenforo` holds the XenForo dev trees: a 2.2.19 and a
2.3.7 throwaway instance for testing this repo's add-on, each with its own
database. `docs/guides/LOCAL_E2E_TESTING.md` is the manual.

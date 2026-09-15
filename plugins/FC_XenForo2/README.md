# Forum Copilot XenForo add-on (`ForumCopilot`)

**This directory is the official source of the Forum Copilot XenForo add-on.**
The add-on is developed and released from this repository
(`forumcopilot/xenforoapp`). Do not maintain a second copy elsewhere; other
repositories that need it should point here.

The one sanctioned exception is a customer-specific build kept in that
customer's private fork. It carries features that only apply to that forum
(a push bridge for a third-party chat add-on) and is **not** upstream.
Generic fixes flow from here to there, never the other way without review.

Current version: see `version_string` in
[`upload/src/addons/ForumCopilot/addon.json`](upload/src/addons/ForumCopilot/addon.json).
Requires XenForo 2.2.0 or newer and a valid XenForo licence. MIT licensed
(see the repository `LICENSE`).

## Layout

```
plugins/FC_XenForo2/
├── README.md                 this file
├── build_release.sh          builds the release ZIP (see below)
└── upload/                   exactly what the release ZIP contains
    ├── js/ForumCopilot/      smart-banner assets copied to the forum webroot
    └── src/addons/ForumCopilot/
        ├── addon.json        id, title, version_id / version_string, requirements
        ├── hashes.json       SHA-256 of every shipped file (XenForo's file-health check)
        ├── _data/            phrases, options, code event listeners, routes…
        ├── Api/, App.php     the forumcopilot.php dispatcher and its controllers
        ├── Push/, Service/   push dispatch (hosted, or direct FCM HTTP v1)
        ├── Setup.php         install / upgrade; copies forumcopilot.php to the webroot
        └── webroot_files/    the forumcopilot.php entry file that Setup.php copies
```

`hashes.json` must stay in sync with the files it lists: XenForo's installer
only copies files whose recorded hash differs from what is on disk, and the
admin "file health check" flags mismatches. After editing any shipped file,
regenerate the entry (or the whole manifest) before committing. The manifest
never lists `hashes.json` itself, `build_release.sh`, or anything outside
`upload/`.

## Installing on a forum

See the top-level [README](../../README.md#install-the-xenforo-add-on-required-for-both-paths):
download the ZIP from the [forumcopilot.com console](https://forumcopilot.com/console)
or zip `upload/` yourself, then **Admin CP → Add-ons → Install/upgrade from
archive**, then open **Options → ForumCopilot Options** once.

For development, `../../deploy_plugin.sh` rsyncs `upload/src/addons/ForumCopilot`
straight into a XenForo install over SSH (`REMOTE_HOST`, `REMOTE_USER`,
`DEST_BASE`).

## Building a release ZIP

XenForo's own packer produces the canonical archive, and `build_release.sh`
wraps it:

```bash
XF_ROOT=/path/to/a/xenforo/install ./plugins/FC_XenForo2/build_release.sh
```

It expects the add-on to be deployed into `$XF_ROOT/src/addons/ForumCopilot/`
(use `deploy_plugin.sh` or a symlink), runs `php cmd.php xf-addon:build-release
ForumCopilot`, then injects `upload/js/ForumCopilot/` into the ZIP and patches
`hashes.json` so the installer copies those webroot assets. The result lands in
`$XF_ROOT/src/addons/ForumCopilot/_releases/ForumCopilot-<version>.zip`.

Without a XenForo install, zipping the `upload/` folder from this directory
produces an equivalent archive as long as `hashes.json` is current.

## Releasing a new add-on version

1. Bump `version_id` and `version_string` in `addon.json`. The id is
   `MMmmpp00`-style: 1.8.1 → `1080100`, 1.8.2 → `1080200`, 1.9.0 → `1090000`.
   Any phrase, option or other `_data` entity whose text changed gets the same
   stamp (`version_id` / `version_string` attributes in its XML).
2. Regenerate `hashes.json` (the packer does it; otherwise update the changed
   entries by hand with `shasum -a 256`).
3. Build the ZIP (above) and install it on a test forum as an **upgrade** over
   the previous version.
4. Commit as `chore(addon): v1.8.2` and push to `main`.
5. Publish, in this order:
   - Attach the ZIP to the next app release on GitHub (or create a dedicated
     `addon-v1.8.2` release if no app release is due).
   - In the `forumcopilot/siteowners` repo, copy the ZIP to
     `frontend/public/downloads/ForumCopilot_1_8_2.zip` and add an entry to
     `frontend/src/data/xenforoAddonReleases.js`. The site redeploys on push;
     `/addon-changelog` and the console download link update from that file.
6. Mention the new add-on version in the app `CHANGELOG.md` under the next
   app release ("Ships with bundled ForumCopilot addon vX.Y.Z").

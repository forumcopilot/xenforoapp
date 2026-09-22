# Local end-to-end testing

How to test this app the way a forum owner would experience it, entirely on one
Mac plus a phone: a local XenForo running the add-on from this repository,
the app built from source and installed on a connected Pixel, and the
automated suites that sit between them.

Written 2026-09-15 against the machine this repo is developed on. Paths,
ports and serials below are that machine's; change them to match yours.

## The strategy in one paragraph

Test against the **oldest XenForo the add-on claims to support (2.2)** on a
**throwaway instance with its own database**, deploy the add-on **from this
repo's `plugins/FC_XenForo2/`** (never from another forum's copy), expose it
with **ngrok** so the phone reaches it over HTTPS with a stable hostname, run
the **live API suite** in `packages/xenforo_core` against it, then build the
app in **debug mode on the Pixel** with `--dart-define=FORUM_BASE_URL` pointing
at the tunnel and walk the manual checklist. Repeat the API suite and a short
manual pass on a **2.3 instance** before a release. Push notifications are a
separate, optional layer because they need a real Firebase project.

Four layers, cheapest first. Stop at the first one that fails.

| Layer | What it proves | Time | Needs |
|---|---|---|---|
| 1. Forum + add-on | The add-on installs, upgrades, and `forumcopilot.php` answers | 5 min | MySQL, PHP, this repo |
| 2. Live API suite | Every proxy the app uses returns the right shapes | 5 min | layer 1, `config.json` |
| 3. App on device | Real UI, real network, real images, real keystore | 15 min | layer 1, Pixel, ngrok or adb reverse |
| 4. Perf harness | Scroll performance did not regress | 10 min | layer 3 |

## What already exists on this Mac

| Thing | Where / value |
|---|---|
| XenForo dev tree | `/Volumes/CRUCIAL/xenforo` (a byte-identical copy of `/Users/tung/xenforo`, 593 MB; the helper scripts hard-code the `/Users/tung` path) |
| XenForo 2.2.19 test instance | `/Volumes/CRUCIAL/xenforo/instances/xf-2.2.19-forumcopilot`, DB `xenforo_2219_fc`, cookie prefix `xf2219_`, runs on PHP 8.2 at `127.0.0.1:8091` |
| XenForo 2.3.7 test instance | `/Volumes/CRUCIAL/xenforo/instances/xf-2.3.7-forumcopilot`, DB `xenforo_237_fc`, cookie prefix `xf237_`, PHP 8.3 at `127.0.0.1:8092`. Created 2026-09-22 by copying the code of the 2.3.7 tree below and running the installer; demo content: 61 users, 43 threads, ~1,600 posts |
| XenForo 2.3.7 working tree | `/Volumes/CRUCIAL/xenforo/upload`, DB `xenforo`, shared with the customer staging tree below. Not for open-source testing |
| Customer staging tree | `/Volumes/CRUCIAL/qhtt/xenforoweb` shares DB `xenforo` and carries the customer add-on flavour. **Do not test the open-source add-on there.** |
| Demo content (2.2.19) | 31 users, 43 threads, 1,375 posts. Long threads with image attachments: 42, 43, 44. Forum nodes: 45 General Chat, 48 Installation Help |
| Admin account (2.2.19) | `Admin`; the password is whatever `XF2219_ADMIN_PASSWORD` was when `install-xf2219.sh` last ran (the script has a default; check it there, and reset with `restore_admin_password.php` in the xenforo tree if lost) |
| Demo users | password `password123` (from `generate-demo-data.php` / `create-test-users.php`) |
| MySQL | Homebrew MySQL 9.5 as a service, root without password, TCP 3306 and socket `/tmp/mysql.sock` |
| PHP | 8.4 default (`php`), 8.2 at `/opt/homebrew/opt/php@8.2/bin/php`, 8.3 installed |
| ngrok | `/opt/homebrew/bin/ngrok`, authenticated, v3 config. A reserved free domain on this account is already set as both forums' board URL; read it with `mysql -u root -N -e "select option_value from xenforo_2219_fc.xf_option where option_id='boardUrl'"` and use it as `<ngrok-domain>` below |
| Helper scripts | `/Volumes/CRUCIAL/xenforo/scripts/start-xf-instance.sh`, `install-xf-instance.sh` (any instance; env `XF_INSTANCE_DIR`, `XF_BASE_URL`, `XF_MYSQL_DB`, `XF_ADMIN_PASSWORD`), the older `install-xf2219.sh`, `update-board-url-instance.php`; `/Volumes/CRUCIAL/xenforo/start-ngrok.sh`, `get-ngrok-url.sh`; notes in `XENFORO_INSTANCES.md` and `NGROK_SETUP.md` |
| Phone | Pixel 4a, Android 13, serial `08041JEC212433`, USB debugging on |

Two of those scripts are stale and should not be used as-is:

- `scripts/sync-forumcopilot-addon.sh` copies the add-on **from the 2.3.7
  tree**, which still holds add-on 1.3.2. Use `scripts/xf_dev_sync.sh` from
  this repo instead (below). It also deletes the add-on's CLI command files
  for 2.2, which is no longer needed: the add-on ships a base-class shim that
  works on both 2.2 and 2.3.
- `QUICK-START.txt` says the 2.3.7 forum is on port 8080. It is not any more.

## Layer 1: forum + add-on

### 1a. MySQL

```bash
brew services list | grep mysql        # should say started
mysql -u root -e 'select 1'            # via socket
```

If the second command fails with *Can't connect through socket '/tmp/mysql.sock'*
while `mysql -u root -h 127.0.0.1 --protocol=tcp` works, macOS has cleaned
`/tmp` under a still-running server. XenForo's `config.php` uses
`host = 'localhost'`, which means the socket, so the forum will not boot either.
Fix:

```bash
brew services restart mysql
```

If it keeps happening, set `$config['db']['host'] = '127.0.0.1';` in the
instance's `src/config.php` so it never depends on the socket.

### 1b. Start the 2.2.19 instance

XenForo 2.2 needs PHP 8.2 or older. The helper script picks PHP 8.2 for any
instance whose name starts with `xf-2.2`.

```bash
/Volumes/CRUCIAL/xenforo/scripts/start-xf-instance.sh xf-2.2.19-forumcopilot 8091
```

Leave it running in its own terminal. Check:

```bash
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8091/
open http://127.0.0.1:8091/admin.php
```

To rebuild the instance from scratch (drops and recreates `xenforo_2219_fc`,
runs the web installer, then you re-generate demo data):

```bash
XF2219_ADMIN_PASSWORD='choose-one' /Volumes/CRUCIAL/xenforo/scripts/install-xf2219.sh
cd /Volumes/CRUCIAL/xenforo/instances/xf-2.2.19-forumcopilot
/opt/homebrew/opt/php@8.2/bin/php generate-demo-data.php --users=30 --threads=40
```

### 1b'. The 2.3.7 instance

Same idea on port 8092 with PHP 8.3 (`start-xf-instance.sh` picks PHP 8.2
only for `xf-2.2*` names, so pass the binary explicitly):

```bash
cd /Volumes/CRUCIAL/xenforo/instances/xf-2.3.7-forumcopilot && \
  /opt/homebrew/opt/php@8.3/bin/php -S 127.0.0.1:8092 -t .
```

To rebuild it from scratch: copy the 2.3.7 code out of the working tree
(everything except `data/`, `internal_data/`, `src/config.php`,
`src/addons/ForumCopilot`, third-party add-ons, `forumcopilot.php` and
`js/ForumCopilot`), give it empty `data/` and `internal_data/` folders and a
`src/config.php` pointing at `127.0.0.1` / `xenforo_237_fc` / cookie prefix
`xf237_`, then:

```bash
XF_INSTANCE_DIR=/Volumes/CRUCIAL/xenforo/instances/xf-2.3.7-forumcopilot \
XF_BASE_URL=http://127.0.0.1:8092 XF_MYSQL_DB=xenforo_237_fc \
XF_ADMIN_PASSWORD='choose-one' /Volumes/CRUCIAL/xenforo/scripts/install-xf-instance.sh http://127.0.0.1:8092
cd /Volumes/CRUCIAL/xenforo/instances/xf-2.3.7-forumcopilot
cp ../xf-2.2.19-forumcopilot/generate-demo-data.php . && /opt/homebrew/opt/php@8.3/bin/php generate-demo-data.php --users=30 --threads=40
```

Use the 2.2.19 instance's copy of `generate-demo-data.php`: it is the newer
one (recent timestamps so the latest-topics APIs return content, and a fix
for a PHP 8.3 fatal on the fresh install's unnamed default nodes). It exits
non-zero after the conversations step on 2.3.7 but everything up to and
including conversations is created.

Two quirks of a generator-built 2.3.7 forum: the generated categories are
not viewable by the admin until XenForo's permission cache is rebuilt (ACP →
Tools → Rebuild caches → permissions), so point the test config at the
installer's own **Main forum** (node 2) or rebuild first; and the 2.3
installer names its default nodes `NULL`, which is what the generator fix
above is for.

### 1c. Deploy the add-on from this repo

`scripts/xf_dev_sync.sh` rsyncs `plugins/FC_XenForo2/upload/` into a
XenForo install (the add-on directory, the smart-banner assets under
`js/ForumCopilot/`, and the `forumcopilot.php` entry file), then runs
`xf-addon:install` or `xf-addon:upgrade` as appropriate.

```bash
cd /Volumes/CRUCIAL/byo/xenforoapp
PHP_BIN=/opt/homebrew/opt/php@8.2/bin/php \
  ./scripts/xf_dev_sync.sh /Volumes/CRUCIAL/xenforo/instances/xf-2.2.19-forumcopilot
```

`DRY_RUN=1` prints what would change without touching anything. Run it after
every add-on edit; XenForo caches nothing that matters for PHP changes, but
`_data/*.xml` changes (phrases, options, listeners) only take effect after the
upgrade step, which the script always runs.

The first time on an instance that had an older add-on, the upgrade walks
every intermediate migration, including the listener rewrites from 1.6 to
1.8. That is itself a useful test: it is what a real forum on an old version
goes through. (Done on 2026-09-21: 1.3.2 → 1.8.1 upgraded cleanly on 2.2.19.)

If XenForo prints *"N files which have unexpected contents"* during the
upgrade, the repo's `hashes.json` is out of step with the files. It hashes
with carriage returns stripped; see `plugins/FC_XenForo2/README.md` for the
one-liner that regenerates it correctly.

### 1d. Verify the add-on

```bash
curl -s -X POST -H 'Content-Type: application/json' -d '{"method":"getConfig"}' \
  http://127.0.0.1:8091/forumcopilot.php | head -c 400
```

You should get `"result":true` with `version` (the add-on) and `systemVersion`
(XenForo). A GET, or a POST without the JSON content type, is rejected with
`"result":false` and a message saying so.
Then in the Admin CP open **Options → ForumCopilot Options** once. On first
visit it copies `forumcopilot.php` if missing and tries to register the forum
with forumcopilot.com. **Registration needs the forum reachable from the
internet**, so with a plain localhost board URL it logs a failure and moves on.
That is fine for layers 2 and 3; the standalone app never talks to
forumcopilot.com. Turn the master push toggle **off** on that page unless you
are doing the push layer, or every alert will queue pushes nobody receives.

The 2.2.19 database currently has push enabled and a hosted `fc_site_id` of 49
from earlier work. Switch it off for ordinary testing.

## Layer 2: live API suite

The XenForo package carries two test files that run the SDK's shared proxy
suites (account, attachments, config, forums, moderation, posts, conversations,
private messages, search, social, subscriptions, topics, users) against a real
forum. They read `packages/xenforo_core/test/config.json`, which is gitignored.

```bash
cd packages/xenforo_core
cp test/config.json.example test/config.json
```

Fill it in for the 2.2.19 instance:

```json
{
  "baseUrl": "http://127.0.0.1:8091",
  "pluginUrl": "http://127.0.0.1:8091/forumcopilot.php",
  "username": "Admin",
  "password": "<admin password>",
  "moderatorUsername": "Admin",
  "moderatorPassword": "<admin password>",
  "forumId": "48",
  "topicId": "42",
  "postId": "<a post id in thread 42>",
  "userId": "1",
  "conversationId": "<an existing conversation id>",
  "messageId": "<a message id in it>",
  "attachmentId": "<an attachment id on thread 42>",
  "groupId": "2",
  "testUrl": "http://127.0.0.1:8091/threads/42/",
  "email": "admin@example.com",
  "privateMessagingType": "conversations",
  "secondUsername": "<a demo user>",
  "secondPassword": "password123",
  "thirdUsername": "<another demo user>"
}
```

`secondUsername` is who conversations, follows and bans are aimed at (a
forum refuses all three against yourself); `thirdUsername` is invited into
the conversation the suite creates. Both are optional; the affected tests
are recorded as skipped without them.

Get the ids from MySQL rather than guessing:

```bash
mysql -u root xenforo_2219_fc -e "select post_id from xf_post where thread_id=42 limit 1; select attachment_id from xf_attachment where content_type='post' limit 1; select conversation_id, first_message_id from xf_conversation_master limit 1;"
```

Keep one config per instance outside the repo (only `test/config.json` is
gitignored) and copy the one you want into place before a run, for example
`config.xf22.json` / `config.xf23.json` in a scratch folder. For 2.3.7 the
URL is `http://127.0.0.1:8092`, the ids from the fresh demo data are forum
2, thread 4, post 4, attachment 1, and the seeded conversation 159 / message
2259 with demo users `EmilyMoore599` and `DavidThomas100`.

Run the basic suite first, then the full interface suite:

```bash
flutter test test/xenforo_basic_tests.dart -r expanded
flutter test test/xenforo_interface_tests.dart -r expanded
```

Both write to the forum (posts, replies, reactions, conversations), which is
why they run against a throwaway instance and never against a customer's
forum. Reset with `install-xf2219.sh` when the demo data gets messy.

Expected outcome with add-on 1.8.3 (2026-09-22), on both 2.2.19 and 2.3.7:
basic suite 49/49, interface suite 100/100 with about 30 recorded as
*skipped*. A skip
is a method XenForo does not implement (moderator login, avatar URL lookup,
"thanks", …) or a test whose second/third user is not configured; the
summary printed at the end lists them. Anything reported as *failed* is a
real regression in the add-on or in `xenforo_core`.

## Layer 3: the app on the Pixel

### 3a. Reach the forum from the phone

Two options. Use **ngrok** for anything that resembles real use and **adb
reverse** for fast offline iteration.

**ngrok (recommended).** The account already has a reserved domain and both
forum databases already carry it as their board URL, so nothing needs updating
when you reuse it:

```bash
ngrok http 8091 --domain=<ngrok-domain>
```

Or `/Volumes/CRUCIAL/xenforo/start-ngrok.sh xf2219 <ngrok-domain>`,
which also rewrites the board URL, useful if it was changed. The ngrok
inspector at `http://localhost:4040` shows every request the app makes, which
is the fastest way to see what the app actually asked the forum. If an ngrok
agent is already running (port 4040 busy), stop it first; the free plan allows
one.

The board URL matters: XenForo builds absolute URLs for avatars and
attachments from it, so the phone must be able to open whatever it says.

**adb reverse (offline).** Maps the phone's `127.0.0.1:8091` to the Mac's:

```bash
adb -s 08041JEC212433 reverse tcp:8091 tcp:8091
php /Volumes/CRUCIAL/xenforo/scripts/update-board-url-instance.php \
  /Volumes/CRUCIAL/xenforo/instances/xf-2.2.19-forumcopilot http://127.0.0.1:8091
```

The debug build allows cleartext HTTP (`android/app/src/debug/AndroidManifest.xml`);
release builds do not, so this path is debug-only. Set the board URL back to
the ngrok domain afterwards.

### 3b. Build and run

```bash
cd /Volumes/CRUCIAL/byo/xenforoapp
flutter pub get && ./buildlib.sh          # once, and after ARB or SDK model changes
flutter run -d 08041JEC212433 \
  --dart-define=FORUM_NAME="Local XF 2.2" \
  --dart-define=FORUM_BASE_URL=https://<ngrok-domain>
```

Notes:

- The debug build installs as `com.example.forumapp.xf`, so it coexists with
  the Discourse template app and with any release build.
- `google-services.json` in the repo is a placeholder project. Firebase init
  logs a warning and the app continues without push. That is expected.
- Hot reload works for UI changes. Config changes (`--dart-define`) need a
  restart of `flutter run`.
- For a fresh-install experience (first launch, no stored session, keystore
  migration paths), uninstall first: `adb -s 08041JEC212433 uninstall com.example.forumapp.xf`.
- To test the release build's behaviour (no cleartext, R8, real signing) use
  `flutter build apk --release` after `android/create_keystore.sh`, then
  `adb install`. Point it at the ngrok HTTPS URL; HTTP will be blocked.

### 3c. Manual checklist

Work through this once per release on 2.2, and the starred items on 2.3.

1. ★ Cold start connects, shows the forum list, no error dialog.
2. ★ Log in with a demo user; toggle Remember me; kill and relaunch; still
   logged in. Verify with `adb shell run-as com.example.forumapp.xf ls shared_prefs`
   that no `password` value appears in any prefs file (it must be in the
   keystore only).
3. ★ Open thread 42: avatars, inline images and attachment thumbnails load;
   tap an image; the full-screen viewer opens with the Hero animation.
4. Scroll to the end of the thread and back; jump-to-post dialog works; the
   post counter tracks.
5. ★ Reply with text, a quote, and a photo from the camera roll.
6. New topic with a poll; vote in it.
7. React to a post with something other than Like; change it; remove it.
8. ★ Conversations: start one with a second demo user, reply from the web UI,
   see it in the app; alerts list shows the alert.
9. Search for a word that exists in thread 42.
10. Profile: view, change avatar, custom fields render.
11. Subscribe and unsubscribe to the thread from the action menu.
12. Log out; the forum is still browsable as a guest.
13. Upgrade path: install the previous release's APK, log in, install the
    current build over it, relaunch. Session survives and no password is left
    in prefs.

## Layer 4: scroll performance

Once layer 3 works, the harness in `integration_test/scroll_perf_test.dart`
can run against the local forum. Its numbers are only comparable with runs
against the same content on the same phone, so record which ids you used.

```bash
flutter drive --profile -d 08041JEC212433 \
  --dart-define=FORUM_BASE_URL=https://<ngrok-domain> \
  --dart-define=PERF_FORUM_ID=48 \
  --dart-define=PERF_TOPIC_ID=42 \
  --dart-define=PERF_MEDIA_TOPIC_ID=44 \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/scroll_perf_test.dart > /tmp/drive.log 2>&1
grep PERF /tmp/drive.log
```

The demo threads are about 250 posts each. The published baseline used a
1,700-post archive thread on a public forum, so treat local numbers as a
regression check between your own runs, not against `docs/perf-benchmarking.md`.
Everything else in that document (traps, what the columns mean, when a
difference is real) applies unchanged.

## Optional layer: push notifications

Skip this unless you are changing push code. It needs the forum reachable
from the internet (ngrok) and a real Firebase project.

- **Direct dispatch (self-hosted, recommended for local work).** Create a
  Firebase project, register the Android app id `com.example.forumapp.xf`
  (the debug id) and download its `google-services.json` over the placeholder.
  Download a service-account JSON and put it outside the web root, for example
  `/Volumes/CRUCIAL/xenforo/secrets/firebase-sa.json`. In the ACP add-on
  options enable push and **Direct push**, and set the service-account path.
  In `app_forum_config.dart` set `pushSource = 'direct'` and leave
  `pushApiBaseUrl` empty. Reply to the phone's user from the web UI and the
  push should arrive within seconds; the ACP add-on page logs each dispatch.
- **Hosted push.** Needs the forum registered with forumcopilot.com over ngrok
  and the hosted backend able to reach it. The marketing repo's
  `push-backend/` can also run locally; that is a bigger setup and out of
  scope here.

## Before a release

1. Layers 1 and 2 on 2.2.19, upgrading from the previous add-on version.
2. Layers 1 and 2 on 2.3.7 (`xf-2.3.7-forumcopilot`, port 8092, PHP 8.3), with
   `config.xf23.json` copied into place.
3. Layer 3 full checklist on 2.2.19, starred items on 2.3.7.
4. Layer 4 once, compared with your previous run.
5. `flutter analyze` and `flutter test` are green (CI enforces this).

## Known rough edges worth fixing

- `/Users/tung/xenforo` and `/Volumes/CRUCIAL/xenforo` are identical copies.
  Keep one; the scripts inside hard-code `/Users/tung/xenforo`.
- The `xenforo` database says add-on 1.4.5 while the customer staging tree on
  top of it has 1.8.1 files. Something there was deployed by file copy without
  an upgrade. Not this repo's problem, but do not draw conclusions from that
  instance.
- `packages/xenforo_core/test/config.json.example` has no comments. The ids
  above are the ones that matter; the rest can stay at their example values
  until a test complains.
- The live suite is destructive. A `--dry-run` or read-only subset would let
  it run against a staging copy of a real forum.

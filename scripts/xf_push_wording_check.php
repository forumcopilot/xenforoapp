<?php
// php scripts/xf_push_wording_check.php <xf dir> <capture file> <sender id> <member A id> <member B id> <thread id>
//
// Checks the add-on's push wording on a local XenForo (deploy the add-on with
// scripts/xf_dev_sync.sh first; XenForo 2.2 needs PHP 8.2). Hosted pushes go
// to a capture server, never to forumcopilot.com:
//   CAPTURE_FILE=/tmp/pushes.jsonl php -S 127.0.0.1:8765 scripts/xf_push_capture.php
// the direct path's FcmDispatch jobs are read from xf_job and deleted unrun.
// Runs only the jobs it creates. Writes to the forum (messages, a post, a
// language, options): back the database up first and restore it afterwards.
[$_, $dir, $captureFile, $senderId, $aId, $bId, $threadId] = $argv;
require $dir . '/src/XF.php';
XF::start($dir);
$app = XF::setupApp('XF\Cli\App');
$db = XF::db();
$em = $app->em();

$failures = 0;
function check(string $what, $actual, $expected): void
{
    global $failures;
    $ok = $actual === $expected;
    if (!$ok) {
        $failures++;
    }
    echo ($ok ? '  ok   ' : '  FAIL ') . $what . ($ok ? '' : "\n         expected: " . var_export($expected, true) . "\n         actual:   " . var_export($actual, true)) . "\n";
}

$preexisting = $db->fetchAllColumn('SELECT job_id FROM xf_job');

/** Runs the jobs this script created; returns the direct-path pushes (FcmDispatch jobs), deleted unrun. */
function drain(): array
{
    global $db, $app, $preexisting;
    $direct = [];
    for ($i = 0; $i < 20; $i++) {
        $jobs = $db->fetchAll('SELECT * FROM xf_job WHERE job_id NOT IN (' . $db->quote($preexisting) . ') ORDER BY job_id');
        if (!$jobs) {
            break;
        }
        foreach ($jobs as $job) {
            if (strpos($job['execute_class'], 'FcmDispatch') !== false) {
                $direct[] = unserialize($job['execute_data']);
                $db->delete('xf_job', 'job_id = ?', $job['job_id']);
            } else {
                $app->jobManager()->runById($job['job_id'], 30);
            }
        }
    }
    return $direct;
}

/** The hosted pushes captured since the last call. */
function captured(): array
{
    global $captureFile;
    static $seen = 0;
    $lines = array_values(array_filter(explode("\n", (string) @file_get_contents($captureFile))));
    $new = array_slice($lines, $seen);
    $seen = count($lines);
    return array_map(fn ($l) => json_decode($l, true), $new);
}

$app->repository('XF:Option')->updateOptions([
    'fc_push_enabled' => 1,
    'fc_push_hosted_enabled' => 1,
    'fc_push_api_url' => 'http://127.0.0.1:8765',
    'fc_site_id' => 999,
    'fc_push_direct_enabled' => 1,
    // Direct mode on, so its jobs are queued; they are never run.
    'fc_push_direct_creds_path' => __FILE__,
]);
$board = (string) XF::options()->boardTitle;
$is23 = XF::$versionId >= 2030000;
echo 'XenForo ' . XF::$version . ", board \"$board\"\n";

$sender = $em->find('XF:User', (int) $senderId);
$a = $em->find('XF:User', (int) $aId);
$b = $em->find('XF:User', (int) $bId);
foreach ([$aId, $bId] as $id) {
    $db->query('REPLACE INTO xf_fc_user (user_id, last_seen) VALUES (?, ?)', [(int) $id, time()]);
    $db->update('xf_user_option', ['push_on_conversation' => 1], 'user_id = ?', (int) $id);
}

// Member B reads the forum in a second language whose direct-message line differs.
$lang = $em->create('XF:Language');
foreach ($em->find('XF:Language', 1)->toArray(false) as $column => $value) {
    if (!in_array($column, ['language_id', 'parent_id', 'parent_list', 'title', 'phrase_cache', 'language_code'], true)) {
        $lang->set($column, $value);
    }
}
$lang->title = 'Push wording test';
$lang->parent_id = 1;
$lang->language_code = 'fr-FR';
$lang->save();
$replyPhrase = ($is23 ? 'push_direct_message_' : 'push_conversation_') . 'reply';
$phrase = $em->create('XF:Phrase');
$phrase->language_id = $lang->language_id;
$phrase->title = $replyPhrase;
$phrase->phrase_text = '{sender} a répondu à « {title} ».';
$phrase->addon_id = '';
$phrase->save();
$db->update('xf_user', ['language_id' => $lang->language_id], 'user_id = ?', (int) $bId);
drain();
// This process read the list of languages before the new one existed.
$app->container()->decache('language.cache');
$app->container()->decacheFactory('language');
captured();

function newConversation($sender, array $to, string $title, string $text)
{
    return XF::asVisitor($sender, function () use ($sender, $to, $title, $text) {
        $creator = XF::service('XF:Conversation\Creator', $sender);
        $creator->setRecipientsTrusted($to);
        $creator->setContent($title, $text);
        if (!$creator->validate($errors)) {
            throw new \Exception('not valid: ' . json_encode(array_map('strval', $errors)));
        }
        return $creator->save();
    });
}

echo "\n1. A new direct message with a quote, an image and a long text\n";
$long = '[QUOTE="Bob, post: 1"]Quoted words that stay out[/QUOTE]See you there [IMG]https://example.com/a.png[/IMG] '
    . str_repeat('and bring the snacks ', 12);
$conversation = newConversation($sender, [$a], 'Weekend plans', $long);
\ForumCopilot\Listener::apiRequestComplete();
$direct = drain();
$hosted = captured();
$snippet = \ForumCopilot\Listener::messageSnippet($long);
check('one hosted push', count($hosted), 1);
check('hosted title is the forum', $hosted[0]['title'] ?? null, $board);
check('hosted body is "Sender: snippet"', $hosted[0]['body'] ?? null, $sender->username . ': ' . $snippet);
check('snippet leaves the quote and image out', strpos($snippet, 'Quoted') === false && strpos($snippet, 'png') === false && strpos($snippet, 'See you there and bring') === 0, true);
check('snippet is at most 140 characters', mb_strlen($snippet) <= 140, true);
check('push_format 2', $hosted[0]['data']['push_format'] ?? null, 2);
check('channel messages', $hosted[0]['data']['channel'] ?? null, 'messages');
check('one direct push', count($direct), 1);
check('direct title is the sender', $direct[0]['title'] ?? null, $sender->username);
check('direct body is the snippet', $direct[0]['body'] ?? null, $snippet);
echo '       hosted: ' . ($hosted[0]['title'] ?? '') . ' / ' . ($hosted[0]['body'] ?? '') . "\n";

echo "\n2. An image-only reply in a group message, members in two languages\n";
$group = newConversation($sender, [$a, $b], 'Photos', 'Here they come');
\ForumCopilot\Listener::apiRequestComplete();
drain();
captured();
XF::asVisitor($sender, function () use ($group, $sender) {
    $replier = XF::service('XF:Conversation\Replier', $group, $sender);
    $replier->setMessageContent('[IMG]https://example.com/photo.jpg[/IMG]');
    $replier->save();
});
\ForumCopilot\Listener::apiRequestComplete();
$direct = drain();
$hosted = captured();
$byUser = [];
foreach ($hosted as $push) {
    foreach ($push['target_user_ids'] as $uid) {
        $byUser[$uid] = $push;
    }
}
$english = XF::app()->language(1)->phrase($replyPhrase, ['sender' => $sender->username, 'title' => 'Photos', 'boardTitle' => $board])->render('raw');
check('two hosted pushes, one per language', count($hosted), 2);
check('member A: XenForo\'s line in English', $byUser[(int) $aId]['body'] ?? null, $english);
check('member B: XenForo\'s line in B\'s language', $byUser[(int) $bId]['body'] ?? null, $sender->username . ' a répondu à « Photos ».');
check('titles are the forum', array_values(array_unique(array_column($hosted, 'title'))), [$board]);
check('direct pushes carry the same line', array_column($direct, 'body'), array_column($hosted, 'body'));
check('direct titles are the forum', array_values(array_unique(array_column($direct, 'title'))), [$board]);
foreach ($hosted as $push) {
    echo '       hosted: ' . $push['title'] . ' / ' . $push['body'] . "\n";
}

if ($is23) {
    echo "\n3. Added to a direct message (XenForo 2.3)\n";
    $solo = newConversation($sender, [$a], 'Planning', 'Just us so far');
    \ForumCopilot\Listener::apiRequestComplete();
    drain();
    captured();
    XF::asVisitor($sender, function () use ($solo, $sender, $b) {
        $inviter = XF::service('XF:Conversation\Inviter', $solo, $sender);
        $inviter->setRecipientsTrusted([$b]);
        $inviter->save();
    });
    \ForumCopilot\Listener::apiRequestComplete();
    $direct = drain();
    $hosted = captured();
    check('one hosted push', count($hosted), 1);
    check('hosted title is the forum', $hosted[0]['title'] ?? null, $board);
    check('body is XenForo\'s invite line, in B\'s language (English here)', $hosted[0]['body'] ?? null,
        XF::app()->language($b->language_id)->phrase('push_direct_message_invite', ['sender' => $sender->username, 'title' => 'Planning', 'boardTitle' => $board])->render('raw'));
    check('direct push matches', [($direct[0]['title'] ?? null), ($direct[0]['body'] ?? null)], [$board, $hosted[0]['body'] ?? null]);
    echo '       hosted: ' . ($hosted[0]['title'] ?? '') . ' / ' . ($hosted[0]['body'] ?? '') . "\n";
}

echo "\n4. A reply in a thread member A watches (an alert)\n";
$thread = $em->find('XF:Thread', (int) $threadId);
$db->query('REPLACE INTO xf_thread_watch (user_id, thread_id, email_subscribe) VALUES (?, ?, 0)', [(int) $aId, (int) $threadId]);
XF::asVisitor($sender, function () use ($thread) {
    $replier = XF::service('XF:Thread\Replier', $thread);
    $replier->setMessage('A reply for the watchers');
    $replier->save();
    $replier->sendNotifications();
});
$direct = drain();
$hosted = captured();
$prefix = $app->templater()->func('prefix', ['thread', $thread, 'plain']);
check('one hosted push', count($hosted), 1);
check('title is the forum', $hosted[0]['title'] ?? null, $board);
check('body is XenForo\'s alert text, unchanged', $hosted[0]['body'] ?? null,
    XF::app()->language(1)->phrase('x_replied_to_thread_y_may_be_more', ['name' => $sender->username, 'title' => $prefix . $thread->title])->render('raw'));
check('channel replies', $hosted[0]['data']['channel'] ?? null, 'replies');
check('direct push matches', [($direct[0]['title'] ?? null), ($direct[0]['body'] ?? null)], [$board, $hosted[0]['body'] ?? null]);
echo '       hosted: ' . ($hosted[0]['title'] ?? '') . ' / ' . ($hosted[0]['body'] ?? '') . "\n";

echo "\n" . ($failures ? "$failures FAILED" : 'all passed') . "\n";
exit($failures ? 1 : 0);

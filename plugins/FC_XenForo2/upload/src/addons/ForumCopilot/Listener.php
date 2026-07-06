<?php

namespace ForumCopilot;

use XF;

class Listener
{
    protected static $bootChecked = false;
    protected static $seenMessageIds = [];

    /**
     * Collected during the request. Populated in
     * conversationMessageEntityPostSave; processed in processBatchedAlerts
     * at app_pub_complete — by which time xf_conversation_recipient rows
     * are committed to the DB.
     *
     * Shape: [ ['conversationId' => int, 'senderId' => int, 'messageId' => int], ... ]
     */
    protected static $pendingConversationPushes = [];

    /**
     * app_pub_complete listener.
     * Also acts as boot hook + processes deferred conversation pushes.
     */
    public static function processBatchedAlerts()
    {
        self::bootCheck();
        self::processPendingConversationPushes();

        $options = XF::options();
        if (!isset($options->fc_push_enabled) || !$options->fc_push_enabled) {
            return;
        }

        $collected = \ForumCopilot\Service\Alert\AlertPushCollector::getCollectedAlerts();
        if (empty($collected)) {
            return;
        }

        \XF::logError('[FC DEBUG] Listener.processBatchedAlerts: enqueuing job with ' . count($collected) . ' alert(s)');

        $jobManager = XF::app()->jobManager();
        $jobManager->enqueueUnique(
            'forumCopilotAlertPush',
            'ForumCopilot:ProcessAlertPush',
            ['collectedAlerts' => $collected],
            false
        );

        \ForumCopilot\Service\Alert\AlertPushCollector::clear();
    }

    /**
     * Process conversation messages queued during this request.
     * Runs at app_pub_complete when recipient rows have been committed.
     */
    protected static function processPendingConversationPushes()
    {
        if (empty(self::$pendingConversationPushes)) {
            return;
        }

        $appOptions = \XF::options();
        if (empty($appOptions->fc_push_enabled)) {
            \XF::logError('[FC PM] app_pub_complete: fc_push_enabled off — skipping ' . count(self::$pendingConversationPushes) . ' pending');
            self::$pendingConversationPushes = [];
            return;
        }

        try {
            $app = \XF::app();
            $em  = $app->em();
            $db  = \XF::db();

            foreach (self::$pendingConversationPushes as $p) {
                $conversationId = (int) $p['conversationId'];
                $senderId       = (int) $p['senderId'];
                $messageId      = (int) $p['messageId'];

                // 1. Recipients (from the now-committed conversation_recipient rows)
                $recipientIds = $db->fetchAllColumn(
                    "SELECT user_id FROM xf_conversation_recipient
                     WHERE conversation_id = ?
                     AND user_id != ?
                     AND recipient_state = 'active'",
                    [$conversationId, $senderId]
                );

                if (empty($recipientIds)) {
                    \XF::logError(sprintf(
                        '[FC PM] resolve conv=%d msg=%d — no recipients',
                        $conversationId, $messageId
                    ));
                    continue;
                }

                // 2. Filter to only users with the app installed (fresh xf_fc_user.last_seen)
                $cutoffTime = time() - (90 * 24 * 60 * 60);
                $placeholders = implode(',', array_fill(0, count($recipientIds), '?'));
                $appInstalledIds = $db->fetchAllColumn(
                    "SELECT user_id FROM xf_fc_user
                     WHERE user_id IN ($placeholders)
                     AND last_seen > ?",
                    array_merge($recipientIds, [$cutoffTime])
                );

                \XF::logError(sprintf(
                    '[FC PM] resolve conv=%d msg=%d — %d/%d recipients have app installed [%s]',
                    $conversationId, $messageId,
                    count($appInstalledIds), count($recipientIds),
                    implode(',', array_map('intval', $appInstalledIds))
                ));

                if (empty($appInstalledIds)) {
                    continue;
                }

                // 3. Load message + conversation for title/body/URL
                $message = $em->find('XF:ConversationMessage', $messageId);
                if (!$message) {
                    \XF::logError('[FC PM] SKIP — message not loadable id=' . $messageId);
                    continue;
                }
                $conversation = $message->Conversation;
                if (!$conversation) {
                    \XF::logError('[FC PM] SKIP — conversation not loadable id=' . $conversationId);
                    continue;
                }

                // Sender display name for title
                $sender = $em->find('XF:User', $senderId);
                $senderName = $sender ? (string) $sender->username : 'Someone';

                // Title = sender username; Body = message excerpt
                $title = $senderName;

                $rawBody = (string) $message->message;
                // Strip BB codes and HTML tags to get a plain-text preview
                $body = preg_replace('/\[\/?[^\]]+\]/', '', $rawBody);
                $body = trim(html_entity_decode(strip_tags($body), ENT_QUOTES | ENT_HTML5, 'UTF-8'));
                if (function_exists('mb_strlen') && mb_strlen($body, 'UTF-8') > 140) {
                    $body = mb_substr($body, 0, 140, 'UTF-8') . '…';
                } elseif (strlen($body) > 140) {
                    $body = substr($body, 0, 140) . '…';
                }
                if ($body === '') {
                    $body = 'New message';
                }

                // URL to the conversation
                $url = '';
                try {
                    $url = $app->router('public')->buildLink('canonical:conversations', $conversation);
                } catch (\Throwable $e) {
                    // fallback: raw conversation link
                    $url = $app->options()->boardUrl . '/conversations/' . $conversationId . '/';
                }

                // 4. Dispatch to all app-installed recipients via DispatchRouter
                $additionalData = [
                    'sender_id'       => $senderId,
                    'content_type'    => 'conversation_message',
                    'content_id'      => $messageId,
                    'action'          => 'insert',
                    'conversation_id' => $conversationId,
                    'event_date'      => time(),
                ];

                \XF::logError(sprintf(
                    '[FC PM] dispatching conv=%d msg=%d to %d user(s) title="%s" body_len=%d',
                    $conversationId, $messageId,
                    count($appInstalledIds),
                    $title,
                    strlen($body)
                ));

                $router = new \ForumCopilot\Service\Push\DispatchRouter();
                $router->dispatch(
                    array_values(array_map('intval', $appInstalledIds)),
                    $title,
                    $body,
                    $url,
                    $additionalData
                );
            }
        } catch (\Throwable $e) {
            \XF::logError('[FC PM] processPendingConversationPushes error: '
                . $e->getMessage() . ' at ' . $e->getFile() . ':' . $e->getLine());
        } finally {
            self::$pendingConversationPushes = [];
        }
    }

    /**
     * v8: no schema change, only Listener.php logic — collect at post_save,
     * resolve at app_pub_complete. Boot check just marks itself done.
     */
    protected static function bootCheck()
    {
        if (self::$bootChecked) {
            return;
        }
        self::$bootChecked = true;

        try {
            $reg = \XF::app()->registry();
            if ($reg->get('fcBootV10Done')) {
                return;
            }

            \XF::logError('[FC BOOT] v10 running: ensure PM entity_post_save listener');

            $db = \XF::db();
            $mutated = false;
            $required = [
                [
                    'method' => 'conversationMessageEntityPostSave',
                    'desc'   => 'Collect ConversationMessage inserts for deferred PM push',
                ],
            ];

            foreach ($required as $req) {
                $existing = $db->fetchOne(
                    "SELECT event_listener_id FROM xf_code_event_listener
                     WHERE callback_class = ?
                     AND callback_method = ?
                     AND event_id = ?",
                    ['ForumCopilot\\Listener', $req['method'], 'entity_post_save']
                );

                if ($existing) {
                    \XF::logError('[FC BOOT] ' . $req['method'] . ' listener present id=' . $existing);
                    continue;
                }

                $db->insert('xf_code_event_listener', [
                    'event_id'        => 'entity_post_save',
                    'execute_order'   => 10,
                    'callback_class'  => 'ForumCopilot\\Listener',
                    'callback_method' => $req['method'],
                    'active'          => 1,
                    'hint'            => '',
                    'description'     => $req['desc'],
                    'addon_id'        => 'ForumCopilot',
                ]);
                \XF::logError('[FC BOOT] INSERTED ' . $req['method'] . ' listener id=' . $db->lastInsertId());
                $mutated = true;
            }

            if ($mutated) {
                try {
                    $repo = \XF::repository('XF:CodeEventListener');
                    if (method_exists($repo, 'rebuildListenerCache')) {
                        $repo->rebuildListenerCache();
                        \XF::logError('[FC BOOT] rebuilt listener cache via repository');
                    }
                } catch (\Throwable $e) {
                    \XF::logError('[FC BOOT] cache rebuild warning: ' . $e->getMessage());
                }
            }

            $reg->set('fcBootV10Done', time());
            \XF::logError('[FC BOOT] v10 done');
        } catch (\Throwable $e) {
            \XF::logError('[FC BOOT] error: ' . $e->getMessage()
                . ' at ' . $e->getFile() . ':' . $e->getLine());
        }
    }

    /**
     * entity_post_save listener — just collects for later processing.
     * The recipient lookup is deferred to app_pub_complete where the
     * xf_conversation_recipient rows have been committed.
     */
    public static function conversationMessageEntityPostSave(\XF\Mvc\Entity\Entity $entity)
    {
        if (!($entity instanceof \XF\Entity\ConversationMessage)) {
            return;
        }

        try {
            $messageId = (int) $entity->message_id;
            if ($messageId <= 0) {
                return;
            }

            if (isset(self::$seenMessageIds[$messageId])) {
                return;
            }
            self::$seenMessageIds[$messageId] = true;

            $conversationId = (int) $entity->conversation_id;
            $senderId       = (int) $entity->user_id;

            \XF::logError(sprintf(
                '[FC PM] conversationMessageEntityPostSave: msg_id=%d conv=%d sender=%d — deferring recipient lookup',
                $messageId, $conversationId, $senderId
            ));

            if ($conversationId <= 0) {
                return;
            }

            self::$pendingConversationPushes[] = [
                'conversationId' => $conversationId,
                'senderId'       => $senderId,
                'messageId'      => $messageId,
            ];
        } catch (\Throwable $e) {
            \XF::logError('[FC PM] post_save error: ' . $e->getMessage()
                . ' at ' . $e->getFile() . ':' . $e->getLine());
        }
    }
}

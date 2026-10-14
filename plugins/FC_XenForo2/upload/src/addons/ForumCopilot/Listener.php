<?php

namespace ForumCopilot;

use XF;

class Listener
{
    protected static $bootChecked = false;
    protected static $seenMessageIds = [];

    /**
     * Collected during the request. Populated in
     * conversationMessageEntityPreSave (INSERT only); processed at
     * app_pub_complete (processBatchedAlerts) or app_api_complete
     * (apiRequestComplete) — by which time the message has been saved
     * (message_id / conversation_id populated) and the
     * xf_conversation_recipient rows are committed to the DB.
     *
     * This is the ONLY place a push for a new conversation or a reply is
     * produced, on XenForo 2.2 and 2.3 alike. It keys on the message insert,
     * not on XenForo's conversation notifier, so it sends once per message no
     * matter how many times the notifier runs. The XF 2.3 PusherService
     * extension leaves create/reply alone and only handles invites.
     *
     * Shape: [ ['entity' => \XF\Entity\ConversationMessage], ... ]
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

        \ForumCopilot\Util\Log::debug('[FC DEBUG] Listener.processBatchedAlerts: enqueuing job with ' . count($collected) . ' alert(s)');

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
     * app_api_complete listener. Conversations and replies created through
     * XenForo's own REST API (api.php) never reach app_pub_complete.
     */
    public static function apiRequestComplete()
    {
        self::processPendingConversationPushes();
    }

    /**
     * Process conversation messages queued during this request.
     * Runs at app_pub_complete / app_api_complete when recipient rows have
     * been committed.
     *
     * Deliberately not hooked to \XF::runOnce(): that also fires in CLI,
     * jobs and importers, and an import would push every historical message.
     */
    protected static function processPendingConversationPushes()
    {
        if (empty(self::$pendingConversationPushes)) {
            return;
        }

        $appOptions = \XF::options();
        if (empty($appOptions->fc_push_enabled)) {
            \ForumCopilot\Util\Log::debug('[FC PM] request complete: fc_push_enabled off — skipping ' . count(self::$pendingConversationPushes) . ' pending');
            self::$pendingConversationPushes = [];
            return;
        }

        try {
            $app = \XF::app();
            $em  = $app->em();
            $db  = \XF::db();

            foreach (self::$pendingConversationPushes as $p) {
                // Stashed at pre_save; by now the insert has committed so the
                // entity's message_id / conversation_id / user_id are populated.
                $pendingMessage = $p['entity'] ?? null;
                if (!$pendingMessage instanceof \XF\Entity\ConversationMessage) {
                    continue;
                }
                $conversationId = (int) $pendingMessage->conversation_id;
                $senderId       = (int) $pendingMessage->user_id;
                $messageId      = (int) $pendingMessage->message_id;

                if ($conversationId <= 0 || $messageId <= 0) {
                    \ForumCopilot\Util\Log::debug(sprintf(
                        '[FC PM] resolve — unsaved/bad ids conv=%d msg=%d, skipping',
                        $conversationId, $messageId
                    ));
                    continue;
                }

                // 1. Recipients (from the now-committed conversation_recipient rows)
                $recipientIds = $db->fetchAllColumn(
                    "SELECT user_id FROM xf_conversation_recipient
                     WHERE conversation_id = ?
                     AND user_id != ?
                     AND recipient_state = 'active'",
                    [$conversationId, $senderId]
                );

                if (empty($recipientIds)) {
                    \ForumCopilot\Util\Log::debug(sprintf(
                        '[FC PM] resolve conv=%d msg=%d — no recipients',
                        $conversationId, $messageId
                    ));
                    continue;
                }

                // 2. Keep users with the app installed (fresh xf_fc_user.last_seen)
                //    whom XenForo's own conversation notifier would push to:
                //    valid, not banned, "push_on_conversation" on. Also skip
                //    anyone ignoring the sender.
                $cutoffTime = time() - (90 * 24 * 60 * 60);
                $placeholders = implode(',', array_fill(0, count($recipientIds), '?'));
                $appInstalledIds = $db->fetchAllColumn(
                    "SELECT fc.user_id
                     FROM xf_fc_user AS fc
                     INNER JOIN xf_user AS u ON u.user_id = fc.user_id
                     INNER JOIN xf_user_option AS o ON o.user_id = fc.user_id
                     LEFT JOIN xf_user_ignored AS ig
                        ON ig.user_id = fc.user_id AND ig.ignored_user_id = ?
                     WHERE fc.user_id IN ($placeholders)
                     AND fc.last_seen > ?
                     AND u.user_state = 'valid'
                     AND u.is_banned = 0
                     AND o.push_on_conversation = 1
                     AND ig.user_id IS NULL",
                    array_merge([$senderId], $recipientIds, [$cutoffTime])
                );

                \ForumCopilot\Util\Log::debug(sprintf(
                    '[FC PM] resolve conv=%d msg=%d — %d/%d recipients have the app and accept DM pushes [%s]',
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
                    \ForumCopilot\Util\Log::debug('[FC PM] SKIP — message not loadable id=' . $messageId);
                    continue;
                }
                $conversation = $message->Conversation;
                if (!$conversation) {
                    \ForumCopilot\Util\Log::debug('[FC PM] SKIP — conversation not loadable id=' . $conversationId);
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

                \ForumCopilot\Util\Log::debug(sprintf(
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
     * v11: migrate the PM listener from entity_post_save to entity_pre_save so
     * $entity->isInsert() is reliable. On post_save isInsert() is always false
     * (Entity::save() runs _saveToSource() before firing the event), so a
     * ConversationMessage re-saved by a reaction/edit — which writes the
     * reaction cache and calls save() — was indistinguishable from a new
     * message and dispatched a phantom "new DM" push to the reactor. Drop the
     * old row and register the pre_save collector instead.
     */
    protected static function bootCheck()
    {
        if (self::$bootChecked) {
            return;
        }
        self::$bootChecked = true;

        try {
            $reg = \XF::app()->registry();
            if ($reg->get('fcBootV11Done')) {
                return;
            }

            \ForumCopilot\Util\Log::debug('[FC BOOT] v11 running: migrate PM listener post_save → pre_save + isInsert');

            $db = \XF::db();
            $mutated = false;

            // 1. Drop any existing PM listener rows (old post_save method OR the
            //    new pre_save method) so we can re-register cleanly.
            $obsolete = $db->fetchAll(
                "SELECT event_listener_id, event_id, callback_method
                 FROM xf_code_event_listener
                 WHERE callback_class = ?
                 AND callback_method IN (?, ?)",
                [
                    'ForumCopilot\\Listener',
                    'conversationMessageEntityPostSave',
                    'conversationMessageEntityPreSave',
                ]
            );
            foreach ($obsolete as $r) {
                $db->delete('xf_code_event_listener', 'event_listener_id = ?', $r['event_listener_id']);
                \ForumCopilot\Util\Log::debug(sprintf(
                    '[FC BOOT] deleted stale PM listener id=%d event=%s method=%s',
                    (int) $r['event_listener_id'], $r['event_id'], $r['callback_method']
                ));
                $mutated = true;
            }

            // 2. Register the PM collector on entity_pre_save.
            $db->insert('xf_code_event_listener', [
                'event_id'        => 'entity_pre_save',
                'execute_order'   => 10,
                'callback_class'  => 'ForumCopilot\\Listener',
                'callback_method' => 'conversationMessageEntityPreSave',
                'active'          => 1,
                'hint'            => '',
                'description'     => 'Collect ConversationMessage inserts for deferred PM push (pre_save so isInsert() is reliable)',
                'addon_id'        => 'ForumCopilot',
            ]);
            \ForumCopilot\Util\Log::debug('[FC BOOT] INSERTED conversationMessageEntityPreSave listener id=' . $db->lastInsertId());
            $mutated = true;

            if ($mutated) {
                try {
                    $repo = \XF::repository('XF:CodeEventListener');
                    if (method_exists($repo, 'rebuildListenerCache')) {
                        $repo->rebuildListenerCache();
                        \ForumCopilot\Util\Log::debug('[FC BOOT] rebuilt listener cache via repository');
                    }
                } catch (\Throwable $e) {
                    \XF::logError('[FC BOOT] cache rebuild warning: ' . $e->getMessage());
                }
            }

            $reg->set('fcBootV11Done', time());
            \ForumCopilot\Util\Log::debug('[FC BOOT] v11 done');
        } catch (\Throwable $e) {
            \XF::logError('[FC BOOT] error: ' . $e->getMessage()
                . ' at ' . $e->getFile() . ':' . $e->getLine());
        }
    }

    /**
     * entity_pre_save listener — collects genuinely NEW conversation messages
     * for a deferred PM push. The recipient lookup is deferred to
     * app_pub_complete, where the xf_conversation_recipient rows have been
     * committed and the entity's message_id / conversation_id are populated.
     *
     * MUST run on entity_pre_save (not post_save) so $entity->isInsert() is
     * reliable. Reacting to / liking / editing a DM re-saves the
     * ConversationMessage (XenForo writes the reaction_score / reactions /
     * reaction_users cache onto the message via
     * AbstractHandler::updateContentReactions() → $entity->save()). On the old
     * post_save listener that re-save — arriving in the reaction's OWN request,
     * so past the per-request dedup — dispatched a fresh "new PM" push whose
     * recipients exclude the message AUTHOR, i.e. include the reactor. Result:
     * the reactor got a phantom DM notification for their own reaction. At
     * post_save isInsert() is always false (Entity::save() runs _saveToSource()
     * before firing the event), so the guard only works here at pre_save.
     */
    public static function conversationMessageEntityPreSave(\XF\Mvc\Entity\Entity $entity)
    {
        if (!($entity instanceof \XF\Entity\ConversationMessage)) {
            return;
        }

        // Skip updates (reactions, edits, cache rebuilds) — only new messages notify.
        if (!$entity->isInsert()) {
            return;
        }

        try {
            // Dedupe within the request by object identity; message_id is not
            // assigned until after the insert commits, so we key on the entity.
            $key = spl_object_hash($entity);
            if (isset(self::$seenMessageIds[$key])) {
                return;
            }
            self::$seenMessageIds[$key] = true;

            \ForumCopilot\Util\Log::debug(sprintf(
                '[FC PM] conversationMessageEntityPreSave: INSERT sender=%d — deferring recipient lookup',
                (int) $entity->user_id
            ));

            // Stash the entity; by app_pub_complete it has been saved and
            // message_id / conversation_id are populated.
            self::$pendingConversationPushes[] = [
                'entity' => $entity,
            ];
        } catch (\Throwable $e) {
            \XF::logError('[FC PM] pre_save error: ' . $e->getMessage()
                . ' at ' . $e->getFile() . ':' . $e->getLine());
        }
    }
}

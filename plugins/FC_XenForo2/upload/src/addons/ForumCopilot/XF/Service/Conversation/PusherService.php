<?php

namespace ForumCopilot\XF\Service\Conversation;

use ForumCopilot\Push\ForumCopilotPush;

class PusherService extends XFCP_PusherService
{
    /**
     * Override push() to intercept conversation push notifications
     * and route them through ForumCopilot's push system
     */
    public function push()
    {
        // Unconditional trace at entry — proves the extension is being invoked
        try {
            $recvId = isset($this->receiver) && $this->receiver ? (int) $this->receiver->user_id : 0;
            $msgId = isset($this->message) && $this->message ? (int) $this->message->message_id : 0;
            \XF::logError('[FC PM TRACE] PusherService.push ENTRY recv=' . $recvId . ' msg_id=' . $msgId);
        } catch (\Throwable $ignore) {}

        // Call parent first to maintain XenForo's default behavior
        parent::push();

        // Check if push is enabled
        $options = $this->app->options();
        if (!isset($options->fc_push_enabled) || !$options->fc_push_enabled) {
            \XF::logError('[FC PM TRACE] gate=fc_push_enabled_off');
            return;
        }

        // Get conversation message and recipient
        $message = $this->message;
        $user = $this->receiver; // PusherTrait provides $this->receiver

        if (!$message || !$user) {
            \XF::logError('[FC PM TRACE] gate=message_or_user_null message='
                . ($message ? 'set' : 'null') . ' user=' . ($user ? 'set' : 'null'));
            return;
        }

        $conversation = $message->Conversation;
        if (!$conversation) {
            \XF::logError('[FC PM TRACE] gate=conversation_null recv=' . (int) $user->user_id);
            return;
        }

        // Check if user has app installed
        $alertRepo = $this->app->repository('XF:UserAlert');
        if (!$alertRepo->userHasAppInstalled($user->user_id)) {
            \XF::logError('[FC PM TRACE] gate=userHasAppInstalled_false recv=' . (int) $user->user_id);
            return;
        }

        // Check XenForo's default push_on_conversation preference (not FC opt-out)
        if (!$user->Option || !$user->Option->push_on_conversation) {
            \XF::logError('[FC PM TRACE] gate=push_on_conversation_off recv=' . (int) $user->user_id
                . ' hasOption=' . ($user->Option ? '1' : '0')
                . ' pushOnConv=' . ($user->Option ? ($user->Option->push_on_conversation ? '1' : '0') : 'n/a'));
            return;
        }

        // Check if user is ignoring the sender
        $sender = $this->sender;
        if ($sender && $user->isIgnoring($sender->user_id)) {
            \XF::logError('[FC PM TRACE] gate=ignoring_sender recv=' . (int) $user->user_id);
            return;
        }

        // Generate title, body, and URL using XenForo's handler system
        $notificationData = $this->extractConversationNotificationData($message, $user);

        if (!$notificationData || empty($notificationData['body'])) {
            \XF::logError('[FC PM TRACE] gate=empty_notificationData recv=' . (int) $user->user_id);
            return;
        }

        // Prepare additional data
        $senderId = $sender ? $sender->user_id : null;
        $contentType = 'conversation_message';
        $action = 'insert'; // XenForo uses 'insert' as the standard action for conversation messages
        
        $additionalData = [
            'sender_id' => $senderId,
            'content_type' => $contentType,
            'content_id' => $message->message_id,
            'action' => $action,
            'conversation_id' => $conversation->conversation_id,
            'event_date' => time()
        ];

        \XF::logError(sprintf(
            '[FC PM] PusherService.push fired for conv=%d recv=%d sender=%d',
            (int) $conversation->conversation_id,
            (int) $user->user_id,
            (int) ($senderId ?? 0)
        ));

        // Send push notification via hosted backend (BYO or ForumCopilot cloud)
        $fcPush = new ForumCopilotPush();
        $fcPush->sendPushNotification(
            [$user->user_id],
            $notificationData['title'],
            $notificationData['body'],
            $notificationData['url'],
            $additionalData
        );

        // Also enqueue for direct-mode dispatch (BYO Firebase).
        // ProcessAlertPush → AlertPushProcessor → DirectDispatcher is the same
        // chain used by reaction/mention alerts, so this delivers to the same
        // device tokens registered via /registerDevice with source=direct.
        // enqueueUnique dedupes by key across paths, so no double-push risk.
        try {
            $uniqueId = sprintf(
                'fcAlertPush_%d_%s_%d_%s',
                (int) $user->user_id,
                preg_replace('/[^a-zA-Z0-9_]/', '_', $contentType),
                (int) $conversation->conversation_id,
                preg_replace('/[^a-zA-Z0-9_]/', '_', $action)
            );

            \XF::app()->jobManager()->enqueueUnique(
                $uniqueId,
                \ForumCopilot\Job\ProcessAlertPush::class,
                [
                    'collectedAlerts' => [
                        [
                            'receiverId'  => (int) $user->user_id,
                            'senderId'    => (int) ($senderId ?? 0),
                            'contentType' => $contentType,
                            'contentId'   => (int) $conversation->conversation_id,
                            'action'      => $action,
                        ],
                    ],
                ],
                false
            );

            \XF::logError('[FC PM] enqueued direct-mode job ' . $uniqueId);
        } catch (\Throwable $e) {
            \XF::logError('[FC PM] direct-mode enqueue error: ' . $e->getMessage()
                . ' at ' . $e->getFile() . ':' . $e->getLine());
        }
    }

    /**
     * Extract Title, Body, URL from conversation message
     * Uses XenForo's default methods from parent class
     *
     * @param \XF\Entity\ConversationMessage $message
     * @param \XF\Entity\User $receiver
     * @return array|null ['title' => ..., 'body' => ..., 'url' => ...]
     */
    protected function extractConversationNotificationData($message, $receiver)
    {
        if (!$message || !$receiver) {
            return null;
        }

        // Use parent class methods which already generate title, body, and URL correctly
        // These methods use XenForo's phrase system and templates
        $title = $this->getNotificationTitle();
        $body = $this->getNotificationBody();
        $url = $this->getNotificationUrl();

        // Clean up the body (parent already returns clean text, but ensure it's properly formatted)
        $body = trim($body);

        if (empty($body)) {
            return null;
        }

        return [
            'title' => $title,
            'body' => $body,
            'url' => $url
        ];
    }

    /**
     * Override notification title to use just the board title
     * Instead of "New direct message at {boardTitle}" or "Reply to direct message at {boardTitle}"
     *
     * @return string
     */
    protected function getNotificationTitle()
    {
        return $this->app->options()->boardTitle;
    }
}


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
        // Call parent first to maintain XenForo's default behavior
        parent::push();

        // Check if push is enabled
        $options = $this->app->options();
        if (!isset($options->fc_push_enabled) || !$options->fc_push_enabled) {
            return;
        }

        // Get conversation message and recipient
        $message = $this->message;
        $user = $this->receiver; // PusherTrait provides $this->receiver

        if (!$message || !$user) {
            return;
        }

        $conversation = $message->Conversation;
        if (!$conversation) {
            return;
        }

        // Check if user has app installed
        $alertRepo = $this->app->repository('XF:UserAlert');
        if (!$alertRepo->userHasAppInstalled($user->user_id)) {
            return;
        }

        // Check XenForo's default push_on_conversation preference (not FC opt-out)
        if (!$user->Option || !$user->Option->push_on_conversation) {
            return;
        }

        // Check if user is ignoring the sender
        $sender = $this->sender;
        if ($sender && $user->isIgnoring($sender->user_id)) {
            return;
        }

        // Generate title, body, and URL using XenForo's handler system
        $notificationData = $this->extractConversationNotificationData($message, $user);
        
        if (!$notificationData || empty($notificationData['body'])) {
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

        // Send push notification
        $fcPush = new ForumCopilotPush();
        $fcPush->sendPushNotification(
            [$user->user_id],
            $notificationData['title'],
            $notificationData['body'],
            $notificationData['url'],
            $additionalData
        );
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


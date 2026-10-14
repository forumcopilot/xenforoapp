<?php

namespace ForumCopilot\XF\Service\Conversation;

/**
 * XenForo 2.3 only (2.2 names the class XF\Service\Conversation\Pusher, so this
 * extension never loads there).
 *
 * New conversations and replies are NOT pushed from here. They are pushed once
 * per message by ForumCopilot\Listener (entity_pre_save + request complete) on
 * every XenForo version. XenForo calls this service once per recipient each
 * time its conversation notifier runs, and the notifier can run more than once
 * for the same message, so pushing create/reply here as well sent the same DM
 * two or three times.
 *
 * What remains is the invite ("X added you to the direct message"): adding a
 * participant inserts no message, so the Listener never sees it.
 */
class PusherService extends XFCP_PusherService
{
    public function push()
    {
        // XenForo's own browser push, unchanged.
        parent::push();

        if ($this->actionType !== 'invite') {
            return;
        }

        $options = $this->app->options();
        if (empty($options->fc_push_enabled)) {
            return;
        }

        $message = $this->message;
        $user = $this->receiver;
        $sender = $this->sender;
        $conversation = $message ? $message->Conversation : null;

        if (!$user || !$conversation) {
            return;
        }

        // XenForo's notifier has already checked push_on_conversation, user
        // state, ban and sender != receiver before calling push().
        if (!$this->app->repository('XF:UserAlert')->userHasAppInstalled($user->user_id)) {
            \ForumCopilot\Util\Log::debug('[FC PM] invite push skipped — no app installed recv=' . (int) $user->user_id);
            return;
        }
        if ($sender && $user->isIgnoring($sender->user_id)) {
            return;
        }

        $body = trim($this->getNotificationBody());
        if ($body === '') {
            return;
        }

        $senderId = $sender ? (int) $sender->user_id : 0;

        \ForumCopilot\Util\Log::debug(sprintf(
            '[FC PM] invite push conv=%d recv=%d sender=%d',
            (int) $conversation->conversation_id,
            (int) $user->user_id,
            $senderId
        ));

        $router = new \ForumCopilot\Service\Push\DispatchRouter();
        $router->dispatch(
            [(int) $user->user_id],
            $sender ? (string) $sender->username : (string) $options->boardTitle,
            $body,
            (string) $this->getNotificationUrl(),
            [
                'sender_id'       => $senderId,
                'content_type'    => 'conversation_message',
                'content_id'      => (int) $message->message_id,
                'action'          => 'invite',
                'conversation_id' => (int) $conversation->conversation_id,
                'event_date'      => time(),
            ]
        );
    }
}

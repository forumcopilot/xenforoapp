<?php

namespace ForumCopilot\Service\Push;

/**
 * Which notification channel a push belongs in, so members can turn kinds
 * of notification on and off (and set their sound) in the phone's settings
 * instead of all or nothing:
 *
 *   messages   direct messages (new message, reply, invite)
 *   replies    replies in watched threads, new threads in watched forums,
 *              quotes and mentions, profile posts
 *   reactions  likes and reactions
 *   other      everything else (follows, trophies, reports, ...)
 *
 * The app creates one Android channel per kind; androidId() names them.
 * Every push carries the kind in data.channel (DispatchRouter), on the
 * hosted path too.
 */
class Channel
{
    public const MESSAGES = 'messages';
    public const REPLIES = 'replies';
    public const REACTIONS = 'reactions';
    public const OTHER = 'other';

    /**
     * The kind of a push from its content_type and action (XenForo's alert
     * fields, or the add-on's own direct-message pushes).
     */
    public static function forData(array $data): string
    {
        $type = (string)($data['content_type'] ?? '');
        $action = (string)($data['action'] ?? '');

        if ($type === 'conversation_message' || $type === 'conversation')
        {
            return self::MESSAGES;
        }
        if ($action === 'reaction' || $action === 'like')
        {
            return self::REACTIONS;
        }
        if ($action === 'quote' || $action === 'mention')
        {
            return self::REPLIES;
        }
        if (in_array($type, ['post', 'thread', 'profile_post', 'profile_post_comment'], true)
            && in_array($action, ['insert', 'reply', 'thread_reply', 'tag'], true))
        {
            return self::REPLIES;
        }

        return self::OTHER;
    }

    /**
     * The Android channel id the app creates for [$channel]. "other" keeps
     * the channel every earlier version used, which older app builds have;
     * a push naming a channel the installed app lacks falls back to it.
     */
    public static function androidId(string $channel): string
    {
        switch ($channel)
        {
            case self::MESSAGES:
                return 'fc_messages';
            case self::REPLIES:
                return 'fc_replies';
            case self::REACTIONS:
                return 'fc_reactions';
            default:
                return 'forum_copilot_channel';
        }
    }
}

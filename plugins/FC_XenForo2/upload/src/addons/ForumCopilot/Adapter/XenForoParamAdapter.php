<?php

namespace ForumCopilot\Adapter;

use XF\Mvc\ParameterBag;
use ForumCopilot\Params\Forum\FCGetForumParams;
use ForumCopilot\Params\Forum\FCMarkAllAsReadParams;
use ForumCopilot\Params\Forum\FCGetForumStatusParams;
use ForumCopilot\Params\Topic\FCGetTopicParams;
use ForumCopilot\Params\Topic\FCNewTopicParams;
use ForumCopilot\Params\Topic\FCGetTopTopicParams;
use ForumCopilot\Params\Topic\FCGetAnnTopicParams;
use ForumCopilot\Params\Topic\FCGetLatestTopicParams;
use ForumCopilot\Params\Topic\FCGetParticipatedTopicParams;
use ForumCopilot\Params\Topic\FCGetTopicByIdsParams;
use ForumCopilot\Params\Account\FCLoginParams;
use ForumCopilot\Params\Account\FCUpdatePasswordParams;
use ForumCopilot\Params\Account\FCUpdateEmailParams;
use ForumCopilot\Params\Account\FCUpdateProfileParams;
use ForumCopilot\Params\User\FCGetUserInfoParams;
use ForumCopilot\Params\User\FCSearchUserParams;
use ForumCopilot\Params\User\FCGetOnlineUsersParams;
use ForumCopilot\Params\User\FCGetUserReplyPostParams;
use ForumCopilot\Params\Post\FCGetThreadParams;
use ForumCopilot\Params\Post\FCReplyPostParams;
use ForumCopilot\Params\Post\FCReplyPostParamsExtended;
use ForumCopilot\Params\Search\FCSearchParams;
use ForumCopilot\Params\Search\FCSearchTopicParams;
use ForumCopilot\Params\Social\FCLikePostParams;
use ForumCopilot\Params\Social\FCFollowUserParams;
use ForumCopilot\Params\Social\FCGetAlertParams;
use ForumCopilot\Params\Subscription\FCSubscribeForumParams;
use ForumCopilot\Params\Subscription\FCSubscribeTopicParams;
use ForumCopilot\Params\Subscription\FCSubscribeForumParamsExtended;
use ForumCopilot\Params\Moderation\FCModerateTopicParams;
use ForumCopilot\Params\Moderation\FCModeratePostParams;

/**
 * XenForo-specific adapter for converting ParameterBag to forum-agnostic parameter classes
 * This class is XenForo-specific and should not be copied to other forum plugins
 */
class XenForoParamAdapter
{
    /**
     * Convert ParameterBag to FCGetForumParams
     */
    public static function toGetForumParams(ParameterBag $params): FCGetForumParams
    {
        return FCGetForumParams::fromArray([
            'returnDescription' => self::toBool($params->get('returnDescription', true)),
            'forumId' => $params->get('forumId', ''),
        ]);
    }

    /**
     * Convert string/boolean to boolean
     */
    private static function toBool($value): bool
    {
        if (is_bool($value)) {
            return $value;
        }
        if (is_string($value)) {
            return in_array(strtolower($value), ['true', '1', 'yes', 'on'], true);
        }
        return (bool)$value;
    }

    /**
     * Convert ParameterBag to FCMarkAllAsReadParams
     */
    public static function toMarkAllAsReadParams(ParameterBag $params): FCMarkAllAsReadParams
    {
        $date = $params->get('date', null);
        if ($date !== null) {
            $date = (int)$date;
        }
        
        return FCMarkAllAsReadParams::fromArray([
            'forumId' => $params->get('forumId', null),
            'date' => $date,
        ]);
    }

    /**
     * Convert ParameterBag to FCGetForumStatusParams
     */
    public static function toGetForumStatusParams(ParameterBag $params): FCGetForumStatusParams
    {
        return FCGetForumStatusParams::fromArray([
            'forumIds' => $params->get('forumIds', []),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetTopicParams
     */
    public static function toGetTopicParams(ParameterBag $params): FCGetTopicParams
    {
        return FCGetTopicParams::fromArray([
            'forumId' => $params->get('forumId', ''),
            'startNum' => $params->get('startNum', 0),
            'lastNum' => $params->get('lastNum', 19),
        ]);
    }

    /**
     * Convert ParameterBag to FCNewTopicParams
     */
    public static function toNewTopicParams(ParameterBag $params): FCNewTopicParams
    {
        return FCNewTopicParams::fromArray([
            'forumId' => $params->get('forumId', ''),
            'title' => $params->get('subject', $params->get('title', '')),
            'textBody' => $params->get('textBody', ''),
            'prefixId' => $params->get('prefixId', ''),
            'attachmentIds' => $params->get('attachmentIds', []),
            'groupId' => $params->get('groupId', null),
            'isPoll' => $params->get('isPoll', false),
            'pollQuestion' => $params->get('pollQuestion', null),
            'pollOptions' => $params->get('pollOptions', []),
        ]);
    }

    /**
     * Convert ParameterBag to FCLoginParams
     */
    public static function toLoginParams(ParameterBag $params): FCLoginParams
    {
        return FCLoginParams::fromArray([
            'loginname' => $params->get('loginname', ''),
            'password' => $params->get('password', ''),
            'anonymous' => $params->get('anonymous', false),
            'trustCode' => $params->get('trustCode', null),
            'tfaCode' => $params->get('tfaCode', null),
            'tfaProvider' => $params->get('tfaProvider', null),
            'trustDevice' => $params->get('trustDevice', false),
            'remember' => $params->get('remember', true),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetThreadParams
     */
    public static function toGetThreadParams(ParameterBag $params): FCGetThreadParams
    {
        return FCGetThreadParams::fromArray([
            'topicId' => $params->get('topicId', ''),
            'startNum' => $params->get('startNum', 0),
            'lastNum' => $params->get('lastNum', 19),
            'returnHtml' => $params->get('returnHtml', true),
        ]);
    }

    /**
     * Convert ParameterBag to FCReplyPostParams
     */
    public static function toReplyPostParams(ParameterBag $params): FCReplyPostParams
    {
        return FCReplyPostParams::fromArray([
            'topicId' => $params->get('topicId', ''),
            'textBody' => $params->get('textBody', ''),
            'attachmentIds' => $params->get('attachmentIds', []),
            'groupId' => $params->get('groupId', null),
            'quotePostId' => $params->get('quotePostId', null),
        ]);
    }

    /**
     * Convert ParameterBag to FCSearchParams
     */
    public static function toSearchParams(ParameterBag $params): FCSearchParams
    {
        return FCSearchParams::fromArray([
            'keywords' => $params->get('keywords', ''),
            'page' => $params->get('page', 1),
            'perpage' => $params->get('perpage', 20),
            'searchId' => $params->get('searchId', null),
            'titleOnly' => $params->get('titleOnly', false),
            'userId' => $params->get('userId', null),
            'searchUser' => $params->get('searchUser', null),
            'forumId' => $params->get('forumId', null),
            'topicId' => $params->get('topicId', null),
            'onlyIn' => $params->get('onlyIn', []),
            'notIn' => $params->get('notIn', []),
            'startedBy' => $params->get('startedBy', false),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetUserInfoParams
     */
    public static function toGetUserInfoParams(ParameterBag $params): FCGetUserInfoParams
    {
        return FCGetUserInfoParams::fromArray([
            'username' => $params->get('username', ''),
            'userId' => $params->get('userId', ''),
        ]);
    }

    /**
     * Convert ParameterBag to FCSearchUserParams
     */
    public static function toSearchUserParams(ParameterBag $params): FCSearchUserParams
    {
        return FCSearchUserParams::fromArray([
            'keywords' => $params->get('keywords', ''),
            'page' => $params->get('page', 1),
            'perpage' => $params->get('perpage', 20),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetUserReplyPostParams
     */
    public static function toGetUserReplyPostParams(ParameterBag $params): FCGetUserReplyPostParams
    {
        return FCGetUserReplyPostParams::fromArray([
            'startNum' => (int)$params->get('startNum', 0),
            'lastNum' => (int)$params->get('lastNum', 10),
            'searchId' => $params->get('searchId', ''),
            'username' => $params->get('username', ''),
            'userId' => $params->get('userId', ''),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetOnlineUsersParams
     */
    public static function toGetOnlineUsersParams(ParameterBag $params): FCGetOnlineUsersParams
    {
        return FCGetOnlineUsersParams::fromArray([
            'page' => $params->get('page', 1),
            'perpage' => $params->get('perpage', 20),
            'id' => $params->get('id', ''),
            'area' => $params->get('area', ''),
        ]);
    }

    /**
     * Convert ParameterBag to FCUpdatePasswordParams
     */
    public static function toUpdatePasswordParams(ParameterBag $params): FCUpdatePasswordParams
    {
        return FCUpdatePasswordParams::fromArray([
            'currentPassword' => $params->get('currentPassword', ''),
            'newPassword' => $params->get('newPassword', ''),
            'confirmPassword' => $params->get('confirmPassword', ''),
        ]);
    }

    /**
     * Convert ParameterBag to FCUpdateEmailParams
     */
    public static function toUpdateEmailParams(ParameterBag $params): FCUpdateEmailParams
    {
        return FCUpdateEmailParams::fromArray([
            'newEmail' => $params->get('newEmail', ''),
            'password' => $params->get('password', ''),
        ]);
    }

    /**
     * Convert ParameterBag to FCUpdateProfileParams
     */
    public static function toUpdateProfileParams(ParameterBag $params): FCUpdateProfileParams
    {
        return FCUpdateProfileParams::fromArray([
            'profileFields' => $params->get('profileFields', []),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetTopTopicParams
     */
    public static function toGetTopTopicParams(ParameterBag $params): FCGetTopTopicParams
    {
        return FCGetTopTopicParams::fromArray([
            'forumId' => $params->get('forumId', ''),
            'startNum' => $params->get('startNum', 0),
            'lastNum' => $params->get('lastNum', 19),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetAnnTopicParams
     */
    public static function toGetAnnTopicParams(ParameterBag $params): FCGetAnnTopicParams
    {
        return FCGetAnnTopicParams::fromArray([
            'forumId' => $params->get('forumId', ''),
            'startNum' => $params->get('startNum', 0),
            'lastNum' => $params->get('lastNum', 19),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetLatestTopicParams
     */
    public static function toGetLatestTopicParams(ParameterBag $params): FCGetLatestTopicParams
    {
        return FCGetLatestTopicParams::fromArray([
            'startNum' => $params->get('startNum', 0),
            'lastNum' => $params->get('lastNum', 19),
            'searchId' => $params->get('searchId', ''),
            'filters' => $params->get('filters', []),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetParticipatedTopicParams
     */
    public static function toGetParticipatedTopicParams(ParameterBag $params): FCGetParticipatedTopicParams
    {
        return FCGetParticipatedTopicParams::fromArray([
            'userId' => $params->get('userId', ''),
            'username' => $params->get('username', ''),
            'startNum' => $params->get('startNum', 0),
            'lastNum' => $params->get('lastNum', 19),
            'searchId' => $params->get('searchId', ''),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetTopicByIdsParams
     */
    public static function toGetTopicByIdsParams(ParameterBag $params): FCGetTopicByIdsParams
    {
        return FCGetTopicByIdsParams::fromArray([
            'topicIds' => $params->get('topicIds', []),
        ]);
    }

    /**
     * Convert ParameterBag to FCReplyPostParamsExtended
     */
    public static function toReplyPostParamsExtended(ParameterBag $params): FCReplyPostParamsExtended
    {
        return FCReplyPostParamsExtended::fromArray([
            'forumId' => $params->get('forumId', ''),
            'topicId' => $params->get('topicId', ''),
            'subject' => $params->get('subject', ''),
            'textBody' => $params->get('textBody', ''),
            'attachmentIds' => $params->get('attachmentIds', []),
            'groupId' => $params->get('groupId', ''),
            'returnHtml' => $params->get('returnHtml', true),
        ]);
    }

    /**
     * Convert ParameterBag to FCSearchTopicParams
     */
    public static function toSearchTopicParams(ParameterBag $params): FCSearchTopicParams
    {
        return FCSearchTopicParams::fromArray([
            'searchString' => $params->get('searchString', ''),
            'startNum' => $params->get('startNum', 0),
            'lastNum' => $params->get('lastNum', 19),
            'searchId' => $params->get('searchId', ''),
        ]);
    }

    /**
     * Convert ParameterBag to FCLikePostParams
     */
    public static function toLikePostParams(ParameterBag $params): FCLikePostParams
    {
        return FCLikePostParams::fromArray([
            'postId' => $params->get('postId', ''),
            'like' => $params->get('like', true),
            'reactionId' => $params->get('reactionId', 1),
        ]);
    }

    /**
     * Convert ParameterBag to FCFollowUserParams
     */
    public static function toFollowUserParams(ParameterBag $params): FCFollowUserParams
    {
        return FCFollowUserParams::fromArray([
            'userId' => $params->get('userId', ''),
            'follow' => $params->get('follow', true),
        ]);
    }

    /**
     * Convert ParameterBag to FCGetAlertParams
     */
    public static function toGetAlertParams(ParameterBag $params): FCGetAlertParams
    {
        return FCGetAlertParams::fromArray([
            'page' => $params->get('page', 1),
            'perpage' => $params->get('perpage', 20),
            'unreadOnly' => $params->get('unreadOnly', false),
        ]);
    }

    /**
     * Convert ParameterBag to FCSubscribeForumParams
     */
    public static function toSubscribeForumParams(ParameterBag $params): FCSubscribeForumParams
    {
        return FCSubscribeForumParams::fromArray([
            'forumId' => $params->get('forumId', ''),
            'subscribe' => $params->get('subscribe', true),
        ]);
    }

    /**
     * Convert ParameterBag to FCSubscribeTopicParams
     */
    public static function toSubscribeTopicParams(ParameterBag $params): FCSubscribeTopicParams
    {
        return FCSubscribeTopicParams::fromArray([
            'topicId' => $params->get('topicId', ''),
            'subscribe' => $params->get('subscribe', true),
        ]);
    }

    /**
     * Convert ParameterBag to FCSubscribeForumParamsExtended
     */
    public static function toSubscribeForumParamsExtended(ParameterBag $params): FCSubscribeForumParamsExtended
    {
        return FCSubscribeForumParamsExtended::fromArray([
            'forumId' => $params->get('forumId', ''),
            'subscribeMode' => $params->get('subscribeMode', 0),
        ]);
    }

    /**
     * Convert ParameterBag to FCModerateTopicParams
     */
    public static function toModerateTopicParams(ParameterBag $params): FCModerateTopicParams
    {
        return FCModerateTopicParams::fromArray([
            'topicId' => $params->get('topicId', ''),
            'action' => $params->get('action', ''),
        ]);
    }

    /**
     * Convert ParameterBag to FCModeratePostParams
     */
    public static function toModeratePostParams(ParameterBag $params): FCModeratePostParams
    {
        return FCModeratePostParams::fromArray([
            'postId' => $params->get('postId', ''),
            'action' => $params->get('action', ''),
        ]);
    }
}

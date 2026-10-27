<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCStickTopicResult;
use ForumCopilot\Result\FCCloseTopicResult;
use ForumCopilot\Result\FCDeleteTopicResult;
use ForumCopilot\Result\FCDeletePostResult;
use ForumCopilot\Result\FCUndeleteTopicResult;
use ForumCopilot\Result\FCUndeletePostResult;
use ForumCopilot\Result\FCMoveTopicResult;
use ForumCopilot\Result\FCRenameTopicResult;
use ForumCopilot\Result\FCApproveTopicResult;
use ForumCopilot\Result\FCApprovePostResult;
use ForumCopilot\Result\FCBanUserResult;
use ForumCopilot\Result\FCUnbanUserResult;
use ForumCopilot\Result\FCSpamCleanUserResult;
use ForumCopilot\Adapter\XenForoParamAdapter;

// Explicitly require FCModerationResult.php which contains multiple Result classes
// This ensures all classes in that file are loaded
require_once(__DIR__ . '/../../Result/FCModerationResult.php');

/**
 * Moderation Controller for ForumCopilot API
 * Handles moderation operations
 */
class ModerationController extends AbstractController
{
    /**
     * Moderators sign in with login like every member: it runs XenForo's
     * whole sign-in (two-step verification, login limits, the login log),
     * and the moderator tools then follow the account's own permissions.
     * This method signed in with the password alone, and no app calls it
     * (the 1.x SDK's doLoginModAsync never reaches the server), so it now
     * answers with a pointer to login and signs nobody in.
     */
    public function actionDoLoginMod(ParameterBag $params)
    {
        return $this->apiError(
            'Moderator sign-in is not used: sign in with login. Moderator tools follow the permissions of the signed-in account.',
            null,
            ErrorCode::BAD_REQUEST
        );
    }

    public function actionStickTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        
        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canStickUnstick($error)) {
                return $this->apiError('Cannot stick this topic' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's standard approach: directly set sticky and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            $thread->sticky = true;
            $thread->save();

            $result = new FCStickTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to stick topic');
        }
    }

    public function actionUnstickTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canStickUnstick($error)) {
                return $this->apiError('Cannot unstick this topic' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's standard approach: directly set sticky and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            $thread->sticky = false;
            $thread->save();

            $result = new FCStickTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to unstick topic');
        }
    }

    public function actionCloseTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canLockUnlock($error)) {
                return $this->apiError('Cannot close this topic' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Check if thread is a redirect (redirects cannot be locked)
            if ($thread->discussion_type == 'redirect') {
                return $this->apiError('Cannot lock redirect threads', null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's standard approach: directly set discussion_open and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            $thread->discussion_open = false;
            $thread->save();

            $result = new FCCloseTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to close topic');
        }
    }

    public function actionUncloseTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canLockUnlock($error)) {
                return $this->apiError('Cannot open this topic' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Check if thread is a redirect (redirects cannot be unlocked)
            if ($thread->discussion_type == 'redirect') {
                return $this->apiError('Cannot unlock redirect threads', null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's standard approach: directly set discussion_open and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            $thread->discussion_open = true;
            $thread->save();

            $result = new FCCloseTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to open topic');
        }
    }

    public function actionDeleteTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $hardDelete = $params->get('hardDelete', false);
        $reason = $params->get('reason', '');
        $starterAlert = $params->get('starterAlert', false);
        $starterAlertReason = $params->get('starterAlertReason', '');

        // Backward compatibility: support old 'mode' parameter
        // mode: 0 = soft delete, 1 = hard delete
        $mode = $params->get('mode', null);
        if ($mode !== null) {
            $hardDelete = ($mode == 1);
        }

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            // Determine delete type
            $type = $hardDelete ? 'hard' : 'soft';

            // Check permissions for the specific delete type
            if (!$thread->canDelete($type, $error)) {
                return $this->apiError('Cannot delete this topic' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's Thread Deleter service (standard way to delete threads)
            /** @var \XF\Service\Thread\Deleter $deleter */
            $deleter = $this->service('XF:Thread\Deleter', $thread);

            // Set alert if requested
            if ($starterAlert) {
                $deleter->setSendAlert(true, $starterAlertReason);
            }

            // Perform deletion
            $deleter->delete($type, $reason);

            $result = new FCDeleteTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to delete topic');
        }
    }

    public function actionDeletePost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');
        $hardDelete = $params->get('hardDelete', false);
        $reason = $params->get('reason', '');

        // Backward compatibility: support old 'mode' parameter
        // mode: 0 = soft delete, 1 = hard delete
        $mode = $params->get('mode', null);
        if ($mode !== null) {
            $hardDelete = ($mode == 1);
        }

        if (empty($postId)) {
            return $this->apiError('Post ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $post = $this->assertViewablePost($postId);
            $visitor = \XF::visitor();

            // Determine delete type
            $type = $hardDelete ? 'hard' : 'soft';

            // Check permissions for the specific delete type
            if (!$post->canDelete($type, $error)) {
                return $this->apiError('Cannot delete this post' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's Post Deleter service
            /** @var \XF\Service\Post\Deleter $deleter */
            $deleter = $this->service('XF:Post\Deleter', $post);
            $deleter->delete($type, $reason);

            $result = new FCDeletePostResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to delete post');
        }
    }

    public function actionUndeleteTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // The thread must be viewable first, as in XenForo's
            // ThreadController::actionUndelete; moderators see deleted
            // threads with the "View deleted threads" permission.
            $thread = $this->assertViewableThread($topicId);

            $visitor = \XF::visitor();

            if (!$thread->canUndelete($error)) {
                return $this->apiError('Cannot undelete this topic' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Check if thread is actually deleted (matches XenForo core InlineMod approach)
            if ($thread->discussion_state != 'deleted') {
                return $this->apiError('Topic is not deleted', null, ErrorCode::VALIDATION);
            }

            // Use XenForo's standard approach: directly set state and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            // Moderator log is automatically created when state changes from 'deleted' to 'visible'
            $thread->discussion_state = 'visible';
            $thread->save();

            $result = new FCUndeleteTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to undelete topic');
        }
    }

    public function actionUndeletePost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // The post must be viewable first, as in XenForo's
            // PostController::actionUndelete
            $post = $this->assertViewablePost($postId);

            $visitor = \XF::visitor();

            if (!$post->canUndelete($error)) {
                return $this->apiError('Cannot undelete this post' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // For undeleting, directly set message_state (as XenForo core does in InlineMod)
            // The entity's _postSave will handle all the necessary updates
            if ($post->message_state == 'deleted') {
                $post->message_state = 'visible';
                $post->save();
            }

            $result = new FCUndeletePostResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to undelete post');
        }
    }

    public function actionMoveTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $forumId = $params->get('forumId', '');
        $redirect = $params->get('redirect', false);

        if (empty($topicId) || empty($forumId)) {
            return $this->apiError('Topic ID and Forum ID are required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $forum = $this->assertViewableForum($forumId);
            $visitor = \XF::visitor();

            if (!$thread->canMove()) {
                return $this->apiError('Cannot move this topic', null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's Thread Mover service
            /** @var \XF\Service\Thread\Mover $mover */
            $mover = $this->service('XF:Thread\Mover', $thread);
            
            // Set redirect if requested
            if ($redirect) {
                $mover->setRedirect(true);
            }
            
            // Move thread (this handles validation internally and throws PrintableException on error)
            $mover->move($forum);

            $result = new FCMoveTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to move topic');
        }
    }

    public function actionRenameTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $title = $params->get('title', '');

        if (empty($topicId) || empty($title)) {
            return $this->apiError('Topic ID and title are required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canEdit()) {
                return $this->apiError('Cannot rename this topic', null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's Thread Editor service
            /** @var \XF\Service\Thread\Editor $editor */
            $editor = $this->service('XF:Thread\Editor', $thread);
            $editor->setTitle($title);

            if (!$editor->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors), null, ErrorCode::VALIDATION);
            }

            $editor->save();

            $result = new FCRenameTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to rename topic');
        }
    }

    public function actionApproveTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canApproveUnapprove($error)) {
                return $this->apiError('Cannot approve this topic' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Approving only lifts moderation; a deleted thread is restored
            // with undeleteTopic, which checks the undelete permission
            if ($thread->discussion_state == 'deleted') {
                return $this->apiError('This topic is deleted; undelete it instead', null, ErrorCode::VALIDATION);
            }

            // XenForo's Thread Approver, as ThreadController::actionApprove
            // and the approval queue use: it approves only a moderated thread
            // (an already visible one is left as it is), and then alerts the
            // forum's watchers and the members mentioned or quoted in the
            // first post.
            $this->approveThread($thread);

            $result = new FCApproveTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to approve topic');
        }
    }

    public function actionApprovePost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $post = $this->assertViewablePost($postId);
            $visitor = \XF::visitor();

            if (!$post->canApproveUnapprove($error)) {
                return $this->apiError('Cannot approve this post' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's Post Approver service (like core does)
            if ($post->isFirstPost()) {
                // For first post, approve the thread instead, with the
                // Thread Approver as XenForo's approval queue does
                $this->approveThread($post->Thread);
            } else if ($post->message_state == 'moderated') {
                /** @var \XF\Service\Post\Approver $approver */
                $approver = $this->service('XF:Post\Approver', $post);
                $approver->setNotifyRunTime(1);
                $approver->approve();
            }

            $result = new FCApprovePostResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to approve post');
        }
    }

    public function actionBanUser(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userName = $params->get('userName', '');
        $reason = $params->get('reason', '');
        
        // New parameters matching web interface
        $banLength = $params->get('banLength', 'permanent');
        $endDateStr = $params->get('endDate', '');
        
        // Backward compatibility: support old banExpires parameter
        $banExpires = $params->get('banExpires', 0);

        if (empty($userName)) {
            return $this->apiError('Username is required', null, ErrorCode::VALIDATION);
        }

        try {
            $user = $this->em()->findOne('XF:User', ['username' => $userName]);
            if (!$user) {
                return $this->apiError('User not found', null, ErrorCode::NOT_FOUND);
            }

            $visitor = \XF::visitor();

            if (!$user->canBan($error)) {
                return $this->apiError('Cannot ban this user' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Determine end date based on parameters
            $endDate = 0; // Default to permanent ban
            
            // Priority: banLength/endDate > banExpires (for backward compatibility)
            if ($banLength === 'temporary') {
                // For temporary ban, endDate is required
                if (empty($endDateStr)) {
                    return $this->apiError('End date is required when banLength is "temporary"', null, ErrorCode::VALIDATION);
                }
                // Parse the end date string (supports formats like "2025-12-21" or "2025-12-21 23:59:59")
                $endDateTimestamp = strtotime($endDateStr);
                if ($endDateTimestamp === false) {
                    return $this->apiError('Invalid end date format. Use format: YYYY-MM-DD or YYYY-MM-DD HH:MM:SS', null, ErrorCode::VALIDATION);
                }
                if ($endDateTimestamp <= time()) {
                    return $this->apiError('End date must be in the future', null, ErrorCode::VALIDATION);
                }
                $endDate = $endDateTimestamp;
            } elseif ($banLength === 'permanent' || empty($banLength)) {
                // Permanent ban
                $endDate = 0;
            } elseif ($banExpires > 0) {
                // Backward compatibility: banExpires is number of seconds from now
                $endDate = \XF::$time + $banExpires;
            }

            // Use XenForo's BanningRepository to ban user
            $banningRepo = $this->repository('XF:Banning');
            
            if (!$banningRepo->banUser($user, $endDate, $reason, $error, $visitor)) {
                return $this->apiError('Failed to ban user: ' . ($error ? $error : 'Unknown error'), null, ErrorCode::VALIDATION);
            }

            $result = new FCBanUserResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to ban user');
        }
    }

    public function actionUnbanUser(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Support both userId and userName for consistency with ban function
        $userId = $params->get('userId', '');
        $userName = $params->get('userName', '');

        if (empty($userId) && empty($userName)) {
            return $this->apiError('User ID or username is required', null, ErrorCode::BAD_REQUEST);
        }
        // A non-numeric "userId" is a username (the SDK's unbanUserAsync has a
        // single identifier parameter; banUserAsync takes a username).
        if (!empty($userId) && !is_numeric($userId) && empty($userName)) {
            $userName = $userId;
            $userId = '';
        }

        try {
            // Find user by ID or username
            if (!empty($userId)) {
                $user = $this->em()->find('XF:User', $userId);
            } else {
                $user = $this->em()->findOne('XF:User', ['username' => $userName]);
            }

            if (!$user) {
                return $this->apiError('User not found', null, ErrorCode::NOT_FOUND);
            }

            // Check if user is actually banned
            if (!$user->is_banned) {
                return $this->apiError('User is not banned', null, ErrorCode::VALIDATION);
            }

            // Check if user has a ban record
            if (!$user->Ban) {
                return $this->apiError('User ban record not found', null, ErrorCode::NOT_FOUND);
            }

            $visitor = \XF::visitor();

            // Check permissions - need ban permission to unban
            if (!$user->canBan($error)) {
                return $this->apiError('Cannot unban this user' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Remove ban - deleting the ban entity will automatically update user.is_banned via _postDelete
            // Use the User relation directly like XenForo core does
            $user->Ban->delete();

            $result = new FCUnbanUserResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to unban user');
        }
    }

    public function actionSpamCleanUser(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Get parameters
        $userId = $params->get('userId', '');
        $username = $params->get('username', '');
        
        // Validate that we have either userId or username
        if (empty($userId) && empty($username)) {
            return $this->apiError('Either userId or username is required', null, ErrorCode::BAD_REQUEST);
        }

        // Get spam cleaner actions (all optional, default to false)
        $actions = [
            'action_threads' => $params->get('actionThreads', false),
            'delete_messages' => $params->get('deleteMessages', false),
            'delete_conversations' => $params->get('deleteConversations', false),
            'ban_user' => $params->get('banUser', false),
        ];

        // Convert boolean strings to actual booleans
        foreach ($actions as $key => $value) {
            $actions[$key] = filter_var($value, FILTER_VALIDATE_BOOLEAN);
        }

        try {
            // Find user
            $user = null;
            if (!empty($userId)) {
                $user = $this->em()->find('XF:User', (int)$userId);
            } elseif (!empty($username)) {
                $user = $this->em()->findOne('XF:User', ['username' => $username]);
            }

            if (!$user) {
                return $this->apiError('User not found', null, ErrorCode::NOT_FOUND);
            }

            $visitor = \XF::visitor();

            // Check permission to clean spam
            if (!$visitor->canCleanSpam()) {
                return $this->apiError('You do not have permission to use the spam cleaner', 403, ErrorCode::NO_PERMISSION);
            }

            // Check if user is a possible spammer
            if (!$user->isPossibleSpammer($error)) {
                return $this->apiError('User cannot be spam cleaned: ' . ($error ?: 'User does not meet spam criteria'), 400, ErrorCode::NO_PERMISSION);
            }

            // Perform spam cleanup
            $cleaner = $this->app->spam()->cleaner($user);
            $cleaner->cleanUp($actions);

            // Finalize (commits transaction and writes log)
            if (!$cleaner->finalize()) {
                $errors = $cleaner->getErrors();
                return $this->apiError('Spam cleanup failed: ' . implode(', ', $errors), 500, ErrorCode::VALIDATION);
            }

            // Create result object
            $result = new FCSpamCleanUserResult(
                true,
                null,
                [
                    'userId' => (string)$user->user_id,
                    'username' => $user->username,
                    'actions' => $actions,
                ]
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to spam clean user');
        }
    }

    /**
     * Approve a moderated thread with XenForo's Thread Approver, as
     * ThreadController::actionApprove and the approval queue do: it does
     * nothing unless the thread is awaiting approval, and then notifies the
     * forum's watchers and the members mentioned or quoted in the first post.
     */
    protected function approveThread(\XF\Entity\Thread $thread)
    {
        /** @var \XF\Service\Thread\Approver $approver */
        $approver = $this->service('XF:Thread\Approver', $thread);
        $approver->setNotifyRunTime(1); // as the approval queue: the rest is queued
        return $approver->approve();
    }
}

<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;
use XF\Service\User\LoginService;
use ForumCopilot\Result\FCLoginModResult;
use ForumCopilot\Result\FCStickTopicResult;
use ForumCopilot\Result\FCCloseTopicResult;
use ForumCopilot\Result\FCDeleteTopicResult;
use ForumCopilot\Result\FCDeletePostResult;
use XF\Service\Thread\DeleterService;
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
    public function actionDoLoginMod(ParameterBag $params)
    {
        $username = $params->get('username', '');
        $password = $params->get('password', '');

        if (empty($username) || empty($password)) {
            return $this->apiError('Username and password are required');
        }

        try {
            // Use XenForo's LoginService for authentication
            $loginService = $this->service(LoginService::class, $username, $this->request()->getIp());
            if ($loginService->isLoginLimited($limitType)) {
                return $this->apiError('Account temporarily locked due to failed login attempts');
            }

            // Validate password
            $user = $loginService->validate($password, $error);
            if (!$user) {
                return $this->apiError($error ?: 'Invalid password');
            }

            // Check if user is a moderator
            if (!$user->is_moderator && !$user->is_admin) {
                return $this->apiError('User is not a moderator');
            }

            // Log the user in
            $this->session()->changeUser($user);
            $this->session()->save();

            $result = new FCLoginModResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Moderator login failed: ' . $e->getMessage());
        }
    }

    public function actionStickTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        
        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canStickUnstick($error)) {
                return $this->apiError('Cannot stick this topic' . ($error ? ': ' . $error : ''));
            }

            // Use XenForo's standard approach: directly set sticky and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            $thread->sticky = true;
            $thread->save();

            $result = new FCStickTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to stick topic: ' . $e->getMessage());
        }
    }

    public function actionUnstickTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canStickUnstick($error)) {
                return $this->apiError('Cannot unstick this topic' . ($error ? ': ' . $error : ''));
            }

            // Use XenForo's standard approach: directly set sticky and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            $thread->sticky = false;
            $thread->save();

            $result = new FCStickTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to unstick topic: ' . $e->getMessage());
        }
    }

    public function actionCloseTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canLockUnlock($error)) {
                return $this->apiError('Cannot close this topic' . ($error ? ': ' . $error : ''));
            }

            // Check if thread is a redirect (redirects cannot be locked)
            if ($thread->discussion_type == 'redirect') {
                return $this->apiError('Cannot lock redirect threads');
            }

            // Use XenForo's standard approach: directly set discussion_open and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            $thread->discussion_open = false;
            $thread->save();

            $result = new FCCloseTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to close topic: ' . $e->getMessage());
        }
    }

    public function actionUncloseTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canLockUnlock($error)) {
                return $this->apiError('Cannot open this topic' . ($error ? ': ' . $error : ''));
            }

            // Check if thread is a redirect (redirects cannot be unlocked)
            if ($thread->discussion_type == 'redirect') {
                return $this->apiError('Cannot unlock redirect threads');
            }

            // Use XenForo's standard approach: directly set discussion_open and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            $thread->discussion_open = true;
            $thread->save();

            $result = new FCCloseTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to open topic: ' . $e->getMessage());
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
            return $this->apiError('Topic ID is required');
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            // Determine delete type
            $type = $hardDelete ? 'hard' : 'soft';

            // Check permissions for the specific delete type
            if (!$thread->canDelete($type, $error)) {
                return $this->apiError('Cannot delete this topic' . ($error ? ': ' . $error : ''));
            }

            // Use XenForo's Thread Deleter service (standard way to delete threads)
            /** @var DeleterService $deleter */
            $deleter = $this->service(DeleterService::class, $thread);

            // Set alert if requested
            if ($starterAlert) {
                $deleter->setSendAlert(true, $starterAlertReason);
            }

            // Perform deletion
            $deleter->delete($type, $reason);

            $result = new FCDeleteTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to delete topic: ' . $e->getMessage());
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
            return $this->apiError('Post ID is required');
        }

        try {
            $post = $this->assertViewablePost($postId);
            $visitor = \XF::visitor();

            // Determine delete type
            $type = $hardDelete ? 'hard' : 'soft';

            // Check permissions for the specific delete type
            if (!$post->canDelete($type, $error)) {
                return $this->apiError('Cannot delete this post' . ($error ? ': ' . $error : ''));
            }

            // Use XenForo's Post Deleter service
            /** @var \XF\Service\Post\DeleterService $deleter */
            $deleter = $this->service('XF:Post\Deleter', $post);
            $deleter->delete($type, $reason);

            $result = new FCDeletePostResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Post not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to delete post: ' . $e->getMessage());
        }
    }

    public function actionUndeleteTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $reason = $params->get('reason', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        try {
            // Use find() instead of assertViewableThread() because deleted threads may not be viewable
            $thread = $this->em()->find('XF:Thread', $topicId);
            if (!$thread) {
                return $this->apiError('Topic not found');
            }

            $visitor = \XF::visitor();

            if (!$thread->canUndelete($error)) {
                return $this->apiError('Cannot undelete this topic' . ($error ? ': ' . $error : ''));
            }

            // Check if thread is actually deleted (matches XenForo core InlineMod approach)
            if ($thread->discussion_state != 'deleted') {
                return $this->apiError('Topic is not deleted');
            }

            // Use XenForo's standard approach: directly set state and save (as InlineMod does)
            // This is simpler and more efficient than using the Editor service
            // Moderator log is automatically created when state changes from 'deleted' to 'visible'
            $thread->discussion_state = 'visible';
            $thread->save();

            $result = new FCUndeleteTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to undelete topic: ' . $e->getMessage());
        }
    }

    public function actionUndeletePost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');
        $reason = $params->get('reason', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required');
        }

        try {
            $post = $this->em()->find('XF:Post', $postId);
            if (!$post) {
                return $this->apiError('Post not found');
            }

            $visitor = \XF::visitor();

            if (!$post->canUndelete()) {
                return $this->apiError('Cannot undelete this post');
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
            return $this->apiError('Failed to undelete post: ' . $e->getMessage());
        }
    }

    public function actionMoveTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $forumId = $params->get('forumId', '');
        $redirect = $params->get('redirect', false);

        if (empty($topicId) || empty($forumId)) {
            return $this->apiError('Topic ID and Forum ID are required');
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $forum = $this->assertViewableForum($forumId);
            $visitor = \XF::visitor();

            if (!$thread->canMove()) {
                return $this->apiError('Cannot move this topic');
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

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread or forum not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to move topic: ' . $e->getMessage());
        }
    }

    public function actionRenameTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $title = $params->get('title', '');

        if (empty($topicId) || empty($title)) {
            return $this->apiError('Topic ID and title are required');
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canEdit()) {
                return $this->apiError('Cannot rename this topic');
            }

            // Use XenForo's Thread Editor service
            /** @var \XF\Service\Thread\Editor $editor */
            $editor = $this->service('XF:Thread\Editor', $thread);
            $editor->setTitle($title);

            if (!$editor->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            $editor->save();

            $result = new FCRenameTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to rename topic: ' . $e->getMessage());
        }
    }

    public function actionApproveTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canApproveUnapprove()) {
                return $this->apiError('Cannot approve this topic');
            }

            // Use XenForo's Thread Editor service
            /** @var \XF\Service\Thread\Editor $editor */
            $editor = $this->service('XF:Thread\Editor', $thread);
            $editor->setDiscussionState('visible');

            if (!$editor->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            $editor->save();

            $result = new FCApproveTopicResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to approve topic: ' . $e->getMessage());
        }
    }

    public function actionApprovePost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required');
        }

        try {
            $post = $this->assertViewablePost($postId);
            $visitor = \XF::visitor();

            if (!$post->canApproveUnapprove()) {
                return $this->apiError('Cannot approve this post');
            }

            // Use XenForo's Post Approver service (like core does)
            if ($post->isFirstPost()) {
                // For first post, approve the thread instead
                if ($post->Thread->discussion_state == 'moderated') {
                    /** @var \XF\Service\Thread\Editor $editor */
                    $editor = $this->service('XF:Thread\Editor', $post->Thread);
                    $editor->setDiscussionState('visible');
                    if (!$editor->validate($errors)) {
                        return $this->apiError('Validation failed: ' . implode(', ', $errors));
                    }
                    $editor->save();
                }
            } else if ($post->message_state == 'moderated') {
                /** @var \XF\Service\Post\Approver $approver */
                $approver = $this->service('XF:Post\Approver', $post);
                $approver->setNotifyRunTime(1);
                $approver->approve();
            }

            $result = new FCApprovePostResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Post not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to approve post: ' . $e->getMessage());
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
            return $this->apiError('Username is required');
        }

        try {
            $user = $this->em()->findOne('XF:User', ['username' => $userName]);
            if (!$user) {
                return $this->apiError('User not found');
            }

            $visitor = \XF::visitor();

            if (!$user->canBan($error)) {
                return $this->apiError('Cannot ban this user' . ($error ? ': ' . $error : ''));
            }

            // Determine end date based on parameters
            $endDate = 0; // Default to permanent ban
            
            // Priority: banLength/endDate > banExpires (for backward compatibility)
            if ($banLength === 'temporary') {
                // For temporary ban, endDate is required
                if (empty($endDateStr)) {
                    return $this->apiError('End date is required when banLength is "temporary"');
                }
                // Parse the end date string (supports formats like "2025-12-21" or "2025-12-21 23:59:59")
                $endDateTimestamp = strtotime($endDateStr);
                if ($endDateTimestamp === false) {
                    return $this->apiError('Invalid end date format. Use format: YYYY-MM-DD or YYYY-MM-DD HH:MM:SS');
                }
                if ($endDateTimestamp <= time()) {
                    return $this->apiError('End date must be in the future');
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
                return $this->apiError('Failed to ban user: ' . ($error ? $error : 'Unknown error'));
            }

            $result = new FCBanUserResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to ban user: ' . $e->getMessage());
        }
    }

    public function actionUnbanUser(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Support both userId and userName for consistency with ban function
        $userId = $params->get('userId', '');
        $userName = $params->get('userName', '');

        if (empty($userId) && empty($userName)) {
            return $this->apiError('User ID or username is required');
        }

        try {
            // Find user by ID or username
            if (!empty($userId)) {
                $user = $this->em()->find('XF:User', $userId);
            } else {
                $user = $this->em()->findOne('XF:User', ['username' => $userName]);
            }

            if (!$user) {
                return $this->apiError('User not found');
            }

            // Check if user is actually banned
            if (!$user->is_banned) {
                return $this->apiError('User is not banned');
            }

            // Check if user has a ban record
            if (!$user->Ban) {
                return $this->apiError('User ban record not found');
            }

            $visitor = \XF::visitor();

            // Check permissions - need ban permission to unban
            if (!$user->canBan($error)) {
                return $this->apiError('Cannot unban this user' . ($error ? ': ' . $error : ''));
            }

            // Remove ban - deleting the ban entity will automatically update user.is_banned via _postDelete
            // Use the User relation directly like XenForo core does
            $user->Ban->delete();

            $result = new FCUnbanUserResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to unban user: ' . $e->getMessage());
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
            return $this->apiError('Either userId or username is required');
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
                return $this->apiError('User not found');
            }

            $visitor = \XF::visitor();

            // Check permission to clean spam
            if (!$visitor->canCleanSpam()) {
                return $this->apiError('You do not have permission to use the spam cleaner', 403);
            }

            // Check if user is a possible spammer
            if (!$user->isPossibleSpammer($error)) {
                return $this->apiError('User cannot be spam cleaned: ' . ($error ?: 'User does not meet spam criteria'), 400);
            }

            // Perform spam cleanup
            $cleaner = $this->app->spam()->cleaner($user);
            $cleaner->cleanUp($actions);

            // Finalize (commits transaction and writes log)
            if (!$cleaner->finalize()) {
                $errors = $cleaner->getErrors();
                return $this->apiError('Spam cleanup failed: ' . implode(', ', $errors), 500);
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
            return $this->apiError('Failed to spam clean user: ' . $e->getMessage(), 500);
        }
    }
}

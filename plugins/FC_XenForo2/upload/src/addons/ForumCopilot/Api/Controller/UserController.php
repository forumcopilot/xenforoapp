<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCSearchUserResult;
use ForumCopilot\Result\FCOnlineUserResult;
use ForumCopilot\Result\FCUserReplyResult;
use ForumCopilot\Result\FCInboxStatResult;
use ForumCopilot\Result\FCReportUserResult;
use ForumCopilot\Entity\FCUser;
use ForumCopilot\Adapter\XenForoParamAdapter;

// Explicitly require FCUserResult.php which contains multiple Result classes
// This ensures all classes in that file are loaded
require_once(__DIR__ . '/../../Result/FCUserResult.php');

/**
 * User Controller for ForumCopilot API
 * Handles user information and user-related operations
 */
class UserController extends AbstractController
{
    public function actionGetUserInfo(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetUserInfoParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            // Use basic finder to avoid add-on conflicts
            $user = null;
            
            if (!empty($fcParams->userId)) {
                $user = $this->em()->find('XF:User', (int)$fcParams->userId);
            } else {
                // Use finder instead of findOne to avoid conflicts
                $finder = $this->finder('XF:User');
                $finder->where('username', $fcParams->username);
                $user = $finder->fetchOne();
            }

            if (!$user) {
                return $this->apiError('User not found');
            }

            $visitor = \XF::visitor();

            // Get avatar URL - use only method that exists in base User entity
            $avatarUrl = '';
            try {
                $avatarUrl = $this->getAbsoluteUrl($user->getAvatarUrl('m'));
            } catch (\Exception $e) {
                // If getAvatarUrl fails, use empty string
            }

            // Check if online - use last_activity comparison instead of isOnline()
            $isOnline = false;
            if ($user->last_activity && $user->last_activity > (\XF::$time - 900)) {
                $isOnline = true;
            }

            // Safely get profile information
            $followingCount = 0;
            $followerCount = 0;
            $customFields = [];
            try {
                if ($user->Profile) {
                    $followingCount = isset($user->Profile->following_count) ? (int)$user->Profile->following_count : 0;
                    $followerCount = isset($user->Profile->followers_count) ? (int)$user->Profile->followers_count : 0;
                    // Filter custom fields based on privacy settings
                    $customFields = $this->getFilteredCustomFields($user, $visitor);
                }
            } catch (\Exception $e) {
                // If Profile relation fails, use defaults
            }

            // Check following relationships
            $isFollowing = false;
            $isFollowingMe = false;
            try {
                if ($visitor->user_id) {
                    // Check if visitor is following the target user
                    $isFollowing = $visitor->isFollowing($user);
                    // Check if target user is following the visitor
                    $isFollowingMe = $user->isFollowing($visitor);
                }
            } catch (\Exception $e) {
                // If check fails, use defaults (false)
            }

            // Check if visitor can ban this user
            $canBan = false;
            try {
                if ($visitor->user_id) {
                    // This checks if visitor (moderator) has permission to ban this user
                    // Returns false if user is admin/moderator or if visitor doesn't have permission
                    $canBan = $user->canBan();
                }
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }

            // Check if visitor is ignoring this user
            $isIgnored = false;
            try {
                if ($visitor->user_id) {
                    // This checks if the visitor has ignored the target user
                    $isIgnored = $visitor->isIgnoring($user->user_id);
                }
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }

            // Check if visitor can spam clean this user
            // This checks both: visitor permission AND user eligibility
            $canSpamClean = false;
            try {
                if ($visitor->user_id) {
                    // Check if visitor has permission to clean spam
                    if ($visitor->canCleanSpam()) {
                        // Check if user is eligible to be spam cleaned
                        $canSpamClean = $user->isPossibleSpammer($error);
                    }
                }
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }

            // Check if visitor can report this user
            $canBeReported = false;
            try {
                if ($visitor->user_id) {
                    // This checks both:
                    // 1. Target user is not staff (admin/moderator) - staff cannot be reported
                    // 2. Visitor has permission to report content
                    $canBeReported = $user->canBeReported();
                }
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }

            // Check if visitor can send PM to this user (combines permission + privacy check)
            $acceptsPM = false;
            try {
                if ($visitor->user_id) {
                    // This checks both:
                    // 1. Visitor has permission to start conversations
                    // 2. Target user accepts PMs from visitor (privacy rules: members/followed/none)
                    // 3. Target user can receive conversations
                    // 4. Target user is not disabled/banned
                    $acceptsPM = $visitor->canStartConversationWith($user);
                }
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }

            // Check if visitor can post on target user's profile (respects privacy rules)
            $acceptsFollowers = false;
            try {
                if ($visitor->user_id && $user->Privacy) {
                    // This checks privacy rules: 'members', 'followed', or 'none'
                    // Returns true if visitor meets the privacy requirement
                    $acceptsFollowers = $user->isPrivacyCheckMet('allow_post_profile', $visitor);
                }
            } catch (\Exception $e) {
                // If Privacy relation fails, use defaults
            }

            // Get user title (display text)
            // First check for custom title, then fall back to default title from group or ladder
            $userTitle = null;
            try {
                if ($user->custom_title !== '') {
                    $userTitle = $user->custom_title;
                } else {
                    // Use templater to get default user title (handles group titles and title ladder)
                    $templater = \XF::app()->templater();
                    $userTitle = $templater->getDefaultUserTitleForUser($user);
                }
            } catch (\Exception $e) {
                // If getting title fails, leave as null
            }

            // Check if visitor can view full profile (for location, website, about, signature)
            $canViewFullProfile = false;
            try {
                $canViewFullProfile = $user->canViewFullProfile();
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }

            // Get profile fields (only if can view full profile)
            $location = null;
            $website = null;
            $about = null;
            $signature = null;
            if ($canViewFullProfile && $user->Profile) {
                try {
                    $location = $user->Profile->location ?: null;
                    $website = $user->Profile->website ?: null;
                    $about = $user->Profile->about ?: null;
                    $signature = $user->Profile->signature ?: null;
                } catch (\Exception $e) {
                    // If Profile access fails, leave as null
                }
            }

            // Check if visitor can follow this user
            $canFollow = false;
            try {
                if ($visitor->user_id) {
                    $canFollow = $visitor->canFollowUser($user);
                }
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }

            // Check if visitor can ignore this user
            $canIgnore = false;
            try {
                if ($visitor->user_id) {
                    $canIgnore = $visitor->canIgnoreUser($user);
                }
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }

            // Create FC user entity
            $fcUser = new FCUser([
                'id' => (string)$user->user_id,
                'username' => $user->username,
                'userType' => (string)$user->user_group_id,
                'iconUrl' => $avatarUrl,
                'postCount' => (int)$user->message_count,
                'registrationTime' => $user->register_date * 1000,
                'lastActivityTime' => $user->last_activity * 1000,
                'isOnline' => $isOnline,
                'acceptsPM' => $acceptsPM,
                // canSendPM and canPM removed - acceptsPM now combines their purpose
                'isFollowing' => $isFollowing,
                'isFollowingMe' => $isFollowingMe,
                'acceptsFollowers' => $acceptsFollowers,
                'followingCount' => $followingCount,
                'followerCount' => $followerCount,
                'customFields' => $customFields,
                'canBan' => $canBan,
                'isBanned' => (bool)$user->is_banned,
                'isIgnored' => $isIgnored,
                'canSpamClean' => $canSpamClean,
                'canBeReported' => $canBeReported,
                'userGroups' => $user->secondary_group_ids ?: [],
                'displayText' => $userTitle,
                'userState' => $user->user_state, // Include user state
                'location' => $location,
                'website' => $website,
                'about' => $about,
                'signature' => $signature,
                'canFollow' => $canFollow,
                'canIgnore' => $canIgnore,
                // canSendPM removed - acceptsPM now combines its purpose (can I send PM to this user?)
            ]);

            // getUserInfo doesn't have a specific result class, return user data directly
            return $this->apiSuccess($fcUser->toArray());

        } catch (\Exception $e) {
            return $this->apiError('Failed to get user info: ' . $e->getMessage());
        }
    }

    public function actionSearchUser(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toSearchUserParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        $visitor = \XF::visitor();
        
        // Trim keywords to check if empty
        $keywords = trim($fcParams->keywords ?? '');
        $hasKeywords = !empty($keywords);
        
        if ($hasKeywords) {
            // When searching with keywords, check search permission
            if (!$visitor->canSearch()) {
                return $this->apiError('Search is not allowed');
            }
            
            // Validate minimum keyword length to prevent performance issues
            if (strlen($keywords) < 2) {
                return $this->apiError('Search keywords must be at least 2 characters');
            }
        } else {
            // When listing all members, check member list permission and option
            if (!$this->options()->enableMemberList || !$visitor->canViewMemberList()) {
                return $this->apiError('Member list is not available');
            }
        }

        // Use finder with proper filtering
        $finder = $this->finder('XF:User');
        // Use isValidUser() method which properly filters valid users
        $finder->isValidUser();
        
        if ($hasKeywords) {
            // Use XenForo's escapeLike method for proper escaping (handles special characters correctly)
            // Format '%?%' means: % before, % after, ? is placeholder for the search term
            $finder->where('username', 'LIKE', $finder->escapeLike($keywords, '%?%'));
            $finder->order('username', 'ASC');
        } else {
            // When no keywords, order alphabetically by username (matching web implementation)
            $finder->order('username', 'ASC');
        }
        
        // Get total count BEFORE applying limit
        $total = $finder->total();
        
        // Apply pagination
        $finder->limit($fcParams->perpage, ($fcParams->page - 1) * $fcParams->perpage);

        $users = $finder->fetch();

        $userList = [];
        foreach ($users as $user) {
            // Users filtered by isValidUser() are already in valid state
            // Get avatar URL - let errors surface if method doesn't exist
            $iconUrl = $this->getAbsoluteUrl($user->getAvatarUrl('s'));

            // Check if online - use last_activity comparison
            $isOnline = false;
            if ($user->last_activity && $user->last_activity > (\XF::$time - 900)) {
                $isOnline = true;
            }

            $userList[] = [
                'id' => (string)$user->user_id,
                'username' => $user->username,
                'iconUrl' => $iconUrl,
                'isOnline' => $isOnline,
                'postCount' => (int)$user->message_count,
                'registrationTime' => $user->register_date * 1000,
            ];
        }

        $result = new FCSearchUserResult(
            true,
            null,
            (int)$total,
            $userList
        );

        return $this->apiSuccess($result);
    }

    public function actionGetInboxStat(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        try {
            $visitor = \XF::visitor();
            
            // Get conversation stats
            $conversationRepo = $this->repository('XF:Conversation');
            
            // Use the same method as web version for consistency
            // This method properly handles unread conversation counting
            $totalUnread = $conversationRepo->findUserConversationsForPopupList($visitor, true)->total();
            
            // Update cached value if it's out of sync (like web version does)
            // This ensures the cached value stays accurate
            if ($totalUnread != $visitor->conversations_unread) {
                $visitor->conversations_unread = $totalUnread;
                $visitor->saveIfChanged();
            }
            
            // Count total conversations for user
            $totalFinder = $conversationRepo->findUserConversations($visitor);
            $totalConversations = $totalFinder->total();
            
            // Use cached unread count (more efficient and matches web behavior)
            $unreadConversations = $visitor->conversations_unread;
            
            // Count unread messages (conversations with unread messages)
            // This is the same as unread conversations count in XenForo
            $unreadMessages = $unreadConversations;
            
            // Get alerts stats - use cached value (like conversations)
            // Optionally verify/update if needed (similar to conversations)
            $alertRepo = $this->repository('XF:UserAlert');
            $actualUnviewedAlerts = $alertRepo->findAlertsForUser($visitor->user_id)
                ->where('view_date', 0)
                ->total();
            
            // Update cached value if it's out of sync
            if ($actualUnviewedAlerts != $visitor->alerts_unviewed) {
                $visitor->alerts_unviewed = $actualUnviewedAlerts;
                $visitor->saveIfChanged();
            }
            
            $unreadAlerts = $visitor->alerts_unviewed;
            
            $conversationStats = [
                'total' => $totalConversations,
                'unread' => $unreadConversations,
                'unread_messages' => $unreadMessages
            ];

            // Get inbox stat result class - includes alerts
            $result = new FCInboxStatResult(
                true,
                null,
                $conversationStats['total'] ?? 0,
                $conversationStats['unread'] ?? 0,
                $conversationStats['unread_messages'] ?? 0,
                $unreadAlerts
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get inbox stats: ' . $e->getMessage());
        }
    }

    public function actionGetOnlineUsers(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetOnlineUsersParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        $visitor = \XF::visitor();
        if (!$visitor->canViewMemberList()) {
            return $this->apiError('Cannot view member list');
        }

        // Use SessionActivityFinder with proper filtering
        $finder = $this->finder('XF:SessionActivity');
        
        // Restrict to members only (excludes guests and robots)
        $finder->restrictType('member');
        
        // Apply member visibility restrictions (respects privacy settings)
        $finder->applyMemberVisibilityRestriction();
        
        // Only include active sessions (within online timeout)
        $finder->activeOnly();
        
        // Filter by specific user ID if provided
        if (!empty($fcParams->id)) {
            $finder->where('user_id', (int)$fcParams->id);
        }
        
        // Filter by area/controller if specified
        if (!empty($fcParams->area)) {
            $finder->where('controller_name', $fcParams->area);
        }

        $finder->with('User');
        $finder->order('view_date', 'DESC');
        
        // Get total count BEFORE applying limit
        $total = $finder->total();
        
        // Apply pagination
        $finder->limit($fcParams->perpage, ($fcParams->page - 1) * $fcParams->perpage);

        $sessions = $finder->fetch();

        // Resolve human-readable activity descriptions in one batched pass.
        // Mirrors what XF's own /online/ page does: groups sessions by
        // controller_name and calls each controller's getActivityDetails()
        // once per group, populating $session->description /
        // ->getItemTitle() / ->getItemUrl().
        $activityRepo = $this->repository('XF:SessionActivity');
        $activityRepo->applyActivityDetails($sessions->toArray());

        $userList = [];
        foreach ($sessions as $session) {
            // User should already be filtered by restrictType and visibility, but double-check
            if ($session->User && $session->User->user_state === 'valid') {
                $description = $session->description;
                $itemUrl = $session->getItemUrl();
                $userList[] = [
                    'id' => (string)$session->User->user_id,
                    'username' => $session->User->username,
                    'iconUrl' => $this->getAbsoluteUrl($session->User->getAvatarUrl('s')),
                    'isOnline' => true,
                    // Human-readable activity string for direct display
                    // (e.g. "Viewing thread Foo", "Using Forum Copilot Mobile App").
                    // Renders Phrase objects to their localised string form.
                    'currentActivity' => $description !== null ? (string)$description : null,
                    // Optional click-through URL the web /online/ page links to
                    // (e.g. the thread URL when viewing a thread, or the
                    // admin-configured /getapps URL for mobile-app sessions).
                    'currentActivityUrl' => $itemUrl !== false && $itemUrl !== null
                        ? $this->getAbsoluteUrl($itemUrl)
                        : null,
                    'currentTopicId' => $session->params['thread_id'] ?? null,
                    'lastActivityTime' => $session->view_date * 1000,
                ];
            }
        }

        $result = new FCOnlineUserResult(
            true,
            null,
            (int)$total,
            $userList
        );

        return $this->apiSuccess($result);
    }

    public function actionGetUserReplyPost(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetUserReplyPostParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $visitor = \XF::visitor();
            
            // Find user by username or userId
            $user = null;
            if (!empty($fcParams->userId)) {
                $user = $this->em()->find('XF:User', $fcParams->userId);
            } elseif (!empty($fcParams->username)) {
                $user = $this->em()->findOne('XF:User', ['username' => $fcParams->username]);
            }

            if (!$user) {
                return $this->apiError('User not found');
            }

            // Get user's posts (replies) with proper filtering
            $finder = $this->em()->getFinder('XF:Post');
            $finder->where('user_id', $user->user_id);
            
            // Apply visibility filtering for message_state
            // Base condition: visible posts are always shown
            $conditions = [];
            $viewableStates = ['visible'];
            
            // Check if visitor can view moderated posts
            // Allow own moderated posts if viewing own profile
            if ($visitor->user_id && $visitor->user_id == $user->user_id) {
                // User viewing their own posts - show their own moderated posts
                $conditions[] = [
                    'message_state' => 'moderated',
                    'user_id' => $visitor->user_id,
                ];
            }
            
            // Add visible posts condition
            $conditions[] = ['message_state', $viewableStates];
            
            // Apply the conditions (visible OR own moderated)
            // Note: Deleted posts and other users' moderated posts are filtered out here
            // canView() checks in the loop will further filter by thread/forum permissions
            $finder->whereOr($conditions);
            
            // Load necessary relations for permission checks
            $finder->with(['Thread', 'Thread.Forum', 'Thread.Forum.Node', 'User']);
            
            // Order by post date descending (newest first)
            $finder->order('post_date', 'DESC');
            
            // Calculate pagination from startNum and lastNum
            // startNum is the starting index (0-based), lastNum is the ending index
            $startNum = max(0, (int)$fcParams->startNum);
            $lastNum = max($startNum, (int)$fcParams->lastNum);
            $limit = $lastNum - $startNum + 1; // +1 because lastNum is inclusive
            $offset = $startNum;
            
            // Get total count BEFORE applying limit
            $total = $finder->total();
            
            // Apply pagination
            $finder->limit($limit, $offset);
            
            $posts = $finder->fetch();

            $postList = [];
            foreach ($posts as $post) {
                $thread = $post->Thread;
                $forum = $thread ? $thread->Forum : null;
                
                // Check if visitor can view the post, thread, and forum
                // This filters out posts from private forums or threads visitor cannot access
                if (!$post->canView() || !$thread || !$forum || !$thread->canView() || !$forum->canView()) {
                    continue;
                }

                $postList[] = [
                    'postId' => (string)$post->post_id,
                    'topicId' => (string)$thread->thread_id,
                    'topicTitle' => $thread->title,
                    'forumId' => (string)$forum->node_id,
                    'forumName' => $forum->title,
                    'replyNumber' => $thread->reply_count,
                    'authorId' => (string)$post->user_id,
                    'authorName' => $post->User ? $post->User->username : '',
                    'authorIconUrl' => $post->User ? $this->getAbsoluteUrl($post->User->getAvatarUrl('s')) : null,
                    'postTime' => $post->post_date * 1000, // Convert to milliseconds
                    'postContent' => null, // Not included in user reply list
                    'shortContent' => $this->getShortContent($post->message),
                ];
            }

            $result = new FCUserReplyResult(
                true,
                null,
                (int)$total,
                $postList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get user reply posts: ' . $e->getMessage());
        }
    }

    public function actionReportUser(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userId = $params->get('userId', '');
        $username = $params->get('username', '');
        $reason = $params->get('reason', '');

        // Validate that we have either userId or username
        if (empty($userId) && empty($username)) {
            return $this->apiError('Either userId or username is required');
        }

        // Validate that reason is provided
        if (empty($reason)) {
            return $this->apiError('Reason is required');
        }

        try {
            // Find user by userId or username
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

            // Check if user can be reported
            if (!$user->canBeReported($error)) {
                return $this->apiError('Cannot report this user: ' . ($error ? $error : 'Permission denied'));
            }

            // Use XenForo's Report Creator service
            /** @var \XF\Service\Report\Creator $creator */
            $creator = $this->service('XF:Report\Creator', 'user', $user);
            $creator->setMessage($reason);

            // Validate before saving
            if (!$creator->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            // Flood check (like web version) - prevent spam reporting
            $floodError = $this->checkFlooding('report');
            if ($floodError) {
                return $floodError;
            }

            // Save report (this already includes the message as a comment)
            $report = $creator->save();
            
            // Send notifications
            $creator->sendNotifications();

            // FCReportUserResult is already loaded via require_once for FCUserResult.php
            $result = new FCReportUserResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to report user: ' . $e->getMessage());
        }
    }

    /**
     * Get filtered custom fields based on privacy settings
     * Respects field groups, viewable_profile setting, and user privacy preferences
     * 
     * @param \XF\Entity\User $user The user whose custom fields to retrieve
     * @param \XF\Entity\User $visitor The viewing user
     * @return array Filtered custom field values
     */
    protected function getFilteredCustomFields(\XF\Entity\User $user, \XF\Entity\User $visitor)
    {
        if (!$user->Profile) {
            return [];
        }

        $profile = $user->Profile;
        $fieldSet = $profile->custom_fields;
        
        // If visitor is viewing their own profile or can bypass privacy, return all fields
        if ($visitor->user_id == $user->user_id || $visitor->canBypassUserPrivacy()) {
            return $fieldSet->getFieldValues();
        }

        // Otherwise, filter based on privacy settings
        $fieldValues = [];
        
        // Get field definitions
        $fieldDefinition = $fieldSet->getDefinitionSet();
        
        // Include personal fields that are viewable on profile
        $personalFields = $fieldDefinition->filterGroup('personal')->filter('profile')->getFieldDefinitions();
        foreach ($personalFields AS $fieldId => $field) {
            $fieldValues[$fieldId] = $fieldSet->getFieldValue($fieldId);
        }
        
        // Include contact fields only if visitor can view identities
        if ($user->canViewIdentities()) {
            $contactFields = $fieldDefinition->filterGroup('contact')->filter('profile')->getFieldDefinitions();
            foreach ($contactFields AS $fieldId => $field) {
                $fieldValues[$fieldId] = $fieldSet->getFieldValue($fieldId);
            }
        }
        
        return $fieldValues;
    }

}

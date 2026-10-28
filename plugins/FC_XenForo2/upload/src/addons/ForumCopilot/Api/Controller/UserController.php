<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            // The relations XenForo's member page loads (assertViewableUser),
            // plus Activity for the online status
            $with = ['Activity', 'Option', 'Privacy', 'Profile'];
            $user = null;

            if (!empty($fcParams->userId)) {
                $user = $this->em()->find('XF:User', (int)$fcParams->userId, $with);
            } else {
                $finder = $this->finder('XF:User');
                $finder->where('username', $fcParams->username);
                $finder->with($with);
                $user = $finder->fetchOne();
            }

            if (!$user) {
                return $this->apiError(\XF::phrase('requested_user_not_found'), null, ErrorCode::NOT_FOUND);
            }

            $visitor = \XF::visitor();
            $isSelf = ($visitor->user_id && $visitor->user_id == $user->user_id);

            // Get avatar URL - use only method that exists in base User entity
            $avatarUrl = '';
            try {
                $avatarUrl = $this->getAbsoluteUrl($user->getAvatarUrl('m'));
            } catch (\Exception $e) {
                // If getAvatarUrl fails, use empty string
            }

            // Online status and "last seen" as XenForo shows them: hidden for
            // members who untick "Show your online status" unless the visitor
            // may override privacy (User::isOnline, canViewOnlineStatus; the
            // member page's last seen uses the same check, Templater
            // fnUserActivity). Hidden: isOnline false, lastActivityTime null
            // (the app hides "last seen" for null).
            $canViewOnlineStatus = $user->canViewOnlineStatus();
            $isOnline = $user->isOnline();
            $lastActivityTime = $canViewOnlineStatus ? $user->last_activity * 1000 : null;

            // Check if visitor can view full profile (for location, website,
            // about, signature, custom fields and follow counts: XenForo's
            // member page and About tab need it, assertViewableUser)
            $canViewFullProfile = false;
            try {
                $canViewFullProfile = $user->canViewFullProfile();
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }

            // Follow counts and custom fields, as on XenForo's About tab
            // (MemberController::actionAbout)
            $followingCount = 0;
            $followerCount = 0;
            $customFields = [];
            $customFieldsDisplay = [];
            if ($canViewFullProfile && $user->Profile) {
                try {
                    $userFollowRepo = $this->repository('XF:UserFollow');
                    if ($user->Profile->following) {
                        $followingCount = $userFollowRepo->findFollowingForProfile($user)->total();
                    }
                    $followerCount = $userFollowRepo->findFollowersForProfile($user)->total();
                } catch (\Exception $e) {
                    \XF::logException($e, false, 'ForumCopilot: follow counts failed: ');
                }

                try {
                    $customFields = $this->getFilteredCustomFields($user, $visitor);
                    $customFieldsDisplay = $this->getCustomFieldsDisplay(
                        $user->Profile->custom_fields->getDefinitionSet(),
                        $customFields
                    );
                } catch (\Exception $e) {
                    \XF::logException($e, false, 'ForumCopilot: custom fields failed: ');
                }
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
            } catch (\Throwable $e) {
                // If check fails, use default (false). \Throwable: should
                // canBan() be missing (needs a 2.2 check), the call throws an
                // \Error, which would otherwise fail the whole profile.
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

            // Check if visitor can follow this user. The app shows the
            // Follow button from acceptsFollowers (isFollowing ||
            // acceptsFollowers), so that is canFollowUser too; it used to be
            // the "post on your profile" privacy check, which hid the button
            // for members who limit profile posts. That check is now
            // canPostOnProfile.
            $canFollow = false;
            try {
                if ($visitor->user_id) {
                    $canFollow = $visitor->canFollowUser($user);
                }
            } catch (\Exception $e) {
                // If check fails, use default (false)
            }
            $acceptsFollowers = $canFollow;

            $canPostOnProfile = false;
            try {
                $canPostOnProfile = $user->canPostOnProfile();
            } catch (\Exception $e) {
                // If check fails, use default (false)
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

            // Get profile fields (only if can view full profile)
            $location = null;
            $website = null;
            $about = null;
            $signature = null;
            if ($canViewFullProfile && $user->Profile) {
                try {
                    // With the forum's censored words replaced, as the profile page shows them
                    $censor = $this->app()->stringFormatter();
                    $location = $user->Profile->location ? $censor->censorText($user->Profile->location) : null;
                    $website = $user->Profile->website ?: null;
                    $about = $user->Profile->about ? $censor->censorText($user->Profile->about) : null;
                    $signature = $user->Profile->signature ? $censor->censorText($user->Profile->signature) : null;
                } catch (\Exception $e) {
                    // If Profile access fails, leave as null
                }
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

            // User state and groups only for the member themself and for
            // admins with user permission, as XenForo's REST API sends them
            // (User::setupApiResultData). The banned flag also for visitors
            // who override privacy (as the REST API) and for moderators who
            // can ban, who need it for the ban/unban menu. Others get the
            // defaults: groups [], state valid, not banned.
            $canViewInternal = $isSelf || $visitor->hasAdminPermission('user');
            $canViewBanned = $canViewInternal
                || $canBan
                || $visitor->canBypassUserPrivacy()
                || ($visitor->is_moderator && $visitor->hasPermission('general', 'banUser'));

            // Create FC user entity
            $fcUser = new FCUser([
                'id' => (string)$user->user_id,
                'username' => $user->username,
                'userType' => (string)$user->user_group_id,
                'iconUrl' => $avatarUrl,
                'postCount' => (int)$user->message_count,
                'registrationTime' => $user->register_date * 1000,
                'lastActivityTime' => $lastActivityTime,
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
                'isBanned' => $canViewBanned ? (bool)$user->is_banned : false,
                'isIgnored' => $isIgnored,
                'canSpamClean' => $canSpamClean,
                'canBeReported' => $canBeReported,
                'userGroups' => $canViewInternal ? ($user->secondary_group_ids ?: []) : [],
                'displayText' => $userTitle,
                'userState' => $canViewInternal ? $user->user_state : 'valid',
                'location' => $location,
                'website' => $website,
                'about' => $about,
                'signature' => $signature,
                'canFollow' => $canFollow,
                'canIgnore' => $canIgnore,
                // canSendPM removed - acceptsPM now combines its purpose (can I send PM to this user?)
            ]);

            $data = $fcUser->toArray();
            // Since 1.11.0: whether the visitor may post on this profile
            // (what acceptsFollowers used to say), and the custom fields with
            // their titles and choice labels, in display order.
            $data['canPostOnProfile'] = $canPostOnProfile;
            $data['customFieldsDisplay'] = $customFieldsDisplay;

            // Viewing a member's profile marks their "followed you" alert
            // read, as XenForo's member page does (MemberController::actionView)
            if ($visitor->user_id && !$isSelf && $canViewFullProfile) {
                try {
                    $alertRepo = $this->repository('XF:UserAlert');
                    if (method_exists($alertRepo, 'markUserAlertsReadForContent')) {
                        $alertRepo->markUserAlertsReadForContent('user', $visitor->user_id, 'following');
                    }
                } catch (\Exception $e) {
                    \XF::logException($e, false, 'ForumCopilot: marking follow alert read failed: ');
                }
            }

            // getUserInfo doesn't have a specific result class, return user data directly
            return $this->apiSuccess($data);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get user info');
        }
    }

    public function actionSearchUser(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toSearchUserParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        $visitor = \XF::visitor();
        
        // Trim keywords to check if empty
        $keywords = trim($fcParams->keywords ?? '');
        $hasKeywords = !empty($keywords);
        
        if ($hasKeywords) {
            // When searching with keywords, check search permission
            if (!$visitor->canSearch()) {
                return $this->apiError('Search is not allowed', null, ErrorCode::NO_PERMISSION);
            }
            
            // Validate minimum keyword length to prevent performance issues
            if (strlen($keywords) < 2) {
                return $this->apiError('Search keywords must be at least 2 characters', null, ErrorCode::VALIDATION);
            }
        } else {
            // When listing all members, check member list permission and option
            if (!$this->options()->enableMemberList || !$visitor->canViewMemberList()) {
                return $this->apiError('Member list is not available', null, ErrorCode::NO_PERMISSION);
            }
        }

        // Use finder with proper filtering
        $finder = $this->finder('XF:User');
        // Use isValidUser() method which properly filters valid users
        $finder->isValidUser();
        // Session activity, for the online status (User::isOnline)
        $finder->with('Activity');
        
        if ($hasKeywords) {
            // Use XenForo's escapeLike method for proper escaping (handles special characters correctly).
            // match "prefix" (since 1.11.0) finds names starting with the
            // keywords, as XenForo's member finder does
            // (MemberController::actionFind), and can use the username
            // index. Without it, names containing the keywords, as before.
            $pattern = ($fcParams->match === 'prefix') ? '?%' : '%?%';
            $finder->where('username', 'LIKE', $finder->escapeLike($keywords, $pattern));
            $finder->order('username', 'ASC');
        } else {
            // When no keywords, order alphabetically by username (matching web implementation)
            $finder->order('username', 'ASC');
        }
        
        // Get total count BEFORE applying limit
        $total = $finder->total();
        
        // Apply pagination. At most 50 per page (or the member list's page
        // size, if larger), so one call can't read the whole member list.
        $perPage = min((int)$fcParams->perpage, max(50, (int)$this->options()->membersPerPage));
        $finder->limit($perPage, ((int)$fcParams->page - 1) * $perPage);

        $users = $finder->fetch();

        $userList = [];
        foreach ($users as $user) {
            // Users filtered by isValidUser() are already in valid state
            // Get avatar URL - let errors surface if method doesn't exist
            $iconUrl = $this->getAbsoluteUrl($user->getAvatarUrl('s'));

            // XenForo's online status: false for members who hide it,
            // unless the visitor may override privacy
            $isOnline = $user->isOnline();

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
            return $this->apiException($e, 'Failed to get inbox stats');
        }
    }

    public function actionGetOnlineUsers(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetOnlineUsersParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        $visitor = \XF::visitor();
        if (!$visitor->canViewMemberList()) {
            return $this->apiError('Cannot view member list', null, ErrorCode::NO_PERMISSION);
        }

        // Use SessionActivityFinder with proper filtering
        $finder = $this->finder('XF:SessionActivity');
        
        // Restrict to members only (excludes guests and robots). This also
        // hides members who hide their online status, unless the visitor
        // may override privacy, as XenForo's online list
        // (SessionActivityFinder::applyMemberVisibilityRestriction).
        $finder->restrictType('member');
        
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
        
        // Apply pagination. At most 50 per page (or the online list's page
        // size, membersPerPage, if larger).
        $perPage = min((int)$fcParams->perpage, max(50, (int)$this->options()->membersPerPage));
        $finder->limit($perPage, ((int)$fcParams->page - 1) * $perPage);

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
            // restrictType('member') already keeps only sessions with a user
            // the visitor may see, as on XenForo's online list; rows are not
            // dropped here, so the list matches total.
            $user = $session->User;
            if (!$user) {
                continue;
            }

            // What the member is doing, only when they show it: XenForo's
            // online list shows it only if User::canViewCurrentActivity()
            // (template online_list; Templater::fnUserActivity). Otherwise
            // the three fields are null.
            $canViewActivity = method_exists($user, 'canViewCurrentActivity')
                ? $user->canViewCurrentActivity()
                : $user->canViewOnlineStatus();

            $currentActivity = null;
            $currentActivityUrl = null;
            $currentTopicId = null;
            if ($canViewActivity) {
                $description = $session->description;
                $itemUrl = $session->item_url;
                // Human-readable activity string for direct display
                // (e.g. "Viewing thread", "Using Forum Copilot Mobile App").
                // Renders Phrase objects to their localised string form.
                $currentActivity = $description !== null ? (string)$description : null;
                // Optional click-through URL the web /online/ page links to
                // (e.g. the thread URL when viewing a thread, or the
                // admin-configured /getapps URL for mobile-app sessions).
                $currentActivityUrl = $itemUrl !== false && $itemUrl !== null
                    ? $this->getAbsoluteUrl($itemUrl)
                    : null;
                // The thread id only when XenForo resolved its title, which it
                // does only for threads the visitor may view
                // (ThreadController::getActivityDetails)
                $threadId = $session->params['thread_id'] ?? null;
                if ($threadId && $session->item_title) {
                    $currentTopicId = (string)$threadId;
                }
            }

            $userList[] = [
                'id' => (string)$user->user_id,
                'username' => $user->username,
                'iconUrl' => $this->getAbsoluteUrl($user->getAvatarUrl('s')),
                'isOnline' => true,
                'currentActivity' => $currentActivity,
                'currentActivityUrl' => $currentActivityUrl,
                'currentTopicId' => $currentTopicId,
                'lastActivityTime' => $session->view_date * 1000,
            ];
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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
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
                return $this->apiError(\XF::phrase('requested_user_not_found'), null, ErrorCode::NOT_FOUND);
            }

            // A member's posts are listed on their profile's Postings tab,
            // which needs the full profile (MemberController, assertViewableUser):
            // members who limit who may view their profile are refused here too.
            $error = null;
            if (!$user->canViewFullProfile($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
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
            $finder->whereOr($conditions);

            // Only threads the visitor may view, in SQL, so that total and
            // the paging count the same rows the list holds
            // (Thread::canView). Rows were dropped after LIMIT before, so the
            // app's next page repeated posts, or kept loading when the last
            // ones were hidden.
            $this->restrictToViewableThreads($finder, $visitor);
            
            // Load necessary relations for permission checks
            $finder->with(['Thread', 'Thread.Forum', 'Thread.Forum.Node', 'User']);
            
            // Order by post date descending (newest first)
            $finder->order('post_date', 'DESC');
            
            // Calculate pagination from startNum and lastNum
            // startNum is the starting index (0-based), lastNum is the ending
            // index; at most 50 posts per call (the app asks for 20)
            $startNum = max(0, (int)$fcParams->startNum);
            $lastNum = min(max($startNum, (int)$fcParams->lastNum), $startNum + 49);
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
                
                // Safety net: the query above already keeps only what these
                // allow (an add-on may extend canView)
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
            return $this->apiException($e, 'Failed to get user reply posts');
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
            return $this->apiError('Either userId or username is required', null, ErrorCode::BAD_REQUEST);
        }

        // Validate that reason is provided
        if (empty($reason)) {
            return $this->apiError('Reason is required', null, ErrorCode::VALIDATION);
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
                return $this->apiError(\XF::phrase('requested_user_not_found'), null, ErrorCode::NOT_FOUND);
            }

            $visitor = \XF::visitor();

            // Check if user can be reported
            if (!$user->canBeReported($error)) {
                return $this->apiError('Cannot report this user: ' . ($error ? $error : 'Permission denied'), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's Report Creator service
            /** @var \XF\Service\Report\Creator $creator */
            $creator = $this->service('XF:Report\Creator', 'user', $user);
            $creator->setMessage($reason);

            // Validate before saving
            if (!$creator->validate($errors)) {
                return $this->apiFieldErrors($errors);
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
            return $this->apiException($e, 'Failed to report user');
        }
    }

    /**
     * Limits a post finder to threads the visitor may view, as
     * Thread::canView decides: forums the visitor may view with "View
     * threads" (view) and "View thread content" (viewContent); without "View
     * others' threads" (viewOthers), only the visitor's own threads.
     * Moderated threads where the visitor may view them (viewModerated, or
     * their own) and deleted ones with viewDeleted.
     *
     * @param \XF\Mvc\Entity\Finder $finder a finder for XF:Post
     * @param \XF\Entity\User $visitor
     */
    protected function restrictToViewableThreads(\XF\Mvc\Entity\Finder $finder, \XF\Entity\User $visitor)
    {
        $nodeIds = [];
        $ownOnlyNodeIds = [];
        $moderatedNodeIds = [];
        $deletedNodeIds = [];
        foreach ($this->repository('XF:Forum')->getViewableForums() as $nodeId => $forum) {
            if (!$visitor->hasNodePermission($nodeId, 'view')
                || !$visitor->hasNodePermission($nodeId, 'viewContent')
            ) {
                continue;
            }
            if ($visitor->hasNodePermission($nodeId, 'viewOthers')) {
                $nodeIds[] = $nodeId;
            } elseif ($visitor->user_id) {
                $ownOnlyNodeIds[] = $nodeId;
            } else {
                continue;
            }
            if ($visitor->hasNodePermission($nodeId, 'viewModerated')) {
                $moderatedNodeIds[] = $nodeId;
            }
            if ($visitor->hasNodePermission($nodeId, 'viewDeleted')) {
                $deletedNodeIds[] = $nodeId;
            }
        }

        if (!$nodeIds && !$ownOnlyNodeIds) {
            $finder->whereSql('1 = 0');
            return;
        }

        $forumConditions = [];
        if ($nodeIds) {
            $forumConditions[] = ['Thread.node_id', $nodeIds];
        }
        if ($ownOnlyNodeIds) {
            $forumConditions[] = [
                ['Thread.node_id', $ownOnlyNodeIds],
                ['Thread.user_id', $visitor->user_id],
            ];
        }
        $finder->whereOr($forumConditions);

        $stateConditions = [['Thread.discussion_state', 'visible']];
        if ($moderatedNodeIds) {
            $stateConditions[] = [
                ['Thread.discussion_state', 'moderated'],
                ['Thread.node_id', $moderatedNodeIds],
            ];
        }
        if ($visitor->user_id) {
            $stateConditions[] = [
                ['Thread.discussion_state', 'moderated'],
                ['Thread.user_id', $visitor->user_id],
            ];
        }
        if ($deletedNodeIds) {
            $stateConditions[] = [
                ['Thread.discussion_state', 'deleted'],
                ['Thread.node_id', $deletedNodeIds],
            ];
        }
        $finder->whereOr($stateConditions);
    }

    /**
     * Custom field values the visitor may see, keyed by field id. The caller
     * asks only when the visitor may view the full profile, as XenForo's
     * About tab needs (MemberController::actionAbout, assertViewableUser).
     * The member themself and admins with user permission get every value,
     * as in XenForo's REST API (User::setupApiResultData); everyone else the
     * personal fields shown on profiles, plus the contact fields when the
     * member lets them see identities.
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

        $isSelf = $visitor->user_id && $visitor->user_id == $user->user_id;
        if (!$isSelf && !$user->canViewFullProfile()) {
            return [];
        }

        $profile = $user->Profile;
        $fieldSet = $profile->custom_fields;

        if ($isSelf || $visitor->hasAdminPermission('user')) {
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

    /**
     * The same custom fields for display: each field's title, and its value
     * as text (a choice field's labels rather than its keys). Fields with no
     * value are left out, as on XenForo's About tab. In display order.
     *
     * @param \XF\CustomField\DefinitionSet $definitionSet the user fields
     * @param array $fieldValues field id => value, from getFilteredCustomFields
     * @return array [{id, title, value}]
     */
    protected function getCustomFieldsDisplay(\XF\CustomField\DefinitionSet $definitionSet, array $fieldValues)
    {
        if (!$fieldValues) {
            return [];
        }

        $display = [];
        foreach ($definitionSet->getFieldDefinitions() as $fieldId => $field) {
            if (!array_key_exists($fieldId, $fieldValues)) {
                continue;
            }
            $value = $fieldValues[$fieldId];
            if ($value === null || $value === '' || $value === []) {
                continue;
            }

            $choices = $field->field_choices ?: [];
            if ($field->type_group === 'single') {
                $text = isset($choices[$value]) ? (string)$choices[$value] : (string)$value;
            } elseif ($field->type_group === 'multiple') {
                $labels = [];
                foreach ((array)$value as $choice => $unused) {
                    $labels[] = isset($choices[$choice]) ? (string)$choices[$choice] : (string)$choice;
                }
                $text = implode(', ', $labels);
            } else {
                $text = $this->plainText($field->getFormattedValue($value));
            }

            if ($text === '') {
                continue;
            }
            $display[] = [
                'id' => (string)$fieldId,
                'title' => (string)$field->title,
                'value' => $text,
            ];
        }

        return $display;
    }

}

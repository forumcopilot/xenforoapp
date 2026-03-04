<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCTopicDataResult;
use ForumCopilot\Result\FCNewTopicResult;
use ForumCopilot\Result\FCMarkTopicReadResult;
use ForumCopilot\Result\FCTopicStatusResult;
use ForumCopilot\Result\FCUnreadTopicResult;
use ForumCopilot\Result\FCParticipatedTopicResult;
use ForumCopilot\Result\FCLatestTopicResult;
use ForumCopilot\Result\FCTopicByIdsResult;
use ForumCopilot\Entity\FCTopic;
use ForumCopilot\Adapter\XenForoParamAdapter;

/**
 * Topic Controller for ForumCopilot API
 * Handles topic/thread operations
 */
class TopicController extends AbstractController
{
    public function actionGetTopic(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetTopicParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            // Try to get forum safely - handle exceptions from assertViewableForum
            $forum = null;
            try {
                $forum = $this->assertViewableForum($fcParams->forumId);
            } catch (\XF\Mvc\Reply\Exception $e) {
                // Extract XenForo's error message from the exception
                $reply = $e->getReply();
                if ($reply instanceof \XF\Mvc\Reply\Error) {
                    $errors = $reply->getErrors();
                    if (!empty($errors)) {
                        // Get first error message - Phrase objects will be rendered via __toString()
                        $errorMsg = is_array($errors) ? (string)($errors[0] ?? 'Forum not found or cannot be viewed') : (string)$errors;
                        return $this->apiError($errorMsg);
                    }
                }
                // Fallback if we can't extract the error
                return $this->apiError('Forum not found or cannot be viewed');
            } catch (\Exception $e) {
                return $this->apiError('Failed to get forum: ' . $e->getMessage());
            }
            
            if (!$forum) {
                return $this->apiError('Forum not found');
            }
            
            $visitor = \XF::visitor();
            
            // Use proper repository method (matches XenForo web implementation)
            $threadRepo = $this->repository('XF:Thread');
            $threadList = $threadRepo->findThreadsForForumView(
                $forum,
                ['allowOwnPending' => $this->hasContentPendingApproval()]
            );
            
            // Apply forum type handler adjustments (matches XenForo web implementation)
            $forumTypeHandler = $forum->TypeHandler;
            $perPage = $fcParams->lastNum - $fcParams->startNum + 1;
            $page = floor($fcParams->startNum / $perPage) + 1;
            if ($page < 1) {
                $page = 1;
            }
            $forumTypeHandler->adjustForumThreadListFinder($forum, $threadList, $page, $this->request);
            
            // Apply date limit filters (matches XenForo web/API implementation)
            if ($forum->list_date_limit_days) {
                $threadList->where('last_post_date', '>=', \XF::$time - ($forum->list_date_limit_days * 86400));
            }
            
            // Exclude sticky topics (they're retrieved via getTopTopic)
            $threadList->where('sticky', 0);
            
            // Order by last post date to show most recent activity first
            $threadList->order('last_post_date', 'DESC');
            
            // Apply pagination using limitByPage() (matches XenForo web/API implementation)
            $threadList->limitByPage($page, $perPage);
            
            $threads = $threadList->fetch();
            $total = $threadList->total();

            $topicList = [];
            foreach ($threads as $thread) {
                // Respect XenForo's permission system
                $error = null;
                if (!$thread->canView($error)) {
                    continue;
                }

                // Convert thread to FCTopic using shared method (use last post for preview to show latest activity)
                try {
                    $fcTopic = $this->convertThreadToFCTopic($thread, $visitor, ['useLastPost' => true]);
                    $topicList[] = $fcTopic;
                } catch (\Exception $e) {
                    // Skip this topic if conversion fails
                    continue;
                }
            }

            // Get forum watch status using helper method
            $forumWatchStatus = $this->getForumWatchStatus($forum, $visitor);

            // Ensure forumName is always a string (never null)
            $forumName = '';
            if ($forum->Node && isset($forum->Node->title)) {
                $forumName = (string)$forum->Node->title;
            }

            // Get dynamic forum values
            $canUpload = $forum->canUploadAndManageAttachments();
            $prefixes = [];
            try {
                $usablePrefixes = $forum->getUsablePrefixes();
                foreach ($usablePrefixes as $groupOrPrefix) {
                    if ($groupOrPrefix instanceof \XF\Entity\ThreadPrefix) {
                        $prefixes[] = [
                            'id' => (string)$groupOrPrefix->prefix_id,
                            'title' => $groupOrPrefix->title,
                        ];
                        continue;
                    }
                    if (is_array($groupOrPrefix) || $groupOrPrefix instanceof \Traversable) {
                        foreach ($groupOrPrefix as $prefix) {
                            if ($prefix instanceof \XF\Entity\ThreadPrefix) {
                                $prefixes[] = [
                                    'id' => (string)$prefix->prefix_id,
                                    'title' => $prefix->title,
                                ];
                            }
                        }
                    }
                }
            } catch (\Exception $e) {
                // If prefix retrieval fails, use empty array
                $prefixes = [];
            }
            $requirePrefix = $forum->require_prefix && count($prefixes) > 0;

            $result = new FCTopicDataResult(
                true,
                null,
                (int)$total,
                (string)$fcParams->forumId,
                $forumName,
                $forum->canCreateThread(),
                $canUpload,
                0, // unreadStickyCount
                0, // unreadAnnounceCount
                $forumWatchStatus['canWatch'],
                $forumWatchStatus['isWatched'],
                $requirePrefix,
                $prefixes,
                $topicList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get topics: ' . $e->getMessage());
        }
    }

    public function actionGetTopTopic(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetTopTopicParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            // Try to get forum safely - handle exceptions from assertViewableForum
            $forum = null;
            try {
                $forum = $this->assertViewableForum($fcParams->forumId);
            } catch (\XF\Mvc\Reply\Exception $e) {
                // Forum not found or not viewable - return empty result instead of error
                return $this->apiSuccess(new FCTopicDataResult(
                    true,
                    null,
                    0,
                    (string)$fcParams->forumId,
                    '',
                    false,
                    false,
                    0,
                    0,
                    false,
                    false,
                    false,
                    [],
                    []
                ));
            } catch (\Exception $e) {
                return $this->apiError('Failed to get forum: ' . $e->getMessage());
            }
            
            if (!$forum) {
                return $this->apiSuccess(new FCTopicDataResult(
                    true,
                    null,
                    0,
                    (string)$fcParams->forumId,
                    '',
                    false,
                    false,
                    0,
                    0,
                    false,
                    false,
                    false,
                    [],
                    []
                ));
            }
            
            $visitor = \XF::visitor();

            // Use proper repository method (matches XenForo web implementation for sticky threads)
            $threadRepo = $this->repository('XF:Thread');
            $threadList = $threadRepo->findThreadsForForumView(
                $forum,
                ['allowOwnPending' => $this->hasContentPendingApproval()]
            );

            // Apply forum type handler adjustments (matches XenForo web implementation)
            $forumTypeHandler = $forum->TypeHandler;
            $perPage = $fcParams->lastNum - $fcParams->startNum + 1;
            $page = floor($fcParams->startNum / $perPage) + 1;
            if ($page < 1) {
                $page = 1;
            }
            $forumTypeHandler->adjustForumThreadListFinder($forum, $threadList, $page, $this->request);

            // Sticky topics only (web clones thread list and filters sticky=1; we do not apply date limit to sticky list per web)
            $threadList->where('sticky', 1);
            $threadList->order('last_post_date', 'DESC');
            $threadList->limitByPage($page, $perPage);

            $threads = $threadList->fetch();
            $total = $threadList->total();

            $topicList = [];
            foreach ($threads as $thread) {
                // Respect XenForo's permission system
                $error = null;
                if (!$thread->canView($error)) {
                    continue;
                }

                // Convert thread to FCTopic using shared method (use last post for preview to show latest activity)
                try {
                    $fcTopic = $this->convertThreadToFCTopic($thread, $visitor, ['useLastPost' => true]);
                    $topicList[] = $fcTopic;
                } catch (\Exception $e) {
                    // Skip this topic if conversion fails
                    continue;
                }
            }

            // Get forum watch status using helper method
            $forumWatchStatus = $this->getForumWatchStatus($forum, $visitor);

            // Ensure forumName is always a string (never null)
            $forumName = '';
            if ($forum->Node && isset($forum->Node->title)) {
                $forumName = (string)$forum->Node->title;
            }

            // Dynamic forum values (matches getTopic)
            $canUpload = $forum->canUploadAndManageAttachments();
            $prefixes = [];
            try {
                $usablePrefixes = $forum->getUsablePrefixes();
                foreach ($usablePrefixes as $groupOrPrefix) {
                    if ($groupOrPrefix instanceof \XF\Entity\ThreadPrefix) {
                        $prefixes[] = [
                            'id' => (string)$groupOrPrefix->prefix_id,
                            'title' => $groupOrPrefix->title,
                        ];
                        continue;
                    }
                    if (is_array($groupOrPrefix) || $groupOrPrefix instanceof \Traversable) {
                        foreach ($groupOrPrefix as $prefix) {
                            if ($prefix instanceof \XF\Entity\ThreadPrefix) {
                                $prefixes[] = [
                                    'id' => (string)$prefix->prefix_id,
                                    'title' => $prefix->title,
                                ];
                            }
                        }
                    }
                }
            } catch (\Exception $e) {
                $prefixes = [];
            }
            $requirePrefix = $forum->require_prefix && count($prefixes) > 0;

            $result = new FCTopicDataResult(
                true,
                null,
                (int)$total,
                (string)$fcParams->forumId,
                $forumName,
                $forum->canCreateThread(),
                $canUpload,
                0, // unreadStickyCount
                0, // unreadAnnounceCount
                $forumWatchStatus['canWatch'],
                $forumWatchStatus['isWatched'],
                $requirePrefix,
                $prefixes,
                $topicList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get pinned topics: ' . $e->getMessage());
        }
    }

    public function actionGetAnnTopic(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetAnnTopicParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            // Try to get forum safely - handle exceptions from assertViewableForum
            $forum = null;
            try {
                $forum = $this->assertViewableForum($fcParams->forumId);
            } catch (\XF\Mvc\Reply\Exception $e) {
                // Forum not found or not viewable - return empty result instead of error
                return $this->apiSuccess(new FCTopicDataResult(
                    true,
                    null,
                    0,
                    (string)$fcParams->forumId,
                    '',
                    false,
                    false,
                    0,
                    0,
                    false,
                    false,
                    false,
                    [],
                    []
                ));
            } catch (\Exception $e) {
                return $this->apiError('Failed to get forum: ' . $e->getMessage());
            }
            
            if (!$forum) {
                return $this->apiSuccess(new FCTopicDataResult(
                    true,
                    null,
                    0,
                    (string)$fcParams->forumId,
                    '',
                    false,
                    false,
                    0,
                    0,
                    false,
                    false,
                    false,
                    [],
                    []
                ));
            }
            
            $visitor = \XF::visitor();

            // XenForo doesn't have announcements, return empty result with forum info
            // Get forum watch status using helper method
            $forumWatchStatus = $this->getForumWatchStatus($forum, $visitor);

            // Ensure forumName is always a string (never null)
            $forumName = '';
            if ($forum->Node && isset($forum->Node->title)) {
                $forumName = (string)$forum->Node->title;
            }

            $result = new FCTopicDataResult(
                true,
                null,
                0,
                (string)$fcParams->forumId,
                $forumName,
                $forum->canCreateThread(),
                false, // canUpload
                0, // unreadStickyCount
                0, // unreadAnnounceCount
                $forumWatchStatus['canWatch'],
                $forumWatchStatus['isWatched'],
                false, // requirePrefix
                [], // prefixes
                [] // topics
            );
            return $this->apiSuccess($result);
        } catch (\Exception $e) {
            return $this->apiError('Failed to get announcement topics: ' . $e->getMessage());
        }
    }

    public function actionGetLatestTopic(ParameterBag $params)
    {
        $fcParams = XenForoParamAdapter::toGetLatestTopicParams($params);

        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $visitor = \XF::visitor();

            if (!$visitor->user_id) {
                $hasViewPermission = $this->checkGuestViewPermissions();
                if (!$hasViewPermission) {
                    return $this->apiSuccess(new FCLatestTopicResult(
                        false,
                        'You do not have permission to view topics. Please log in to access this content.',
                        0,
                        []
                    ));
                }
            }

            // Setup base finder (restrict to viewable forums, eager load Forum/Node)
            $finder = $this->setupTopicListFinder(['restrictViewable' => true]);

            // Apply filters from request (unread, watched, participated, started, unanswered)
            $this->applyTopicFilters($finder, $fcParams->filters);

            $result = $this->buildTopicListFromFinder(
                $finder,
                $fcParams->startNum,
                $fcParams->lastNum,
                ['useLastPost' => true]
            );

            return $this->apiSuccess(new FCLatestTopicResult(
                true,
                null,
                $result['total'],
                $result['topics']
            ));
        } catch (\Exception $e) {
            return $this->apiError('Failed to get latest topics: ' . $e->getMessage());
        }
    }

    public function actionGetUnreadTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) {
            return $error;
        }

        $fcParams = XenForoParamAdapter::toGetLatestTopicParams($params);

        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $visitor = \XF::visitor();

            $finder = $this->setupTopicListFinder(['restrictViewable' => true]);

            // Unread is always on; merge with request filters (e.g. watched, participated)
            $filters = array_merge($fcParams->filters, ['unread' => true]);
            $this->applyTopicFilters($finder, $filters, $visitor);

            $result = $this->buildTopicListFromFinder(
                $finder,
                $fcParams->startNum,
                $fcParams->lastNum,
                ['useLastPost' => true]
            );

            return $this->apiSuccess(new FCUnreadTopicResult(
                true,
                null,
                $result['total'],
                $result['topics']
            ));
        } catch (\Exception $e) {
            return $this->apiError('Failed to get unread topics: ' . $e->getMessage());
        }
    }

    public function actionGetTopicByIds(ParameterBag $params)
    {
        $fcParams = XenForoParamAdapter::toGetTopicByIdsParams($params);

        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        $threadIds = $fcParams->getThreadIds();
        if (empty($threadIds)) {
            return $this->apiSuccess(new FCTopicByIdsResult(true, null, []));
        }

        try {
            $visitor = \XF::visitor();

            $finder = $this->finder('XF:Thread');
            $finder->where('thread_id', $threadIds);
            $finder->where('discussion_state', '<>', 'deleted');
            $finder->with(['Forum', 'Forum.Node', 'User']);

            $threads = $finder->fetch();

            $topicList = [];
            foreach ($threads as $thread) {
                $error = null;
                if (!$thread->canView($error)) {
                    continue;
                }

                try {
                    $fcTopic = $this->convertThreadToFCTopic($thread, $visitor);
                    $topicList[] = $fcTopic;
                } catch (\Exception $e) {
                    continue;
                }
            }

            return $this->apiSuccess(new FCTopicByIdsResult(true, null, $topicList));
        } catch (\Exception $e) {
            return $this->apiError('Failed to get topics: ' . $e->getMessage());
        }
    }

    public function actionNewTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) {
            return $error;
        }

        $fcParams = XenForoParamAdapter::toNewTopicParams($params);

        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $forum = $this->assertViewableForum($fcParams->forumId);
            $visitor = \XF::visitor();

            if (!$forum->canCreateThread($error)) {
                return $this->apiError('Cannot create thread in this forum: ' . ($error ? $error : 'Permission denied'));
            }

            $creator = $this->service('XF:Thread\Creator', $forum);
            $creator->setContent($fcParams->title, $fcParams->textBody);

            if (!empty($fcParams->prefixId) && $forum->isPrefixUsable($fcParams->prefixId)) {
                $creator->setPrefix($fcParams->prefixId);
            }

            if ($forum->canUploadAndManageAttachments()) {
                $attachmentHash = '';
                if ($fcParams->groupId !== null && $fcParams->groupId !== '') {
                    $attachmentHash = (string)$fcParams->groupId;
                } elseif (!empty($fcParams->attachmentIds)) {
                    $attachmentRepo = $this->repository('XF:Attachment');
                    $attachments = $attachmentRepo->findByIds($fcParams->attachmentIds);
                    $hashArray = [];
                    foreach ($attachments as $attachment) {
                        if ($attachment->canView() && $attachment->temp_hash) {
                            $hashArray[] = $attachment->temp_hash;
                        }
                    }
                    if ($hashArray) {
                        $attachmentHash = implode(',', $hashArray);
                    }
                }
                if ($attachmentHash !== '') {
                    $creator->setAttachmentHash($attachmentHash);
                }
            }

            if (!$creator->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            $this->checkFlooding('thread', $this->options()->floodCheckLengthDiscussion ?: null);

            $thread = $creator->save();
            $creator->sendNotifications();

            $this->repository('XF:Thread')->markThreadReadByVisitor($thread, $thread->post_date);

            $result = new FCNewTopicResult(
                true,
                null,
                (string)$thread->thread_id,
                $thread->canView() ? 0 : 1
            );

            return $this->apiSuccess($result);
        } catch (\Exception $e) {
            return $this->apiError('Failed to create topic: ' . $e->getMessage());
        }
    }

    public function actionMarkTopicRead(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicIds = $params->get('topicIds', []);

        if (empty($topicIds) || !is_array($topicIds)) {
            return $this->apiError('Topic IDs array is required');
        }

        try {
            $visitor = \XF::visitor();

            // Convert topic IDs to integers for query
            $threadIds = array_map('intval', $topicIds);
            
            // Use basic finder to avoid add-on conflicts
            $finder = $this->finder('XF:Thread');
            $finder->where('thread_id', $threadIds);
            
            $threads = $finder->fetch();

            foreach ($threads as $thread) {
                // Respect XenForo's permission system
                $error = null;
                if (!$thread->canView($error)) {
                    continue;
                }

                // Mark as read safely - avoid calling markThreadAsRead which may have XFMG conflicts
                // Instead, update thread read tracking directly
                try {
                    $threadRead = $this->em()->find('XF:ThreadRead', [
                        'thread_id' => $thread->thread_id,
                        'user_id' => $visitor->user_id
                    ]);
                    
                    if (!$threadRead) {
                        $threadRead = $this->em()->create('XF:ThreadRead');
                        $threadRead->thread_id = $thread->thread_id;
                        $threadRead->user_id = $visitor->user_id;
                    }
                    
                    $threadRead->thread_read_date = \XF::$time;
                    $threadRead->save();
                } catch (\Exception $e) {
                    // If ThreadRead entity doesn't exist or has conflicts, skip silently
                    // The thread will be marked as read on next view
                }
            }

            $result = new FCMarkTopicReadResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to mark topics as read: ' . $e->getMessage());
        }
    }

    public function actionGetParticipatedTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) {
            return $error;
        }

        $fcParams = XenForoParamAdapter::toGetParticipatedTopicParams($params);

        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $visitor = \XF::visitor();

            // Resolve target user: userId or username, or default to visitor
            $targetUser = $visitor;
            if (!empty($fcParams->userId)) {
                $targetUser = $this->em()->find('XF:User', (int)$fcParams->userId);
                if (!$targetUser) {
                    return $this->apiError('User not found');
                }
            } elseif (!empty(trim((string)$fcParams->username))) {
                $targetUser = $this->em()->findOne('XF:User', ['username' => $fcParams->username]);
                if (!$targetUser) {
                    return $this->apiError('User not found');
                }
            }

            // Use same finder pattern as getLatestTopic/getUnreadTopic: viewable forums + participated filter
            $finder = $this->setupTopicListFinder(['restrictViewable' => true]);
            $this->applyTopicFilters($finder, ['participated' => true], $targetUser);

            $result = $this->buildTopicListFromFinder(
                $finder,
                $fcParams->startNum,
                $fcParams->lastNum,
                ['useLastPost' => true]
            );

            return $this->apiSuccess(new FCParticipatedTopicResult(
                true,
                null,
                $result['total'],
                $result['topics']
            ));
        } catch (\Exception $e) {
            return $this->apiError('Failed to get participated topics: ' . $e->getMessage());
        }
    }

    /**
     * Check if guest visitor has any view permissions on forums with find_new enabled
     * Returns true if guest can view at least one forum, false otherwise
     * 
     * @return bool
     */
    protected function checkGuestViewPermissions()
    {
        $visitor = \XF::visitor();
        
        // Only check for guests
        if ($visitor->user_id) {
            return true; // Registered users are not checked here
        }
        
        // Get all forums with find_new enabled
        $forumFinder = $this->finder('XF:Forum');
        $forumFinder->where('find_new', true);
        $forumFinder->with('Node.Permissions|' . $visitor->permission_combination_id);
        $forums = $forumFinder->fetch();
        
        // Check if guest can view any forum with find_new enabled
        // A guest can view a forum if they have:
        // 1. 'view' permission (to view the forum)
        // 2. 'viewOthers' permission (to view threads created by others)
        // 3. 'viewContent' permission (to view thread content)
        foreach ($forums as $forum) {
            $nodeId = $forum->node_id;
            
            // Check all required permissions
            if ($visitor->hasNodePermission($nodeId, 'view') 
                && $visitor->hasNodePermission($nodeId, 'viewOthers')
                && $visitor->hasNodePermission($nodeId, 'viewContent')) {
                return true; // Guest has permissions on at least one forum
            }
        }
        
        return false; // Guest has no view permissions on any forum
    }
}

<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            // Try to get forum safely - handle exceptions from assertViewableForum
            $forum = null;
            try {
                $forum = $this->assertViewableForum($fcParams->forumId);
            } catch (\Exception $e) {
                return $this->apiException($e, 'Failed to get forum');
            }
            
            if (!$forum) {
                return $this->apiError('Forum not found', null, ErrorCode::NOT_FOUND);
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
            return $this->apiException($e, 'Failed to get topics');
        }
    }

    public function actionGetTopTopic(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetTopTopicParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
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
                return $this->apiException($e, 'Failed to get forum');
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
            return $this->apiException($e, 'Failed to get pinned topics');
        }
    }

    public function actionGetAnnTopic(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetAnnTopicParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
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
                return $this->apiException($e, 'Failed to get forum');
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
            return $this->apiException($e, 'Failed to get announcement topics');
        }
    }

    public function actionGetLatestTopic(ParameterBag $params)
    {
        $fcParams = XenForoParamAdapter::toGetLatestTopicParams($params);

        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
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
            return $this->apiException($e, 'Failed to get latest topics');
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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
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
            return $this->apiException($e, 'Failed to get unread topics');
        }
    }

    public function actionGetTopicByIds(ParameterBag $params)
    {
        $fcParams = XenForoParamAdapter::toGetTopicByIdsParams($params);

        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
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
            return $this->apiException($e, 'Failed to get topics');
        }
    }

    /**
     * Starts a thread the way XenForo's "Post thread" page does
     * (Pub ForumController::actionPostThread): canCreateThread, the spam
     * check, validation, the flood check, then the follow-ups of
     * finalizeThreadCreate (notifications, watching, read marking, the
     * forum's draft, the pending-approval flag).
     *
     * Optional params (1.11.0), as the website's form has them: tags (list
     * or comma-separated), customFields (field id => value), threadType
     * (one of the forum's threadTypes from getForum), and for a poll
     * isPoll or threadType "poll" with pollQuestion, pollOptions,
     * pollMaxVotes (0 = unlimited, default 1), pollChangeVote,
     * pollPublicVotes, pollViewResultsUnvoted (default true) and
     * pollCloseDays (0 = never). getForum says what each forum requires.
     */
    public function actionNewTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) {
            return $error;
        }

        $fcParams = XenForoParamAdapter::toNewTopicParams($params);

        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $forum = $this->assertViewableForum($fcParams->forumId);

            $error = null;
            if (!$forum->canCreateThread($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            $attachmentsIgnored = false;
            $creator = $this->setupThreadCreate($forum, $fcParams, $attachmentsIgnored);

            // Before validation, as XenForo does; spam that should be held
            // makes the thread moderated (state 1), other spam is an error.
            $creator->checkForSpam();

            if (!$creator->validate($errors)) {
                return $this->apiFieldErrors($errors);
            }

            if ($floodError = $this->checkFlooding('thread', $this->options()->floodCheckLengthDiscussion ?: null)) {
                return $floodError;
            }

            /** @var \XF\Entity\Thread $thread */
            $thread = $creator->save();
            $this->finalizeThreadCreate($creator);

            $result = new FCNewTopicResult(
                true,
                null,
                (string)$thread->thread_id,
                // 1 = held for moderator approval (see actionReplyPost).
                $thread->discussion_state === 'moderated' ? 1 : 0
            );
            if ($attachmentsIgnored) {
                // The forum doesn't let this member attach files
                $result->extra['attachmentsIgnored'] = true;
            }

            return $this->apiSuccess($result);
        } catch (\Throwable $e) {
            return $this->apiException($e, 'newTopic');
        }
    }

    /**
     * The thread creator with the app's input, as XenForo's
     * ForumController::setupThreadCreate fills it.
     *
     * attachmentIds is ignored: it named attachments that are already saved,
     * and the code reading it called a repository method that doesn't exist.
     * The app sends groupId (the upload hash) instead.
     *
     * @param \XF\Entity\Forum $forum
     * @param \ForumCopilot\Params\Topic\FCNewTopicParams $fcParams
     * @param bool $attachmentsIgnored set when files were sent to a forum
     *                                 where the member can't attach them
     * @return \XF\Service\Thread\Creator
     */
    protected function setupThreadCreate(\XF\Entity\Forum $forum, $fcParams, &$attachmentsIgnored = false)
    {
        $creator = $this->service('XF:Thread\Creator', $forum);

        // Thread type first, as XenForo does. Empty = the forum's default
        // type; one the forum doesn't offer is a validation error
        // ("Please select a valid thread type"), never a silent fallback.
        // The poll's input is handed over the way XenForo's poll form
        // sends it (poll[question], poll[new_responses]...).
        $typeRequest = new \XF\Http\Request(
            $this->app->container('inputFilterer'),
            $fcParams->wantsPoll() ? ['poll' => $fcParams->getPollFormInput()] : []
        );
        if (method_exists($creator, 'setDiscussionTypeAndDataForApi')) {
            $creator->setDiscussionTypeAndDataForApi($fcParams->getThreadType(), $typeRequest);
        } else {
            $creator->setDiscussionTypeAndData($fcParams->getThreadType(), $typeRequest);
        }

        $creator->setContent((string)$fcParams->title, (string)$fcParams->textBody);

        $prefixId = (int)$fcParams->prefixId;
        if ($prefixId && $forum->isPrefixUsable($prefixId)) {
            $creator->setPrefix($prefixId);
        }

        if ($forum->canEditTags()) {
            // XenForo checks the forum's minimum number of tags on validate
            $creator->setTags($fcParams->getTags());
        }

        // Always, as XenForo does: required thread fields are checked here
        // even when the app sends none.
        $creator->setCustomFields(is_array($fcParams->customFields) ? $fcParams->customFields : []);

        $attachmentHash = $fcParams->groupId !== null ? (string)$fcParams->groupId : '';
        if ($attachmentHash !== '') {
            if ($forum->canUploadAndManageAttachments()) {
                $creator->setAttachmentHash($attachmentHash);
            } else {
                $attachmentsIgnored = true;
            }
        }

        return $creator;
    }

    /**
     * XenForo's ForumController::finalizeThreadCreate, with watching by the
     * member's "watch content on creation" preference (the app sends no
     * watch choice).
     *
     * @param \XF\Service\Thread\Creator $creator
     */
    protected function finalizeThreadCreate($creator)
    {
        $creator->sendNotifications();

        $forum = $creator->getForum();
        $thread = $creator->getThread();

        $this->autoWatchThread($thread, true);

        $this->repository('XF:Thread')->markThreadReadByVisitor($thread, $thread->post_date);

        // The web editor's "forum-{id}" draft (shared with DraftController)
        $forum->draft_thread->delete();

        if ($thread->discussion_state == 'moderated') {
            // getTopic lists the member's own pending threads while this is set
            $this->session()->setHasContentPendingApproval();
        }
    }

    public function actionMarkTopicRead(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicIds = $params->get('topicIds', []);

        if (empty($topicIds) || !is_array($topicIds)) {
            return $this->apiError('Topic IDs array is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // Convert topic IDs to integers for query
            $threadIds = array_map('intval', $topicIds);

            // Load the visitor's thread and forum read markers with the threads
            $finder = $this->finder('XF:Thread');
            $finder->where('thread_id', $threadIds);
            $finder->withReadData();

            $threads = $finder->fetch();

            /** @var \XF\Repository\Thread $threadRepo */
            $threadRepo = $this->repository('XF:Thread');

            foreach ($threads as $thread) {
                // Respect XenForo's permission system
                $error = null;
                if (!$thread->canView($error)) {
                    continue;
                }

                // XenForo's own read marking, as when the thread is viewed on the web:
                // xf_thread_read moves to the later of now and the last post, and the
                // forum is marked read once none of its threads are unread. Watched-thread
                // reply alerts depend on this date (AbstractWatch::canNotify).
                $threadRepo->markThreadReadByVisitor($thread);
            }

            $result = new FCMarkTopicReadResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            \XF::logException($e, false, 'ForumCopilot markTopicRead: ');
            return $this->apiException($e, 'Failed to mark topics as read');
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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();

            // Resolve target user: userId or username, or default to visitor
            $targetUser = $visitor;
            if (!empty($fcParams->userId)) {
                $targetUser = $this->em()->find('XF:User', (int)$fcParams->userId);
                if (!$targetUser) {
                    return $this->apiError('User not found', null, ErrorCode::NOT_FOUND);
                }
            } elseif (!empty(trim((string)$fcParams->username))) {
                $targetUser = $this->em()->findOne('XF:User', ['username' => $fcParams->username]);
                if (!$targetUser) {
                    return $this->apiError('User not found', null, ErrorCode::NOT_FOUND);
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
            return $this->apiException($e, 'Failed to get participated topics');
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

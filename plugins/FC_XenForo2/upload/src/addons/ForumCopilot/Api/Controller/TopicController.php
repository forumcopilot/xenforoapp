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
    /** The forum page's "last N days" choices (-1 = any time), as XenForo's getAvailableDateLimits */
    const FORUM_DATE_LIMITS = [-1, 7, 14, 30, 60, 90, 182, 365];

    /**
     * One page of a forum's threads (not the sticky ones: getTopTopic), as
     * XenForo's forum page lists them.
     */
    public function actionGetTopic(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetTopicParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        return $this->getForumThreadList($fcParams, false);
    }

    /**
     * A forum's sticky threads.
     */
    public function actionGetTopTopic(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetTopTopicParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        return $this->getForumThreadList($fcParams, true);
    }

    /**
     * getTopic and getTopTopic: the forum's threads from XenForo's forum view
     * finder (Pub ForumController::actionForum), its sticky threads when
     * $sticky is set.
     *
     * A forum that doesn't exist or can't be seen is an error for both
     * (getTopTopic used to answer it with an empty success). So is a forum
     * whose threads the visitor may not read: see denyForumThreadList.
     *
     * @param \ForumCopilot\Params\Topic\FCGetTopicParams|\ForumCopilot\Params\Topic\FCGetTopTopicParams $fcParams
     */
    protected function getForumThreadList($fcParams, bool $sticky)
    {
        try {
            $forum = $this->assertViewableForum($fcParams->forumId);
            $visitor = \XF::visitor();

            if ($denied = $this->denyForumThreadList($forum, $fcParams->forumId)) {
                return $denied;
            }
            
            // Use proper repository method (matches XenForo web implementation)
            $threadRepo = $this->repository('XF:Thread');
            $threadList = $threadRepo->findThreadsForForumView(
                $forum,
                ['allowOwnPending' => $this->hasContentPendingApproval()]
            );
            
            // Everything the rows read, loaded with the threads
            $this->addTopicListWith($threadList);

            // The forum page's sort and filters (XenForo applies them to the sticky list too)
            $filters = $this->getForumFilterInput($forum, $fcParams);
            $this->applyForumFilters($forum, $threadList, $filters);

            // Apply forum type handler adjustments (matches XenForo web implementation)
            $forumTypeHandler = $forum->TypeHandler;
            [$offset, $perPage] = $this->getTopicListWindow($fcParams->startNum, $fcParams->lastNum);
            $page = (int)floor($offset / $perPage) + 1;
            $forumTypeHandler->adjustForumThreadListFinder($forum, $threadList, $page, $this->request);

            $dateLimitDays = 0;
            if ($sticky) {
                // The web clones the thread list and filters sticky=1, with no date limit
                $threadList->where('sticky', 1);
            } else {
                // The forum's date limit, or lastDays, unless noDateLimit (applyDateLimitFilters)
                $dateLimitDays = $this->applyDateLimitFilters($forum, $threadList, $filters);

                // Exclude sticky topics (they're retrieved via getTopTopic)
                $threadList->where('sticky', 0);
            }
            
            if (empty($filters['order']) && $fcParams->order !== 'forum') {
                // Without order: by last message, newest first, as before 1.11.0
                // (order "forum" keeps the forum's own default order)
                $threadList->order('last_post_date', 'DESC');
            }
            
            // Rows startNum..lastNum, at most 100
            $total = $threadList->total();
            $threads = $threadList->limit($perPage, $offset)->fetch();

            $topicList = [];
            foreach ($threads as $thread) {
                // Respect XenForo's permission system
                $error = null;
                if (!$thread->canView($error)) {
                    continue;
                }

                // Convert thread to FCTopic using shared method (use last post for preview to show latest activity)
                try {
                    $topicList[] = $this->convertThreadToFCTopic($thread, $visitor, ['useLastPost' => true]);
                } catch (\Exception $e) {
                    // Skip this topic if conversion fails
                    continue;
                }
            }

            $result = $this->newForumTopicDataResult($forum, $fcParams->forumId, (int)$total, $topicList);
            $result->extra = $this->getForumListDetails($forum, $filters, $fcParams, $dateLimitDays);
            return $this->apiSuccess($result);

        } catch (\Throwable $e) {
            return $this->apiException($e, $sticky ? 'Failed to get pinned topics' : 'Failed to get topics');
        }
    }

    /**
     * The sort and filters for a forum's thread list, checked as XenForo's
     * ForumController::getForumFilterInput checks them: a prefix the forum
     * uses, a member by id or name, a date limit from the forum page's
     * choices, a sort the forum type offers, a thread type the forum allows,
     * then the forum type's own filters (questions: unsolved, ...). Values
     * that don't apply are left out, as on the website.
     *
     * @param \ForumCopilot\Params\Topic\FCGetTopicParams $fcParams
     * @return array XenForo's filter names (prefix_id, starter_id, ...)
     */
    protected function getForumFilterInput(\XF\Entity\Forum $forum, $fcParams): array
    {
        $visitor = \XF::visitor();
        $filters = [];

        if ($fcParams->noDateLimit) {
            $filters['no_date_limit'] = true;
        }

        if ($fcParams->prefixId && $forum->isPrefixValid($fcParams->prefixId)) {
            $filters['prefix_id'] = $fcParams->prefixId;
        }

        if ($fcParams->starterId) {
            $filters['starter_id'] = $fcParams->starterId;
        } elseif ($fcParams->starterName !== '') {
            $user = $this->em()->findOne('XF:User', ['username' => $fcParams->starterName]);
            if ($user) {
                $filters['starter_id'] = $user->user_id;
            }
        }

        $lastDays = $fcParams->lastDays;
        if ($lastDays !== null
            && in_array($lastDays, self::FORUM_DATE_LIMITS, true)
            && (($lastDays > 0 && $lastDays != $forum->list_date_limit_days) || ($lastDays < 0 && $forum->list_date_limit_days))
        ) {
            $filters['last_days'] = $lastDays;
        }

        $sorts = $forum->TypeHandler->getThreadListSortOptions($forum);
        if ($fcParams->order && isset($sorts[$fcParams->order])) {
            // Kept even when it is the forum's default: without it the API sorts by last message
            $filters['order'] = $fcParams->order;
            $filters['direction'] = $fcParams->direction === 'asc' ? 'asc' : 'desc';
        }

        if ($fcParams->threadType !== '' && $forum->TypeHandler->isThreadTypeAllowed($fcParams->threadType, $forum)) {
            $filters['thread_type'] = $fcParams->threadType;
        }

        if ($fcParams->unread && $visitor->user_id) {
            // As the REST API's thread list offers it
            $filters['unread'] = true;
        }

        // The forum type reads its own filters from the request, as the form sends them
        $typeRequest = new \XF\Http\Request($this->app->container('inputFilterer'), $fcParams->typeFilters);

        return $forum->TypeHandler->getForumFilterInput($forum, $typeRequest, $filters);
    }

    /**
     * XenForo's ForumController::applyForumFilters, plus unread.
     */
    protected function applyForumFilters(\XF\Entity\Forum $forum, \XF\Finder\Thread $threadFinder, array $filters)
    {
        if (!empty($filters['prefix_id'])) {
            $threadFinder->where('prefix_id', (int)$filters['prefix_id']);
        }

        if (!empty($filters['starter_id'])) {
            $threadFinder->where('user_id', (int)$filters['starter_id']);
        }

        if (!empty($filters['thread_type'])) {
            $threadFinder->where('discussion_type', $filters['thread_type']);
        }

        if (!empty($filters['unread'])) {
            $threadFinder->unreadOnly(\XF::visitor()->user_id);
        }

        $sorts = $forum->TypeHandler->getThreadListSortOptions($forum);
        if (!empty($filters['order']) && isset($sorts[$filters['order']])) {
            $threadFinder->order($sorts[$filters['order']], $filters['direction']);
        }

        $forum->TypeHandler->applyForumFilters($forum, $threadFinder, $filters);
    }

    /**
     * XenForo's ForumController::applyDateLimitFilters.
     *
     * @return int the date limit applied, in days (0 = none)
     */
    protected function applyDateLimitFilters(\XF\Entity\Forum $forum, \XF\Finder\Thread $threadFinder, array $filters): int
    {
        if (!empty($filters['no_date_limit'])) {
            return 0;
        }

        $days = !empty($filters['last_days']) ? (int)$filters['last_days'] : (int)$forum->list_date_limit_days;
        if ($days > 0) {
            $threadFinder->where('last_post_date', '>=', \XF::$time - ($days * 86400));
            return $days;
        }

        return 0;
    }

    /**
     * getTopic's sort and filter details (1.11.0):
     *   - appliedFilters: the filters in effect, by param name (values that
     *     didn't apply are missing), and the order used;
     *   - sortOptions: [{key, title}], the orders this forum offers;
     *   - defaultOrder / defaultDirection: the forum's own default order
     *     (order "forum");
     *   - dateLimitDays / isDateLimited: the date limit in effect (getTopic
     *     only), and dateLimitOptions, the forum page's choices for lastDays
     *     (-1 = any time). When a date-limited list runs out, noDateLimit or
     *     lastDays -1 shows the older threads, like the website's "Show older
     *     items".
     */
    protected function getForumListDetails(\XF\Entity\Forum $forum, array $filters, $fcParams, int $dateLimitDays): array
    {
        $names = [
            'prefix_id' => 'prefixId',
            'starter_id' => 'starterId',
            'last_days' => 'lastDays',
            'no_date_limit' => 'noDateLimit',
            'thread_type' => 'threadType',
            'unread' => 'unread',
            'order' => 'order',
            'direction' => 'direction',
        ];
        $applied = [];
        $typeFilters = [];
        foreach ($filters as $key => $value) {
            if (isset($names[$key])) {
                $applied[$names[$key]] = $value;
            } else {
                $typeFilters[$key] = $value;
            }
        }
        if ($typeFilters) {
            $applied['typeFilters'] = $typeFilters;
        }
        if (!isset($applied['order'])) {
            $useForumOrder = ($fcParams->order === 'forum');
            $applied['order'] = $useForumOrder ? (string)$forum->default_sort_order : 'last_post_date';
            $applied['direction'] = $useForumOrder ? (string)$forum->default_sort_direction : 'desc';
        }

        $sortOptions = [];
        foreach (array_keys($forum->TypeHandler->getThreadListSortOptions($forum)) as $key) {
            $sortOptions[] = ['key' => $key, 'title' => $this->plainText(\XF::phrase('forum_sort.' . $key))];
        }

        return [
            'appliedFilters' => $applied,
            'sortOptions' => $sortOptions,
            'defaultOrder' => (string)$forum->default_sort_order,
            'defaultDirection' => (string)$forum->default_sort_direction,
            'dateLimitDays' => $dateLimitDays,
            'isDateLimited' => $dateLimitDays > 0,
            'dateLimitOptions' => self::FORUM_DATE_LIMITS,
        ];
    }

    /**
     * The refusal for a forum the visitor may see but whose threads they may
     * not read (XenForo shows the forum with no threads):
     *   - a guest without "View thread content" or "View threads by others":
     *     guest_denied with XenForo's "You must be logged-in to do that.";
     *   - a member without "View thread content": no_permission. A member
     *     without "View others' threads" still gets their own threads.
     *
     * The reply keeps the list's fields (topics [], totalTopicNum 0, the
     * forum's name...). A 1.x app's forum page reads only topics from it and
     * shows the same empty list as before, when this answered success.
     *
     * @return \XF\Http\Response|null
     */
    protected function denyForumThreadList(\XF\Entity\Forum $forum, $forumId)
    {
        $visitor = \XF::visitor();
        $nodeId = $forum->node_id;

        if (!$visitor->hasNodePermission($nodeId, 'viewContent')) {
            $denied = true;
        } else {
            $denied = !$visitor->user_id && !$visitor->hasNodePermission($nodeId, 'viewOthers');
        }
        if (!$denied) {
            return null;
        }

        $isGuest = !$visitor->user_id;
        $text = $this->plainText(\XF::phrase($isGuest ? 'login_required' : 'do_not_have_permission'));
        $result = $this->newForumTopicDataResult($forum, $forumId, 0, [], false, $text);

        return $this->apiError($result, null, $isGuest ? ErrorCode::GUEST_DENIED : ErrorCode::NO_PERMISSION);
    }

    /**
     * getTopic's reply: the page of topics with the forum's details.
     */
    protected function newForumTopicDataResult(
        \XF\Entity\Forum $forum,
        $forumId,
        int $total,
        array $topics,
        bool $success = true,
        ?string $resultText = null
    ): FCTopicDataResult
    {
        $visitor = \XF::visitor();

        // Get forum watch status using helper method
        $forumWatchStatus = $this->getForumWatchStatus($forum, $visitor);

        // Ensure forumName is always a string (never null)
        $forumName = $forum->Node ? (string)$forum->Node->title : '';

        $prefixes = $this->getUsablePrefixList($forum);

        return new FCTopicDataResult(
            $success,
            $resultText,
            $total,
            (string)$forumId,
            $forumName,
            $forum->canCreateThread(),
            $forum->canUploadAndManageAttachments(),
            0, // unreadStickyCount
            0, // unreadAnnounceCount
            $forumWatchStatus['canWatch'],
            $forumWatchStatus['isWatched'],
            $forum->require_prefix && count($prefixes) > 0,
            $prefixes,
            $topics
        );
    }

    /**
     * XenForo has no announcements: always an empty list. The app no longer
     * calls this.
     */
    public function actionGetAnnTopic(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetAnnTopicParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        return $this->apiSuccess(new FCTopicDataResult(
            true,
            null,
            0,
            (string)$fcParams->forumId,
            '',
            false,
            false, // canUpload
            0, // unreadStickyCount
            0, // unreadAnnounceCount
            false,
            false,
            false, // requirePrefix
            [], // prefixes
            [] // topics
        ));
    }

    /**
     * What's New: recent threads in the forums shown there.
     *
     * A guest who may read no thread in those forums gets guest_denied with
     * XenForo's "You must be logged-in to do that." (it was an English-only
     * sentence); the app shows it in place of the list.
     */
    public function actionGetLatestTopic(ParameterBag $params)
    {
        $fcParams = XenForoParamAdapter::toGetLatestTopicParams($params);

        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();

            if (!$visitor->user_id && !$this->getReadableForumIds(true)['full']) {
                return $this->apiError(
                    new FCLatestTopicResult(false, $this->plainText(\XF::phrase('login_required')), 0, []),
                    null,
                    ErrorCode::GUEST_DENIED
                );
            }

            // Setup base finder (restrict to readable forums, eager load what rows read)
            $finder = $this->setupTopicListFinder([
                'restrictViewable' => true,
                'includeModerated' => $fcParams->includeModerated,
            ]);

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
        } catch (\Throwable $e) {
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
        if (count($threadIds) > self::TOPIC_LIST_MAX_ROWS) {
            return $this->apiError(
                'Invalid parameters: at most ' . self::TOPIC_LIST_MAX_ROWS . ' topicIds',
                null,
                ErrorCode::BAD_REQUEST
            );
        }

        try {
            $visitor = \XF::visitor();

            // canView below decides, as on the thread page: soft-deleted
            // threads show to moderators who may see them
            $finder = $this->finder('XF:Thread');
            $finder->where('thread_id', $threadIds);
            $this->addTopicListWith($finder, false);

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
        if (count($topicIds) > self::TOPIC_LIST_MAX_ROWS) {
            return $this->apiError(
                'Invalid parameters: at most ' . self::TOPIC_LIST_MAX_ROWS . ' topicIds',
                null,
                ErrorCode::BAD_REQUEST
            );
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
}

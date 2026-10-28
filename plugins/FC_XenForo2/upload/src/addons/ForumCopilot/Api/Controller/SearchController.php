<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCSearchTopicResult;
use ForumCopilot\Result\FCSearchPostResult;
use ForumCopilot\Result\FCSearchDataResultTopic;
use ForumCopilot\Result\FCSearchDataResultPost;
use ForumCopilot\Adapter\XenForoParamAdapter;

/**
 * Search Controller for ForumCopilot API
 * Handles search operations
 */
class SearchController extends AbstractController
{
    public function actionSearchTopic(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toSearchTopicParams($params);

        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            if ($denied = $this->assertCanSearch()) {
                return $denied;
            }

            // XenForo's "Search threads": posts and threads, one result per thread
            $page = $this->runSearchPage([
                'search_type' => 'post',
                'keywords' => $fcParams->searchString,
                'c' => [],
                'grouped' => 1,
            ], (int)$fcParams->startNum, (int)$fcParams->lastNum - (int)$fcParams->startNum + 1, (int)$fcParams->searchId);
            if (!is_array($page)) {
                return $page;
            }

            $result = new FCSearchTopicResult(
                true,
                null,
                $page['total'],
                $page['searchId'],
                $this->topicRowsForResults($page['results'])
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Search failed');
        }
    }

    public function actionSearchPost(ParameterBag $params)
    {
        $searchString = (string)$params->get('searchString', '');
        $startNum = (int)$params->get('startNum', 0);
        $lastNum = (int)$params->get('lastNum', 19);
        $searchId = (int)$params->get('searchId', 0);

        if ($searchString === '') {
            return $this->apiError('Search string is required', null, ErrorCode::VALIDATION);
        }

        try {
            if ($denied = $this->assertCanSearch()) {
                return $denied;
            }

            $page = $this->runSearchPage([
                'search_type' => 'post',
                'keywords' => $searchString,
                'c' => [],
                'order' => 'date',
            ], $startNum, $lastNum - $startNum + 1, $searchId);
            if (!is_array($page)) {
                return $page;
            }

            $result = new FCSearchPostResult(
                true,
                null,
                $page['total'],
                $page['searchId'],
                $this->postRowsForResults($page['results'])
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Search failed');
        }
    }

    /**
     * Topic search, the one the app's Search tab uses. Runs on XenForo's own
     * search, like the website's "Search threads": its search index, minimum
     * word length, result limit and per-member result cache, with permissions
     * applied before results are counted. Rows are full topic rows.
     */
    public function actionAdvanceSearchTopic(ParameterBag $params)
    {
        return $this->advancedSearch($params, true);
    }

    public function actionAdvanceSearchPost(ParameterBag $params)
    {
        return $this->advancedSearch($params, false);
    }

    /**
     * advanceSearchTopic and advanceSearchPost. Params as before: keywords,
     * page, perpage, searchId (reuses the member's own earlier search for the
     * same words), titleOnly, userId or searchUser (member names), forumId and
     * onlyIn (forums to search), notIn (forums to leave out), topicId,
     * startedBy (with a member: threads they started) and searchTime (newer
     * than, a Unix time).
     */
    protected function advancedSearch(ParameterBag $params, bool $topics)
    {
        $keywords = trim((string)$params->get('keywords', ''));
        $page = max(1, (int)$params->get('page', 1));
        $perpage = max(1, min(100, (int)$params->get('perpage', 20)));
        $searchId = (int)$params->get('searchId', 0);
        $titleOnly = (bool)$params->get('titleOnly', false);
        $userId = (int)$params->get('userId', 0);
        $searchUser = trim((string)$params->get('searchUser', ''));
        $forumId = (int)$params->get('forumId', 0);
        $topicId = (int)$params->get('topicId', 0);
        $onlyIn = $params->get('onlyIn', []);
        $notIn = $params->get('notIn', []);
        $startedBy = (bool)$params->get('startedBy', false);
        $searchTime = (int)$params->get('searchTime', 0);

        if ($keywords === '') {
            return $this->apiError('Search keywords are required', null, ErrorCode::VALIDATION);
        }

        try {
            if ($denied = $this->assertCanSearch()) {
                return $denied;
            }

            $constraints = ['title_only' => $titleOnly ? 1 : 0];

            // Members by name only, as XenForo's search form takes them
            $userName = '';
            if ($userId) {
                $user = $this->em()->find('XF:User', $userId);
                if (!$user) {
                    return $this->apiError(\XF::phrase('requested_member_not_found'), null, ErrorCode::NOT_FOUND);
                }
                $userName = $user->username;
            } elseif ($searchUser !== '') {
                $userName = $searchUser;
            }
            if ($userName !== '') {
                $constraints['users'] = $userName;
            }

            // Threads a member started: XenForo's thread search, whose
            // results are threads by their starter
            $searchType = ($topics && $startedBy && $userName !== '') ? 'thread' : 'post';

            $nodeIds = [];
            if ($forumId) {
                $nodeIds[] = $forumId;
            }
            if (is_array($onlyIn)) {
                $nodeIds = array_merge($nodeIds, array_map('intval', $onlyIn));
            }
            if (!$nodeIds && is_array($notIn) && $notIn) {
                // XenForo's search takes forums to include; leaving some out
                // means every other forum the member can see
                $exclude = array_map('intval', $notIn);
                $nodeIds = array_diff($this->getViewableForumIds(), $exclude);
                if (!$nodeIds) {
                    $nodeIds = [0];
                }
            }
            if ($nodeIds) {
                $constraints['nodes'] = array_values(array_unique(array_filter($nodeIds, function ($id) {
                    return $id >= 0;
                })));
            }
            if ($topicId && $searchType === 'post') {
                $constraints['thread'] = $topicId;
            }
            if ($searchTime > 0) {
                // A number: XenForo's datetime filter takes it as a Unix time.
                // Formatting it as a date read it in the member's timezone.
                $constraints['newer_than'] = $searchTime;
            }

            $input = [
                'search_type' => $searchType,
                'keywords' => $keywords,
                'c' => $constraints,
                'order' => 'date',
            ];
            if ($topics && $searchType === 'post') {
                $input['grouped'] = 1;
            }

            $result = $this->runSearchPage($input, ($page - 1) * $perpage, $perpage, $searchId);
            if (!is_array($result)) {
                return $result;
            }

            if ($topics) {
                $reply = new FCSearchDataResultTopic(
                    true,
                    null,
                    $result['total'],
                    $result['searchId'],
                    $this->topicRowsForResults($result['results'], $topicId)
                );
            } else {
                $reply = new FCSearchDataResultPost(
                    true,
                    null,
                    $result['total'],
                    $result['searchId'],
                    $this->postRowsForResults($result['results'])
                );
            }

            return $this->apiSuccess($reply);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Advanced search failed');
        }
    }

    /**
     * The member may search, as XenForo's search pages require.
     *
     * @return \XF\Http\Response|null an error reply, or null
     */
    protected function assertCanSearch()
    {
        $error = null;
        if (!\XF::visitor()->canSearch($error)) {
            return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
        }
        return null;
    }

    /**
     * Ids of the forums the visitor can view.
     */
    protected function getViewableForumIds(): array
    {
        $ids = [];
        foreach ($this->repository('XF:Node')->getNodeList() as $node) {
            if ($node->node_type_id === 'Forum') {
                $ids[] = (int)$node->node_id;
            }
        }
        return $ids;
    }

    /**
     * Runs a XenForo search, or reuses the member's own earlier one when
     * searchId names a search for the same words and type (as XenForo's
     * results page does), then cuts out one page of viewable results.
     *
     * @param array $input search form input for prepareSearchQuery
     * @param int $offset results to skip
     * @param int $limit page size, at most 100
     * @param int $searchId an earlier search's id, or 0
     * @return array|\XF\Http\Response ['results' => entities, 'total' => int,
     *                                 'searchId' => string|null], or an error reply
     */
    protected function runSearchPage(array $input, int $offset, int $limit, int $searchId)
    {
        $offset = max(0, $offset);
        $limit = max(1, min(100, $limit));
        $visitor = \XF::visitor();
        $searcher = $this->app()->search();

        $search = null;
        if ($searchId) {
            /** @var \XF\Entity\Search|null $existing */
            $existing = $this->em()->find('XF:Search', $searchId);
            $keywords = $this->app->stringFormatter()->censorText((string)$input['keywords'], '');
            if ($existing
                && $existing->user_id == $visitor->user_id
                && $existing->search_type === $input['search_type']
                && $existing->search_query === $keywords
                && (!$existing->isValidColumn('search_grouping')
                    || (bool)$existing->search_grouping === !empty($input['grouped']))
            ) {
                $search = $existing;
            }
        }

        if (!$search) {
            $query = $this->prepareSearchQuery($input, $constraints);
            if ($query->getErrors()) {
                return $this->apiFieldErrors($query->getErrors());
            }

            $error = null;
            if ($searcher->isQueryEmpty($query, $error)) {
                return $this->apiError($error ?: \XF::phrase('please_specify_search_query_or_name_of_member'), null, ErrorCode::VALIDATION);
            }

            $search = $this->repository('XF:Search')->runSearch($query, $constraints, true);
            if (!$search) {
                return ['results' => [], 'total' => 0, 'searchId' => null];
            }
        }

        $resultSet = $searcher->getResultSet($search->search_results);
        if (method_exists($resultSet, 'sliceResults')) {
            $resultSet->sliceResults($offset, $limit);
        } else {
            $resultSet->sliceResultsToPage((int)floor($offset / $limit) + 1, $limit);
        }
        $resultSet->limitToViewableResults();

        $results = [];
        foreach ($searcher->wrapResultsForRender($resultSet, ['search' => $search, 'term' => $search->search_query]) as $wrapper) {
            $results[] = $wrapper->getResult();
        }

        return [
            'results' => $results,
            'total' => (int)$search->result_count,
            'searchId' => (string)$search->search_id,
        ];
    }

    /**
     * Topic rows for search results: threads, or the threads of post results
     * (once each). Read and watch state for the whole page come from one
     * query, rather than two per thread.
     *
     * @param array $results search result entities
     * @param int $onlyTopicId when set, only this thread
     */
    protected function topicRowsForResults(array $results, int $onlyTopicId = 0): array
    {
        $threads = [];
        foreach ($results as $entity) {
            $thread = $entity instanceof \XF\Entity\Thread
                ? $entity
                : ($entity instanceof \XF\Entity\Post ? $entity->Thread : null);
            if ($thread && !isset($threads[$thread->thread_id])
                && (!$onlyTopicId || $thread->thread_id == $onlyTopicId)
            ) {
                $threads[$thread->thread_id] = $thread;
            }
        }

        $visitorId = \XF::visitor()->user_id;
        if ($threads && $visitorId) {
            $this->finder('XF:Thread')
                ->whereIds(array_keys($threads))
                ->with(['Read|' . $visitorId, 'Watch|' . $visitorId])
                ->fetch();
        }

        $rows = [];
        foreach ($threads as $thread) {
            $rows[] = $this->convertThreadToApiFormat($thread);
        }
        return $rows;
    }

    /**
     * Post rows for search results. XenForo's post search also finds threads
     * by their title; those come as the thread's first post, once.
     */
    protected function postRowsForResults(array $results): array
    {
        $rows = [];
        $seen = [];
        foreach ($results as $entity) {
            if ($entity instanceof \XF\Entity\Thread) {
                $entity = $entity->FirstPost;
            }
            if ($entity instanceof \XF\Entity\Post && !isset($seen[$entity->post_id]) && $entity->canView()) {
                $seen[$entity->post_id] = true;
                $rows[] = $this->convertPostToApiFormat($entity);
            }
        }
        return $rows;
    }

    /**
     * Prepare search query from input data (same as XenForo web search)
     * 
     * @param array $data
     * @param array &$urlConstraints
     * @return \XF\Search\Query\KeywordQuery
     */
    protected function prepareSearchQuery(array $data, &$urlConstraints = [])
    {
        $searchRequest = new \XF\Http\Request($this->app->inputFilterer(), $data, [], []);
        $input = $searchRequest->filter([
            'search_type' => 'str',
            'keywords' => 'str',
            'c' => 'array',
            'c.title_only' => 'uint',
            'c.newer_than' => 'datetime',
            'c.older_than' => 'datetime',
            'c.users' => 'str',
            'c.content' => 'str',
            'c.type' => 'str',
            'c.thread_type' => 'str',
            'c.thread' => 'uint',
            'c.nodes' => 'array-uint',
            'c.child_nodes' => 'bool',
            'grouped' => 'bool',
            'order' => 'str',
        ]);

        $urlConstraints = $input['c'];

        $searcher = $this->app()->search();
        $query = $searcher->getQuery();

        if ($input['search_type'] && $searcher->isValidContentType($input['search_type'])) {
            $typeHandler = $searcher->handler($input['search_type']);
            $query->forTypeHandler($typeHandler, $searchRequest, $urlConstraints);
        }

        // Censor keywords (same as web search)
        $input['keywords'] = $this->app->stringFormatter()->censorText($input['keywords'], '');
        if ($input['keywords']) {
            $query->withKeywords($input['keywords'], $input['c.title_only']);
        }

        if ($input['c.newer_than']) {
            $query->newerThan($input['c.newer_than']);
        } else {
            unset($urlConstraints['newer_than']);
        }
        
        if ($input['c.older_than']) {
            $query->olderThan($input['c.older_than']);
        } else {
            unset($urlConstraints['older_than']);
        }

        if ($input['c.users']) {
            $users = \XF\Util\Arr::stringToArray($input['c.users'], '/,\s*/');
            if ($users) {
                $userRepo = $this->repository('XF:User');
                $matchedUsers = $userRepo->getUsersByNames($users, $notFound);
                if ($notFound) {
                    $query->error(
                        'users',
                        \XF::phrase('following_members_not_found_x', ['members' => implode(', ', $notFound)])
                    );
                } else {
                    $query->byUserIds($matchedUsers->keys());
                    $urlConstraints['users'] = implode(', ', $users);
                }
            }
        }

        if ($input['c.content']) {
            $query->inType($input['c.content']);
        } else if ($input['c.type']) {
            $query->inType($input['c.type']);
        }

        if ($input['c.thread_type'] && $query->getTypes() == ['thread']) {
            $query->withMetadata('thread_type', $input['c.thread_type']);
        }

        // One result per thread, as XenForo's "Search threads" (2.2+)
        if ($input['grouped'] && method_exists($query, 'withGroupedResults')) {
            $query->withGroupedResults();
        }

        if ($input['order']) {
            $query->orderedBy($input['order']);
        }

        return $query;
    }

    /**
     * Convert Thread entity to API format
     * 
     * @param \XF\Entity\Thread $thread
     * @return \ForumCopilot\Entity\FCTopic
     */
    protected function convertThreadToApiFormat(\XF\Entity\Thread $thread)
    {
        $forumName = 'Unknown';
        if ($thread->Forum && $thread->Forum->Node) {
            $forumName = $thread->Forum->Node->title;
        }

        // Get like count from first post
        $likeCount = 0;
        if ($thread->FirstPost) {
            $likeCount = $this->getReactionCount($thread->FirstPost);
        }

        // Get short content from first post
        $shortContent = '';
        if ($thread->FirstPost && $thread->FirstPost->message) {
            $shortContent = $this->getShortContent($thread->FirstPost->message);
        }

        // Get author info - ensure User relation is loaded
        $user = $thread->User;
        if (!$user && $thread->user_id) {
            // User relation not loaded, load it manually
            $user = $this->em()->find('XF:User', $thread->user_id);
        }
        
        $authorName = $user ? $user->username : ($thread->username ?: 'Unknown');
        $authorId = (string)$thread->user_id;
        $authorUserType = $user ? (string)$user->user_group_id : '0';
        
        // Get avatar URL - handle null return from getAvatarUrl
        $authorIconUrl = '';
        if ($user) {
            $avatarUrl = $user->getAvatarUrl('s');
            if ($avatarUrl !== null) {
                $authorIconUrl = $this->getAbsoluteUrl($avatarUrl);
            }
        }

        // Check if user can view thread content (viewContent permission)
        $visitor = \XF::visitor();
        $canViewContent = $visitor->hasNodePermission($thread->node_id, 'viewContent');
        
        return new \ForumCopilot\Entity\FCTopic([
            'id' => (string)$thread->thread_id,
            'title' => $thread->title,
            'forumId' => (string)$thread->node_id,
            'forumName' => $forumName,
            'authorId' => $authorId,
            'authorName' => $authorName,
            'authorUserType' => $authorUserType,
            'timestamp' => $thread->post_date * 1000,
            'authorIconUrl' => $authorIconUrl,
            'replyCount' => $thread->reply_count,
            'viewCount' => $thread->view_count,
            'hasNewPosts' => $thread->isUnread(),
            'isClosed' => !$thread->discussion_open,
            'isSubscribed' => $thread->isWatched(),
            'canSubscribe' => $thread->canWatch(),
            'url' => $this->buildLink('canonical:threads', $thread),
            'shortContent' => $shortContent,
            'participatedUserIds' => [],
            'isPinned' => (bool)$thread->sticky,
            'isAnnouncement' => false,
            'isStickySource' => (bool)$thread->sticky,
            'canRename' => $thread->canEdit(),
            'canDelete' => $thread->canDelete(),
            'canClose' => $thread->canLockUnlock(),
            'canApprove' => $thread->canApproveUnapprove(),
            'canStick' => $thread->canStickUnstick(),
            'canMove' => $thread->canMove(),
            'canMerge' => $thread->canMerge(),
            'canBan' => false,
            'canReply' => $thread->canReply(),
            'canViewContent' => $canViewContent,
            'canReport' => $thread->FirstPost ? $thread->FirstPost->canReport() : false,
            'canUpload' => false,
            'isBanned' => false,
            'isApproved' => $thread->discussion_state === 'visible',
            'isDeleted' => $thread->discussion_state === 'deleted',
            'isMoved' => false,
            'isMerged' => false,
            'realTopicId' => null,
            'canLike' => $thread->FirstPost ? $thread->FirstPost->canReact() : false,
            'isLiked' => false, // Would need to check visitor's reactions
            'likeCount' => $likeCount,
        ]);
    }

    /**
     * Convert Post entity to API format
     * 
     * @param \XF\Entity\Post $post
     * @return array
     */
    protected function convertPostToApiFormat(\XF\Entity\Post $post)
    {
        $threadTitle = 'Unknown';
        if ($post->Thread) {
            $threadTitle = $post->Thread->title;
        }

        $authorName = $post->User ? $post->User->username : ($post->username ?: 'Unknown');
        
        $authorIconUrl = '';
        $authorIsBanned = false;
        if ($post->User) {
            $authorIconUrl = $this->getAbsoluteUrl($post->User->getAvatarUrl('s'));
            $authorIsBanned = (bool)($post->User->is_banned ?? false);
        }
        
        $preview = '';
        if ($post->message) {
            $preview = $this->getShortContent($post->message);
        }

        return [
            'id' => (string)$post->post_id,
            'topicId' => (string)$post->thread_id,
            'title' => $threadTitle,
            'authorId' => (string)$post->user_id,
            'authorName' => $authorName,
            'authorIconUrl' => $authorIconUrl,
            'timestamp' => $post->post_date * 1000,
            'content' => $preview,
            'url' => $this->buildLink('canonical:posts', $post),
            'isBanned' => $authorIsBanned,
        ];
    }
}

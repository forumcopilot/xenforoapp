<?php

namespace ForumCopilot\Api\Controller;

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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $visitor = \XF::visitor();
            if (!$visitor->canSearch()) {
                return $this->apiError('Search is not allowed');
            }

            // Build search input matching XenForo's web format
            // Don't specify 'order' to use default (relevance if supported, otherwise date)
            // This matches how the web interface works - search results are ordered by relevance
            $input = [
                'search_type' => 'thread', // Search for threads
                'keywords' => $fcParams->searchString,
                'c' => [
                    'title_only' => 0, // Search in both title and content
                ],
            ];

            // Prepare search query using XenForo's search system
            $query = $this->prepareSearchQuery($input, $constraints);
            
            if ($query->getErrors()) {
                return $this->apiError('Search query errors: ' . implode(', ', $query->getErrors()));
            }

            $searcher = $this->app()->search();
            if ($searcher->isQueryEmpty($query, $error)) {
                return $this->apiError($error);
            }

            // Run search using XenForo's search repository (same as web interface)
            $searchRepo = $this->repository('XF:Search');
            $search = $searchRepo->runSearch($query, $constraints, true);

            if (!$search) {
                $result = new FCSearchTopicResult(
                    true,
                    null,
                    0,
                    []
                );
                return $this->apiSuccess($result);
            }

            // Get result set from search
            $resultSet = $searcher->getResultSet($search->search_results);
            
            // Calculate pagination
            $perPage = $fcParams->lastNum - $fcParams->startNum + 1;
            $page = floor($fcParams->startNum / $perPage) + 1;
            if ($page < 1) {
                $page = 1;
            }
            
            // Slice results to requested page
            $resultSet->sliceResultsToPage($page, $perPage);
            
            // Limit to viewable results (respects permissions)
            $resultSet->limitToViewableResults();
            
            // Get wrapped results (same as web interface)
            $resultsWrapped = $searcher->wrapResultsForRender($resultSet, [
                'search' => $search,
                'term' => $search->search_query,
            ]);

            // Convert to API format
            $topicList = [];
            foreach ($resultsWrapped as $wrapper) {
                $entity = $wrapper->getResult();
                
                // Only process thread entities
                if ($entity instanceof \XF\Entity\Thread) {
                    $topicList[] = $this->convertThreadToApiFormat($entity);
                }
            }

            $result = new FCSearchTopicResult(
                true,
                null,
                (int)$search->result_count,
                $topicList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Search failed: ' . $e->getMessage());
        }
    }

    public function actionSearchPost(ParameterBag $params)
    {
        $searchString = $params->get('searchString', '');
        $startNum = $params->get('startNum', 0);
        $lastNum = $params->get('lastNum', 19);
        $searchId = $params->get('searchId', '');

        if (empty($searchString)) {
            return $this->apiError('Search string is required');
        }

        try {
            $visitor = \XF::visitor();
            if (!$visitor->canSearch()) {
                return $this->apiError('Search is not allowed');
            }

            // Build search input for post search
            $input = [
                'search_type' => 'post', // Search for posts
                'keywords' => $searchString,
                'c' => [],
                'order' => 'date',
            ];

            // Prepare search query using XenForo's search system
            $query = $this->prepareSearchQuery($input, $constraints);
            
            if ($query->getErrors()) {
                return $this->apiError('Search query errors: ' . implode(', ', $query->getErrors()));
            }

            $searcher = $this->app()->search();
            if ($searcher->isQueryEmpty($query, $error)) {
                return $this->apiError($error);
            }

            // Run search using XenForo's search repository
            $searchRepo = $this->repository('XF:Search');
            $search = $searchRepo->runSearch($query, $constraints, true);

            if (!$search) {
                $result = new FCSearchPostResult(
                    true,
                    null,
                    0,
                    $searchId ?: null,
                    []
                );
                return $this->apiSuccess($result);
            }

            // Get result set from search
            $resultSet = $searcher->getResultSet($search->search_results);
            
            // Calculate pagination
            $perPage = $lastNum - $startNum + 1;
            $page = floor($startNum / $perPage) + 1;
            if ($page < 1) {
                $page = 1;
            }
            
            // Slice results to requested page
            $resultSet->sliceResultsToPage($page, $perPage);
            
            // Limit to viewable results (respects permissions)
            $resultSet->limitToViewableResults();
            
            // Get wrapped results
            $resultsWrapped = $searcher->wrapResultsForRender($resultSet, [
                'search' => $search,
                'term' => $search->search_query,
            ]);

            // Convert to API format
            $postList = [];
            foreach ($resultsWrapped as $wrapper) {
                $entity = $wrapper->getResult();
                
                // Only process post entities
                if ($entity instanceof \XF\Entity\Post) {
                    $postList[] = $this->convertPostToApiFormat($entity);
                }
            }

            $result = new FCSearchPostResult(
                true,
                null,
                (int)$search->result_count,
                $searchId ?: $search->search_id,
                $postList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Search failed: ' . $e->getMessage());
        }
    }

    public function actionAdvanceSearchTopic(ParameterBag $params)
    {
        $keywords = $params->get('keywords', '');
        $page = $params->get('page', 1);
        $perpage = $params->get('perpage', 20);
        $searchId = $params->get('searchId', '');
        $titleOnly = $params->get('titleOnly', false);
        $userId = $params->get('userId', '');
        $searchUser = $params->get('searchUser', '');
        $forumId = $params->get('forumId', '');
        $topicId = $params->get('topicId', '');
        $onlyIn = $params->get('onlyIn', []);
        $notIn = $params->get('notIn', []);
        $startedBy = $params->get('startedBy', false);
        $searchTime = $params->get('searchTime', 0);

        if (empty($keywords)) {
            return $this->apiError('Search keywords are required');
        }

        try {
            $visitor = \XF::visitor();
            if (!$visitor->canSearch()) {
                return $this->apiError('Search is not allowed');
            }

            // Resolve searchUser to userId if provided
            $resolvedUserId = null;
            if (!empty($userId)) {
                $resolvedUserId = (int)$userId;
            } elseif (!empty($searchUser)) {
                $userRepo = $this->repository('XF:User');
                $user = $userRepo->getUserByNameOrEmail($searchUser);
                if ($user) {
                    $resolvedUserId = $user->user_id;
                } else {
                    return $this->apiError('User not found: ' . $searchUser);
                }
            }

            // Use basic finder approach (like actionSearchTopic) to avoid search system conflicts
            $finder = $this->finder('XF:Thread');
            $finder->where('discussion_state', 'visible');
            
            // Apply search keywords
            $db = $this->app()->db();
            $likePattern = '%' . $db->escapeLike($keywords) . '%';
            $quotedLike = $db->quote($likePattern);
            if ($titleOnly) {
                $finder->whereSql('title LIKE ' . $quotedLike);
            } else {
                // Restrict to threads where title OR any visible post message matches
                $finder->whereSql(
                    '(title LIKE ' . $quotedLike . ' OR thread_id IN (SELECT thread_id FROM xf_post WHERE message LIKE ' . $quotedLike . ' AND message_state = \'visible\'))'
                );
            }
            
            // Apply user filter
            if ($resolvedUserId !== null) {
                if ($startedBy) {
                    // Filter threads started by the user
                    $finder->where('user_id', $resolvedUserId);
                }
                // Note: When startedBy is false, we would ideally filter threads where the user
                // has participated (posted in), but this requires a complex subquery. For now,
                // we filter by thread starter when startedBy is true, and don't apply user filter
                // when startedBy is false. The user participation filtering would need to be
                // done in post-processing, which is inefficient for large result sets.
            }
            
            // Apply forum filters
            $forumIds = [];
            if (!empty($forumId)) {
                $forumIds[] = (int)$forumId;
            }
            if (!empty($onlyIn) && is_array($onlyIn)) {
                foreach ($onlyIn as $forum) {
                    $forumIds[] = (int)$forum;
                }
            }
            if (!empty($forumIds)) {
                $finder->where('node_id', $forumIds);
            }
            
            // Exclude forums
            if (!empty($notIn) && is_array($notIn)) {
                $excludeIds = array_map('intval', $notIn);
                if (!empty($excludeIds)) {
                    // XenForo finder doesn't support NOT IN directly, use whereSql
                    $excludeIdsStr = implode(',', $excludeIds);
                    $finder->whereSql("node_id NOT IN ($excludeIdsStr)");
                }
            }
            
            // Filter by specific topic
            if (!empty($topicId)) {
                $finder->where('thread_id', (int)$topicId);
            }
            
            // Apply date filter
            if ($searchTime > 0) {
                // searchTime is expected to be a Unix timestamp
                // Use post_date for thread creation date, or last_post_date for recent activity
                // Using post_date to match thread creation time
                $finder->where('post_date', '>', (int)$searchTime);
            }
            
            // Order by last post date to show threads with most recent activity first
            $finder->order('last_post_date', 'DESC');
            
            // Apply pagination
            $finder->limit($perpage, ($page - 1) * $perpage);
            
            $threads = $finder->fetch();
            $total = $finder->total();

            $topicList = [];
            foreach ($threads as $thread) {
                // Respect XenForo's permission system
                $error = null;
                if (!$thread->canView($error)) {
                    continue;
                }
                
                // Find the actual post that matches the search criteria
                $matchedPost = null;
                
                // Check if title matches
                $titleMatches = stripos($thread->title, $keywords) !== false;
                
                if ($titleOnly) {
                    // Title-only search: if title matches, use first post
                    if ($titleMatches && $thread->first_post_id) {
                        $matchedPost = $this->em()->find('XF:Post', $thread->first_post_id);
                    }
                } else {
                    // Search in both title and posts
                    if ($titleMatches) {
                        // Title matches, use first post
                        if ($thread->first_post_id) {
                            $matchedPost = $this->em()->find('XF:Post', $thread->first_post_id);
                        }
                    } else {
                        // Title doesn't match, search through posts
                        try {
                            $postFinder = $this->finder('XF:Post');
                            $postFinder->where('thread_id', $thread->thread_id);
                            $postFinder->where('message_state', 'visible');
                            $postFinder->order('post_date', 'ASC');
                            $posts = $postFinder->fetch();
                            
                            foreach ($posts as $post) {
                                if ($post->message && stripos($post->message, $keywords) !== false) {
                                    $matchedPost = $post;
                                    break; // Use first matching post
                                }
                            }
                        } catch (\Exception $e) {
                            // If search fails, skip this thread
                            continue;
                        }
                    }
                    
                    // If no match found, skip this thread
                    if (!$matchedPost) {
                        continue;
                    }
                }

                // Safely get forum/node information
                $forumName = 'Unknown';
                try {
                    if ($thread->Forum && $thread->Forum->Node) {
                        $forumName = $thread->Forum->Node->title;
                    }
                } catch (\Exception $e) {
                    // If add-on conflict occurs, skip this relation
                }

                // Get short content and author info from matched post (or fallback to last post)
                $authorName = 'Unknown';
                $authorId = (string)$thread->user_id;
                $authorUserType = '0';
                $authorIconUrl = '';
                $timestamp = $thread->post_date * 1000;
                $shortContent = '';
                
                try {
                    if ($matchedPost) {
                        // Use the matched post
                        if ($matchedPost->message) {
                            $shortContent = $this->getShortContent($matchedPost->message);
                        }
                        
                        if ($matchedPost->User) {
                            $authorName = $matchedPost->User->username;
                            $authorId = (string)$matchedPost->user_id;
                            $authorUserType = (string)$matchedPost->User->user_group_id;
                            $authorIconUrl = $this->getAbsoluteUrl($matchedPost->User->getAvatarUrl('s'));
                        }
                        $timestamp = $matchedPost->post_date * 1000;
                    } else {
                        // Fallback to last post if no match found
                        if ($thread->last_post_id) {
                            $lastPost = $this->em()->find('XF:Post', $thread->last_post_id);
                            if ($lastPost) {
                                if ($lastPost->message) {
                                    $shortContent = $this->getShortContent($lastPost->message);
                                }
                                
                                if ($lastPost->User) {
                                    $authorName = $lastPost->User->username;
                                    $authorId = (string)$lastPost->user_id;
                                    $authorUserType = (string)$lastPost->User->user_group_id;
                                    $authorIconUrl = $this->getAbsoluteUrl($lastPost->User->getAvatarUrl('s'));
                                } else {
                                    $authorName = $thread->last_post_username ?: 'Unknown';
                                    $authorId = (string)$thread->last_post_user_id;
                                }
                                $timestamp = $lastPost->post_date * 1000;
                            }
                        }
                    }
                } catch (\Exception $e) {
                    // If preview generation fails, use thread creator info
                    try {
                        if ($thread->User) {
                            $authorName = $thread->User->username;
                            $authorId = (string)$thread->user_id;
                            $authorUserType = (string)$thread->User->user_group_id;
                            $authorIconUrl = $this->getAbsoluteUrl($thread->User->getAvatarUrl('s'));
                        }
                    } catch (\Exception $e2) {
                        // If add-on conflict occurs, use defaults
                    }
                }

                $topicList[] = [
                    'id' => (string)$thread->thread_id,
                    'title' => $thread->title,
                    'forumId' => (string)$thread->node_id,
                    'forumName' => $forumName,
                    'authorId' => $authorId,
                    'authorName' => $authorName,
                    'authorUserType' => $authorUserType,
                    'timestamp' => $timestamp,
                    'authorIconUrl' => $authorIconUrl,
                    'shortContent' => $shortContent,
                    'url' => $this->buildLink('canonical:threads', $thread),
                ];
            }

            $result = new FCSearchDataResultTopic(
                true,
                null,
                (int)$total,
                $searchId ?: null,
                $topicList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Advanced search failed: ' . $e->getMessage());
        }
    }

    public function actionAdvanceSearchPost(ParameterBag $params)
    {
        $keywords = $params->get('keywords', '');
        $page = $params->get('page', 1);
        $perpage = $params->get('perpage', 20);
        $searchId = $params->get('searchId', '');
        $titleOnly = $params->get('titleOnly', false);
        $userId = $params->get('userId', '');
        $searchUser = $params->get('searchUser', '');
        $forumId = $params->get('forumId', '');
        $topicId = $params->get('topicId', '');
        $onlyIn = $params->get('onlyIn', []);
        $notIn = $params->get('notIn', []);
        $startedBy = $params->get('startedBy', false);
        $searchTime = $params->get('searchTime', 0);

        if (empty($keywords)) {
            return $this->apiError('Search keywords are required');
        }

        try {
            $visitor = \XF::visitor();
            if (!$visitor->canSearch()) {
                return $this->apiError('Search is not allowed');
            }

            // Build search input for advanced post search
            $input = [
                'search_type' => 'post', // Search for posts
                'keywords' => $keywords,
                'c' => [
                    'title_only' => $titleOnly ? 1 : 0,
                ],
                'order' => 'date',
            ];

            // Apply user filter
            if (!empty($userId)) {
                // If userId is provided, we need to convert it to username
                // because prepareSearchQuery expects usernames, not user IDs
                $user = $this->em()->find('XF:User', (int)$userId);
                if ($user) {
                    $input['c']['users'] = $user->username;
                } else {
                    return $this->apiError('User not found: ' . $userId);
                }
            } elseif (!empty($searchUser)) {
                // If searchUser (username) is provided, use that
                $input['c']['users'] = $searchUser;
            }

            // Apply forum filters - combine forumId and onlyIn
            $forumIds = [];
            if (!empty($forumId)) {
                $forumIds[] = (int)$forumId;
            }
            if (!empty($onlyIn) && is_array($onlyIn)) {
                foreach ($onlyIn as $forum) {
                    $forumIds[] = (int)$forum;
                }
            }
            if (!empty($forumIds)) {
                $input['c']['nodes'] = array_unique($forumIds);
            }

            // Note: notIn (exclude forums) is not directly supported by XenForo's search system
            // This would require post-processing the results, which is inefficient
            // The parameter is accepted but not applied to maintain API compatibility

            if (!empty($topicId)) {
                // Filter by specific thread
                $input['c']['thread'] = (int)$topicId;
            }

            // Note: startedBy parameter applies to thread starters, not post authors
            // For post search, this parameter is not applicable and is ignored

            if ($searchTime > 0) {
                // Filter by date (newer than)
                // searchTime is expected to be a Unix timestamp
                // Convert to datetime format expected by prepareSearchQuery
                $input['c']['newer_than'] = date('Y-m-d H:i:s', (int)$searchTime);
            }

            // Prepare search query using XenForo's search system
            $query = $this->prepareSearchQuery($input, $constraints);
            
            if ($query->getErrors()) {
                return $this->apiError('Search query errors: ' . implode(', ', $query->getErrors()));
            }

            $searcher = $this->app()->search();
            if ($searcher->isQueryEmpty($query, $error)) {
                return $this->apiError($error);
            }

            // Run search using XenForo's search repository
            $searchRepo = $this->repository('XF:Search');
            $search = $searchRepo->runSearch($query, $constraints, true);

            if (!$search) {
                $result = new FCSearchDataResultPost(
                    true,
                    null,
                    0,
                    $searchId ?: null,
                    []
                );
                return $this->apiSuccess($result);
            }

            // Get result set from search
            $resultSet = $searcher->getResultSet($search->search_results);
            
            // Slice results to requested page
            $resultSet->sliceResultsToPage($page, $perpage);
            
            // Limit to viewable results (respects permissions)
            $resultSet->limitToViewableResults();
            
            // Get wrapped results
            $resultsWrapped = $searcher->wrapResultsForRender($resultSet, [
                'search' => $search,
                'term' => $search->search_query,
            ]);

            // Convert to API format
            $postList = [];
            foreach ($resultsWrapped as $wrapper) {
                $entity = $wrapper->getResult();
                
                // Only process post entities
                if ($entity instanceof \XF\Entity\Post) {
                    $postList[] = $this->convertPostToApiFormat($entity);
                }
            }

            $result = new FCSearchDataResultPost(
                true,
                null,
                (int)$search->result_count,
                $searchId ?: $search->search_id,
                $postList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Advanced search failed: ' . $e->getMessage());
        }
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
        if ($thread->FirstPost && isset($thread->FirstPost->reaction_score)) {
            $likeCount = (int)$thread->FirstPost->reaction_score;
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
            'isClosed' => $thread->discussion_state === 'closed',
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
            'isDeleted' => false,
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

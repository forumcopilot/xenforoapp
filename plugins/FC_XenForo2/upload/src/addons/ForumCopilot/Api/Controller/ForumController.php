<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCForumDataResult;
use ForumCopilot\Result\FCLoginForumResult;
use ForumCopilot\Result\FCBoardStatResult;
use ForumCopilot\Result\FCMarkAllAsReadResult;
use ForumCopilot\Result\FCForumStatusResult;
use ForumCopilot\Result\FCParticipatedForumResult;
use ForumCopilot\Entity\FCForum;
use ForumCopilot\Adapter\XenForoParamAdapter;

/**
 * Forum Controller for ForumCopilot API
 * Handles forum structure and forum-related operations
 */
class ForumController extends AbstractController
{
    /** @var \XF\Mvc\Entity\AbstractCollection|null Every thread prefix, loaded once for getForum */
    private $allPrefixes = null;

    /**
     * The forum list (with forumId: the subtree under that forum or
     * category), as XenForo's node list shows it.
     *
     * Since 1.11.0 each forum also says, for the visitor:
     *   - watching: canSubscribe, isSubscribed, notifyOn, sendAlert,
     *     sendEmail, allowedWatchNotifications (see subscribeForum);
     *   - starting a thread: canUpload, prefixes ([{id, title, group}]),
     *     requirePrefix, canTag, minTags, threadFields, threadTypes
     *     ([{type, title}]), defaultThreadType, canCreatePoll, forumType;
     *   - lastPostDateMs and lastPostUserIconUrl next to lastPostDate.
     * Categories and link forums carry canSubscribe, isSubscribed and
     * canUpload as false.
     */
    public function actionGetForum(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetForumParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            $nodeRepo = $this->repository('XF:Node');
            
            // If forumId is provided, the subtree under that forum or category
            $withinNode = null;
            if (!empty($fcParams->forumId)) {
                $withinNode = $this->assertViewableNode($fcParams->forumId);
            }
            
            // Get nodes (all nodes or children of specified node)
            $nodes = $nodeRepo->getNodeList($withinNode);

            // The member's forum watches, in one query
            $watches = [];
            if ($visitor->user_id) {
                $watches = $this->finder('XF:ForumWatch')
                    ->where('user_id', $visitor->user_id)
                    ->keyedBy('node_id')
                    ->fetch();
            }
            
            // Build a map of all nodes by ID
            $nodeMap = [];
            $allForums = [];
            $extras = [];
            
            foreach ($nodes as $node) {
                // Include both Categories and Forums
                if ($node->node_type_id === 'Category' || $node->node_type_id === 'Forum') {
                    $isCategory = ($node->node_type_id === 'Category');
                    $isForum = ($node->node_type_id === 'Forum');
                    
                    // getNodeList only returns nodes the visitor can view;
                    // a forum also needs its data.
                    // Note: Inclusion is based on canView() permission, not canViewContent()
                    // A forum with canView=true but canViewContent=false will still be included
                    // (the canViewContent flag indicates if user can view the topic list)
                    $forum = $isForum ? $node->Data : null;
                    $canView = $isCategory ? $node->canView() : ($forum && $forum->canView());
                    
                    // Include forum if canView is true (regardless of canViewContent)
                    if ($canView) {
                        // Check viewOthers permission for private info (categories have none to hide)
                        $hasViewOthers = $visitor->hasNodePermission($node->node_id, 'viewOthers');
                        $privateInfo = $isForum && !$hasViewOthers;
                        
                        // Get last post information for forums
                        $lastPostId = 0;
                        $lastPostDate = 0;
                        $lastPostUserId = 0;
                        $lastPostUsername = '';
                        $lastThreadId = 0;
                        $lastThreadTitle = '';
                        $lastThreadPrefixId = 0;
                        $lastPostUser = null;
                        
                        if ($isForum && $forum && $hasViewOthers) {
                            $nodeExtras = $forum->getNodeListExtras();
                            if (!empty($nodeExtras['last_post_date'])) {
                                $lastPostId = $nodeExtras['last_post_id'] ?? 0;
                                $lastPostDate = $nodeExtras['last_post_date'] ?? 0;
                                $lastPostUserId = $nodeExtras['last_post_user_id'] ?? 0;
                                $lastPostUsername = $nodeExtras['last_post_username'] ?? '';
                                $lastThreadId = $nodeExtras['last_thread_id'] ?? 0;
                                $lastThreadTitle = $nodeExtras['last_thread_title'] ?? '';
                                $lastThreadPrefixId = $nodeExtras['last_thread_prefix_id'] ?? 0;
                                $lastPostUser = $nodeExtras['LastPostUser'] ?? null;
                            }
                        }
                        
                        $fcForum = new FCForum([
                            'id' => (string)$node->node_id,
                            'name' => $node->title,
                            'description' => $fcParams->returnDescription ? $node->description : '',
                            'parentId' => $node->parent_node_id ? (string)$node->parent_node_id : '',
                            'displayOrder' => $node->display_order,
                            'threadCount' => ($isForum && $forum && $hasViewOthers) ? $forum->discussion_count : 0,
                            'postCount' => ($isForum && $forum && $hasViewOthers) ? $forum->message_count : 0,
                            'canPost' => $isForum && $forum ? $forum->canCreateThread() : false,
                            // Replying in the forum's threads ("Post replies")
                            'canReply' => $isForum && $forum ? $visitor->hasNodePermission($node->node_id, 'postReply') : false,
                            'canViewContent' => $isForum && $forum ? $visitor->hasNodePermission($node->node_id, 'viewContent') : false,
                            'isRead' => $isForum && $forum && $visitor->user_id ? !$forum->isUnread() : true,
                            'url' => $isForum && $forum ? $this->buildLink('canonical:forums', $forum) : '',
                            'subForums' => [], // Will be populated below
                            'privateInfo' => $privateInfo,
                            'lastPostId' => $lastPostId,
                            'lastPostDate' => $lastPostDate,
                            'lastPostUserId' => $lastPostUserId,
                            'lastPostUsername' => $lastPostUsername,
                            'lastThreadId' => $lastThreadId,
                            'lastThreadTitle' => $lastThreadTitle,
                            'lastThreadPrefixId' => $lastThreadPrefixId,
                        ]);
                        
                        $nodeMap[(string)$node->node_id] = $fcForum;
                        $allForums[] = $fcForum;

                        if ($isForum && $forum) {
                            $watch = $watches[$node->node_id] ?? null;
                            $extras[(string)$node->node_id] = $this->getForumRowDetails($forum, $watch, $lastPostDate, $lastPostUser);
                        } else {
                            $extras[(string)$node->node_id] = ['canUpload' => false, 'canSubscribe' => false, 'isSubscribed' => false];
                        }
                    }
                } elseif ($node->node_type_id === 'LinkForum') {
                    $linkForum = $node->Data;
                    if (!$linkForum || !$linkForum->canView()) {
                        continue;
                    }
                    $fcForum = new FCForum([
                        'id' => (string)$node->node_id,
                        'name' => $node->title,
                        'description' => '',
                        'parentId' => $node->parent_node_id ? (string)$node->parent_node_id : '',
                        'displayOrder' => $node->display_order,
                        'threadCount' => 0,
                        'postCount' => 0,
                        'canPost' => false,
                        'canReply' => false,
                        'canViewContent' => false,
                        'isRead' => true,
                        'url' => $linkForum->link_url,
                        'subForums' => [],
                        'privateInfo' => false,
                        'lastPostId' => 0,
                        'lastPostDate' => 0,
                        'lastPostUserId' => 0,
                        'lastPostUsername' => '',
                        'lastThreadId' => 0,
                        'lastThreadTitle' => '',
                        'lastThreadPrefixId' => 0,
                        'isLinkForum' => true,
                    ]);
                    $nodeMap[(string)$node->node_id] = $fcForum;
                    $allForums[] = $fcForum;
                    $extras[(string)$node->node_id] = ['canUpload' => false, 'canSubscribe' => false, 'isSubscribed' => false];
                }
            }
            
            // Build nested structure by populating subForums. With forumId,
            // the requested node's children are the roots (getNodeList
            // returns its descendants only).
            $rootParentId = $withinNode ? (string)$withinNode->node_id : '';
            $rootForums = [];
            foreach ($allForums as $fcForum) {
                if ((string)$fcForum->parentId === $rootParentId) {
                    // Root level forum/category
                    $rootForums[] = $fcForum;
                } else {
                    // Child forum/category - add to parent's subForums
                    if (isset($nodeMap[$fcForum->parentId])) {
                        $parent = $nodeMap[$fcForum->parentId];
                        if (!is_array($parent->subForums)) {
                            $parent->subForums = [];
                        }
                        $parent->subForums[] = $fcForum;
                    }
                }
            }
            
            // Sort root forums by display order
            usort($rootForums, function($a, $b) {
                return $a->displayOrder <=> $b->displayOrder;
            });
            
            // Recursively sort subForums
            $this->sortForumsRecursive($rootForums);
            
            // Convert FCForum entities to arrays, with the 1.11.0 fields
            $forumListArray = array_map(function($fcForum) {
                return is_object($fcForum) ? $fcForum->toArray() : $fcForum;
            }, $rootForums);
            $this->addForumRowDetails($forumListArray, $extras);

            $result = new FCForumDataResult(
                true,
                null, // resultText must be null when result = true
                $forumListArray
            );

            return $this->apiSuccess($result);

        } catch (\Throwable $e) {
            return $this->apiException($e, 'Failed to get forums');
        }
    }

    /**
     * A forum or category the visitor can see, by id or node name (getForum's
     * forumId).
     */
    protected function assertViewableNode($nodeIdOrName): \XF\Entity\Node
    {
        $node = is_numeric($nodeIdOrName)
            ? $this->em()->find('XF:Node', (int)$nodeIdOrName)
            : $this->em()->findOne('XF:Node', ['node_name' => (string)$nodeIdOrName]);

        if (!$node || !in_array($node->node_type_id, ['Forum', 'Category'], true)) {
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase('requested_forum_not_found'), 404));
        }

        $error = null;
        if (!$node->canView($error)) {
            throw new \XF\Mvc\Reply\Exception($this->error($error ?: \XF::phrase('do_not_have_permission'), 403));
        }

        return $node;
    }

    /**
     * getForum's 1.11.0 fields for one forum: the visitor's watch, what
     * starting a thread there takes (XenForo's "Post thread" form: prefix,
     * tags, custom fields, thread types, poll), and the last poster's
     * avatar.
     *
     * @param \XF\Entity\ForumWatch|null $watch
     * @param \XF\Entity\User|null $lastPostUser
     */
    protected function getForumRowDetails(\XF\Entity\Forum $forum, $watch, int $lastPostDate, $lastPostUser): array
    {
        $watchStatus = $this->getForumWatchStatus($forum, null, $watch);
        $prefixes = $this->getForumPrefixes($forum);

        $threadTypes = [];
        foreach ($forum->getCreatableThreadTypes() as $type) {
            $handler = $this->app->threadType($type, false);
            if ($handler) {
                $threadTypes[] = ['type' => $type, 'title' => $this->plainText($handler->getTypeTitle())];
            }
        }

        return [
            'canUpload' => $forum->canUploadAndManageAttachments(),
            'canSubscribe' => $watchStatus['canWatch'],
            'isSubscribed' => $watchStatus['isWatched'],
            'notifyOn' => $watchStatus['notifyOn'],
            'sendAlert' => $watchStatus['sendAlert'],
            'sendEmail' => $watchStatus['sendEmail'],
            'allowedWatchNotifications' => $watchStatus['allowedWatchNotifications'],

            'forumType' => $forum->isValidColumn('forum_type_id') ? (string)$forum->forum_type_id : 'discussion',
            'prefixes' => $prefixes,
            // As the thread creator checks it: only when a prefix can be picked
            'requirePrefix' => $forum->require_prefix && count($prefixes) > 0,
            'canTag' => (bool)$forum->canEditTags(),
            'minTags' => $forum->isValidColumn('min_tags') ? (int)$forum->min_tags : 0,
            'threadFields' => $this->getForumThreadFields($forum),
            'threadTypes' => $threadTypes,
            'defaultThreadType' => (string)$forum->TypeHandler->getDefaultThreadType($forum),
            'canCreatePoll' => (bool)$forum->canCreatePoll(),

            'lastPostDateMs' => $lastPostDate * 1000,
            'lastPostUserIconUrl' => $lastPostUser ? $this->getAbsoluteUrl($lastPostUser->getAvatarUrl('s')) : '',
        ];
    }

    /**
     * The prefixes the visitor may use in the forum, as
     * Forum::getUsablePrefixes gives them ([{id, title, group}]), from one
     * load of every prefix for the whole forum list.
     */
    protected function getForumPrefixes(\XF\Entity\Forum $forum): array
    {
        if (!$forum->prefix_cache) {
            return [];
        }

        if ($this->allPrefixes === null) {
            $this->allPrefixes = $this->finder('XF:ThreadPrefix')->order('materialized_order')->fetch();
        }

        $prefixes = [];
        foreach ($this->allPrefixes as $prefixId => $prefix) {
            if (!isset($forum->prefix_cache[$prefixId]) || !$prefix->isUsableByUser()) {
                continue;
            }
            $prefixes[] = [
                'id' => (string)$prefixId,
                'title' => (string)$prefix->title,
                'group' => $prefix->prefix_group_id
                    ? (string)\XF::phrase('thread_prefix_group.' . $prefix->prefix_group_id)
                    : '',
            ];
        }

        return $prefixes;
    }

    /**
     * The custom thread fields a member fills in when starting a thread in
     * the forum, as the "Post thread" form shows them (the forum's fields
     * the member may edit). Values go to newTopic as customFields
     * {id: value}; a multiple-choice field takes a list of choice values.
     *
     * @return array [{id, title, description, type, required, choices:
     *               [{value, title}], group, maxLength, matchType}]
     */
    protected function getForumThreadFields(\XF\Entity\Forum $forum): array
    {
        if (!$forum->field_cache) {
            return [];
        }

        /** @var \XF\CustomField\DefinitionSet $definitions */
        $definitions = $this->app->container('customFields.threads');
        $fields = [];
        foreach ($definitions->filterOnly($forum->field_cache)->getFieldDefinitions() as $fieldId => $definition) {
            if (!$definition->isEditable(null, 'user')) {
                continue;
            }

            $choices = [];
            foreach ((array)$definition->field_choices as $value => $title) {
                $choices[] = ['value' => (string)$value, 'title' => $this->plainText($title)];
            }

            $fields[] = [
                'id' => (string)$fieldId,
                'title' => $this->plainText($definition->title),
                'description' => $this->plainText($definition->description),
                'type' => (string)$definition->field_type,
                'required' => (bool)$definition->isRequired('user'),
                'choices' => $choices,
                // before / after the message, or thread_status
                'group' => (string)$definition->display_group,
                'maxLength' => (int)$definition->max_length,
                'matchType' => (string)$definition->match_type,
            ];
        }

        return $fields;
    }

    /**
     * Adds getForumRowDetails' fields to each row of the forum tree.
     */
    protected function addForumRowDetails(array &$rows, array $details)
    {
        foreach ($rows as &$row) {
            if (isset($details[$row['id']])) {
                $row = array_merge($row, $details[$row['id']]);
            }
            if (!empty($row['subForums'])) {
                $this->addForumRowDetails($row['subForums'], $details);
            }
        }
        unset($row);
    }

    public function actionMarkAllAsRead(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toMarkAllAsReadParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            
            // Validate and set date parameter (matches XenForo web/API behavior)
            $markDate = $fcParams->date;
            if ($markDate !== null) {
                // Validate date is not in the future (matches XenForo API behavior)
                if ($markDate > \XF::$time) {
                    $markDate = null; // Use current time if date is in future
                }
            }
            // If date is null, it will default to current time in markForumTreeReadByVisitor
            
            if (!empty($fcParams->forumId)) {
                // Mark specific forum as read (including all sub-forums)
                // This matches the web interface behavior which marks the forum tree
                $forum = $this->assertViewableForum($fcParams->forumId);
                
                // Use markForumTreeReadByVisitor to mark forum and all sub-forums
                // This matches the web interface behavior (see ForumController::actionMarkRead)
                $this->repository('XF:Forum')->markForumTreeReadByVisitor($forum, $markDate);
            } else {
                // Mark all forums as read - use repository method with null base node
                // This marks all forums in the entire forum tree
                $this->repository('XF:Forum')->markForumTreeReadByVisitor(null, $markDate);
            }

            $result = new FCMarkAllAsReadResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Throwable $e) {
            return $this->apiException($e, 'Failed to mark forum as read');
        }
    }

    /**
     * loginForum: XenForo has no password-protected forums, so there is
     * nothing to unlock. The dispatcher routes the method here; without this
     * action the call was a 500 ("Call to undefined method"). Answer with a
     * plain success so clients following the generic flow can continue.
     */
    public function actionLoginForum(ParameterBag $params)
    {
        return $this->apiSuccess((new FCLoginForumResult(true, 'success'))->toArray());
    }

    public function actionGetForumStatus(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetForumStatusParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            
            // Use findByIds() for efficient bulk loading with Node relation
            $forums = $this->em()->findByIds('XF:Forum', $fcParams->forumIds, ['Node']);
            
            $statusList = [];

            foreach ($forums as $forum) {
                if ($forum && $forum->canView()) {
                    // Check viewOthers permission for private info
                    $hasViewOthers = $visitor->hasNodePermission($forum->node_id, 'viewOthers');
                    $privateInfo = !$hasViewOthers;
                    
                    // Get last post information for forums
                    $lastPostId = 0;
                    $lastPostDate = 0;
                    $lastPostUserId = 0;
                    $lastPostUsername = '';
                    $lastThreadId = 0;
                    $lastThreadTitle = '';
                    $lastThreadPrefixId = 0;
                    
                    if ($hasViewOthers) {
                        $extras = $forum->getNodeListExtras();
                        if (!empty($extras['last_post_date'])) {
                            $lastPostId = $extras['last_post_id'] ?? 0;
                            $lastPostDate = $extras['last_post_date'] ?? 0;
                            $lastPostUserId = $extras['last_post_user_id'] ?? 0;
                            $lastPostUsername = $extras['last_post_username'] ?? '';
                            $lastThreadId = $extras['last_thread_id'] ?? 0;
                            $lastThreadTitle = $extras['last_thread_title'] ?? '';
                            $lastThreadPrefixId = $extras['last_thread_prefix_id'] ?? 0;
                        }
                    }
                    
                    $fcForum = new FCForum([
                        'id' => (string)$forum->node_id,
                        'name' => $forum->Node->title,
                        'description' => $forum->Node->description,
                        'parentId' => $forum->Node->parent_node_id ? (string)$forum->Node->parent_node_id : '',
                        'displayOrder' => $forum->Node->display_order,
                        'threadCount' => $hasViewOthers ? $forum->discussion_count : 0,
                        'postCount' => $hasViewOthers ? $forum->message_count : 0,
                        'canPost' => $forum->canCreateThread(),
                        'canReply' => $forum->canCreateThread(),
                        'canViewContent' => $forum->canViewThreadContent(),
                        'isRead' => !$forum->isUnread(),
                        'url' => $this->buildLink('canonical:forums', $forum),
                        'privateInfo' => $privateInfo,
                        'lastPostId' => $lastPostId,
                        'lastPostDate' => $lastPostDate,
                        'lastPostUserId' => $lastPostUserId,
                        'lastPostUsername' => $lastPostUsername,
                        'lastThreadId' => $lastThreadId,
                        'lastThreadTitle' => $lastThreadTitle,
                        'lastThreadPrefixId' => $lastThreadPrefixId,
                    ]);
                    $statusList[] = $fcForum;
                }
            }

            $result = new FCForumStatusResult(
                true,
                null,
                $statusList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get forum status');
        }
    }

    public function actionGetBoardStat(ParameterBag $params)
    {
        try {
            // Get cached forum statistics (matches XenForo web/API behavior)
            $forumStats = $this->app()->forumStatistics;
            
            // Get thread, post, and member counts from cache
            $totalThreads = $forumStats['threads'] ?? 0;
            $totalPosts = $forumStats['messages'] ?? 0;
            $totalMembers = $forumStats['users'] ?? 0;
            
            // Get latest user information from cache
            $latestUser = $forumStats['latestUser'] ?? null;
            $latestUserId = $latestUser['user_id'] ?? 0;
            $latestUsername = $latestUser['username'] ?? '';
            $latestUserRegisterDate = $latestUser['register_date'] ?? 0;

            // Get active members (users active in last 30 days)
            $db = $this->app->db();
            $activeMembers = $db->fetchOne(
                'SELECT COUNT(*) FROM xf_user WHERE user_state = ? AND last_activity > ?',
                ['valid', \XF::$time - (30 * 24 * 60 * 60)]
            );

            // Get online users using repository method (respects onlineStatusTimeout option)
            $activityRepo = $this->repository('XF:SessionActivity');
            $onlineCounts = $activityRepo->getOnlineCounts();
            $totalOnline = $onlineCounts['total'] ?? 0;
            $guestOnline = $onlineCounts['guests'] ?? 0;

            $result = new FCBoardStatResult(
                true,
                null,
                (int)$totalThreads,
                (int)$totalPosts,
                (int)$totalMembers,
                (int)$activeMembers,
                (int)$totalOnline,
                (int)$guestOnline,
                (int)$latestUserId,
                $latestUsername,
                (int)$latestUserRegisterDate
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get board stats');
        }
    }

    public function actionGetParticipatedForum(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        try {
            $visitor = \XF::visitor();
            
            // Get forums where user has participated (posted)
            // Use threads where user has posted to find forums efficiently
            $threadRepo = $this->repository('XF:Thread');
            $finder = $threadRepo->findThreadsWithPostsByUser($visitor->user_id);
            $finder->where('discussion_state', 'visible');
            
            $threads = $finder->fetch();
            
            // Get unique forum IDs from threads
            $forumIds = [];
            foreach ($threads as $thread) {
                if ($thread->Forum && $thread->Forum->canView()) {
                    $forumIds[$thread->node_id] = true;
                }
            }
            $forumIds = array_keys($forumIds);
            
            if (empty($forumIds)) {
                // Return empty result
                $result = new FCParticipatedForumResult(
                    true,
                    null,
                    []
                );
                return $this->apiSuccess($result);
            }
            
            // Fetch forums by IDs with Node relation loaded
            $forums = $this->em()->findByIds('XF:Forum', $forumIds, ['Node']);
            
            $participatedForums = [];
            foreach ($forums as $forum) {
                if ($forum && $forum->canView()) {
                    // Check viewOthers permission for private info
                    $hasViewOthers = $visitor->hasNodePermission($forum->node_id, 'viewOthers');
                    $privateInfo = !$hasViewOthers;
                    
                    // Get last post information for forums
                    $lastPostId = 0;
                    $lastPostDate = 0;
                    $lastPostUserId = 0;
                    $lastPostUsername = '';
                    $lastThreadId = 0;
                    $lastThreadTitle = '';
                    $lastThreadPrefixId = 0;
                    
                    if ($hasViewOthers) {
                        $extras = $forum->getNodeListExtras();
                        if (!empty($extras['last_post_date'])) {
                            $lastPostId = $extras['last_post_id'] ?? 0;
                            $lastPostDate = $extras['last_post_date'] ?? 0;
                            $lastPostUserId = $extras['last_post_user_id'] ?? 0;
                            $lastPostUsername = $extras['last_post_username'] ?? '';
                            $lastThreadId = $extras['last_thread_id'] ?? 0;
                            $lastThreadTitle = $extras['last_thread_title'] ?? '';
                            $lastThreadPrefixId = $extras['last_thread_prefix_id'] ?? 0;
                        }
                    }
                    
                    $fcForum = new FCForum([
                        'id' => (string)$forum->node_id,
                        'name' => $forum->Node->title,
                        'description' => $forum->Node->description,
                        'parentId' => $forum->Node->parent_node_id ? (string)$forum->Node->parent_node_id : '',
                        'displayOrder' => $forum->Node->display_order,
                        'threadCount' => $hasViewOthers ? $forum->discussion_count : 0,
                        'postCount' => $hasViewOthers ? $forum->message_count : 0,
                        'canPost' => $forum->canCreateThread(),
                        'canReply' => $forum->canCreateThread(),
                        'canViewContent' => $forum->canViewThreadContent(),
                        'isRead' => !$forum->isUnread(),
                        'url' => $this->buildLink('canonical:forums', $forum),
                        'privateInfo' => $privateInfo,
                        'lastPostId' => $lastPostId,
                        'lastPostDate' => $lastPostDate,
                        'lastPostUserId' => $lastPostUserId,
                        'lastPostUsername' => $lastPostUsername,
                        'lastThreadId' => $lastThreadId,
                        'lastThreadTitle' => $lastThreadTitle,
                        'lastThreadPrefixId' => $lastThreadPrefixId,
                    ]);
                    $participatedForums[] = $fcForum;
                }
            }

            $result = new FCParticipatedForumResult(
                true,
                null,
                $participatedForums
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get participated forums');
        }
    }

    
    /**
     * Recursively sort forums by display order
     * @param array $forums Array of FCForum objects
     */
    private function sortForumsRecursive(&$forums)
    {
        usort($forums, function($a, $b) {
            return $a->displayOrder <=> $b->displayOrder;
        });
        
        foreach ($forums as $forum) {
            if (!empty($forum->subForums) && is_array($forum->subForums)) {
                $this->sortForumsRecursive($forum->subForums);
            }
        }
    }
}

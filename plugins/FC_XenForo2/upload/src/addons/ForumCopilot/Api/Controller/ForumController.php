<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCForumDataResult;
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
    public function actionGetForum(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetForumParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $visitor = \XF::visitor();
            $nodeRepo = $this->repository('XF:Node');
            
            // If forumId is provided, get that specific forum and its children
            $withinNode = null;
            if (!empty($fcParams->forumId)) {
                $forum = $this->assertViewableForum($fcParams->forumId);
                $withinNode = $forum->Node;
            }
            
            // Get nodes (all nodes or children of specified forum)
            $nodes = $nodeRepo->getNodeList($withinNode);
            
            // Build a map of all nodes by ID
            $nodeMap = [];
            $allForums = [];
            
            foreach ($nodes as $node) {
                // Include both Categories and Forums
                if ($node->node_type_id === 'Category' || $node->node_type_id === 'Forum') {
                    $isCategory = ($node->node_type_id === 'Category');
                    $isForum = ($node->node_type_id === 'Forum');
                    
                    // For Categories, check if node is viewable
                    // For Forums, check if forum data is viewable
                    // Note: Inclusion is based on canView() permission, not canViewContent()
                    // A forum with canView=true but canViewContent=false will still be included
                    // (the canViewContent flag indicates if user can view the topic list)
                    $canView = false;
                    $forum = null;
                    
                    if ($isCategory) {
                        // Categories don't have Data, just check node permissions
                        try {
                            $canView = $node->canView();
                        } catch (\Exception $e) {
                            $canView = true; // Default to viewable if check fails
                        }
                    } else if ($isForum) {
                        $forum = $node->Data;
                        if ($forum) {
                            try {
                                $canView = $forum->canView();
                            } catch (\Exception $e) {
                                $canView = false;
                            }
                        }
                    }
                    
                    // Include forum if canView is true (regardless of canViewContent)
                    if ($canView) {
                        // Check viewOthers permission for private info
                        $hasViewOthers = $visitor->hasNodePermission($node->node_id, 'viewOthers');
                        $privateInfo = !$hasViewOthers;
                        
                        // Get last post information for forums
                        $lastPostId = 0;
                        $lastPostDate = 0;
                        $lastPostUserId = 0;
                        $lastPostUsername = '';
                        $lastThreadId = 0;
                        $lastThreadTitle = '';
                        $lastThreadPrefixId = 0;
                        
                        if ($isForum && $forum && $hasViewOthers) {
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
                            'id' => (string)$node->node_id,
                            'name' => $node->title,
                            'description' => $fcParams->returnDescription ? $node->description : '',
                            'parentId' => $node->parent_node_id ? (string)$node->parent_node_id : '',
                            'displayOrder' => $node->display_order,
                            'threadCount' => ($isForum && $forum && $hasViewOthers) ? $forum->discussion_count : 0,
                            'postCount' => ($isForum && $forum && $hasViewOthers) ? $forum->message_count : 0,
                            'canPost' => $isForum && $forum ? $forum->canCreateThread() : false,
                            'canReply' => $isForum && $forum ? $forum->canCreateThread() : false,
                            'canViewContent' => $isForum && $forum ? $forum->canViewThreadContent() : false,
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
                    }
                } elseif ($node->node_type_id === 'LinkForum') {
                    $linkForum = $node->Data;
                    if (!$linkForum) {
                        continue;
                    }
                    $canView = false;
                    try {
                        $canView = $linkForum->canView();
                    } catch (\Exception $e) {
                        $canView = false;
                    }
                    if ($canView) {
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
                    }
                }
            }
            
            // Build nested structure by populating subForums
            $rootForums = [];
            foreach ($allForums as $fcForum) {
                if (empty($fcForum->parentId)) {
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
            
            // Convert FCForum entities to arrays
            $forumListArray = array_map(function($fcForum) {
                return is_object($fcForum) ? $fcForum->toArray() : $fcForum;
            }, $rootForums);

            $result = new FCForumDataResult(
                true,
                null, // resultText must be null when result = true
                $forumListArray
            );

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Forum not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to get forums: ' . $e->getMessage());
        }
    }

    public function actionMarkAllAsRead(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toMarkAllAsReadParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
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

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Handle XenForo reply exceptions
            $reply = $e->getReply();
            if ($reply instanceof \XF\Mvc\Reply\Error) {
                $errors = $reply->getErrors();
                if (!empty($errors)) {
                    // Get first error message
                    $errorMsg = is_array($errors) ? (string)($errors[0] ?? 'Forum not found or cannot be viewed') : (string)$errors;
                    return $this->apiError($errorMsg);
                }
                return $this->apiError('Forum not found or cannot be viewed');
            }
            $errorMsg = $e->getMessage();
            return $this->apiError('Failed to mark forum as read: ' . ($errorMsg ?: 'Unknown error'));
        } catch (\Throwable $e) {
            return $this->apiError('Failed to mark forum as read: ' . $e->getMessage());
        }
    }

    public function actionGetForumStatus(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetForumStatusParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
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
            return $this->apiError('Failed to get forum status: ' . $e->getMessage());
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
            return $this->apiError('Failed to get board stats: ' . $e->getMessage());
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
            return $this->apiError('Failed to get participated forums: ' . $e->getMessage());
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

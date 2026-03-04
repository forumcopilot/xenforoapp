<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCThreadResult;
use ForumCopilot\Result\FCThreadByUnreadResult;
use ForumCopilot\Result\FCThreadByPostResult;
use ForumCopilot\Result\FCReplyPostResult;
use ForumCopilot\Result\FCRawPostResult;
use ForumCopilot\Result\FCSaveRawPostResult;
use ForumCopilot\Result\FCQuotePostResult;
use ForumCopilot\Result\FCReportPostResult;
use ForumCopilot\Entity\FCPost;
use ForumCopilot\Entity\FCAttachment;
use ForumCopilot\Adapter\XenForoParamAdapter;

// Explicitly require FCPostResult.php which contains multiple Result classes
// This ensures all classes in that file are loaded
require_once(__DIR__ . '/../../Result/FCPostResult.php');

/**
 * Post Controller for ForumCopilot API
 * Handles post operations and thread management
 */
class PostController extends AbstractController
{
    public function actionGetThread(ParameterBag $params)
    {
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toGetThreadParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            // Try to get thread safely - handle exceptions from assertViewableThread
            $thread = null;
            try {
                $thread = $this->assertViewableThread($fcParams->topicId);
            } catch (\XF\Mvc\Reply\Exception $e) {
                // Extract XenForo's error message from the exception
                $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
                return $this->apiError($errorMsg);
            } catch (\Exception $e) {
                return $this->apiError('Failed to get thread: ' . $e->getMessage());
            }
            
            if (!$thread) {
                return $this->apiError('Thread not found');
            }
            
            $visitor = \XF::visitor();

            // Get posts in thread - use basic finder to avoid add-on conflicts
            $finder = $this->finder('XF:Post');
            $finder->where('thread_id', $thread->thread_id);
            $finder->where('message_state', 'visible');
            $finder->order('post_date', 'ASC');
            
            // Load Thread relationship with Forum for proper permission checks (needed for canEdit/canDelete)
            $finder->with(['Thread', 'Thread.Forum', 'Thread.Forum.Node']);
            
            // Apply pagination
            $perPage = $fcParams->lastNum - $fcParams->startNum + 1;
            // Offset should be startNum - 1 (since position 1 = offset 0)
            $offset = $fcParams->startNum - 1;
            $finder->limit($perPage, $offset);
            
            // Load visitor's reaction if logged in (needed for isReactedTo check)
            $visitor = \XF::visitor();
            if ($visitor->user_id) {
                $finder->with(['Reactions|' . $visitor->user_id]);
            }
            
            // Fetch posts
            $posts = $finder->fetch();
            $total = $finder->total();

            $postList = [];
            foreach ($posts as $post) {
                // Respect XenForo's permission system
                $error = null;
                if (!$post->canView($error)) {
                    continue;
                }

                // Safely get user information
                $authorName = 'Unknown';
                $authorUserType = '0';
                $authorIconUrl = '';
                try {
                    if ($post->User) {
                        $authorName = $post->User->username;
                        $authorUserType = (string)$post->User->user_group_id;
                        $authorIconUrl = $this->getAbsoluteUrl($post->User->getAvatarUrl('s'));
                    }
                } catch (\Exception $e) {
                    // If add-on conflict occurs, use defaults
                }

                // Get post content safely - always return BBCode
                $postContent = '';
                try {
                    // Ensure message is a string before processing
                    $message = is_array($post->message) ? '' : (string)$post->message;
                    $postContent = $message; // Always return BBCode
                    
                    // Process image proxy URLs in BBCode
                    $postContent = $this->processImageProxyInBbCode($postContent);
                } catch (\Exception $e) {
                    // Fallback: ensure we have a string
                    $postContent = is_array($post->message) ? '' : (string)$post->message;
                }

                // For post-level permissions, use defaults to avoid conflicts
                $canReport = false;
                
                // Get canLike and isLiked flags
                $likeFlags = $this->getPostLikeFlags($post);
                $canLike = $likeFlags['canLike'];
                $isLiked = $likeFlags['isLiked'];

                // Get likes info (list of users who liked this post)
                $likesInfo = $this->getPostLikesInfo($post);

                // Calculate post position (floor number) in the thread
                $position = $this->getPostPosition($post);

                // Load and convert attachments
                $attachments = $this->getPostAttachments($post);

                $fcPost = new FCPost([
                    'id' => (string)$post->post_id,
                    'topicId' => (string)$post->thread_id,
                    'authorId' => (string)$post->user_id,
                    'authorName' => $authorName,
                    'authorUserType' => $authorUserType,
                    'timestamp' => $post->post_date * 1000,
                    'content' => $postContent,
                    'title' => $post->post_id === $thread->first_post_id ? $thread->title : '',
                    'authorIconUrl' => $authorIconUrl,
                    'canEdit' => $post->canEdit(),
                    'canDelete' => $post->canDelete(),
                    'canReport' => $canReport,
                    'canLike' => $canLike,
                    'isLiked' => $isLiked,
                    'likeCount' => isset($post->reaction_score) ? (int)$post->reaction_score : 0,
                    'likesInfo' => $likesInfo,
                    'isApproved' => $post->message_state === 'visible',
                    'isFirstPost' => $post->post_id === $thread->first_post_id,
                    'position' => $position,
                    'attachments' => $attachments,
                ]);
                
                $postList[] = $fcPost;
            }

            // Safely access forum/node information
            $forumName = 'Unknown';
            try {
                if ($thread->Forum && $thread->Forum->Node) {
                    $forumName = $thread->Forum->Node->title;
                }
            } catch (\Exception $e) {
                // If add-on conflict occurs, skip this relation
            }

            // Safely get thread author information
            $threadAuthorName = 'Unknown';
            $threadAuthorUserType = '0';
            $threadAuthorIconUrl = '';
            try {
                if ($thread->User) {
                    $threadAuthorName = $thread->User->username;
                    $threadAuthorUserType = (string)$thread->User->user_group_id;
                    $threadAuthorIconUrl = $this->getAbsoluteUrl($thread->User->getAvatarUrl('m'));
                }
            } catch (\Exception $e) {
                // If add-on conflict occurs, use defaults
            }

            // Get short content safely - create manual preview from message
            $shortContent = '';
            try {
                if ($thread->first_post_id) {
                    $firstPost = $this->em()->find('XF:Post', $thread->first_post_id);
                    if ($firstPost && $firstPost->message) {
                        $shortContent = $this->getShortContent($firstPost->message);
                    }
                }
            } catch (\Exception $e) {
                // If preview generation fails, use empty string
            }

            // Get like count from first post
            $likeCount = 0;
            if ($thread->first_post_id) {
                $firstPost = $this->em()->find('XF:Post', $thread->first_post_id);
                if ($firstPost && isset($firstPost->reaction_score)) {
                    $likeCount = (int)$firstPost->reaction_score;
                }
            }

            // For thread-level permissions, use defaults to avoid conflicts
            $canReport = false;
            $canLike = false;
            $isLiked = false;
            $canUpload = false;

            // Get prefix label
            $prefixLabel = $this->getThreadPrefixLabel($thread);
            $threadWithPoll = $this->em()->find('XF:Thread', $thread->thread_id, ['Poll']);
            $pollData = $this->buildPollDataForThread($threadWithPoll ?: $thread);

            $topicData = [
                'id' => (string)$thread->thread_id,
                'title' => $thread->title,
                'forumId' => (string)$thread->node_id,
                'forumName' => $forumName,
                'authorId' => (string)$thread->user_id,
                'authorName' => $threadAuthorName,
                'authorUserType' => $threadAuthorUserType,
                'timestamp' => $thread->post_date * 1000,
                'prefix' => $prefixLabel,
                'authorIconUrl' => $threadAuthorIconUrl,
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
                'canReport' => $canReport,
                'canUpload' => $canUpload,
                'isBanned' => false,
                'isApproved' => $thread->discussion_state === 'visible',
                'isDeleted' => $thread->discussion_state === 'deleted',
                'isMoved' => false,
                'isMerged' => false,
                'realTopicId' => (string)$thread->thread_id,
                'canLike' => $canLike,
                'isLiked' => $isLiked,
                'likeCount' => $likeCount,
                'hasPoll' => ($pollData !== null),
                'poll' => $pollData,
            ];

            // Mark thread as read up to the last post shown (same as web interface)
            // Only mark if user is logged in and we have posts in simple date order
            if ($visitor->user_id && !empty($posts) && !$this->request->isPrefetch()) {
                // Find the last post by post_date (posts are ordered by post_date ASC)
                $lastPost = null;
                $lastPostDate = 0;
                foreach ($posts as $post) {
                    if ($post->post_date > $lastPostDate) {
                        $lastPostDate = $post->post_date;
                        $lastPost = $post;
                    }
                }
                
                if ($lastPost) {
                    try {
                        $this->repository('XF:Thread')->markThreadReadByVisitor($thread, $lastPost->post_date);
                    } catch (\Exception $e) {
                        // Silently fail if marking as read fails (e.g., add-on conflicts)
                    }
                }
            }

            $result = new FCThreadResult(
                true,
                null,
                (int)$total,
                $postList,
                $topicData
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get thread: ' . $e->getMessage());
        }
    }

    public function actionGetThreadByPost(ParameterBag $params)
    {
        $postId = $params->get('postId', '');
        $postsPerRequest = $params->get('postsPerRequest', 20);

        if (empty($postId)) {
            return $this->apiError('Post ID is required');
        }

        try {
            $post = $this->assertViewablePost($postId);
            
            // Safely get thread
            $thread = null;
            try {
                $thread = $post->Thread;
            } catch (\Exception $e) {
                return $this->apiError('Thread not found');
            }
            
            if (!$thread) {
                return $this->apiError('Thread not found');
            }
            
            // Calculate position and get surrounding posts
            // Get position by counting posts before this one
            $positionFinder = $this->finder('XF:Post');
            $positionFinder->where('thread_id', $thread->thread_id);
            $positionFinder->where('message_state', 'visible');
            $positionFinder->where('post_date', '<=', $post->post_date);
            $position = $positionFinder->total();
            
            $startNum = max(1, $position - floor($postsPerRequest / 2));
            $lastNum = $startNum + $postsPerRequest - 1;

            // Get posts using same logic as actionGetThread
            $postFinder = $this->finder('XF:Post');
            $postFinder->where('thread_id', $thread->thread_id);
            $postFinder->where('message_state', 'visible');
            $postFinder->order('post_date', 'ASC');
            
            // Load Thread relationship with Forum for proper permission checks (needed for canEdit/canDelete)
            $postFinder->with(['Thread', 'Thread.Forum', 'Thread.Forum.Node']);
            
            // Apply pagination
            $perPage = $lastNum - $startNum + 1;
            // Offset should be startNum - 1 (since position 1 = offset 0)
            $offset = $startNum - 1;
            $postFinder->limit($perPage, $offset);
            
            // Fetch posts
            $posts = $postFinder->fetch();
            $total = $postFinder->total();

            $postList = [];
            foreach ($posts as $p) {
                $error = null;
                if (!$p->canView($error)) {
                    continue;
                }

                $authorName = 'Unknown';
                $authorUserType = '0';
                $authorIconUrl = '';
                try {
                    if ($p->User) {
                        $authorName = $p->User->username;
                        $authorUserType = (string)$p->User->user_group_id;
                        $authorIconUrl = $this->getAbsoluteUrl($p->User->getAvatarUrl('s'));
                    }
                } catch (\Exception $e) {
                }

                $postContent = '';
                try {
                    // Ensure message is a string before processing
                    $message = is_array($p->message) ? '' : (string)$p->message;
                    $postContent = $message; // Always return BBCode
                    
                    // Process image proxy URLs in BBCode
                    $postContent = $this->processImageProxyInBbCode($postContent);
                } catch (\Exception $e) {
                    // Fallback: ensure we have a string
                    $postContent = is_array($p->message) ? '' : (string)$p->message;
                }

                // Get likes info (list of users who liked this post)
                $likesInfo = $this->getPostLikesInfo($p);

                // Get canLike and isLiked flags
                $likeFlags = $this->getPostLikeFlags($p);
                $canLike = $likeFlags['canLike'];
                $isLiked = $likeFlags['isLiked'];

                // Calculate post position (floor number) in the thread
                $position = $this->getPostPosition($p);

                // Load and convert attachments
                $attachments = $this->getPostAttachments($p);

                $fcPost = new FCPost([
                    'id' => (string)$p->post_id,
                    'topicId' => (string)$p->thread_id,
                    'authorId' => (string)$p->user_id,
                    'authorName' => $authorName,
                    'authorUserType' => $authorUserType,
                    'timestamp' => $p->post_date * 1000,
                    'content' => $postContent,
                    'title' => $p->post_id === $thread->first_post_id ? $thread->title : '',
                    'authorIconUrl' => $authorIconUrl,
                    'canEdit' => $p->canEdit(),
                    'canDelete' => $p->canDelete(),
                    'canReport' => false,
                    'canLike' => $canLike,
                    'isLiked' => $isLiked,
                    'likeCount' => isset($p->reaction_score) ? (int)$p->reaction_score : 0,
                    'likesInfo' => $likesInfo,
                    'isApproved' => $p->message_state === 'visible',
                    'isFirstPost' => $p->post_id === $thread->first_post_id,
                    'position' => $position,
                    'attachments' => $attachments,
                ]);
                
                $postList[] = $fcPost;
            }

            // Build topic data (same as actionGetThread)
            $forumName = 'Unknown';
            try {
                if ($thread->Forum && $thread->Forum->Node) {
                    $forumName = $thread->Forum->Node->title;
                }
            } catch (\Exception $e) {
            }

            $threadAuthorName = 'Unknown';
            $threadAuthorUserType = '0';
            $threadAuthorIconUrl = '';
            try {
                if ($thread->User) {
                    $threadAuthorName = $thread->User->username;
                    $threadAuthorUserType = (string)$thread->User->user_group_id;
                    $threadAuthorIconUrl = $this->getAbsoluteUrl($thread->User->getAvatarUrl('m'));
                }
            } catch (\Exception $e) {
            }

            $shortContent = '';
            try {
                if ($thread->first_post_id) {
                    $firstPost = $this->em()->find('XF:Post', $thread->first_post_id);
                    if ($firstPost && $firstPost->message) {
                        $shortContent = $this->getShortContent($firstPost->message);
                    }
                }
            } catch (\Exception $e) {
            }

            $likeCount = 0;
            if ($thread->first_post_id) {
                $firstPost = $this->em()->find('XF:Post', $thread->first_post_id);
                if ($firstPost && isset($firstPost->reaction_score)) {
                    $likeCount = (int)$firstPost->reaction_score;
                }
            }

            // Get prefix label
            $prefixLabel = $this->getThreadPrefixLabel($thread);
            $threadWithPoll = $this->em()->find('XF:Thread', $thread->thread_id, ['Poll']);
            $pollData = $this->buildPollDataForThread($threadWithPoll ?: $thread);

            $topicData = [
                'id' => (string)$thread->thread_id,
                'title' => $thread->title,
                'forumId' => (string)$thread->node_id,
                'forumName' => $forumName,
                'authorId' => (string)$thread->user_id,
                'authorName' => $threadAuthorName,
                'authorUserType' => $threadAuthorUserType,
                'timestamp' => $thread->post_date * 1000,
                'prefix' => $prefixLabel,
                'authorIconUrl' => $threadAuthorIconUrl,
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
                'canReport' => false,
                'canUpload' => false,
                'isBanned' => false,
                'isApproved' => $thread->discussion_state === 'visible',
                'isDeleted' => $thread->discussion_state === 'deleted',
                'isMoved' => false,
                'isMerged' => false,
                'realTopicId' => (string)$thread->thread_id,
                'canLike' => false,
                'isLiked' => false,
                'likeCount' => $likeCount,
                'hasPoll' => ($pollData !== null),
                'poll' => $pollData,
            ];

            // Mark thread as read up to the last post shown (same as web interface)
            // Only mark if user is logged in and we have posts in simple date order
            $visitor = \XF::visitor();
            if ($visitor->user_id && !empty($posts) && !$this->request->isPrefetch()) {
                // Find the last post by post_date (posts are ordered by post_date ASC)
                $lastPost = null;
                $lastPostDate = 0;
                foreach ($posts as $p) {
                    if ($p->post_date > $lastPostDate) {
                        $lastPostDate = $p->post_date;
                        $lastPost = $p;
                    }
                }
                
                if ($lastPost) {
                    try {
                        $this->repository('XF:Thread')->markThreadReadByVisitor($thread, $lastPost->post_date);
                    } catch (\Exception $e) {
                        // Silently fail if marking as read fails (e.g., add-on conflicts)
                    }
                }
            }

            $result = new FCThreadByPostResult(
                true,
                null,
                (int)$total,
                $thread->canReply(),
                false, // canReport
                false, // canUpload
                $postList,
                $position,
                $topicData
            );

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Post not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to get thread by post: ' . $e->getMessage());
        }
    }

    public function actionGetThreadByUnread(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $postsPerRequest = $params->get('postsPerRequest', 20);

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        try {
            // Try to get thread safely - handle exceptions from assertViewableThread
            $thread = null;
            try {
                $thread = $this->assertViewableThread($topicId);
            } catch (\XF\Mvc\Reply\Exception $e) {
                // Extract XenForo's error message from the exception
                $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
                return $this->apiError($errorMsg);
            } catch (\Exception $e) {
                return $this->apiError('Failed to get thread: ' . $e->getMessage());
            }
            
            if (!$thread) {
                return $this->apiError('Thread not found');
            }

            $visitor = \XF::visitor();

            // Get read date from ThreadRead entity - avoid add-on conflicts
            $readDate = 0;
            try {
                $threadRead = $this->em()->find('XF:ThreadRead', [
                    'thread_id' => $thread->thread_id,
                    'user_id' => $visitor->user_id
                ]);
                
                if ($threadRead && isset($threadRead->thread_read_date)) {
                    $readDate = (int)$threadRead->thread_read_date;
                }
            } catch (\Exception $e) {
                // If ThreadRead doesn't exist or has conflicts, use thread post_date as fallback
                $readDate = (int)$thread->post_date;
            }
            
            // If no read date found, use thread creation date or visitor registration date
            if ($readDate === 0) {
                $readDate = (int)$thread->post_date;
                if ($visitor->user_id && $visitor->register_date > $thread->post_date) {
                    $readDate = (int)$visitor->register_date;
                }
            }

            // Check if thread is fully read by comparing readDate with last_post_date
            // If readDate >= last_post_date, the thread is fully read
            $isFullyRead = false;
            if ($readDate > 0 && isset($thread->last_post_date)) {
                $isFullyRead = ($readDate >= (int)$thread->last_post_date);
            }
            
            // Find first unread post using basic finder to avoid add-on conflicts
            $firstUnreadPost = null;
            if (!$isFullyRead) {
                // Only search for unread posts if thread is not fully read
                $finder = $this->finder('XF:Post');
                $finder->where('thread_id', $thread->thread_id);
                $finder->where('message_state', 'visible');
                $finder->where('post_date', '>', $readDate);
                $finder->order('post_date', 'ASC');
                $finder->limit(1);
                
                $firstUnreadPost = $finder->fetchOne();
            }
            
            // Calculate position of first unread post
            $position = 1;
            $startNum = 1;
            
            if ($firstUnreadPost) {
                // Get position of first unread post
                $positionFinder = $this->finder('XF:Post');
                $positionFinder->where('thread_id', $thread->thread_id);
                $positionFinder->where('message_state', 'visible');
                $positionFinder->where('post_date', '<=', $firstUnreadPost->post_date);
                $position = $positionFinder->total();
                
                // Calculate which page contains the first unread post
                // Return the full page that contains the first unread post
                $page = ceil($position / $postsPerRequest);
                // Calculate start position for that page (page 1 = posts 1-20, page 2 = posts 21-40, etc.)
                $startNum = ($page - 1) * $postsPerRequest + 1;
            } else {
                // No unread posts - user has read everything
                // Return the last page and last post position
                $totalPostsFinder = $this->finder('XF:Post');
                $totalPostsFinder->where('thread_id', $thread->thread_id);
                $totalPostsFinder->where('message_state', 'visible');
                $totalPosts = $totalPostsFinder->total();
                
                if ($totalPosts > 0) {
                    // Position is the last post
                    $position = $totalPosts;
                    // Start from the last page
                    $startNum = max(1, $totalPosts - $postsPerRequest + 1);
                } else {
                    // No posts at all, default to position 1
                    $position = 1;
                    $startNum = 1;
                }
            }
            
            $lastNum = $startNum + $postsPerRequest - 1;
            
            // Get posts using same logic as actionGetThread
            $postFinder = $this->finder('XF:Post');
            $postFinder->where('thread_id', $thread->thread_id);
            $postFinder->where('message_state', 'visible');
            $postFinder->order('post_date', 'ASC');
            
            // Load Thread relationship with Forum for proper permission checks (needed for canEdit/canDelete)
            $postFinder->with(['Thread', 'Thread.Forum', 'Thread.Forum.Node']);
            
            // Apply pagination
            $perPage = $lastNum - $startNum + 1;
            // Offset should be startNum - 1 (since position 1 = offset 0)
            $offset = $startNum - 1;
            $postFinder->limit($perPage, $offset);
            
            // Load visitor's reaction if logged in (needed for isReactedTo check)
            $visitor = \XF::visitor();
            if ($visitor->user_id) {
                $postFinder->with(['Reactions|' . $visitor->user_id]);
            }
            
            // Fetch posts
            $posts = $postFinder->fetch();
            $total = $postFinder->total();

            $postList = [];
            foreach ($posts as $post) {
                // Respect XenForo's permission system
                $error = null;
                if (!$post->canView($error)) {
                    continue;
                }

                // Safely get user information
                $authorName = 'Unknown';
                $authorUserType = '0';
                $authorIconUrl = '';
                try {
                    if ($post->User) {
                        $authorName = $post->User->username;
                        $authorUserType = (string)$post->User->user_group_id;
                        $authorIconUrl = $this->getAbsoluteUrl($post->User->getAvatarUrl('s'));
                    }
                } catch (\Exception $e) {
                    // If add-on conflict occurs, use defaults
                }

                // Get post content safely - always return BBCode
                $postContent = '';
                try {
                    // Ensure message is a string before processing
                    $message = is_array($post->message) ? '' : (string)$post->message;
                    $postContent = $message; // Always return BBCode
                    
                    // Process image proxy URLs in BBCode
                    $postContent = $this->processImageProxyInBbCode($postContent);
                } catch (\Exception $e) {
                    // Fallback: ensure we have a string
                    $postContent = is_array($post->message) ? '' : (string)$post->message;
                }

                // For post-level permissions, use defaults to avoid conflicts
                $canReport = false;
                
                // Get canLike and isLiked flags
                $likeFlags = $this->getPostLikeFlags($post);
                $canLike = $likeFlags['canLike'];
                $isLiked = $likeFlags['isLiked'];

                // Get likes info (list of users who liked this post)
                $likesInfo = $this->getPostLikesInfo($post);

                // Calculate post position (floor number) in the thread
                // Use $postPosition to avoid overwriting $position (first unread position)
                $postPosition = $this->getPostPosition($post);

                // Load and convert attachments
                $attachments = $this->getPostAttachments($post);

                $fcPost = new FCPost([
                    'id' => (string)$post->post_id,
                    'topicId' => (string)$post->thread_id,
                    'authorId' => (string)$post->user_id,
                    'authorName' => $authorName,
                    'authorUserType' => $authorUserType,
                    'timestamp' => $post->post_date * 1000,
                    'content' => $postContent,
                    'title' => $post->post_id === $thread->first_post_id ? $thread->title : '',
                    'authorIconUrl' => $authorIconUrl,
                    'canEdit' => $post->canEdit(),
                    'canDelete' => $post->canDelete(),
                    'canReport' => $canReport,
                    'canLike' => $canLike,
                    'isLiked' => $isLiked,
                    'likeCount' => isset($post->reaction_score) ? (int)$post->reaction_score : 0,
                    'likesInfo' => $likesInfo,
                    'isApproved' => $post->message_state === 'visible',
                    'isFirstPost' => $post->post_id === $thread->first_post_id,
                    'position' => $postPosition,
                    'attachments' => $attachments,
                ]);
                
                $postList[] = $fcPost;
            }

            // Build topic data
            $forumName = 'Unknown';
            try {
                if ($thread->Forum && $thread->Forum->Node) {
                    $forumName = $thread->Forum->Node->title;
                }
            } catch (\Exception $e) {
            }

            $threadAuthorName = 'Unknown';
            $threadAuthorUserType = '0';
            $threadAuthorIconUrl = '';
            try {
                if ($thread->User) {
                    $threadAuthorName = $thread->User->username;
                    $threadAuthorUserType = (string)$thread->User->user_group_id;
                    $threadAuthorIconUrl = $this->getAbsoluteUrl($thread->User->getAvatarUrl('m'));
                }
            } catch (\Exception $e) {
            }

            $shortContent = '';
            try {
                if ($thread->first_post_id) {
                    $firstPost = $this->em()->find('XF:Post', $thread->first_post_id);
                    if ($firstPost && $firstPost->message) {
                        $shortContent = $this->getShortContent($firstPost->message);
                    }
                }
            } catch (\Exception $e) {
            }

            $likeCount = 0;
            if ($thread->first_post_id) {
                $firstPost = $this->em()->find('XF:Post', $thread->first_post_id);
                if ($firstPost && isset($firstPost->reaction_score)) {
                    $likeCount = (int)$firstPost->reaction_score;
                }
            }

            // Get prefix label
            $prefixLabel = $this->getThreadPrefixLabel($thread);
            $threadWithPoll = $this->em()->find('XF:Thread', $thread->thread_id, ['Poll']);
            $pollData = $this->buildPollDataForThread($threadWithPoll ?: $thread);

            $topicData = [
                'id' => (string)$thread->thread_id,
                'title' => $thread->title,
                'forumId' => (string)$thread->node_id,
                'forumName' => $forumName,
                'authorId' => (string)$thread->user_id,
                'authorName' => $threadAuthorName,
                'authorUserType' => $threadAuthorUserType,
                'timestamp' => $thread->post_date * 1000,
                'prefix' => $prefixLabel,
                'authorIconUrl' => $threadAuthorIconUrl,
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
                'canReport' => false,
                'canUpload' => false,
                'isBanned' => false,
                'isApproved' => $thread->discussion_state === 'visible',
                'isDeleted' => $thread->discussion_state === 'deleted',
                'isMoved' => false,
                'isMerged' => false,
                'realTopicId' => (string)$thread->thread_id,
                'canLike' => false,
                'isLiked' => false,
                'likeCount' => $likeCount,
                'hasPoll' => ($pollData !== null),
                'poll' => $pollData,
            ];

            // Mark thread as read up to the last post shown (same as web interface)
            // Only mark if user is logged in and we have posts in simple date order
            if ($visitor->user_id && !empty($posts) && !$this->request->isPrefetch()) {
                // Find the last post by post_date (posts are ordered by post_date ASC)
                $lastPost = null;
                $lastPostDate = 0;
                foreach ($posts as $post) {
                    if ($post->post_date > $lastPostDate) {
                        $lastPostDate = $post->post_date;
                        $lastPost = $post;
                    }
                }
                
                if ($lastPost) {
                    try {
                        $this->repository('XF:Thread')->markThreadReadByVisitor($thread, $lastPost->post_date);
                    } catch (\Exception $e) {
                        // Silently fail if marking as read fails (e.g., add-on conflicts)
                    }
                }
            }

            $result = new FCThreadByUnreadResult(
                true,
                null,
                (int)$total,
                $thread->canReply(),
                false, // canReport
                false, // canUpload
                $postList,
                $position,
                $topicData
            );

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to get thread by unread: ' . $e->getMessage());
        }
    }

    /**
     * Submit or change the current user's vote on a thread poll.
     * Expects topicId and responseIds (option IDs from poll). Returns updated poll data on success.
     */
    public function actionVotePoll(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $responseIds = $params->get('responseIds', []);

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        if (!is_array($responseIds) || empty($responseIds)) {
            return $this->apiError('responseIds is required');
        }

        try {
            $thread = null;
            try {
                $thread = $this->assertViewableThread($topicId);
            } catch (\XF\Mvc\Reply\Exception $e) {
                $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
                return $this->apiError($errorMsg);
            } catch (\Exception $e) {
                return $this->apiError('Failed to get thread: ' . $e->getMessage());
            }

            if (!$thread) {
                return $this->apiError('Thread not found');
            }

            $poll = null;
            try {
                $poll = $thread->Poll;
            } catch (\Exception $e) {
                $poll = null;
            }

            if (!$poll) {
                return $this->apiError('Poll not found');
            }

            $error = null;
            if (!$poll->canVote($error)) {
                $errorMessage = $error ? (string)$error : 'Cannot vote on this poll';
                return $this->apiError($errorMessage);
            }

            $responseIds = array_values(array_map('intval', $responseIds));

            $voter = $this->service(\XF\Service\Poll\VoterService::class, $poll, $responseIds);
            if (!$voter->validate($errors)) {
                if (is_array($errors)) {
                    $errors = array_map('strval', $errors);
                    return $this->apiError(implode(', ', $errors));
                }
                return $this->apiError((string)$errors);
            }

            $voter->save();

            return $this->apiSuccess([
                'poll' => $this->buildPollDataForThread($thread),
            ]);
        } catch (\Exception $e) {
            return $this->apiError('Failed to vote on poll: ' . $e->getMessage());
        }
    }

    public function actionReplyPost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toReplyPostParamsExtended($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $thread = $this->assertViewableThread($fcParams->topicId);
            $visitor = \XF::visitor();

            if (!$thread->canReply($error)) {
                return $this->apiError('Cannot reply to this thread: ' . ($error ? $error : 'Permission denied'));
            }

            // Use XenForo's Thread Replier service (like Tapatalk does)
            /** @var \XF\Service\Thread\Replier $replier */
            $replier = $this->service('XF:Thread\Replier', $thread);
            $replier->setMessage($fcParams->textBody);

            // Handle attachments if provided
            if ($thread->Forum->canUploadAndManageAttachments()) {
                $attachmentHash = '';
                $groupId = $fcParams->groupId ?? $params->get('groupId', '');
                if ($groupId) {
                    $attachmentHash = $groupId;
                } elseif (!empty($fcParams->attachmentIds) && is_array($fcParams->attachmentIds)) {
                    // Get attachments by IDs and build hash string
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
                if ($attachmentHash) {
                    $replier->setAttachmentHash($attachmentHash);
                }
            }

            // Validate before saving
            if (!$replier->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            // Save reply post
            $post = $replier->save();
            
            // Send notifications
            $replier->sendNotifications();

            // Mark thread as read for replier
            $this->repository('XF:Thread')->markThreadReadByVisitor($thread);

            // Get post content safely - always return BBCode
            $postContent = '';
            try {
                $postContent = $post->message; // Always return BBCode
            } catch (\Exception $e) {
                $postContent = $post->message;
            }

            $result = new FCReplyPostResult(
                true,
                null,
                (string)$post->post_id,
                $thread->canView() ? 0 : 1, // state: 0 = visible, 1 = needs moderation
                $postContent,
                $post->canEdit(),
                $post->canDelete(),
                $post->canReport() // canReport
            );

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to post reply: ' . $e->getMessage());
        }
    }

    public function actionGetRawPost(ParameterBag $params)
    {
        $postId = $params->get('postId', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required');
        }

        try {
            // Use basic finder to avoid add-on conflicts
            $post = $this->em()->find('XF:Post', (int)$postId);
            
            if (!$post) {
                return $this->apiError('Post not found');
            }

            $visitor = \XF::visitor();

            // Check if post is viewable
            $error = null;
            if (!$post->canView($error)) {
                return $this->apiError('Cannot view this post');
            }

            // Check edit permission - use canEdit() which exists in base Post entity
            if (!$post->canEdit()) {
                return $this->apiError('Cannot edit this post');
            }

            // Safely get thread title, prefix information
            $threadTitle = '';
            $canEditTitle = false;
            $prefixId = null;
            $requirePrefix = false;
            $availablePrefixes = [];

            try {
                if ($post->Thread && $post->post_id === $post->Thread->first_post_id) {
                    $thread = $post->Thread;
                    $threadTitle = $thread->title;

                    // Check if user can edit thread title
                    $canEditTitle = $thread->canEdit();

                    // Check if user has permission to edit prefix
                    if ($thread->isPrefixEditable()) {
                        // Get current prefix_id
                        if ($thread->prefix_id) {
                            $prefixId = is_array($thread->prefix_id) 
                                ? (string)($thread->prefix_id[0] ?? '') 
                                : (string)$thread->prefix_id;
                        }

                        // Get forum and check if prefix is required
                        if ($thread->Forum) {
                            $forum = $thread->Forum;
                            $usablePrefixes = $forum->getUsablePrefixes($thread->Prefix);

                            // Get available prefixes
                            foreach ($usablePrefixes as $groupOrPrefix) {
                                if ($groupOrPrefix instanceof \XF\Entity\ThreadPrefix) {
                                    $prefixTitle = $groupOrPrefix->title;
                                    if ($prefixTitle instanceof \XF\Phrase) {
                                        $prefixTitle = $prefixTitle->render();
                                    }

                                    $availablePrefixes[] = [
                                        'id' => (string)$groupOrPrefix->prefix_id,
                                        'title' => (string)$prefixTitle,
                                    ];
                                    continue;
                                }
                                if (is_array($groupOrPrefix) || $groupOrPrefix instanceof \Traversable) {
                                    foreach ($groupOrPrefix as $prefix) {
                                        if ($prefix instanceof \XF\Entity\ThreadPrefix) {
                                            $prefixTitle = $prefix->title;
                                            if ($prefixTitle instanceof \XF\Phrase) {
                                                $prefixTitle = $prefixTitle->render();
                                            }

                                            $availablePrefixes[] = [
                                                'id' => (string)$prefix->prefix_id,
                                                'title' => (string)$prefixTitle,
                                            ];
                                        }
                                    }
                                }
                            }

                            // Check if prefix is required
                            $requirePrefix = $forum->require_prefix 
                                && count($availablePrefixes) > 0
                                && !$thread->canMove();
                        }
                    }
                }
            } catch (\Exception $e) {
                // If add-on conflict occurs, skip thread title and prefix info
            }

            // Load and convert attachments
            $attachments = $this->getPostAttachments($post);

            $result = new FCRawPostResult(
                true,
                null,
                $post->message,
                $threadTitle,
                $canEditTitle,
                $prefixId,
                $requirePrefix,
                $availablePrefixes,
                $attachments
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get raw post: ' . $e->getMessage());
        }
    }

    public function actionSaveRawPost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');
        $postTitle = $params->get('postTitle', '');
        $postContent = $params->get('postContent', '');
        $prefix = $params->get('prefix', null);
        $reason = $params->get('reason', '');
        $attachmentIds = $params->get('attachmentIds', []);
        $groupId = $params->get('groupId', '');

        if (empty($postId) || empty($postContent)) {
            return $this->apiError('Post ID and content are required');
        }

        try {
            // Use basic finder to avoid add-on conflicts
            $post = $this->em()->find('XF:Post', (int)$postId);
            
            if (!$post) {
                return $this->apiError('Post not found');
            }

            $visitor = \XF::visitor();

            // Check if post is viewable
            $error = null;
            if (!$post->canView($error)) {
                return $this->apiError('Cannot view this post');
            }

            // Check edit permission - use canEdit() which exists in base Post entity
            if (!$post->canEdit($error)) {
                return $this->apiError('Cannot edit this post: ' . ($error ? $error : 'Permission denied'));
            }

            // Use XenForo's Post Editor service (like core does)
            /** @var \XF\Service\Post\Editor $editor */
            $editor = $this->service('XF:Post\Editor', $post);
            $editor->setMessage($postContent);

            // Handle attachments if provided
            $thread = $post->Thread;
            if ($thread && $thread->Forum && $thread->Forum->canUploadAndManageAttachments()) {
                $attachmentHash = '';
                if ($groupId) {
                    $attachmentHash = $groupId;
                } elseif (!empty($attachmentIds) && is_array($attachmentIds)) {
                    // Get attachments by IDs and build hash string
                    $attachmentRepo = $this->repository('XF:Attachment');
                    $attachments = $attachmentRepo->findByIds($attachmentIds);
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
                if ($attachmentHash) {
                    $editor->setAttachmentHash($attachmentHash);
                }
            }

            // If this is the first post, handle thread-level edits (title and/or prefix)
            $threadEditor = null;
            if ($post->isFirstPost() && $thread && $thread->canEdit()) {
                $needsThreadEditor = false;

                // Check if we need to update title or prefix
                if (!empty($postTitle)) {
                    $needsThreadEditor = true;
                }
                if ($prefix !== null) {
                    $needsThreadEditor = true;
                }

                if ($needsThreadEditor) {
                    /** @var \XF\Service\Thread\EditorService $threadEditor */
                    $threadEditor = $this->service('XF:Thread\Editor', $thread);

                    // Handle title if provided
                    if (!empty($postTitle)) {
                        $threadEditor->setTitle($postTitle);
                    }

                    // Handle prefix if provided and editable
                    if ($prefix !== null && $thread->isPrefixEditable()) {
                        $prefixId = (int)$prefix;
                        // Validate prefix is usable for this forum
                        if ($prefixId != $thread->prefix_id && !$thread->Forum->isPrefixUsable($prefixId)) {
                            $prefixId = 0; // not usable, just blank it out
                        }
                        $threadEditor->setPrefix($prefixId);
                    }

                    $editor->setThreadEditor($threadEditor);
                }
            }

            // Validate before saving
            if (!$editor->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            // Save post (and thread if first post)
            $editor->save();

            // Get post content safely - always return BBCode
            $finalContent = $post->message;

            $result = new FCSaveRawPostResult(
                true,
                null,
                $finalContent
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to update post: ' . $e->getMessage());
        }
    }

    public function actionGetQuotePost(ParameterBag $params)
    {
        $postId = $params->get('postId', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required');
        }

        try {
            $post = $this->assertViewablePost($postId);

            // Get username with fallback for guest users
            $username = $post->User ? $post->User->username : ($post->username ?: 'Guest');
            
            // Create quote format - handle guest users properly
            $quote = '[QUOTE="' . $username . ', post: ' . $post->post_id;
            if ($post->User) {
                $quote .= ', member: ' . $post->user_id;
            }
            $quote .= '"]' . $post->message . '[/QUOTE]';

            $result = new FCQuotePostResult(
                true,
                null,
                $quote
            );

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Post not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to get quote: ' . $e->getMessage());
        }
    }

    public function actionReportPost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');
        $reason = $params->get('reason', '');

        if (empty($postId) || empty($reason)) {
            return $this->apiError('Post ID and reason are required');
        }

        try {
            $post = $this->assertViewablePost($postId);
            $visitor = \XF::visitor();

            if (!$post->canReport($error)) {
                return $this->apiError('Cannot report this post: ' . ($error ? $error : 'Permission denied'));
            }

            if (empty($reason)) {
                return $this->apiError('Reason is required');
            }

            // Use XenForo's Report Creator service (like Tapatalk does)
            /** @var \XF\Service\Report\Creator $creator */
            $creator = $this->service('XF:Report\Creator', 'post', $post);
            $creator->setMessage($reason);

            // Validate before saving
            if (!$creator->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            // Save report (this already includes the message as a comment)
            $report = $creator->save();
            
            // Send notifications
            $creator->sendNotifications();

            $result = new FCReportPostResult(true, null);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Post not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to report post: ' . $e->getMessage());
        }
    }

    /**
     * Process BBCode content to replace image URLs with proxy URLs if image proxy is enabled
     * 
     * @param string $bbCode The BBCode content
     * @return string BBCode with proxied image URLs
     */
    protected function processImageProxyInBbCode($bbCode)
    {
        if (empty($bbCode)) {
            return $bbCode;
        }
        
        try {
            $formatter = $this->app()->stringFormatter();
            
            // Process [IMG] tags - match [IMG]url[/IMG] or [IMG size="..."]url[/IMG]
            $bbCode = preg_replace_callback(
                '#\[IMG(?:[^\]]*)?\](https?://[^\[]+)\[/IMG\]#iU',
                function ($matches) use ($formatter) {
                    $url = $matches[1];
                    
                    // Check if URL is local (shouldn't be proxied)
                    $linkInfo = $formatter->getLinkClassTarget($url);
                    if ($linkInfo['local']) {
                        return $matches[0]; // Return original if local
                    }
                    
                    // Get proxied URL if image proxy is active
                    $proxiedUrl = $formatter->getProxiedUrlIfActive('image', $url);
                    if ($proxiedUrl) {
                        // Replace the URL in the IMG tag
                        return str_replace($url, $proxiedUrl, $matches[0]);
                    }
                    
                    // Return original if no proxy
                    return $matches[0];
                },
                $bbCode
            );
        } catch (\Exception $e) {
            // If processing fails, return original BBCode
        }
        
        return $bbCode;
    }

    /**
     * Get attachments for a post and convert them to FCAttachment objects
     * 
     * @param \XF\Entity\Post $post The post entity
     * @return array Array of FCAttachment objects
     */
    protected function getPostAttachments($post)
    {
        $attachments = [];
        
        try {
            // Query attachments for this post
            $attachmentFinder = $this->finder('XF:Attachment');
            $attachmentFinder->where('content_type', 'post');
            $attachmentFinder->where('content_id', $post->post_id);
            $attachmentFinder->with('Data');
            $postAttachments = $attachmentFinder->fetch();
            
            if (!$postAttachments || $postAttachments->count() == 0) {
                return $attachments;
            }
            
            foreach ($postAttachments as $attachment) {
                // Skip temporary/unassociated attachments
                if ($attachment->temp_hash || $attachment->unassociated) {
                    continue;
                }
                
                // Check if user can view this attachment
                $error = null;
                $canView = $attachment->canView($error);
                
                // Get attachment data
                $data = $attachment->Data;
                if (!$data) {
                    continue;
                }
                
                // Determine if it's an image
                $isImage = false;
                $width = null;
                $height = null;
                if ($data->width && $data->height) {
                    $isImage = true;
                    $width = (int)$data->width;
                    $height = (int)$data->height;
                }
                
                // Get MIME type from extension (simple mapping for common types)
                $mimeType = '';
                try {
                    $extension = strtolower($data->extension ?? '');
                    $mimeMap = [
                        'txt' => 'text/plain',
                        'jpg' => 'image/jpeg',
                        'jpeg' => 'image/jpeg',
                        'png' => 'image/png',
                        'gif' => 'image/gif',
                        'pdf' => 'application/pdf',
                        'zip' => 'application/zip',
                    ];
                    $mimeType = $mimeMap[$extension] ?? '';
                } catch (\Exception $e) {
                    // If MIME type detection fails, leave empty
                }
                
                // Get attachment URL (only if user can view full attachment)
                // Use getDirectUrl() which returns direct file URL when available, or route URL as fallback
                $url = '';
                if ($canView) {
                    try {
                        // getDirectUrl() returns direct file URL for videos/audio, or attachment route URL for others
                        $directUrl = $attachment->getDirectUrl(true);
                        $url = $this->getAbsoluteUrl($directUrl);
                    } catch (\Exception $e) {
                        // If URL building fails, try alternative method
                        try {
                            $url = $this->buildLink('canonical:attachments', $attachment);
                        } catch (\Exception $e2) {
                            // If both fail, leave URL empty
                        }
                    }
                }
                
                // Get thumbnail URL if available (ALWAYS return if thumbnail exists, like web interface)
                $thumbnailUrl = null;
                if ($attachment->has_thumbnail) {
                    try {
                        $thumbnailUrl = $this->getAbsoluteUrl($attachment->thumbnail_url);
                    } catch (\Exception $e) {
                        // If thumbnail URL building fails, leave as null
                    }
                }
                
                // Check permissions for viewing URLs
                // canViewUrl requires thread's canViewAttachments permission (for full image viewing)
                // Thumbnails are always viewable (like web interface), full URLs require permission
                $canViewUrl = false;
                if ($post->Thread) {
                    $error = null;
                    $canViewUrl = $post->Thread->canViewAttachments($error);
                }
                $canViewThumbnailUrl = $attachment->has_thumbnail; // Not dependent on canView
                
                // Check if attachment is embedded inline in the post
                $isInline = false;
                if (method_exists($post, 'isAttachmentEmbedded')) {
                    $isInline = $post->isAttachmentEmbedded($attachment->attachment_id);
                }
                
                // Create FCAttachment object
                $fcAttachment = new FCAttachment([
                    'id' => (string)$attachment->attachment_id,
                    'fileName' => $attachment->filename,
                    'fileSize' => (int)$attachment->file_size,
                    'mimeType' => $mimeType,
                    'url' => $url,
                    'thumbnailUrl' => $thumbnailUrl,
                    'groupId' => $attachment->temp_hash ?: '',
                    'isImage' => $isImage,
                    'width' => $width,
                    'height' => $height,
                    'canViewUrl' => $canViewUrl,
                    'canViewThumbnailUrl' => $canViewThumbnailUrl,
                    'isInline' => $isInline,
                ]);
                
                $attachments[] = $fcAttachment;
            }
        } catch (\Exception $e) {
            // If attachment loading fails, log error and return empty array
            \XF::logError('ForumCopilot: Error loading post attachments: ' . $e->getMessage());
        }
        
        return $attachments;
    }
}

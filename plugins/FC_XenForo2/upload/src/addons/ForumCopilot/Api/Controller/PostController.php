<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($fcParams->topicId);

            $startNum = (int)$fcParams->startNum;
            $perPage = (int)$fcParams->lastNum - $startNum + 1;
            [$posts, $total] = $this->fetchThreadPostsPage($thread, $startNum, $perPage);

            $result = new FCThreadResult(
                true,
                null,
                $total,
                $this->buildThreadPostRows($thread, $posts),
                $this->buildThreadTopicData($thread)
            );

            $this->finishThreadView($thread, $posts);

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get thread');
        }
    }

    public function actionGetThreadByPost(ParameterBag $params)
    {
        $postId = $params->get('postId', '');
        $postsPerRequest = $params->get('postsPerRequest', 20);

        if (empty($postId)) {
            return $this->apiError('Post ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $post = $this->assertViewablePost($postId);
            $thread = $post->Thread;
            if (!$thread) {
                return $this->apiError('Thread not found', null, ErrorCode::NOT_FOUND);
            }

            // Calculate position and get surrounding posts
            // Get position by counting posts before this one
            $positionFinder = $this->finder('XF:Post');
            $positionFinder->where('thread_id', $thread->thread_id);
            $positionFinder->where('message_state', 'visible');
            $positionFinder->where('post_date', '<=', $post->post_date);
            $position = $positionFinder->total();

            $startNum = max(1, $position - floor($postsPerRequest / 2));
            [$posts, $total] = $this->fetchThreadPostsPage($thread, $startNum, $postsPerRequest);

            $topicData = $this->buildThreadTopicData($thread);
            $result = new FCThreadByPostResult(
                true,
                null,
                $total,
                $thread->canReply(),
                $topicData['canReport'],
                $topicData['canUpload'],
                $this->buildThreadPostRows($thread, $posts),
                $position,
                $topicData
            );

            $this->finishThreadView($thread, $posts);

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get thread by post');
        }
    }

    public function actionGetThreadByUnread(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $postsPerRequest = $params->get('postsPerRequest', 20);

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);

            // XenForo's read date for the visitor: the later of the thread and forum read
            // markers, never earlier than the read-marking cut-off
            $readDate = (int)$thread->getVisitorReadDate();

            // At the cut-off XenForo has no read data for this visitor, so like its own
            // "unread" link (Pub\Controller\Thread::actionUnread) start from the first post
            if ($readDate <= $this->repository('XF:Thread')->getReadMarkingCutOff()) {
                $readDate = 0;
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

                // Return the full page that contains the first unread post
                // (page 1 = posts 1-20, page 2 = posts 21-40, etc.)
                $page = ceil($position / $postsPerRequest);
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
                }
            }

            [$posts, $total] = $this->fetchThreadPostsPage($thread, $startNum, $postsPerRequest);

            $topicData = $this->buildThreadTopicData($thread);
            $result = new FCThreadByUnreadResult(
                true,
                null,
                $total,
                $thread->canReply(),
                $topicData['canReport'],
                $topicData['canUpload'],
                $this->buildThreadPostRows($thread, $posts),
                $position,
                $topicData
            );

            $this->finishThreadView($thread, $posts);

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get thread by unread');
        }
    }

    /**
     * One page of a thread's posts for getThread, getThreadByPost and
     * getThreadByUnread, which share it and the builders below.
     *
     * @param \XF\Entity\Thread $thread
     * @param int $startNum 1-based number of the first post
     * @param int $perPage
     * @return array [posts (collection), total number of posts]
     */
    protected function fetchThreadPostsPage(\XF\Entity\Thread $thread, $startNum, $perPage): array
    {
        $finder = $this->finder('XF:Post');
        $finder->where('thread_id', $thread->thread_id);
        $finder->where('message_state', 'visible');
        $finder->order('post_date', 'ASC');

        // Load Thread relationship with Forum for proper permission checks (needed for canEdit/canDelete)
        $finder->with(['Thread', 'Thread.Forum', 'Thread.Forum.Node']);

        // Load visitor's reaction if logged in (needed for isReactedTo check)
        $visitor = \XF::visitor();
        if ($visitor->user_id) {
            $finder->with(['Reactions|' . $visitor->user_id]);
        }

        // Offset should be startNum - 1 (since position 1 = offset 0)
        $finder->limit($perPage, $startNum - 1);

        $posts = $finder->fetch();
        $total = $finder->total();

        return [$posts, (int)$total];
    }

    /**
     * The app's post rows for a page of a thread.
     *
     * @param \XF\Entity\Thread $thread
     * @param \XF\Mvc\Entity\AbstractCollection $posts
     * @return array
     */
    protected function buildThreadPostRows(\XF\Entity\Thread $thread, $posts): array
    {
        $rows = [];
        foreach ($posts as $post) {
            // Respect XenForo's permission system
            if (!$post->canView()) {
                continue;
            }
            $rows[] = $this->buildThreadPostRow($thread, $post);
        }
        return $rows;
    }

    /**
     * One post as the app reads it (FCPost, plus fields added later).
     */
    protected function buildThreadPostRow(\XF\Entity\Thread $thread, \XF\Entity\Post $post): array
    {
        $user = $post->User;

        // Get canLike and isLiked flags
        $likeFlags = $this->getPostLikeFlags($post);

        $fcPost = new FCPost([
            'id' => (string)$post->post_id,
            'topicId' => (string)$post->thread_id,
            'authorId' => (string)$post->user_id,
            'authorName' => $user ? $user->username : 'Unknown',
            'authorUserType' => $user ? (string)$user->user_group_id : '0',
            'timestamp' => $post->post_date * 1000,
            'content' => $this->postContentForApp($post->message),
            'title' => $post->post_id === $thread->first_post_id ? $thread->title : '',
            'authorIconUrl' => $user ? $this->getAbsoluteUrl($user->getAvatarUrl('s')) : '',
            'canEdit' => $post->canEdit(),
            'canDelete' => $post->canDelete(),
            'canReport' => false,
            'canLike' => $likeFlags['canLike'],
            'isLiked' => $likeFlags['isLiked'],
            'likeCount' => $this->getReactionCount($post),
            'likesInfo' => $this->getPostLikesInfo($post),
            'isApproved' => $post->message_state === 'visible',
            'isFirstPost' => $post->post_id === $thread->first_post_id,
            // The post's number (floor) in the thread
            'position' => $this->getPostPosition($post),
            'attachments' => $this->getPostAttachments($post),
        ]);

        return $fcPost->toArray();
    }

    /**
     * A post's message for the app: always the BBCode, with image URLs
     * through the forum's image proxy.
     */
    protected function postContentForApp($message): string
    {
        $message = is_string($message) ? $message : '';
        return $this->processImageProxyInBbCode($message);
    }

    /**
     * The thread part of a thread page (the FCTopic fields of FCThreadResult).
     */
    protected function buildThreadTopicData(\XF\Entity\Thread $thread): array
    {
        $forum = $thread->Forum;
        $author = $thread->User;
        $firstPost = $thread->first_post_id ? $thread->FirstPost : null;
        $pollData = $this->buildPollDataForThread($thread);

        return [
            'id' => (string)$thread->thread_id,
            'title' => $thread->title,
            'forumId' => (string)$thread->node_id,
            'forumName' => ($forum && $forum->Node) ? $forum->Node->title : 'Unknown',
            'authorId' => (string)$thread->user_id,
            'authorName' => $author ? $author->username : 'Unknown',
            'authorUserType' => $author ? (string)$author->user_group_id : '0',
            'timestamp' => $thread->post_date * 1000,
            'prefix' => $this->getThreadPrefixLabel($thread),
            'authorIconUrl' => $author ? $this->getAbsoluteUrl($author->getAvatarUrl('m')) : '',
            'replyCount' => $thread->reply_count,
            'viewCount' => $thread->view_count,
            'hasNewPosts' => $thread->isUnread(),
            'isClosed' => $thread->discussion_state === 'closed',
            'isSubscribed' => $thread->isWatched(),
            'canSubscribe' => $thread->canWatch(),
            'url' => $this->buildLink('canonical:threads', $thread),
            'shortContent' => $firstPost ? $this->getShortContent($firstPost->message) : '',
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
            'likeCount' => $this->getReactionCount($firstPost),
            'hasPoll' => ($pollData !== null),
            'poll' => $pollData,
        ];
    }

    /**
     * What the thread page does once a page is shown: the thread is read up
     * to the last post shown (ThreadController::actionIndex).
     *
     * @param \XF\Entity\Thread $thread
     * @param \XF\Mvc\Entity\AbstractCollection $posts
     */
    protected function finishThreadView(\XF\Entity\Thread $thread, $posts)
    {
        $visitor = \XF::visitor();
        if (!$visitor->user_id || !$posts->count() || $this->request->isPrefetch()) {
            return;
        }

        $lastPostDate = 0;
        foreach ($posts as $post) {
            $lastPostDate = max($lastPostDate, (int)$post->post_date);
        }

        try {
            $this->repository('XF:Thread')->markThreadReadByVisitor($thread, $lastPostDate);
        } catch (\Exception $e) {
            // Silently fail if marking as read fails (e.g., add-on conflicts)
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
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        if (!is_array($responseIds) || empty($responseIds)) {
            return $this->apiError('responseIds is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = null;
            try {
                $thread = $this->assertViewableThread($topicId);
            } catch (\Exception $e) {
                return $this->apiException($e, 'Failed to get thread');
            }

            if (!$thread) {
                return $this->apiError('Thread not found', null, ErrorCode::NOT_FOUND);
            }

            $poll = null;
            try {
                $poll = $thread->Poll;
            } catch (\Exception $e) {
                $poll = null;
            }

            if (!$poll) {
                return $this->apiError('Poll not found', null, ErrorCode::NOT_FOUND);
            }

            $error = null;
            if (!$poll->canVote($error)) {
                $errorMessage = $error ? (string)$error : 'Cannot vote on this poll';
                return $this->apiError($errorMessage, null, ErrorCode::NO_PERMISSION);
            }

            // Each response once: the web form's checkboxes can't repeat one,
            // and a repeat failed the vote with a database error
            $responseIds = array_values(array_unique(array_map('intval', $responseIds)));

            $voter = $this->service('XF:Poll\Voter', $poll, $responseIds);
            if (!$voter->validate($errors)) {
                if (is_array($errors)) {
                    $errors = array_map('strval', $errors);
                    return $this->apiError(implode(', ', $errors), null, ErrorCode::VALIDATION);
                }
                return $this->apiError((string)$errors, null, ErrorCode::VALIDATION);
            }

            $voter->save();

            return $this->apiSuccess([
                'poll' => $this->buildPollDataForThread($thread),
            ]);
        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to vote on poll');
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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($fcParams->topicId);
            $visitor = \XF::visitor();

            if (!$thread->canReply($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's Thread Replier service (like Tapatalk does)
            /** @var \XF\Service\Thread\Replier $replier */
            $replier = $this->service('XF:Thread\Replier', $thread);
            $replier->setMessage($fcParams->textBody);

            // New uploads come as the upload hash (groupId), attached only
            // where the member may attach files, as ThreadController::
            // setupThreadReply does. attachmentIds is accepted and ignored:
            // XenForo attaches uploads by their hash alone.
            $groupId = (string)$fcParams->groupId;
            if ($groupId !== '' && $thread->Forum && $thread->Forum->canUploadAndManageAttachments()) {
                $replier->setAttachmentHash($groupId);
            }

            // XenForo's spam check (spam phrases, Akismet and the other
            // content checkers) for members who still need it, as
            // ThreadController::actionAddReply does before validating. It can
            // reject the reply or hold it for approval (state 1 below).
            $replier->checkForSpam();

            if (!$replier->validate($errors)) {
                return $this->apiFieldErrors($errors);
            }

            if ($floodError = $this->checkFlooding('post')) {
                return $floodError;
            }

            // Save reply post
            $post = $replier->save();

            // The follow-ups of ThreadController::finalizeThreadReply
            $replier->sendNotifications();

            $this->autoWatchThread($thread, false);

            // Mark thread as read for replier
            $this->repository('XF:Thread')->markThreadReadByVisitor($thread);

            // The reply is saved: these never fail the call
            try {
                // The reply draft the forum's editor keeps for this thread
                $thread->draft_reply->delete();

                // XenForo's "awaiting approval" notice for the member's session
                if ($post->message_state == 'moderated' && method_exists($this->session(), 'setHasContentPendingApproval')) {
                    $this->session()->setHasContentPendingApproval();
                }
            } catch (\Exception $e) {
                \XF::logException($e, false, 'ForumCopilot: reply follow-up failed: ');
            }

            // Always the raw message (BBCode)
            $postContent = $post->message;

            $result = new FCReplyPostResult(
                true,
                null,
                (string)$post->post_id,
                // 1 = held for moderator approval. This was $thread->canView(),
                // which is true for the author's own moderated reply, so the
                // app never heard that it was waiting for approval.
                $post->message_state === 'moderated' ? 1 : 0,
                $postContent,
                $post->canEdit(),
                $post->canDelete(),
                $post->canReport() // canReport
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to post reply');
        }
    }

    public function actionGetRawPost(ParameterBag $params)
    {
        $postId = $params->get('postId', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // XenForo's not-found and no-permission messages
            $post = $this->assertViewablePost((int)$postId);

            // As PostController::actionEdit: XenForo's reason (edit time
            // limit passed, thread closed, ...)
            if (!$post->canEdit($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
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

            // The forum new uploads go to, and XenForo's upload data for the
            // edit form (PostController::actionEdit): a fresh upload hash and
            // the size, type and count limits. Only where the member may
            // attach files, as on the website.
            $forumId = $post->Thread ? (string)$post->Thread->node_id : null;
            $attachmentData = null;
            try {
                $forum = $post->Thread ? $post->Thread->Forum : null;
                if ($forum && $forum->canUploadAndManageAttachments()) {
                    $editorData = $this->repository('XF:Attachment')->getEditorData('post', $post);
                    $attachmentData = [
                        'type' => $editorData['type'],
                        'hash' => $editorData['hash'],
                        'context' => (object)$editorData['context'],
                        'constraints' => (object)$editorData['constraints'],
                    ];
                }
            } catch (\Exception $e) {
                // Optional data: the edit form works without it
                \XF::logException($e, false, 'ForumCopilot: post editor data failed: ');
            }

            $result = new FCRawPostResult(
                true,
                null,
                $post->message,
                $threadTitle,
                $canEditTitle,
                $prefixId,
                $requirePrefix,
                $availablePrefixes,
                $attachments,
                $forumId,
                $attachmentData
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get raw post');
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
        $groupId = $params->get('groupId', '');

        if (empty($postId) || empty($postContent)) {
            return $this->apiError('Post ID and content are required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // XenForo's not-found and no-permission messages
            $post = $this->assertViewablePost((int)$postId);

            // As PostController::actionEdit: XenForo's reason (edit time
            // limit passed, thread closed, ...)
            if (!$post->canEdit($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's Post Editor service, set up as
            // PostController::setupPostEdit does
            /** @var \XF\Service\Post\Editor $editor */
            $editor = $this->service('XF:Post\Editor', $post);

            // Optional: a moderator's silent edit, which leaves no "last
            // edited" mark
            if ($this->isTrueParam($params->get('silent', false)) && $post->canEditSilently()) {
                $editor->logEdit(false);
            }

            $editor->setMessage($postContent);

            // New uploads come as the upload hash (groupId), attached only
            // where the member may attach files (PostController::setupPostEdit).
            // The post's existing attachments stay as they are; removals go
            // through removeAttachment. attachmentIds (the ids already on the
            // post) is accepted and ignored.
            $thread = $post->Thread;
            if (is_string($groupId) && $groupId !== ''
                && $thread && $thread->Forum && $thread->Forum->canUploadAndManageAttachments()
            ) {
                $editor->setAttachmentHash($groupId);
            }

            // Optional: alert the author that a moderator edited their post,
            // with `reason` as the alert's reason
            if ($this->isTrueParam($params->get('authorAlert', false)) && $post->canSendModeratorActionAlert()) {
                $editor->setSendAlert(true, is_string($reason) ? $reason : '');
            }

            // XenForo's spam check for members who still need it, right after
            // setup as PostController::actionEdit runs it
            $editor->checkForSpam();

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
                    /** @var \XF\Service\Thread\Editor $threadEditor */
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

            if (!$editor->validate($errors)) {
                return $this->apiFieldErrors($errors);
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
            return $this->apiException($e, 'Failed to update post');
        }
    }

    public function actionGetQuotePost(ParameterBag $params)
    {
        $postId = $params->get('postId', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $post = $this->assertViewablePost((int)$postId);

            // Only where the visitor may reply, as PostController::actionQuote
            if (!$post->Thread || !$post->Thread->canReply($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            // XenForo's quote (QuotePlugin::actionQuote): quotes inside the
            // post are left out and censored words replaced, then wrapped in
            // [QUOTE="name, post: id, member: id"], with the stored name for
            // a guest or deleted member
            $quote = $post->getQuoteWrapper(
                $this->app()->stringFormatter()->getBbCodeForQuote($post->message, 'post')
            );

            $result = new FCQuotePostResult(
                true,
                null,
                $quote
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get quote');
        }
    }

    public function actionReportPost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');
        $reason = $params->get('reason', '');
        $reason = is_string($reason) ? trim($reason) : '';

        if (empty($postId)) {
            return $this->apiError('Post ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $post = $this->assertViewablePost((int)$postId);

            if (!$post->canReport($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            // ReportPlugin::setupReportCreate's check and message
            if (!strlen($reason)) {
                return $this->apiError(\XF::phrase('please_enter_reason_for_reporting_this_message'), null, ErrorCode::VALIDATION);
            }

            // Use XenForo's Report Creator service, as ReportPlugin::actionReport
            /** @var \XF\Service\Report\Creator $creator */
            $creator = $this->service('XF:Report\Creator', 'post', $post);
            $creator->setMessage($reason);

            if (!$creator->validate($errors)) {
                return $this->apiFieldErrors($errors);
            }

            if ($floodError = $this->checkFlooding('report')) {
                return $floodError;
            }

            // Save report (this already includes the message as a comment)
            $creator->save();

            // Send notifications
            $creator->sendNotifications();

            $result = new FCReportPostResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to report post');
        }
    }

    /**
     * An optional bool param: true, 1, "1", "true", "yes" or "on".
     */
    protected function isTrueParam($value): bool
    {
        if (is_string($value)) {
            return in_array(strtolower(trim($value)), ['1', 'true', 'yes', 'on'], true);
        }
        return (bool)$value;
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

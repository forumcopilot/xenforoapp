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
    /**
     * Most posts one thread call returns. XenForo's own page is
     * messagesPerPage (20 by default); the app asks for 20.
     */
    const MAX_POSTS_PER_REQUEST = 100;

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

            // 1-based range, at most MAX_POSTS_PER_REQUEST posts
            $startNum = max(1, (int)$fcParams->startNum);
            $perPage = $this->clampPostsPerRequest((int)$fcParams->lastNum - $startNum + 1);
            [$posts, $total] = $this->fetchThreadPostsPage($thread, $startNum, $perPage);

            $result = new FCThreadResult(
                true,
                null,
                $total,
                $this->buildThreadPostRows($thread, $posts),
                $this->buildThreadTopicData($thread)
            );

            // A view is counted when the thread is opened at its start, not
            // for every further page the app loads while scrolling
            $this->finishThreadView($thread, $posts, $startNum <= 1);

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get thread');
        }
    }

    public function actionGetThreadByPost(ParameterBag $params)
    {
        $postId = $params->get('postId', '');
        $postsPerRequest = $this->clampPostsPerRequest($params->get('postsPerRequest', 20));

        if (empty($postId)) {
            return $this->apiError('Post ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $post = $this->assertViewablePost((int)$postId);
            $thread = $post->Thread;
            if (!$thread) {
                return $this->apiError(\XF::phrase('requested_thread_not_found'), null, ErrorCode::NOT_FOUND);
            }

            // The anchor's number in the thread, from XenForo's position
            // column (as ThreadPlugin::getPostLink finds its page); a hidden
            // post shares the number of the visible post before it. The page
            // has the anchor in the middle.
            $position = $this->getPostPosition($post);
            $startNum = max(1, $position - (int)floor($postsPerRequest / 2));
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

            $this->finishThreadView($thread, $posts, true);

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get thread by post');
        }
    }

    public function actionGetThreadByUnread(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $postsPerRequest = $this->clampPostsPerRequest($params->get('postsPerRequest', 20));

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

            // The first unread post, in XenForo's order for it
            // (PostRepository::findNextPostsInThread)
            $firstUnreadPost = null;
            if (!$isFullyRead) {
                // Only search for unread posts if thread is not fully read
                $finder = $this->finder('XF:Post');
                $finder->where('thread_id', $thread->thread_id);
                $finder->where('message_state', 'visible');
                $finder->where('post_date', '>', $readDate);
                $finder->order([['post_date', 'ASC'], ['post_id', 'ASC']]);
                // Not a post by a member the visitor ignores, as
                // ThreadController::actionUnread skips them
                if (method_exists($finder, 'skipIgnored')) {
                    $finder->skipIgnored();
                }

                $firstUnreadPost = $finder->fetchOne();
            }

            // Calculate position of first unread post
            $position = 1;
            $startNum = 1;

            if ($firstUnreadPost) {
                // Its number in the thread, from XenForo's position column
                $position = $this->getPostPosition($firstUnreadPost);

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

            $this->finishThreadView($thread, $posts, true);

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
        // XenForo's thread order (PostFinder::orderByDate), with the id last
        // so posts made in the same second keep their place across pages
        $finder->order([['position', 'ASC'], ['post_date', 'ASC'], ['post_id', 'ASC']]);

        $finder->with($this->getThreadPostListWith());

        // Offset should be startNum - 1 (since position 1 = offset 0)
        $finder->limit($perPage, $startNum - 1);

        $posts = $finder->fetch();
        $total = $finder->total();

        return [$posts, (int)$total];
    }

    /**
     * Relations loaded with a page of posts, as XenForo's thread page loads
     * them (the Post entity's "full" set): the author with profile and,
     * where online status is shown, activity; the visitor's own reaction.
     * Without them each post cost several queries.
     */
    protected function getThreadPostListWith(): array
    {
        // The thread and forum for the permission checks (canEdit, canDelete, ...)
        $with = ['Thread', 'Thread.Forum', 'Thread.Forum.Node', 'User', 'User.Profile'];

        $userRelations = $this->em()->getEntityStructure('XF:User')->relations;
        if ($this->options()->showMessageOnlineStatus && isset($userRelations['Activity'])) {
            $with[] = 'User.Activity';
        }

        $visitorId = \XF::visitor()->user_id;
        if ($visitorId) {
            // Needed for isReactedTo
            $with[] = 'Reactions|' . $visitorId;
        }

        return $with;
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
        if (!$posts->count()) {
            return [];
        }

        // Attachments for the whole page in one query, only for posts that
        // have some, as ThreadPlugin::fetchExtraContentForPostsFullView does
        $this->repository('XF:Attachment')->addAttachmentsToContent($posts, 'post');

        $context = [
            // XenForo shows online status beside messages only with this option on
            'showOnline' => (bool)$this->options()->showMessageOnlineStatus,
            'reactions' => $this->fetchReactionsForPosts($posts),
        ];

        $rows = [];
        foreach ($posts as $post) {
            // Respect XenForo's permission system
            if (!$post->canView()) {
                continue;
            }
            $rows[] = $this->buildThreadPostRow($thread, $post, $context);
        }
        return $rows;
    }

    /**
     * One post as the app reads it (FCPost, plus fields added later).
     *
     * @param array $context per-page values from buildThreadPostRows
     */
    protected function buildThreadPostRow(\XF\Entity\Thread $thread, \XF\Entity\Post $post, array $context = []): array
    {
        $user = $post->User;

        // Get canLike and isLiked flags
        $likeFlags = $this->getPostLikeFlags($post);
        $likeCount = $this->getReactionCount($post);
        if (!$likeCount) {
            $likesInfo = [];
        } elseif (isset($context['reactions'])) {
            $likesInfo = $this->getPostLikesInfo($post, $context['reactions'][$post->post_id] ?? []);
        } else {
            $likesInfo = $this->getPostLikesInfo($post);
        }

        $fcPost = new FCPost([
            'id' => (string)$post->post_id,
            'topicId' => (string)$post->thread_id,
            'authorId' => (string)$post->user_id,
            // The name stored with the post for guests and deleted members,
            // as XenForo shows it
            'authorName' => $user ? $user->username : ($post->username !== '' ? $post->username : 'Unknown'),
            'authorUserType' => $user ? (string)$user->user_group_id : '0',
            'timestamp' => $post->post_date * 1000,
            'content' => $this->postContentForApp($post->message),
            'title' => $post->post_id === $thread->first_post_id ? $thread->title : '',
            'authorIconUrl' => $user ? $this->getAbsoluteUrl($user->getAvatarUrl('s')) : '',
            'canEdit' => $post->canEdit(),
            'canDelete' => $post->canDelete(),
            // XenForo's check for the post's Report link (the member's
            // "report content" permission)
            'canReport' => $post->canReport(),
            'canLike' => $likeFlags['canLike'],
            'isLiked' => $likeFlags['isLiked'],
            'likeCount' => $likeCount,
            // Everyone who reacted: the app counts and finds the member's own
            // reaction in this list
            'likesInfo' => $likesInfo,
            'isApproved' => $post->message_state === 'visible',
            'isFirstPost' => $post->post_id === $thread->first_post_id,
            // The post's number (floor) in the thread
            'position' => $this->getPostPosition($post),
            'attachments' => $this->getPostAttachments($post),
        ]);

        $row = $fcPost->toArray();

        // The author's online dot, where the forum shows it and the author's
        // privacy allows (User::isOnline)
        $row['isAuthorOnline'] = !empty($context['showOnline']) && $user && $user->isOnline();

        // A member the visitor ignores: XenForo shows the post collapsed
        $row['isIgnored'] = $post->isIgnored();

        return $row;
    }

    /**
     * The reactions to a page of posts in one query, by post id, in the
     * order and with the relations of XenForo's "who reacted" list
     * (ReactionRepository::findContentReactions). Only posts with reactions
     * are looked up. Null when the batch could not be read: each post then
     * reads its own.
     *
     * @param \XF\Mvc\Entity\AbstractCollection $posts
     * @return array|null post id => ReactionContent[]
     */
    protected function fetchReactionsForPosts($posts): ?array
    {
        $postIds = [];
        foreach ($posts as $post) {
            if ($this->getReactionCount($post)) {
                $postIds[] = $post->post_id;
            }
        }
        if (!$postIds) {
            return [];
        }

        try {
            $byPost = [];
            $reactions = $this->repository('XF:Reaction')->findContentReactions('post', $postIds)->fetch();
            foreach ($reactions as $reaction) {
                $byPost[$reaction->content_id][] = $reaction;
            }
            return $byPost;
        } catch (\Exception $e) {
            \XF::logException($e, false, 'ForumCopilot: reactions for posts failed: ');
            return null;
        }
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
        $firstPostFlags = $firstPost
            ? $this->getPostLikeFlags($firstPost)
            : ['canLike' => false, 'isLiked' => false];

        // A redirect left behind when a thread was moved: XenForo's thread
        // page sends the visitor on to the target (RedirectHandler::
        // overrideDisplay). Its key is "thread-{target id}-{forum id}-"
        // (ThreadRedirectRepository::createThreadRedirectionDouble).
        $isMoved = false;
        $realTopicId = (string)$thread->thread_id;
        if ($thread->discussion_type === 'redirect') {
            $isMoved = true;
            $redirect = $thread->Redirect;
            if ($redirect && preg_match('/^thread-(\d+)-/', (string)$redirect->redirect_key, $match)) {
                $realTopicId = $match[1];
            }
        }

        return [
            'id' => (string)$thread->thread_id,
            'title' => $thread->title,
            'forumId' => (string)$thread->node_id,
            'forumName' => ($forum && $forum->Node) ? $forum->Node->title : 'Unknown',
            'authorId' => (string)$thread->user_id,
            'authorName' => $author ? $author->username : ($thread->username !== '' ? $thread->username : 'Unknown'),
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
            // Thread-level flags from the same checks as the first post's
            // links and the reply form
            'canReport' => \XF::visitor()->canReport(),
            'canUpload' => $forum ? $forum->canUploadAndManageAttachments() : false,
            'isBanned' => false,
            'isApproved' => $thread->discussion_state === 'visible',
            'isDeleted' => $thread->discussion_state === 'deleted',
            'isMoved' => $isMoved,
            'isMerged' => false,
            'realTopicId' => $realTopicId,
            'canLike' => $firstPostFlags['canLike'],
            'isLiked' => $firstPostFlags['isLiked'],
            'likeCount' => $this->getReactionCount($firstPost),
            'hasPoll' => ($pollData !== null),
            'poll' => $pollData,
        ];
    }

    /**
     * What XenForo's thread page does once a page is shown
     * (ThreadController::actionIndex): alerts about the posts shown are
     * marked read, the thread is read up to the last post shown, and the
     * view is counted. Best-effort: a failure here never fails the call.
     *
     * @param \XF\Entity\Thread $thread
     * @param \XF\Mvc\Entity\AbstractCollection $posts
     * @param bool $countView count a view of the thread (the first page
     *                        the app opens, not every page it loads)
     */
    protected function finishThreadView(\XF\Entity\Thread $thread, $posts, bool $countView = false)
    {
        $visitor = \XF::visitor();

        try {
            if ($visitor->user_id && $posts->count()) {
                // A member who reads the quoted or mentioned post here has
                // seen the alert about it
                $alertRepo = $this->repository('XF:UserAlert');
                if (method_exists($alertRepo, 'markUserAlertsReadForContent')) {
                    $alertRepo->markUserAlertsReadForContent('post', $posts->keys());
                }

                if (!$this->request->isPrefetch()) {
                    $lastPostDate = 0;
                    foreach ($posts as $post) {
                        $lastPostDate = max($lastPostDate, (int)$post->post_date);
                    }
                    $this->repository('XF:Thread')->markThreadReadByVisitor($thread, $lastPostDate);
                }
            }

            if ($countView && $this->isThreadViewCounted()) {
                $this->repository('XF:Thread')->logThreadView($thread);
            }
        } catch (\Exception $e) {
            \XF::logException($e, false, 'ForumCopilot: thread view follow-up failed: ');
        }
    }

    /**
     * Whether XenForo would count this view: not for prefetches, and for
     * guests and robots only as the "Count views" option says
     * (Controller::isContentViewCounted, XenForo 2.3).
     */
    protected function isThreadViewCounted(): bool
    {
        if (method_exists($this, 'isContentViewCounted')) {
            return $this->isContentViewCounted();
        }

        return !$this->request->isPrefetch();
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
     * Posts per thread call: a number from 1 to MAX_POSTS_PER_REQUEST.
     */
    protected function clampPostsPerRequest($perPage): int
    {
        return max(1, min(self::MAX_POSTS_PER_REQUEST, (int)$perPage));
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
     * The post's attachments as the app reads them (FCAttachment, plus
     * fields added later). The page's attachments are usually loaded in one
     * query beforehand (addAttachmentsToContent); a post without any costs
     * no query.
     *
     * @param \XF\Entity\Post $post The post entity
     * @return array attachment rows
     */
    protected function getPostAttachments($post)
    {
        $attachments = [];

        if (!$post->attach_count) {
            return $attachments;
        }

        try {
            $postAttachments = $post->Attachments;
            if (!$postAttachments || !$postAttachments->count()) {
                return $attachments;
            }

            // Full files need the thread's "view attachments" permission;
            // thumbnails are shown regardless, as on the website
            $error = null;
            $canViewUrl = $post->Thread ? $post->Thread->canViewAttachments($error) : false;

            foreach ($postAttachments as $attachment) {
                // Skip temporary/unassociated attachments
                if ($attachment->temp_hash || $attachment->unassociated) {
                    continue;
                }

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

                // The file's URL, only if the visitor may view it.
                // getDirectUrl (XenForo 2.3) is the direct file URL for videos
                // and audio and the attachment page for the rest.
                $url = '';
                if ($attachment->canView()) {
                    try {
                        $url = method_exists($attachment, 'getDirectUrl')
                            ? $this->getAbsoluteUrl($attachment->getDirectUrl(true))
                            : $this->buildLink('canonical:attachments', $attachment);
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

                // Check if attachment is embedded inline in the post
                $isInline = false;
                if (method_exists($post, 'isAttachmentEmbedded')) {
                    $isInline = $post->isAttachmentEmbedded($attachment->attachment_id);
                }

                $fcAttachment = new FCAttachment([
                    'id' => (string)$attachment->attachment_id,
                    'fileName' => $attachment->filename,
                    'fileSize' => (int)$attachment->file_size,
                    'mimeType' => $this->mimeTypeForExtension($data->extension),
                    'url' => $url,
                    'thumbnailUrl' => $thumbnailUrl,
                    'groupId' => $attachment->temp_hash ?: '',
                    'isImage' => $isImage,
                    'width' => $width,
                    'height' => $height,
                    'canViewUrl' => $canViewUrl,
                    'canViewThumbnailUrl' => (bool)$attachment->has_thumbnail,
                    'isInline' => $isInline,
                ]);

                $attachments[] = array_merge($fcAttachment->toArray(), $this->getAttachmentTypeFields($attachment));
            }
        } catch (\Exception $e) {
            // If attachment loading fails, log error and return empty array
            \XF::logException($e, false, 'ForumCopilot: Error loading post attachments: ');
        }

        return $attachments;
    }

    /**
     * Attachment fields the SDK reads (FCAttachment) from XenForo's own
     * getters: video, audio, type group and file-type icon. The getters
     * that a XenForo version doesn't have are left out.
     *
     * @param \XF\Entity\Attachment $attachment
     * @return array
     */
    protected function getAttachmentTypeFields($attachment): array
    {
        $fields = [
            'fileSizePrintable' => (string)\XF::language()->fileSizeFormat((int)$attachment->file_size),
        ];

        foreach (['isVideo' => 'is_video', 'isAudio' => 'is_audio'] as $field => $getter) {
            if ($attachment->isValidGetter($getter)) {
                $fields[$field] = (bool)$attachment->get($getter);
            }
        }
        foreach (['typeGrouping' => 'type_grouping', 'icon' => 'icon', 'iconName' => 'icon_name'] as $field => $getter) {
            if ($attachment->isValidGetter($getter)) {
                $value = $attachment->get($getter);
                // The SDK reads these as strings
                if (is_string($value) && $value !== '') {
                    $fields[$field] = $value;
                }
            }
        }

        return $fields;
    }
}

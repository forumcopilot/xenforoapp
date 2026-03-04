<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Reply Post Result
 * Maps from ReplyPostData_Output
 */
class FCReplyPostResult extends FCResult
{
    public $postId;
    public $state;
    public $postContent;
    public $canEdit;
    public $canDelete;
    public $canReport;

    public function __construct($result = true, $resultText = 'success', $postId = null, $state = 0, $postContent = null, $canEdit = false, $canDelete = false, $canReport = false)
    {
        parent::__construct($result, $resultText);
        $this->postId = $postId;
        $this->state = $state;
        $this->postContent = $postContent;
        $this->canEdit = $canEdit;
        $this->canDelete = $canDelete;
        $this->canReport = $canReport;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->postId !== null) $data['postId'] = $this->postId;
        $data['state'] = $this->state;
        if ($this->postContent !== null) $data['postContent'] = $this->postContent;
        $data['canEdit'] = $this->canEdit;
        $data['canDelete'] = $this->canDelete;
        $data['canReport'] = $this->canReport;
        return $data;
    }
}

/**
 * ForumCopilot Report Post Result
 * Maps from ReportPostData_Output
 */
class FCReportPostResult extends FCResult
{
    public function __construct($result = true, $resultText = 'success')
    {
        parent::__construct($result, $resultText);
    }

    public function toArray()
    {
        return parent::toArray();
    }
}

/**
 * ForumCopilot Quote Post Result
 * Maps from QuotePostData_Output
 */
class FCQuotePostResult extends FCResult
{
    public $quoteContent;

    public function __construct($result = true, $resultText = 'success', $quoteContent = null)
    {
        parent::__construct($result, $resultText);
        $this->quoteContent = $quoteContent;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->quoteContent !== null) $data['quoteContent'] = $this->quoteContent;
        return $data;
    }
}

/**
 * ForumCopilot Raw Post Result
 * Maps from RawPostData_Output
 */
class FCRawPostResult extends FCResult
{
    public $postContent;
    public $postTitle;
    public $canEditTitle;
    public $prefixId;
    public $requirePrefix;
    public $prefixes;
    public $attachments;

    public function __construct($result = true, $resultText = 'success', $postContent = null, $postTitle = null, $canEditTitle = false, $prefixId = null, $requirePrefix = false, $prefixes = [], $attachments = [])
    {
        parent::__construct($result, $resultText);
        $this->postContent = $postContent;
        $this->postTitle = $postTitle;
        $this->canEditTitle = $canEditTitle;
        $this->prefixId = $prefixId;
        $this->requirePrefix = $requirePrefix;
        $this->prefixes = $prefixes;
        $this->attachments = $attachments;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->postContent !== null) $data['postContent'] = $this->postContent;
        if ($this->postTitle !== null) $data['postTitle'] = $this->postTitle;
        $data['canEditTitle'] = $this->canEditTitle;
        // Always include prefixId, even if null
        $data['prefixId'] = $this->prefixId;
        $data['requirePrefix'] = $this->requirePrefix;
        if (!empty($this->prefixes)) {
            $data['prefixes'] = array_map(function($prefix) {
                return is_object($prefix) ? $prefix->toArray() : $prefix;
            }, $this->prefixes);
        } else {
            $data['prefixes'] = [];
        }
        // Convert attachments to arrays if they are FCAttachment objects
        $attachmentsArray = [];
        if (is_array($this->attachments)) {
            foreach ($this->attachments as $attachment) {
                if (is_object($attachment) && method_exists($attachment, 'toArray')) {
                    $attachmentsArray[] = $attachment->toArray();
                } else {
                    $attachmentsArray[] = $attachment;
                }
            }
        }
        $data['attachments'] = $attachmentsArray;
        return $data;
    }
}

/**
 * ForumCopilot Save Raw Post Result
 * Maps from SaveRawPostData_Output
 */
class FCSaveRawPostResult extends FCResult
{
    public $postContent;

    public function __construct($result = true, $resultText = 'success', $postContent = null)
    {
        parent::__construct($result, $resultText);
        $this->postContent = $postContent;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->postContent !== null) $data['postContent'] = $this->postContent;
        return $data;
    }
}

/**
 * ForumCopilot Thread Result
 * Maps from ThreadData_Output
 * Contains all FCTopic properties plus posts array
 */
class FCThreadResult extends FCResult
{
    // FCTopic properties
    public $id;
    public $title;
    public $forumId;
    public $forumName;
    public $authorId;
    public $authorName;
    public $authorUserType;
    public $timestamp;
    public $prefix;
    public $authorIconUrl;
    public $replyCount;
    public $viewCount;
    public $hasNewPosts;
    public $isClosed;
    public $isSubscribed;
    public $canSubscribe;
    public $url;
    public $shortContent;
    public $participatedUserIds;
    public $isPinned;
    public $isAnnouncement;
    public $isStickySource;
    public $canRename;
    public $canDelete;
    public $canClose;
    public $canApprove;
    public $canStick;
    public $canMove;
    public $canMerge;
    public $canBan;
    public $canReply;
    public $canReport;
    public $canUpload;
    public $isBanned;
    public $isApproved;
    public $isDeleted;
    public $isMoved;
    public $isMerged;
    public $realTopicId;
    public $canLike;
    public $isLiked;
    public $likeCount;
    public $hasPoll;
    public $poll;

    // Thread-specific properties
    public $totalPostNum;
    public $posts;

    public function __construct($result = true, $resultText = 'success', $totalPostNum = 0, $posts = [], $topicData = [])
    {
        parent::__construct($result, $resultText);
        $this->totalPostNum = $totalPostNum;
        $this->posts = $posts;
        
        // Set all topic properties from $topicData
        if (is_array($topicData)) {
            foreach ($topicData as $key => $value) {
                if (property_exists($this, $key)) {
                    $this->$key = $value;
                }
            }
        }
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalPostNum'] = $this->totalPostNum;
        $data['posts'] = array_map(function($post) {
            return is_object($post) ? $post->toArray() : $post;
        }, $this->posts);
        
        // Add all topic properties (include hasPoll and poll for thread responses)
        $topicProps = ['id', 'title', 'forumId', 'forumName', 'authorId', 'authorName', 'authorUserType',
                      'timestamp', 'prefix', 'authorIconUrl', 'replyCount', 'viewCount', 'hasNewPosts',
                      'isClosed', 'isSubscribed', 'canSubscribe', 'url', 'shortContent', 'participatedUserIds',
                      'isPinned', 'isAnnouncement', 'isStickySource', 'canRename', 'canDelete', 'canClose',
                      'canApprove', 'canStick', 'canMove', 'canMerge', 'canBan', 'canReply', 'canReport',
                      'canUpload', 'isBanned', 'isApproved', 'isDeleted', 'isMoved', 'isMerged', 'realTopicId',
                      'canLike', 'isLiked', 'likeCount', 'hasPoll', 'poll'];

        foreach ($topicProps as $prop) {
            if (property_exists($this, $prop)) {
                $data[$prop] = $this->$prop;
            }
        }
        $data['hasPoll'] = $this->hasPoll ?? false;
        $data['poll'] = $this->poll;

        return $data;
    }
}

/**
 * ForumCopilot Thread By Post Result
 * Maps from ThreadByPostData_Output
 */
class FCThreadByPostResult extends FCThreadResult
{
    public $canReply;
    public $canReport;
    public $canUpload;
    public $position;

    public function __construct($result = true, $resultText = 'success', $totalPostNum = 0, $canReply = false, $canReport = false, $canUpload = false, $posts = [], $position = 1, $topicData = [])
    {
        parent::__construct($result, $resultText, $totalPostNum, $posts, $topicData);
        $this->canReply = $canReply;
        $this->canReport = $canReport;
        $this->canUpload = $canUpload;
        $this->position = $position;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['canReply'] = $this->canReply;
        $data['canReport'] = $this->canReport;
        $data['canUpload'] = $this->canUpload;
        $data['position'] = $this->position;
        return $data;
    }
}

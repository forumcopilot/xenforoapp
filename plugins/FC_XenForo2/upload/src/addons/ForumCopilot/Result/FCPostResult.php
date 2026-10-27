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
    /** @var string|null the forum new uploads go to */
    public $forumId;
    /** @var array|null upload hash, context and limits for new uploads */
    public $attachmentData;

    public function __construct($result = true, $resultText = 'success', $postContent = null, $postTitle = null, $canEditTitle = false, $prefixId = null, $requirePrefix = false, $prefixes = [], $attachments = [], $forumId = null, $attachmentData = null)
    {
        parent::__construct($result, $resultText);
        $this->forumId = $forumId;
        $this->attachmentData = $attachmentData;
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
        if ($this->forumId !== null) $data['forumId'] = $this->forumId;
        if ($this->attachmentData !== null) $data['attachmentData'] = $this->attachmentData;
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

// FCThreadResult and FCThreadByPostResult live in their own files
// (FCThreadResult.php, FCThreadByPostResult.php), loaded by the autoloader.

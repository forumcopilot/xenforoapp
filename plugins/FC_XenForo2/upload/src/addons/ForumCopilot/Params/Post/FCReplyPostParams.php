<?php

namespace ForumCopilot\Params\Post;

/**
 * Parameters for replyPost API method
 * Forum-agnostic parameter class for replying to posts
 */
class FCReplyPostParams
{
    /** @var string Topic ID to reply to */
    public $topicId;
    
    /** @var string Reply content */
    public $textBody;
    
    /** @var array List of attachment IDs */
    public $attachmentIds;
    
    /** @var string|null Group ID for permissions */
    public $groupId;
    
    /** @var string|null Post ID to quote */
    public $quotePostId;

    public function __construct($topicId = '', $textBody = '', $attachmentIds = [], $groupId = null, $quotePostId = null)
    {
        $this->topicId = $topicId;
        $this->textBody = $textBody;
        $this->attachmentIds = $attachmentIds;
        $this->groupId = $groupId;
        $this->quotePostId = $quotePostId;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['topicId'] ?? '',
            $data['textBody'] ?? '',
            $data['attachmentIds'] ?? [],
            $data['groupId'] ?? null,
            $data['quotePostId'] ?? null
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->topicId)) {
            $errors[] = 'topicId is required';
        }
        
        if (empty($this->textBody)) {
            $errors[] = 'textBody is required';
        }
        
        if (!is_array($this->attachmentIds)) {
            $errors[] = 'attachmentIds must be array';
        }
        
        if ($this->groupId !== null && !is_string($this->groupId)) {
            $errors[] = 'groupId must be string or null';
        }
        
        if ($this->quotePostId !== null && !is_string($this->quotePostId)) {
            $errors[] = 'quotePostId must be string or null';
        }
        
        return $errors;
    }
}

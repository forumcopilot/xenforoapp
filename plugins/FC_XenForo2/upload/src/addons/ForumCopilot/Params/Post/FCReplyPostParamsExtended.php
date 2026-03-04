<?php

namespace ForumCopilot\Params\Post;

/**
 * Parameters for replyPost API method (extended version)
 * Forum-agnostic parameter class for replying to posts with additional fields
 */
class FCReplyPostParamsExtended
{
    /** @var string Forum ID */
    public $forumId;
    
    /** @var string Topic ID to reply to */
    public $topicId;
    
    /** @var string Reply subject */
    public $subject;
    
    /** @var string Reply content */
    public $textBody;
    
    /** @var array List of attachment IDs */
    public $attachmentIds;
    
    /** @var string Group ID for permissions */
    public $groupId;
    
    /** @var bool Whether to return HTML content */
    public $returnHtml;

    public function __construct($forumId = '', $topicId = '', $subject = '', $textBody = '', $attachmentIds = [], $groupId = '', $returnHtml = true)
    {
        $this->forumId = $forumId;
        $this->topicId = $topicId;
        $this->subject = $subject;
        $this->textBody = $textBody;
        $this->attachmentIds = $attachmentIds;
        $this->groupId = $groupId;
        $this->returnHtml = $returnHtml;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['forumId'] ?? '',
            $data['topicId'] ?? '',
            $data['subject'] ?? '',
            $data['textBody'] ?? '',
            $data['attachmentIds'] ?? [],
            $data['groupId'] ?? '',
            $data['returnHtml'] ?? true
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->forumId)) {
            $errors[] = 'forumId is required';
        }
        
        if (empty($this->topicId)) {
            $errors[] = 'topicId is required';
        }
        
        if (empty($this->textBody)) {
            $errors[] = 'textBody is required';
        }
        
        if (!is_array($this->attachmentIds)) {
            $errors[] = 'attachmentIds must be array';
        }
        
        if (!is_string($this->groupId)) {
            $errors[] = 'groupId must be string';
        }
        
        if (!is_bool($this->returnHtml)) {
            $errors[] = 'returnHtml must be boolean';
        }
        
        return $errors;
    }
}

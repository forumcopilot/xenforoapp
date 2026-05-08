<?php

namespace ForumCopilot\Params\Moderation;

/**
 * Parameters for moderation operations on posts
 * Forum-agnostic parameter class for post moderation operations
 */
class FCModeratePostParams
{
    /** @var string Post ID to moderate */
    public $postId;
    
    /** @var string Action to perform (delete, undelete, approve, etc.) */
    public $action;

    public function __construct($postId = '', $action = '')
    {
        $this->postId = $postId;
        $this->action = $action;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['postId'] ?? '',
            $data['action'] ?? ''
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->postId)) {
            $errors[] = 'postId is required';
        }
        
        if (empty($this->action)) {
            $errors[] = 'action is required';
        }
        
        $validActions = ['delete', 'undelete', 'approve', 'move'];
        if (!in_array($this->action, $validActions)) {
            $errors[] = 'action must be one of: ' . implode(', ', $validActions);
        }
        
        return $errors;
    }
}

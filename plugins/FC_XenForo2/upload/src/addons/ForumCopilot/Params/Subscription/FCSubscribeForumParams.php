<?php

namespace ForumCopilot\Params\Subscription;

/**
 * Parameters for subscribeForum API method
 * Forum-agnostic parameter class for forum subscription operations
 */
class FCSubscribeForumParams
{
    /** @var string Forum ID to subscribe/unsubscribe */
    public $forumId;
    
    /** @var bool Whether to subscribe (true) or unsubscribe (false) */
    public $subscribe;

    public function __construct($forumId = '', $subscribe = true)
    {
        $this->forumId = $forumId;
        $this->subscribe = $subscribe;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['forumId'] ?? '',
            $data['subscribe'] ?? true
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
        
        if (!is_bool($this->subscribe)) {
            $errors[] = 'subscribe must be boolean';
        }
        
        return $errors;
    }
}

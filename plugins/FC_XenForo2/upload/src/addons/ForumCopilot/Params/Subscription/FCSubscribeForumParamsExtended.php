<?php

namespace ForumCopilot\Params\Subscription;

/**
 * Parameters for subscribeForum API method (extended version)
 * Forum-agnostic parameter class for forum subscription operations with mode
 */
class FCSubscribeForumParamsExtended
{
    /** @var string Forum ID to subscribe/unsubscribe */
    public $forumId;
    
    /** @var int Subscribe mode: 0 = no email (alerts only), 1 = instant email, 2 = daily digest, 3 = weekly digest */
    public $subscribeMode;

    public function __construct($forumId = '', $subscribeMode = 0)
    {
        $this->forumId = $forumId;
        $this->subscribeMode = $subscribeMode;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['forumId'] ?? '',
            $data['subscribeMode'] ?? 0
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
        
        // subscribeMode: 0 = no email (alerts only), 1 = instant email, 2 = daily digest, 3 = weekly digest
        // All values are valid, but 2 and 3 may not be fully supported by all forums
        if (!is_numeric($this->subscribeMode) || $this->subscribeMode < 0 || $this->subscribeMode > 3) {
            $errors[] = 'subscribeMode must be between 0 and 3';
        }
        
        return $errors;
    }
}

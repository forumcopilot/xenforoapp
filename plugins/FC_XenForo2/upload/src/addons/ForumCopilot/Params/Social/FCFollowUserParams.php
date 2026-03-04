<?php

namespace ForumCopilot\Params\Social;

/**
 * Parameters for follow/unfollow API methods
 * Forum-agnostic parameter class for user following operations
 */
class FCFollowUserParams
{
    /** @var string User ID to follow/unfollow */
    public $userId;
    
    /** @var bool Whether to follow (true) or unfollow (false) */
    public $follow;

    public function __construct($userId = '', $follow = true)
    {
        $this->userId = $userId;
        $this->follow = $follow;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['userId'] ?? '',
            $data['follow'] ?? true
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->userId)) {
            $errors[] = 'userId is required';
        }
        
        if (!is_bool($this->follow)) {
            $errors[] = 'follow must be boolean';
        }
        
        return $errors;
    }
}

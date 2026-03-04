<?php

namespace ForumCopilot\Params\Social;

/**
 * Parameters for likePost API method
 * Forum-agnostic parameter class for post liking operations
 */
class FCLikePostParams
{
    /** @var string Post ID to like */
    public $postId;
    
    /** @var bool Whether to like (true) or unlike (false) */
    public $like;

    public function __construct($postId = '', $like = true)
    {
        $this->postId = $postId;
        $this->like = $like;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['postId'] ?? '',
            $data['like'] ?? true
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
        
        if (!is_bool($this->like)) {
            $errors[] = 'like must be boolean';
        }
        
        return $errors;
    }
}

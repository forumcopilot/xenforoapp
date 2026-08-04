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

    /**
     * @var int Reaction id to apply. Defaults to 1 (XenForo's built-in "Like"),
     * so older app builds that don't send a reactionId keep their exact
     * previous behavior. Newer builds pass the reaction the user picked.
     */
    public $reactionId;

    public function __construct($postId = '', $like = true, $reactionId = 1)
    {
        $this->postId = $postId;
        $this->like = $like;
        $this->reactionId = $reactionId;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        $reactionId = isset($data['reactionId']) ? (int) $data['reactionId'] : 1;
        if ($reactionId < 1) {
            $reactionId = 1;
        }
        return new self(
            $data['postId'] ?? '',
            $data['like'] ?? true,
            $reactionId
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

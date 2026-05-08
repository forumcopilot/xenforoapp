<?php

namespace ForumCopilot\Params\Forum;

/**
 * Parameters for getForumStatus API method
 * Forum-agnostic parameter class for getting forum status
 */
class FCGetForumStatusParams
{
    /** @var array List of forum IDs to check status for */
    public $forumIds;

    public function __construct($forumIds = [])
    {
        $this->forumIds = $forumIds;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self($data['forumIds'] ?? []);
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (!is_array($this->forumIds)) {
            $errors[] = 'forumIds must be array';
        }
        
        return $errors;
    }
}

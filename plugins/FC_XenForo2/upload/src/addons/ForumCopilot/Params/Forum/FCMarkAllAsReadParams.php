<?php

namespace ForumCopilot\Params\Forum;

/**
 * Parameters for markAllAsRead API method
 * Forum-agnostic parameter class for marking forums as read
 */
class FCMarkAllAsReadParams
{
    /** @var string|null Specific forum ID to mark as read (null for all forums) */
    public $forumId;
    
    /** @var int|null Unix timestamp to mark the forum read to. If not specified, defaults to current time. */
    public $date;

    public function __construct($forumId = null, $date = null)
    {
        $this->forumId = $forumId;
        $this->date = $date;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['forumId'] ?? null,
            isset($data['date']) ? (int)$data['date'] : null
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if ($this->forumId !== null && !is_string($this->forumId)) {
            $errors[] = 'forumId must be string or null';
        }
        
        if ($this->date !== null && (!is_int($this->date) || $this->date < 0)) {
            $errors[] = 'date must be a positive integer (Unix timestamp)';
        }
        
        return $errors;
    }
}

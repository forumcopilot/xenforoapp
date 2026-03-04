<?php

namespace ForumCopilot\Params\Topic;

/**
 * Parameters for getTopic API method
 * Forum-agnostic parameter class for topic retrieval operations
 */
class FCGetTopicParams
{
    /** @var string Forum ID to get topics from */
    public $forumId;
    
    /** @var int Starting position for pagination */
    public $startNum;
    
    /** @var int Ending position for pagination */
    public $lastNum;

    public function __construct($forumId = '', $startNum = 0, $lastNum = 19)
    {
        $this->forumId = $forumId;
        $this->startNum = $startNum;
        $this->lastNum = $lastNum;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['forumId'] ?? '',
            $data['startNum'] ?? 0,
            $data['lastNum'] ?? 19
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
        
        if (!is_numeric($this->startNum) || $this->startNum < 0) {
            $errors[] = 'startNum must be non-negative integer';
        }
        
        if (!is_numeric($this->lastNum) || $this->lastNum < $this->startNum) {
            $errors[] = 'lastNum must be integer >= startNum';
        }
        
        return $errors;
    }
}

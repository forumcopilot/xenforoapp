<?php

namespace ForumCopilot\Params\Post;

/**
 * Parameters for getThread API method
 * Forum-agnostic parameter class for thread retrieval operations
 */
class FCGetThreadParams
{
    /** @var string Topic/thread ID */
    public $topicId;
    
    /** @var int Starting position for pagination */
    public $startNum;
    
    /** @var int Ending position for pagination */
    public $lastNum;
    
    /** @var bool Whether to return HTML content */
    public $returnHtml;

    /**
     * @var bool Optional (1.11.0): also the moderated and deleted posts the
     *           visitor may see, and the member's own posts awaiting approval,
     *           as XenForo's thread page shows them. Off by default.
     */
    public $includeHidden;

    public function __construct($topicId = '', $startNum = 0, $lastNum = 19, $returnHtml = true, $includeHidden = false)
    {
        $this->topicId = $topicId;
        $this->startNum = $startNum;
        $this->lastNum = $lastNum;
        $this->returnHtml = $returnHtml;
        $this->includeHidden = (bool)$includeHidden;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['topicId'] ?? '',
            $data['startNum'] ?? 0,
            $data['lastNum'] ?? 19,
            $data['returnHtml'] ?? true,
            $data['includeHidden'] ?? false
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->topicId)) {
            $errors[] = 'topicId is required';
        }
        
        if (!is_numeric($this->startNum) || $this->startNum < 0) {
            $errors[] = 'startNum must be non-negative integer';
        }
        
        if (!is_numeric($this->lastNum) || $this->lastNum < $this->startNum) {
            $errors[] = 'lastNum must be integer >= startNum';
        }
        
        if (!is_bool($this->returnHtml)) {
            $errors[] = 'returnHtml must be boolean';
        }
        
        return $errors;
    }
}

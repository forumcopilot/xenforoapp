<?php

namespace ForumCopilot\Params\Search;

/**
 * Parameters for searchTopic API method
 * Forum-agnostic parameter class for topic search operations
 */
class FCSearchTopicParams
{
    /** @var string Search string */
    public $searchString;
    
    /** @var int Starting position for pagination */
    public $startNum;
    
    /** @var int Ending position for pagination */
    public $lastNum;
    
    /** @var string Search ID for advanced searches */
    public $searchId;

    public function __construct($searchString = '', $startNum = 0, $lastNum = 19, $searchId = '')
    {
        $this->searchString = $searchString;
        $this->startNum = $startNum;
        $this->lastNum = $lastNum;
        $this->searchId = $searchId;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['searchString'] ?? '',
            $data['startNum'] ?? 0,
            $data['lastNum'] ?? 19,
            $data['searchId'] ?? ''
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->searchString)) {
            $errors[] = 'searchString is required';
        }
        
        if (!is_numeric($this->startNum) || $this->startNum < 0) {
            $errors[] = 'startNum must be non-negative integer';
        }
        
        if (!is_numeric($this->lastNum) || $this->lastNum < $this->startNum) {
            $errors[] = 'lastNum must be integer >= startNum';
        }
        
        if (!is_string($this->searchId)) {
            $errors[] = 'searchId must be string';
        }
        
        return $errors;
    }
}

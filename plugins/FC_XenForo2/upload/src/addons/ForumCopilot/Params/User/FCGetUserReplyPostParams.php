<?php

namespace ForumCopilot\Params\User;

/**
 * Parameters for getUserReplyPost API method
 * Forum-agnostic parameter class for user reply post retrieval
 */
class FCGetUserReplyPostParams
{
    /** @var int Start number (for pagination) */
    public $startNum;
    
    /** @var int Last number (for pagination) */
    public $lastNum;
    
    /** @var string Search ID (optional) */
    public $searchId;
    
    /** @var string Username to get replies for */
    public $username;
    
    /** @var string User ID to get replies for */
    public $userId;

    public function __construct($startNum = 0, $lastNum = 10, $searchId = '', $username = '', $userId = '')
    {
        $this->startNum = $startNum;
        $this->lastNum = $lastNum;
        $this->searchId = $searchId;
        $this->username = $username;
        $this->userId = $userId;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['startNum'] ?? 0,
            $data['lastNum'] ?? 10,
            $data['searchId'] ?? '',
            $data['username'] ?? '',
            $data['userId'] ?? ''
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->username) && empty($this->userId)) {
            $errors[] = 'Either username or userId is required';
        }
        
        if (!is_int($this->startNum) && !is_numeric($this->startNum)) {
            $errors[] = 'startNum must be integer';
        }
        
        if (!is_int($this->lastNum) && !is_numeric($this->lastNum)) {
            $errors[] = 'lastNum must be integer';
        }
        
        return $errors;
    }
}


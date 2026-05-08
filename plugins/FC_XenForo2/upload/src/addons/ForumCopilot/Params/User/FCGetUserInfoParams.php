<?php

namespace ForumCopilot\Params\User;

/**
 * Parameters for getUserInfo API method
 * Forum-agnostic parameter class for user information retrieval
 */
class FCGetUserInfoParams
{
    /** @var string Username to get info for */
    public $username;
    
    /** @var string User ID to get info for */
    public $userId;

    public function __construct($username = '', $userId = '')
    {
        $this->username = $username;
        $this->userId = $userId;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
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
        
        if (!is_string($this->username)) {
            $errors[] = 'username must be string';
        }
        
        if (!is_string($this->userId)) {
            $errors[] = 'userId must be string';
        }
        
        return $errors;
    }
}

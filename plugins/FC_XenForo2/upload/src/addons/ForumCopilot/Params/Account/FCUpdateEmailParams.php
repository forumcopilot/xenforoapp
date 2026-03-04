<?php

namespace ForumCopilot\Params\Account;

/**
 * Parameters for updateEmail API method
 * Forum-agnostic parameter class for email updates
 */
class FCUpdateEmailParams
{
    /** @var string New email address */
    public $newEmail;
    
    /** @var string Current password for verification */
    public $password;

    public function __construct($newEmail = '', $password = '')
    {
        $this->newEmail = $newEmail;
        $this->password = $password;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['newEmail'] ?? '',
            $data['password'] ?? ''
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->newEmail)) {
            $errors[] = 'newEmail is required';
        }
        
        if (!filter_var($this->newEmail, FILTER_VALIDATE_EMAIL)) {
            $errors[] = 'newEmail must be a valid email address';
        }
        
        if (empty($this->password)) {
            $errors[] = 'password is required for verification';
        }
        
        return $errors;
    }
}

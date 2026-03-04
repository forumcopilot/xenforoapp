<?php

namespace ForumCopilot\Params\Account;

/**
 * Parameters for updateProfile API method
 * Forum-agnostic parameter class for profile updates
 */
class FCUpdateProfileParams
{
    /** @var array Profile fields to update */
    public $profileFields;

    public function __construct($profileFields = [])
    {
        $this->profileFields = $profileFields;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self($data['profileFields'] ?? []);
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (!is_array($this->profileFields)) {
            $errors[] = 'profileFields must be array';
        }
        
        if (empty($this->profileFields)) {
            $errors[] = 'profileFields cannot be empty';
        }
        
        return $errors;
    }
}

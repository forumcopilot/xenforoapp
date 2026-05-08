<?php

namespace ForumCopilot\Params\Account;

/**
 * Parameters for updatePassword API method
 * Forum-agnostic parameter class for password updates
 */
class FCUpdatePasswordParams
{
    /** @var string Current password */
    public $currentPassword;
    
    /** @var string New password */
    public $newPassword;
    
    /** @var string Confirm new password */
    public $confirmPassword;

    public function __construct($currentPassword = '', $newPassword = '', $confirmPassword = '')
    {
        $this->currentPassword = $currentPassword;
        $this->newPassword = $newPassword;
        $this->confirmPassword = $confirmPassword;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['currentPassword'] ?? '',
            $data['newPassword'] ?? '',
            $data['confirmPassword'] ?? ''
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->currentPassword)) {
            $errors[] = 'currentPassword is required';
        }
        
        if (empty($this->newPassword)) {
            $errors[] = 'newPassword is required';
        }
        
        if (empty($this->confirmPassword)) {
            $errors[] = 'confirmPassword is required';
        }
        
        if ($this->newPassword !== $this->confirmPassword) {
            $errors[] = 'newPassword and confirmPassword must match';
        }
        
        if (strlen($this->newPassword) < 6) {
            $errors[] = 'newPassword must be at least 6 characters';
        }
        
        return $errors;
    }
}

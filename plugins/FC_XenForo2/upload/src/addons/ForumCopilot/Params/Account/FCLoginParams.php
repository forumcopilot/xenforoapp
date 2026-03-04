<?php

namespace ForumCopilot\Params\Account;

/**
 * Parameters for login API method
 * Forum-agnostic parameter class for user authentication
 */
class FCLoginParams
{
    /** @var string Username or email for login */
    public $loginname;
    
    /** @var string User password */
    public $password;
    
    /** @var bool Whether to login as anonymous user */
    public $anonymous;
    
    /** @var string|null Trust code for two-factor authentication */
    public $trustCode;
    
    /** @var string|null Two-factor authentication code */
    public $tfaCode;
    
    /** @var string|null TFA provider ID (totp, email, backup) */
    public $tfaProvider;
    
    /** @var bool Whether to trust this device for 45 days */
    public $trustDevice;

    /** @var bool Whether to create XenForo remember cookie */
    public $remember;

    public function __construct($loginname = '', $password = '', $anonymous = false, $trustCode = null, $tfaCode = null, $tfaProvider = null, $trustDevice = false, $remember = true)
    {
        $this->loginname = $loginname;
        $this->password = $password;
        $this->anonymous = $anonymous;
        $this->trustCode = $trustCode;
        $this->tfaCode = $tfaCode;
        $this->tfaProvider = $tfaProvider;
        $this->trustDevice = $trustDevice;
        $this->remember = $remember;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['loginname'] ?? '',
            $data['password'] ?? '',
            self::toBool($data['anonymous'] ?? false),
            $data['trustCode'] ?? null,
            $data['tfaCode'] ?? null,
            $data['tfaProvider'] ?? null,
            self::toBool($data['trustDevice'] ?? false),
            self::toBool($data['remember'] ?? true)
        );
    }

    /**
     * Convert string/boolean to boolean
     */
    private static function toBool($value): bool
    {
        if (is_bool($value)) {
            return $value;
        }
        if (is_string($value)) {
            return in_array(strtolower($value), ['true', '1', 'yes', 'on'], true);
        }
        return (bool)$value;
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        // Convert to proper types if needed
        $this->anonymous = self::toBool($this->anonymous);
        
        if (empty($this->loginname)) {
            $errors[] = 'loginname is required';
        }
        
        if (empty($this->password)) {
            $errors[] = 'password is required';
        }
        
        if (!is_bool($this->anonymous)) {
            $errors[] = 'anonymous must be boolean';
        }
        
        if ($this->trustCode !== null && !is_string($this->trustCode)) {
            $errors[] = 'trustCode must be string or null';
        }
        
        if ($this->tfaCode !== null && !is_string($this->tfaCode)) {
            $errors[] = 'tfaCode must be string or null';
        }
        
        if ($this->tfaProvider !== null && !is_string($this->tfaProvider)) {
            $errors[] = 'tfaProvider must be string or null';
        }
        
        if (!is_bool($this->trustDevice)) {
            $this->trustDevice = self::toBool($this->trustDevice);
        }

        if (!is_bool($this->remember)) {
            $this->remember = self::toBool($this->remember);
        }
        
        return $errors;
    }
}

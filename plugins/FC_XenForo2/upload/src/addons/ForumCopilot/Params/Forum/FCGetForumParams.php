<?php

namespace ForumCopilot\Params\Forum;

/**
 * Parameters for getForum API method
 * Forum-agnostic parameter class for forum retrieval operations
 */
class FCGetForumParams
{
    /** @var bool Whether to return forum descriptions */
    public $returnDescription;
    
    /** @var string Specific forum ID to retrieve (empty for all forums) */
    public $forumId;

    public function __construct($returnDescription = true, $forumId = '')
    {
        $this->returnDescription = $returnDescription;
        $this->forumId = $forumId;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            self::toBool($data['returnDescription'] ?? true),
            $data['forumId'] ?? ''
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
        $this->returnDescription = self::toBool($this->returnDescription);
        
        if (!is_bool($this->returnDescription)) {
            $errors[] = 'returnDescription must be boolean';
        }
        
        if (!is_string($this->forumId)) {
            $errors[] = 'forumId must be string';
        }
        
        return $errors;
    }
}

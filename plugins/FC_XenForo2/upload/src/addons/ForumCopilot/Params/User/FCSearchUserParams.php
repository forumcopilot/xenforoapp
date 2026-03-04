<?php

namespace ForumCopilot\Params\User;

/**
 * Parameters for searchUser API method
 * Forum-agnostic parameter class for user search operations
 */
class FCSearchUserParams
{
    /** @var string Search keywords */
    public $keywords;
    
    /** @var int Page number for pagination */
    public $page;
    
    /** @var int Results per page */
    public $perpage;

    public function __construct($keywords = '', $page = 1, $perpage = 20)
    {
        $this->keywords = $keywords;
        $this->page = $page;
        $this->perpage = $perpage;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        // Trim keywords to remove leading/trailing whitespace
        $keywords = isset($data['keywords']) ? trim($data['keywords']) : '';
        return new self(
            $keywords,
            $data['page'] ?? 1,
            $data['perpage'] ?? 20
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        // keywords is now optional - only validate if provided
        // (empty keywords means list all members)
        
        if (!is_numeric($this->page) || $this->page < 1) {
            $errors[] = 'page must be positive integer';
        }
        
        if (!is_numeric($this->perpage) || $this->perpage < 1) {
            $errors[] = 'perpage must be positive integer';
        }
        
        return $errors;
    }
}

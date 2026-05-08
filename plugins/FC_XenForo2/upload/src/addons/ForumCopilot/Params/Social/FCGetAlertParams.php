<?php

namespace ForumCopilot\Params\Social;

/**
 * Parameters for getAlert API method
 * Forum-agnostic parameter class for getting user alerts/notifications
 */
class FCGetAlertParams
{
    /** @var int Page number for pagination */
    public $page;
    
    /** @var int Results per page */
    public $perpage;
    
    /** @var bool Whether to get unread alerts only */
    public $unreadOnly;

    public function __construct($page = 1, $perpage = 20, $unreadOnly = false)
    {
        $this->page = $page;
        $this->perpage = $perpage;
        $this->unreadOnly = $unreadOnly;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['page'] ?? 1,
            $data['perpage'] ?? 20,
            $data['unreadOnly'] ?? false
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (!is_numeric($this->page) || $this->page < 1) {
            $errors[] = 'page must be positive integer';
        }
        
        if (!is_numeric($this->perpage) || $this->perpage < 1) {
            $errors[] = 'perpage must be positive integer';
        }
        
        if (!is_bool($this->unreadOnly)) {
            $errors[] = 'unreadOnly must be boolean';
        }
        
        return $errors;
    }
}

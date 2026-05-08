<?php

namespace ForumCopilot\Params\User;

/**
 * Parameters for getOnlineUsers API method
 * Forum-agnostic parameter class for online users retrieval
 */
class FCGetOnlineUsersParams
{
    /** @var int Page number for pagination */
    public $page;
    
    /** @var int Results per page */
    public $perpage;
    
    /** @var string Specific user ID to get info for */
    public $id;
    
    /** @var string Area/forum ID to filter by */
    public $area;

    public function __construct($page = 1, $perpage = 20, $id = '', $area = '')
    {
        $this->page = $page;
        $this->perpage = $perpage;
        $this->id = $id;
        $this->area = $area;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['page'] ?? 1,
            $data['perpage'] ?? 20,
            $data['id'] ?? '',
            $data['area'] ?? ''
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
        
        if (!is_string($this->id)) {
            $errors[] = 'id must be string';
        }
        
        if (!is_string($this->area)) {
            $errors[] = 'area must be string';
        }
        
        return $errors;
    }
}

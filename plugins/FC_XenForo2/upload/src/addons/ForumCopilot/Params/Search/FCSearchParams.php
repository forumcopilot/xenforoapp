<?php

namespace ForumCopilot\Params\Search;

/**
 * Parameters for search API methods
 * Forum-agnostic parameter class for search operations
 */
class FCSearchParams
{
    /** @var string Search keywords */
    public $keywords;
    
    /** @var int Page number for pagination */
    public $page;
    
    /** @var int Results per page */
    public $perpage;
    
    /** @var string|null Search ID for advanced searches */
    public $searchId;
    
    /** @var bool Whether to search only in titles */
    public $titleOnly;
    
    /** @var string|null User ID to search for */
    public $userId;
    
    /** @var string|null Username to search for */
    public $searchUser;
    
    /** @var string|null Forum ID to search in */
    public $forumId;
    
    /** @var string|null Topic ID to search in */
    public $topicId;
    
    /** @var array Forums to include in search */
    public $onlyIn;
    
    /** @var array Forums to exclude from search */
    public $notIn;
    
    /** @var bool Whether to search only topics started by specific user */
    public $startedBy;

    public function __construct($keywords = '', $page = 1, $perpage = 20, $searchId = null, $titleOnly = false, $userId = null, $searchUser = null, $forumId = null, $topicId = null, $onlyIn = [], $notIn = [], $startedBy = false)
    {
        $this->keywords = $keywords;
        $this->page = $page;
        $this->perpage = $perpage;
        $this->searchId = $searchId;
        $this->titleOnly = $titleOnly;
        $this->userId = $userId;
        $this->searchUser = $searchUser;
        $this->forumId = $forumId;
        $this->topicId = $topicId;
        $this->onlyIn = $onlyIn;
        $this->notIn = $notIn;
        $this->startedBy = $startedBy;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['keywords'] ?? '',
            $data['page'] ?? 1,
            $data['perpage'] ?? 20,
            $data['searchId'] ?? null,
            $data['titleOnly'] ?? false,
            $data['userId'] ?? null,
            $data['searchUser'] ?? null,
            $data['forumId'] ?? null,
            $data['topicId'] ?? null,
            $data['onlyIn'] ?? [],
            $data['notIn'] ?? [],
            $data['startedBy'] ?? false
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->keywords)) {
            $errors[] = 'keywords is required';
        }
        
        if (!is_numeric($this->page) || $this->page < 1) {
            $errors[] = 'page must be positive integer';
        }
        
        if (!is_numeric($this->perpage) || $this->perpage < 1) {
            $errors[] = 'perpage must be positive integer';
        }
        
        if ($this->searchId !== null && !is_string($this->searchId)) {
            $errors[] = 'searchId must be string or null';
        }
        
        if (!is_bool($this->titleOnly)) {
            $errors[] = 'titleOnly must be boolean';
        }
        
        if ($this->userId !== null && !is_string($this->userId)) {
            $errors[] = 'userId must be string or null';
        }
        
        if ($this->searchUser !== null && !is_string($this->searchUser)) {
            $errors[] = 'searchUser must be string or null';
        }
        
        if ($this->forumId !== null && !is_string($this->forumId)) {
            $errors[] = 'forumId must be string or null';
        }
        
        if ($this->topicId !== null && !is_string($this->topicId)) {
            $errors[] = 'topicId must be string or null';
        }
        
        if (!is_array($this->onlyIn)) {
            $errors[] = 'onlyIn must be array';
        }
        
        if (!is_array($this->notIn)) {
            $errors[] = 'notIn must be array';
        }
        
        if (!is_bool($this->startedBy)) {
            $errors[] = 'startedBy must be boolean';
        }
        
        return $errors;
    }
}

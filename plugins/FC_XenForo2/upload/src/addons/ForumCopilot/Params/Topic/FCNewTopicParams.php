<?php

namespace ForumCopilot\Params\Topic;

/**
 * Parameters for newTopic API method
 * Forum-agnostic parameter class for creating new topics
 */
class FCNewTopicParams
{
    /** @var string Forum ID where topic will be created */
    public $forumId;
    
    /** @var string Topic title */
    public $title;
    
    /** @var string Topic content/body */
    public $textBody;

    /** @var string Optional thread prefix ID (API: prefixId) */
    public $prefixId;

    /** @var array List of attachment IDs */
    public $attachmentIds;

    /** @var string|null Group ID / attachment temp hash (API: groupId) */
    public $groupId;
    
    /** @var bool Whether topic is a poll */
    public $isPoll;
    
    /** @var string|null Poll question */
    public $pollQuestion;
    
    /** @var array Poll options */
    public $pollOptions;

    public function __construct($forumId = '', $title = '', $textBody = '', $prefixId = '', $attachmentIds = [], $groupId = null, $isPoll = false, $pollQuestion = null, $pollOptions = [])
    {
        $this->forumId = $forumId;
        $this->title = $title;
        $this->textBody = $textBody;
        $this->prefixId = $prefixId;
        $this->attachmentIds = is_array($attachmentIds) ? $attachmentIds : [];
        $this->groupId = $groupId;
        $this->isPoll = $isPoll;
        $this->pollQuestion = $pollQuestion;
        $this->pollOptions = is_array($pollOptions) ? $pollOptions : [];
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['forumId'] ?? '',
            $data['title'] ?? '',
            $data['textBody'] ?? '',
            $data['prefixId'] ?? '',
            $data['attachmentIds'] ?? [],
            $data['groupId'] ?? null,
            $data['isPoll'] ?? false,
            $data['pollQuestion'] ?? null,
            $data['pollOptions'] ?? []
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->forumId)) {
            $errors[] = 'forumId is required';
        }
        
        if (empty($this->title)) {
            $errors[] = 'title is required';
        }
        
        if (empty($this->textBody)) {
            $errors[] = 'textBody is required';
        }

        if ($this->prefixId !== '' && $this->prefixId !== null && !is_string($this->prefixId)) {
            $errors[] = 'prefixId must be string';
        }

        if (!is_array($this->attachmentIds)) {
            $errors[] = 'attachmentIds must be array';
        }
        
        if ($this->groupId !== null && !is_string($this->groupId)) {
            $errors[] = 'groupId must be string or null';
        }
        
        if (!is_bool($this->isPoll)) {
            $errors[] = 'isPoll must be boolean';
        }
        
        if ($this->isPoll && empty($this->pollQuestion)) {
            $errors[] = 'pollQuestion is required when isPoll is true';
        }
        
        if (!is_array($this->pollOptions)) {
            $errors[] = 'pollOptions must be array';
        }
        
        return $errors;
    }
}

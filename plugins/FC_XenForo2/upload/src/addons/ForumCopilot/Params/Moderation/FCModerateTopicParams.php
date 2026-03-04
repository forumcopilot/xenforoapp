<?php

namespace ForumCopilot\Params\Moderation;

/**
 * Parameters for moderation operations on topics
 * Forum-agnostic parameter class for topic moderation operations
 */
class FCModerateTopicParams
{
    /** @var string Topic ID to moderate */
    public $topicId;
    
    /** @var string Action to perform (stick, unstick, close, unclose, delete, etc.) */
    public $action;

    public function __construct($topicId = '', $action = '')
    {
        $this->topicId = $topicId;
        $this->action = $action;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['topicId'] ?? '',
            $data['action'] ?? ''
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->topicId)) {
            $errors[] = 'topicId is required';
        }
        
        if (empty($this->action)) {
            $errors[] = 'action is required';
        }
        
        $validActions = ['stick', 'unstick', 'close', 'unclose', 'delete', 'undelete', 'move', 'rename'];
        if (!in_array($this->action, $validActions)) {
            $errors[] = 'action must be one of: ' . implode(', ', $validActions);
        }
        
        return $errors;
    }
}

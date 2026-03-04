<?php

namespace ForumCopilot\Params\Subscription;

/**
 * Parameters for subscribeTopic API method
 * Forum-agnostic parameter class for topic subscription operations
 */
class FCSubscribeTopicParams
{
    /** @var string Topic ID to subscribe/unsubscribe */
    public $topicId;
    
    /** @var bool Whether to subscribe (true) or unsubscribe (false) */
    public $subscribe;

    public function __construct($topicId = '', $subscribe = true)
    {
        $this->topicId = $topicId;
        $this->subscribe = $subscribe;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['topicId'] ?? '',
            $data['subscribe'] ?? true
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
        
        if (!is_bool($this->subscribe)) {
            $errors[] = 'subscribe must be boolean';
        }
        
        return $errors;
    }
}

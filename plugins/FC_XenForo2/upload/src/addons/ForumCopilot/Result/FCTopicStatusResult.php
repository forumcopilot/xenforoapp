<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Topic Status Result
 * Maps from TopicStatusData_Output
 */
class FCTopicStatusResult extends FCResult
{
    public $topics;

    public function __construct($result = true, $resultText = 'success', $topics = [])
    {
        parent::__construct($result, $resultText);
        $this->topics = $topics;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['topics'] = array_map(function($topic) {
            return is_object($topic) ? $topic->toArray() : $topic;
        }, $this->topics);
        return $data;
    }
}


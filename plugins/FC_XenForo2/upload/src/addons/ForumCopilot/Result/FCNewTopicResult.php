<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot New Topic Result
 * Maps from NewTopicData_Output
 */
class FCNewTopicResult extends FCResult
{
    public $topicId;
    public $state;

    public function __construct($result = true, $resultText = 'success', $topicId = '', $state = 0)
    {
        parent::__construct($result, $resultText);
        $this->topicId = $topicId;
        $this->state = $state;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['topicId'] = $this->topicId;
        $data['state'] = $this->state;
        return $data;
    }
}


<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Subscribed Topic Result
 * Maps from SubscribedTopicData_Output
 */
class FCSubscribedTopicResult extends FCResult
{
    public $totalSubscribedNum;
    public $topics;

    public function __construct($result = true, $resultText = 'success', $totalSubscribedNum = 0, $topics = [])
    {
        parent::__construct($result, $resultText);
        $this->totalSubscribedNum = $totalSubscribedNum;
        $this->topics = $topics;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalSubscribedNum'] = $this->totalSubscribedNum;
        $data['totalTopicNum'] = $this->totalSubscribedNum; // Compatibility
        $data['topics'] = array_map(function($topic) {
            return is_object($topic) ? $topic->toArray() : $topic;
        }, $this->topics);
        return $data;
    }
}


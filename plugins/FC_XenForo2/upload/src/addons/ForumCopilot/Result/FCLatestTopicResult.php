<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Latest Topic Result
 * Maps from LatestTopicData_Output
 */
class FCLatestTopicResult extends FCResult
{
    public $totalLatestNum;
    public $topics;

    public function __construct($result = true, $resultText = 'success', $totalLatestNum = 0, $topics = [])
    {
        parent::__construct($result, $resultText);
        $this->totalLatestNum = $totalLatestNum;
        $this->topics = $topics;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalLatestNum'] = $this->totalLatestNum;
        $data['totalTopicNum'] = $this->totalLatestNum; // Compatibility
        $data['topics'] = array_map(function($topic) {
            return is_object($topic) ? $topic->toArray() : $topic;
        }, $this->topics);
        return $data;
    }
}


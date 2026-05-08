<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Search Data Result Topic
 * Maps from SearchData_OutputTopic
 */
class FCSearchDataResultTopic extends FCResult
{
    public $totalTopicNum;
    public $searchId;
    public $topics;

    public function __construct($result = true, $resultText = 'success', $totalTopicNum = 0, $searchId = null, $topics = [])
    {
        parent::__construct($result, $resultText);
        $this->totalTopicNum = $totalTopicNum;
        $this->searchId = $searchId;
        $this->topics = $topics;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalTopicNum'] = $this->totalTopicNum;
        if ($this->searchId !== null) $data['searchId'] = $this->searchId;
        $data['topics'] = array_map(function($topic) {
            return is_object($topic) ? $topic->toArray() : $topic;
        }, $this->topics);
        return $data;
    }
}


<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Participated Topic Result
 * Maps from ParticipatedTopicData_Output
 */
class FCParticipatedTopicResult extends FCResult
{
    public $totalParticipatedNum;
    public $topics;

    public function __construct($result = true, $resultText = 'success', $totalParticipatedNum = 0, $topics = [])
    {
        parent::__construct($result, $resultText);
        $this->totalParticipatedNum = $totalParticipatedNum;
        $this->topics = $topics;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalParticipatedNum'] = $this->totalParticipatedNum;
        $data['totalTopicNum'] = $this->totalParticipatedNum; // Compatibility
        $data['topics'] = array_map(function($topic) {
            return is_object($topic) ? $topic->toArray() : $topic;
        }, $this->topics);
        return $data;
    }
}


<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Subscribed Forum Result
 * Maps from SubscribedForumData_Output
 */
class FCSubscribedForumResult extends FCResult
{
    public $totalForumsNum;
    public $forums;

    public function __construct($result = true, $resultText = 'success', $totalForumsNum = 0, $forums = [])
    {
        parent::__construct($result, $resultText);
        $this->totalForumsNum = $totalForumsNum;
        $this->forums = $forums;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalForumsNum'] = $this->totalForumsNum;
        $data['forums'] = array_map(function($forum) {
            return is_object($forum) ? $forum->toArray() : $forum;
        }, $this->forums);
        return $data;
    }
}


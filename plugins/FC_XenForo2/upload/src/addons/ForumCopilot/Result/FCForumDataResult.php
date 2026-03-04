<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Forum Data Result
 * Maps from ForumData_Output
 */
class FCForumDataResult extends FCResult
{
    public $forums;

    public function __construct($result = true, $resultText = 'success', $forums = [])
    {
        parent::__construct($result, $resultText);
        $this->forums = $forums;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['forums'] = array_map(function($forum) {
            return is_object($forum) ? $forum->toArray() : $forum;
        }, $this->forums);
        return $data;
    }
}


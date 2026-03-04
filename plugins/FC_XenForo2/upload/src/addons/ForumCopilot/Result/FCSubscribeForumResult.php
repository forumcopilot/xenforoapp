<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Subscribe Forum Result
 * Maps from SubscribeForumData_Output
 */
class FCSubscribeForumResult extends FCResult
{
    public function __construct($result = true, $resultText = 'success')
    {
        parent::__construct($result, $resultText);
    }

    public function toArray()
    {
        return parent::toArray();
    }
}


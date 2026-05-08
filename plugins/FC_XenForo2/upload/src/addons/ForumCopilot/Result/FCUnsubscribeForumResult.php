<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Unsubscribe Forum Result
 * Maps from UnsubscribeForumData_Output
 */
class FCUnsubscribeForumResult extends FCResult
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


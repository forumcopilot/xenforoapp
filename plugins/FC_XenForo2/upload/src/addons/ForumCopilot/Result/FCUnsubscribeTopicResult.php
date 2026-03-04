<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Unsubscribe Topic Result
 * Maps from UnsubscribeTopicData_Output
 */
class FCUnsubscribeTopicResult extends FCResult
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


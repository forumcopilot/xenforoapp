<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Subscribe Topic Result
 * Maps from SubscribeTopicData_Output
 */
class FCSubscribeTopicResult extends FCResult
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


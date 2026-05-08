<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Mark Topic Read Result
 * Maps from MarkTopicReadData_Output
 */
class FCMarkTopicReadResult extends FCResult
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


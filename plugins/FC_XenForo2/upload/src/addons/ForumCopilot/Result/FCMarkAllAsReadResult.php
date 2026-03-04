<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Mark All As Read Result
 * Maps from MarkAllAsReadData_Output
 */
class FCMarkAllAsReadResult extends FCResult
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


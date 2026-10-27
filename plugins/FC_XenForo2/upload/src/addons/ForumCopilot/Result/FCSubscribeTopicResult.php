<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Subscribe Topic Result
 * Maps from SubscribeTopicData_Output
 */
class FCSubscribeTopicResult extends FCResult
{
    /** @var array More fields for the reply (1.11.0): the watch as it is now */
    public $extra = [];

    public function __construct($result = true, $resultText = 'success')
    {
        parent::__construct($result, $resultText);
    }

    public function toArray()
    {
        return array_merge(parent::toArray(), $this->extra);
    }
}


<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Mark Conversation Read Result
 * Maps from MarkConversationReadData_Output
 */
class FCMarkConversationReadResult extends FCResult
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


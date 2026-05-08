<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Mark Conversation Unread Result
 * Maps from MarkConversationUnreadData_Output
 */
class FCMarkConversationUnreadResult extends FCResult
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


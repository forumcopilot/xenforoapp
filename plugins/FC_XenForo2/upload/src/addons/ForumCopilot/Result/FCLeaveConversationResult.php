<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Leave Conversation Result
 * Maps from LeaveConversationData_Output
 */
class FCLeaveConversationResult extends FCResult
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


















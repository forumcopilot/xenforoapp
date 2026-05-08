<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot New Conversation Result
 * Maps from NewConversationData_Output
 */
class FCNewConversationResult extends FCResult
{
    public $convId;

    public function __construct($result = true, $resultText = 'success', $convId = '')
    {
        parent::__construct($result, $resultText);
        $this->convId = $convId;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['convId'] = $this->convId;
        return $data;
    }
}


<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Reply Conversation Result
 * Maps from ReplyConversationData_Output
 */
class FCReplyConversationResult extends FCResult
{
    public $messageId;

    public function __construct($result = true, $resultText = 'success', $messageId = null)
    {
        parent::__construct($result, $resultText);
        $this->messageId = $messageId;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->messageId !== null) $data['messageId'] = $this->messageId;
        return $data;
    }
}


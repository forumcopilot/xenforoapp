<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Quote Conversation Result
 * Maps from QuoteConversationData_Output
 */
class FCQuoteConversationResult extends FCResult
{
    public $quote;

    public function __construct($result = true, $resultText = 'success', $quote = null)
    {
        parent::__construct($result, $resultText);
        $this->quote = $quote;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->quote !== null) {
            $data['quote'] = $this->quote;
        }
        return $data;
    }
}


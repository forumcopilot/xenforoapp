<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Quote Post Result
 * Maps from QuotePostData_Output
 */
class FCQuotePostResult extends FCResult
{
    public $quoteContent;

    public function __construct($result = true, $resultText = 'success', $quoteContent = null)
    {
        parent::__construct($result, $resultText);
        $this->quoteContent = $quoteContent;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->quoteContent !== null) {
            $data['quoteContent'] = $this->quoteContent;
        }
        return $data;
    }
}


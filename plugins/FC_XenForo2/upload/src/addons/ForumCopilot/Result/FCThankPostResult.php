<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Thank Post Result
 * Maps from ThankPostData_Output
 */
class FCThankPostResult extends FCResult
{
    public $isThanked;
    public $thankCount;

    public function __construct($result = true, $resultText = 'success', $isThanked = false, $thankCount = 0)
    {
        parent::__construct($result, $resultText);
        $this->isThanked = $isThanked;
        $this->thankCount = $thankCount;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isThanked'] = $this->isThanked;
        $data['thankCount'] = $this->thankCount;
        return $data;
    }
}


<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Login Forum Result
 * Maps from LoginForumData_Output
 */
class FCLoginForumResult extends FCResult
{
    public $cookies;

    public function __construct($result = true, $resultText = 'success', $cookies = null)
    {
        parent::__construct($result, $resultText);
        $this->cookies = $cookies;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->cookies !== null) $data['cookies'] = $this->cookies;
        return $data;
    }
}


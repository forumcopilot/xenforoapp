<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Follow Result
 * Maps from FollowData_Output
 */
class FCFollowResult extends FCResult
{
    public $isFollowing;

    public function __construct($result = true, $resultText = 'success', $isFollowing = false)
    {
        parent::__construct($result, $resultText);
        $this->isFollowing = $isFollowing;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isFollowing'] = $this->isFollowing;
        return $data;
    }
}


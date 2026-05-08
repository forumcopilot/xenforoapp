<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Unlike Post Result
 * Maps from UnlikePostData_Output
 */
class FCUnlikePostResult extends FCResult
{
    public $isLiked;
    public $likeCount;

    public function __construct($result = true, $resultText = 'success', $isLiked = false, $likeCount = 0)
    {
        parent::__construct($result, $resultText);
        $this->isLiked = $isLiked;
        $this->likeCount = $likeCount;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLiked'] = $this->isLiked;
        $data['likeCount'] = $this->likeCount;
        return $data;
    }
}


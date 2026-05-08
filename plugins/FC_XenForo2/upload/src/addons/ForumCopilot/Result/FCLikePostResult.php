<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Like Post Result
 * Maps from LikePostData_Output
 */
class FCLikePostResult extends FCResult
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


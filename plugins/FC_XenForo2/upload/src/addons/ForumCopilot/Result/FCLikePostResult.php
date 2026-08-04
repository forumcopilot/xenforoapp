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

    /**
     * @var int|null The reaction the visitor now has on this post after the
     * action (e.g. 2 = Love), or null if they have no reaction (toggled off).
     * Lets the app render the correct emoji without a full refresh.
     */
    public $visitorReactionId;

    public function __construct($result = true, $resultText = 'success', $isLiked = false, $likeCount = 0, $visitorReactionId = null)
    {
        parent::__construct($result, $resultText);
        $this->isLiked = $isLiked;
        $this->likeCount = $likeCount;
        $this->visitorReactionId = $visitorReactionId;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLiked'] = $this->isLiked;
        $data['likeCount'] = $this->likeCount;
        $data['visitorReactionId'] = $this->visitorReactionId;
        return $data;
    }
}


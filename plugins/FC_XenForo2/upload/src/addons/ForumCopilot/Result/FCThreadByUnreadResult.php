<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Thread By Unread Result
 * Maps from ThreadByUnreadData_Output
 */
class FCThreadByUnreadResult extends FCThreadResult
{
    public $canReply;
    public $canReport;
    public $canUpload;
    public $position;

    public function __construct($result = true, $resultText = 'success', $totalPostNum = 0, $canReply = false, $canReport = false, $canUpload = false, $posts = [], $position = 1, $topicData = [])
    {
        parent::__construct($result, $resultText, $totalPostNum, $posts, $topicData);
        $this->canReply = $canReply;
        $this->canReport = $canReport;
        $this->canUpload = $canUpload;
        $this->position = $position;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['canReply'] = $this->canReply;
        $data['canReport'] = $this->canReport;
        $data['canUpload'] = $this->canUpload;
        $data['position'] = $this->position;
        return $data;
    }
}


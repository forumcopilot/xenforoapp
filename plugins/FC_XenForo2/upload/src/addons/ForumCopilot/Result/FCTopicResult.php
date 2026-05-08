<?php

namespace ForumCopilot\Result;

/**
 * FCTopicResult.php
 * 
 * This file previously contained multiple classes but they have been split into separate files
 * for PSR-4 autoloading compatibility. The classes have been moved to:
 * - FCTopicDataResult.php
 * - FCNewTopicResult.php
 * - FCMarkTopicReadResult.php
 * - FCTopicStatusResult.php
 * - FCUnreadTopicResult.php
 * - FCParticipatedTopicResult.php
 * - FCLatestTopicResult.php
 * - FCTopicByIdsResult.php
 * 
 * This file now only contains the legacy FCTopicResult class for backward compatibility.
 */

/**
 * ForumCopilot Topic Result (legacy compatibility)
 * Forum-agnostic topic result that can be reused across different forum plugins
 */
class FCTopicResult extends FCResult
{
    public $topics;
    public $totalTopicNum;

    public function __construct($result = true, $resultText = 'success', $topics = [], $totalTopicNum = 0)
    {
        parent::__construct($result, $resultText);
        $this->topics = $topics;
        $this->totalTopicNum = $totalTopicNum;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['topics'] = array_map(function($topic) {
            return is_object($topic) ? $topic->toArray() : $topic;
        }, $this->topics);
        $data['totalTopicNum'] = $this->totalTopicNum;
        return $data;
    }
}

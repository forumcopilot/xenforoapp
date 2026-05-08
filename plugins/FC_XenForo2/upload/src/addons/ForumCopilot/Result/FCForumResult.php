<?php

namespace ForumCopilot\Result;

/**
 * FCForumResult.php
 * 
 * This file previously contained multiple classes but they have been split into separate files
 * for PSR-4 autoloading compatibility. The classes have been moved to:
 * - FCForumDataResult.php
 * - FCBoardStatResult.php
 * - FCParticipatedForumResult.php
 * - FCMarkAllAsReadResult.php
 * - FCForumStatusResult.php
 * 
 * This file now only contains the legacy FCForumResult class and other classes that are not yet split.
 */

/**
 * ForumCopilot ID By URL Result
 * Maps from IdByUrlData_Output
 */
class FCIdByUrlResult extends FCResult
{
    public $topicId;
    public $postId;
    public $forumId;

    public function __construct($result = true, $resultText = 'success', $topicId = null, $postId = null, $forumId = null)
    {
        parent::__construct($result, $resultText);
        $this->topicId = $topicId;
        $this->postId = $postId;
        $this->forumId = $forumId;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->topicId !== null) $data['topicId'] = $this->topicId;
        if ($this->postId !== null) $data['postId'] = $this->postId;
        if ($this->forumId !== null) $data['forumId'] = $this->forumId;
        return $data;
    }
}

/**
 * ForumCopilot URL By ID Result
 * Maps from UrlByIdData_Output
 */
class FCUrlByIdResult extends FCResult
{
    public $url;

    public function __construct($result = true, $resultText = 'success', $url = null)
    {
        parent::__construct($result, $resultText);
        $this->url = $url;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->url !== null) $data['url'] = $this->url;
        return $data;
    }
}

/**
 * ForumCopilot Forum Result (legacy compatibility)
 * Forum-agnostic forum result that can be reused across different forum plugins
 */
class FCForumResult extends FCResult
{
    public $forums;

    public function __construct($result = true, $resultText = 'success', $forums = [])
    {
        parent::__construct($result, $resultText);
        $this->forums = $forums;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['forums'] = array_map(function($forum) {
            return is_object($forum) ? $forum->toArray() : $forum;
        }, $this->forums);
        return $data;
    }
}

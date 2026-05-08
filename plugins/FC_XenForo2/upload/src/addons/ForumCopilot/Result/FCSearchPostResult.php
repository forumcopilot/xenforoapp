<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Search Post Result
 * Maps from SearchPostData_Output
 */
class FCSearchPostResult extends FCResult
{
    public $totalPostNum;
    public $searchId;
    public $posts;

    public function __construct($result = true, $resultText = 'success', $totalPostNum = 0, $searchId = null, $posts = [])
    {
        parent::__construct($result, $resultText);
        $this->totalPostNum = $totalPostNum;
        $this->searchId = $searchId;
        $this->posts = $posts;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalPostNum'] = $this->totalPostNum;
        if ($this->searchId !== null) $data['searchId'] = $this->searchId;
        $data['posts'] = array_map(function($post) {
            return is_object($post) ? $post->toArray() : $post;
        }, $this->posts);
        return $data;
    }
}


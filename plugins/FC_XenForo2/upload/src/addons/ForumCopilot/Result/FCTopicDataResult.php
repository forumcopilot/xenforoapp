<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Topic Data Result
 * Maps from TopicData_Output
 */
class FCTopicDataResult extends FCResult
{
    public $totalTopicNum;
    public $forumId;
    public $forumName;
    public $canPost;
    public $canUpload;
    public $unreadStickyCount;
    public $unreadAnnounceCount;
    public $canSubscribe;
    public $isSubscribed;
    public $requirePrefix;
    public $prefixes;
    public $topics;

    public function __construct($result = true, $resultText = 'success', $totalTopicNum = 0, $forumId = '', $forumName = '', $canPost = false, $canUpload = false, $unreadStickyCount = 0, $unreadAnnounceCount = 0, $canSubscribe = false, $isSubscribed = false, $requirePrefix = false, $prefixes = [], $topics = [])
    {
        parent::__construct($result, $resultText);
        $this->totalTopicNum = $totalTopicNum;
        $this->forumId = $forumId;
        $this->forumName = $forumName;
        $this->canPost = $canPost;
        $this->canUpload = $canUpload;
        $this->unreadStickyCount = $unreadStickyCount;
        $this->unreadAnnounceCount = $unreadAnnounceCount;
        $this->canSubscribe = $canSubscribe;
        $this->isSubscribed = $isSubscribed;
        $this->requirePrefix = $requirePrefix;
        $this->prefixes = $prefixes;
        $this->topics = $topics;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalTopicNum'] = $this->totalTopicNum;
        $data['forumId'] = $this->forumId;
        $data['forumName'] = $this->forumName;
        $data['canPost'] = $this->canPost;
        $data['canUpload'] = $this->canUpload;
        $data['unreadStickyCount'] = $this->unreadStickyCount;
        $data['unreadAnnounceCount'] = $this->unreadAnnounceCount;
        $data['canSubscribe'] = $this->canSubscribe;
        $data['isSubscribed'] = $this->isSubscribed;
        $data['requirePrefix'] = $this->requirePrefix;
        $data['prefixes'] = array_map(function($prefix) {
            return is_object($prefix) ? $prefix->toArray() : $prefix;
        }, $this->prefixes);
        $data['topics'] = array_map(function($topic) {
            return is_object($topic) ? $topic->toArray() : $topic;
        }, $this->topics);
        return $data;
    }
}


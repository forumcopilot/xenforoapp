<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Thread Result
 * Maps from ThreadData_Output
 * Contains all FCTopic properties plus posts array
 */
class FCThreadResult extends FCResult
{
    // FCTopic properties
    public $id;
    public $title;
    public $forumId;
    public $forumName;
    public $authorId;
    public $authorName;
    public $authorUserType;
    public $timestamp;
    public $prefix;
    public $authorIconUrl;
    public $replyCount;
    public $viewCount;
    public $hasNewPosts;
    public $isClosed;
    public $isSubscribed;
    public $canSubscribe;
    public $url;
    public $shortContent;
    public $participatedUserIds;
    public $isPinned;
    public $isAnnouncement;
    public $isStickySource;
    public $canRename;
    public $canDelete;
    public $canClose;
    public $canApprove;
    public $canStick;
    public $canMove;
    public $canMerge;
    public $canBan;
    public $canReply;
    public $canReport;
    public $canUpload;
    public $isBanned;
    public $isApproved;
    public $isDeleted;
    public $isMoved;
    public $isMerged;
    public $realTopicId;
    public $canLike;
    public $isLiked;
    public $likeCount;
    public $hasPoll;
    public $poll;
    
    // Thread-specific properties
    public $totalPostNum;
    public $posts;

    public function __construct($result = true, $resultText = 'success', $totalPostNum = 0, $posts = [], $topicData = [])
    {
        parent::__construct($result, $resultText);
        $this->totalPostNum = $totalPostNum;
        $this->posts = $posts;
        
        // Set all topic properties from $topicData
        if (is_array($topicData)) {
            foreach ($topicData as $key => $value) {
                if (property_exists($this, $key)) {
                    $this->$key = $value;
                }
            }
        }
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalPostNum'] = $this->totalPostNum;
        $data['posts'] = array_map(function($post) {
            return is_object($post) ? $post->toArray() : $post;
        }, $this->posts);
        
        // Add all topic properties
        $topicProperties = [
            'id', 'title', 'forumId', 'forumName', 'authorId', 'authorName', 
            'authorUserType', 'timestamp', 'prefix', 'authorIconUrl', 'replyCount',
            'viewCount', 'hasNewPosts', 'isClosed', 'isSubscribed', 'canSubscribe',
            'url', 'shortContent', 'participatedUserIds', 'isPinned', 'isAnnouncement',
            'isStickySource', 'canRename', 'canDelete', 'canClose', 'canApprove',
            'canStick', 'canMove', 'canMerge', 'canBan', 'canReply', 'canReport',
            'canUpload', 'isBanned', 'isApproved', 'isDeleted', 'isMoved', 'isMerged',
            'realTopicId', 'canLike', 'isLiked', 'likeCount', 'hasPoll', 'poll'
        ];
        
        foreach ($topicProperties as $prop) {
            if (property_exists($this, $prop)) {
                $data[$prop] = $this->$prop;
            }
        }
        // Always include hasPoll and poll in thread responses (API contract)
        $data['hasPoll'] = $this->hasPoll ?? false;
        $data['poll'] = $this->poll;

        return $data;
    }
}


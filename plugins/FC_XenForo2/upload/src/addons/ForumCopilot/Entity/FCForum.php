<?php

namespace ForumCopilot\Entity;

/**
 * ForumCopilot Forum Entity
 * Forum-agnostic forum representation that can be reused across different forum plugins
 */
class FCForum
{
    public $id;
    public $name;
    public $description;
    public $parentId;
    public $displayOrder;
    public $threadCount;
    public $postCount;
    public $canPost;
    public $canReply;
    public $canViewContent;
    public $isRead;
    public $url;
    public $subForums;
    public $privateInfo;
    public $lastPostId;
    public $lastPostDate;
    public $lastPostUserId;
    public $lastPostUsername;
    public $lastThreadId;
    public $lastThreadTitle;
    public $lastThreadPrefixId;
    public $isLinkForum;

    public function __construct($data = [])
    {
        $this->id = $data['id'] ?? '';
        $this->name = $data['name'] ?? '';
        $this->description = $data['description'] ?? '';
        $this->parentId = $data['parentId'] ?? '';
        $this->displayOrder = $data['displayOrder'] ?? 0;
        $this->threadCount = $data['threadCount'] ?? 0;
        $this->postCount = $data['postCount'] ?? 0;
        $this->canPost = $data['canPost'] ?? false;
        $this->canReply = $data['canReply'] ?? false;
        $this->canViewContent = $data['canViewContent'] ?? false;
        $this->isRead = $data['isRead'] ?? true;
        $this->url = $data['url'] ?? '';
        $this->subForums = $data['subForums'] ?? [];
        $this->privateInfo = $data['privateInfo'] ?? false;
        $this->lastPostId = $data['lastPostId'] ?? 0;
        $this->lastPostDate = $data['lastPostDate'] ?? 0;
        $this->lastPostUserId = $data['lastPostUserId'] ?? 0;
        $this->lastPostUsername = $data['lastPostUsername'] ?? '';
        $this->lastThreadId = $data['lastThreadId'] ?? 0;
        $this->lastThreadTitle = $data['lastThreadTitle'] ?? '';
        $this->lastThreadPrefixId = $data['lastThreadPrefixId'] ?? 0;
        $this->isLinkForum = $data['isLinkForum'] ?? false;
    }

    public function toArray()
    {
        // Recursively convert subForums to arrays
        $subForumsArray = [];
        if (is_array($this->subForums)) {
            foreach ($this->subForums as $subForum) {
                if (is_object($subForum) && method_exists($subForum, 'toArray')) {
                    $subForumsArray[] = $subForum->toArray();
                } elseif (is_array($subForum)) {
                    $subForumsArray[] = $subForum;
                }
            }
        }
        
        return [
            'id' => $this->id,
            'name' => $this->name,
            'description' => $this->description,
            'parentId' => $this->parentId,
            'displayOrder' => $this->displayOrder,
            'threadCount' => $this->threadCount,
            'postCount' => $this->postCount,
            'canPost' => $this->canPost,
            'canReply' => $this->canReply,
            'canViewContent' => $this->canViewContent,
            'isRead' => $this->isRead,
            'url' => $this->url,
            'subForums' => $subForumsArray,
            'privateInfo' => $this->privateInfo,
            'lastPostId' => $this->lastPostId,
            'lastPostDate' => $this->lastPostDate,
            'lastPostUserId' => $this->lastPostUserId,
            'lastPostUsername' => $this->lastPostUsername,
            'lastThreadId' => $this->lastThreadId,
            'lastThreadTitle' => $this->lastThreadTitle,
            'lastThreadPrefixId' => $this->lastThreadPrefixId,
            'isLinkForum' => $this->isLinkForum,
        ];
    }
}

<?php

namespace ForumCopilot\Entity;

/**
 * ForumCopilot Topic Entity
 * Forum-agnostic topic/thread representation that can be reused across different forum plugins
 */
class FCTopic
{
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
    public $canViewContent;
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

    public function __construct($data = [])
    {
        $this->id = $data['id'] ?? '';
        $this->title = $data['title'] ?? '';
        $this->forumId = $data['forumId'] ?? '';
        $this->forumName = $data['forumName'] ?? '';
        $this->authorId = $data['authorId'] ?? '';
        $this->authorName = $data['authorName'] ?? '';
        $this->authorUserType = $data['authorUserType'] ?? '';
        $this->timestamp = $data['timestamp'] ?? null;
        $this->prefix = $data['prefix'] ?? null;
        $this->authorIconUrl = $data['authorIconUrl'] ?? null;
        $this->replyCount = $data['replyCount'] ?? 0;
        $this->viewCount = $data['viewCount'] ?? 0;
        $this->hasNewPosts = $data['hasNewPosts'] ?? false;
        $this->isClosed = $data['isClosed'] ?? false;
        $this->isSubscribed = $data['isSubscribed'] ?? false;
        $this->canSubscribe = $data['canSubscribe'] ?? false;
        $this->url = $data['url'] ?? '';
        $this->shortContent = $data['shortContent'] ?? '';
        $this->participatedUserIds = $data['participatedUserIds'] ?? [];
        $this->isPinned = $data['isPinned'] ?? false;
        $this->isAnnouncement = $data['isAnnouncement'] ?? false;
        $this->isStickySource = $data['isStickySource'] ?? false;
        $this->canRename = $data['canRename'] ?? false;
        $this->canDelete = $data['canDelete'] ?? false;
        $this->canClose = $data['canClose'] ?? false;
        $this->canApprove = $data['canApprove'] ?? false;
        $this->canStick = $data['canStick'] ?? false;
        $this->canMove = $data['canMove'] ?? false;
        $this->canMerge = $data['canMerge'] ?? false;
        $this->canBan = $data['canBan'] ?? false;
        $this->canReply = $data['canReply'] ?? false;
        $this->canViewContent = $data['canViewContent'] ?? false;
        $this->canReport = $data['canReport'] ?? false;
        $this->canUpload = $data['canUpload'] ?? false;
        $this->isBanned = $data['isBanned'] ?? false;
        $this->isApproved = $data['isApproved'] ?? false;
        $this->isDeleted = $data['isDeleted'] ?? false;
        $this->isMoved = $data['isMoved'] ?? false;
        $this->isMerged = $data['isMerged'] ?? false;
        $this->realTopicId = $data['realTopicId'] ?? null;
        $this->canLike = $data['canLike'] ?? false;
        $this->isLiked = $data['isLiked'] ?? false;
        $this->likeCount = $data['likeCount'] ?? 0;
        $this->hasPoll = $data['hasPoll'] ?? false;
    }

    public function toArray()
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'forumId' => $this->forumId,
            'forumName' => $this->forumName,
            'authorId' => $this->authorId,
            'authorName' => $this->authorName,
            'authorUserType' => $this->authorUserType,
            'timestamp' => $this->timestamp,
            'prefix' => $this->prefix,
            'authorIconUrl' => $this->authorIconUrl,
            'replyCount' => $this->replyCount,
            'viewCount' => $this->viewCount,
            'hasNewPosts' => $this->hasNewPosts,
            'isClosed' => $this->isClosed,
            'isSubscribed' => $this->isSubscribed,
            'canSubscribe' => $this->canSubscribe,
            'url' => $this->url,
            'shortContent' => $this->shortContent,
            'participatedUserIds' => $this->participatedUserIds,
            'isPinned' => $this->isPinned,
            'isAnnouncement' => $this->isAnnouncement,
            'isStickySource' => $this->isStickySource,
            'canRename' => $this->canRename,
            'canDelete' => $this->canDelete,
            'canClose' => $this->canClose,
            'canApprove' => $this->canApprove,
            'canStick' => $this->canStick,
            'canMove' => $this->canMove,
            'canMerge' => $this->canMerge,
            'canBan' => $this->canBan,
            'canReply' => $this->canReply,
            'canViewContent' => $this->canViewContent,
            'canReport' => $this->canReport,
            'canUpload' => $this->canUpload,
            'isBanned' => $this->isBanned,
            'isApproved' => $this->isApproved,
            'isDeleted' => $this->isDeleted,
            'isMoved' => $this->isMoved,
            'isMerged' => $this->isMerged,
            'realTopicId' => $this->realTopicId,
            'canLike' => $this->canLike,
            'isLiked' => $this->isLiked,
            'likeCount' => $this->likeCount,
            'hasPoll' => $this->hasPoll,
        ];
    }
}

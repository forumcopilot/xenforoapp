<?php

namespace ForumCopilot\Entity;

/**
 * ForumCopilot Post Entity
 * Forum-agnostic post representation that can be reused across different forum plugins
 */
class FCPost
{
    public $id;
    public $topicId;
    public $authorId;
    public $authorName;
    public $authorUserType;
    public $timestamp;
    public $content;
    public $title;
    public $authorIconUrl;
    public $canEdit;
    public $canDelete;
    public $canReport;
    public $canLike;
    public $isLiked;
    public $likeCount;
    public $attachments;
    public $isApproved;
    public $isDeleted;
    public $isFirstPost;
    public $position;
    public $likesInfo;
    public $isBanned;

    public function __construct($data = [])
    {
        $this->id = $data['id'] ?? '';
        $this->topicId = $data['topicId'] ?? '';
        $this->authorId = $data['authorId'] ?? '';
        $this->authorName = $data['authorName'] ?? '';
        $this->authorUserType = $data['authorUserType'] ?? '';
        $this->timestamp = $data['timestamp'] ?? null;
        $this->content = $data['content'] ?? ($data['postContent'] ?? ''); // Support both for migration
        $this->title = $data['title'] ?? ($data['postTitle'] ?? ''); // Support both for migration
        $this->authorIconUrl = $data['authorIconUrl'] ?? null;
        $this->canEdit = $data['canEdit'] ?? false;
        $this->canDelete = $data['canDelete'] ?? false;
        $this->canReport = $data['canReport'] ?? false;
        $this->canLike = $data['canLike'] ?? false;
        $this->isLiked = $data['isLiked'] ?? false;
        $this->likeCount = $data['likeCount'] ?? 0;
        $this->attachments = $data['attachments'] ?? [];
        $this->isApproved = $data['isApproved'] ?? false;
        $this->isDeleted = $data['isDeleted'] ?? false;
        $this->isFirstPost = $data['isFirstPost'] ?? false;
        $this->position = $data['position'] ?? 0;
        $this->likesInfo = $data['likesInfo'] ?? [];
        $this->isBanned = $data['isBanned'] ?? false;
    }

    public function toArray()
    {
        // Convert attachments to arrays if they are FCAttachment objects
        $attachmentsArray = [];
        if (is_array($this->attachments)) {
            foreach ($this->attachments as $attachment) {
                if ($attachment instanceof FCAttachment) {
                    $attachmentsArray[] = $attachment->toArray();
                } else {
                    $attachmentsArray[] = $attachment;
                }
            }
        } else {
            $attachmentsArray = $this->attachments;
        }

        return [
            'id' => $this->id,
            'topicId' => $this->topicId,
            'authorId' => $this->authorId,
            'authorName' => $this->authorName,
            'authorUserType' => $this->authorUserType,
            'timestamp' => $this->timestamp,
            'content' => $this->content,
            'title' => $this->title,
            'authorIconUrl' => $this->authorIconUrl,
            'canEdit' => $this->canEdit,
            'canDelete' => $this->canDelete,
            'canReport' => $this->canReport,
            'canLike' => $this->canLike,
            'isLiked' => $this->isLiked,
            'likeCount' => $this->likeCount,
            'attachments' => $attachmentsArray,
            'isApproved' => $this->isApproved,
            'isDeleted' => $this->isDeleted,
            'isFirstPost' => $this->isFirstPost,
            'position' => $this->position,
            'likesInfo' => $this->likesInfo,
            'isBanned' => $this->isBanned,
        ];
    }
}

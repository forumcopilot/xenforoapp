<?php

namespace ForumCopilot\Entity;

/**
 * ForumCopilot Conversation Entity
 * Forum-agnostic conversation representation that can be reused across different forum plugins
 */
class FCConversation
{
    public $id;
    public $title;
    public $participants;
    public $lastMessageTime;
    public $lastMessageAuthor;
    public $isUnread;
    public $messageCount;
    public $canReply;
    public $canDelete;
    public $canInvite;

    public function __construct($data = [])
    {
        $this->id = $data['id'] ?? '';
        $this->title = $data['title'] ?? '';
        $this->participants = $data['participants'] ?? [];
        $this->lastMessageTime = $data['lastMessageTime'] ?? null;
        $this->lastMessageAuthor = $data['lastMessageAuthor'] ?? null;
        $this->isUnread = $data['isUnread'] ?? false;
        $this->messageCount = $data['messageCount'] ?? 0;
        $this->canReply = $data['canReply'] ?? false;
        $this->canDelete = $data['canDelete'] ?? false;
        $this->canInvite = $data['canInvite'] ?? false;
    }

    public function toArray()
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'participants' => $this->participants,
            'lastMessageTime' => $this->lastMessageTime,
            'lastMessageAuthor' => $this->lastMessageAuthor,
            'isUnread' => $this->isUnread,
            'messageCount' => $this->messageCount,
            'canReply' => $this->canReply,
            'canDelete' => $this->canDelete,
            'canInvite' => $this->canInvite,
        ];
    }
}

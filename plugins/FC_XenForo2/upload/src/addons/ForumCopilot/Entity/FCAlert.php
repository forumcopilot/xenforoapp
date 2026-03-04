<?php

namespace ForumCopilot\Entity;

/**
 * ForumCopilot Alert Entity
 * Forum-agnostic alert/notification representation that can be reused across different forum plugins
 */
class FCAlert
{
    public $id;
    public $type;
    public $title;
    public $content;
    public $timestamp;
    public $isRead;
    public $actionUrl;
    public $fromUserId;
    public $fromUsername;
    public $fromUserIconUrl;

    public function __construct($data = [])
    {
        $this->id = $data['id'] ?? '';
        $this->type = $data['type'] ?? '';
        $this->title = $data['title'] ?? '';
        $this->content = $data['content'] ?? '';
        $this->timestamp = $data['timestamp'] ?? null;
        $this->isRead = $data['isRead'] ?? false;
        $this->actionUrl = $data['actionUrl'] ?? null;
        $this->fromUserId = $data['fromUserId'] ?? null;
        $this->fromUsername = $data['fromUsername'] ?? null;
        $this->fromUserIconUrl = $data['fromUserIconUrl'] ?? null;
    }

    public function toArray()
    {
        return [
            'id' => $this->id,
            'type' => $this->type,
            'title' => $this->title,
            'content' => $this->content,
            'timestamp' => $this->timestamp,
            'isRead' => $this->isRead,
            'actionUrl' => $this->actionUrl,
            'fromUserId' => $this->fromUserId,
            'fromUsername' => $this->fromUsername,
            'fromUserIconUrl' => $this->fromUserIconUrl,
        ];
    }
}

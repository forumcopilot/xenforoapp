<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Conversation Inbox Stat Result
 * Maps from InboxStatData_Output
 */
class FCConversationInboxStatResult extends FCResult
{
    public $totalConversations;
    public $unreadConversations;
    public $unreadMessages;
    public $unreadAlerts;

    public function __construct($result = true, $resultText = 'success', $totalConversations = 0, $unreadConversations = 0, $unreadMessages = 0, $unreadAlerts = 0)
    {
        parent::__construct($result, $resultText);
        $this->totalConversations = $totalConversations;
        $this->unreadConversations = $unreadConversations;
        $this->unreadMessages = $unreadMessages;
        $this->unreadAlerts = $unreadAlerts;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalConversations'] = $this->totalConversations;
        $data['unreadConversations'] = $this->unreadConversations;
        $data['unreadMessages'] = $this->unreadMessages;
        $data['unreadAlerts'] = $this->unreadAlerts;
        return $data;
    }
}


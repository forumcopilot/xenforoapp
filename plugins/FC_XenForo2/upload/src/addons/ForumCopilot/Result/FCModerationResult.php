<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Stick Topic Result
 * Maps from StickTopicData_Output
 */
class FCStickTopicResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Close Topic Result
 * Maps from CloseTopicData_Output
 */
class FCCloseTopicResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Close Conversation Result
 * Maps from CloseConversationData_Output
 */
class FCCloseConversationResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Delete Topic Result
 * Maps from DeleteTopicData_Output
 */
class FCDeleteTopicResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Delete Post Result
 * Maps from DeletePostData_Output
 */
class FCDeletePostResult extends FCResult
{
    public $isLoginMod;
    /** @var bool|null Whether the whole thread went with its first post (since 1.11.0) */
    public $threadDeleted;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true, $threadDeleted = null)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
        $this->threadDeleted = $threadDeleted;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        if ($this->threadDeleted !== null) {
            $data['threadDeleted'] = $this->threadDeleted;
        }
        return $data;
    }
}

/**
 * ForumCopilot Undelete Topic Result
 * Maps from UndeleteTopicData_Output
 */
class FCUndeleteTopicResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Undelete Post Result
 * Maps from UndeletePostData_Output
 */
class FCUndeletePostResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Move Topic Result
 * Maps from MoveTopicData_Output
 */
class FCMoveTopicResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Rename Topic Result
 * Maps from RenameTopicData_Output
 */
class FCRenameTopicResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Approve Topic Result
 * Maps from ApproveTopicData_Output
 */
class FCApproveTopicResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Approve Post Result
 * Maps from ApprovePostData_Output
 */
class FCApprovePostResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Ban User Result
 * Maps from BanUserData_Output
 */
class FCBanUserResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Unban User Result
 * Maps from UnbanUserData_Output
 */
class FCUnbanUserResult extends FCResult
{
    public $isLoginMod;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true)
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        return $data;
    }
}

/**
 * ForumCopilot Spam Clean User Result
 * Maps from SpamCleanUserData_Output
 */
class FCSpamCleanUserResult extends FCResult
{
    public $userId;
    public $username;
    public $actions;

    public function __construct($result = true, $resultText = 'success', $data = [])
    {
        parent::__construct($result, $resultText);
        $this->userId = $data['userId'] ?? '';
        $this->username = $data['username'] ?? '';
        $this->actions = $data['actions'] ?? [];
    }

    public function toArray()
    {
        $data = parent::toArray();
        
        if ($this->result) {
            $data['userId'] = $this->userId;
            $data['username'] = $this->username;
            $data['actions'] = $this->actions;
        }
        
        return $data;
    }
}


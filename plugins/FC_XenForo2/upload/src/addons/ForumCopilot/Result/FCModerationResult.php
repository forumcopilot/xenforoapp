<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Login Mod Result
 * Maps from LoginModData_Output
 */
class FCLoginModResult extends FCResult
{
    public function __construct($result = true, $resultText = 'success')
    {
        parent::__construct($result, $resultText);
    }

    public function toArray()
    {
        return parent::toArray();
    }
}

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
 * ForumCopilot Move Post Result
 * Maps from MovePostData_Output
 */
class FCMovePostResult extends FCResult
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
 * ForumCopilot Merge Topic Result
 * Maps from MergeTopicData_Output
 */
class FCMergeTopicResult extends FCResult
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
 * ForumCopilot Moderate Topic Result
 * Maps from ModerateTopicData_Output
 */
class FCModerateTopicResult extends FCResult
{
    public $isLoginMod;
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true, $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot Moderate Post Result
 * Maps from ModeratePostData_Output
 */
class FCModeratePostResult extends FCResult
{
    public $isLoginMod;
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true, $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot Deleted Topic Result
 * Maps from DeletedTopicData_Output
 */
class FCDeletedTopicResult extends FCResult
{
    public $isLoginMod;
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true, $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot Deleted Post Result
 * Maps from DeletedPostData_Output
 */
class FCDeletedPostResult extends FCResult
{
    public $isLoginMod;
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true, $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot Reported Post Result
 * Maps from ReportedPostData_Output
 */
class FCReportedPostResult extends FCResult
{
    public $isLoginMod;
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $isLoginMod = true, $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->isLoginMod = $isLoginMod;
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['isLoginMod'] = $this->isLoginMod;
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
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
 * ForumCopilot Mark As Spam Result
 * Maps from MarkAsSpamData_Output
 */
class FCMarkAsSpamResult extends FCResult
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


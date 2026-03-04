<?php

namespace ForumCopilot\Result;

use ForumCopilot\Entity\FCUser;

/**
 * ForumCopilot Online User Result
 * Maps from OnlineUserData_Output
 */
class FCOnlineUserResult extends FCResult
{
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot User Topic Result
 * Maps from UserTopicData_Output
 */
class FCUserTopicResult extends FCResult
{
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot User Reply Result
 * Maps from UserReplyData_Output
 */
class FCUserReplyResult extends FCResult
{
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        $data['posts'] = $data['list']; // Compatibility alias
        return $data;
    }
}

/**
 * ForumCopilot Recommended User Result
 * Maps from RecomendedUserData_Output
 */
class FCRecommendedUserResult extends FCResult
{
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot Search User Result
 * Maps from SearchUserData_Output
 */
class FCSearchUserResult extends FCResult
{
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot Ignore User Result
 * Maps from IgnoreUserData_Output
 */
class FCIgnoreUserResult extends FCResult
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
 * ForumCopilot Ignored User Result
 * Maps from IgnoredUserData_Output
 */
class FCIgnoredUserResult extends FCResult
{
    public $total;
    public $list;

    public function __construct($result = true, $resultText = 'success', $total = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->total = $total;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['total'] = $this->total;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot Report User Result
 * Maps from ReportUserData_Output
 */
class FCReportUserResult extends FCResult
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


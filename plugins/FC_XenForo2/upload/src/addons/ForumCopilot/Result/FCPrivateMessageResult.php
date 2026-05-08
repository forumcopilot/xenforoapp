<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Report PM Result
 * Maps from ReportPMData_Output
 */
class FCReportPMResult extends FCResult
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
 * ForumCopilot Create Message Result
 * Maps from CreateMessageData_Output
 */
class FCCreateMessageResult extends FCResult
{
    public $msgId;

    public function __construct($result = true, $resultText = 'success', $msgId = '')
    {
        parent::__construct($result, $resultText);
        $this->msgId = $msgId;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['msgId'] = $this->msgId;
        return $data;
    }
}

/**
 * ForumCopilot Box Info Result
 * Maps from BoxInfoData_Output
 */
class FCBoxInfoResult extends FCResult
{
    public $messageRoomCount;
    public $list;

    public function __construct($result = true, $resultText = 'success', $messageRoomCount = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->messageRoomCount = $messageRoomCount;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['messageRoomCount'] = $this->messageRoomCount;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot Box Result
 * Maps from BoxData_Output
 */
class FCBoxResult extends FCResult
{
    public $totalMessageNum;
    public $list;

    public function __construct($result = true, $resultText = 'success', $totalMessageNum = 0, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->totalMessageNum = $totalMessageNum;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalMessageNum'] = $this->totalMessageNum;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

/**
 * ForumCopilot Message Result
 * Maps from MessageData_Output
 */
class FCMessageResult extends FCResult
{
    public $msgId;
    public $subject;
    public $authorId;
    public $authorName;
    public $msgFrom;
    public $msgTo;
    public $iconUrl;
    public $textBody;
    public $msgTime;
    public $isUnread;
    public $canReply;
    public $canForward;
    public $canReport;

    public function __construct($result = true, $resultText = 'success', $msgId = '', $subject = '', $authorId = '', $authorName = '', $msgFrom = null, $msgTo = null, $iconUrl = null, $textBody = '', $msgTime = '', $isUnread = false, $canReply = null, $canForward = null, $canReport = null)
    {
        parent::__construct($result, $resultText);
        $this->msgId = $msgId;
        $this->subject = $subject;
        $this->authorId = $authorId;
        $this->authorName = $authorName;
        $this->msgFrom = $msgFrom;
        $this->msgTo = $msgTo;
        $this->iconUrl = $iconUrl;
        $this->textBody = $textBody;
        $this->msgTime = $msgTime;
        $this->isUnread = $isUnread;
        $this->canReply = $canReply;
        $this->canForward = $canForward;
        $this->canReport = $canReport;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['msgId'] = $this->msgId;
        $data['subject'] = $this->subject;
        $data['authorId'] = $this->authorId;
        $data['authorName'] = $this->authorName;
        if ($this->msgFrom !== null) $data['msgFrom'] = $this->msgFrom;
        if ($this->msgTo !== null) $data['msgTo'] = $this->msgTo;
        if ($this->iconUrl !== null) $data['iconUrl'] = $this->iconUrl;
        $data['textBody'] = $this->textBody;
        $data['msgTime'] = $this->msgTime;
        $data['isUnread'] = $this->isUnread;
        if ($this->canReply !== null) $data['canReply'] = $this->canReply;
        if ($this->canForward !== null) $data['canForward'] = $this->canForward;
        if ($this->canReport !== null) $data['canReport'] = $this->canReport;
        return $data;
    }
}

/**
 * ForumCopilot Quote PM Result
 * Maps from QuotePMData_Output
 */
class FCQuotePMResult extends FCResult
{
    public $quoteText;
    public $authorName;

    public function __construct($result = true, $resultText = 'success', $quoteText = null, $authorName = null)
    {
        parent::__construct($result, $resultText);
        $this->quoteText = $quoteText;
        $this->authorName = $authorName;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->quoteText !== null) $data['quoteText'] = $this->quoteText;
        if ($this->authorName !== null) $data['authorName'] = $this->authorName;
        return $data;
    }
}

/**
 * ForumCopilot Delete Message Result
 * Maps from DeleteMessageData_Output
 */
class FCDeleteMessageResult extends FCResult
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
 * ForumCopilot Mark PM Unread Result
 * Maps from MarkPMUnreadData_Output
 */
class FCMarkPMUnreadResult extends FCResult
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
 * ForumCopilot Mark PM Read Result
 * Maps from MarkPMReadData_Output
 */
class FCMarkPMReadResult extends FCResult
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


<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Conversation Result
 * Maps from ConversationData_Output
 */
class FCConversationResult extends FCResult
{
    public $convId;
    public $subject;
    public $convTitle;
    public $messages;
    public $participants;
    public $participantCount;
    public $canReply;
    public $canInvite;
    public $canEdit;
    public $canClose;
    public $isClosed;
    public $canUpload;

    public function __construct($result = true, $resultText = 'success', $convId = '', $subject = null, $convTitle = null, $messages = [], $participants = [], $participantCount = null, $canReply = null, $canInvite = null, $canEdit = null, $canClose = null, $isClosed = null, $canUpload = null)
    {
        parent::__construct($result, $resultText);
        $this->convId = $convId;
        $this->subject = $subject;
        $this->convTitle = $convTitle;
        $this->messages = $messages;
        $this->participants = $participants;
        $this->participantCount = $participantCount;
        $this->canReply = $canReply;
        $this->canInvite = $canInvite;
        $this->canEdit = $canEdit;
        $this->canClose = $canClose;
        $this->isClosed = $isClosed;
        $this->canUpload = $canUpload;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['convId'] = $this->convId;
        if ($this->subject !== null) $data['subject'] = $this->subject;
        if ($this->convTitle !== null) $data['convTitle'] = $this->convTitle;
        $data['messages'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->messages);
        $data['list'] = $data['messages']; // Compatibility alias
        $data['participants'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->participants);
        if ($this->participantCount !== null) $data['participantCount'] = $this->participantCount;
        if ($this->canReply !== null) $data['canReply'] = $this->canReply;
        if ($this->canInvite !== null) $data['canInvite'] = $this->canInvite;
        if ($this->canEdit !== null) $data['canEdit'] = $this->canEdit;
        if ($this->canClose !== null) $data['canClose'] = $this->canClose;
        if ($this->isClosed !== null) $data['isClosed'] = $this->isClosed;
        if ($this->canUpload !== null) $data['canUpload'] = $this->canUpload;
        return $data;
    }
}

/**
 * ForumCopilot Raw Conversation Result
 * Maps from RawConversationData_Output
 */
class FCRawConversationResult extends FCResult
{
    public $conversationTitle;
    public $openInvite;
    public $conversationOpen;
    public $canEdit;

    public function __construct($result = true, $resultText = 'success', $conversationTitle = null, $openInvite = false, $conversationOpen = true, $canEdit = false)
    {
        parent::__construct($result, $resultText);
        $this->conversationTitle = $conversationTitle;
        $this->openInvite = $openInvite;
        $this->conversationOpen = $conversationOpen;
        $this->canEdit = $canEdit;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->conversationTitle !== null) $data['conversationTitle'] = $this->conversationTitle;
        $data['openInvite'] = $this->openInvite;
        $data['conversationOpen'] = $this->conversationOpen;
        $data['canEdit'] = $this->canEdit;
        return $data;
    }
}

/**
 * ForumCopilot Save Raw Conversation Result
 * Maps from SaveRawConversationData_Output
 */
class FCSaveRawConversationResult extends FCResult
{
    public $conversationTitle;

    public function __construct($result = true, $resultText = 'success', $conversationTitle = null)
    {
        parent::__construct($result, $resultText);
        $this->conversationTitle = $conversationTitle;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->conversationTitle !== null) $data['conversationTitle'] = $this->conversationTitle;
        return $data;
    }
}

/**
 * ForumCopilot Raw Message Result
 * Maps from RawMessageData_Output
 */
class FCRawMessageResult extends FCResult
{
    public $messageContent;
    public $attachments;

    public function __construct($result = true, $resultText = 'success', $messageContent = null, $attachments = [])
    {
        parent::__construct($result, $resultText);
        $this->messageContent = $messageContent;
        $this->attachments = $attachments;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->messageContent !== null) $data['messageContent'] = $this->messageContent;
        // Convert attachments to arrays if they are FCAttachment objects
        $attachmentsArray = [];
        if (is_array($this->attachments)) {
            foreach ($this->attachments as $attachment) {
                if (is_object($attachment) && method_exists($attachment, 'toArray')) {
                    $attachmentsArray[] = $attachment->toArray();
                } else {
                    $attachmentsArray[] = $attachment;
                }
            }
        }
        $data['attachments'] = $attachmentsArray;
        return $data;
    }
}

/**
 * ForumCopilot Save Raw Message Result
 * Maps from SaveRawMessageData_Output
 */
class FCSaveRawMessageResult extends FCResult
{
    public $messageContent;

    public function __construct($result = true, $resultText = 'success', $messageContent = null)
    {
        parent::__construct($result, $resultText);
        $this->messageContent = $messageContent;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->messageContent !== null) $data['messageContent'] = $this->messageContent;
        return $data;
    }
}


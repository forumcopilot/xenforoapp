<?php

namespace ForumCopilot\Result;

use ForumCopilot\Entity\FCUser;

/**
 * ForumCopilot Login Result
 * Forum-agnostic login result that can be reused across different forum plugins
 */
class FCLoginResult extends FCResult
{
    public $user;
    public $canWhosonline;
    public $canProfile;
    public $canUploadAvatar;
    public $maxAttachment;
    public $maxPngSize;
    public $maxJpgSize;
    // New attachment fields
    public $canUploadAttachment;
    public $canUploadConversationAttachment;
    public $maxAttachmentSize;
    public $allowedFileExtensions;
    public $maxImageWidth;
    public $maxImageHeight;

    public function __construct($result = true, $resultText = 'success', $user = null, $canWhosonline = false, $canProfile = false, $canUploadAvatar = false, $maxAttachment = 0, $maxPngSize = 0, $maxJpgSize = 0, $canUploadAttachment = false, $canUploadConversationAttachment = false, $maxAttachmentSize = 0, $allowedFileExtensions = [], $maxImageWidth = 0, $maxImageHeight = 0)
    {
        parent::__construct($result, $resultText);
        $this->user = $user;
        $this->canWhosonline = $canWhosonline;
        $this->canProfile = $canProfile;
        $this->canUploadAvatar = $canUploadAvatar;
        $this->maxAttachment = $maxAttachment;
        $this->maxPngSize = $maxPngSize;
        $this->maxJpgSize = $maxJpgSize;
        $this->canUploadAttachment = $canUploadAttachment;
        $this->canUploadConversationAttachment = $canUploadConversationAttachment;
        $this->maxAttachmentSize = $maxAttachmentSize;
        $this->allowedFileExtensions = $allowedFileExtensions;
        $this->maxImageWidth = $maxImageWidth;
        $this->maxImageHeight = $maxImageHeight;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['user'] = $this->user ? $this->user->toArray() : null;
        $data['canWhosonline'] = $this->canWhosonline;
        $data['canProfile'] = $this->canProfile;
        $data['canUploadAvatar'] = $this->canUploadAvatar;
        $data['maxAttachment'] = $this->maxAttachment;
        $data['maxPngSize'] = $this->maxPngSize;
        $data['maxJpgSize'] = $this->maxJpgSize;
        $data['canUploadAttachment'] = $this->canUploadAttachment;
        $data['canUploadConversationAttachment'] = $this->canUploadConversationAttachment;
        $data['maxAttachmentSize'] = $this->maxAttachmentSize;
        $data['allowedFileExtensions'] = $this->allowedFileExtensions;
        $data['maxImageWidth'] = $this->maxImageWidth;
        $data['maxImageHeight'] = $this->maxImageHeight;
        return $data;
    }
}

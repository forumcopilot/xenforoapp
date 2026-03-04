<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Attachment Upload Result
 * Maps from UploadData_Output
 */
class FCAttachmentUploadResult extends FCResult
{
    public $attachmentId;
    public $fileName;
    public $groupId;
    public $fileSize;
    
    // Additional metadata fields (like web version)
    public $thumbnailUrl;
    public $width;
    public $height;
    public $icon;
    public $iconName;
    public $isVideo;
    public $isAudio;
    public $link;
    public $typeGrouping;
    public $fileSizePrintable;
    
    // Additional metadata array for handler-specific data
    private $additionalMetadata = [];

    public function __construct($result = true, $resultText = 'success', $attachmentId = null, $fileName = null, $groupId = null, $fileSize = null)
    {
        parent::__construct($result, $resultText);
        $this->attachmentId = $attachmentId;
        $this->fileName = $fileName;
        $this->groupId = $groupId;
        $this->fileSize = $fileSize;
    }
    
    /**
     * Add additional metadata (for handler-specific data)
     */
    public function addMetadata(array $metadata)
    {
        $this->additionalMetadata = array_merge($this->additionalMetadata, $metadata);
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->attachmentId !== null) $data['attachmentId'] = $this->attachmentId;
        if ($this->fileName !== null) $data['fileName'] = $this->fileName;
        if ($this->groupId !== null) $data['groupId'] = $this->groupId;
        if ($this->fileSize !== null) $data['fileSize'] = $this->fileSize;
        
        // Add additional metadata fields
        if ($this->thumbnailUrl !== null) $data['thumbnailUrl'] = $this->thumbnailUrl;
        if ($this->width !== null) $data['width'] = $this->width;
        if ($this->height !== null) $data['height'] = $this->height;
        if ($this->icon !== null) $data['icon'] = $this->icon;
        if ($this->iconName !== null) $data['iconName'] = $this->iconName;
        if ($this->isVideo !== null) $data['isVideo'] = $this->isVideo;
        if ($this->isAudio !== null) $data['isAudio'] = $this->isAudio;
        if ($this->link !== null) $data['link'] = $this->link;
        if ($this->typeGrouping !== null) $data['typeGrouping'] = $this->typeGrouping;
        if ($this->fileSizePrintable !== null) $data['fileSizePrintable'] = $this->fileSizePrintable;
        
        // Merge additional metadata
        if (!empty($this->additionalMetadata)) {
            $data = array_merge($data, $this->additionalMetadata);
        }
        
        return $data;
    }
}

/**
 * ForumCopilot Attachment Remove Result
 * Maps from RemoveAttachmentData_Output
 */
class FCAttachmentRemoveResult extends FCResult
{
    public $groupId;

    public function __construct($result = true, $resultText = 'success', $groupId = null)
    {
        parent::__construct($result, $resultText);
        $this->groupId = $groupId;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->groupId !== null) $data['groupId'] = $this->groupId;
        return $data;
    }
}

/**
 * ForumCopilot Tapatalk Image Upload Result
 * Maps from UploadTapatalkImageData_Output
 */
class FCTapatalkImageUploadResult extends FCResult
{
    public $imageUrl;
    public $imageId;
    public $thumbnailUrl;

    public function __construct($result = true, $resultText = 'success', $imageUrl = null, $imageId = null, $thumbnailUrl = null)
    {
        parent::__construct($result, $resultText);
        $this->imageUrl = $imageUrl;
        $this->imageId = $imageId;
        $this->thumbnailUrl = $thumbnailUrl;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->imageUrl !== null) $data['imageUrl'] = $this->imageUrl;
        if ($this->imageId !== null) $data['imageId'] = $this->imageId;
        if ($this->thumbnailUrl !== null) $data['thumbnailUrl'] = $this->thumbnailUrl;
        return $data;
    }
}


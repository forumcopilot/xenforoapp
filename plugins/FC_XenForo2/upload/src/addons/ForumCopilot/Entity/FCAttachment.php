<?php

namespace ForumCopilot\Entity;

/**
 * ForumCopilot Attachment Entity
 * Forum-agnostic attachment representation that can be reused across different forum plugins
 */
class FCAttachment
{
    public $id;
    public $fileName;
    public $fileSize;
    public $mimeType;
    public $url;
    public $thumbnailUrl;
    public $groupId;
    public $isImage;
    public $width;
    public $height;
    public $canViewUrl;
    public $canViewThumbnailUrl;
    public $isInline;

    public function __construct($data = [])
    {
        $this->id = $data['id'] ?? '';
        $this->fileName = $data['fileName'] ?? '';
        $this->fileSize = $data['fileSize'] ?? 0;
        $this->mimeType = $data['mimeType'] ?? '';
        $this->url = $data['url'] ?? '';
        $this->thumbnailUrl = $data['thumbnailUrl'] ?? null;
        $this->groupId = $data['groupId'] ?? '';
        $this->isImage = $data['isImage'] ?? false;
        $this->width = $data['width'] ?? null;
        $this->height = $data['height'] ?? null;
        $this->canViewUrl = $data['canViewUrl'] ?? false;
        $this->canViewThumbnailUrl = $data['canViewThumbnailUrl'] ?? false;
        $this->isInline = $data['isInline'] ?? false;
    }

    public function toArray()
    {
        return [
            'id' => $this->id,
            'fileName' => $this->fileName,
            'fileSize' => $this->fileSize,
            'mimeType' => $this->mimeType,
            'url' => $this->url,
            'thumbnailUrl' => $this->thumbnailUrl,
            'groupId' => $this->groupId,
            'isImage' => $this->isImage,
            'width' => $this->width,
            'height' => $this->height,
            'canViewUrl' => $this->canViewUrl,
            'canViewThumbnailUrl' => $this->canViewThumbnailUrl,
            'isInline' => $this->isInline,
        ];
    }
}

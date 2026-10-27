<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
use XF\Mvc\ParameterBag;
use XF\Http\Upload;
use ForumCopilot\Result\FCAttachmentUploadResult;
use ForumCopilot\Result\FCAttachmentRemoveResult;
use ForumCopilot\Result\FCTapatalkImageUploadResult;

// Explicitly require FCAttachmentResult.php which contains multiple Result classes
// This ensures all classes in that file are loaded
require_once(__DIR__ . '/../../Result/FCAttachmentResult.php');

/**
 * Attachment Controller for ForumCopilot API
 * Handles file uploads and attachment management
 */
class AttachmentController extends AbstractController
{
    public function actionUploadAttachment(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $type = $params->get('type', '');
        $id = $params->get('id', '');
        $groupId = $params->get('groupId', '');
        $attachmentName = $params->get('attachmentName', '');
        // Accept both attachmentData and attachmentBytes for compatibility
        $attachmentData = $params->get('attachmentData', $params->get('attachmentBytes', ''));

        // Validate required fields
        // Empty ID is allowed for conversation_message attachments (drafts), but required for other types
        $isConversationType = ($type === 'pm' || $type === 'conversation_message');
        if (empty($type) || empty($attachmentName) || empty($attachmentData)) {
            return $this->apiError('Type, attachment name, and data are required', null, ErrorCode::VALIDATION);
        }
        if (!$isConversationType && empty($id)) {
            return $this->apiError('ID is required for ' . $type . ' attachments', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            
            // Decode base64 data
            $fileData = base64_decode($attachmentData);
            if ($fileData === false) {
                return $this->apiError('Invalid attachment data', null, ErrorCode::VALIDATION);
            }

            // Create temporary file with proper extension
            $extension = strtolower(pathinfo($attachmentName, PATHINFO_EXTENSION));
            $tempFile = tempnam(sys_get_temp_dir(), 'fc_upload_') . '.' . $extension;
            file_put_contents($tempFile, $fileData);

            // Determine content type and context
            $contentType = 'post';
            $contentData = [];
            if ($type === 'pm' || $type === 'conversation_message') {
                $contentType = 'conversation_message';
                // Set conversation_id for conversation_message attachments
                // The handler requires conversation_id in contentData for permission checks
                // Empty id is allowed for new conversation drafts
                if (!empty($id)) {
                    $contentData['conversation_id'] = (int)$id;
                }
            } else {
                // For forum posts
                $contentData['node_id'] = $id;
            }

            // Get attachment handler and manipulator (like Tapatalk does)
            $attachmentRepo = $this->repository('XF:Attachment');
            $handler = $attachmentRepo->getAttachmentHandler($contentType);
            if (!$handler) {
                unlink($tempFile);
                return $this->apiError('Invalid content type', null, ErrorCode::BAD_REQUEST);
            }

            if (!$handler->canManageAttachments($contentData, $error)) {
                unlink($tempFile);
                return $this->apiError('Cannot manage attachments: ' . ($error ? $error : 'Permission denied'), null, ErrorCode::NO_PERMISSION);
            }

            // Generate or use provided hash
            if (empty($groupId)) {
                $hash = md5(uniqid('', true));
            } else {
                $hash = $groupId;
            }

            // Create XF\Http\Upload object from temp file
            $uploadFile = [
                'tmp_name' => $tempFile,
                'name' => $attachmentName,
                'error' => UPLOAD_ERR_OK,
                'size' => filesize($tempFile),
                'type' => mime_content_type($tempFile),
            ];
            $upload = new Upload($tempFile, $attachmentName, UPLOAD_ERR_OK);

            // Use Attachment Manipulator (like Tapatalk does)
            $manipulator = new \XF\Attachment\Manipulator($handler, $attachmentRepo, $contentData, $hash);
            
            if (!$manipulator->canUpload($uploadError)) {
                unlink($tempFile);
                return $this->apiError('Cannot upload: ' . ($uploadError ? $uploadError : 'Permission denied'), null, ErrorCode::NO_PERMISSION);
            }

            // Insert attachment from upload
            $attachment = $manipulator->insertAttachmentFromUpload($upload, $error);
            if (!$attachment) {
                unlink($tempFile);
                return $this->apiError('Failed to upload attachment: ' . ($error ? $error : 'Unknown error'), null, ErrorCode::VALIDATION);
            }

            // Clean up temp file (manipulator should have moved it)
            if (file_exists($tempFile)) {
                unlink($tempFile);
            }

            $result = new FCAttachmentUploadResult(
                true,
                null,
                (string)$attachment->attachment_id,
                $attachmentName,
                $hash,
                $attachment->Data->file_size
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            // Clean up temp file if it exists
            if (isset($tempFile) && file_exists($tempFile)) {
                @unlink($tempFile);
            }
            return $this->apiException($e, 'Failed to upload attachment');
        }
    }

    public function actionRemoveAttachment(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $attachmentId = $params->get('attachmentId', '');
        $groupId = $params->get('groupId', '');

        // Validate attachment ID is provided and is a positive integer
        if (empty($attachmentId) || !is_numeric($attachmentId) || (int)$attachmentId <= 0) {
            return $this->apiError('Attachment ID is required and must be a positive integer', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // First, load the attachment to check if it's temporary or existing
            $attachment = $this->em()->find('XF:Attachment', (int)$attachmentId, ['Data']);
            if (!$attachment) {
                return $this->apiError('Attachment not found', null, ErrorCode::NOT_FOUND);
            }

            // For temporary attachments, validate hash
            // For existing attachments, hash is not needed - just check permissions
            if ($attachment->temp_hash) {
                // This is a temporary attachment - validate hash
                if (empty($groupId)) {
                    return $this->apiError('Hash must be specified for temporary attachments', null, ErrorCode::BAD_REQUEST);
                }
                if ($attachment->temp_hash !== $groupId) {
                    return $this->apiError('Invalid hash', null, ErrorCode::VALIDATION);
                }
            } else {
                // This is an existing attachment - check view permission only (no hash needed)
                $error = null;
                if (!$attachment->canView($error)) {
                    return $this->apiError($error ?: 'Cannot view attachment', null, ErrorCode::NO_PERMISSION);
                }
            }

            $attachmentRepo = $this->repository('XF:Attachment');
            $handler = $attachmentRepo->getAttachmentHandler($attachment->content_type);
            
            if (!$handler) {
                return $this->apiError('Invalid attachment handler', null, ErrorCode::BAD_REQUEST);
            }

            // For existing attachments, check container and manage permissions
            if (!$attachment->temp_hash) {
                $container = $attachment->Container;
                if (!$container) {
                    return $this->apiError('Attachment container not found', null, ErrorCode::NOT_FOUND);
                }

                $context = $handler->getContext($container);
                if (!$handler->canManageAttachments($context, $error)) {
                    return $this->apiError('Cannot manage attachments: ' . ($error ?: 'Permission denied'), null, ErrorCode::NO_PERMISSION);
                }
            }
            
            // Capture temp_hash before deletion
            $hash = $attachment->temp_hash ?: null;
            
            // Delete attachment
            $attachment->delete();

            $result = new FCAttachmentRemoveResult(true, null, $hash);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to remove attachment');
        }
    }

    public function actionUploadAvatar(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $imageExtension = $params->get('imageExtension', '');
        // Accept both attachmentData and attachmentBytes for compatibility
        $attachmentData = $params->get('attachmentData', $params->get('attachmentBytes', ''));

        if (empty($imageExtension) || empty($attachmentData)) {
            return $this->apiError('Image extension and data are required', null, ErrorCode::VALIDATION);
        }

        // Only an image type XenForo's avatar service takes; the extension
        // names the uploaded file and nothing else
        $imageExtension = strtolower(ltrim(trim((string)$imageExtension), '.'));
        if (!in_array($imageExtension, ['gif', 'jpg', 'jpeg', 'jpe', 'png', 'webp'], true)) {
            return $this->apiError(\XF::phrase('uploaded_file_must_be_valid_image'), null, ErrorCode::VALIDATION);
        }

        try {
            $visitor = \XF::visitor();
            
            if (!$visitor->canUploadAvatar()) {
                return $this->apiError('Cannot upload avatar', null, ErrorCode::NO_PERMISSION);
            }

            // Decode base64 data
            $fileData = base64_decode($attachmentData);
            if ($fileData === false) {
                return $this->apiError('Invalid image data', null, ErrorCode::VALIDATION);
            }

            // XenForo's own temporary file; the avatar service reads the image
            // type from the contents and the extension from the upload's name
            $tempFile = \XF\Util\File::getTempFile();
            file_put_contents($tempFile, $fileData);

            // Use XenForo's Avatar service (like Tapatalk does)
            // The service will validate the image internally
            /** @var \XF\Service\User\Avatar $avatarService */
            $avatarService = $this->service('XF:User\Avatar', $visitor);

            // Create XF\Http\Upload object from temp file
            $upload = new Upload($tempFile, 'avatar.' . $imageExtension, UPLOAD_ERR_OK);

            // Set image from upload
            if (!$avatarService->setImageFromUpload($upload)) {
                unlink($tempFile);
                return $this->apiError('Failed to process image: ' . ($avatarService->getError() ?: 'Unknown error'), null, ErrorCode::VALIDATION);
            }

            // Update avatar
            if (!$avatarService->updateAvatar()) {
                unlink($tempFile);
                return $this->apiError('Failed to update avatar', null, ErrorCode::VALIDATION);
            }

            // Refresh visitor to get updated avatar info
            $visitor = \XF::visitor();

            $fileSize = filesize($tempFile);
            unlink($tempFile);

            $result = new FCTapatalkImageUploadResult(
                true,
                null,
                (string)$visitor->user_id, // Use user_id as image ID
                'avatar.' . $imageExtension,
                '',
                $fileSize
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            // Clean up temp file if it exists
            if (isset($tempFile) && file_exists($tempFile)) {
                @unlink($tempFile);
            }
            return $this->apiException($e, 'Failed to upload avatar');
        }
    }
}

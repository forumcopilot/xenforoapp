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
        // Optional, for posts: the post being edited or the thread being
        // replied to. XenForo's editor uploads in that context, so the
        // per-message attachment limit counts the post's own files too.
        $postId = (int)$params->get('postId', 0);
        $threadId = (int)$params->get('threadId', 0);

        // Validate required fields
        // Empty ID is allowed for conversation_message attachments (drafts), but required for other types
        $isConversationType = ($type === 'pm' || $type === 'conversation_message');
        if (empty($type) || empty($attachmentName) || empty($attachmentData)) {
            return $this->apiError('Type, attachment name, and data are required', null, ErrorCode::VALIDATION);
        }
        if (!$isConversationType && empty($id) && !$postId && !$threadId) {
            return $this->apiError('ID is required for ' . $type . ' attachments', null, ErrorCode::BAD_REQUEST);
        }

        // An upload hash is at most 32 characters (XenForo's
        // AttachmentController::actionUpload); ours and XenForo's are md5 hex
        $groupId = is_string($groupId) ? trim($groupId) : '';
        if ($groupId !== '' && !preg_match('/^[a-zA-Z0-9]{1,32}$/', $groupId)) {
            return $this->apiError('Invalid groupId', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // Decode base64 data
            $fileData = base64_decode($attachmentData);
            if ($fileData === false) {
                return $this->apiError('Invalid attachment data', null, ErrorCode::VALIDATION);
            }

            // Determine content type and context
            $contentType = 'post';
            $contentData = [];
            if ($isConversationType) {
                $contentType = 'conversation_message';
                // Set conversation_id for conversation_message attachments
                // The handler requires conversation_id in contentData for permission checks
                // Empty id is allowed for new conversation drafts
                if (!empty($id)) {
                    $contentData['conversation_id'] = (int)$id;
                }
            } elseif ($postId) {
                // An edit: the handler checks the member may view and edit
                // the post (Attachment\PostHandler::getForumFromContext)
                $contentData['post_id'] = $postId;
            } elseif ($threadId) {
                $contentData['thread_id'] = $threadId;
            } else {
                // A new thread, or a reply from an app that sends only the forum
                $contentData['node_id'] = (int)$id;
            }

            // Get attachment handler and manipulator (like Tapatalk does)
            $attachmentRepo = $this->repository('XF:Attachment');
            $handler = $attachmentRepo->getAttachmentHandler($contentType);
            if (!$handler) {
                return $this->apiError('Invalid content type', null, ErrorCode::BAD_REQUEST);
            }

            if (!$handler->canManageAttachments($contentData, $error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            // A new upload hash the way XenForo makes one
            // (AttachmentRepository::getEditorData)
            $hash = $groupId !== '' ? $groupId : md5(microtime(true) . \XF::generateRandomString(8, true));

            // XenForo's own temporary file, removed at the end of the request.
            // The member's file name only names the upload (its extension is
            // checked against the forum's allowed types); it is never part of
            // a path.
            $tempFile = \XF\Util\File::getTempFile();
            file_put_contents($tempFile, $fileData);
            $fileName = basename(str_replace('\\', '/', (string)$attachmentName));
            $upload = new Upload($tempFile, $fileName, UPLOAD_ERR_OK);

            // XenForo's Attachment Manipulator, as its upload page creates it
            $class = \XF::extendClass('XF\Attachment\Manipulator');
            $manipulator = new $class($handler, $attachmentRepo, $contentData, $hash);

            if (!$manipulator->canUpload($uploadError)) {
                return $this->apiError($uploadError ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            // Insert attachment from upload
            $attachment = $manipulator->insertAttachmentFromUpload($upload, $error);
            if (!$attachment) {
                return $this->apiError($error ?: \XF::phrase('something_went_wrong_please_try_again'), null, ErrorCode::VALIDATION);
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

        } catch (\Throwable $e) {
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
                // and only the member's own upload
                if (!$attachment->Data || $attachment->Data->user_id != \XF::visitor()->user_id) {
                    return $this->apiError(\XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
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

        } catch (\Throwable $e) {
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
                return $this->apiError(\XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            // Decode base64 data
            $fileData = base64_decode($attachmentData);
            if ($fileData === false) {
                return $this->apiError('Invalid image data', null, ErrorCode::VALIDATION);
            }

            // XenForo's own temporary file, removed at the end of the request;
            // the avatar service reads the image type from the contents and the
            // extension from the upload's name
            $tempFile = \XF\Util\File::getTempFile();
            file_put_contents($tempFile, $fileData);

            // Use XenForo's Avatar service, as AccountController::actionAvatar
            /** @var \XF\Service\User\Avatar $avatarService */
            $avatarService = $this->service('XF:User\Avatar', $visitor);

            // Create XF\Http\Upload object from temp file
            $upload = new Upload($tempFile, 'avatar.' . $imageExtension, UPLOAD_ERR_OK);

            // Set image from upload: XenForo's message when it isn't a usable image
            if (!$avatarService->setImageFromUpload($upload)) {
                return $this->apiError($avatarService->getError() ?: \XF::phrase('uploaded_file_must_be_valid_image'), null, ErrorCode::VALIDATION);
            }

            if (!$avatarService->updateAvatar()) {
                return $this->apiError(\XF::phrase('something_went_wrong_please_try_again'), null, ErrorCode::VALIDATION);
            }

            // The new avatar: imageUrl is its full-size URL, and the fields the
            // SDK reads (attachmentId, fileName, fileSize) are filled. imageUrl
            // was the member's id and imageId the file name before 1.11.0.
            $result = new FCTapatalkImageUploadResult(
                true,
                null,
                $this->getAbsoluteUrl($visitor->getAvatarUrl('o', null, true)),
                (string)$visitor->user_id,
                $this->getAbsoluteUrl($visitor->getAvatarUrl('s', null, true)),
                (string)$visitor->user_id,
                'avatar.' . $imageExtension,
                strlen($fileData)
            );

            return $this->apiSuccess($result);

        } catch (\Throwable $e) {
            return $this->apiException($e, 'Failed to upload avatar');
        }
    }
}

<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;
use XF\Service\Conversation\CreatorService;
use XF\Service\Conversation\ReplierService;
use XF\Service\Conversation\InviterService;
use ForumCopilot\Result\FCNewConversationResult;
use ForumCopilot\Result\FCReplyConversationResult;
use ForumCopilot\Result\FCConversationsResult;
use ForumCopilot\Result\FCConversationResult;
use ForumCopilot\Result\FCConversationInboxStatResult;
use ForumCopilot\Result\FCMarkConversationReadResult;
use ForumCopilot\Result\FCMarkConversationUnreadResult;
use ForumCopilot\Result\FCCloseConversationResult;
use ForumCopilot\Result\FCLeaveConversationResult;
use ForumCopilot\Result\FCInviteParticipantResult;
use ForumCopilot\Result\FCQuoteConversationResult;
use ForumCopilot\Result\FCLikePostResult;
use ForumCopilot\Result\FCRawConversationResult;
use ForumCopilot\Result\FCSaveRawConversationResult;
use ForumCopilot\Result\FCRawMessageResult;
use ForumCopilot\Result\FCSaveRawMessageResult;
use XF\Service\Conversation\EditorService;
use XF\Service\Conversation\MessageEditorService;
use ForumCopilot\Result\FCUnlikePostResult;

/**
 * Private Conversation Controller for ForumCopilot API
 * Handles XenForo conversation operations
 */
class PrivateConversationController extends AbstractController
{
    public function actionNewConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userName = $params->get('userName', []);
        $subject = $params->get('subject', '');
        $textBody = $params->get('textBody', '');
        $attachmentIds = $params->get('attachmentIds', []);
        $groupId = $params->get('groupId', '');
        
        // Optional parameters for conversation settings
        $openInvite = $params->get('openInvite', false);
        $conversationLocked = $params->get('conversationLocked', false);

        if (empty($userName) || empty($subject) || empty($textBody)) {
            return $this->apiError('Username, subject, and content are required');
        }

        try {
            $visitor = \XF::visitor();

            // Validate users and build recipients string (like Tapatalk does)
            $validUsernames = [];
            foreach ($userName as $username) {
                $user = $this->em()->findOne('XF:User', ['username' => $username]);
                if ($user && $visitor->canStartConversationWith($user)) {
                    $validUsernames[] = $username;
                }
            }

            if (empty($validUsernames)) {
                return $this->apiError('No valid users found');
            }

            // Use XenForo's Conversation Creator service (like XenForo core does)
            /** @var CreatorService $creator */
            $creator = $this->service(CreatorService::class, $visitor);
            
            // Set options - use provided values or defaults
            $options = [];
            $options['open_invite'] = (bool)$openInvite;
            $options['conversation_open'] = !(bool)$conversationLocked; // Convert locked to open status
            $creator->setOptions($options);
            
            // Set recipients as comma-separated string (like Tapatalk)
            $creator->setRecipients(implode(',', $validUsernames));
            
            // Set content (title and message)
            $creator->setContent($subject, $textBody);

            // Handle attachments if provided (like Tapatalk does)
            // Note: We set attachment hash before getting conversation to avoid entity access issues
            if ($groupId) {
                $creator->setAttachmentHash($groupId);
            } elseif (!empty($attachmentIds) && is_array($attachmentIds)) {
                $attachmentRepo = $this->repository('XF:Attachment');
                $attachments = $attachmentRepo->findByIds($attachmentIds);
                $hashArray = [];
                foreach ($attachments as $attachment) {
                    if ($attachment->canView() && $attachment->temp_hash) {
                        $hashArray[] = $attachment->temp_hash;
                    }
                }
                if ($hashArray) {
                    $creator->setAttachmentHash(implode(',', $hashArray));
                }
            }

            // Validate before saving
            $errors = [];
            if (!$creator->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            // Save conversation (returns ConversationMaster entity, like Tapatalk)
            /** @var \XF\Entity\ConversationMaster $conversation */
            $conversation = $creator->save();
            
            // Finalize conversation creation (like Tapatalk does)
            \XF\Draft::createFromKey('conversation')->delete();
            
            // Send notifications
            $creator->sendNotifications();

            $result = new FCNewConversationResult(
                true,
                null,
                (string)$conversation->conversation_id
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to create conversation: ' . $e->getMessage());
        }
    }

    public function actionReplyConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');
        $textBody = $params->get('textBody', '');
        $attachmentIds = $params->get('attachmentIds', []);
        $groupId = $params->get('groupId', '');

        if (empty($conversationId) || empty($textBody)) {
            return $this->apiError('Conversation ID and content are required');
        }

        try {
            $conversation = $this->em()->find('XF:ConversationMaster', $conversationId);
            if (!$conversation) {
                return $this->apiError('Conversation not found');
            }

            $visitor = \XF::visitor();

            if (!$conversation->canReply()) {
                return $this->apiError('Cannot reply to this conversation');
            }

            // Use XenForo's Conversation Replier service (like XenForo core does)
            /** @var ReplierService $replier */
            $replier = $this->service(ReplierService::class, $conversation, $visitor);
            $replier->setMessageContent($textBody);

            // Handle attachments if provided
            if ($groupId) {
                $replier->setAttachmentHash($groupId);
            } elseif (!empty($attachmentIds) && is_array($attachmentIds)) {
                $attachmentRepo = $this->repository('XF:Attachment');
                $attachments = $attachmentRepo->findByIds($attachmentIds);
                $hashArray = [];
                foreach ($attachments as $attachment) {
                    if ($attachment->canView() && $attachment->temp_hash) {
                        $hashArray[] = $attachment->temp_hash;
                    }
                }
                if ($hashArray) {
                    $replier->setAttachmentHash(implode(',', $hashArray));
                }
            }

            // Validate before saving
            $errors = [];
            if (!$replier->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            // Save reply (returns ConversationMessage entity)
            $message = $replier->save();

            // Send notifications
            $replier->sendNotifications();

            $result = new FCReplyConversationResult(true, null, (string)$message->message_id);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to reply to conversation: ' . $e->getMessage());
        }
    }

    public function actionGetConversations(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $startNum = $params->get('startNum', 0);
        $lastNum = $params->get('lastNum', 19);

        try {
            $visitor = \XF::visitor();
            
            // Use the same finder approach as the web interface for consistent ordering
            // The web uses ConversationUser finder with default order by last_message_date DESC
            $conversationRepo = $this->repository('XF:Conversation');
            $finder = $conversationRepo->findUserConversations($visitor);
            $finder->with('Master.Starter'); // Load starter user for avatar/username
            $finder->with('Master.LastMessageUser'); // Load last message user for avatar/username
            
            // Calculate pagination
            $perPage = $lastNum - $startNum + 1;
            // For limitByPage, calculate correct page number (page 1 = startNum 1-20, page 2 = startNum 21-40, etc.)
            $page = (int)ceil($startNum / $perPage);
            $finder->limitByPage($page, $perPage);
            
            // Fetch ConversationUser entities (not ConversationMaster directly)
            $userConvs = $finder->fetch();
            $total = $finder->total();
            
            // Process ConversationUser entities (which have unread status and are already ordered)
            $conversationList = [];
            foreach ($userConvs as $userConv) {
                try {
                    $conversation = $userConv->Master;
                    if (!$conversation) {
                        continue;
                    }
                    
                    // ConversationUser entity has is_unread property directly
                    $isUnread = (bool)$userConv->is_unread;
                    
                    // Check permissions safely
                    $canReply = false;
                    $canDelete = false;
                    $canInvite = false;
                    $canEdit = false;
                    $canClose = false;
                    $isClosed = false;
                    if (method_exists($conversation, 'canReply')) {
                        $canReply = $conversation->canReply();
                    }
                    if (method_exists($conversation, 'canDelete')) {
                        $canDelete = $conversation->canDelete();
                    }
                    if (method_exists($conversation, 'canInvite')) {
                        $canInvite = $conversation->canInvite();
                    }
                    if (method_exists($conversation, 'canEdit')) {
                        $canEdit = $conversation->canEdit();
                    }
                    // canClose is the same as canEdit - only the creator can close/reopen conversations
                    $canClose = $canEdit;
                    // isClosed is true when conversation_open is false
                    $isClosed = !$conversation->conversation_open;
                    
                    // Get conversation starter info
                    $startUserId = '';
                    $startUsername = '';
                    $startUserIconUrl = '';
                    try {
                        // Use 'Starter' relation (not 'User') - this is the correct relation name in ConversationMaster
                        if ($conversation->Starter) {
                            $startUserId = (string)$conversation->user_id;
                            $startUsername = $conversation->Starter->username;
                            $startUserIconUrl = $this->getAbsoluteUrl($conversation->Starter->getAvatarUrl('s'));
                        } elseif ($conversation->user_id) {
                            // Fallback: load user if not already loaded
                            $starterUser = $this->em()->find('XF:User', $conversation->user_id);
                            if ($starterUser) {
                                $startUserId = (string)$conversation->user_id;
                                $startUsername = $starterUser->username;
                                $startUserIconUrl = $this->getAbsoluteUrl($starterUser->getAvatarUrl('s'));
                            }
                        }
                    } catch (\Exception $e) {
                        // If user loading fails, continue without starter info
                    }
                    
                    // Get last message author info
                    $lastMessageAuthorId = '';
                    $lastMessageAuthorIconUrl = '';
                    try {
                        if ($conversation->LastMessageUser) {
                            $lastMessageAuthorId = (string)$conversation->last_message_user_id;
                            $lastMessageAuthorIconUrl = $this->getAbsoluteUrl($conversation->LastMessageUser->getAvatarUrl('s'));
                        } elseif ($conversation->last_message_user_id) {
                            // Fallback: load user if not already loaded
                            $lastMessageUser = $this->em()->find('XF:User', $conversation->last_message_user_id);
                            if ($lastMessageUser) {
                                $lastMessageAuthorId = (string)$conversation->last_message_user_id;
                                $lastMessageAuthorIconUrl = $this->getAbsoluteUrl($lastMessageUser->getAvatarUrl('s'));
                            }
                        }
                    } catch (\Exception $e) {
                        // If user loading fails, continue without last message author info
                    }
                    
                    // Get participant count (count active recipients)
                    $participantCount = 0;
                    try {
                        if (isset($conversation->recipient_count)) {
                            $participantCount = (int)$conversation->recipient_count;
                        } else {
                            // Fallback: count recipients manually
                            $recipientFinder = $this->finder('XF:ConversationRecipient');
                            $recipientFinder->where('conversation_id', $conversation->conversation_id);
                            $recipientFinder->where('recipient_state', 'active');
                            $participantCount = $recipientFinder->total();
                        }
                    } catch (\Exception $e) {
                        // If counting fails, default to 0
                        $participantCount = 0;
                    }
                    
                    // Get message ID: first unread if unread, otherwise latest message
                    // Also count unread messages if conversation is unread
                    $messageId = null;
                    $unreadMessageCount = 0;
                    
                    if ($isUnread) {
                        try {
                            $messageRepo = $this->repository('XF:ConversationMessage');
                            $firstUnreadMessage = $messageRepo->getFirstUnreadMessageInConversation($userConv);
                            if ($firstUnreadMessage) {
                                $messageId = (string)$firstUnreadMessage->message_id;
                            }
                            
                            // Count unread messages
                            if ($userConv->Recipient) {
                                $lastReadDate = $userConv->Recipient->last_read_date;
                                $unreadMessageFinder = $messageRepo->findNewestMessagesInConversation($conversation, $lastReadDate);
                                $unreadMessageCount = $unreadMessageFinder->total();
                            }
                        } catch (\Exception $e) {
                            // If lookup fails, will fall back to last message ID
                        }
                    }
                    
                    // If no unread message found (or conversation is read), use the latest message ID
                    if ($messageId === null && $conversation->last_message_id) {
                        $messageId = (string)$conversation->last_message_id;
                    }
                    
                    // Use ConversationUser's reply_count (should match Master, but use user-specific record for consistency)
                    // reply_count excludes the first message, so add 1 to get total message count
                    $messageCount = $userConv->reply_count + 1;
                    
                    $conversationList[] = [
                        'id' => (string)$conversation->conversation_id,
                        'title' => $conversation->title,
                        'startTime' => $conversation->start_date * 1000, // Convert to milliseconds
                        'startUserId' => $startUserId,
                        'startUsername' => $startUsername,
                        'startUserIconUrl' => $startUserIconUrl,
                        'lastMessageTime' => $conversation->last_message_date * 1000,
                        'lastMessageAuthor' => $conversation->last_message_username,
                        'lastMessageAuthorId' => $lastMessageAuthorId,
                        'lastMessageAuthorIconUrl' => $lastMessageAuthorIconUrl,
                        'isUnread' => $isUnread,
                        'messageId' => $messageId,
                        'unreadMessageCount' => $unreadMessageCount,
                        'messageCount' => $messageCount,
                        'participantCount' => $participantCount,
                        'canReply' => $canReply,
                        'canDelete' => $canDelete,
                        'canInvite' => $canInvite,
                        'canEdit' => $canEdit,
                        'canClose' => $canClose,
                        'isClosed' => $isClosed,
                    ];
                } catch (\Exception $e) {
                    // Skip this conversation if there's an error
                    continue;
                }
            }

            // Count unread conversations
            $unreadFinder = $this->finder('XF:ConversationRecipient');
            $unreadFinder->where('user_id', $visitor->user_id);
            $unreadFinder->where('recipient_state', 'active');
            $unreadFinder->where('last_read_date', '<', \XF::$time);
            $unreadCount = $unreadFinder->total();
            
            $result = new FCConversationsResult(
                true,
                null,
                (int)$total,
                (int)$unreadCount,
                $visitor->canUploadAndManageAttachments(),
                $conversationList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get conversations: ' . $e->getMessage());
        }
    }

    public function actionGetConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');
        $startNum = $params->get('startNum', 0);
        $lastNum = $params->get('lastNum', 19);

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required');
        }

        try {
            $visitor = \XF::visitor();
            
            // Use ConversationUser to get better access to recipient data (like web version)
            // Find ConversationUser for this user and conversation (like web version)
            // Note: ConversationUser has defaultWith = ['Master', 'Recipient'], so they're loaded automatically
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            $userConv = $finder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found');
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation');
            }

            // Get lastRead timestamp (like web version)
            $lastRead = $userConv->Recipient ? $userConv->Recipient->last_read_date : 0;

            // Get conversation repository (like web version)
            $conversationRepo = $this->repository('XF:Conversation');

            // Get participants - load Recipients relation explicitly
            $participants = [];
            try {
                // Use finder to get recipients with User relation loaded
                $recipientFinder = $this->finder('XF:ConversationRecipient');
                $recipientFinder->where('conversation_id', $conversation->conversation_id);
                $recipientFinder->where('recipient_state', 'active');
                $recipientFinder->with('User');
                $recipients = $recipientFinder->fetch();
                
                foreach ($recipients as $recipient) {
                    if ($recipient->User) {
                        $participants[] = [
                            'id' => (string)$recipient->User->user_id,
                            'username' => $recipient->User->username,
                            'iconUrl' => $this->getAbsoluteUrl($recipient->User->getAvatarUrl('s')),
                        ];
                    }
                }
            } catch (\Exception $e) {
                // If loading recipients fails, continue with empty participants list
                \XF::logError('ForumCopilot: Error loading recipients: ' . $e->getMessage());
            }

            // Get messages
            $messageRepo = $this->repository('XF:ConversationMessage');
            $finder = $messageRepo->findMessagesForConversationView($conversation);
            // Note: findMessagesForConversationView already includes 'full' which has User
            // Attachments relation is already configured with 'with' => 'Data' in the entity structure
            // So we don't need to explicitly add it here
            
            // Calculate pagination - ensure valid values
            $perPage = max(1, $lastNum - $startNum + 1);
            // Offset should be startNum - 1 (since position 1 = offset 0)
            $offset = max(0, $startNum - 1);
            $finder->limit($perPage, $offset);
            
            $messages = $finder->fetch();

            $messageList = [];
            foreach ($messages as $message) {
                // Always return raw message (BBCode)
                $messageContent = $message->message;
                
                // Get canLike and isLiked flags
                $likeFlags = $this->getConversationMessageLikeFlags($message);
                $canLike = $likeFlags['canLike'];
                $isLiked = $likeFlags['isLiked'];

                // Get likes info (list of users who liked this message)
                $likesInfo = $this->getConversationMessageLikesInfo($message);

                // Get attachments for this message
                $attachments = $this->getConversationMessageAttachments($message);
                
                // Convert FCAttachment objects to arrays
                $attachmentsArray = [];
                foreach ($attachments as $attachment) {
                    if ($attachment instanceof \ForumCopilot\Entity\FCAttachment) {
                        $attachmentsArray[] = $attachment->toArray();
                    } else {
                        $attachmentsArray[] = $attachment;
                    }
                }
                
                // Check if message is unread (like web version)
                $isUnread = false;
                try {
                    if (method_exists($message, 'isUnread')) {
                        $isUnread = $message->isUnread($lastRead);
                    }
                } catch (\Exception $e) {
                    // If check fails, default to false
                }
                
                // Check if this is the first message (like web version)
                $isFirstMessage = false;
                try {
                    if (method_exists($message, 'isFirstMessage')) {
                        $isFirstMessage = $message->isFirstMessage();
                    }
                } catch (\Exception $e) {
                    // If check fails, default to false
                }
                
                // Check if user can report this message (like web version)
                $canReport = false;
                try {
                    if (method_exists($message, 'canReport')) {
                        $canReport = $message->canReport();
                    }
                } catch (\Exception $e) {
                    // If check fails, default to false
                }
                
                // Check if message author is ignored (like web version)
                $isIgnored = false;
                try {
                    if (method_exists($message, 'isIgnored')) {
                        $isIgnored = $message->isIgnored();
                    }
                } catch (\Exception $e) {
                    // If check fails, default to false
                }
                
                // Check if user can edit this message (like web version)
                $canEditMessage = false;
                try {
                    if (method_exists($message, 'canEdit')) {
                        $canEditMessage = $message->canEdit();
                    }
                } catch (\Exception $e) {
                    // If check fails, default to false
                }
                
                // Calculate message position (message number) in the conversation
                $messageNumber = $this->getMessagePosition($message, $conversation);
                
                $messageList[] = [
                    'id' => (string)$message->message_id,
                    'authorId' => (string)$message->user_id,
                    'authorName' => $message->User ? $message->User->username : $message->username,
                    'authorIconUrl' => $message->User ? $this->getAbsoluteUrl($message->User->getAvatarUrl('s')) : '',
                    'timestamp' => $message->message_date * 1000,
                    'messageContent' => $messageContent,
                    'messageNumber' => $messageNumber,
                    'canEdit' => $canEditMessage,
                    'canDelete' => false, // ConversationMessage doesn't have canDelete() method
                    'canReport' => $canReport,
                    'canLike' => $canLike,
                    'isLiked' => $isLiked,
                    'likeCount' => isset($message->reaction_score) ? (int)$message->reaction_score : 0,
                    'likesInfo' => $likesInfo,
                    'attachments' => $attachmentsArray,
                    'isUnread' => $isUnread,
                    'isFirstMessage' => $isFirstMessage,
                    'isIgnored' => $isIgnored,
                ];
            }
            
            // Mark conversation as read after viewing (like web version)
            $lastMessage = $messages->last();
            if ($lastMessage) {
                try {
                    $conversationRepo->markUserConversationRead($userConv, $lastMessage->message_date);
                } catch (\Exception $e) {
                    // If marking as read fails, log but don't break the API
                    \XF::logError('ForumCopilot: Error marking conversation as read: ' . $e->getMessage());
                }
            }

            // Get total message count for pagination
            $totalMessageCount = $conversation->reply_count + 1; // +1 for first message
            
            // Get conversation permissions
            $canReply = false;
            $canInvite = false;
            $canEdit = false;
            $canClose = false;
            $isClosed = false;
            $canUpload = false;
            try {
                if (method_exists($conversation, 'canReply')) {
                    $canReply = $conversation->canReply();
                }
                if (method_exists($conversation, 'canInvite')) {
                    $canInvite = $conversation->canInvite();
                }
                if (method_exists($conversation, 'canEdit')) {
                    $canEdit = $conversation->canEdit();
                }
                if (method_exists($conversation, 'canUploadAndManageAttachments')) {
                    $canUpload = $conversation->canUploadAndManageAttachments();
                }
                // canClose is the same as canEdit - only the creator can close/reopen conversations
                $canClose = $canEdit;
                // isClosed is true when conversation_open is false
                $isClosed = !$conversation->conversation_open;
            } catch (\Exception $e) {
                // If permission checks fail, use defaults
            }

            $result = new FCConversationResult(
                true,
                null, // resultText
                (string)$conversation->conversation_id, // convId
                $conversation->title, // subject
                $conversation->title, // convTitle
                $messageList, // messages
                $participants, // participants
                count($participants), // participantCount
                $canReply,
                $canInvite,
                $canEdit,
                $canClose,
                $isClosed,
                $canUpload
            );

            // Add totalMessageNum and lastRead to the result array for pagination
            $resultArray = $result->toArray();
            $resultArray['totalMessageNum'] = $totalMessageCount;
            $resultArray['lastRead'] = $lastRead * 1000; // Convert to milliseconds

            return $this->apiSuccess($resultArray);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get conversation: ' . $e->getMessage());
        }
    }

    public function actionGetConversationByMessage(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $messageId = $params->get('messageId', '');
        $messagesPerRequest = $params->get('messagesPerRequest', 20);

        if (empty($messageId)) {
            return $this->apiError('Message ID is required');
        }

        try {
            // Get the message and verify it's viewable
            $message = $this->assertViewableMessage($messageId);
            
            // Get the conversation from the message
            $conversation = null;
            try {
                $conversation = $message->Conversation;
            } catch (\Exception $e) {
                return $this->apiError('Conversation not found');
            }
            
            if (!$conversation) {
                return $this->apiError('Conversation not found');
            }

            $visitor = \XF::visitor();
            
            // Find ConversationUser for this user and conversation
            $userConvFinder = $this->finder('XF:ConversationUser');
            $userConvFinder->where('conversation_id', $conversation->conversation_id);
            $userConvFinder->where('owner_user_id', $visitor->user_id);
            $userConv = $userConvFinder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found');
            }

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation');
            }

            // Get lastRead timestamp
            $lastRead = $userConv->Recipient ? $userConv->Recipient->last_read_date : 0;

            // Calculate message position by counting messages before this one
            $messageRepo = $this->repository('XF:ConversationMessage');
            $positionFinder = $messageRepo->findMessagesForConversationView($conversation);
            $positionFinder->where('message_date', '<=', $message->message_date);
            $position = $positionFinder->total();

            // Calculate pagination to center around the target message
            $startNum = max(1, $position - floor($messagesPerRequest / 2));
            $lastNum = $startNum + $messagesPerRequest - 1;

            // Get conversation repository
            $conversationRepo = $this->repository('XF:Conversation');

            // Get participants
            $participants = [];
            try {
                $recipientFinder = $this->finder('XF:ConversationRecipient');
                $recipientFinder->where('conversation_id', $conversation->conversation_id);
                $recipientFinder->where('recipient_state', 'active');
                $recipientFinder->with('User');
                $recipients = $recipientFinder->fetch();
                
                foreach ($recipients as $recipient) {
                    if ($recipient->User) {
                        $participants[] = [
                            'id' => (string)$recipient->User->user_id,
                            'username' => $recipient->User->username,
                            'iconUrl' => $this->getAbsoluteUrl($recipient->User->getAvatarUrl('s')),
                        ];
                    }
                }
            } catch (\Exception $e) {
                \XF::logError('ForumCopilot: Error loading recipients: ' . $e->getMessage());
            }

            // Get messages using same logic as actionGetConversation
            $messageFinder = $messageRepo->findMessagesForConversationView($conversation);
            
            // Calculate pagination - ensure valid values
            $perPage = max(1, $lastNum - $startNum + 1);
            $offset = max(0, $startNum - 1);
            $messageFinder->limit($perPage, $offset);
            
            $messages = $messageFinder->fetch();
            $total = $conversation->reply_count + 1; // +1 for first message

            $messageList = [];
            foreach ($messages as $msg) {
                $messageContent = $msg->message;
                
                // Get canLike and isLiked flags
                $likeFlags = $this->getConversationMessageLikeFlags($msg);
                $canLike = $likeFlags['canLike'];
                $isLiked = $likeFlags['isLiked'];

                // Get likes info
                $likesInfo = $this->getConversationMessageLikesInfo($msg);

                // Get attachments
                $attachments = $this->getConversationMessageAttachments($msg);
                
                $attachmentsArray = [];
                foreach ($attachments as $attachment) {
                    if ($attachment instanceof \ForumCopilot\Entity\FCAttachment) {
                        $attachmentsArray[] = $attachment->toArray();
                    } else {
                        $attachmentsArray[] = $attachment;
                    }
                }
                
                // Check if message is unread
                $isUnread = false;
                try {
                    if (method_exists($msg, 'isUnread')) {
                        $isUnread = $msg->isUnread($lastRead);
                    }
                } catch (\Exception $e) {
                }
                
                // Check if this is the first message
                $isFirstMessage = false;
                try {
                    if (method_exists($msg, 'isFirstMessage')) {
                        $isFirstMessage = $msg->isFirstMessage();
                    }
                } catch (\Exception $e) {
                }
                
                // Check if user can report this message
                $canReport = false;
                try {
                    if (method_exists($msg, 'canReport')) {
                        $canReport = $msg->canReport();
                    }
                } catch (\Exception $e) {
                }
                
                // Check if message author is ignored
                $isIgnored = false;
                try {
                    if (method_exists($msg, 'isIgnored')) {
                        $isIgnored = $msg->isIgnored();
                    }
                } catch (\Exception $e) {
                }
                
                // Check if user can edit this message
                $canEditMessage = false;
                try {
                    if (method_exists($msg, 'canEdit')) {
                        $canEditMessage = $msg->canEdit();
                    }
                } catch (\Exception $e) {
                }
                
                // Calculate message position (message number) in the conversation
                $messageNumber = $this->getMessagePosition($msg, $conversation);
                
                $messageList[] = [
                    'id' => (string)$msg->message_id,
                    'authorId' => (string)$msg->user_id,
                    'authorName' => $msg->User ? $msg->User->username : $msg->username,
                    'authorIconUrl' => $msg->User ? $this->getAbsoluteUrl($msg->User->getAvatarUrl('s')) : '',
                    'timestamp' => $msg->message_date * 1000,
                    'messageContent' => $messageContent,
                    'messageNumber' => $messageNumber,
                    'canEdit' => $canEditMessage,
                    'canDelete' => false,
                    'canReport' => $canReport,
                    'canLike' => $canLike,
                    'isLiked' => $isLiked,
                    'likeCount' => isset($msg->reaction_score) ? (int)$msg->reaction_score : 0,
                    'likesInfo' => $likesInfo,
                    'attachments' => $attachmentsArray,
                    'isUnread' => $isUnread,
                    'isFirstMessage' => $isFirstMessage,
                    'isIgnored' => $isIgnored,
                ];
            }
            
            // Mark conversation as read after viewing
            $lastMessage = $messages->last();
            if ($lastMessage) {
                try {
                    $conversationRepo->markUserConversationRead($userConv, $lastMessage->message_date);
                } catch (\Exception $e) {
                    \XF::logError('ForumCopilot: Error marking conversation as read: ' . $e->getMessage());
                }
            }

            // Get conversation permissions
            $canReply = false;
            $canInvite = false;
            $canEdit = false;
            $canClose = false;
            $isClosed = false;
            $canUpload = false;
            try {
                if (method_exists($conversation, 'canReply')) {
                    $canReply = $conversation->canReply();
                }
                if (method_exists($conversation, 'canInvite')) {
                    $canInvite = $conversation->canInvite();
                }
                if (method_exists($conversation, 'canEdit')) {
                    $canEdit = $conversation->canEdit();
                }
                if (method_exists($conversation, 'canUploadAndManageAttachments')) {
                    $canUpload = $conversation->canUploadAndManageAttachments();
                }
                $canClose = $canEdit;
                $isClosed = !$conversation->conversation_open;
            } catch (\Exception $e) {
            }

            $result = new FCConversationResult(
                true,
                null,
                (string)$conversation->conversation_id,
                $conversation->title,
                $conversation->title,
                $messageList,
                $participants,
                count($participants),
                $canReply,
                $canInvite,
                $canEdit,
                $canClose,
                $isClosed,
                $canUpload
            );

            // Add totalMessageNum, lastRead, and position to the result array
            $resultArray = $result->toArray();
            $resultArray['totalMessageNum'] = $total;
            $resultArray['lastRead'] = $lastRead * 1000; // Convert to milliseconds
            $resultArray['position'] = $position; // Position of the target message

            return $this->apiSuccess($resultArray);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Failed to get conversation by message');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to get conversation by message: ' . $e->getMessage());
        }
    }

    public function actionGetInboxStat(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        try {
            $visitor = \XF::visitor();
            
            $conversationRepo = $this->repository('XF:ConversationMaster');
            $stats = $conversationRepo->getConversationStatsForUser($visitor);

            $result = new FCConversationInboxStatResult(
                true,
                null,
                $stats['total'] ?? 0,
                $stats['unread'] ?? 0,
                $stats['unread_messages'] ?? 0
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get inbox stats: ' . $e->getMessage());
        }
    }

    public function actionMarkConversationRead(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required');
        }

        try {
            $conversation = $this->em()->find('XF:ConversationMaster', $conversationId);
            if (!$conversation) {
                return $this->apiError('Conversation not found');
            }

            $visitor = \XF::visitor();
            $conversation->markAsRead($visitor);

            $result = new FCMarkConversationReadResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to mark conversation as read: ' . $e->getMessage());
        }
    }

    public function actionMarkConversationUnread(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required');
        }

        try {
            $visitor = \XF::visitor();
            $conversationRepo = $this->repository('XF:Conversation');
            
            // Get ConversationUser for the current visitor (search directly without forUser to avoid filtering deleted conversations)
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            
            $userConv = $finder->fetchOne();
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found');
            }

            // Mark conversation as unread using repository method
            $conversationRepo->markUserConversationUnread($userConv);

            $result = new FCMarkConversationUnreadResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to mark conversation as unread: ' . $e->getMessage());
        }
    }

    public function actionLeaveConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');
        $mode = $params->get('mode', 0);

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required');
        }

        try {
            $visitor = \XF::visitor();
            
            // Get ConversationUser for the current visitor (search directly without forUser to avoid filtering deleted conversations)
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            
            $userConv = $finder->fetchOne();
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found');
            }

            // Determine recipient state based on mode (like Tapatalk/XenForo core)
            // mode 1 = deleted, mode 2 = deleted_ignored
            // Note: XenForo core also directly sets recipient_state (see ConversationController::actionLeave)
            // The recipient entity's _postSave will handle ConversationUser deletion and conversation updates
            $recipientState = 'deleted';
            if ($mode == 2) {
                $recipientState = 'deleted_ignored';
            } else {
                // Default to deleted if mode is not 2
                $recipientState = 'deleted';
            }

            // Update recipient state (following XenForo core pattern)
            $recipient = $userConv->Recipient;
            if ($recipient) {
                $recipient->recipient_state = $recipientState;
                $recipient->save(); // _postSave will handle ConversationUser deletion and conversation updates
            }

            $result = new FCLeaveConversationResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to leave conversation: ' . $e->getMessage());
        }
    }

    public function actionInviteParticipant(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userName = $params->get('userName', []);
        $conversationId = $params->get('conversationId', '');
        $reason = $params->get('reason', '');

        // Validate input parameters
        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required');
        }

        // Ensure userName is an array
        if (empty($userName)) {
            return $this->apiError('Username is required');
        }
        if (!is_array($userName)) {
            // If it's a string, convert to array (comma-separated or single username)
            if (is_string($userName)) {
                $userName = array_filter(array_map('trim', explode(',', $userName)));
            } else {
                return $this->apiError('Username must be an array or comma-separated string');
            }
        }
        if (empty($userName)) {
            return $this->apiError('At least one username is required');
        }

        try {
            $visitor = \XF::visitor();

            // Verify user is a participant in the conversation (security check)
            // This ensures users can only invite to conversations they're part of
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            $userConv = $finder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found or you are not a participant');
            }

            $conversation = $userConv->Master;

            // Check if user can invite to this conversation
            if (!$conversation->canInvite()) {
                return $this->apiError('Cannot invite to this conversation');
            }

            // Use XenForo's Conversation Inviter service (like XenForo core does)
            /** @var InviterService $inviter */
            $inviter = $this->service(InviterService::class, $conversation, $visitor);
            
            // Set recipients as comma-separated string (getValidatedRecipients accepts string or array)
            // Convert array to comma-separated string for consistency with XenForo web interface
            $recipientsString = implode(',', $userName);
            $inviter->setRecipients($recipientsString);
            
            // Validate before saving
            $errors = [];
            if (!$inviter->validate($errors)) {
                // Convert error objects to strings if needed
                $errorMessages = [];
                foreach ($errors as $error) {
                    if (is_string($error)) {
                        $errorMessages[] = $error;
                    } elseif (is_object($error) && method_exists($error, '__toString')) {
                        $errorMessages[] = (string)$error;
                    } elseif (is_object($error) && method_exists($error, 'render')) {
                        $errorMessages[] = $error->render();
                    } else {
                        $errorMessages[] = 'Validation error';
                    }
                }
                return $this->apiError('Validation failed: ' . implode(', ', $errorMessages));
            }

            // Save (insertRecipients handles duplicates correctly)
            $inviter->save();

            // Send notifications
            $inviter->sendNotifications();

            $result = new FCInviteParticipantResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to invite participants: ' . $e->getMessage());
        }
    }

    public function actionGetQuoteConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Ensure result class is loaded
        if (!class_exists('ForumCopilot\Result\FCQuoteConversationResult')) {
            require \XF::getRootDirectory() . '/src/addons/ForumCopilot/Result/FCQuoteConversationResult.php';
        }

        $messageId = $params->get('messageId', '');

        if (empty($messageId)) {
            return $this->apiError('Message ID is required');
        }

        try {
            $message = $this->assertViewableMessage($messageId);

            // Process message through getBbCodeForQuote (matches XenForo web behavior)
            // This handles nested quotes and censoring
            $processedMessage = $this->app()->stringFormatter()->getBbCodeForQuote($message->message, 'conversation_message');
            
            if (strlen($processedMessage)) {
                // Use XenForo's getQuoteWrapper method (matches web format with newlines)
                $quote = $message->getQuoteWrapper($processedMessage);
            } else {
                // Don't show a blank quote
                $quote = '';
            }

            $result = new FCQuoteConversationResult(
                true,
                null,
                $quote
            );

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Failed to get quote');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to get quote: ' . $e->getMessage());
        }
    }

    public function actionLikeConversationMessage(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $messageId = $params->get('messageId', '');

        if (empty($messageId)) {
            return $this->apiError('Message ID is required');
        }

        try {
            $message = $this->assertViewableMessage($messageId);
            $visitor = \XF::visitor();

            // Check if can like/react
            $canLike = false;
            $error = null;
            if (method_exists($message, 'canReact')) {
                $canLike = $message->canReact($error);
            } elseif (method_exists($message, 'canLike')) {
                $canLike = $message->canLike($error);
            }
            
            if (!$canLike) {
                $errorMessage = $error ? (is_string($error) ? $error : 'Cannot like this message') : 'Cannot like this message';
                return $this->apiError($errorMessage);
            }

            // Apply the reaction the user picked via XenForo's reaction
            // repository. reactToContent() adds / switches / toggles-off
            // automatically. reactionId defaults to 1 (Like) so older app
            // builds that don't send it behave exactly as before.
            $contentType = 'conversation_message';
            $contentId = (int) $message->message_id;
            $reactionId = (int) $params->get('reactionId', 1);
            if ($reactionId < 1) {
                $reactionId = 1;
            }

            try {
                $reactionRepo = $this->repository('XF:Reaction');
                $reaction = $reactionRepo->reactToContent(
                    $reactionId,
                    $contentType,
                    $contentId,
                    $visitor,
                    true,
                    false
                );
            } catch (\Throwable $e) {
                return $this->apiError('Failed to react to message: ' . $e->getMessage());
            }

            // Refresh the message so reaction_score reflects the change.
            $message = $this->em()->find('XF:ConversationMessage', $contentId);

            $visitorReactionId = ($reaction && isset($reaction->reaction_id))
                ? (int) $reaction->reaction_id
                : null;

            $result = new FCLikePostResult(
                true,
                null,
                $visitorReactionId !== null,
                (isset($message->reaction_score) ? (int) $message->reaction_score : 0),
                $visitorReactionId
            );

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Message not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to like message: ' . $e->getMessage());
        }
    }

    public function actionUnlikeConversationMessage(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $messageId = $params->get('messageId', '');

        if (empty($messageId)) {
            return $this->apiError('Message ID is required');
        }

        try {
            $message = $this->assertViewableMessage($messageId);
            $visitor = \XF::visitor();

            // Check if can like/react
            $canLike = false;
            $error = null;
            if (method_exists($message, 'canReact')) {
                $canLike = $message->canReact($error);
            } elseif (method_exists($message, 'canLike')) {
                $canLike = $message->canLike($error);
            }
            
            if (!$canLike) {
                $errorMessage = $error ? (is_string($error) ? $error : 'Cannot unlike this message') : 'Cannot unlike this message';
                return $this->apiError($errorMessage);
            }

            // Use like system
            $contentType = 'conversation_message';
            $contentId = $message->message_id;
            
            // Check if already reacted/liked
            $isReacted = false;
            try {
                if (method_exists($message, 'isReactedTo')) {
                    $isReacted = $message->isReactedTo();
                } else {
                    $isReacted = $message->isLiked();
                }
            } catch (\Exception $e) {
                // If check fails, assume not liked and return
                $result = new FCUnlikePostResult(
                    true,
                    null,
                    false,
                    isset($message->reaction_score) ? (int)$message->reaction_score : 0
                );
                return $this->apiSuccess($result);
            }
            
            if (!$isReacted) {
                // Not liked, return current state
                $result = new FCUnlikePostResult(
                    true,
                    null,
                    false,
                    isset($message->reaction_score) ? (int)$message->reaction_score : 0
                );
            } else {
                // Use unlike system
                $contentType = 'conversation_message';
                $contentId = $message->message_id;
                
                // Check if reaction system is available
                if (class_exists('\XF\ControllerPlugin\Reaction')) {
                    try {
                        $reactionRepo = $this->repository('XF:Reaction');
                        $existingReaction = $reactionRepo->getReactionByContentAndReactionUser('conversation_message', $contentId, $visitor->user_id);
                        if ($existingReaction && $existingReaction->reaction_id) {
                            $existingReaction->setOption('is_like_only', false);
                            $existingReaction->delete();
                        }
                        
                        // Refresh message
                        $message = $this->em()->find('XF:ConversationMessage', $message->message_id);
                        
                        $result = new FCUnlikePostResult(
                            true,
                            null,
                            false,
                            isset($message->reaction_score) ? (int)$message->reaction_score : 0
                        );
                    } catch (\Exception $e) {
                        return $this->apiError('Failed to unlike message: ' . $e->getMessage());
                    }
                } else {
                    // Use old like system
                    try {
                        $likeRepo = $this->repository('XF:LikedContent');
                        $likeRepo->toggleLike($contentType, $contentId, $visitor);
                        
                        // Refresh message
                        $message = $this->em()->find('XF:ConversationMessage', $message->message_id);
                        
                        $result = new FCUnlikePostResult(
                            true,
                            null,
                            false,
                            isset($message->reaction_score) ? (int)$message->reaction_score : 0
                        );
                    } catch (\Exception $e) {
                        return $this->apiError('Failed to unlike message: ' . $e->getMessage());
                    }
                }
            }

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Message not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to unlike message: ' . $e->getMessage());
        }
    }

    public function actionCloseConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Ensure result class is loaded
        if (!class_exists('ForumCopilot\Result\FCCloseConversationResult')) {
            require \XF::getRootDirectory() . '/src/addons/ForumCopilot/Result/FCModerationResult.php';
        }

        $conversationId = $params->get('conversationId', '');

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required');
        }

        try {
            $visitor = \XF::visitor();
            
            // Find ConversationUser for this user and conversation
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            $userConv = $finder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found');
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation');
            }

            // Check if user can edit (only creator can close/reopen conversations)
            if (!$conversation->canEdit($error)) {
                return $this->apiError('Cannot close this conversation' . ($error ? ': ' . $error : ''));
            }

            // Use XenForo's standard approach: directly set conversation_open and save
            $conversation->conversation_open = false;
            $conversation->save();

            $result = new FCCloseConversationResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to close conversation: ' . $e->getMessage());
        }
    }

    public function actionUncloseConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Ensure result class is loaded
        if (!class_exists('ForumCopilot\Result\FCCloseConversationResult')) {
            require \XF::getRootDirectory() . '/src/addons/ForumCopilot/Result/FCModerationResult.php';
        }

        $conversationId = $params->get('conversationId', '');

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required');
        }

        try {
            $visitor = \XF::visitor();
            
            // Find ConversationUser for this user and conversation
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            $userConv = $finder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found');
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation');
            }

            // Check if user can edit (only creator can close/reopen conversations)
            if (!$conversation->canEdit($error)) {
                return $this->apiError('Cannot open this conversation' . ($error ? ': ' . $error : ''));
            }

            // Use XenForo's standard approach: directly set conversation_open and save
            $conversation->conversation_open = true;
            $conversation->save();

            $result = new FCCloseConversationResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to open conversation: ' . $e->getMessage());
        }
    }

    public function actionGetRawConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required');
        }

        try {
            // Ensure result classes are loaded
            if (!class_exists('ForumCopilot\Result\FCRawConversationResult')) {
                require \XF::getRootDirectory() . '/src/addons/ForumCopilot/Result/FCConversationResult.php';
            }
            
            $visitor = \XF::visitor();
            
            // Find ConversationUser for this user and conversation
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            $userConv = $finder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found');
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation');
            }

            // Check edit permission (only creator can edit)
            if (!$conversation->canEdit($error)) {
                return $this->apiError('Cannot edit this conversation' . ($error ? ': ' . $error : ''));
            }

            $result = new FCRawConversationResult(
                true,
                null,
                $conversation->title,
                $conversation->open_invite,
                $conversation->conversation_open,
                true // canEdit is true since we already checked it
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get raw conversation: ' . $e->getMessage());
        }
    }

    public function actionSaveRawConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Ensure result classes are loaded
        if (!class_exists('ForumCopilot\Result\FCSaveRawConversationResult')) {
            require \XF::getRootDirectory() . '/src/addons/ForumCopilot/Result/FCConversationResult.php';
        }

        $conversationId = $params->get('conversationId', '');
        $conversationTitle = $params->get('conversationTitle', '');
        $openInvite = $params->get('openInvite', null);
        $conversationOpen = $params->get('conversationOpen', null);

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required');
        }

        try {
            $visitor = \XF::visitor();
            
            // Find ConversationUser for this user and conversation
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            $userConv = $finder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found');
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation');
            }

            // Check edit permission (only creator can edit)
            if (!$conversation->canEdit($error)) {
                return $this->apiError('Cannot edit this conversation' . ($error ? ': ' . $error : ''));
            }

            // Use XenForo's EditorService (same as core API uses)
            /** @var EditorService $editor */
            $editor = $this->service(EditorService::class, $conversation);

            if (!empty($conversationTitle)) {
                $editor->setTitle($conversationTitle);
            }

            if ($openInvite !== null) {
                $editor->setOpenInvite((bool)$openInvite);
            }

            if ($conversationOpen !== null) {
                $editor->setConversationOpen((bool)$conversationOpen);
            }

            // Validate before saving
            if (!$editor->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            // Save changes
            $editor->save();

            // Get updated conversation title
            $updatedTitle = $conversation->title;

            $result = new FCSaveRawConversationResult(
                true,
                null,
                $updatedTitle
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to save conversation: ' . $e->getMessage());
        }
    }

    public function actionGetRawMessage(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Ensure result classes are loaded
        if (!class_exists('ForumCopilot\Result\FCRawMessageResult')) {
            require \XF::getRootDirectory() . '/src/addons/ForumCopilot/Result/FCConversationResult.php';
        }

        $messageId = $params->get('messageId', '');

        if (empty($messageId)) {
            return $this->apiError('Message ID is required');
        }

        try {
            // Find message
            $message = $this->em()->find('XF:ConversationMessage', (int)$messageId);
            
            if (!$message) {
                return $this->apiError('Message not found');
            }

            // Check if message is viewable
            $error = null;
            if (!$message->canView($error)) {
                return $this->apiError('Cannot view this message');
            }

            // Check edit permission
            if (!$message->canEdit($error)) {
                return $this->apiError('Cannot edit this message' . ($error ? ': ' . $error : ''));
            }

            // Get existing attachments using helper method
            $attachments = $this->getConversationMessageAttachments($message);

            $result = new FCRawMessageResult(
                true,
                null,
                $message->message,
                $attachments
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get raw message: ' . $e->getMessage());
        }
    }

    public function actionSaveRawMessage(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Ensure result classes are loaded
        if (!class_exists('ForumCopilot\Result\FCSaveRawMessageResult')) {
            require \XF::getRootDirectory() . '/src/addons/ForumCopilot/Result/FCConversationResult.php';
        }

        $messageId = $params->get('messageId', '');
        $messageContent = $params->get('messageContent', '');
        $attachmentIds = $params->get('attachmentIds', []);
        $groupId = $params->get('groupId', '');

        if (empty($messageId) || empty($messageContent)) {
            return $this->apiError('Message ID and content are required');
        }

        try {
            // Find message
            $message = $this->em()->find('XF:ConversationMessage', (int)$messageId);
            
            if (!$message) {
                return $this->apiError('Message not found');
            }

            $conversation = $message->Conversation;
            if (!$conversation) {
                return $this->apiError('Conversation not found');
            }

            // Check if message is viewable
            $error = null;
            if (!$message->canView($error)) {
                return $this->apiError('Cannot view this message');
            }

            // Check edit permission
            if (!$message->canEdit($error)) {
                return $this->apiError('Cannot edit this message' . ($error ? ': ' . $error : ''));
            }

            // Use XenForo's MessageEditorService (same as core API uses)
            /** @var MessageEditorService $editor */
            $editor = $this->service(MessageEditorService::class, $message);
            $editor->setMessageContent($messageContent);

            // Handle attachments if provided (same pattern as saveRawPost)
            if ($conversation->canUploadAndManageAttachments()) {
                $attachmentHash = '';
                if ($groupId) {
                    $attachmentHash = $groupId;
                } elseif (!empty($attachmentIds) && is_array($attachmentIds)) {
                    // Get attachments by IDs and build hash string
                    $attachmentRepo = $this->repository('XF:Attachment');
                    $attachments = $attachmentRepo->findByIds($attachmentIds);
                    $hashArray = [];
                    foreach ($attachments as $attachment) {
                        if ($attachment->canView() && $attachment->temp_hash) {
                            $hashArray[] = $attachment->temp_hash;
                        }
                    }
                    if ($hashArray) {
                        $attachmentHash = implode(',', $hashArray);
                    }
                }
                if ($attachmentHash) {
                    $editor->setAttachmentHash($attachmentHash);
                }
            }

            // Validate before saving
            if (!$editor->validate($errors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $errors));
            }

            // Save message
            $editor->save();

            // Get updated message content
            $updatedContent = $message->message;

            $result = new FCSaveRawMessageResult(
                true,
                null,
                $updatedContent
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to save message: ' . $e->getMessage());
        }
    }
}

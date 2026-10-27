<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
use XF\Mvc\ParameterBag;
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
        $groupId = $params->get('groupId', '');
        
        // Optional parameters for conversation settings
        $openInvite = $params->get('openInvite', false);
        $conversationLocked = $params->get('conversationLocked', false);

        if (empty($userName) || empty($subject) || empty($textBody)) {
            return $this->apiError('Username, subject, and content are required', null, ErrorCode::VALIDATION);
        }

        $visitor = \XF::visitor();
        if (!$visitor->canStartConversation()) {
            return $this->apiError(\XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
        }

        try {
            // Use XenForo's Conversation Creator service, as XenForo's own
            // ConversationController::setupConversationCreate does. Its
            // recipient check names recipients who don't exist or whose
            // privacy settings refuse direct messages, and applies the
            // maximum number of recipients.
            /** @var \XF\Service\Conversation\Creator $creator */
            $creator = $this->service('XF:Conversation\Creator', $visitor);
            
            // Set options - use provided values or defaults
            $options = [];
            $options['open_invite'] = (bool)$openInvite;
            $options['conversation_open'] = !(bool)$conversationLocked; // Convert locked to open status
            $creator->setOptions($options);
            $creator->setRecipients($this->recipientNames($userName));
            $creator->setContent($subject, $textBody);

            // New uploads come as the upload hash (groupId). attachmentIds
            // lists attachments that are already saved and needs nothing.
            if ($groupId && $creator->getConversation()->canUploadAndManageAttachments()) {
                $creator->setAttachmentHash($groupId);
            }

            if (!$creator->validate($errors)) {
                return $this->apiFieldErrors($errors);
            }
            if ($floodError = $this->checkFlooding('conversation', $this->options()->floodCheckLengthDiscussion ?: null)) {
                return $floodError;
            }

            /** @var \XF\Entity\ConversationMaster $conversation */
            $conversation = $creator->save();
            
            \XF\Draft::createFromKey('conversation')->delete();

            // No sendNotifications(): XenForo's conversation Creator already
            // sent them inside save(). A second call e-mailed every recipient
            // twice and, on XF 2.3, pushed twice.

            $result = new FCNewConversationResult(
                true,
                null,
                (string)$conversation->conversation_id
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to create conversation');
        }
    }

    /**
     * Recipient names as XenForo's recipients field takes them: one
     * comma-separated string. The app sends an array; a string is accepted too.
     *
     * @param mixed $names
     */
    protected function recipientNames($names): string
    {
        if (is_string($names)) {
            return $names;
        }
        if (!is_array($names)) {
            return '';
        }
        $names = array_filter(array_map('trim', array_map('strval', $names)), 'strlen');
        return implode(', ', $names);
    }

    public function actionReplyConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');
        $textBody = $params->get('textBody', '');
        $groupId = $params->get('groupId', '');

        if (empty($conversationId) || empty($textBody)) {
            return $this->apiError('Conversation ID and content are required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();

            // Only the visitor's own copy of the conversation, as XenForo's
            // ConversationController::actionAddReply does
            $userConv = $this->assertViewableUserConversation($conversationId);
            $conversation = $userConv->Master;

            if (!$conversation->canReply()) {
                return $this->apiError(\XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            /** @var \XF\Service\Conversation\Replier $replier */
            $replier = $this->service('XF:Conversation\Replier', $conversation, $visitor);
            $replier->setMessageContent($textBody);

            if ($groupId && $conversation->canUploadAndManageAttachments()) {
                $replier->setAttachmentHash($groupId);
            }

            if (!$replier->validate($errors)) {
                return $this->apiFieldErrors($errors);
            }
            if ($floodError = $this->checkFlooding('conversation_message')) {
                return $floodError;
            }

            // Save reply (returns ConversationMessage entity). XenForo's
            // conversation Replier sends the notifications inside save(), so
            // there is no sendNotifications() call here.
            $message = $replier->save();

            // The reply draft XenForo's editor keeps, as afterConversationReply does
            $conversation->draft_reply->delete();

            $result = new FCReplyConversationResult(true, null, (string)$message->message_id);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to reply to conversation');
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
            
            // Calculate pagination. The app documents startNum as 0-based
            // (0-19, 20-39), like the other list endpoints here; ceil() read it
            // as 1-based, so startNum 20 gave page 1 again. floor() + 1 gives
            // the right page for 0-based ranges and for 1-based ones (1-20,
            // 21-40), which newer apps send to cope with older add-ons.
            $perPage = max(1, $lastNum - $startNum + 1);
            $page = (int)floor($startNum / $perPage) + 1;
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
            return $this->apiException($e, 'Failed to get conversations');
        }
    }

    public function actionGetConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');
        $startNum = $params->get('startNum', 0);
        $lastNum = $params->get('lastNum', 19);

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required', null, ErrorCode::BAD_REQUEST);
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
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation', null, ErrorCode::NO_PERMISSION);
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
            // Then by ID: messages posted in the same second keep one order
            // from page to page, the order getMessagePosition() numbers.
            $finder->order('message_id');
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
                    'likeCount' => $this->getReactionCount($message),
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
            return $this->apiException($e, 'Failed to get conversation');
        }
    }

    public function actionGetConversationByMessage(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $messageId = $params->get('messageId', '');
        $messagesPerRequest = $params->get('messagesPerRequest', 20);

        if (empty($messageId)) {
            return $this->apiError('Message ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // Get the message and verify it's viewable
            $message = $this->assertViewableMessage($messageId);
            
            // Get the conversation from the message
            $conversation = null;
            try {
                $conversation = $message->Conversation;
            } catch (\Exception $e) {
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }
            
            if (!$conversation) {
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }

            $visitor = \XF::visitor();
            
            // Find ConversationUser for this user and conversation
            $userConvFinder = $this->finder('XF:ConversationUser');
            $userConvFinder->where('conversation_id', $conversation->conversation_id);
            $userConvFinder->where('owner_user_id', $visitor->user_id);
            $userConv = $userConvFinder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation', null, ErrorCode::NO_PERMISSION);
            }

            // Get lastRead timestamp
            $lastRead = $userConv->Recipient ? $userConv->Recipient->last_read_date : 0;

            $messageRepo = $this->repository('XF:ConversationMessage');
            $position = $this->getMessagePosition($message, $conversation);

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
            $messageFinder->order('message_id');
            
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
                    'likeCount' => $this->getReactionCount($msg),
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

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get conversation by message');
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
            return $this->apiException($e, 'Failed to get inbox stats');
        }
    }

    public function actionMarkConversationRead(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            $conversationRepo = $this->repository('XF:Conversation');

            // The visitor's own ConversationUser row (no forUser() so a deleted
            // conversation is still found), same lookup as markConversationUnread.
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);

            $userConv = $finder->fetchOne();
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }

            $conversationRepo->markUserConversationRead($userConv);

            $result = new FCMarkConversationReadResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to mark conversation as read');
        }
    }

    public function actionMarkConversationUnread(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required', null, ErrorCode::BAD_REQUEST);
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
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }

            // Mark conversation as unread using repository method
            $conversationRepo->markUserConversationUnread($userConv);

            $result = new FCMarkConversationUnreadResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to mark conversation as unread');
        }
    }

    public function actionLeaveConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');
        $mode = $params->get('mode', 0);

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            
            // Get ConversationUser for the current visitor (search directly without forUser to avoid filtering deleted conversations)
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            
            $userConv = $finder->fetchOne();
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
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
            return $this->apiException($e, 'Failed to leave conversation');
        }
    }

    public function actionInviteParticipant(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userName = $params->get('userName', []);
        $conversationId = $params->get('conversationId', '');

        // Validate input parameters
        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required', null, ErrorCode::BAD_REQUEST);
        }

        // Ensure userName is an array
        if (empty($userName)) {
            return $this->apiError('Username is required', null, ErrorCode::VALIDATION);
        }
        if (!is_array($userName)) {
            // If it's a string, convert to array (comma-separated or single username)
            if (is_string($userName)) {
                $userName = array_filter(array_map('trim', explode(',', $userName)));
            } else {
                return $this->apiError('Username must be an array or comma-separated string', null, ErrorCode::BAD_REQUEST);
            }
        }
        if (empty($userName)) {
            return $this->apiError('At least one username is required', null, ErrorCode::VALIDATION);
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
                return $this->apiError('Conversation not found or you are not a participant', null, ErrorCode::NOT_FOUND);
            }

            $conversation = $userConv->Master;

            // Check if user can invite to this conversation
            if (!$conversation->canInvite()) {
                return $this->apiError('Cannot invite to this conversation', null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's Conversation Inviter service (like XenForo core does)
            /** @var \XF\Service\Conversation\Inviter $inviter */
            $inviter = $this->service('XF:Conversation\Inviter', $conversation, $visitor);
            
            // Set recipients as comma-separated string (getValidatedRecipients accepts string or array)
            // Convert array to comma-separated string for consistency with XenForo web interface
            $recipientsString = implode(',', $userName);
            $inviter->setRecipients($recipientsString);
            
            if (!$inviter->validate($errors)) {
                return $this->apiFieldErrors($errors);
            }

            // Save (insertRecipients handles duplicates correctly). XenForo's
            // conversation Inviter sends the notifications inside save(), so
            // there is no sendNotifications() call here.
            $inviter->save();

            $result = new FCInviteParticipantResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to invite participants');
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
            return $this->apiError('Message ID is required', null, ErrorCode::BAD_REQUEST);
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

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get quote');
        }
    }

    public function actionLikeConversationMessage(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $messageId = $params->get('messageId', '');

        if (empty($messageId)) {
            return $this->apiError('Message ID is required', null, ErrorCode::BAD_REQUEST);
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
                return $this->apiError($errorMessage, null, ErrorCode::NO_PERMISSION);
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
                return $this->apiException($e, 'Failed to react to message');
            }

            // Refresh the message so its reaction counts reflect the change.
            $message = $this->em()->find('XF:ConversationMessage', $contentId);

            $visitorReactionId = ($reaction && isset($reaction->reaction_id))
                ? (int) $reaction->reaction_id
                : null;

            $result = new FCLikePostResult(
                true,
                null,
                $visitorReactionId !== null,
                $this->getReactionCount($message),
                $visitorReactionId
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to like message');
        }
    }

    public function actionUnlikeConversationMessage(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $messageId = $params->get('messageId', '');

        if (empty($messageId)) {
            return $this->apiError('Message ID is required', null, ErrorCode::BAD_REQUEST);
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
                return $this->apiError($errorMessage, null, ErrorCode::NO_PERMISSION);
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
                    $this->getReactionCount($message)
                );
                return $this->apiSuccess($result);
            }
            
            if (!$isReacted) {
                // Not liked, return current state
                $result = new FCUnlikePostResult(
                    true,
                    null,
                    false,
                    $this->getReactionCount($message)
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
                            $this->getReactionCount($message)
                        );
                    } catch (\Exception $e) {
                        return $this->apiException($e, 'Failed to unlike message');
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
                            $this->getReactionCount($message)
                        );
                    } catch (\Exception $e) {
                        return $this->apiException($e, 'Failed to unlike message');
                    }
                }
            }

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to unlike message');
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
            return $this->apiError('Conversation ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            
            // Find ConversationUser for this user and conversation
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            $userConv = $finder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation', null, ErrorCode::NO_PERMISSION);
            }

            // Check if user can edit (only creator can close/reopen conversations)
            if (!$conversation->canEdit($error)) {
                return $this->apiError('Cannot close this conversation' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's standard approach: directly set conversation_open and save
            $conversation->conversation_open = false;
            $conversation->save();

            $result = new FCCloseConversationResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to close conversation');
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
            return $this->apiError('Conversation ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            
            // Find ConversationUser for this user and conversation
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            $userConv = $finder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation', null, ErrorCode::NO_PERMISSION);
            }

            // Check if user can edit (only creator can close/reopen conversations)
            if (!$conversation->canEdit($error)) {
                return $this->apiError('Cannot open this conversation' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's standard approach: directly set conversation_open and save
            $conversation->conversation_open = true;
            $conversation->save();

            $result = new FCCloseConversationResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to open conversation');
        }
    }

    public function actionGetRawConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');

        if (empty($conversationId)) {
            return $this->apiError('Conversation ID is required', null, ErrorCode::BAD_REQUEST);
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
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation', null, ErrorCode::NO_PERMISSION);
            }

            // Check edit permission (only creator can edit)
            if (!$conversation->canEdit($error)) {
                return $this->apiError('Cannot edit this conversation' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
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
            return $this->apiException($e, 'Failed to get raw conversation');
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
            return $this->apiError('Conversation ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            
            // Find ConversationUser for this user and conversation
            $finder = $this->finder('XF:ConversationUser');
            $finder->where('conversation_id', $conversationId);
            $finder->where('owner_user_id', $visitor->user_id);
            $userConv = $finder->fetchOne();
            
            if (!$userConv || !$userConv->Master) {
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }
            
            $conversation = $userConv->Master;

            if (!$conversation->canView()) {
                return $this->apiError('Cannot view this conversation', null, ErrorCode::NO_PERMISSION);
            }

            // Check edit permission (only creator can edit)
            if (!$conversation->canEdit($error)) {
                return $this->apiError('Cannot edit this conversation' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's EditorService (same as core API uses)
            /** @var \XF\Service\Conversation\Editor $editor */
            $editor = $this->service('XF:Conversation\Editor', $conversation);

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
                return $this->apiFieldErrors($errors);
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
            return $this->apiException($e, 'Failed to save conversation');
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
            return $this->apiError('Message ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // Find message
            $message = $this->em()->find('XF:ConversationMessage', (int)$messageId);
            
            if (!$message) {
                return $this->apiError('Message not found', null, ErrorCode::NOT_FOUND);
            }

            // Check if message is viewable
            $error = null;
            if (!$message->canView($error)) {
                return $this->apiError('Cannot view this message', null, ErrorCode::NO_PERMISSION);
            }

            // Check edit permission
            if (!$message->canEdit($error)) {
                return $this->apiError('Cannot edit this message' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
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
            return $this->apiException($e, 'Failed to get raw message');
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
        $groupId = $params->get('groupId', '');

        if (empty($messageId) || empty($messageContent)) {
            return $this->apiError('Message ID and content are required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // Find message
            $message = $this->em()->find('XF:ConversationMessage', (int)$messageId);
            
            if (!$message) {
                return $this->apiError('Message not found', null, ErrorCode::NOT_FOUND);
            }

            $conversation = $message->Conversation;
            if (!$conversation) {
                return $this->apiError('Conversation not found', null, ErrorCode::NOT_FOUND);
            }

            // Check if message is viewable
            $error = null;
            if (!$message->canView($error)) {
                return $this->apiError('Cannot view this message', null, ErrorCode::NO_PERMISSION);
            }

            // Check edit permission
            if (!$message->canEdit($error)) {
                return $this->apiError('Cannot edit this message' . ($error ? ': ' . $error : ''), null, ErrorCode::NO_PERMISSION);
            }

            // Use XenForo's MessageEditorService (same as core API uses)
            /** @var \XF\Service\Conversation\MessageEditor $editor */
            $editor = $this->service('XF:Conversation\MessageEditor', $message);
            $editor->setMessageContent($messageContent);

            // New uploads come as the upload hash (groupId). attachmentIds
            // lists the attachments the message already has, which stay as
            // they are, as on XenForo's own edit form.
            if ($groupId && $conversation->canUploadAndManageAttachments()) {
                $editor->setAttachmentHash($groupId);
            }

            // Validate before saving
            if (!$editor->validate($errors)) {
                return $this->apiFieldErrors($errors);
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
            return $this->apiException($e, 'Failed to save message');
        }
    }
}

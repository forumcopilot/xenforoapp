<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCNewConversationResult;
use ForumCopilot\Result\FCReplyConversationResult;
use ForumCopilot\Result\FCConversationsResult;
use ForumCopilot\Result\FCConversationResult;
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

        $startNum = (int)$params->get('startNum', 0);
        $lastNum = (int)$params->get('lastNum', 19);

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
            $perPage = $this->clampPerPage($lastNum - $startNum + 1);
            $page = (int)floor(max(0, $startNum) / $perPage) + 1;
            $finder->limitByPage($page, $perPage);
            
            // Fetch ConversationUser entities (not ConversationMaster directly)
            $userConvs = $finder->fetch();
            $total = $finder->total();
            $unreadInfo = $this->getUnreadMessageInfo($userConvs);
            
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
                    
                    $canReply = $conversation->canReply();
                    // XenForo has no deleting a conversation, only leaving it
                    $canDelete = false;
                    $canInvite = $conversation->canInvite();
                    // Only the starter can edit, close or reopen a conversation
                    $canEdit = $conversation->canEdit();
                    $canClose = $canEdit;
                    $isClosed = !$conversation->conversation_open;
                    
                    // Conversation starter; the master keeps the name when the
                    // account has gone
                    $startUserId = $conversation->user_id ? (string)$conversation->user_id : '';
                    $startUsername = $conversation->Starter ? $conversation->Starter->username : (string)$conversation->username;
                    $startUserIconUrl = $conversation->Starter
                        ? $this->getAbsoluteUrl($conversation->Starter->getAvatarUrl('s'))
                        : '';
                    
                    // Last message author
                    $lastMessageAuthorId = $conversation->last_message_user_id ? (string)$conversation->last_message_user_id : '';
                    $lastMessageAuthorIconUrl = $conversation->LastMessageUser
                        ? $this->getAbsoluteUrl($conversation->LastMessageUser->getAvatarUrl('s'))
                        : '';
                    
                    $participantCount = (int)$conversation->recipient_count;

                    // Everyone but the starter, from the list XenForo keeps on
                    // the conversation itself (no extra query)
                    $participants = [];
                    foreach ((array)$conversation->recipients as $recipient) {
                        if (!empty($recipient['user_id']) && $recipient['user_id'] != $conversation->user_id) {
                            $participants[] = [
                                'id' => (string)$recipient['user_id'],
                                'username' => (string)($recipient['username'] ?? ''),
                            ];
                        }
                    }
                    
                    // Message to open: the first unread one, otherwise the latest
                    $messageId = null;
                    $unreadMessageCount = 0;
                    if ($isUnread && isset($unreadInfo[$conversation->conversation_id])) {
                        $messageId = (string)$unreadInfo[$conversation->conversation_id]['first_unread'];
                        $unreadMessageCount = (int)$unreadInfo[$conversation->conversation_id]['unread'];
                    }
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
                        'participants' => $participants,
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

            // XenForo keeps the member's unread conversation count
            $unreadCount = (int)$visitor->conversations_unread;
            
            $result = new FCConversationsResult(
                true,
                null,
                (int)$total,
                $unreadCount,
                // Attaching files to direct messages, as the new-message form
                // decides (ConversationMaster::canUploadAndManageAttachments)
                (bool)$visitor->hasPermission('conversation', 'uploadAttachment'),
                $conversationList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get conversations');
        }
    }

    /**
     * Unread messages for the unread conversations on a page, in one query:
     * conversation id => [unread count, first unread message id].
     *
     * @param \XF\Mvc\Entity\AbstractCollection $userConvs ConversationUser entities
     * @return array
     */
    protected function getUnreadMessageInfo($userConvs): array
    {
        $ids = [];
        foreach ($userConvs as $userConv) {
            if ($userConv->is_unread) {
                $ids[] = (int)$userConv->conversation_id;
            }
        }
        if (!$ids) {
            return [];
        }

        return $this->app()->db()->fetchAllKeyed(
            'SELECT m.conversation_id, COUNT(*) AS unread, MIN(m.message_id) AS first_unread
            FROM xf_conversation_message AS m
            INNER JOIN xf_conversation_recipient AS r
                ON (r.conversation_id = m.conversation_id AND r.user_id = ?)
            WHERE m.conversation_id IN (' . $this->app()->db()->quote($ids) . ')
                AND m.message_date > r.last_read_date
            GROUP BY m.conversation_id',
            'conversation_id',
            [\XF::visitor()->user_id]
        );
    }

    /**
     * Page size for a list request, at most 100, so one call can't ask for a
     * whole long conversation at once. The app asks for 20.
     */
    protected function clampPerPage($perPage): int
    {
        return max(1, min(100, (int)$perPage));
    }

    /**
     * The app's rows for a page of conversation messages. Attachments are
     * loaded for the whole page in one query, as XenForo's conversation view
     * does; reactions are fetched only for messages that have some; the
     * message number comes from the page offset (messages are ordered by date,
     * then id, which is the order getMessagePosition counts in). Alerts about
     * the messages shown are marked read, as on the website.
     *
     * @param \XF\Mvc\Entity\AbstractCollection $messages
     * @param int $lastRead the member's last read date in this conversation
     * @param int $offset how many messages come before this page
     * @return array
     */
    protected function buildConversationMessageRows($messages, $lastRead, $offset, bool $withHtml = false): array
    {
        $this->repository('XF:Attachment')->addAttachmentsToContent($messages, 'conversation_message');
        if ($withHtml) {
            $this->preloadAppHtmlContent($messages);
        }

        $alertRepo = $this->repository('XF:UserAlert');
        if ($messages->count() && method_exists($alertRepo, 'markUserAlertsReadForContent')) {
            $alertRepo->markUserAlertsReadForContent('conversation_message', $messages->keys());
        }

        $rows = [];
        $i = 0;
        foreach ($messages as $message) {
            $likeFlags = $this->getConversationMessageLikeFlags($message);
            $likeCount = $this->getReactionCount($message);

            $attachments = [];
            foreach ($this->getConversationMessageAttachments($message) as $attachment) {
                $attachments[] = $attachment instanceof \ForumCopilot\Entity\FCAttachment
                    ? $attachment->toArray()
                    : $attachment;
            }

            $rows[] = [
                'id' => (string)$message->message_id,
                'authorId' => (string)$message->user_id,
                'authorName' => $message->User ? $message->User->username : $message->username,
                'authorIconUrl' => $message->User ? $this->getAbsoluteUrl($message->User->getAvatarUrl('s')) : '',
                'timestamp' => $message->message_date * 1000,
                // Always the raw message (BBCode)
                'messageContent' => $message->message,
                'messageNumber' => $offset + (++$i),
                'canEdit' => $message->canEdit(),
                // XenForo has no deleting a direct message
                'canDelete' => false,
                'canReport' => $message->canReport(),
                'canLike' => $likeFlags['canLike'],
                'isLiked' => $likeFlags['isLiked'],
                'likeCount' => $likeCount,
                'likesInfo' => $likeCount ? $this->getConversationMessageLikesInfo($message) : [],
                'attachments' => $attachments,
                'isUnread' => $message->message_date > $lastRead,
                'isFirstMessage' => $message->message_id == $message->Conversation->first_message_id,
                'isIgnored' => $message->isIgnored(),
            ];
            if ($withHtml) {
                // Optional (1.11.0, contentHtml: true): the message as HTML
                $rows[count($rows) - 1]['contentHtml'] = $this->renderAppHtml($message->message, 'conversation_message', $message);
            }
        }

        return $rows;
    }

    public function actionGetConversation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $conversationId = $params->get('conversationId', '');
        $startNum = (int)$params->get('startNum', 0);
        $lastNum = (int)$params->get('lastNum', 19);

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
            $perPage = $this->clampPerPage($lastNum - $startNum + 1);
            // Offset should be startNum - 1 (since position 1 = offset 0)
            $offset = max(0, $startNum - 1);
            $finder->limit($perPage, $offset);
            
            $messages = $finder->fetch();
            $messageList = $this->buildConversationMessageRows($messages, $lastRead, $offset, (bool)filter_var($params->get('contentHtml', false), FILTER_VALIDATE_BOOLEAN));

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
        $messagesPerRequest = $this->clampPerPage($params->get('messagesPerRequest', 20));

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
            $messageList = $this->buildConversationMessageRows($messages, $lastRead, $offset, (bool)filter_var($params->get('contentHtml', false), FILTER_VALIDATE_BOOLEAN));

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
            // Optional (1.11.0): ignore: true, the name XenForo's REST API uses, is mode 2
            $recipientState = ($mode == 2 || $params->get('ignore')) ? 'deleted_ignored' : 'deleted';

            // Update recipient state (following XenForo core pattern)
            $recipient = $userConv->Recipient;
            if (!$recipient) {
                return $this->apiError(\XF::phrase('requested_direct_message_not_found'), null, ErrorCode::NOT_FOUND);
            }
            $recipient->recipient_state = $recipientState;
            $recipient->save(); // _postSave will handle ConversationUser deletion and conversation updates

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

            // Quoting is for replying, as XenForo's ConversationController::actionReply
            if (!$message->Conversation->canReply()) {
                return $this->apiError(\XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

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

            // Added, switched, or toggled off when it is the member's current
            // one. reactionId defaults to 1 (Like) for app builds that don't send it.
            $reacted = $this->toggleVisitorReaction($message, max(1, (int)$params->get('reactionId', 1)));
            if (!is_array($reacted)) {
                return $reacted;
            }
            $visitorReactionId = $reacted['reactionId'];

            // Refresh the message so its reaction counts reflect the change.
            $message = $this->em()->find('XF:ConversationMessage', $message->message_id);

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

            if ($error = $this->removeVisitorReaction($message)) {
                return $error;
            }

            // Refresh the message so its reaction counts reflect the change.
            $message = $this->em()->find('XF:ConversationMessage', $message->message_id);

            $result = new FCUnlikePostResult(
                true,
                null,
                false,
                $this->getReactionCount($message)
            );

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

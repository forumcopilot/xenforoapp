<?php

namespace ForumCopilot\Service\Alert;

use XF\Service\AbstractService;
use XF\Entity\UserAlert;
use ForumCopilot\Push\ForumCopilotPush;
use ForumCopilot\Service\Alert\AlertPushCollector;

class AlertPushProcessor extends AbstractService
{
    /**
     * Process all pending batched alerts
     * This is called at end of request after all alerts have been created
     */
    public function processPendingAlerts()
    {
        $collected = AlertPushCollector::getCollectedAlerts();

        if (empty($collected)) {
            return;
        }

        $this->processCollectedAlerts($collected);
    }

    /**
     * Process collected alerts (can be called from job or directly)
     *
     * @param array $collected
     */
    public function processCollectedAlerts(array $collected)
    {
        if (empty($collected)) {
            \XF::logError('[FC DEBUG] AlertPushProcessor: no collected alerts');
            return;
        }

        // Step 1: Get all unique receiver IDs from collected alerts
        $allReceiverIds = array_unique(array_column($collected, 'receiverId'));

        \XF::logError(sprintf(
            '[FC DEBUG] AlertPushProcessor: %d collected alert(s) for %d unique receiver(s) [%s]',
            count($collected), count($allReceiverIds), implode(',', $allReceiverIds)
        ));

        if (empty($allReceiverIds)) {
            AlertPushCollector::clear();
            return;
        }

        // Step 2: Single bulk query to get app users (users with app installed)
        $appUserIds = $this->getAppUserIds($allReceiverIds);

        \XF::logError(sprintf(
            '[FC DEBUG] AlertPushProcessor: %d/%d receiver(s) have app installed [%s]',
            count($appUserIds), count($allReceiverIds), implode(',', $appUserIds)
        ));

        if (empty($appUserIds)) {
            // No app users, nothing to process
            \XF::logError('[FC DEBUG] AlertPushProcessor: SKIP — no recipients have app installed (xf_fc_user.last_seen within 90d). Recipient IDs: ' . implode(',', $allReceiverIds));
            AlertPushCollector::clear();
            return;
        }

        // Step 3: Filter collected alerts to only app users
        $appUserAlerts = array_filter($collected, function($alert) use ($appUserIds) {
            return in_array($alert['receiverId'], $appUserIds);
        });

        if (empty($appUserAlerts)) {
            AlertPushCollector::clear();
            return;
        }

        // Step 4: Group alerts by (contentType, contentId, action) for batching
        $groupedAlerts = $this->groupAlertsByBatch($appUserAlerts);

        // Step 5: Process each batch (one HTTP request per batch)
        foreach ($groupedAlerts as $batchKey => $batchAlerts) {
            try {
                $this->processBatch($batchAlerts);
            } catch (\Exception $ex) {
                // Log error but continue processing other batches
                \XF::logError('ForumCopilot Alert Push Error (batch ' . $batchKey . '): ' . $ex->getMessage());
            }
        }

        // Note: Alerts are cleared in Listener when job is enqueued
        // No need to clear here since we're processing from job data
    }

    /**
     * Get app user IDs (users with app installed) - single bulk query
     *
     * @param array $userIds
     * @return array Array of user IDs that have app installed
     */
    protected function getAppUserIds(array $userIds)
    {
        if (empty($userIds)) {
            return [];
        }

        $db = $this->db();
        $cutoffTime = time() - (90 * 24 * 60 * 60); // 90 days
        
        $placeholders = str_repeat('?,', count($userIds) - 1) . '?';
        return $db->fetchAllColumn(
            "SELECT user_id FROM xf_fc_user 
             WHERE user_id IN ($placeholders) 
             AND last_seen > ?",
            array_merge($userIds, [$cutoffTime])
        );
    }

    /**
     * Group alerts by batch key (contentType_contentId_action)
     *
     * @param array $alerts
     * @return array Grouped alerts by batch key
     */
    protected function groupAlertsByBatch(array $alerts)
    {
        $grouped = [];
        
        foreach ($alerts as $alert) {
            $batchKey = $this->getBatchKey(
                $alert['contentType'],
                $alert['contentId'],
                $alert['action']
            );
            
            if (!isset($grouped[$batchKey])) {
                $grouped[$batchKey] = [
                    'contentType' => $alert['contentType'],
                    'contentId' => $alert['contentId'],
                    'action' => $alert['action'],
                    'senderId' => $alert['senderId'],
                    'receiverIds' => []
                    // Alert entity will be fetched in processBatch()
                ];
            }
            
            // Collect receiver IDs for this batch
            $grouped[$batchKey]['receiverIds'][] = $alert['receiverId'];
        }
        
        // Remove duplicates from receiver IDs
        foreach ($grouped as &$batch) {
            $batch['receiverIds'] = array_unique($batch['receiverIds']);
        }
        
        return $grouped;
    }

    /**
     * Get batch key for grouping alerts
     *
     * @param string $contentType
     * @param int $contentId
     * @param string $action
     * @return string
     */
    protected function getBatchKey($contentType, $contentId, $action)
    {
        return "{$contentType}_{$contentId}_{$action}";
    }

    /**
     * Process a single batch of alerts
     *
     * @param array $batchData Contains: contentType, contentId, action, senderId, receiverIds
     */
    protected function processBatch(array $batchData)
    {
        $contentType = $batchData['contentType'];
        $contentId = $batchData['contentId'];
        $action = $batchData['action'];
        $senderId = $batchData['senderId'];
        $receiverIds = $batchData['receiverIds'];

        if (empty($receiverIds)) {
            return;
        }

        // Fetch one alert entity for this batch to extract Title/Body/URL
        // We'll use the first receiver ID to find a matching alert
        $alertRepo = $this->app->repository('XF:UserAlert');
        $firstReceiverId = reset($receiverIds);
        
        $alertFinder = $alertRepo->findAlertsForUser($firstReceiverId);
        $alertFinder->where('content_type', $contentType);
        $alertFinder->where('content_id', $contentId);
        $alertFinder->where('action', $action);
        $alertFinder->order('event_date', 'DESC');
        $alertFinder->limit(1);
        $alerts = $alertFinder->fetch();
        
        if ($alerts->count() === 0) {
            // No alert found, can't process
            return;
        }
        
        $alert = $alerts->first();

        // Filter by opt-out preferences (bulk check)
        $validUserIds = $this->filterByOptOut($receiverIds, $senderId, $contentType, $action);

        if (empty($validUserIds)) {
            return;
        }

        // Extract Title, Body, URL from alert
        $alertData = $this->extractAlertData($alert);

        if (!$alertData) {
            // Can't process without alert data
            return;
        }

        // Add additional fields available without queries
        $alertData['sender_id'] = $senderId;
        $alertData['content_type'] = $contentType;
        $alertData['content_id'] = $contentId;
        $alertData['action'] = $action;
        $alertData['event_date'] = $alert->event_date;

        // Get content to extract thread information for post-type alerts
        $content = $alert->getContent();

        if ($contentType === 'post' && $content) {
            $topic_id = $content->get('thread_id');
            if ($topic_id) {
                $alertData['topic_id'] = $topic_id;
            }
        } elseif ($contentType === 'thread' && $content) {
            $topic_id = $content->get('thread_id');
            if ($topic_id) {
                $alertData['topic_id'] = $topic_id;
            }
        } elseif ($contentType === 'conversation_message' && $content) {
            $conversation_id = $content->get('conversation_id');
            if ($conversation_id) {
                $alertData['conversation_id'] = $conversation_id;
            }
        }

        // Use constant batch size
        $batchSize = 1000;

        // Split into chunks if needed
        $chunks = array_chunk($validUserIds, $batchSize);

        // Send push for each chunk
        foreach ($chunks as $chunk) {
            $this->sendPush($chunk, $alertData);
        }
    }

    /**
     * Filter users by opt-out preferences (optimized with direct DB query)
     *
     * @param array $userIds Already filtered to app users
     * @param int $senderId
     * @param string $contentType
     * @param string $action
     * @return array Valid user IDs
     */
    protected function filterByOptOut(array $userIds, $senderId, $contentType, $action)
    {
        if (empty($userIds)) {
            return [];
        }

        $db = $this->db();
        $placeholders = str_repeat('?,', count($userIds) - 1) . '?';
        
        // Single optimized query to get user data and opt-out preferences
        $optOutKey = "{$contentType}_{$action}";
        
        // Get users with their opt-out preferences from normalization table
        $userOptOuts = $db->fetchAllKeyed("
            SELECT u.user_id, u.is_banned,
                   GROUP_CONCAT(optout.push) as fc_push_optout
            FROM xf_user u
            LEFT JOIN xf_user_fc_push_optout optout ON optout.user_id = u.user_id
            WHERE u.user_id IN ($placeholders)
            GROUP BY u.user_id
        ", 'user_id', $userIds);

        $validUserIds = [];
        
        foreach ($userOptOuts as $userId => $userData) {
            // Check if banned
            if ($userData['is_banned']) {
                continue;
            }
            
            // Check opt-out preferences
            $optOuts = $userData['fc_push_optout'] ? explode(',', $userData['fc_push_optout']) : [];
            if (in_array($optOutKey, $optOuts)) {
                continue;
            }
            
            // Note: We skip the ignored check and doesReceiveAlert check here for performance
            // These are less common cases and would require additional queries
            // If needed, we can add them later with separate optimized queries
            
            $validUserIds[] = $userId;
        }
        
        return $validUserIds;
    }

    /**
     * Extract Title, Body, URL from alert using handler templates
     *
     * @param UserAlert $alert
     * @return array|null ['title' => ..., 'body' => ..., 'url' => ...]
     */
    protected function extractAlertData(UserAlert $alert)
    {
        $receiver = $alert->User;
        if (!$receiver) {
            return null;
        }

        $handler = $alert->getHandler();
        $content = $alert->getContent();

        if (!$handler || !$content) {
            return null;
        }

        // Extract Title
        $title = $this->getNotificationTitle($alert, $receiver);

        // Extract Body
        $body = $this->getNotificationBody($alert, $receiver, $handler, $content);

        // Extract URL
        $url = $this->getNotificationUrl($content);

        return [
            'title' => $title,
            'body' => $body,
            'url' => $url
        ];
    }

    /**
     * Get notification title
     *
     * @param UserAlert $alert
     * @param \XF\Entity\User $receiver
     * @return string
     */
    protected function getNotificationTitle(UserAlert $alert, \XF\Entity\User $receiver)
    {
        return $this->app->options()->boardTitle;
    }

    /**
     * Get notification body
     *
     * @param UserAlert $alert
     * @param \XF\Entity\User $receiver
     * @param \XF\Alert\AbstractHandler $handler
     * @param \XF\Mvc\Entity\Entity $content
     * @return string
     */
    protected function getNotificationBody(UserAlert $alert, \XF\Entity\User $receiver, $handler, $content)
    {
        $templater = $this->app->templater();
        $language = $this->app->userLanguage($receiver);
        $style = $this->app->style($receiver->style_id ?: $this->app->options()->defaultStyleId);

        $originalLang = $templater->getLanguage();
        $originalStyle = $templater->getStyle();

        try {
            $templater->setLanguage($language);
            $templater->setStyle($style);

            $templateName = $handler->getPushTemplateName($alert->action);
            if (!$templater->isKnownTemplate($templateName)) {
                $templateName = $handler->getTemplateName($alert->action);
            }
            $templateData = $handler->getTemplateData($alert->action, $alert, $content);

            $pushContent = \XF::asVisitor(
                $receiver,
                function () use ($templater, $templateName, $templateData) {
                    $templater->addDefaultParam(
                        'xf',
                        \XF::app()->getGlobalTemplateData()
                    );
                    return $templater->renderTemplate($templateName, $templateData);
                }
            );
        } finally {
            if ($originalLang) {
                $templater->setLanguage($originalLang);
            }
            if ($originalStyle) {
                $templater->setStyle($originalStyle);
            }
        }

        // Remove <push:url> and <push:tag> tags before stripping other tags
        // These tags contain URLs/metadata that should not appear in the message body
        $pushContent = preg_replace('#<(push:[a-z0-9_]+)>.*</\\1>#siU', '', $pushContent);
        
        $pushContent = strip_tags($pushContent);
        $pushContent = html_entity_decode($pushContent, ENT_QUOTES);
        return trim($pushContent);
    }

    /**
     * Get notification URL
     *
     * @param \XF\Mvc\Entity\Entity $content
     * @return string|null
     */
    protected function getNotificationUrl($content)
    {
        if (method_exists($content, 'getContentUrl')) {
            return $content->getContentUrl(true);
        }

        return null;
    }

    /**
     * Send simplified push notification
     * Simplified payload: Title, Message, URL, user IDs, and available metadata
     *
     * @param array $userIds
     * @param array $alertData ['title' => ..., 'body' => ..., 'url' => ..., 'sender_id' => ..., etc.]
     */
    protected function sendPush(array $userIds, array $alertData)
    {
        try {
            $router = new \ForumCopilot\Service\Push\DispatchRouter();
            $router->dispatch(
                $userIds,
                (string)($alertData['title'] ?? ''),
                (string)($alertData['body'] ?? ''),
                (string)($alertData['url'] ?? ''),
                $alertData
            );
        } catch (\Exception $ex) {
            \XF::logError('ForumCopilot Simplified Push Error: ' . $ex->getMessage());
        }
    }
}


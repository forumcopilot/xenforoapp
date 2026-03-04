<?php

namespace ForumCopilot\Service\Alert;

class AlertPushCollector
{
    /**
     * Static storage for collected individual alerts
     * Each alert is stored with its receiver ID for later bulk processing
     */
    protected static $collectedAlerts = [];

    /**
     * Collect individual alert for batch processing
     * Called during alert creation - no filtering here, just collection
     * Alert entity will be fetched later during processing
     *
     * @param int $receiverId
     * @param int|null $senderId
     * @param string $contentType
     * @param int $contentId
     * @param string $action
     */
    public static function collectAlert($receiverId, $senderId, $contentType, $contentId, $action)
    {
        // Store individual alert with receiver ID
        // We'll group and filter in bulk later, and fetch alert entity then
        self::$collectedAlerts[] = [
            'receiverId' => $receiverId,
            'senderId' => $senderId,
            'contentType' => $contentType,
            'contentId' => $contentId,
            'action' => $action
        ];
    }

    /**
     * Get all collected alerts
     *
     * @return array
     */
    public static function getCollectedAlerts()
    {
        return self::$collectedAlerts;
    }

    /**
     * Clear collected alerts
     */
    public static function clear()
    {
        self::$collectedAlerts = [];
    }
}


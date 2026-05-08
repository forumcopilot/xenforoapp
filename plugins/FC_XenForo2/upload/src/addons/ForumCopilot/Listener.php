<?php

namespace ForumCopilot;

use XF;

class Listener
{
    /**
     * Process batched alert push notifications at end of request
     * Enqueues a background job instead of processing directly
     */
    public static function processBatchedAlerts()
    {
        $options = XF::options();
        if (!isset($options->fc_push_enabled) || !$options->fc_push_enabled) {
            return;
        }

        $collected = \ForumCopilot\Service\Alert\AlertPushCollector::getCollectedAlerts();

        if (empty($collected)) {
            return;
        }

        \XF::logError('[FC DEBUG] Listener.processBatchedAlerts: enqueuing job with ' . count($collected) . ' alert(s)');

        // Enqueue background job to process alerts
        $jobManager = XF::app()->jobManager();
        $jobManager->enqueueUnique(
            'forumCopilotAlertPush',
            'ForumCopilot:ProcessAlertPush',
            ['collectedAlerts' => $collected],
            false // Don't run immediately
        );

        // Clear collected alerts (they're now in the job)
        \ForumCopilot\Service\Alert\AlertPushCollector::clear();
    }
}
<?php

namespace ForumCopilot\Job;

use XF\Job\AbstractJob;

class ProcessAlertPush extends AbstractJob
{
    protected $defaultData = [
        'collectedAlerts' => []
    ];

    public function run($maxRunTime)
    {
        $start = microtime(true);
        
        $collectedAlerts = $this->data['collectedAlerts'];
        
        if (empty($collectedAlerts)) {
            return $this->complete();
        }

        $processor = new \ForumCopilot\Service\Alert\AlertPushProcessor(\XF::app());
        
        // Process collected alerts directly (bypass collector)
        $processor->processCollectedAlerts($collectedAlerts);

        return $this->complete();
    }

    public function getStatusMessage()
    {
        $count = count($this->data['collectedAlerts'] ?? []);
        return "Processing {$count} alert push notifications...";
    }

    public function canCancel()
    {
        return false;
    }

    public function canTriggerByChoice()
    {
        return false;
    }
}


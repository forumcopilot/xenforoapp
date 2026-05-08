<?php

namespace ForumCopilot\Job;

use XF\Job\AbstractJob;

/**
 * Async FCM dispatch job for the BYO ("direct") push mode.
 *
 * Payload:
 *   userIds  int[]      — target user ids
 *   title    string
 *   body     string
 *   url      string
 *   data     array      — extra metadata baked into the FCM `data` payload
 *
 * Hosted-mode dispatch still happens synchronously inline via ForumCopilotPush
 * since that's just an HTTP POST to your queue-backed push backend (which itself
 * does the async fan-out). Direct mode needs its own job because we're calling
 * FCM in-process and don't want to block the request that triggered the alert.
 */
class FcmDispatch extends AbstractJob
{
    protected $defaultData = [
        'userIds' => [],
        'title'   => '',
        'body'    => '',
        'url'     => '',
        'data'    => [],
    ];

    public function run($maxRunTime)
    {
        $userIds = $this->data['userIds'] ?? [];
        \XF::logError('[FC DEBUG] FcmDispatch.run: userIds=[' . implode(',', $userIds) . ']');
        if (!$userIds) {
            return $this->complete();
        }

        try {
            /** @var \ForumCopilot\Repository\DeviceToken $repo */
            $repo = \XF::repository('ForumCopilot:DeviceToken');
            $devices = $repo->findValidTokensForUsers((array)$userIds, 'direct')->fetch()->toArray();

            \XF::logError(sprintf(
                '[FC DEBUG] FcmDispatch.run: %d device(s) found for direct dispatch',
                count($devices)
            ));

            if (!$devices) {
                return $this->complete();
            }

            $dispatcher = new \ForumCopilot\Service\Push\DirectDispatcher();
            if (!$dispatcher->isReady()) {
                \XF::logError('FC FcmDispatch: dispatcher not ready: ' . ($dispatcher->getConfigError() ?? 'unknown'));
                return $this->complete();
            }

            $stats = $dispatcher->dispatch(
                $devices,
                (string)($this->data['title'] ?? ''),
                (string)($this->data['body'] ?? ''),
                (string)($this->data['url'] ?? ''),
                (array)($this->data['data'] ?? [])
            );

            \XF::logError(sprintf(
                'FC FcmDispatch: sent=%d failed=%d invalidated=%d (target=%d devices)',
                $stats['sent'] ?? 0,
                $stats['failed'] ?? 0,
                $stats['invalidated'] ?? 0,
                count($devices)
            ));
        } catch (\Throwable $e) {
            \XF::logError('FC FcmDispatch run error: ' . $e->getMessage());
        }

        return $this->complete();
    }

    public function getStatusMessage()
    {
        return 'Sending Forum Copilot push notifications…';
    }

    public function canCancel()
    {
        return true;
    }

    public function canTriggerByChoice()
    {
        return false;
    }
}

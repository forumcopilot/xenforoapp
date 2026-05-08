<?php

namespace ForumCopilot\Service\Push;

/**
 * Single entry point for dispatching alerts to all configured push paths.
 *
 * Reads admin options:
 *   fc_push_hosted_enabled        — route 'forumcopilot' devices through ForumCopilotPush (HTTP→hosted backend)
 *   fc_push_direct_enabled        — route 'direct' devices through DirectDispatcher (FcmClient)
 *   fc_push_enabled               — legacy global gate; if false, both modes are off
 *
 * Both can be enabled simultaneously — devices are grouped by their `source`
 * column and each group goes through the matching dispatcher. A user with both
 * the official app and a white-label app installed receives both pushes.
 *
 * The hosted dispatcher is called inline (it's just an HTTP POST to the push
 * backend, which itself queues async). The direct dispatcher is enqueued as
 * an XF Job so the in-process FCM round-trip doesn't block the request.
 */
class DispatchRouter
{
    /**
     * @param int[] $userIds
     */
    public function dispatch(array $userIds, string $title, string $body, string $url, array $data = []): void
    {
        $contentType = $data['content_type'] ?? 'unknown';
        $action = $data['action'] ?? 'unknown';

        if (!$userIds) {
            \XF::logError('[FC DEBUG] DispatchRouter: skip — empty userIds (' . $contentType . '/' . $action . ')');
            return;
        }

        $opts = \XF::options();
        $globallyEnabled = !empty($opts->fc_push_enabled);
        if (!$globallyEnabled) {
            \XF::logError('[FC DEBUG] DispatchRouter: skip — fc_push_enabled is OFF');
            return;
        }

        $hostedEnabled = !empty($opts->fc_push_hosted_enabled);
        // Direct mode requires both the toggle AND a credentials path. Default
        // installs ship with the toggle on but the path empty — silently skip
        // until the admin drops a service-account JSON in place. Avoids
        // spawning no-op jobs and "dispatcher not ready" log spam on every alert.
        $directEnabled = !empty($opts->fc_push_direct_enabled)
            && !empty(trim((string)($opts->fc_push_direct_creds_path ?? '')));
        if (!$hostedEnabled && !$directEnabled) {
            \XF::logError('[FC DEBUG] DispatchRouter: skip — both hosted and direct disabled');
            return;
        }

        \XF::logError(sprintf(
            '[FC DEBUG] DispatchRouter: dispatching %s/%s to %d user(s) [hosted=%s, direct=%s]',
            $contentType, $action, count($userIds),
            $hostedEnabled ? 'on' : 'off',
            $directEnabled ? 'on' : 'off'
        ));

        // Hosted path — fire inline, mirroring previous behavior. The hosted
        // backend handles its own async fan-out.
        if ($hostedEnabled) {
            try {
                $hosted = new \ForumCopilot\Push\ForumCopilotPush();
                $hosted->sendPushNotification($userIds, $title, $body, $url, $data);
                \XF::logError('[FC DEBUG] DispatchRouter: hosted sendPushNotification returned (HTTP outcome logged separately)');
            } catch (\Throwable $e) {
                \XF::logError('FC DispatchRouter hosted push error: ' . $e->getMessage());
            }
        }

        // Direct path — enqueue, run from cron to avoid blocking the request.
        if ($directEnabled) {
            try {
                \XF::app()->jobManager()->enqueueUnique(
                    'fcDirectPush:' . md5(implode(',', $userIds) . ':' . $title . ':' . $body),
                    \ForumCopilot\Job\FcmDispatch::class,
                    [
                        'userIds' => array_values(array_map('intval', $userIds)),
                        'title'   => $title,
                        'body'    => $body,
                        'url'     => $url,
                        'data'    => $data,
                    ],
                    false
                );
            } catch (\Throwable $e) {
                \XF::logError('FC DispatchRouter direct enqueue error: ' . $e->getMessage());
            }
        }
    }
}

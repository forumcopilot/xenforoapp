<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;

/**
 * Device-token registration endpoints used by the mobile app.
 *
 * Methods exposed via forumcopilot.php dispatcher:
 *   - registerDevice    POST {deviceId, fcmToken, platform, source, appVersion?}
 *   - unregisterDevice  POST {deviceId}
 *   - updateDeviceToken POST {deviceId, fcmToken}
 *
 * `source` is the routing hint: 'forumcopilot' (official app, dispatched via
 * the hosted push backend) or 'direct' (white-label app, dispatched in-process
 * to the customer's Firebase project).
 */
class DeviceController extends AbstractController
{
    public function actionRegisterDevice(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $deviceId   = trim((string)$params->get('deviceId', ''));
        $fcmToken   = trim((string)$params->get('fcmToken', ''));
        $platform   = strtolower(trim((string)$params->get('platform', '')));
        $source     = trim((string)$params->get('source', 'direct'));
        $appVersion = trim((string)$params->get('appVersion', ''));

        if ($deviceId === '' || $fcmToken === '') {
            return $this->apiError('deviceId and fcmToken are required', 400);
        }
        if (!in_array($platform, ['ios', 'android', 'macos', 'web'], true)) {
            return $this->apiError('platform must be one of: ios, android, macos, web', 400);
        }
        if (!in_array($source, ['forumcopilot', 'direct'], true)) {
            return $this->apiError("source must be 'forumcopilot' or 'direct'", 400);
        }

        try {
            /** @var \ForumCopilot\Repository\DeviceToken $repo */
            $repo = $this->repository('ForumCopilot:DeviceToken');
            $entity = $repo->upsert(
                $deviceId,
                (int)\XF::visitor()->user_id,
                $fcmToken,
                $platform,
                $source,
                $appVersion
            );

            return $this->apiResponse(true, 'success', [
                'device' => [
                    'deviceId' => $entity->device_id,
                    'platform' => $entity->platform,
                    'source'   => $entity->source,
                ],
            ]);
        } catch (\Exception $e) {
            return $this->apiError('Failed to register device: ' . $e->getMessage());
        }
    }

    public function actionUnregisterDevice(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $deviceId = trim((string)$params->get('deviceId', ''));
        if ($deviceId === '') {
            return $this->apiError('deviceId is required', 400);
        }

        try {
            /** @var \ForumCopilot\Repository\DeviceToken $repo */
            $repo = $this->repository('ForumCopilot:DeviceToken');

            // Only delete if it belongs to the visitor — never let one user
            // delete another's device row by guessing an id.
            $entity = $this->em()->find('ForumCopilot:DeviceToken', $deviceId);
            if ($entity && (int)$entity->user_id === (int)\XF::visitor()->user_id) {
                $repo->deleteByDeviceId($deviceId);
            }
            return $this->apiResponse(true, 'success', []);
        } catch (\Exception $e) {
            return $this->apiError('Failed to unregister device: ' . $e->getMessage());
        }
    }

    public function actionUpdateDeviceToken(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $deviceId = trim((string)$params->get('deviceId', ''));
        $fcmToken = trim((string)$params->get('fcmToken', ''));
        if ($deviceId === '' || $fcmToken === '') {
            return $this->apiError('deviceId and fcmToken are required', 400);
        }

        try {
            /** @var \ForumCopilot\Entity\DeviceToken $entity */
            $entity = $this->em()->find('ForumCopilot:DeviceToken', $deviceId);
            if (!$entity) {
                return $this->apiError('Device not found — call registerDevice first', 404);
            }
            if ((int)$entity->user_id !== (int)\XF::visitor()->user_id) {
                return $this->apiError('Device does not belong to current user', 403);
            }

            $entity->fcm_token      = $fcmToken;
            $entity->is_token_valid = true;
            $entity->last_seen_at   = \XF::$time;
            $entity->save();

            return $this->apiResponse(true, 'success', []);
        } catch (\Exception $e) {
            return $this->apiError('Failed to update device token: ' . $e->getMessage());
        }
    }
}

<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
use XF\Mvc\ParameterBag;

/**
 * Device-token registration endpoints used by the mobile app.
 *
 * Methods exposed via forumcopilot.php dispatcher:
 *   - registerDevice    POST {deviceId, fcmToken, platform, source, appVersion?}
 *   - unregisterDevice  POST {deviceId, fcmToken?}
 *   - updateDeviceToken POST {deviceId, fcmToken}
 *
 * `source` is the routing hint: 'forumcopilot' (official app, dispatched via
 * the hosted push backend) or 'direct' (white-label app, dispatched in-process
 * to the customer's Firebase project).
 *
 * Errors answer HTTP 200 with errorCode, as the rest of the API: the app
 * reads resultText only from 2xx replies.
 */
class DeviceController extends AbstractController
{
    /** The column sizes of xf_fc_device_token. */
    protected const MAX_DEVICE_ID = 100;
    protected const MAX_FCM_TOKEN = 500;

    public function actionRegisterDevice(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $deviceId   = $this->stringParam($params, 'deviceId');
        $fcmToken   = $this->stringParam($params, 'fcmToken');
        $platform   = strtolower($this->stringParam($params, 'platform'));
        $source     = $this->stringParam($params, 'source', 'direct');
        $appVersion = $this->stringParam($params, 'appVersion');

        if ($error = $this->deviceParamError($deviceId, $fcmToken)) {
            return $error;
        }
        // An app on a platform the table has no value for (the app sends
        // "unknown" on Windows and Linux) is stored with the column's
        // default rather than refused.
        if (!in_array($platform, ['ios', 'android', 'macos', 'web'], true)) {
            $platform = 'android';
        }
        if (!in_array($source, ['forumcopilot', 'direct'], true)) {
            return $this->apiError("source must be 'forumcopilot' or 'direct'", null, ErrorCode::BAD_REQUEST);
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
                    'deviceId' => $entity ? $entity->device_id : $deviceId,
                    'platform' => $entity ? $entity->platform : $platform,
                    'source'   => $entity ? $entity->source : $source,
                ],
            ]);
        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to register device');
        }
    }

    /**
     * Stops pushes to this device. A signed-in member removes their own
     * device. Anyone may remove a device by sending its fcmToken as well:
     * holding the token shows the request comes from that install, so a
     * phone whose session already ended (password changed elsewhere, signed
     * out by an administrator) can still stop getting the account's
     * notifications. Another member's device id without its token is a
     * silent no-op, as before.
     */
    public function actionUnregisterDevice(ParameterBag $params)
    {
        $visitorId = (int)\XF::visitor()->user_id;
        $deviceId = $this->stringParam($params, 'deviceId');
        $fcmToken = $this->stringParam($params, 'fcmToken');

        if (!$visitorId && $fcmToken === '') {
            if ($error = $this->assertRegisteredUser()) { return $error; }
        }
        if ($deviceId === '') {
            return $this->apiError('deviceId is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            /** @var \ForumCopilot\Repository\DeviceToken $repo */
            $repo = $this->repository('ForumCopilot:DeviceToken');
            $repo->deleteDevice($deviceId, $visitorId, $fcmToken);

            return $this->apiResponse(true, 'success', []);
        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to unregister device');
        }
    }

    public function actionUpdateDeviceToken(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $deviceId = $this->stringParam($params, 'deviceId');
        $fcmToken = $this->stringParam($params, 'fcmToken');
        if ($error = $this->deviceParamError($deviceId, $fcmToken)) {
            return $error;
        }

        try {
            /** @var \ForumCopilot\Entity\DeviceToken $entity */
            $entity = $this->em()->find('ForumCopilot:DeviceToken', $deviceId);
            if (!$entity) {
                return $this->apiError('Device not found — call registerDevice first', null, ErrorCode::NOT_FOUND);
            }
            if ((int)$entity->user_id !== (int)\XF::visitor()->user_id) {
                return $this->apiError('Device does not belong to current user', null, ErrorCode::NO_PERMISSION);
            }

            /** @var \ForumCopilot\Repository\DeviceToken $repo */
            $repo = $this->repository('ForumCopilot:DeviceToken');
            $repo->updateToken($entity, $fcmToken);

            return $this->apiResponse(true, 'success', []);
        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to update device token');
        }
    }

    /**
     * A trimmed string parameter; '' when it is missing or not a string or
     * number.
     */
    protected function stringParam(ParameterBag $params, string $key, string $default = ''): string
    {
        $value = $params->get($key, $default);
        return is_scalar($value) ? trim((string)$value) : '';
    }

    /**
     * The error for a missing or oversized deviceId / fcmToken, or null.
     */
    protected function deviceParamError(string $deviceId, string $fcmToken)
    {
        if ($deviceId === '' || $fcmToken === '') {
            return $this->apiError('deviceId and fcmToken are required', null, ErrorCode::BAD_REQUEST);
        }
        if (strlen($deviceId) > self::MAX_DEVICE_ID || strlen($fcmToken) > self::MAX_FCM_TOKEN) {
            return $this->apiError('deviceId or fcmToken is too long', null, ErrorCode::BAD_REQUEST);
        }
        return null;
    }
}

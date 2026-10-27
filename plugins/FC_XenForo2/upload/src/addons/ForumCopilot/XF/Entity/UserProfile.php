<?php

namespace ForumCopilot\XF\Entity;

/**
 * Stops push notifications to the devices a password change signs out.
 *
 * XenForo moves the profile's password_date on every real password change
 * (UserAuth::setPassword and resetPassword: the member's password page, a
 * lost-password reset, an administrator's change), and ends every other
 * session by it. The app's device registrations are removed with them, so
 * a lost phone stops showing the member's notifications. The device the
 * member changed the password on in the app keeps its registration
 * (DeviceToken::keepDeviceOnPasswordChange).
 *
 * Class extension of XF\Entity\UserProfile.
 */
class UserProfile extends XFCP_UserProfile
{
    protected function _postSave()
    {
        parent::_postSave();

        if ($this->isUpdate()
            && $this->isValidColumn('password_date')
            && $this->isChanged('password_date')
        ) {
            try {
                /** @var \ForumCopilot\Repository\DeviceToken $repo */
                $repo = $this->repository('ForumCopilot:DeviceToken');
                $repo->onPasswordChanged((int)$this->user_id);
            } catch (\Exception $e) {
                \XF::logException($e, false, 'ForumCopilot: device tokens after password change: ');
            }
        }
    }
}

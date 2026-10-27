<?php

namespace ForumCopilot\XF\Entity;

/**
 * Removes the app's device registrations of a member who can no longer use
 * the forum: banned, rejected, disabled or deleted (by an administrator or
 * a moderator, or the member's own deletion from the app). Their phones
 * stop showing the member's notifications. A member who is let back in
 * registers again when the app next starts.
 *
 * Class extension of XF\Entity\User.
 */
class User extends XFCP_User
{
    protected function _postSave()
    {
        parent::_postSave();

        if ($this->isUpdate()
            && (
                ($this->isChanged('is_banned') && $this->is_banned)
                || ($this->isChanged('user_state') && in_array($this->user_state, ['rejected', 'disabled'], true))
            )
        ) {
            $this->fcRemoveAppData(false);
        }
    }

    protected function _postDelete()
    {
        parent::_postDelete();

        $this->fcRemoveAppData(true);
    }

    /**
     * The member's push registrations, and with [$deleted] the record that
     * they use the app (xf_fc_user).
     */
    protected function fcRemoveAppData(bool $deleted): void
    {
        try {
            /** @var \ForumCopilot\Repository\DeviceToken $repo */
            $repo = $this->repository('ForumCopilot:DeviceToken');
            $repo->deleteForUser((int)$this->user_id);

            if ($deleted) {
                $this->db()->delete('xf_fc_user', 'user_id = ?', $this->user_id);
            }
        } catch (\Exception $e) {
            \XF::logException($e, false, 'ForumCopilot: app data of user ' . $this->user_id . ': ');
        }
    }
}

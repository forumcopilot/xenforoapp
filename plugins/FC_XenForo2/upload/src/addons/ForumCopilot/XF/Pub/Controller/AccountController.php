<?php

namespace ForumCopilot\XF\Pub\Controller;

class AccountController extends XFCP_AccountController
{
    protected function preferencesSaveProcess(\XF\Entity\User $visitor)
    {
        $form = parent::preferencesSaveProcess($visitor);

        $options = $this->app()->options();
        if (isset($options->fc_push_enabled) && $options->fc_push_enabled)
        {
            $alertRepo = $this->repository(\XF\Repository\UserAlertRepository::class);
            $optOutActions = $alertRepo->getAlertOptOutActions();
            $fcPush = $this->filter('fc_push', 'array-bool');
            $fcPushShown = $this->filter('fc_push_shown', 'array-bool');

            $fcPushOptOuts = [];
            foreach (array_keys($optOutActions) AS $optOut)
            {
                if (empty($fcPush[$optOut]) && isset($fcPushShown[$optOut]))
                {
                    $fcPushOptOuts[$optOut] = $optOut;
                }
            }

            $form->setup(function () use ($visitor, $fcPushOptOuts)
            {
                $userOptions = $visitor->getRelationOrDefault('Option');
                $userOptions->fc_push_optout = $fcPushOptOuts;
            });
        }

        return $form;
    }
}


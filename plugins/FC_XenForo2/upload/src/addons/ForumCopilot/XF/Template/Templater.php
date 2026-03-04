<?php

namespace ForumCopilot\XF\Template;

class Templater extends XFCP_Templater
{
    public function addDefaultHandlers()
    {
        parent::addDefaultHandlers();
        
        $this->addFunction('fc_does_receive_push', [$this, 'fnFcDoesReceivePush']);
    }

    public function fnFcDoesReceivePush($templater, &$escape, $userOption, $contentType, $action)
    {
        $escape = false;
        
        if (!($userOption instanceof \XF\Entity\UserOption)) {
            return false;
        }

        $options = \XF::options();
        if (!isset($options->fc_push_enabled) || !$options->fc_push_enabled) {
            return false;
        }

        $optOuts = $userOption->fc_push_optout ?? [];
        if (!is_array($optOuts)) {
            $optOuts = [];
        }

        return ($userOption->doesReceiveAlert($contentType, $action)
            && !in_array("{$contentType}_{$action}", $optOuts)
        );
    }
}


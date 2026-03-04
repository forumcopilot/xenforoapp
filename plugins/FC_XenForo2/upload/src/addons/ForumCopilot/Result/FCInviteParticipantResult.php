<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Invite Participant Result
 * Maps from InviteParticipantData_Output
 */
class FCInviteParticipantResult extends FCResult
{
    public function __construct($result = true, $resultText = 'success')
    {
        parent::__construct($result, $resultText);
    }

    public function toArray()
    {
        return parent::toArray();
    }
}


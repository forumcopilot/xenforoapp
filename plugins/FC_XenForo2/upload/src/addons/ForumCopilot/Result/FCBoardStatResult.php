<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Board Statistics Result
 * Maps from BoardStatData_Output
 */
class FCBoardStatResult extends FCResult
{
    public $totalThreads;
    public $totalPosts;
    public $totalMembers;
    public $activeMembers;
    public $totalOnline;
    public $guestOnline;
    public $latestUserId;
    public $latestUsername;
    public $latestUserRegisterDate;

    public function __construct($result = true, $resultText = 'success', $totalThreads = 0, $totalPosts = 0, $totalMembers = 0, $activeMembers = 0, $totalOnline = 0, $guestOnline = 0, $latestUserId = 0, $latestUsername = '', $latestUserRegisterDate = 0)
    {
        parent::__construct($result, $resultText);
        $this->totalThreads = $totalThreads;
        $this->totalPosts = $totalPosts;
        $this->totalMembers = $totalMembers;
        $this->activeMembers = $activeMembers;
        $this->totalOnline = $totalOnline;
        $this->guestOnline = $guestOnline;
        $this->latestUserId = $latestUserId;
        $this->latestUsername = $latestUsername;
        $this->latestUserRegisterDate = $latestUserRegisterDate;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalThreads'] = $this->totalThreads;
        $data['totalPosts'] = $this->totalPosts;
        $data['totalMembers'] = $this->totalMembers;
        $data['activeMembers'] = $this->activeMembers;
        $data['totalOnline'] = $this->totalOnline;
        $data['guestOnline'] = $this->guestOnline;
        $data['latestUserId'] = $this->latestUserId;
        $data['latestUsername'] = $this->latestUsername;
        $data['latestUserRegisterDate'] = $this->latestUserRegisterDate;
        return $data;
    }
}


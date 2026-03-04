<?php

namespace ForumCopilot\Entity;

/**
 * ForumCopilot User Entity
 * Forum-agnostic user representation that can be reused across different forum plugins
 */
class FCUser
{
    public $id;
    public $username;
    public $userType;
    public $iconUrl;
    public $postCount;
    public $registrationTime;
    public $lastActivityTime;
    public $isOnline;
    public $acceptsPM;
    public $isFollowing;
    public $isFollowingMe;
    public $acceptsFollowers;
    public $followingCount;
    public $followerCount;
    public $customFields;
    public $canBan;
    public $isBanned;
    public $isIgnored;
    public $canSpamClean;
    public $canBeReported;
    public $userGroups;
    public $canSendPM;
    public $displayText;
    public $userState;
    public $location;
    public $website;
    public $about;
    public $signature;
    public $canFollow;
    public $canIgnore;
    
    private $canSendPMSet = false;

    public function __construct($data = [])
    {
        $this->id = $data['id'] ?? '';
        $this->username = $data['username'] ?? '';
        $this->userType = $data['userType'] ?? null;
        $this->iconUrl = $data['iconUrl'] ?? null;
        $this->postCount = $data['postCount'] ?? null;
        $this->registrationTime = $data['registrationTime'] ?? null;
        $this->lastActivityTime = $data['lastActivityTime'] ?? null;
        $this->isOnline = $data['isOnline'] ?? false;
        $this->acceptsPM = $data['acceptsPM'] ?? false;
        $this->isFollowing = $data['isFollowing'] ?? false;
        $this->isFollowingMe = $data['isFollowingMe'] ?? false;
        $this->acceptsFollowers = $data['acceptsFollowers'] ?? false;
        $this->followingCount = $data['followingCount'] ?? 0;
        $this->followerCount = $data['followerCount'] ?? 0;
        $this->customFields = $data['customFields'] ?? [];
        $this->canBan = $data['canBan'] ?? false;
        $this->isBanned = $data['isBanned'] ?? false;
        $this->isIgnored = $data['isIgnored'] ?? false;
        $this->canSpamClean = $data['canSpamClean'] ?? false;
        $this->canBeReported = $data['canBeReported'] ?? false;
        $this->userGroups = $data['userGroups'] ?? [];
        $this->displayText = $data['displayText'] ?? null;
        $this->userState = $data['userState'] ?? 'valid';
        $this->location = $data['location'] ?? null;
        $this->website = $data['website'] ?? null;
        $this->about = $data['about'] ?? null;
        $this->signature = $data['signature'] ?? null;
        $this->canFollow = $data['canFollow'] ?? false;
        $this->canIgnore = $data['canIgnore'] ?? false;
        if (array_key_exists('canSendPM', $data)) {
            $this->canSendPM = $data['canSendPM'];
            $this->canSendPMSet = true;
        } else {
            $this->canSendPM = false;
        }
    }

    public function toArray()
    {
        $data = [
            'id' => $this->id,
            'username' => $this->username,
            'userType' => $this->userType,
            'iconUrl' => $this->iconUrl,
            'postCount' => $this->postCount,
            'registrationTime' => $this->registrationTime,
            'lastActivityTime' => $this->lastActivityTime,
            'isOnline' => $this->isOnline,
            'acceptsPM' => $this->acceptsPM,
            'isFollowing' => $this->isFollowing,
            'isFollowingMe' => $this->isFollowingMe,
            'acceptsFollowers' => $this->acceptsFollowers,
            'followingCount' => $this->followingCount,
            'followerCount' => $this->followerCount,
            'customFields' => $this->customFields,
            'canBan' => $this->canBan,
            'isBanned' => $this->isBanned,
            'isIgnored' => $this->isIgnored,
            'canSpamClean' => $this->canSpamClean,
            'canBeReported' => $this->canBeReported,
            'userGroups' => $this->userGroups,
            'displayText' => $this->displayText,
            'userState' => $this->userState,
            'location' => $this->location,
            'website' => $this->website,
            'about' => $this->about,
            'signature' => $this->signature,
            'canFollow' => $this->canFollow,
            'canIgnore' => $this->canIgnore,
        ];
        
        // Only include canSendPM if it was explicitly set in constructor
        // For getUserInfo (other users), canSendPM is not set - use acceptsPM instead
        // For login (own user), canSendPM indicates general permission to send PMs
        if ($this->canSendPMSet) {
            $data['canSendPM'] = $this->canSendPM;
        }
        
        return $data;
    }
}

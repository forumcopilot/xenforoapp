<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Configuration Result
 * 
 * This class represents the configuration data returned by forum systems.
 * It contains all the necessary configuration flags and settings that
 * determine the capabilities and behavior of the forum.
 * 
 * Note: This class does NOT extend FCResult because config is not a standard
 * result with result/resultText fields. It's a pure configuration object.
 */
class FCConfigResult
{
    public $version;
    public $systemVersion;
    public $phpVersion;
    public $hookVersion;
    public $apiLevel;
    public $releaseTimestamp;
    public $pushSlug;
    public $smartBannerInfo;
    public $isOpen;
    public $guestOkay;
    public $modApprove;
    public $modDelete;
    public $modReport;
    public $guestSearch;
    public $guestWhosOnline;
    public $subscribeTopicMode;
    public $subscribeForumMode;
    public $multiQuote;
    public $announcement;
    public $passwordType;
    public $conversation;
    public $getTopicStatus;
    public $getParticipatedForum;
    public $updateProfile;
    public $userId;
    public $alert;
    public $searchUser;
    public $ignoreUser;
    public $advancedMerge;
    public $advancedMove;
    public $pushType;
    public $push;
    public $contentEncoding;
    public $contentType;
    public $loginWithEmail;
    public $apiKey;
    public $forumType;

    public function __construct($data = [])
    {
        // Set all properties from data array
        foreach ($data as $key => $value) {
            if (property_exists($this, $key)) {
                $this->$key = $value;
            }
        }
    }

    /**
     * Convert config to array for JSON response
     * 
     * @return array
     */
    public function toArray()
    {
        return get_object_vars($this);
    }
}


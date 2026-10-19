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
    public $canViewChat;

    /** @var array<int, array<string, mixed>> Active reactions the forum has configured */
    public $availableReactions = [];

    /** @var array<string, mixed>|null The default style's colours and logo, light and dark (ConfigController::getStyleInfo) */
    public $style;

    /** @var bool Members can delete their account from the app (deleteAccount) */
    public $accountDeletion = false;

    /** @var string[] App schemes the website may hand a browser sign-in to; empty when it is off */
    public $browserLoginSchemes = [];

    /** @var string The signed-in member's state (valid, email_confirm, moderated, ...); empty for a guest */
    public $userState = '';

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


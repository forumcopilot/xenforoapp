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

    // 1.11.0

    /** @var bool The app's search uses advanceSearchTopic/Post (what apps assumed when it was missing) */
    public $advancedSearch = true;

    /** @var int XenForo's minimum search word length */
    public $minSearchLength = 3;

    /** @var bool Search is switched off on this forum */
    public $disableSearch = false;

    /** @var string Why the board is closed (plain text); empty when open */
    public $boardInactiveMessage = '';

    /** @var bool The visitor may search */
    public $canSearch = false;

    /** @var bool The visitor may start direct messages */
    public $canStartConversation = false;

    /** @var bool The visitor may upload an avatar */
    public $canUploadAvatar = false;

    /** @var bool The visitor is a moderator */
    public $isModerator = false;

    /** @var array<int, array<string, mixed>> Notices for the visitor: id, type, title, message, messageHtml, dismissible, displayStyle */
    public $notices = [];

    /** @var string Terms, privacy policy and contact pages; empty when the forum has none */
    public $tosUrl = '';
    public $privacyPolicyUrl = '';
    public $contactUrl = '';

    /** @var array<int, array<string, string>> Help pages: id, title, url */
    public $helpPages = [];

    /** @var array{required: bool, privacyRequired: bool, termsRequired: bool, acceptUrl: string} Updated policies the member hasn't accepted */
    public $policyAcceptance = [];

    // After 1.11.0: the forum itself, for adding a forum by its address

    /** @var string The forum's name (XenForo's boardTitle) */
    public $boardTitle = '';

    /** @var string The forum's own address (XenForo's boardUrl) */
    public $boardUrl = '';

    /** @var string The default style's app icon or favicon, absolute; empty when it has none */
    public $boardIcon = '';

    /** @var string The site id forumcopilot.com gave the forum; empty until the add-on's options are saved */
    public $siteId = '';

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


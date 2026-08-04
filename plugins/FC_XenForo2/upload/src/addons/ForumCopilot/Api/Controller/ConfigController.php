<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCConfigResult;

/**
 * Config Controller for ForumCopilot API
 * Handles Config-related operations
 */
class ConfigController extends AbstractController
{
    public function actionGetConfig(ParameterBag $params)
    {
        $options = $this->app()->options();
        $visitor = \XF::visitor();
        
        // Check if forum is open (not in maintenance mode)
        // Explicitly cast to boolean to ensure true/false, not 0/1
        $isOpen = (bool)$options->boardActive;
        
        // Check if guests can access the forum (check if there are any viewable nodes for guests)
        $guestOkay = true; // Default to true
        if (!$visitor->user_id) {
            // For guests, check if they can view any nodes
            $nodeRepo = $this->repository('XF:Node');
            $nodes = $nodeRepo->getNodeList();
            $guestOkay = false;
            foreach ($nodes as $node) {
                if ($node->canView()) {
                    $guestOkay = true;
                    break;
                }
            }
        }
        // Explicitly cast to boolean
        $guestOkay = (bool)$guestOkay;
        
        // Check if guests can search
        $guestSearch = false;
        // Check guest search permission by checking if guest user (user_id = 0) has search permission
        $guestUser = $this->em()->find('XF:User', 0);
        if ($guestUser) {
            $guestSearch = $guestUser->canSearch();
        }
        // Explicitly cast to boolean
        $guestSearch = (bool)$guestSearch;
        
        // Check if guests can view who's online
        $guestWhosOnline = false;
        if ($guestUser) {
            $guestWhosOnline = $guestUser->canViewMemberList();
        }
        // Explicitly cast to boolean
        $guestWhosOnline = (bool)$guestWhosOnline;
        
        $addOn = \XF::app()->addOnManager()->getById('ForumCopilot');
        $addOnVersion = $addOn ? $addOn->version_string : 'unknown';

        // Capability: can the visitor see the Siropu Chat tab? True only when:
        //   1. Siropu Chat is installed (the canViewSiropuChat method exists on
        //      the visitor user, added via XF class extension by Siropu/Chat).
        //   2. The FCSiropuChatBridge add-on is installed (otherwise the mobile
        //      Chat.* API methods aren't dispatched anyway).
        //   3. The visitor's permission actually grants chat viewing.
        // The mobile app gates the Chat tab on this so users without permission
        // don't see a tab that would just show an empty "no messages" view.
        $canViewChat = false;
        if ($visitor && method_exists($visitor, 'canViewSiropuChat'))
        {
            $bridge = \XF::app()->addOnManager()->getById('FCSiropuChatBridge');
            if ($bridge && $bridge->isActive())
            {
                $canViewChat = (bool)$visitor->canViewSiropuChat();
            }
        }

        $config = [
            'version' => $addOnVersion,
            'systemVersion' => \XF::$version,
            'phpVersion' => phpversion(),
            'hookVersion' => '1.0',
            'apiLevel' => '4',
            'releaseTimestamp' => (string)(time() * 1000),
            'pushSlug' => 'xenforo',
            'smartBannerInfo' => '',
            'isOpen' => $isOpen,
            'guestOkay' => $guestOkay,
            'modApprove' => false,
            'modDelete' => false,
            'modReport' => false,
            'guestSearch' => $guestSearch,
            'guestWhosOnline' => $guestWhosOnline,
            'subscribeTopicMode' => 'email',
            'subscribeForumMode' => 'email',
            'multiQuote' => false,
            'announcement' => false,
            'passwordType' => 'bcrypt',
            'conversation' => true,
            'getTopicStatus' => false,
            'getParticipatedForum' => false,
            'updateProfile' => true,
            'userId' => '',
            'alert' => true,
            'searchUser' => true,
            'ignoreUser' => false,
            'advancedMerge' => false,
            'advancedMove' => false,
            'pushType' => 'fcm',
            'push' => 'enabled',
            'contentEncoding' => 'gzip',
            'contentType' => 'application/json',
            'loginWithEmail' => false,
            'apiKey' => '', // Will be set by client
            'forumType' => 'xenforo',
            'canViewChat' => $canViewChat,
            'availableReactions' => $this->getAvailableReactions(),
        ];

        // Create FCConfigResult object and return it
        $configResult = new FCConfigResult($config);
        return $this->apiSuccess($configResult->toArray());
    }

    /**
     * Build the list of active reactions the forum has configured, so the app
     * can show a reaction picker instead of a single hardcoded "Like".
     *
     * Each entry: {id, title, emoji, imageUrl, displayOrder}. `emoji` is a
     * native Unicode emoji derived from the standard XenForo reaction set
     * (so the app can render crisp native emoji); it is null for any custom
     * reaction we can't map, in which case the app falls back to `imageUrl`.
     *
     * @return array<int, array<string, mixed>>
     */
    protected function getAvailableReactions(): array
    {
        try {
            /** @var \XF\Finder\ReactionFinder $finder */
            $finder = $this->finder('XF:Reaction')
                ->where('active', 1)
                ->order('display_order');
            $reactions = $finder->fetch();
        } catch (\Throwable $e) {
            \XF::logError('FC getAvailableReactions: ' . $e->getMessage());
            return [];
        }

        $boardUrl = rtrim((string) $this->app()->options()->boardUrl, '/');
        $out = [];

        foreach ($reactions as $reaction) {
            $imageUrl = (string) $reaction->image_url;
            // XenForo stores a style-relative path (styles/…/reactions/…/love.png).
            // Absolutize it so the app can load it directly if needed.
            if ($imageUrl !== '' && !preg_match('#^https?://#i', $imageUrl)) {
                $imageUrl = $boardUrl . '/' . ltrim($imageUrl, '/');
            }

            $out[] = [
                'id'           => (int) $reaction->reaction_id,
                'title'        => (string) $reaction->title,
                'emoji'        => self::emojiForReaction($reaction),
                'imageUrl'     => $imageUrl,
                'displayOrder' => (int) $reaction->display_order,
            ];
        }

        return $out;
    }

    /**
     * Map a XenForo reaction to a native Unicode emoji using the basename of
     * its image_url (the standard EmojiOne set: like/love/haha/wow/sad/angry/
     * dislike). Returns null for anything we don't recognise so the app falls
     * back to the reaction's image.
     */
    protected static function emojiForReaction($reaction): ?string
    {
        // 1. AUTHORITATIVE: XenForo's own "Emoji replacement" field. When the
        //    admin sets it (e.g. :exploding_head:), $reaction->emoji returns the
        //    actual Unicode emoji. This is the clean, per-reaction, admin-driven
        //    mapping — no plugin change needed for any future reaction. To use
        //    it for an image-based reaction like "Mind Blown", the admin sets
        //    the Emoji replacement field and clears the image URL (XenForo
        //    requires one or the other, not both).
        try {
            if (!empty($reaction->emoji_shortname)) {
                $native = $reaction->emoji;
                if (is_string($native) && $native !== '') {
                    return $native;
                }
            }
        } catch (\Throwable $e) {
            // fall through to the heuristic maps below
        }

        // 2. XenForo's built-in default reaction set ships as EmojiOne images
        //    (no emoji_shortname), so map those by their fixed image basename.
        //    This is the standard set present on every XenForo install — not
        //    per-forum config — so it's safe generic behavior. Any reaction NOT
        //    in this default set returns null and the app renders its image;
        //    to have such a reaction show as a native emoji, the admin fills
        //    the reaction's "Emoji replacement" field (handled by step 1 above).
        static $defaultSet = [
            'like'    => "\u{1F44D}", 'love'    => "\u{2764}\u{FE0F}",
            'haha'    => "\u{1F604}", 'wow'     => "\u{1F62E}",
            'sad'     => "\u{1F622}", 'angry'   => "\u{1F620}",
            'dislike' => "\u{1F44E}",
        ];
        $imageUrl = (string) $reaction->image_url;
        if ($imageUrl !== '') {
            // Image-mode reaction: match XenForo's default EmojiOne images by
            // their fixed basename (like.png, love_2x.png, …).
            $base = strtolower(pathinfo(parse_url($imageUrl, PHP_URL_PATH) ?: $imageUrl, PATHINFO_FILENAME));
            $base = preg_replace('/[-_]?2x$/', '', $base);
            if (isset($defaultSet[$base])) {
                return $defaultSet[$base];
            }
        } else {
            // Sprite-mode reaction: XenForo's built-in set ships this way by
            // default — no emoji_shortname AND no image_url, rendered from a
            // shared sprite sheet via sprite_params. Neither a native emoji nor
            // a plain <img> is available, so the app would otherwise draw a
            // placeholder. Map the standard built-in set by its (lowercased)
            // title. Locale caveat: matches XenForo's default English titles; a
            // renamed/translated built-in should use the Emoji replacement
            // field (handled authoritatively by step 1 above).
            $title = strtolower(trim((string) $reaction->title));
            if (isset($defaultSet[$title])) {
                return $defaultSet[$title];
            }
        }

        // Custom reaction with an uploaded image and no emoji — app renders image.
        return null;
    }
}

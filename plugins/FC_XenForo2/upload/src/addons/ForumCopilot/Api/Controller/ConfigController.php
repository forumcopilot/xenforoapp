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
            'style' => $this->getStyleInfo(),
            // Members can delete their account from the app (deleteAccount).
            'accountDeletion' => (bool)$options->fc_account_deletion,
        ];

        // Create FCConfigResult object and return it
        $configResult = new FCConfigResult($config);
        return $this->apiSuccess($configResult->toArray());
    }

    /**
     * The forum's look, so the app can draw it in the forum's colours instead
     * of the same blue for every forum: the board's default style, as a
     * light scheme and a dark one where the style has them (XenForo 2.3
     * variations; on 2.2 the one scheme goes under its own style type).
     *
     * Each scheme: colours as #rrggbb, resolved the way XenForo resolves the
     * browser's theme-color, and the header logo as an absolute URL with its
     * size. A colour that cannot be resolved is left out. Null when the style
     * cannot be read (the rest of getConfig is unaffected).
     *
     * @return array<string, mixed>|null
     */
    protected function getStyleInfo(): ?array
    {
        try
        {
            $app = \XF::app();
            $styleId = (int)$app->options()->defaultStyleId;
            $style = $app->style($styleId);
            if (!$style)
            {
                return null;
            }

            $info = ['styleId' => $styleId, 'light' => null, 'dark' => null];
            if (method_exists($style, 'getStyleTypeVariation') && $style->isVariationsEnabled())
            {
                foreach (['light', 'dark'] AS $type)
                {
                    $variation = $style->getStyleTypeVariation($type);
                    if ($variation !== null)
                    {
                        $info[$type] = $this->getStyleScheme($style, $variation);
                    }
                }
            }
            else
            {
                $type = $style->getProperty('styleType') === 'dark' ? 'dark' : 'light';
                $info[$type] = $this->getStyleScheme($style, null);
            }

            return $info;
        }
        catch (\Throwable $e)
        {
            \XF::logException($e, false, 'ForumCopilot: reading the style for getConfig: ');
            return null;
        }
    }

    /**
     * One scheme of [$style]: [$variation] on XenForo 2.3, the style's only
     * values on 2.2 (null).
     *
     * @return array<string, mixed>
     */
    protected function getStyleScheme(\XF\Style $style, ?string $variation): array
    {
        $app = \XF::app();
        $property = function (string $name) use ($style, $variation)
        {
            return $variation !== null
                ? $style->getPropertyVariation($name, $variation)
                : $style->getProperty($name);
        };

        // The LESS parser on a copy set to this variation: in the style's
        // usual CSS-variable mode, darken() and contrast() give CSS
        // expressions rather than colours.
        $lessStyle = $style;
        if ($variation !== null && method_exists($style, 'setVariation'))
        {
            $lessStyle = clone $style;
            $lessStyle->setVariation($variation);
        }
        $rendererClass = $app->extendClass('XF\CssRenderer');
        /** @var \XF\CssRenderer $renderer */
        $renderer = new $rendererClass($app, $app->templater());
        $renderer->setStyle($lessStyle);

        $color = function (string $name) use ($property, $renderer): ?string
        {
            $raw = $property($name);
            if (!is_string($raw) || trim($raw) === '')
            {
                return null;
            }
            // A plain colour as it is; an expression (darken(...),
            // contrast(...)) through XenForo's LESS parser.
            $rgb = \XF\Util\Color::colorToRgb($raw);
            if (!$rgb)
            {
                $parsed = $renderer->parseLessColorValue($raw);
                $rgb = $parsed ? \XF\Util\Color::colorToRgb($parsed) : null;
            }
            return $rgb ? '#' . strtolower(\XF\Util\Color::rgbToHex($rgb)) : null;
        };

        $scheme = array_filter([
            'headerBackground' => $color('publicHeader--background-color'),
            'headerText' => $color('publicHeader--color'),
            'page' => $color('pageBg'),
            'content' => $color('contentBg'),
            'text' => $color('textColor'),
            'link' => $color('linkColor'),
            'button' => $color('buttonPrimary--background-color'),
            'buttonText' => $color('buttonPrimary--color'),
            'accent' => $color('paletteAccent2'),
            'error' => $color('errorColor'),
            'success' => $color('successColor'),
            'themeColor' => $color('metaThemeColor'),
        ]);

        // The header logo, drawn for headerBackground; the 2x file where
        // there is one.
        $logo = $property('publicLogoUrl2x') ?: $property('publicLogoUrl');
        if (is_string($logo) && trim($logo) !== '' && strpos($logo, '{') === false)
        {
            $scheme['logo'] = $this->getAbsoluteUrl(trim($logo));
            $width = (int)$property('publicLogoWidth');
            $height = (int)$property('publicLogoHeight');
            if ($width > 0 && $height > 0)
            {
                $scheme['logoWidth'] = $width;
                $scheme['logoHeight'] = $height;
            }
        }

        return $scheme;
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

        $out = [];

        foreach ($reactions as $reaction) {
            $out[] = [
                'id'           => (int) $reaction->reaction_id,
                'title'        => (string) $reaction->title,
                'emoji'        => self::emojiForReaction($reaction),
                'imageUrl'     => (string) (self::iconUrlForReaction($reaction) ?? ''),
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
    public static function emojiForReaction($reaction): ?string
    {
        // 1. AUTHORITATIVE: XenForo's own "Emoji replacement" field. When the
        //    admin sets it (e.g. :exploding_head:), $reaction->emoji returns the
        //    actual Unicode emoji. This is the clean, per-reaction, admin-driven
        //    mapping — no plugin change needed for any future reaction. To use
        //    it for an image-based reaction like "Mind Blown", the admin sets
        //    the Emoji replacement field and clears the image URL (XenForo
        //    requires one or the other, not both).
        try {
            if ($reaction->isValidColumn('emoji_shortname') && !empty($reaction->emoji_shortname)) { // column exists on 2.3+ only
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
        }
        {
            // Sprite-mode or otherwise unmatched reaction (2.2's built-ins carry
            // the shared sprite sheet as image_url, 2.3's carry no image_url):
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

    /**
     * Absolute URL of a reaction's image, or null when the reaction has no
     * usable standalone icon: no image_url, or sprite mode, where image_url
     * points at the shared sprite sheet (the whole sheet, not one reaction).
     * XenForo 2.2's built-in reactions are exactly that case.
     */
    public static function iconUrlForReaction($reaction): ?string
    {
        try {
            if ($reaction->isValidColumn('sprite_mode') && $reaction->sprite_mode) {
                return null;
            }
        } catch (\Throwable $e) {
        }
        $imageUrl = (string) $reaction->image_url;
        if ($imageUrl === '') {
            return null;
        }
        if (!preg_match('#^https?://#i', $imageUrl)) {
            $boardUrl = rtrim((string) \XF::options()->boardUrl, '/');
            $imageUrl = $boardUrl . '/' . ltrim($imageUrl, '/');
        }
        return $imageUrl;
    }
}

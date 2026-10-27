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
        
        // What guests may do, from XenForo's guest user (there is no user 0
        // row to look up, so these were always false before 1.11.0)
        $guest = $this->repository('XF:User')->getGuestUser();
        $guestOkay = (bool)\XF::asVisitor($guest, function () {
            foreach ($this->repository('XF:Node')->getNodeList() as $node) {
                if ($node->canView()) {
                    return true;
                }
            }
            return false;
        });
        $guestSearch = (bool)$guest->canSearch();
        $guestWhosOnline = (bool)$guest->canViewMemberList();

        // Optional (1.11.0): dismiss a notice, as XenForo's notice close button does
        $dismissNoticeId = (int)$params->get('dismissNoticeId', 0);
        if ($dismissNoticeId && $visitor->user_id) {
            $this->dismissNotice($dismissNoticeId);
        }
        
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
            // Not used by the app; the server's PHP version is nobody's business
            'phpVersion' => '',
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
            'getParticipatedForum' => true,
            'updateProfile' => true,
            'userId' => $visitor->user_id ? (string)$visitor->user_id : '',
            // The signed-in member's state (valid, email_confirm, moderated,
            // ...), so the app sees a new member's account become ready.
            'userState' => $visitor->user_id ? (string)$visitor->user_state : '',
            'alert' => true,
            'searchUser' => true,
            'ignoreUser' => false,
            'advancedMerge' => false,
            'advancedMove' => false,
            'pushType' => 'fcm',
            'push' => $options->fc_push_enabled ? 'enabled' : 'disabled',
            'contentEncoding' => 'gzip',
            'contentType' => 'application/json',
            // XenForo's login takes a user name or an email address
            'loginWithEmail' => true,
            'apiKey' => '', // Will be set by client
            'forumType' => 'xenforo',
            'canViewChat' => $canViewChat,
            'availableReactions' => $this->getAvailableReactions(),
            'style' => $this->getStyleInfo(),
            // Members can delete their account from the app (deleteAccount).
            'accountDeletion' => (bool)$options->fc_account_deletion,
            // Members can sign the app in through the website (Pub\Controller\AppLogin).
            'browserLoginSchemes' => array_values(preg_split('/[\s,]+/', strtolower((string)$options->fc_app_login_schemes), -1, PREG_SPLIT_NO_EMPTY)),

            // 1.11.0. advancedSearch is what the app already assumed when it
            // was missing: its Search tab uses advanceSearchTopic/Post.
            'advancedSearch' => true,
            'minSearchLength' => (int)$options->searchMinWordLength,
            'disableSearch' => !$options->enableSearch,
            'boardInactiveMessage' => $isOpen ? '' : $this->plainText($options->boardInactiveMessage),
            'canSearch' => (bool)$visitor->canSearch(),
            'canStartConversation' => (bool)$visitor->canStartConversation(),
            'canUploadAvatar' => (bool)$visitor->canUploadAvatar(),
            'isModerator' => (bool)$visitor->is_moderator,
            'notices' => $this->getNotices(),
            'tosUrl' => $this->getAbsoluteUrl((string)$this->app->container('tosUrl')),
            'privacyPolicyUrl' => $this->getAbsoluteUrl((string)$this->app->container('privacyPolicyUrl')),
            'contactUrl' => $this->getAbsoluteUrl((string)$this->app->container('contactUrl')),
            'helpPages' => $this->getHelpPages(),
            'policyAcceptance' => $this->getPolicyAcceptance(),
        ];

        // Create FCConfigResult object and return it
        $configResult = new FCConfigResult($config);
        return $this->apiSuccess($configResult->toArray());
    }

    /**
     * The notices XenForo would show this visitor on a page with no page
     * criteria (Pub\App::getNoticeList): active, matching the visitor's user
     * criteria, not dismissed. Notices limited to particular pages don't
     * show, as the app has no such pages.
     */
    protected function getNotices(): array
    {
        if (!$this->options()->enableNotices) {
            return [];
        }

        try {
            $class = $this->app->extendClass('XF\NoticeList');
            /** @var \XF\NoticeList $noticeList */
            $noticeList = new $class($this->app, \XF::visitor(), []);

            $visitor = \XF::visitor();
            $dismissed = $this->session()->dismissedNotices;
            if (!is_array($dismissed) && $visitor->user_id) {
                $dismissed = $this->repository('XF:Notice')->getDismissedNoticesForUser($visitor);
            }
            if (is_array($dismissed)) {
                $noticeList->setDismissed($dismissed);
            }

            foreach ($this->app->container('notices') as $key => $notice) {
                $noticeList->addConditionalNotice($key, $notice['notice_type'], $notice['message'], $notice);
            }

            $notices = [];
            foreach ($noticeList->getNotices() as $type => $typeNotices) {
                foreach ($typeNotices as $key => $notice) {
                    $notices[] = [
                        'id' => (string)$key,
                        'type' => (string)$type,
                        'title' => (string)($notice['title'] ?? ''),
                        'message' => $this->plainText($notice['message']),
                        'messageHtml' => (string)$notice['message'],
                        'dismissible' => !empty($notice['dismissible']) && $visitor->user_id,
                        'displayStyle' => (string)($notice['display_style'] ?? ''),
                    ];
                }
            }
            return $notices;
        } catch (\Exception $e) {
            \XF::logException($e, false, 'Forum Copilot getConfig notices: ');
            return [];
        }
    }

    /**
     * Dismisses a notice for the visitor, as AccountController::actionDismissNotice.
     */
    protected function dismissNotice(int $noticeId)
    {
        $notice = $this->em()->find('XF:Notice', $noticeId);
        $error = null;
        if ($notice && $notice->canDismissNotice($error)) {
            $this->repository('XF:Notice')->dismissNotice($notice, \XF::visitor());
            $this->session()->remove('dismissedNotices');
        }
    }

    /**
     * Active help pages with their web addresses, as XenForo's help index lists
     * them (terms and privacy policy only when their links are on).
     */
    protected function getHelpPages(): array
    {
        $pages = [];
        try {
            $privacyPolicyUrl = $this->app->container('privacyPolicyUrl');
            $tosUrl = $this->app->container('tosUrl');
            foreach ($this->repository('XF:HelpPage')->findActiveHelpPages()->fetch() as $page) {
                if (($page->page_id == 'privacy_policy' && !$privacyPolicyUrl)
                    || ($page->page_id == 'terms' && !$tosUrl)
                ) {
                    continue;
                }
                $pages[] = [
                    'id' => (string)$page->page_id,
                    'title' => (string)$page->title,
                    'url' => $this->buildLink('canonical:help', $page),
                ];
            }
        } catch (\Exception $e) {
            \XF::logException($e, false, 'Forum Copilot getConfig help pages: ');
        }
        return $pages;
    }

    /**
     * Whether the member still has to accept updated terms or privacy policy,
     * which the website asks before anything else
     * (Pub\Controller\AbstractController::assertPolicyAcceptance). Reported
     * only: the app isn't refused, as 1.x apps have no screen to accept on.
     */
    protected function getPolicyAcceptance(): array
    {
        $options = $this->options();
        $visitor = \XF::visitor();
        $privacyPolicyUrl = (string)$this->app->container('privacyPolicyUrl');
        $tosUrl = (string)$this->app->container('tosUrl');

        $privacyRequired = false;
        $termsRequired = false;
        if ($visitor->user_id && isset($options->privacyPolicyLastUpdate, $options->termsLastUpdate)) {
            $privacyRequired = $options->privacyPolicyLastUpdate && $privacyPolicyUrl
                && $visitor->privacy_policy_accepted < $options->privacyPolicyLastUpdate;
            $termsRequired = $options->termsLastUpdate && $tosUrl
                && $visitor->terms_accepted < $options->termsLastUpdate;
        }

        return [
            'required' => $privacyRequired || $termsRequired,
            'privacyRequired' => (bool)$privacyRequired,
            'termsRequired' => (bool)$termsRequired,
            'acceptUrl' => ($privacyRequired || $termsRequired)
                ? $this->buildLink('canonical:misc/' . ($privacyRequired ? 'accept-privacy-policy' : 'accept-terms'))
                : '',
        ];
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

<?php

namespace ForumCopilot\BbCode\Renderer;

use XF\BbCode\Renderer\ApiHtml;

/**
 * Post and message HTML for the app (contentHtml), from XenForo's own REST
 * API renderer: plain HTML without the website's JavaScript or templates,
 * with data attributes on the parts the app draws itself.
 *
 *   <blockquote data-quote-name data-quote-type data-quote-id data-quote-member-id>
 *   <a data-user-id>                         a mention
 *   <span data-attachment-id data-attachment-full>   wraps an attachment
 *   <div data-media-site data-media-key data-media-url>   a media embed (BBCode [MEDIA]);
 *                                        data-media-url is the media's page (getMediaUrl)
 *   <details data-spoiler [data-spoiler-title]>, <span data-inline-spoiler>
 *   <div data-unfurl data-url data-title data-description data-image data-favicon>
 *
 * Smilies are <img> (or emoji), images go through the forum's image proxy
 * when it is on, as on the website, and every link and image URL is absolute.
 */
class AppHtml extends ApiHtml
{
    public function getDefaultOptions()
    {
        $options = parent::getDefaultOptions();
        $options['smilieFormat'] = 'default';
        $options['allowUnfurl'] = true;
        $options['noProxy'] = false;

        return $options;
    }

    public function filterFinalOutput($output)
    {
        $output = parent::filterFinalOutput($output);

        // Relative src/href (smilies, attachments, member links) as absolute URLs
        $request = \XF::app()->request();
        return preg_replace_callback(
            '#\s(src|href)="(?!https?:|//|data:|mailto:|tel:|\#)([^"]*)"#i',
            function (array $match) use ($request) {
                $url = html_entity_decode($match[2], ENT_QUOTES | ENT_HTML5, 'UTF-8');
                return ' ' . $match[1] . '="' . htmlspecialchars($request->convertToAbsoluteUri($url)) . '"';
            },
            $output
        );
    }

    public function renderTagAttach(array $children, $option, array $tag, array $options)
    {
        $html = parent::renderTagAttach($children, $option, $tag, $options);
        $id = intval($this->renderSubTreePlain($children));
        if (!$id || $html === '') {
            return $html;
        }

        return '<span data-attachment-id="' . $id . '" data-attachment-full="'
            . ($this->isFullAttachView($option) ? '1' : '0') . '">' . $html . '</span>';
    }

    public function renderTagMedia(array $children, $option, array $tag, array $options)
    {
        $mediaKey = trim($this->renderSubTreePlain($children));
        if ($mediaKey === '' || preg_match('#[&?"\'<>\r\n]#', $mediaKey) || strpos($mediaKey, '..') !== false) {
            return '';
        }
        if ($this->formatter->censorText($mediaKey) != $mediaKey) {
            return '';
        }

        $siteId = strtolower((string)$option);
        $site = $this->mediaSites[$siteId] ?? null;
        if (!$site && !$this->isLegacyMediaSite($siteId)) {
            return '';
        }

        $url = $site ? $this->getMediaUrl($siteId, $mediaKey) : '';
        $title = $site ? (string)($site['site_title'] ?? $siteId) : $siteId;

        return '<div data-media-site="' . htmlspecialchars($siteId) . '" data-media-key="' . htmlspecialchars($mediaKey) . '"'
            . ' data-media-url="' . htmlspecialchars($url) . '">'
            . ($url !== '' ? '<a href="' . htmlspecialchars($url) . '">' . htmlspecialchars($url) . '</a>' : htmlspecialchars($title))
            . '</div>';
    }

    /**
     * The media's page address, empty when there is none to build:
     * - the sites XenForo ships, from the key as their match callbacks write
     *   it (a YouTube key can carry a start time and a playlist, a Vimeo key
     *   a private link's hash, a Twitch key "clip:", a Spotify key the type);
     * - other sites from their own URL patterns: the oEmbed URL scheme, then
     *   each match URL, the first that the site's patterns read back as this
     *   key.
     */
    protected function getMediaUrl(string $siteId, string $mediaKey): string
    {
        // The renderer's media site cache has no URL patterns: the sites are
        // read once per request, when the first embed is rendered
        static $sites = null;
        if ($sites === null) {
            $sites = \XF::finder('XF:BbCodeMediaSite')->fetch();
        }
        $site = $sites[$siteId] ?? null;
        if (!$site) {
            return '';
        }

        if ($site->addon_id === 'XF') {
            $url = $this->getXenForoMediaUrl($site, $mediaKey);
            if ($url !== null) {
                return $url;
            }
        }
        return $this->getMediaUrlFromPatterns($site, $mediaKey);
    }

    /**
     * Page addresses for XenForo's own media sites: null for a site it
     * doesn't ship, empty for a key its callback wouldn't have written.
     */
    protected function getXenForoMediaUrl(\XF\Entity\BbCodeMediaSite $site, string $key): ?string
    {
        $path = $this->encodeMediaKey($key);

        switch ($site->media_site_id) {
            case 'youtube':
                // "id[:start][, list: playlist]"
                if (!preg_match('/^([\w-]+)(?::(\d+))?(?:\s*,\s*list:\s*([\w-]+))?$/', $key, $match)) {
                    return '';
                }
                return 'https://www.youtube.com/watch?v=' . $match[1]
                    . (!empty($match[2]) ? '&t=' . $match[2] : '')
                    . (!empty($match[3]) ? '&list=' . $match[3] : '');

            case 'vimeo':
                // "id[:hash][:start]", the hash of a private link
                $parts = explode(':', $key);
                $id = array_shift($parts);
                if (!ctype_digit($id)) {
                    return '';
                }
                $hash = $start = '';
                foreach ($parts as $part) {
                    if (ctype_digit($part)) {
                        $start = $part;
                    } elseif (ctype_xdigit($part)) {
                        $hash = $part;
                    }
                }
                return 'https://vimeo.com/' . $id . ($hash !== '' ? '/' . $hash : '') . ($start !== '' ? '#t=' . $start . 's' : '');

            case 'dailymotion':
                // "id[:start]"
                if (!preg_match('/^([a-z0-9]+)(?::(\d+))?$/i', $key, $match)) {
                    return '';
                }
                return 'https://www.dailymotion.com/video/' . $match[1] . (!empty($match[2]) ? '?start=' . $match[2] : '');

            case 'twitch':
                // "clip:slug", "video id[:time]" or a channel
                if (preg_match('/^clip:(\w+)$/', $key, $match)) {
                    return 'https://clips.twitch.tv/' . $match[1];
                }
                if (preg_match('/^(\d+)(?::([0-9hms]+))?$/i', $key, $match)) {
                    return 'https://www.twitch.tv/videos/' . $match[1] . (!empty($match[2]) ? '?t=' . $match[2] : '');
                }
                return preg_match('/^\w+$/', $key) ? 'https://www.twitch.tv/' . $key : '';

            case 'spotify':
                // "track:id", "user:name:playlist:id"
                return preg_match('/^[\w:]+$/', $key) ? 'https://open.spotify.com/' . str_replace(':', '/', $key) : '';

            case 'facebook':
                // As Facebook::htmlCallback reads the key: a post's or photo's
                // path, "story_fbid=…:id=…", a video id or an fb.watch id
                if (preg_match('/^story_fbid=(\w+):id=(\d+)$/', $key, $match)) {
                    return 'https://www.facebook.com/permalink.php?story_fbid=' . $match[1] . '&id=' . $match[2];
                }
                if (ctype_digit($key)) {
                    return 'https://www.facebook.com/watch/?v=' . $key;
                }
                return preg_match('/^\w+$/', $key) ? 'https://fb.watch/' . $key : 'https://www.facebook.com/' . $path;

            case 'twitter':
                // X's address for a post, which needs no author name
                return ctype_digit($key) ? 'https://x.com/i/status/' . $key : '';

            case 'tiktok':
                // The oEmbed scheme's tiktok.com/video/{id} is no page
                return ctype_digit($key) ? 'https://www.tiktok.com/@/video/' . $key : '';

            case 'applemusic':
                // "country/type/id"
                return 'https://music.apple.com/' . $path;
            case 'imgur':
                // "a/id" (an album) or "id"
                return 'https://imgur.com/' . $path;
            case 'giphy':
                return 'https://giphy.com/gifs/' . $path;
            case 'instagram':
                return 'https://www.instagram.com/p/' . $path . '/';
            case 'pinterest':
                return 'https://www.pinterest.com/pin/' . $path . '/';

            case 'bluesky':
            case 'flickr':
            case 'reddit':
            case 'soundcloud':
            case 'tumblr':
                // The key is what the site's oEmbed URL scheme takes
                return $site->oembed_url_scheme ? str_replace('{$id}', $path, $site->oembed_url_scheme) : '';
        }

        return null;
    }

    /**
     * A page address from the site's own patterns: its oEmbed URL scheme,
     * then each match URL. Only one the site's patterns read back as this
     * key, so empty for a key a match callback rewrote, or for patterns with
     * wildcards.
     */
    protected function getMediaUrlFromPatterns(\XF\Entity\BbCodeMediaSite $site, string $mediaKey): string
    {
        $id = $this->encodeMediaKey($mediaKey);

        $urls = [];
        if ($site->oembed_url_scheme) {
            $urls[] = str_replace('{$id}', $id, $site->oembed_url_scheme);
        }
        foreach (preg_split('/\r?\n/', (string)$site->match_urls) as $pattern) {
            $pattern = trim($pattern);
            if ($pattern === '') {
                continue;
            }
            if ($site->match_is_regex) {
                $urls[] = $this->getUrlFromRegex($pattern, $id);
            } elseif (strpos($pattern, '*') === false) {
                $urls[] = preg_replace('/\{\$id(?::[a-z]+)?\}/i', $id, $pattern);
            }
        }

        foreach ($urls as $url) {
            if (strpos($url, $id) === false) {
                continue;
            }
            $url = preg_match('#^https?://#i', $url) ? $url : 'https://' . ltrim($url, '/');
            if (!preg_match('/^[a-z0-9-]+(\.[a-z0-9-]+)+$/i', (string)parse_url($url, PHP_URL_HOST))) {
                continue;
            }
            foreach ($site->regexes as $regex) {
                if (preg_match($regex, $url, $match) && isset($match['id']) && urldecode($match['id']) === $mediaKey) {
                    return $url;
                }
            }
        }
        return '';
    }

    /**
     * A regex match URL as an address, when it is plain text apart from its
     * id group, anchors and optional parts:
     * "#^https://vimeo.com/(?P<id>\d+)(?:\#t=…)?$#siU" gives https://vimeo.com/{id}.
     */
    protected function getUrlFromRegex(string $regex, string $id): string
    {
        $delimiter = $regex[0] ?? '';
        $end = $delimiter !== '' ? strrpos($regex, $delimiter) : false;
        if (!$end) {
            return '';
        }
        $body = preg_replace('/^\^|(?<!\\\\)\$$/', '', substr($regex, 1, $end - 1));
        $body = str_replace('https?:', 'https:', $body);

        $url = '';
        $hasId = false;
        for ($i = 0, $length = strlen($body); $i < $length; $i++) {
            $char = $body[$i];
            if ($char === '\\') {
                // An escaped character is itself; \d, \w and the like aren't text
                $next = $body[++$i] ?? '';
                if ($next === '' || ctype_alnum($next)) {
                    return '';
                }
                $url .= $next;
            } elseif ($char === '(') {
                $close = $this->findRegexGroupEnd($body, $i);
                if ($close === null) {
                    return '';
                }
                if (!$hasId && preg_match('/^\(\?(?:P?<id>|\'id\')/', substr($body, $i, 8))) {
                    $url .= $id;
                    $hasId = true;
                } elseif (!in_array($body[$close + 1] ?? '', ['?', '*'], true)) {
                    // A part the URL must have, and can't be read as text
                    return '';
                } else {
                    $close++;
                }
                $i = $close;
            } elseif (strpos('[]{}*+?|^$', $char) !== false) {
                return '';
            } else {
                // An unescaped "." stands for itself in these patterns
                $url .= $char;
            }
        }
        return $hasId ? $url : '';
    }

    /**
     * Where the regex group opened at $start closes, skipping escapes and
     * character classes; null when it doesn't.
     */
    protected function findRegexGroupEnd(string $body, int $start): ?int
    {
        $depth = 0;
        $inClass = false;
        for ($i = $start, $length = strlen($body); $i < $length; $i++) {
            $char = $body[$i];
            if ($char === '\\') {
                $i++;
            } elseif ($inClass) {
                $inClass = $char !== ']';
            } elseif ($char === '[') {
                $inClass = true;
                // "[]…]" and "[^]…]" start with a literal "]"
                $i += (($body[$i + 1] ?? '') === '^') ? 1 : 0;
                $i += (($body[$i + 1] ?? '') === ']') ? 1 : 0;
            } elseif ($char === '(') {
                $depth++;
            } elseif ($char === ')' && --$depth === 0) {
                return $i;
            }
        }
        return null;
    }

    /**
     * A media key in a URL: encoded, but with the "/", ":", "#", "=", "@"
     * and "," that keys use as separators (renderTagMedia already refused
     * keys with ? & " ' < >).
     */
    protected function encodeMediaKey(string $key): string
    {
        return strtr(rawurlencode($key), ['%2F' => '/', '%3A' => ':', '%23' => '#', '%3D' => '=', '%40' => '@', '%2C' => ',']);
    }

    protected function getRenderedQuote($content, $name, array $source, array $attributes)
    {
        $attrs = ' data-quote-name="' . htmlspecialchars((string)$name) . '"';
        if (!empty($source['type']) && !empty($source['id'])) {
            $attrs .= ' data-quote-type="' . htmlspecialchars($source['type']) . '"'
                . ' data-quote-id="' . intval($source['id']) . '"';
        }
        if (!empty($attributes['member'])) {
            $attrs .= ' data-quote-member-id="' . intval($attributes['member']) . '"';
        }

        return $this->wrapHtml('<blockquote' . $attrs . '>', $content, '</blockquote>');
    }

    protected function getRenderedSpoiler($content, $title = null)
    {
        $titleAttr = $title !== null ? ' data-spoiler-title="' . htmlspecialchars(strip_tags((string)$title)) . '"' : '';
        $summary = $title !== null ? $title : \XF::phrase('spoiler');

        return $this->wrapHtml(
            '<details data-spoiler' . $titleAttr . '><summary>' . $summary . '</summary>',
            $content,
            '</details>'
        );
    }

    protected function getRenderedInlineSpoiler($content)
    {
        return $this->wrapHtml('<span data-inline-spoiler>', $content, '</span>');
    }

    protected function getRenderedUser($content, int $userId)
    {
        $link = \XF::app()->router('public')->buildLink('canonical:members', ['user_id' => $userId]);

        return $this->wrapHtml(
            '<a href="' . htmlspecialchars($link) . '" data-user-id="' . $userId . '">',
            $content,
            '</a>'
        );
    }

    protected function getRenderedUnfurl($url, array $options)
    {
        $result = $this->getUnfurlResultFromUrl($url, $options);
        if (!$result || !$result->title) {
            return '<div>' . $this->getRenderedLink($this->prepareTextFromUrlExtended($url, $options), $url, $options) . '</div>';
        }

        $image = $result->image_url ? (string)$result->image_url : '';
        $favicon = $result->favicon_url ? (string)$result->favicon_url : '';

        return '<div data-unfurl data-url="' . htmlspecialchars($url) . '"'
            . ' data-title="' . htmlspecialchars((string)$result->title) . '"'
            . ' data-description="' . htmlspecialchars((string)$result->description) . '"'
            . ' data-image="' . htmlspecialchars($image) . '"'
            . ' data-favicon="' . htmlspecialchars($favicon) . '">'
            . $this->getRenderedLink(htmlspecialchars((string)$result->title), $url, $options)
            . '</div>';
    }
}

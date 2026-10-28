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
 *   <div data-media-site data-media-key data-media-url>   a media embed (BBCode [MEDIA])
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
     * A link to the media from the site's first plain URL pattern
     * ("youtube.com/watch?v={$id}"), when it has one without wildcards.
     */
    protected function getMediaUrl(string $siteId, string $mediaKey): string
    {
        // XenForo's media site cache has no URL patterns: read them once per request
        static $matchUrls = null;
        if ($matchUrls === null) {
            $matchUrls = \XF::db()->fetchPairs('SELECT media_site_id, match_urls FROM xf_bb_code_media_site');
        }

        foreach (preg_split('/\r?\n/', (string)($matchUrls[$siteId] ?? '')) as $pattern) {
            $pattern = trim($pattern);
            if ($pattern === '' || $pattern[0] === '#' || strpos($pattern, '*') !== false) {
                continue;
            }
            $url = preg_replace('/\{\$id(?::[a-z]+)?\}/i', rawurlencode($mediaKey), $pattern, 1, $count);
            if ($count) {
                return preg_match('#^https?://#i', $url) ? $url : 'https://' . $url;
            }
        }
        return '';
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

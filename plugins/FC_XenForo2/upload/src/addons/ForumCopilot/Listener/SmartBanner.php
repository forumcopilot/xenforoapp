<?php

namespace ForumCopilot\Listener;

use XF\Template\Templater;

class SmartBanner
{
    private const APPLE_ITUNES_APP_ID = '6755660616';

    /**
     * Injects the iOS native Smart Banner meta tag into the page head when the option is enabled.
     * Safari on iOS will show a native app banner; other browsers ignore the tag.
     *
     * @param Templater $templater
     * @param string    $type
     * @param string    $template
     * @param array     $params
     */
    public static function templateHook(Templater $templater, &$type, &$template, array &$params)
    {
        if ($type !== 'public' || strtoupper($template) !== 'PAGE_CONTAINER') {
            return;
        }

        $app = \XF::app();
        $options = $app->options();

        if (empty($options->fc_smart_banner_enabled)) {
            return;
        }

        $userAgent = isset($_SERVER['HTTP_USER_AGENT']) ? (string) $_SERVER['HTTP_USER_AGENT'] : '';
        if (preg_match('/bot|crawl|slurp|spider/i', $userAgent)) {
            return;
        }

        $content = 'app-id=' . self::APPLE_ITUNES_APP_ID;
        $html = '<!-- Forum Copilot Smart Banner (iOS native) -->'
            . '<meta name="apple-itunes-app" content="' . htmlspecialchars($content, ENT_QUOTES, 'UTF-8') . '">';

        $head = isset($params['head']) ? $params['head'] : [];
        if (!is_array($head)) {
            $head = [];
        }
        $head['fc_smart_banner'] = new \XF\PreEscaped($html);
        $params['head'] = $head;
    }
}

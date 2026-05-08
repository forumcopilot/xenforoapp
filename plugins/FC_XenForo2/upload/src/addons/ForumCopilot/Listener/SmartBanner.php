<?php

namespace ForumCopilot\Listener;

use XF\Template\Templater;

class SmartBanner
{
    private const DEFAULT_IOS_APP_ID = '6755660616';
    private const DEFAULT_ANDROID_PACKAGE = 'com.forumcopilot.mobile';
    private const ASSET_BASE = 'js/ForumCopilot/';
    private const DEFAULT_ICON = 'js/ForumCopilot/smartbanner-icon.png';

    /**
     * Injects the Forum Copilot smart banner stylesheet, script and init call
     * into <head> on every public page when enabled. The banner itself is
     * rendered client-side and only appears on iOS / Android browsers.
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

        // Skip bots — no banner needed and we keep the markup clean for SEO.
        $userAgent = isset($_SERVER['HTTP_USER_AGENT']) ? (string) $_SERVER['HTTP_USER_AGENT'] : '';
        if (preg_match('/bot|crawl|slurp|spider/i', $userAgent)) {
            return;
        }

        $iosId = trim((string) ($options->fc_smart_banner_ios_app_id ?? '')) ?: self::DEFAULT_IOS_APP_ID;
        $androidPkg = trim((string) ($options->fc_smart_banner_android_package ?? '')) ?: self::DEFAULT_ANDROID_PACKAGE;
        $iconUrl = trim((string) ($options->fc_smart_banner_icon_url ?? ''));

        $boardUrl = rtrim((string) $options->boardUrl, '/');
        $addon = $app->addOnManager()->getById('ForumCopilot');
        $assetVer = $addon ? (string) $addon->version_id : (string) time();

        $css = $boardUrl . '/' . self::ASSET_BASE . 'smartbanner.css?v=' . $assetVer;
        $js  = $boardUrl . '/' . self::ASSET_BASE . 'smartbanner.js?v=' . $assetVer;
        if ($iconUrl === '') {
            $iconUrl = $boardUrl . '/' . self::DEFAULT_ICON;
        }

        $title = (string) ($options->boardTitle ?: 'Forum');
        $config = [
            'title' => $title,
            'subtitle' => 'Faster browsing in the app',
            'cta' => 'Open',
            'icon' => $iconUrl,
            'appStoreId' => 'id' . preg_replace('/[^0-9]/', '', $iosId),
            'playStoreId' => preg_replace('/[^a-zA-Z0-9._]/', '', $androidPkg),
            'dismissDays' => 7,
            'position' => 'bottom',
        ];

        $configJson = json_encode($config, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

        $html =
            '<!-- Forum Copilot Smart Banner -->'
            . '<link rel="stylesheet" href="' . htmlspecialchars($css, ENT_QUOTES, 'UTF-8') . '">'
            . '<script src="' . htmlspecialchars($js, ENT_QUOTES, 'UTF-8') . '" defer></script>'
            . '<script>document.addEventListener("DOMContentLoaded",function(){if(window.SmartBanner)SmartBanner.init('
            . $configJson
            . ');});</script>';

        $head = isset($params['head']) ? $params['head'] : [];
        if (!is_array($head)) {
            $head = [];
        }
        $head['fc_smart_banner'] = new \XF\PreEscaped($html);
        $params['head'] = $head;
    }
}

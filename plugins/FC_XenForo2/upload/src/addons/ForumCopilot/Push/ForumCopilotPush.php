<?php

namespace ForumCopilot\Push;

use ForumCopilot\BackendApi;
use XF;
use XF\App;
use XF\Entity\Post;
use XF\Entity\Thread;
use XF\Entity\User;
use XF\Entity\Forum;

class ForumCopilotPush
{
    protected $app;
    protected $options;
    protected $boardUrl;

    public function __construct()
    {
        $this->app = XF::app();
        $this->options = $this->app->options();
        $this->boardUrl = $this->getBoardUrl();
    }

    public static function getBoardUrl()
    {
        $app = XF::app();
        $homePageUrl = $app->container('homePageUrl');
        if ($homePageUrl) {
            return $homePageUrl;
        }
        return $app->options()->boardUrl;
    }


    protected function canDoPush()
    {
        return $this->options->fc_push_enabled && 
               function_exists('curl_init') && 
               !empty($this->options->fc_push_api_url);
    }


    /**
     * Send push notification
     *
     * @param array $userIds
     * @param string $title
     * @param string $message
     * @param string $url
     * @param array $additionalData Additional metadata
     */
    public function sendPushNotification(array $userIds, $title, $message, $url, array $additionalData = [])
    {
        if (!$this->canDoPush() || empty($userIds)) {
            return false;
        }

        $apiUrl = rtrim($this->options->fc_push_api_url, '/') . '/push';
        
        $siteId = $this->getForumIdFromUrl($url ?: $this->boardUrl);
        if (!$siteId) {
            \XF::logError('FC Push: Cannot send push - site_id not available');
            return false;
        }
        
        // Build the new payload structure
        $data = [
            'directpush' => 'xenforo',
            'title' => $this->cleanString($title),
            'body' => $this->cleanString($message),
            'url' => $url ?: $this->boardUrl,
            'site_id' => $siteId,
            'target_user_ids' => array_map('intval', $userIds),
            'data' => [
                'site_id' => $siteId,
                'event_date' => time()
            ]
        ];

        // Merge all additional data into data object - everything in $additionalData goes to push notification
        $data['data'] = array_merge($data['data'], $additionalData);

        $this->sendWebhook($apiUrl, $data);
        return true;
    }

    protected function getForumIdFromUrl($url)
    {
        // Use site_id from options (set during site registration)
        $siteId = $this->options->fc_site_id ?? null;
        
        if (empty($siteId)) {
            \XF::logError('FC Push: fc_site_id not configured. Please register site in admin panel.');
            return null;
        }
        
        return $siteId;
    }

    protected function sendWebhook($url, $data)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        
        $headers = [
            'Content-Type: application/json',
            'User-Agent: ' . BackendApi::USER_AGENT
        ];
        
        if (!empty($this->options->fc_push_api_key)) {
            $headers[] = 'Authorization: Bearer ' . $this->options->fc_push_api_key;
        }
        
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if ($curlError) {
            \XF::logError('ForumCopilot Push Failed: cURL error - ' . $curlError);
            \XF::logError('ForumCopilot Push URL: ' . $url);
            return;
        }

        if ($httpCode !== 200) {
            \XF::logError('ForumCopilot Push Failed: HTTP ' . $httpCode . ' - ' . $response);
            \XF::logError('ForumCopilot Push Data: ' . json_encode($data));
        }
    }

    protected function cleanString($str)
    {
        $str = strip_tags($str);
        $str = trim($str);
        return html_entity_decode($str, ENT_QUOTES, 'UTF-8');
    }

    protected function cleanPost($post, $extraStates = [])
    {
        if (!isset($extraStates['states']['returnHtml'])) {
            $extraStates['states']['returnHtml'] = false;
        }

        if ($extraStates['states']['returnHtml']) {
            $post = str_replace("&", '&amp;', $post);
            $post = str_replace("<", '&lt;', $post);
            $post = str_replace(">", '&gt;', $post);
            $post = str_replace("\r", '', $post);
            $post = str_replace("\n", '<br />', $post);
        }

        if (!$extraStates) {
            $extraStates = ['states' => []];
        }

        $post = preg_replace('/\[(CODE|PHP|HTML)\](.*?)\[\/\1\]/si', '[CODE]$2[/CODE]', $post);
        $post = $this->processListTag($post);

        $formatter = $this->app->stringFormatter();
        $post = $formatter->censorText($post);
        $post = $formatter->stripBbCode($post);

        return trim($post);
    }

    protected function processListTag($message)
    {
        $contents = preg_split('#(\[LIST=[^\]]*?\]|\[/?LIST\])#siU', $message, -1, PREG_SPLIT_NO_EMPTY | PREG_SPLIT_DELIM_CAPTURE);

        $result = '';
        $status = 'out';
        foreach ($contents as $content) {
            if ($status == 'out') {
                if ($content == '[LIST]') {
                    $status = 'inlist';
                } elseif (strpos($content, '[LIST=') !== false) {
                    $status = 'inorder';
                } else {
                    $result .= $content;
                }
            } elseif ($status == 'inlist') {
                if ($content == '[/LIST]') {
                    $status = 'out';
                } else {
                    $result .= str_replace('[*]', '  * ', ltrim($content));
                }
            } elseif ($status == 'inorder') {
                if ($content == '[/LIST]') {
                    $status = 'out';
                } else {
                    $index = 1;
                    $result .= preg_replace_callback('/\[\*\]/s', function($matches) use (&$index) {
                        return '  ' . $index++ . '. ';
                    }, ltrim($content));
                }
            }
        }
        return $result;
    }

    protected function getClientUserAgent()
    {
        return $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';
    }

    protected function getIsFromApp()
    {
        // Check if request is from mobile app
        $userAgent = $this->getClientUserAgent();
        return (strpos($userAgent, 'ForumCopilot') !== false) ? 1 : 0;
    }

    protected function getUserType($user)
    {
        if ($user['is_banned']) {
            return 'banned';
        }
        if (in_array($user['user_state'], ['email_confirm', 'email_confirm_edit', 'Email invalid (bounced)'])) {
            return 'inactive';
        }
        if ($user['user_state'] == 'moderated') {
            return 'unapproved';
        }

        $groupid = $user['display_style_group_id'];
        if ($groupid == 3) {
            return 'admin';
        } else if ($groupid == 4) {
            return 'mod';
        } else if ($groupid == 2) {
            return 'normal';
        } else if ($groupid == 1) {
            return ' ';
        }
        
        return ' ';
    }
}

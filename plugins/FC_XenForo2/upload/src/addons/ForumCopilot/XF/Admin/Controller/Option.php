<?php

namespace ForumCopilot\XF\Admin\Controller;

use ForumCopilot\BackendApi;
use XF\Mvc\ParameterBag;

class Option extends XFCP_Option
{
    public function actionGroups()
    {
        $reply = parent::actionGroups();
        
        // Add register site button for fc_options group
        if ($reply instanceof \XF\Mvc\Reply\View)
        {
            $groupId = $this->filter('group_id', 'str');
            if ($groupId === 'fc_options')
            {
                $reply->setParam('registerSiteUrl', $this->buildLink('forumcopilot/options/register-site'));
            }
        }
        
        return $reply;
    }
    
    public function actionUpdate()
    {
        // Check if register site button was pressed
        $registerSite = $this->filter('register_site', 'bool');
        
        if ($registerSite)
        {
            // Call register site logic directly
            return $this->registerSite();
        }
        
        return parent::actionUpdate();
    }
    
    protected function registerSite()
    {
        $this->assertPostOnly();

        $options = $this->app->options();
        
        $apiUrl = BackendApi::API_URL . '/register-site-public';
        
        $boardUrl = rtrim($options->boardUrl, '/');
        $boardTitle = $options->boardTitle ?? 'Community Forum';
        $boardDescription = $options->boardDescription ?? 'Community Forum';
        
        $data = [
            'name' => $boardTitle,
            'url' => $boardUrl,
            'description' => $boardDescription,
            'endpoint' => 'forumcopilot.php',
            'provider' => 'xenforo'
        ];
        
        $ch = curl_init($apiUrl);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => json_encode($data),
            CURLOPT_HTTPHEADER => [
                'Content-Type: application/json',
                'User-Agent: ' . BackendApi::USER_AGENT
            ],
            CURLOPT_TIMEOUT => 10,
            CURLOPT_SSL_VERIFYPEER => true
        ]);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);
        
        if ($curlError)
        {
            return $this->error('Registration failed: Connection error - ' . $curlError . ' You can refresh this page to attempt registration again.');
        }
        
        if ($httpCode === 200)
        {
            $result = json_decode($response, true);
            if ($result && isset($result['site_id']))
            {
                $siteId = $result['site_id'];
                $apikey = $result['apikey'] ?? null;
                $created = $result['created'] ?? false;
                
                // Store site_id and apikey in options (use fc_push_api_key)
                $optionRepo = $this->repository('XF:Option');
                $updateData = ['fc_site_id' => (string)$siteId];
                if ($apikey) {
                    $updateData['fc_push_api_key'] = $apikey;
                }
                $optionRepo->updateOptions($updateData);
                
                $message = 'Site registered successfully! Site ID: ' . $siteId;
                if ($created) {
                    $message .= ' (new site created)';
                } else {
                    $message .= ' (existing site)';
                }
                
                return $this->redirect($this->buildLink('options/groups', ['group_id' => 'fc_options']), $message);
            }
            else
            {
                return $this->error('Registration failed: Invalid response format - ' . $response . ' You can refresh this page to attempt registration again.');
            }
        }
        else
        {
            $errorData = json_decode($response, true);
            $errorMessage = $errorData['error'] ?? 'Unknown error';
            return $this->error('Registration failed: HTTP ' . $httpCode . ' - ' . $errorMessage . ' You can refresh this page to attempt registration again.');
        }
    }
}


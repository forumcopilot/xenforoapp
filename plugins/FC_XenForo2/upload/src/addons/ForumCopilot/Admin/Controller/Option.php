<?php

namespace ForumCopilot\Admin\Controller;

use ForumCopilot\BackendApi;
use XF\Admin\Controller\AbstractController;
use XF\Mvc\ParameterBag;

class Option extends AbstractController
{
    public function actionIndex()
    {
        $options = $this->app->options();
        
        // If site_id doesn't exist, try to register automatically
        $siteId = $options->fc_site_id ?? '';
        $apikey = $options->fc_push_api_key ?? '';
        
        $registrationError = null;
        if (empty($siteId) || empty($apikey))
        {
            // Try to register site automatically
            $registrationResult = $this->tryRegisterSite();
            if ($registrationResult['success'])
            {
                $siteId = $registrationResult['site_id'];
                $apikey = $registrationResult['apikey'] ?? $apikey;
                // Reload options to get updated values
                $options = $this->app->options();
            }
            else
            {
                // Store error message to display to user
                $errorMsg = $registrationResult['error'] ?? 'Registration failed. Please try again later.';
                $registrationError = 'Site registration failed: ' . $errorMsg . ' You can refresh this page to attempt registration again.';
            }
        }
        
        $viewParams = [
            'fc_push_enabled' => $options->fc_push_enabled,
            'fc_push_api_url' => $options->fc_push_api_url,
            'fc_push_api_key' => $options->fc_push_api_key,
            'fc_site_id' => $siteId,
            'fc_smart_banner_enabled' => $options->fc_smart_banner_enabled ?? false,
            'registration_error' => $registrationError
        ];

        return $this->view('ForumCopilot:Option', 'fc_option', $viewParams);
    }

    public function actionSave()
    {
        $this->assertPostOnly();

        $input = $this->filter([
            'fc_push_enabled' => 'bool',
            'fc_push_api_url' => 'str',
            'fc_push_api_key' => 'str',
            'fc_site_id' => 'str',
            'fc_smart_banner_enabled' => 'bool'
        ]);

        $optionRepo = $this->repository('XF:Option');
        $optionRepo->updateOptions($input);

        return $this->redirect($this->buildLink('options/groups', ['group_id' => 'fc_options']));
    }

    public function actionTest()
    {
        $this->assertPostOnly();

        $apiUrl = $this->filter('fc_push_api_url', 'str');
        $apiKey = $this->filter('fc_push_api_key', 'str');

        if (empty($apiUrl)) {
            return $this->error('API URL is required');
        }

        // Test webhook connection
        $testData = [
            'event_type' => 'test',
            'forum_id' => 1,
            'author_username' => 'Test User',
            'author_user_id' => 1,
            'target_user_ids' => ['1'],
            'content' => [
                'type' => 'test',
                'id' => 'test_123',
                'title' => 'Test Notification',
                'subforum_id' => '1',
                'subforum_name' => 'Test Forum',
                'topic_id' => 'test_123',
                'topic_title' => 'Test Notification'
            ]
        ];

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, rtrim($apiUrl, '/') . '/api/webhook/forum-content');
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($testData));
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'User-Agent: ' . BackendApi::USER_AGENT
        ]);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        
        if (!empty($apiKey)) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'Authorization: Bearer ' . $apiKey,
                'User-Agent: ' . BackendApi::USER_AGENT
            ]);
        }

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        if ($error) {
            return $this->error('Connection failed: ' . $error);
        }

        if ($httpCode === 200) {
            return $this->message('Test successful! API connection is working.');
        } else {
            return $this->error('Test failed: HTTP ' . $httpCode . ' - ' . $response);
        }
    }

    /**
     * Try to register site automatically (called when loading options page if not registered)
     * 
     * @return array ['success' => bool, 'site_id' => string|null, 'apikey' => string|null, 'error' => string|null]
     */
    private function tryRegisterSite(): array
    {
        try
        {
            $options = $this->app->options();
            
            $apiUrl = BackendApi::API_URL . '/register-site-public';
            
            $boardUrl = rtrim($options->boardUrl, '/');
            $boardTitle = $options->boardTitle ?? 'Community Forum';
            $boardDescription = $options->boardDescription ?? 'Community Forum';
            
            // Get email of the current admin user
            $techContact = null;
            try
            {
                $visitor = \XF::visitor();
                if ($visitor && $visitor->user_id > 0 && !empty($visitor->email))
                {
                    $techContact = $visitor->email;
                }
            }
            catch (\Throwable $e)
            {
                // If we can't get visitor email, continue without it
            }
            
            $data = [
                'name' => $boardTitle,
                'url' => $boardUrl,
                'description' => $boardDescription,
                'endpoint' => 'forumcopilot.php',
                'provider' => 'xenforo'
            ];
            
            // Add tech_contact if available
            if ($techContact)
            {
                $data['tech_contact'] = $techContact;
            }
            
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
                return [
                    'success' => false,
                    'site_id' => null,
                    'apikey' => null,
                    'error' => 'Connection error: ' . $curlError
                ];
            }
            
            if ($httpCode === 200)
            {
                $result = json_decode($response, true);
                if ($result && isset($result['site_id']))
                {
                    $siteId = $result['site_id'];
                    $apikey = $result['apikey'] ?? null;
                    
                    // Store site_id and apikey in options
                    $optionRepo = $this->repository('XF:Option');
                    $updateData = ['fc_site_id' => (string)$siteId];
                    if ($apikey) {
                        $updateData['fc_push_api_key'] = $apikey;
                    }
                    $optionRepo->updateOptions($updateData);
                    
                    return [
                        'success' => true,
                        'site_id' => $siteId,
                        'apikey' => $apikey,
                        'error' => null
                    ];
                }
                else
                {
                    return [
                        'success' => false,
                        'site_id' => null,
                        'apikey' => null,
                        'error' => 'Invalid response format: ' . $response
                    ];
                }
            }
            else
            {
                $errorData = json_decode($response, true);
                $errorMessage = $errorData['error'] ?? 'Unknown error';
                return [
                    'success' => false,
                    'site_id' => null,
                    'apikey' => null,
                    'error' => 'HTTP ' . $httpCode . ': ' . $errorMessage
                ];
            }
        }
        catch (\Throwable $e)
        {
            return [
                'success' => false,
                'site_id' => null,
                'apikey' => null,
                'error' => $e->getMessage()
            ];
        }
    }

}

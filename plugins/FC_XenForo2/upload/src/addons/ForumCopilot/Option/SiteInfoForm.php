<?php

namespace ForumCopilot\Option;

use ForumCopilot\BackendApi;
use XF\Entity\Option;
use XF\Option\AbstractOption;

class SiteInfoForm extends AbstractOption
{
    public static function renderForm(Option $option, array $htmlParams)
    {
        $app = \XF::app();
        $options = $app->options();

        // During addon installation/setup, boardUrl may not be set yet; show placeholder
        if (!isset($options->boardUrl))
        {
            return '<div style="padding: 20px;">'
                . '<div class="formRow">'
                . '<div class="blockMessage blockMessage--info">Forum information form will be available after installation is complete.</div>'
                . '</div>'
                . '</div>';
        }

        $siteId = $options->fc_site_id ?? '';
        $apikey = $options->fc_push_api_key ?? '';
        
        // If not registered, attempt automatic registration
        if (empty($siteId) || empty($apikey)) {
            $registrationResult = static::attemptRegistration();
            
            // Refresh options after registration attempt
            $options = $app->options();
            $siteId = $options->fc_site_id ?? '';
            $apikey = $options->fc_push_api_key ?? '';
            
            // If still not registered after attempt, show message (fields will be rendered by XenForo automatically)
            if (empty($siteId) || empty($apikey)) {
                if ($registrationResult['attempted']) {
                    // Error case: show site_id and api_key for manual entry, hide push options
                    $errorMsg = $registrationResult['error'] ?? 'Registration failed. Please try again later.';
                    $jsErrorMode = '<script>
                        (function() {
                            var optionsToHide = ["fc_push_enabled", "fc_push_api_url", "fc_push_api_key"];
                            optionsToHide.forEach(function(optionId) {
                                var input = document.getElementById("ctrl_" + optionId);
                                if (input) {
                                    var formRow = input.closest(".formRow");
                                    if (formRow) {
                                        formRow.style.display = "none";
                                    }
                                }
                            });
                            var apiKeyInput = document.getElementById("ctrl_fc_push_api_key");
                            if (apiKeyInput) {
                                var apiKeyFormRow = apiKeyInput.closest(".formRow");
                                if (apiKeyFormRow) {
                                    apiKeyFormRow.style.display = "";
                                }
                            }
                        })();
                    </script>';
                    
                    return '<div style="padding: 20px;">'
                        . '<div class="formRow">'
                        . '<div class="blockMessage blockMessage--error">'
                        . '<p><strong>Automatic registration failed</strong></p>'
                        . '<p>' . htmlspecialchars($errorMsg) . '</p>'
                        . '<p><strong>What to do:</strong></p>'
                        . '<ul>'
                        . '<li>Check that your forum URL is accessible from the internet</li>'
                        . '<li>Verify that the forumcopilot.php file is in your forum root directory</li>'
                        . '<li>Ensure your server allows outbound HTTPS connections</li>'
                        . '<li>You can enter your Site ID and API Key manually in the fields above, or refresh this page to try automatic registration again</li>'
                        . '<li>Please contact support at support@forumcopilot.com if you need help</li>'
                        . '</ul>'
                        . '</div>'
                        . '</div>'
                        . $jsErrorMode
                        . '</div>';
                } else {
                    // No error yet: hide all push options (fc_site_id is in debug-only group, so hidden natively)
                    $jsHideAll = '<script>
                        (function() {
                            var optionsToHide = ["fc_push_enabled", "fc_push_api_url", "fc_push_api_key"];
                            optionsToHide.forEach(function(optionId) {
                                var input = document.getElementById("ctrl_" + optionId);
                                if (input) {
                                    var formRow = input.closest(".formRow");
                                    if (formRow) {
                                        formRow.style.display = "none";
                                    }
                                }
                            });
                        })();
                    </script>';
                    
                    return '<div style="padding: 20px;">'
                        . '<div class="formRow">'
                        . '<div class="blockMessage blockMessage--warning">'
                        . '<p><strong>Site not registered yet</strong></p>'
                        . '<p>Your forum needs to be registered with ForumCopilot to use the mobile app features. You can either:</p>'
                        . '<ul>'
                        . '<li>Refresh this page to attempt automatic registration</li>'
                        . '<li>Enter your Site ID and API Key manually in the fields above (if you already have them)</li>'
                        . '</ul>'
                        . '</div>'
                        . '</div>'
                        . $jsHideAll
                        . '</div>';
                }
            }
        }
        
        // Site is registered - get SSO token and show link
        $ssoData = static::getSsoToken($apikey, $siteId);
        if (!$ssoData) {
            // Error case: show site_id and api_key for manual correction, show push options
            $jsErrorMode = '<script>
                (function() {
                    var optionsToShow = ["fc_push_enabled", "fc_push_api_url", "fc_push_api_key"];
                    optionsToShow.forEach(function(optionId) {
                        var input = document.getElementById("ctrl_" + optionId);
                        if (input) {
                            var formRow = input.closest(".formRow");
                            if (formRow) {
                                formRow.style.display = "";
                            }
                        }
                    });
                    var apiKeyInput = document.getElementById("ctrl_fc_push_api_key");
                    if (apiKeyInput) {
                        var apiKeyFormRow = apiKeyInput.closest(".formRow");
                        if (apiKeyFormRow) {
                            apiKeyFormRow.style.display = "";
                        }
                    }
                })();
            </script>';
            
            return '<div style="padding: 20px;">'
                . '<div class="formRow">'
                . '<div class="blockMessage blockMessage--error">'
                . '<p><strong>Failed to authenticate with ForumCopilot backend.</strong> Please verify your API key and site ID are correct.</p>'
                . '<p>If you continue to experience issues, you can update your credentials in the fields above and try again.</p>'
                . '</div>'
                . '</div>'
                . $jsErrorMode
                . '</div>';
        }
        
        // Show success message and SSO link
        $ssoUrl = $ssoData['sso_url'];
        
        // JavaScript to show push options when registered
        $jsShowOptions = '<script>
            (function() {
                var optionsToShow = ["fc_push_enabled", "fc_push_api_url", "fc_push_api_key"];
                optionsToShow.forEach(function(optionId) {
                    var input = document.getElementById("ctrl_" + optionId);
                    if (input) {
                        var formRow = input.closest(".formRow");
                        if (formRow) {
                            formRow.style.display = "";
                        }
                    }
                });
            })();
        </script>';
        
        return '<div style="padding: 20px;">'
            . '<div class="formRow">'
            . '<div class="blockMessage blockMessage--success">'
            . '<p><strong>✓ Your forum is successfully connected to ForumCopilot!</strong></p>'
            . '<p>Your site is registered and ready to use. Click the button below to manage your site settings in the ForumCopilot Owner Console.</p>'
            . '</div>'
            . '</div>'
            . '<div class="formRow">'
            . '<a href="' . htmlspecialchars($ssoUrl) . '" target="_blank" class="button button--primary">'
            . 'Manage Site in ForumCopilot Console'
            . '</a>'
            . '<dfn class="formRow-explain">This will open the ForumCopilot Owner Console in a new tab where you can edit your site settings, upload images, and manage your forum configuration.</dfn>'
            . '</div>'
            . $jsShowOptions
            . '</div>';
    }

    /**
     * Attempt to register site with ForumCopilot API
     *
     * @return array Result array with 'attempted' (bool), 'success' (bool), and 'error' (string|null)
     */
    private static function attemptRegistration()
    {
        try
        {
            $app = \XF::app();
            $options = $app->options();
            
            $apiUrl = BackendApi::API_URL . '/register-site-public';
            
            $boardUrl = rtrim($options->boardUrl, '/');
            $boardTitle = $options->boardTitle ?? 'Community Forum';
            $boardDescription = $options->boardDescription ?? 'Community Forum';
            
            // Get email of the current visitor/admin
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
                CURLOPT_SSL_VERIFYPEER => true,
                CURLOPT_SSL_VERIFYHOST => 2
            ]);
            
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $curlError = curl_error($ch);
            curl_close($ch);
            
            if ($curlError)
            {
                \XF::logError('ForumCopilot registration failed (from options page): Connection error - ' . $curlError);
                return [
                    'attempted' => true,
                    'success' => false,
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
                    $created = $result['created'] ?? false;
                    
                    // Store site_id and apikey in options
                    try {
                        $optionRepo = $app->repository('XF:Option');
                        
                        $updateData = ['fc_site_id' => (string)$siteId];
                        if ($apikey) {
                            $updateData['fc_push_api_key'] = $apikey;
                        }
                        
                        $optionRepo->updateOptions($updateData);
                        
                        return [
                            'attempted' => true,
                            'success' => true,
                            'error' => null
                        ];
                    } catch (\Throwable $e) {
                        \XF::logError('ForumCopilot registration: Failed to save options (from options page) - ' . $e->getMessage() . ' - site_id=' . $siteId . ($apikey ? ', apikey=' . $apikey : '') . ' - Trace: ' . $e->getTraceAsString());
                        return [
                            'attempted' => true,
                            'success' => false,
                            'error' => 'Failed to save registration data: ' . $e->getMessage()
                        ];
                    }
                }
                else
                {
                    \XF::logError('ForumCopilot registration failed (from options page): Invalid response format - ' . $response);
                    return [
                        'attempted' => true,
                        'success' => false,
                        'error' => 'Invalid response format from server'
                    ];
                }
            }
            else
            {
                $errorData = json_decode($response, true);
                $responsePreview = is_string($response) && $response !== ''
                    ? (strlen($response) > 500 ? substr($response, 0, 500) . '... (truncated)' : $response)
                    : null;
                $errorMessage = $errorData['error'] ?? ($responsePreview ? 'Non-JSON response: ' . $responsePreview : 'Unknown error');
                \XF::logError('ForumCopilot registration failed (from options page): HTTP ' . $httpCode . ' - ' . $errorMessage);
                return [
                    'attempted' => true,
                    'success' => false,
                    'error' => 'HTTP ' . $httpCode . ': ' . $errorMessage
                ];
            }
        }
        catch (\Throwable $e)
        {
            \XF::logError('ForumCopilot registration failed (from options page): ' . $e->getMessage());
            return [
                'attempted' => true,
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Get SSO token from backend
     *
     * @param string $apikey API key
     * @param string $siteId Site ID
     * @return array|false SSO token data array or false on error
     */
    private static function getSsoToken(string $apikey, string $siteId)
    {
        try
        {
            $apiUrl = BackendApi::API_URL . '/get-site-sso-token';
            
            $queryParams = http_build_query([
                'apikey' => $apikey,
                'site_id' => $siteId
            ]);
            
            $ch = curl_init($apiUrl . '?' . $queryParams);
            if (!$ch)
            {
                return false;
            }
            
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_HTTPHEADER => [
                    'User-Agent: ' . BackendApi::USER_AGENT
                ],
                CURLOPT_TIMEOUT => 10,
                CURLOPT_SSL_VERIFYPEER => true,
                CURLOPT_SSL_VERIFYHOST => 2,
                CURLOPT_CONNECTTIMEOUT => 5
            ]);
            
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $curlError = curl_error($ch);
            curl_close($ch);
            
            if ($curlError || $httpCode !== 200)
            {
                return false;
            }
            
            $result = json_decode($response, true);
            if ($result && isset($result['token']) && isset($result['sso_url']))
            {
                return $result;
            }
            
            return false;
        }
        catch (\Throwable $e)
        {
            return false;
        }
    }
}

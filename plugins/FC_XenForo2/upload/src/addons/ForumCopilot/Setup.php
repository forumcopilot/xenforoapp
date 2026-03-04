<?php

namespace ForumCopilot;

use XF\AddOn\AbstractSetup;
use XF\AddOn\StepRunnerInstallTrait;
use XF\AddOn\StepRunnerUninstallTrait;
use XF\AddOn\StepRunnerUpgradeTrait;
use XF\Db\Schema\Create;

class Setup extends AbstractSetup
{
    use StepRunnerInstallTrait;
    use StepRunnerUpgradeTrait;
    use StepRunnerUninstallTrait;

    public function install(array $stepParams = [])
    {
        // Options are automatically imported from _data/options.xml
        
        // Create FC user table
        $this->schemaManager()->createTable('xf_fc_user', function(Create $table)
        {
            $table->addColumn('user_id', 'int')->primaryKey();
            $table->addColumn('last_seen', 'int')->setDefault(0);
            $table->addKey('last_seen');
        });
        
        // Create FC push optout table
        $this->schemaManager()->createTable('xf_user_fc_push_optout', function(Create $table)
        {
            $table->addColumn('user_id', 'int');
            $table->addColumn('push', 'varbinary', 50);
            $table->addPrimaryKey(['user_id', 'push']);
        });
        
        // Add fc_push_optout column to xf_user_option
        try
        {
            $this->schemaManager()->alterTable('xf_user_option', function(\XF\Db\Schema\Alter $table)
            {
                $table->addColumn('fc_push_optout', 'mediumblob')->nullable();
            });
        }
        catch (\XF\Db\Schema\Exception $e)
        {
            // Column might already exist, ignore error
            if (strpos($e->getMessage(), 'Duplicate column name') === false)
            {
                throw $e;
            }
        }

        // Note: Registration with ForumCopilot API is done in postInstall()
        // to ensure all options are imported first
    }

    /**
     * Called after installation is complete (including options import)
     */
    public function postInstall(array &$stateChanges)
    {
        // Register site with ForumCopilot API after everything is installed
        $this->registerWithForumCopilot();
    }
    
    /**
     * Register site with ForumCopilot API
     */
    private function registerWithForumCopilot()
    {
        try
        {
            $app = \XF::app();
            $options = $app->options();
            
            $apiUrl = BackendApi::API_URL . '/register-site-public';
            
            $boardUrl = rtrim($options->boardUrl, '/');
            $boardTitle = $options->boardTitle ?? 'Community Forum';
            $boardDescription = $options->boardDescription ?? 'Community Forum';
            
            // Get email of the user installing the plugin (current visitor/admin)
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
                \XF::logError('ForumCopilot registration failed: Connection error - ' . $curlError);
                return;
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
                    try {
                        $optionRepo = $app->repository('XF:Option');
                        
                        // Use updateOptions which is the proper way to update options
                        $updateData = ['fc_site_id' => (string)$siteId];
                        if ($apikey) {
                            $updateData['fc_push_api_key'] = $apikey;
                        }
                        
                        $optionRepo->updateOptions($updateData);
                    } catch (\Throwable $e) {
                        \XF::logError('ForumCopilot registration: Failed to save options - ' . $e->getMessage() . ' - site_id=' . $siteId . ($apikey ? ', apikey=' . $apikey : '') . ' - Trace: ' . $e->getTraceAsString());
                    }
                }
                else
                {
                    \XF::logError('ForumCopilot registration failed: Invalid response format - ' . $response);
                }
            }
            else
            {
                $errorData = json_decode($response, true);
                $errorMessage = $errorData['error'] ?? 'Unknown error';
                \XF::logError('ForumCopilot registration failed: HTTP ' . $httpCode . ' - ' . $errorMessage);
            }
        }
        catch (\Throwable $e)
        {
            // Log error but don't break installation
            \XF::logError('ForumCopilot registration failed: ' . $e->getMessage());
        }
    }


    public function uninstall(array $stepParams = [])
    {
        // Options will be removed automatically when addon is uninstalled

        // Drop tables
        $this->schemaManager()->dropTable('xf_fc_user');
        $this->schemaManager()->dropTable('xf_user_fc_push_optout');
        
        // Remove column from xf_user_option
        try
        {
            $this->schemaManager()->alterTable('xf_user_option', function(\XF\Db\Schema\Alter $table)
            {
                $table->dropColumns('fc_push_optout');
            });
        }
        catch (\XF\Db\Exception $e)
        {
            // Column might not exist, ignore error
        }
    }
}

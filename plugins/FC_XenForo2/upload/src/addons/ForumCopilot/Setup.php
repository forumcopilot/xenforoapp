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

    protected const ENTRY_FILE = 'forumcopilot.php';

    public function install(array $stepParams = [])
    {
        $this->copyEntryPointToWebRoot();
        $sm = $this->schemaManager();

        // Options are automatically imported from _data/options.xml

        if (!$sm->tableExists('xf_fc_user'))
        {
            $sm->createTable('xf_fc_user', function(Create $table)
            {
                $table->addColumn('user_id', 'int')->primaryKey();
                $table->addColumn('last_seen', 'int')->setDefault(0);
                $table->addKey('last_seen');
            });
        }

        if (!$sm->tableExists('xf_user_fc_push_optout'))
        {
            $sm->createTable('xf_user_fc_push_optout', function(Create $table)
            {
                $table->addColumn('user_id', 'int');
                $table->addColumn('push', 'varbinary', 50);
                $table->addPrimaryKey(['user_id', 'push']);
            });
        }

        if (!$sm->columnExists('xf_user_option', 'fc_push_optout'))
        {
            $sm->alterTable('xf_user_option', function(\XF\Db\Schema\Alter $table)
            {
                $table->addColumn('fc_push_optout', 'mediumblob')->nullable();
            });
        }

        // Device tokens for direct-to-FCM push (BYO Firebase mode).
        // Hosted-mode tokens still live in the push backend's separate DB.
        if (!$sm->tableExists('xf_fc_device_token'))
        {
            $sm->createTable('xf_fc_device_token', function(Create $table)
            {
                $table->addColumn('device_id', 'varchar', 100);
                $table->addColumn('user_id', 'int');
                $table->addColumn('fcm_token', 'varchar', 500);
                $table->addColumn('platform', 'enum')->values(['ios', 'android', 'macos', 'web'])->setDefault('android');
                // Routes dispatch: 'forumcopilot' (official app → hosted backend),
                // 'direct' (white-label app → in-process FCM via FcmClient).
                $table->addColumn('source', 'enum')->values(['forumcopilot', 'direct'])->setDefault('direct');
                $table->addColumn('app_version', 'varchar', 30)->setDefault('');
                $table->addColumn('is_token_valid', 'tinyint', 3)->setDefault(1);
                $table->addColumn('last_seen_at', 'int')->setDefault(0);
                $table->addColumn('created_at', 'int')->setDefault(0);
                $table->addColumn('updated_at', 'int')->setDefault(0);

                $table->addPrimaryKey('device_id');
                $table->addKey(['user_id', 'is_token_valid']);
                $table->addKey(['source', 'is_token_valid']);
                $table->addUniqueKey('fcm_token', 'fcm_token');
            });
        }

        // Note: Registration with ForumCopilot API is done in postInstall()
        // to ensure all options are imported first
    }

    /**
     * 1.3.2 → 1.3.3: add xf_fc_device_token table for direct (BYO) push mode.
     */
    public function upgrade1003003Step1()
    {
        $sm = $this->schemaManager();
        if (!$sm->tableExists('xf_fc_device_token'))
        {
            $sm->createTable('xf_fc_device_token', function(Create $table)
            {
                $table->addColumn('device_id', 'varchar', 100);
                $table->addColumn('user_id', 'int');
                $table->addColumn('fcm_token', 'varchar', 500);
                $table->addColumn('platform', 'enum')->values(['ios', 'android', 'macos', 'web'])->setDefault('android');
                $table->addColumn('source', 'enum')->values(['forumcopilot', 'direct'])->setDefault('direct');
                $table->addColumn('app_version', 'varchar', 30)->setDefault('');
                $table->addColumn('is_token_valid', 'tinyint', 3)->setDefault(1);
                $table->addColumn('last_seen_at', 'int')->setDefault(0);
                $table->addColumn('created_at', 'int')->setDefault(0);
                $table->addColumn('updated_at', 'int')->setDefault(0);

                $table->addPrimaryKey('device_id');
                $table->addKey(['user_id', 'is_token_valid']);
                $table->addKey(['source', 'is_token_valid']);
                $table->addUniqueKey('fcm_token', 'fcm_token');
            });
        }
    }

    /**
     * 1.3.3 → 1.3.4: enable direct push by default on existing installs.
     * "Both modes on" is the right default — a forum may serve users on the
     * official ForumCopilot app AND a white-label app. The dispatcher safely
     * no-ops the direct path until fc_push_direct_creds_path is configured.
     */
    public function upgrade1003004Step1()
    {
        $optionRepo = $this->app->repository('XF:Option');
        $optionRepo->updateOptions(['fc_push_direct_enabled' => 1]);
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


    /**
     * Refresh the webroot entry point on every upgrade. Final step in the
     * upgrade chain so it runs regardless of which version we came from.
     */
    public function postUpgrade($previousVersion, array &$stateChanges)
    {
        $this->copyEntryPointToWebRoot();
    }

    /**
     * Copy the bundled forumcopilot.php into the web root so the routes the
     * mobile app calls are always in sync with the installed addon version.
     * Logs (does not fail) on permission/missing-source so the install can
     * still complete on hosts where Setup can't write to web root.
     */
    protected function copyEntryPointToWebRoot(): void
    {
        $source = $this->addOn->getAddOnDirectory() . '/webroot_files/' . self::ENTRY_FILE;
        $target = \XF::getRootDirectory() . '/' . self::ENTRY_FILE;

        if (!file_exists($source))
        {
            \XF::logError('ForumCopilot: webroot entry-point source missing at ' . $source);
            return;
        }

        if (!@copy($source, $target))
        {
            \XF::logError(
                'ForumCopilot: failed to copy entry-point to ' . $target
                . '. Copy ' . $source . ' there manually (or set permissions on the web root).'
            );
        }
    }

    public function uninstall(array $stepParams = [])
    {
        $sm = $this->schemaManager();

        // Options will be removed automatically when addon is uninstalled

        // Drop tables
        if ($sm->tableExists('xf_fc_user'))
        {
            $sm->dropTable('xf_fc_user');
        }

        if ($sm->tableExists('xf_user_fc_push_optout'))
        {
            $sm->dropTable('xf_user_fc_push_optout');
        }

        if ($sm->tableExists('xf_fc_device_token'))
        {
            $sm->dropTable('xf_fc_device_token');
        }

        if ($sm->columnExists('xf_user_option', 'fc_push_optout'))
        {
            $sm->alterTable('xf_user_option', function(\XF\Db\Schema\Alter $table)
            {
                $table->dropColumns('fc_push_optout');
            });
        }
    }
}

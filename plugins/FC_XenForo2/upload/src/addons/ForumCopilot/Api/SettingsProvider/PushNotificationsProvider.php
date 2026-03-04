<?php

namespace ForumCopilot\Api\SettingsProvider;

use XF\Entity\User;
use XF\App;

/**
 * Settings provider for ForumCopilot push notifications
 */
class PushNotificationsProvider implements SettingsProviderInterface
{
    protected $app;

    public function __construct(App $app)
    {
        $this->app = $app;
    }

    public function getCategoryDisplayName(): string
    {
        return 'Push Notifications';
    }

    public function getCategoryDescription(): string
    {
        return 'Control ForumCopilot mobile app push notification preferences';
    }

    public function isCategoryEnabled(User $user): bool
    {
        $options = $this->app->options();
        return isset($options->fc_push_enabled) && $options->fc_push_enabled;
    }

    public function getSettingsDefinition(User $user): array
    {
        $alertRepo = $this->app->repository('XF:UserAlert');
        $optOutActions = $alertRepo->getAlertOptOutActions();

        // Get the nested structure to preserve display order from handlers
        $alertOptOuts = $alertRepo->getAlertOptOuts();
        
        // Build definition with proper display order
        $definition = [];
        $displayOrder = 1;
        
        // Process in the order returned by getAlertOptOuts (respects handler display order)
        foreach ($alertOptOuts as $contentType => $actions) {
            foreach ($actions as $action => $label) {
                $key = "{$contentType}_{$action}";
                
                // Get display name
                if ($label instanceof \XF\Phrase) {
                    $displayName = $label->render();
                } else {
                    $displayName = (string)$label;
                }
                
                // Skip if not in optOutActions (shouldn't happen, but safety check)
                if (!isset($optOutActions[$key])) {
                    continue;
                }
                
                $definition[$key] = [
                    'fieldType' => 'toggle', // Toggle switch for boolean settings
                    'dataType' => 'boolean',
                    'title' => $displayName,
                    'description' => null,
                    'default' => true,
                    'required' => false,
                    'readOnly' => false,
                    'displayOrder' => $displayOrder++,
                    'group' => 'notification_types',
                ];
            }
        }

        return $definition;
    }

    public function getCurrentValues(User $user): array
    {
        if (!$user->Option) {
            return [];
        }

        $userOptions = $user->Option;
        $fcPushOptOuts = $userOptions->fc_push_optout ?? [];
        
        $alertRepo = $this->app->repository('XF:UserAlert');
        $optOutActions = $alertRepo->getAlertOptOutActions();
        
        $values = [];
        foreach (array_keys($optOutActions) as $key) {
            // Parse contentType and action from key (format: "contentType_action")
            list($contentType, $action) = explode('_', $key, 2);
            $values[$key] = $userOptions->doesReceiveFcPush($contentType, $action);
        }

        return $values;
    }

    public function validateSettings(User $user, array $settings): array
    {
        $errors = [];

        if (!$this->isCategoryEnabled($user)) {
            $errors[] = 'Push notifications are not enabled on this forum';
            return $errors;
        }

        $alertRepo = $this->app->repository('XF:UserAlert');
        $optOutActions = $alertRepo->getAlertOptOutActions();
        $validKeys = array_keys($optOutActions);

        foreach (array_keys($settings) as $key) {
            if (!in_array($key, $validKeys)) {
                $errors[] = "Invalid setting key: {$key}";
            } else {
                // Validate value type (should be boolean)
                $value = $settings[$key];
                if (!is_bool($value) && !in_array($value, ['0', '1', 0, 1, 'true', 'false'], true)) {
                    $errors[] = "Setting '{$key}' must be a boolean value";
                }
            }
        }

        return $errors;
    }

    public function updateSettings(User $user, array $settings): void
    {
        $alertRepo = $this->app->repository('XF:UserAlert');
        $optOutActions = $alertRepo->getAlertOptOutActions();
        $validKeys = array_keys($optOutActions);

        // Get current opt-out state (preserve existing opt-outs for settings not being updated)
        // Reload user to ensure we have fresh Option entity
        $user = $this->app->em()->find('XF:User', $user->user_id, ['Option']);
        if (!$user) {
            return;
        }
        
        $userOptions = $user->getRelationOrDefault('Option');
        if (!$userOptions) {
            return;
        }
        
        // Get current opt-outs - ensure it's an array
        $currentOptOuts = $userOptions->fc_push_optout ?? [];
        if (!is_array($currentOptOuts)) {
            $currentOptOuts = [];
        }
        
        // Start with existing opt-outs (preserve settings not being updated)
        // Convert to array_values to ensure it's a simple indexed array
        $fcPushOptOuts = array_values($currentOptOuts);
        
        // Update only the settings that were provided
        foreach ($settings as $key => $enabled) {
            if (!in_array($key, $validKeys)) {
                continue; // Skip invalid keys
            }

            // Convert various formats to boolean
            $enabledBool = filter_var($enabled, FILTER_VALIDATE_BOOLEAN);
            
            if ($enabledBool) {
                // Enabled: remove from opt-out array (if present)
                $index = array_search($key, $fcPushOptOuts);
                if ($index !== false) {
                    unset($fcPushOptOuts[$index]);
                    // Re-index the array
                    $fcPushOptOuts = array_values($fcPushOptOuts);
                }
            } else {
                // Disabled: add to opt-out array (if not already present)
                if (!in_array($key, $fcPushOptOuts)) {
                    $fcPushOptOuts[] = $key;
                }
            }
        }

        // Update user options - ensure it's a simple indexed array
        $userOptions->fc_push_optout = array_values($fcPushOptOuts);
        $userOptions->save();
    }
}


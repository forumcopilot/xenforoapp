<?php

namespace ForumCopilot\Api\SettingsProvider;

use XF\Entity\User;
use XF\App;

/**
 * Settings provider for Email and Privacy preferences
 */
class EmailPrivacyProvider implements SettingsProviderInterface
{
    protected $app;

    public function __construct(App $app)
    {
        $this->app = $app;
    }

    public function getCategoryDisplayName(): string
    {
        return 'Email and Privacy';
    }

    public function getCategoryDescription(): string
    {
        return 'Manage your email preferences and privacy settings';
    }

    public function isCategoryEnabled(User $user): bool
    {
        // Always enabled for all users
        return true;
    }

    public function getSettingsDefinition(User $user): array
    {
        $definition = [];

        // Email options group
        $definition['receive_admin_email'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => 'Receive news and update emails',
            'description' => null,
            'default' => true,
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 1,
            'group' => 'email_options',
        ];

        $definition['email_on_conversation'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => 'Receive email when a new direct message is received',
            'description' => null,
            'default' => true,
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 2,
            'group' => 'email_options',
        ];

        // Content options group
        $definition['creation_watch_state'] = [
            'fieldType' => 'select',
            'dataType' => 'string',
            'title' => 'Automatically watch content you create...',
            'description' => null,
            'default' => '',
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 3,
            'group' => 'content_options',
            'choices' => [
                '' => 'No',
                'watch_no_email' => 'Yes',
                'watch_email' => 'Yes, with email',
            ],
        ];

        $definition['creation_watch_email'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => '...and receive email notifications',
            'description' => 'Only shown when "Automatically watch content you create" is enabled',
            'default' => false,
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 4,
            'group' => 'content_options',
            'dependsOn' => [
                'key' => 'creation_watch_state',
                'value' => 'watch_no_email', // Show when watch_state is not empty (watch_no_email or watch_email)
            ],
        ];

        $definition['interaction_watch_state'] = [
            'fieldType' => 'select',
            'dataType' => 'string',
            'title' => 'Automatically watch content you interact with...',
            'description' => null,
            'default' => '',
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 5,
            'group' => 'content_options',
            'choices' => [
                '' => 'No',
                'watch_no_email' => 'Yes',
                'watch_email' => 'Yes, with email',
            ],
        ];

        $definition['interaction_watch_email'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => '...and receive email notifications',
            'description' => 'Only shown when "Automatically watch content you interact with" is enabled',
            'default' => false,
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 6,
            'group' => 'content_options',
            'dependsOn' => [
                'key' => 'interaction_watch_state',
                'value' => 'watch_no_email', // Show when watch_state is not empty (watch_no_email or watch_email)
            ],
        ];

        $definition['content_show_signature'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => 'Show people\'s signatures with their messages',
            'description' => null,
            'default' => true,
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 7,
            'group' => 'content_options',
        ];

        // Privacy options group
        $definition['visible'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => 'Show your online status',
            'description' => 'This will allow other people to see when you are online.',
            'default' => true,
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 8,
            'group' => 'privacy_options',
        ];

        $definition['activity_visible'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => 'Show your current activity',
            'description' => 'This will allow other people to see what page you are currently viewing.',
            'default' => true,
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 9,
            'group' => 'privacy_options',
        ];

        return $definition;
    }

    public function getCurrentValues(User $user): array
    {
        $values = [];

        if (!$user->Option) {
            return $values;
        }

        $userOptions = $user->Option;

        // Email options
        $values['receive_admin_email'] = (bool)$userOptions->receive_admin_email;
        $values['email_on_conversation'] = (bool)$userOptions->email_on_conversation;

        // Content options
        $values['creation_watch_state'] = (string)$userOptions->creation_watch_state;
        $values['creation_watch_email'] = ($userOptions->creation_watch_state === 'watch_email');
        
        $values['interaction_watch_state'] = (string)$userOptions->interaction_watch_state;
        $values['interaction_watch_email'] = ($userOptions->interaction_watch_state === 'watch_email');
        
        $values['content_show_signature'] = (bool)$userOptions->content_show_signature;

        // Privacy options (from User entity)
        $values['visible'] = (bool)$user->visible;
        $values['activity_visible'] = (bool)$user->activity_visible;

        return $values;
    }

    public function validateSettings(User $user, array $settings): array
    {
        $errors = [];
        $validKeys = [
            'receive_admin_email',
            'email_on_conversation',
            'creation_watch_state',
            'creation_watch_email',
            'interaction_watch_state',
            'interaction_watch_email',
            'content_show_signature',
            'visible',
            'activity_visible',
        ];

        foreach (array_keys($settings) as $key) {
            if (!in_array($key, $validKeys)) {
                $errors[] = "Invalid setting key: {$key}";
                continue;
            }

            $value = $settings[$key];

            // Validate boolean fields
            if (in_array($key, ['receive_admin_email', 'email_on_conversation', 'creation_watch_email', 'interaction_watch_email', 'content_show_signature', 'visible', 'activity_visible'])) {
                if (!is_bool($value) && !in_array($value, ['0', '1', 0, 1, 'true', 'false'], true)) {
                    $errors[] = "Setting '{$key}' must be a boolean value";
                }
            }

            // Validate watch state fields
            if (in_array($key, ['creation_watch_state', 'interaction_watch_state'])) {
                $allowedValues = ['', 'watch_no_email', 'watch_email'];
                if (!in_array($value, $allowedValues, true)) {
                    $errors[] = "Setting '{$key}' must be one of: " . implode(', ', $allowedValues);
                }
            }
        }

        return $errors;
    }

    public function updateSettings(User $user, array $settings): void
    {
        // Reload user to ensure we have fresh entities
        $user = $this->app->em()->find('XF:User', $user->user_id, ['Option']);
        if (!$user) {
            return;
        }

        $userOptions = $user->getRelationOrDefault('Option');
        if (!$userOptions) {
            return;
        }

        // Update email options
        if (isset($settings['receive_admin_email'])) {
            $userOptions->receive_admin_email = filter_var($settings['receive_admin_email'], FILTER_VALIDATE_BOOLEAN);
        }

        if (isset($settings['email_on_conversation'])) {
            $userOptions->email_on_conversation = filter_var($settings['email_on_conversation'], FILTER_VALIDATE_BOOLEAN);
        }

        // Update content options
        if (isset($settings['creation_watch_state'])) {
            $watchState = (string)$settings['creation_watch_state'];
            // If creation_watch_email is set, override the watch state
            if (isset($settings['creation_watch_email'])) {
                $emailEnabled = filter_var($settings['creation_watch_email'], FILTER_VALIDATE_BOOLEAN);
                if ($emailEnabled && $watchState !== '') {
                    $watchState = 'watch_email';
                } elseif (!$emailEnabled && $watchState === 'watch_email') {
                    $watchState = 'watch_no_email';
                }
            }
            $userOptions->creation_watch_state = $watchState;
        } elseif (isset($settings['creation_watch_email'])) {
            // Only creation_watch_email was updated, update the watch state accordingly
            $emailEnabled = filter_var($settings['creation_watch_email'], FILTER_VALIDATE_BOOLEAN);
            $currentState = $userOptions->creation_watch_state;
            if ($emailEnabled && $currentState === 'watch_no_email') {
                $userOptions->creation_watch_state = 'watch_email';
            } elseif (!$emailEnabled && $currentState === 'watch_email') {
                $userOptions->creation_watch_state = 'watch_no_email';
            }
        }

        if (isset($settings['interaction_watch_state'])) {
            $watchState = (string)$settings['interaction_watch_state'];
            // If interaction_watch_email is set, override the watch state
            if (isset($settings['interaction_watch_email'])) {
                $emailEnabled = filter_var($settings['interaction_watch_email'], FILTER_VALIDATE_BOOLEAN);
                if ($emailEnabled && $watchState !== '') {
                    $watchState = 'watch_email';
                } elseif (!$emailEnabled && $watchState === 'watch_email') {
                    $watchState = 'watch_no_email';
                }
            }
            $userOptions->interaction_watch_state = $watchState;
        } elseif (isset($settings['interaction_watch_email'])) {
            // Only interaction_watch_email was updated, update the watch state accordingly
            $emailEnabled = filter_var($settings['interaction_watch_email'], FILTER_VALIDATE_BOOLEAN);
            $currentState = $userOptions->interaction_watch_state;
            if ($emailEnabled && $currentState === 'watch_no_email') {
                $userOptions->interaction_watch_state = 'watch_email';
            } elseif (!$emailEnabled && $currentState === 'watch_email') {
                $userOptions->interaction_watch_state = 'watch_no_email';
            }
        }

        if (isset($settings['content_show_signature'])) {
            $userOptions->content_show_signature = filter_var($settings['content_show_signature'], FILTER_VALIDATE_BOOLEAN);
        }

        // Update privacy options (User entity fields)
        if (isset($settings['visible'])) {
            $user->visible = filter_var($settings['visible'], FILTER_VALIDATE_BOOLEAN);
        }

        if (isset($settings['activity_visible'])) {
            $user->activity_visible = filter_var($settings['activity_visible'], FILTER_VALIDATE_BOOLEAN);
        }

        // Save both entities
        $userOptions->save();
        if ($user->isChanged(['visible', 'activity_visible'])) {
            $user->save();
        }
    }
}

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

    /**
     * The settings of XenForo's preferences and privacy pages the app shows
     * (Pub\Controller\Account::actionPreferences / actionPrivacy), with
     * XenForo's own labels and the forum's defaults for new members
     * (registrationDefaults). "Yes, with email" is one of the watch
     * choices, as on the website.
     */
    public function getSettingsDefinition(User $user): array
    {
        $defaults = $this->app->options()->registrationDefaults;
        $defaults = is_array($defaults) ? $defaults : [];
        $boolDefault = function (string $key, bool $fallback) use ($defaults): bool {
            return array_key_exists($key, $defaults) ? (bool)$defaults[$key] : $fallback;
        };
        $watchDefault = function (string $key) use ($defaults): string {
            $value = (string)($defaults[$key] ?? '');
            return in_array($value, ['watch_no_email', 'watch_email'], true) ? $value : '';
        };
        $watchChoices = [
            '' => $this->phrase('no', 'No'),
            'watch_no_email' => $this->phrase('yes', 'Yes'),
            'watch_email' => $this->phrase('yes_with_email', 'Yes, with email'),
        ];

        $definition = [];

        // Email options group
        $definition['receive_admin_email'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => $this->phrase('receive_site_mailings_option', 'Receive news and update emails'),
            'description' => null,
            'default' => $boolDefault('receive_admin_email', true),
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 1,
            'group' => 'email_options',
        ];

        $definition['email_on_conversation'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => $this->phrase(
                'receive_email_when_new_direct_message_is_received',
                'Receive email when a new direct message is received'
            ),
            'description' => null,
            'default' => $boolDefault('email_on_conversation', true),
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 2,
            'group' => 'email_options',
        ];

        // Content options group
        $definition['creation_watch_state'] = [
            'fieldType' => 'select',
            'dataType' => 'string',
            'title' => $this->phrase('automatically_watch_content_you_create', 'Automatically watch content you create'),
            'description' => null,
            'default' => $watchDefault('creation_watch_state'),
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 3,
            'group' => 'content_options',
            'choices' => $watchChoices,
        ];

        $definition['interaction_watch_state'] = [
            'fieldType' => 'select',
            'dataType' => 'string',
            'title' => $this->phrase('automatically_watch_content_you_interact_with', 'Automatically watch content you interact with'),
            'description' => null,
            'default' => $watchDefault('interaction_watch_state'),
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 5,
            'group' => 'content_options',
            'choices' => $watchChoices,
        ];

        $definition['content_show_signature'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => $this->phrase('show_peoples_signatures_with_their_messages', 'Show people\'s signatures with their messages'),
            'description' => null,
            'default' => $boolDefault('content_show_signature', true),
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 7,
            'group' => 'content_options',
        ];

        // Privacy options group
        $definition['visible'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => $this->phrase('show_your_online_status', 'Show your online status'),
            'description' => $this->phrase(
                'this_will_allow_other_people_to_see_when_you_online',
                'This will allow other people to see when you are online.'
            ),
            'default' => $boolDefault('visible', true),
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 8,
            'group' => 'privacy_options',
        ];

        $definition['activity_visible'] = [
            'fieldType' => 'toggle',
            'dataType' => 'boolean',
            'title' => $this->phrase('show_your_current_activity', 'Show your current activity'),
            'description' => $this->phrase(
                'this_will_allow_other_people_to_see_what_page_you_currently_viewing',
                'This will allow other people to see what page you are currently viewing.'
            ),
            'default' => $boolDefault('activity_visible', true),
            'required' => false,
            'readOnly' => false,
            'displayOrder' => 9,
            'group' => 'privacy_options',
        ];

        return $definition;
    }

    /**
     * A XenForo phrase as plain text, or [$fallback] where the forum has no
     * phrase of that name (some were renamed between 2.2 and 2.3).
     */
    protected function phrase(string $name, string $fallback): string
    {
        $text = \XF::phrase($name)->render('raw');
        if ($text === '' || $text === $name) {
            return $fallback;
        }
        return trim(html_entity_decode(strip_tags($text), ENT_QUOTES | ENT_HTML5, 'UTF-8'));
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

        // Content options. (creation_watch_email / interaction_watch_email,
        // toggles of earlier versions, are still accepted by updateSettings.)
        $values['creation_watch_state'] = (string)$userOptions->creation_watch_state;
        $values['interaction_watch_state'] = (string)$userOptions->interaction_watch_state;
        
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

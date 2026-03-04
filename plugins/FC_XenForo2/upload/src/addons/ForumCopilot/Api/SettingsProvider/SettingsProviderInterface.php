<?php

namespace ForumCopilot\Api\SettingsProvider;

use XF\Entity\User;

/**
 * Interface for settings providers
 * Each category of settings (push notifications, privacy, etc.) implements this interface
 */
interface SettingsProviderInterface
{
    /**
     * Get display name for this settings category
     * 
     * @return string
     */
    public function getCategoryDisplayName(): string;

    /**
     * Get description for this settings category
     * 
     * @return string
     */
    public function getCategoryDescription(): string;

    /**
     * Check if this category is enabled/available for the user
     * 
     * @param User $user
     * @return bool
     */
    public function isCategoryEnabled(User $user): bool;

    /**
     * Get settings definition (metadata for all settings in this category)
     * Returns array of [key => ['fieldType' => ..., 'title' => ..., etc.]]
     * 
     * @param User $user
     * @return array
     */
    public function getSettingsDefinition(User $user): array;

    /**
     * Get current values for all settings in this category
     * Returns array of [key => value]
     * 
     * @param User $user
     * @return array
     */
    public function getCurrentValues(User $user): array;

    /**
     * Validate settings before update
     * Returns array of error messages, empty array if valid
     * 
     * @param User $user
     * @param array $settings Array of [key => value] to validate
     * @return array Array of error messages
     */
    public function validateSettings(User $user, array $settings): array;

    /**
     * Update settings
     * 
     * @param User $user
     * @param array $settings Array of [key => value] to update
     * @return void
     */
    public function updateSettings(User $user, array $settings): void;
}


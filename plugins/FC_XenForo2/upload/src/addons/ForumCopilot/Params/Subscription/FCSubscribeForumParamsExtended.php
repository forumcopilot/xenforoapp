<?php

namespace ForumCopilot\Params\Subscription;

/**
 * Parameters for subscribeForum API method (extended version)
 * Forum-agnostic parameter class for forum subscription operations with mode
 */
class FCSubscribeForumParamsExtended
{
    /** @var string Forum ID to subscribe/unsubscribe */
    public $forumId;
    
    /** @var int Subscribe mode: 0 = no email (alerts only), 1 = instant email, 2 = daily digest, 3 = weekly digest */
    public $subscribeMode;

    /** @var string|null "thread", "message" or "" (no notifications); null = not sent (1.11.0) */
    public $notifyOn;

    /** @var bool|null Alerts for this forum; null = not sent (1.11.0) */
    public $sendAlert;

    /** @var bool|null Emails for this forum; null = not sent (1.11.0) */
    public $sendEmail;

    public function __construct($forumId = '', $subscribeMode = 0, $notifyOn = null, $sendAlert = null, $sendEmail = null)
    {
        $this->forumId = $forumId;
        $this->subscribeMode = $subscribeMode;
        $this->notifyOn = $notifyOn;
        $this->sendAlert = $sendAlert;
        $this->sendEmail = $sendEmail;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['forumId'] ?? '',
            $data['subscribeMode'] ?? 0,
            $data['notifyOn'] ?? null,
            self::toOptionalBool($data['sendAlert'] ?? null),
            self::toOptionalBool($data['sendEmail'] ?? null)
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (empty($this->forumId)) {
            $errors[] = 'forumId is required';
        }
        
        // subscribeMode: 0 = no email (alerts only), 1 = instant email, 2 = daily digest, 3 = weekly digest
        // All values are valid, but 2 and 3 may not be fully supported by all forums
        if (!is_numeric($this->subscribeMode) || $this->subscribeMode < 0 || $this->subscribeMode > 3) {
            $errors[] = 'subscribeMode must be between 0 and 3';
        }

        if ($this->notifyOn !== null && !in_array($this->notifyOn, ['thread', 'message', ''], true)) {
            $errors[] = 'notifyOn must be "thread", "message" or ""';
        }
        
        return $errors;
    }

    /**
     * Whether the caller sent any of the watch options (notifyOn, sendAlert,
     * sendEmail). A 1.x app sends only subscribeMode.
     */
    public function hasWatchOptions(): bool
    {
        return $this->notifyOn !== null || $this->sendAlert !== null || $this->sendEmail !== null;
    }

    /**
     * true/false/1/0/"true"/"false"/"1"/"0" to a bool; anything else (not
     * sent) to null.
     */
    public static function toOptionalBool($value): ?bool
    {
        if (is_bool($value)) {
            return $value;
        }
        if (is_int($value) || (is_string($value) && $value !== '')) {
            $value = strtolower((string)$value);
            if (in_array($value, ['1', 'true', 'yes', 'on'], true)) {
                return true;
            }
            if (in_array($value, ['0', 'false', 'no', 'off'], true)) {
                return false;
            }
        }
        return null;
    }
}

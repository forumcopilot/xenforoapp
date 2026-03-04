<?php

namespace ForumCopilot\Params\Topic;

/**
 * Parameters for getParticipatedTopic API method
 * Topics the user participated in (created or replied)
 */
class FCGetParticipatedTopicParams
{
    /** @var string Target user ID (optional; default: current user) */
    public $userId;

    /** @var string Target username (optional; used if userId not provided) */
    public $username;

    /** @var int Starting position for pagination */
    public $startNum;

    /** @var int Ending position for pagination */
    public $lastNum;

    /** @var string Optional search session ID (reserved) */
    public $searchId;

    public function __construct($userId = '', $username = '', $startNum = 0, $lastNum = 19, $searchId = '')
    {
        $this->userId = $userId;
        $this->username = $username;
        $this->startNum = $startNum;
        $this->lastNum = $lastNum;
        $this->searchId = $searchId;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        return new self(
            $data['userId'] ?? '',
            $data['username'] ?? '',
            $data['startNum'] ?? 0,
            $data['lastNum'] ?? 19,
            $data['searchId'] ?? ''
        );
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];

        if (!is_numeric($this->startNum) || $this->startNum < 0) {
            $errors[] = 'startNum must be non-negative integer';
        }

        if (!is_numeric($this->lastNum) || $this->lastNum < $this->startNum) {
            $errors[] = 'lastNum must be integer >= startNum';
        }

        return $errors;
    }
}

<?php

namespace ForumCopilot\Params\Topic;

/**
 * Parameters for getLatestTopic API method
 * Forum-agnostic parameter class for getting latest topics across the forum
 */
class FCGetLatestTopicParams
{
    /** @var int Starting position for pagination */
    public $startNum;

    /** @var int Ending position for pagination */
    public $lastNum;

    /** @var string Optional search session ID (reserved) */
    public $searchId;

    /** @var array Filter options: unread, watched, participated, started, unanswered */
    public $filters;

    /** @var bool Also threads awaiting approval the visitor may see, as What's New shows them (1.11.0) */
    public $includeModerated = false;

    public function __construct($startNum = 0, $lastNum = 19, $searchId = '', $filters = [])
    {
        $this->startNum = $startNum;
        $this->lastNum = $lastNum;
        $this->searchId = $searchId;
        $this->filters = is_array($filters) ? $filters : [];
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        $params = new self(
            $data['startNum'] ?? 0,
            $data['lastNum'] ?? 19,
            $data['searchId'] ?? '',
            $data['filters'] ?? []
        );
        $includeModerated = $data['includeModerated'] ?? false;
        $params->includeModerated = $includeModerated === true || $includeModerated === 1
            || $includeModerated === '1' || $includeModerated === 'true';
        return $params;
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

        if (!is_array($this->filters)) {
            $errors[] = 'filters must be array';
        }

        return $errors;
    }
}

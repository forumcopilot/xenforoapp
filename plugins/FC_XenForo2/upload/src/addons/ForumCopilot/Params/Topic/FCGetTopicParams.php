<?php

namespace ForumCopilot\Params\Topic;

/**
 * Parameters for getTopic API method
 * Forum-agnostic parameter class for topic retrieval operations
 *
 * The sort and filter params (1.11.0) are those of XenForo's forum page
 * filters; all optional. Without order the list stays sorted by last
 * message, newest first, as before 1.11.0.
 */
class FCGetTopicParams
{
    /** @var string Forum ID to get topics from */
    public $forumId;
    
    /** @var int Starting position for pagination */
    public $startNum;
    
    /** @var int Ending position for pagination */
    public $lastNum;

    /** @var string|null last_post_date, post_date, title, reply_count, view_count,
     *  first_post_reaction_score, vote_score (suggestion forums), or "forum" for the forum's default order */
    public $order;

    /** @var string|null asc or desc (anything else: desc, as XenForo does) */
    public $direction;

    /** @var int Only threads with this prefix */
    public $prefixId = 0;

    /** @var int Only threads started by this member */
    public $starterId = 0;

    /** @var string Only threads started by this member (by name, when starterId is not sent) */
    public $starterName = '';

    /** @var bool Only threads unread by the member (ignored for guests) */
    public $unread = false;

    /** @var int|null Threads with a message in the last N days: 7, 14, 30, 60, 90, 182, 365, or -1 for any time */
    public $lastDays;

    /** @var bool Lift the forum's own date limit */
    public $noDateLimit = false;

    /** @var string Only threads of this type (discussion, question, poll, article, suggestion...) */
    public $threadType = '';

    /** @var array The forum type's own filters with XenForo's names: questions take unsolved,
     *  unanswered, your_questions, your_answers; suggestions your_suggestions, your_votes, suggestion_state */
    public $typeFilters = [];

    public function __construct($forumId = '', $startNum = 0, $lastNum = 19)
    {
        $this->forumId = $forumId;
        $this->startNum = $startNum;
        $this->lastNum = $lastNum;
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        $params = new static(
            $data['forumId'] ?? '',
            $data['startNum'] ?? 0,
            $data['lastNum'] ?? 19
        );

        $params->order = isset($data['order']) && is_string($data['order']) && $data['order'] !== '' ? $data['order'] : null;
        $params->direction = isset($data['direction']) && is_string($data['direction']) ? strtolower($data['direction']) : null;
        $params->prefixId = is_numeric($data['prefixId'] ?? null) ? (int)$data['prefixId'] : 0;
        $params->starterId = is_numeric($data['starterId'] ?? null) ? (int)$data['starterId'] : 0;
        $params->starterName = is_string($data['starterName'] ?? null) ? trim($data['starterName']) : '';
        $params->unread = self::toBool($data['unread'] ?? false);
        $params->lastDays = is_numeric($data['lastDays'] ?? null) ? (int)$data['lastDays'] : null;
        $params->noDateLimit = self::toBool($data['noDateLimit'] ?? false);
        $params->threadType = is_string($data['threadType'] ?? null) ? $data['threadType'] : '';
        $params->typeFilters = is_array($data['typeFilters'] ?? null) ? $data['typeFilters'] : [];

        return $params;
    }

    protected static function toBool($value): bool
    {
        if (is_string($value)) {
            return in_array(strtolower($value), ['1', 'true', 'yes', 'on'], true);
        }
        return (bool)$value;
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];
        
        if (!is_scalar($this->forumId) || (string)$this->forumId === '' || (string)$this->forumId === '0') {
            $errors[] = 'forumId is required';
        }
        
        if (!is_numeric($this->startNum) || $this->startNum < 0) {
            $errors[] = 'startNum must be non-negative integer';
        }
        
        if (!is_numeric($this->lastNum) || $this->lastNum < $this->startNum) {
            $errors[] = 'lastNum must be integer >= startNum';
        }
        
        return $errors;
    }
}

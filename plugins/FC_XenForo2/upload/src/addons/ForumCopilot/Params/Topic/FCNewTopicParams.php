<?php

namespace ForumCopilot\Params\Topic;

/**
 * Parameters for newTopic API method
 * Forum-agnostic parameter class for creating new topics
 */
class FCNewTopicParams
{
    /** @var string Forum ID where topic will be created */
    public $forumId;

    /** @var string Topic title */
    public $title;

    /** @var string Topic content/body */
    public $textBody;

    /** @var string Optional thread prefix ID (API: prefixId) */
    public $prefixId;

    /** @var array List of attachment IDs (ignored: see TopicController::actionNewTopic) */
    public $attachmentIds;

    /** @var string|null Group ID / attachment temp hash (API: groupId) */
    public $groupId;

    /** @var bool Whether topic is a poll (same as threadType "poll") */
    public $isPoll;

    /** @var string|null Poll question */
    public $pollQuestion;

    /** @var array Poll options */
    public $pollOptions;

    /** @var array|string|null Tags: a list of names or one comma-separated string (1.11.0) */
    public $tags;

    /** @var array|null Custom thread fields, field_id => value (1.11.0) */
    public $customFields;

    /** @var string Thread type (discussion, question, poll, article, suggestion...); empty = the forum's default (1.11.0) */
    public $threadType;

    /** @var int|null Poll: most choices a voter may pick, 0 = unlimited; default 1 (1.11.0) */
    public $pollMaxVotes;

    /** @var bool|null Poll: voters may change their vote (1.11.0) */
    public $pollChangeVote;

    /** @var bool|null Poll: votes are shown publicly (1.11.0) */
    public $pollPublicVotes;

    /** @var bool|null Poll: results can be viewed without voting; default true (1.11.0) */
    public $pollViewResultsUnvoted;

    /** @var int|null Poll: close after this many days, 0 = never (1.11.0) */
    public $pollCloseDays;

    public function __construct($forumId = '', $title = '', $textBody = '', $prefixId = '', $attachmentIds = [], $groupId = null, $isPoll = false, $pollQuestion = null, $pollOptions = [])
    {
        $this->forumId = $forumId;
        $this->title = $title;
        $this->textBody = $textBody;
        $this->prefixId = $prefixId;
        $this->attachmentIds = is_array($attachmentIds) ? $attachmentIds : [];
        $this->groupId = $groupId;
        $this->isPoll = $isPoll;
        $this->pollQuestion = $pollQuestion;
        $this->pollOptions = is_array($pollOptions) ? $pollOptions : [];
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        $params = new self(
            $data['forumId'] ?? '',
            $data['title'] ?? '',
            $data['textBody'] ?? '',
            $data['prefixId'] ?? '',
            $data['attachmentIds'] ?? [],
            $data['groupId'] ?? null,
            self::toBool($data['isPoll'] ?? false),
            $data['pollQuestion'] ?? null,
            $data['pollOptions'] ?? []
        );
        $params->tags = $data['tags'] ?? null;
        $params->customFields = $data['customFields'] ?? null;
        $params->threadType = $data['threadType'] ?? '';
        $params->pollMaxVotes = $data['pollMaxVotes'] ?? null;
        $params->pollChangeVote = isset($data['pollChangeVote']) ? self::toBool($data['pollChangeVote']) : null;
        $params->pollPublicVotes = isset($data['pollPublicVotes']) ? self::toBool($data['pollPublicVotes']) : null;
        $params->pollViewResultsUnvoted = isset($data['pollViewResultsUnvoted']) ? self::toBool($data['pollViewResultsUnvoted']) : null;
        $params->pollCloseDays = $data['pollCloseDays'] ?? null;
        return $params;
    }

    /**
     * Validate parameters. An empty title or message is left to XenForo,
     * which names the field ("Please enter a valid title.").
     */
    public function validate(): array
    {
        $errors = [];

        if (!is_scalar($this->forumId) || (string)$this->forumId === '') {
            $errors[] = 'forumId is required';
        }

        if (!is_scalar($this->title)) {
            $errors[] = 'title must be string';
        }

        if (!is_scalar($this->textBody)) {
            $errors[] = 'textBody must be string';
        }

        if ($this->prefixId !== '' && $this->prefixId !== null && !is_scalar($this->prefixId)) {
            $errors[] = 'prefixId must be string';
        }

        if (!is_array($this->attachmentIds)) {
            $errors[] = 'attachmentIds must be array';
        }

        if ($this->groupId !== null && !is_string($this->groupId)) {
            $errors[] = 'groupId must be string or null';
        }

        if (!is_bool($this->isPoll) && $this->isPoll !== null) {
            $errors[] = 'isPoll must be boolean';
        }

        if (!is_array($this->pollOptions)) {
            $errors[] = 'pollOptions must be array';
        }

        if ($this->tags !== null && !is_array($this->tags) && !is_string($this->tags)) {
            $errors[] = 'tags must be array or string';
        }

        if ($this->customFields !== null && !is_array($this->customFields)) {
            $errors[] = 'customFields must be an object (field id => value)';
        }

        if (!is_string($this->threadType)) {
            $errors[] = 'threadType must be string';
        }

        foreach (['pollMaxVotes', 'pollCloseDays'] as $key) {
            if ($this->$key !== null && (!is_numeric($this->$key) || $this->$key < 0)) {
                $errors[] = $key . ' must be a non-negative integer';
            }
        }

        return $errors;
    }

    /**
     * Whether the caller asked for a poll, by isPoll or threadType.
     */
    public function wantsPoll(): bool
    {
        return $this->isPoll === true || $this->threadType === 'poll';
    }

    /**
     * The thread type to create: "poll" when isPoll is set, otherwise
     * threadType (empty = the forum's default type).
     */
    public function getThreadType(): string
    {
        return $this->wantsPoll() ? 'poll' : (string)$this->threadType;
    }

    /**
     * Tags as a list of names.
     */
    public function getTags(): array
    {
        if (is_string($this->tags)) {
            return array_values(array_filter(array_map('trim', explode(',', $this->tags)), 'strlen'));
        }
        if (!is_array($this->tags)) {
            return [];
        }
        $tags = [];
        foreach ($this->tags as $tag) {
            if (is_scalar($tag) && trim((string)$tag) !== '') {
                $tags[] = trim((string)$tag);
            }
        }
        return $tags;
    }

    /**
     * The poll as XenForo's poll form sends it (poll[...]: question,
     * new_responses, max_votes_type/value, close/close_length/close_units,
     * change_vote, public_votes, view_results_unvoted), for the poll thread
     * type's handler (XF\Helper\Poll::getPollInput).
     */
    public function getPollFormInput(): array
    {
        $maxVotes = $this->pollMaxVotes === null ? 1 : (int)$this->pollMaxVotes;
        $closeDays = (int)($this->pollCloseDays ?? 0);

        $responses = [];
        foreach ($this->pollOptions as $option) {
            if (is_array($option)) {
                // {text: "..."} or {response: "..."}
                $option = $option['text'] ?? $option['response'] ?? '';
            }
            if (is_scalar($option)) {
                $responses[] = (string)$option;
            }
        }

        return [
            'question' => (string)$this->pollQuestion,
            'new_responses' => $responses,
            'max_votes_type' => $maxVotes === 0 ? 'unlimited' : ($maxVotes === 1 ? 'single' : 'number'),
            'max_votes_value' => max(0, $maxVotes),
            'close' => $closeDays > 0 ? 1 : 0,
            'close_length' => $closeDays,
            'close_units' => 'days',
            'change_vote' => $this->pollChangeVote ? 1 : 0,
            'public_votes' => $this->pollPublicVotes ? 1 : 0,
            'view_results_unvoted' => ($this->pollViewResultsUnvoted ?? true) ? 1 : 0,
        ];
    }

    /**
     * A flag as JSON true/false, 1/0 or the strings "true"/"false"/"1"/"0";
     * anything else is left for validate() to refuse.
     */
    protected static function toBool($value)
    {
        if (is_bool($value)) {
            return $value;
        }
        if (is_int($value) || (is_string($value) && $value !== '')) {
            $bool = filter_var($value, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
            return $bool ?? $value;
        }
        return $value;
    }
}

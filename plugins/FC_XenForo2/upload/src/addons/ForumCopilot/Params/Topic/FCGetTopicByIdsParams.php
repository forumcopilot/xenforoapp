<?php

namespace ForumCopilot\Params\Topic;

/**
 * Parameters for getTopicByIds API method
 * Fetch topics by thread/topic IDs
 */
class FCGetTopicByIdsParams
{
    /** @var array Topic/thread IDs (string or int) */
    public $topicIds;

    public function __construct(array $topicIds = [])
    {
        $this->topicIds = is_array($topicIds) ? $topicIds : [];
    }

    /**
     * Create from array data
     */
    public static function fromArray(array $data): self
    {
        $topicIds = $data['topicIds'] ?? [];
        return new self(is_array($topicIds) ? $topicIds : []);
    }

    /**
     * Validate parameters
     */
    public function validate(): array
    {
        $errors = [];

        if (empty($this->topicIds)) {
            $errors[] = 'topicIds is required and must be a non-empty array';
        }

        if (!is_array($this->topicIds)) {
            $errors[] = 'topicIds must be an array';
        }

        return $errors;
    }

    /**
     * Return list of thread IDs as positive integers (deduplicated, invalid filtered out)
     */
    public function getThreadIds(): array
    {
        $ids = [];
        foreach ($this->topicIds as $id) {
            $id = is_scalar($id) ? (int)$id : 0;
            if ($id > 0) {
                $ids[$id] = true;
            }
        }
        return array_keys($ids);
    }
}

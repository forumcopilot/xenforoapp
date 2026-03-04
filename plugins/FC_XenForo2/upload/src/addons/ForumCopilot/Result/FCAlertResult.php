<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Alert Result
 * Maps from AlertData_Output
 */
class FCAlertResult extends FCResult
{
    public $total;
    public $items;

    public function __construct($result = true, $resultText = 'success', $total = 0, $items = [])
    {
        parent::__construct($result, $resultText);
        $this->total = $total;
        $this->items = $items;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['total'] = $this->total;
        $data['items'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->items);
        return $data;
    }
}


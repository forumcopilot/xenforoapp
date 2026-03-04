<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Base Result Class
 * Forum-agnostic base result that can be reused across different forum plugins
 * 
 * IMPORTANT: resultText is ONLY included in the response when result = false (error cases).
 * When result = true (success), resultText must NOT be present in the response.
 */
class FCResult
{
    public $result;
    public $resultText;

    public function __construct($result = true, $resultText = 'success')
    {
        $this->result = $result;
        $this->resultText = $resultText;
    }

    /**
     * Convert result to array for JSON response
     * 
     * IMPORTANT: resultText is ONLY included when result = false.
     * When result = true, resultText is NOT included in the response.
     * 
     * @return array
     */
    public function toArray()
    {
        $data = [
            'result' => $this->result,
        ];
        
        // Only include resultText when result is false (error cases)
        // When result = true, resultText must NOT be present
        if (!$this->result) {
            $data['resultText'] = $this->resultText;
        }
        
        return $data;
    }

    public static function success($resultText = 'success')
    {
        return new self(true, $resultText);
    }

    public static function error($resultText = 'error')
    {
        return new self(false, $resultText);
    }
}

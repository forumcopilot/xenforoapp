<?php

namespace ForumCopilot\Admin\View\Option;

use XF\Mvc\View;

class Index extends View
{
    public function renderHtml()
    {
        $this->params['form'] = $this->app->form('ForumCopilot:Option');
    }
}
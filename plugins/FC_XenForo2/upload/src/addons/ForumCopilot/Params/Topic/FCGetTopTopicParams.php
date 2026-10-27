<?php

namespace ForumCopilot\Params\Topic;

/**
 * Parameters for getTopTopic API method
 * Forum-agnostic parameter class for getting pinned/sticky topics
 *
 * Same params as getTopic: XenForo filters a forum's sticky threads with
 * the forum page's filters too.
 */
class FCGetTopTopicParams extends FCGetTopicParams
{
}

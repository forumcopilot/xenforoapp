<?php

namespace ForumCopilot\Service\Activity;

/**
 * Stand-in "controller" used by the mobile API dispatcher to mark a visitor's
 * current session activity. The activity row is written by the webroot
 * forumcopilot.php entry point on each authenticated API request; this class
 * supplies the human-readable description that XF renders in the "Members
 * Online" / "Currently viewing this thread" lists.
 *
 * The class does not extend any controller — it just exists so
 * SessionActivityRepository::getActivityList() finds a callable
 * `getActivityDetails` for our recorded controller_name.
 *
 * Both the label text and an optional click-through URL are admin-configurable
 * via Admin CP → Options → ForumCopilot Options:
 *   - fc_mobile_activity_label  (string, default "Using Forum Copilot Mobile App")
 *   - fc_mobile_activity_url    (string, default "https://forumcopilot.com/getapps")
 * Either can be set to empty: an empty label hides the activity description
 * entirely; an empty URL renders the label as plain text instead of a link.
 */
class MobileSessionActivity
{
    /**
     * Called by SessionActivityRepository::getActivityList() to render activity
     * descriptions for our recorded session rows.
     *
     * Returns one entry per activity. Each entry is either:
     *   - a plain string (just description), or
     *   - an array {description, title, url} when the admin configured a URL,
     *     which XF renders as a clickable link via SessionActivity::setItemDetails.
     *
     * @param array $activities array keyed by session id; each entry is a
     *                          \XF\Entity\SessionActivity
     * @return array same keys
     */
    public static function getActivityDetails(array $activities)
    {
        $options = \XF::options();
        $label = trim((string)($options->fc_mobile_activity_label ?? 'Using Forum Copilot Mobile App'));
        $url = trim((string)($options->fc_mobile_activity_url ?? 'https://forumcopilot.com/getapps'));

        if ($label === '')
        {
            // Admin explicitly cleared the label — render nothing.
            return [];
        }

        $entry = ($url !== '')
            ? ['description' => $label, 'title' => $label, 'url' => $url]
            : $label;

        $output = [];
        foreach ($activities as $key => $activity)
        {
            $output[$key] = $entry;
        }
        return $output;
    }
}

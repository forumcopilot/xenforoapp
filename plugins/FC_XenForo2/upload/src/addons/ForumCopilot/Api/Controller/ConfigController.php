<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCConfigResult;

/**
 * Config Controller for ForumCopilot API
 * Handles Config-related operations
 */
class ConfigController extends AbstractController
{
    public function actionGetConfig(ParameterBag $params)
    {
        $options = $this->app()->options();
        $visitor = \XF::visitor();
        
        // Check if forum is open (not in maintenance mode)
        // Explicitly cast to boolean to ensure true/false, not 0/1
        $isOpen = (bool)$options->boardActive;
        
        // Check if guests can access the forum (check if there are any viewable nodes for guests)
        $guestOkay = true; // Default to true
        if (!$visitor->user_id) {
            // For guests, check if they can view any nodes
            $nodeRepo = $this->repository('XF:Node');
            $nodes = $nodeRepo->getNodeList();
            $guestOkay = false;
            foreach ($nodes as $node) {
                if ($node->canView()) {
                    $guestOkay = true;
                    break;
                }
            }
        }
        // Explicitly cast to boolean
        $guestOkay = (bool)$guestOkay;
        
        // Check if guests can search
        $guestSearch = false;
        // Check guest search permission by checking if guest user (user_id = 0) has search permission
        $guestUser = $this->em()->find('XF:User', 0);
        if ($guestUser) {
            $guestSearch = $guestUser->canSearch();
        }
        // Explicitly cast to boolean
        $guestSearch = (bool)$guestSearch;
        
        // Check if guests can view who's online
        $guestWhosOnline = false;
        if ($guestUser) {
            $guestWhosOnline = $guestUser->canViewMemberList();
        }
        // Explicitly cast to boolean
        $guestWhosOnline = (bool)$guestWhosOnline;
        
        $addOn = \XF::app()->addOnManager()->getById('ForumCopilot');
        $addOnVersion = $addOn ? $addOn->version_string : 'unknown';

        $config = [
            'version' => $addOnVersion,
            'systemVersion' => \XF::$version,
            'phpVersion' => phpversion(),
            'hookVersion' => '1.0',
            'apiLevel' => '4',
            'releaseTimestamp' => (string)(time() * 1000),
            'pushSlug' => 'xenforo',
            'smartBannerInfo' => '',
            'isOpen' => $isOpen,
            'guestOkay' => $guestOkay,
            'modApprove' => false,
            'modDelete' => false,
            'modReport' => false,
            'guestSearch' => $guestSearch,
            'guestWhosOnline' => $guestWhosOnline,
            'subscribeTopicMode' => 'email',
            'subscribeForumMode' => 'email',
            'multiQuote' => false,
            'announcement' => false,
            'passwordType' => 'bcrypt',
            'conversation' => true,
            'getTopicStatus' => false,
            'getParticipatedForum' => false,
            'updateProfile' => true,
            'userId' => '',
            'alert' => true,
            'searchUser' => true,
            'ignoreUser' => false,
            'advancedMerge' => false,
            'advancedMove' => false,
            'pushType' => 'fcm',
            'push' => 'enabled',
            'contentEncoding' => 'gzip',
            'contentType' => 'application/json',
            'loginWithEmail' => false,
            'apiKey' => '', // Will be set by client
            'forumType' => 'xenforo',
        ];

        // Create FCConfigResult object and return it
        $configResult = new FCConfigResult($config);
        return $this->apiSuccess($configResult->toArray());
    }
}

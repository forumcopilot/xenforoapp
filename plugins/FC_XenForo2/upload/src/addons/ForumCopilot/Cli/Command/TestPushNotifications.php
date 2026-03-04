<?php

namespace ForumCopilot\Cli\Command;

use XF\Cli\Command\AbstractCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use XF;
use XF\Entity\Forum;
use XF\Entity\Post;
use XF\Entity\Thread;
use XF\Entity\User;
use XF\Service\User\FollowService;

class TestPushNotifications extends AbstractCommand
{
    protected function configure()
    {
        $this
            ->setName('fc:test-push')
            ->setDescription('Test ForumCopilot push notifications')
            ->addOption('type', 't', InputOption::VALUE_REQUIRED, 'Notification type to test (all, newtopic, reply, mention, quote, like, conversation, follow)', 'all')
            ->addOption('sender', 's', InputOption::VALUE_REQUIRED, 'Sender username (default: BarbaraThompson203)', 'BarbaraThompson203')
            ->addOption('receiver', 'r', InputOption::VALUE_REQUIRED, 'Receiver username (default: admin)', 'admin')
            ->addOption('forum-id', 'f', InputOption::VALUE_REQUIRED, 'Forum ID to use (optional)', null);
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $app = XF::app();
        $type = $input->getOption('type');
        $senderUsername = $input->getOption('sender');
        $receiverUsername = $input->getOption('receiver');
        $forumId = $input->getOption('forum-id');

        // Get users
        $sender = $this->getUser($senderUsername, $output);
        if (!$sender) {
            $output->writeln("<error>Sender user '{$senderUsername}' not found.</error>");
            return 1;
        }

        $receiver = $this->getUser($receiverUsername, $output);
        if (!$receiver) {
            $output->writeln("<error>Receiver user '{$receiverUsername}' not found.</error>");
            return 1;
        }

        // Ensure receiver has app installed (for testing)
        $this->ensureAppInstalled($receiver, $output);

        // Get forum
        $forum = $this->getForum($forumId, $output);
        if (!$forum) {
            return 1;
        }

        $output->writeln("<info>=== ForumCopilot Push Notification Test ===</info>");
        $output->writeln("");
        $output->writeln("Sender: <comment>{$sender->username}</comment> (ID: {$sender->user_id})");
        $output->writeln("Receiver: <comment>{$receiver->username}</comment> (ID: {$receiver->user_id})");
        $output->writeln("Forum: <comment>{$forum->title}</comment> (ID: {$forum->node_id})");
        $output->writeln("Test Type: <comment>{$type}</comment>");
        $output->writeln("");

        // Set sender as visitor
        \XF::setVisitor($sender);

        $results = [];

        if ($type === 'all' || $type === 'newtopic') {
            $results['newtopic'] = $this->testNewTopic($forum, $sender, $receiver, $output);
            $output->writeln("");
        }

        if ($type === 'all' || $type === 'reply') {
            $results['reply'] = $this->testReply($forum, $sender, $receiver, $output);
            $output->writeln("");
        }

        if ($type === 'all' || $type === 'mention') {
            $results['mention'] = $this->testMention($forum, $sender, $receiver, $output);
            $output->writeln("");
        }

        if ($type === 'all' || $type === 'quote') {
            $results['quote'] = $this->testQuote($forum, $sender, $receiver, $output);
            $output->writeln("");
        }

        if ($type === 'all' || $type === 'like') {
            $results['like'] = $this->testLike($forum, $sender, $receiver, $output);
            $output->writeln("");
        }

        if ($type === 'all' || $type === 'conversation') {
            $results['conversation'] = $this->testConversation($sender, $receiver, $output);
            $output->writeln("");
        }

        if ($type === 'all' || $type === 'follow') {
            $results['follow'] = $this->testFollow($sender, $receiver, $output);
            $output->writeln("");
        }

        // Summary
        $output->writeln("<info>=== Test Summary ===</info>");
        foreach ($results as $testType => $result) {
            $status = $result ? '<fg=green>PASS</>' : '<fg=red>FAIL</>';
            $output->writeln("  {$testType}: {$status}");
        }

        $output->writeln("");
        
        // In CLI context, app_pub_complete event doesn't fire, so we need to manually trigger the listener
        $output->writeln("<info>Processing collected alerts (CLI context)...</info>");
        $this->processCollectedAlerts($output);
        
        $output->writeln("");
        $output->writeln("<info>Check error logs for push notification JSON requests:</info>");
        $output->writeln("  upload/internal_data/logs/error_log_" . date('Y-m-d') . ".php");
        $output->writeln("  Or run: php cmd.php fc:view-push-logs");
        $output->writeln("");
        $output->writeln("<info>Note: In web requests, push notifications are processed automatically via background jobs.</info>");
        $output->writeln("<info>      In CLI context, alerts are processed immediately after creation.</info>");

        return 0;
    }

    protected function getUser($username, OutputInterface $output)
    {
        $user = XF::app()->finder('XF:User')
            ->where('username', $username)
            ->fetchOne();

        if (!$user) {
            return null;
        }

        return $user;
    }

    protected function ensureAppInstalled(User $user, OutputInterface $output)
    {
        $db = XF::app()->db();
        $exists = $db->fetchOne(
            'SELECT user_id FROM xf_fc_user WHERE user_id = ?',
            [$user->user_id]
        );

        if (!$exists) {
            $output->writeln("<comment>Adding user to xf_fc_user table for testing...</comment>");
            $db->insert('xf_fc_user', [
                'user_id' => $user->user_id,
                'last_seen' => time()
            ]);
        } else {
            // Update last_seen to ensure it's recent
            $db->update('xf_fc_user', [
                'last_seen' => time()
            ], 'user_id = ?', [$user->user_id]);
        }
    }

    protected function getForum($forumId, OutputInterface $output)
    {
        if ($forumId) {
            $forum = XF::app()->em()->find('XF:Forum', $forumId);
            if (!$forum) {
                $output->writeln("<error>Forum ID {$forumId} not found.</error>");
                return null;
            }
            return $forum;
        }

        // Get first available forum through Node relationship
        $forum = XF::app()->finder('XF:Forum')
            ->with('Node')
            ->where('Node.node_type_id', 'Forum')
            ->order('Node.node_id')
            ->fetchOne();

        if (!$forum) {
            $output->writeln("<error>No forums found. Please create a forum first.</error>");
            return null;
        }

        return $forum;
    }

    /**
     * Find or create a watched forum for the receiver
     */
    protected function findOrCreateWatchedForum(User $receiver, OutputInterface $output)
    {
        // First, try to find an existing watched forum
        $forumWatch = XF::app()->finder('XF:ForumWatch')
            ->where('user_id', $receiver->user_id)
            ->order('node_id', 'DESC')
            ->fetchOne();

        if ($forumWatch) {
            $forum = XF::app()->em()->find('XF:Forum', $forumWatch->node_id);
            if ($forum) {
                $output->writeln("  ✓ Found existing watched forum: {$forum->title} (ID: {$forum->node_id})");
                return $forum;
            }
        }

        // If no watched forum found, get any forum and set up watch
        $forum = $this->getForum(null, $output);
        if (!$forum) {
            return null;
        }

        // Set up forum watch
        $forumWatch = XF::app()->em()->create('XF:ForumWatch');
        $forumWatch->user_id = $receiver->user_id;
        $forumWatch->node_id = $forum->node_id;
        $forumWatch->notify_on = 'thread';
        $forumWatch->send_alert = 1;
        $forumWatch->save();
        $output->writeln("  ✓ Set up forum watch for receiver: {$forum->title} (ID: {$forum->node_id})");

        return $forum;
    }

    /**
     * Find or create a watched thread for the receiver
     */
    protected function findOrCreateWatchedThread(User $receiver, Forum $forum, OutputInterface $output)
    {
        // First, try to find an existing watched thread
        $threadWatch = XF::app()->finder('XF:ThreadWatch')
            ->where('user_id', $receiver->user_id)
            ->order('thread_id', 'DESC')
            ->fetchOne();

        if ($threadWatch) {
            $thread = XF::app()->em()->find('XF:Thread', $threadWatch->thread_id);
            if ($thread && $thread->node_id == $forum->node_id) {
                $output->writeln("  ✓ Found existing watched thread: {$thread->title} (ID: {$thread->thread_id})");
                return $thread;
            }
        }

        // If no watched thread found, create one as the receiver
        \XF::setVisitor($receiver);
        $creator = XF::app()->service('XF:Thread\Creator', $forum);
        $creator->setContent(
            'Test Thread Watched by ' . $receiver->username . ' ' . date('H:i:s'),
            'This thread is watched by ' . $receiver->username . ' for testing push notifications.'
        );
        $thread = $creator->save();

        // Set up thread watch
        $threadWatch = XF::app()->em()->create('XF:ThreadWatch');
        $threadWatch->user_id = $receiver->user_id;
        $threadWatch->thread_id = $thread->thread_id;
        $threadWatch->email_subscribe = false;
        $threadWatch->save();
        $output->writeln("  ✓ Created and set up thread watch: {$thread->title} (ID: {$thread->thread_id})");

        return $thread;
    }

    /**
     * Find a post by the receiver (admin) to like
     */
    protected function findPostByUser(User $user, Forum $forum, OutputInterface $output)
    {
        // Try to find a recent post by the user in the forum
        $post = XF::app()->finder('XF:Post')
            ->where('user_id', $user->user_id)
            ->where('message_state', 'visible')
            ->with('Thread', function($thread) use ($forum) {
                $thread->where('node_id', $forum->node_id);
            })
            ->order('post_date', 'DESC')
            ->fetchOne();

        if ($post) {
            $output->writeln("  ✓ Found existing post by {$user->username} (Post ID: {$post->post_id})");
            return $post;
        }

        // If no post found, create one as the user
        \XF::setVisitor($user);
        $creator = XF::app()->service('XF:Thread\Creator', $forum);
        $creator->setContent(
            'Test Thread by ' . $user->username . ' ' . date('H:i:s'),
            'This is a post by ' . $user->username . ' that will be liked for testing push notifications.'
        );
        $thread = $creator->save();
        $post = $thread->FirstPost;
        $output->writeln("  ✓ Created new post by {$user->username} (Post ID: {$post->post_id})");

        return $post;
    }

    protected function testNewTopic(Forum $forum, User $sender, User $receiver, OutputInterface $output)
    {
        $output->writeln("<info>Testing: New Topic (forumwatch_insert)</info>");

        try {
            // Find or create a watched forum for the receiver
            $watchedForum = $this->findOrCreateWatchedForum($receiver, $output);
            if (!$watchedForum) {
                $output->writeln("  <fg=red>✗</> Error: Could not find or create watched forum");
                return false;
            }

            // Create thread in the watched forum
            \XF::setVisitor($sender);
            $creator = XF::app()->service('XF:Thread\Creator', $watchedForum);
            $creator->setContent(
                'Test Push Notification - New Topic ' . date('H:i:s'),
                'This is a test thread to trigger a new topic push notification for ' . $receiver->username . '.'
            );
            $thread = $creator->save();
            $creator->sendNotifications();

            $output->writeln("  <fg=green>✓</> Created thread: {$thread->title} (ID: {$thread->thread_id})");
            return true;
        } catch (\Exception $e) {
            $output->writeln("  <fg=red>✗</> Error: " . $e->getMessage());
            return false;
        }
    }

    protected function testReply(Forum $forum, User $sender, User $receiver, OutputInterface $output)
    {
        $output->writeln("<info>Testing: Reply to Thread (threadwatch_insert)</info>");

        try {
            // Find or create a watched thread for the receiver
            $watchedThread = $this->findOrCreateWatchedThread($receiver, $forum, $output);
            if (!$watchedThread) {
                $output->writeln("  <fg=red>✗</> Error: Could not find or create watched thread");
                return false;
            }

            // Switch back to sender and reply
            \XF::setVisitor($sender);
            $replier = XF::app()->service('XF:Thread\Replier', $watchedThread);
            $replier->setMessage('This is a test reply to trigger a push notification for ' . $receiver->username . '.');
            $post = $replier->save();
            $replier->sendNotifications();

            $output->writeln("  <fg=green>✓</> Created reply in thread: {$watchedThread->title} (Post ID: {$post->post_id})");
            return true;
        } catch (\Exception $e) {
            $output->writeln("  <fg=red>✗</> Error: " . $e->getMessage());
            \XF::setVisitor($sender);
            return false;
        }
    }

    protected function testMention(Forum $forum, User $sender, User $receiver, OutputInterface $output)
    {
        $output->writeln("<info>Testing: Mention (@username)</info>");

        try {
            // Create a thread first
            $creator = XF::app()->service('XF:Thread\Creator', $forum);
            $creator->setContent(
                'Test Thread for Mention ' . date('H:i:s'),
                'This thread will be used for mention testing.'
            );
            $thread = $creator->save();

            // Reply with mention
            $replier = XF::app()->service('XF:Thread\Replier', $thread);
            $replier->setMessage("Hey @{$receiver->username}, this is a test mention!");
            $post = $replier->save();
            $replier->sendNotifications();

            $output->writeln("  <fg=green>✓</> Created post with mention (Post ID: {$post->post_id})");
            return true;
        } catch (\Exception $e) {
            $output->writeln("  <fg=red>✗</> Error: " . $e->getMessage());
            return false;
        }
    }

    protected function testQuote(Forum $forum, User $sender, User $receiver, OutputInterface $output)
    {
        $output->writeln("<info>Testing: Quote</info>");

        try {
            // Create a thread first (as receiver)
            \XF::setVisitor($receiver);
            $creator = XF::app()->service('XF:Thread\Creator', $forum);
            $creator->setContent(
                'Test Thread for Quote ' . date('H:i:s'),
                'This is the original post that will be quoted.'
            );
            $thread = $creator->save();
            $originalPost = $thread->FirstPost;

            // Switch back to sender and reply with quote
            \XF::setVisitor($sender);
            $replier = XF::app()->service('XF:Thread\Replier', $thread);
            $quoteText = '[quote="' . $receiver->username . ', post:' . $originalPost->post_id . '"]' . 
                        $originalPost->message . '[/quote]' . 
                        "\n\nThis is a reply with a quote.";
            $replier->setMessage($quoteText);
            $post = $replier->save();
            $replier->sendNotifications();

            $output->writeln("  <fg=green>✓</> Created post with quote (Post ID: {$post->post_id})");
            return true;
        } catch (\Exception $e) {
            $output->writeln("  <fg=red>✗</> Error: " . $e->getMessage());
            \XF::setVisitor($sender);
            return false;
        }
    }

    protected function testLike(Forum $forum, User $sender, User $receiver, OutputInterface $output)
    {
        $output->writeln("<info>Testing: Like/Reaction</info>");

        try {
            // Find or create a post by the receiver (admin) to like
            $post = $this->findPostByUser($receiver, $forum, $output);
            if (!$post) {
                $output->writeln("  <fg=red>✗</> Error: Could not find or create post by receiver");
                \XF::setVisitor($sender);
                return false;
            }

            // Clear entity cache to ensure clean state
            XF::app()->em()->clearEntityCache();

            // Switch to sender and like the post
            \XF::setVisitor($sender);
            $reactionRepo = XF::app()->repository('XF:Reaction');
            
            // Get the default "like" reaction (usually ID 1)
            $reaction = XF::app()->em()->find('XF:Reaction', 1);
            if (!$reaction) {
                // Try to find any reaction
                $reaction = XF::app()->finder('XF:Reaction')
                    ->order('reaction_id')
                    ->fetchOne();
            }

            if ($reaction) {
                // Reload post to ensure it's in a clean state
                $post = XF::app()->em()->find('XF:Post', $post->post_id);
                if ($post) {
                    $reactionRepo->reactToContent($reaction->reaction_id, 'post', $post->post_id, $sender);
                    $output->writeln("  <fg=green>✓</> Liked post by {$receiver->username} (Post ID: {$post->post_id}, Reaction ID: {$reaction->reaction_id})");
                } else {
                    $output->writeln("  <fg=red>✗</> Error: Could not reload post");
                    \XF::setVisitor($sender);
                    return false;
                }
            } else {
                $output->writeln("  <fg=yellow>⚠</> No reactions found. Skipping like test.");
                \XF::setVisitor($sender);
                return false;
            }

            \XF::setVisitor($sender);
            return true;
        } catch (\Exception $e) {
            $output->writeln("  <fg=red>✗</> Error: " . $e->getMessage());
            \XF::setVisitor($sender);
            return false;
        }
    }

    protected function testConversation(User $sender, User $receiver, OutputInterface $output)
    {
        $output->writeln("<info>Testing: Conversation Messages (New & Reply)</info>");

        try {
            // Test 1: Create new conversation
            $output->writeln("  <comment>Test 1: New Conversation</comment>");
            $creator = XF::app()->service('XF:Conversation\Creator', $sender);
            $creator->setRecipients([$receiver]);
            $creator->setContent(
                'Test Push Notification - New Conversation to ' . $receiver->username . ' ' . date('H:i:s'),
                'This is a test new conversation message to ' . $receiver->username . ' to trigger a push notification.'
            );
            
            if (!$creator->validate($errors)) {
                $output->writeln("  <fg=red>✗</> Validation failed: " . implode(', ', $errors));
                return false;
            }
            
            $conversation = $creator->save();
            $creator->sendNotifications();

            $output->writeln("  <fg=green>✓</> Created new conversation to {$receiver->username} (ID: {$conversation->conversation_id})");

            // Test 2: Reply to the conversation
            $output->writeln("  <comment>Test 2: Reply to Conversation</comment>");
            \XF::setVisitor($sender);
            $replier = XF::app()->service('XF:Conversation\Replier', $conversation, $sender);
            $replier->setMessageContent('This is a test reply in the conversation to trigger a push notification for ' . $receiver->username . '.');
            
            if (!$replier->validate($errors)) {
                $output->writeln("  <fg=red>✗</> Reply validation failed: " . implode(', ', $errors));
                return false;
            }
            
            $message = $replier->save();
            $replier->sendNotifications();

            $output->writeln("  <fg=green>✓</> Created reply in conversation (Message ID: {$message->message_id})");
            
            return true;
        } catch (\Exception $e) {
            $output->writeln("  <fg=red>✗</> Error: " . $e->getMessage());
            return false;
        }
    }

    protected function testFollow(User $sender, User $receiver, OutputInterface $output)
    {
        $output->writeln("<info>Testing: Follow (user_following)</info>");

        try {
            // Check if sender is already following receiver
            $existingFollow = XF::app()->finder('XF:UserFollow')
                ->where('user_id', $sender->user_id)
                ->where('follow_user_id', $receiver->user_id)
                ->fetchOne();

            if ($existingFollow) {
                // Unfollow first, then follow again to trigger a new alert
                $output->writeln("  <comment>Sender already following receiver, unfollowing first...</comment>");
                \XF::setVisitor($sender);
                $followService = XF::app()->service(FollowService::class, $receiver, $sender);
                $followService->setSilent(true); // Don't send alert on unfollow
                $followService->unfollow();
                $output->writeln("  <fg=green>✓</> Unfollowed (silent)");
            }

            // Now follow the receiver (this will trigger an alert to the receiver)
            \XF::setVisitor($sender);
            $followService = XF::app()->service(FollowService::class, $receiver, $sender);
            $followService->setSilent(false); // Send alert
            $userFollow = $followService->follow();

            if ($userFollow && $userFollow->hasErrors()) {
                $output->writeln("  <fg=red>✗</> Error: " . implode(', ', $userFollow->getErrors()));
                return false;
            }

            $output->writeln("  <fg=green>✓</> {$sender->username} is now following {$receiver->username}");
            return true;
        } catch (\Exception $e) {
            $output->writeln("  <fg=red>✗</> Error: " . $e->getMessage());
            \XF::setVisitor($sender);
            return false;
        }
    }

    /**
     * Process collected alerts manually (for CLI context where app_pub_complete doesn't fire)
     */
    protected function processCollectedAlerts(OutputInterface $output)
    {
        // Manually trigger the listener (simulating app_pub_complete event)
        try {
            \ForumCopilot\Listener::processBatchedAlerts();
            $output->writeln("  <fg=green>✓</> Listener triggered");
        } catch (\Exception $e) {
            $output->writeln("  <fg=red>✗</> Error triggering listener: " . $e->getMessage());
        }
        
        // Check if job was enqueued
        $db = XF::app()->db();
        $job = $db->fetchRow('SELECT * FROM xf_job WHERE unique_key = ? ORDER BY job_id DESC LIMIT 1', ['forumCopilotAlertPush']);
        if ($job) {
            $output->writeln("  <fg=green>✓</> Background job enqueued (ID: {$job['job_id']})");
            
            // Run the job immediately in CLI context
            $output->writeln("  Processing job immediately...");
            $jobManager = XF::app()->jobManager();
            $runner = $jobManager->runById($job['job_id'], 30);
            if ($runner) {
                $output->writeln("  <fg=green>✓</> Job processed: " . $runner->statusMessage);
            }
        } else {
            $collected = \ForumCopilot\Service\Alert\AlertPushCollector::getCollectedAlerts();
            if (empty($collected)) {
                $output->writeln("  <comment>No alerts collected (conversations don't use alerts)</comment>");
            } else {
                $output->writeln("  <comment>Job not enqueued, processing alerts directly...</comment>");
                try {
                    $processor = new \ForumCopilot\Service\Alert\AlertPushProcessor(XF::app());
                    $processor->processCollectedAlerts($collected);
                    $output->writeln("  <fg=green>✓</> Alerts processed directly");
                } catch (\Exception $e) {
                    $output->writeln("  <fg=red>✗</> Error processing alerts: " . $e->getMessage());
                }
            }
        }
    }
}


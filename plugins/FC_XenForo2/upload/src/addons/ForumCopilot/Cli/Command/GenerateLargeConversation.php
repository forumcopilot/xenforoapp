<?php

namespace ForumCopilot\Cli\Command;

use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use XF;
use XF\Entity\User;

class GenerateLargeConversation extends AbstractCommand
{
    protected function configure()
    {
        $this
            ->setName('fc:generate-large-conversation')
            ->setDescription('Generate a conversation with many members and over 100 messages')
            ->addOption('members', 'm', InputOption::VALUE_REQUIRED, 'Number of members to include (default: 20)', '20')
            ->addOption('messages', null, InputOption::VALUE_REQUIRED, 'Number of messages to generate (default: 150)', '150')
            ->addOption('create-users', 'c', InputOption::VALUE_NONE, 'Create users if they don\'t exist');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $app = XF::app();
        $numMembers = (int)$input->getOption('members');
        $numMessages = (int)$input->getOption('messages');
        $createUsers = $input->getOption('create-users');

        $output->writeln("<info>=== Generate Large Conversation ===</info>");
        $output->writeln("Members: <comment>{$numMembers}</comment>");
        $output->writeln("Messages: <comment>{$numMessages}</comment>");
        $output->writeln("");

        // Ensure we have at least 100 messages
        if ($numMessages < 100) {
            $output->writeln("<comment>Warning: Number of messages is less than 100. Setting to 100.</comment>");
            $numMessages = 100;
        }

        // Get or create users
        $output->writeln("<info>Getting or creating users...</info>");
        $users = $this->getOrCreateUsers($numMembers, $createUsers, $output);
        
        if (empty($users)) {
            $output->writeln("<error>No users available. Cannot create conversation.</error>");
            return 1;
        }

        // Ensure admin is in the list
        $admin = $this->getUser('admin');
        if (!$admin) {
            $output->writeln("<error>Admin user not found. Please ensure 'admin' user exists.</error>");
            return 1;
        }

        // Add admin to users if not already present
        $adminInList = false;
        foreach ($users as $user) {
            if ($user->user_id === $admin->user_id) {
                $adminInList = true;
                break;
            }
        }

        if (!$adminInList) {
            // Replace first user with admin if we have too many, or add admin
            if (count($users) >= $numMembers) {
                $users[0] = $admin;
            } else {
                array_unshift($users, $admin);
            }
        }

        $output->writeln("  ✓ Found/created " . count($users) . " users");
        $output->writeln("  ✓ Admin user included: <comment>{$admin->username}</comment>");
        $output->writeln("");

        // Create conversation
        $output->writeln("<info>Creating conversation...</info>");
        $starter = $users[0];
        $recipients = array_slice($users, 1);

        \XF::setVisitor($starter);

        $conversationTitle = 'Large Group Conversation - ' . date('Y-m-d H:i:s');
        $firstMessage = "Hello everyone! This is a large group conversation with " . count($users) . " members and " . $numMessages . " messages for testing purposes.\n\nLet's start the discussion!";

        try {
            $creator = XF::app()->service('XF:Conversation\Creator', $starter);
            $creator->setIsAutomated();
            $creator->setRecipientsTrusted($recipients);
            $creator->setContent($conversationTitle, $firstMessage);

            $errors = [];
            if (!$creator->validate($errors)) {
                $output->writeln("<error>Validation failed: " . implode(', ', $errors) . "</error>");
                return 1;
            }

            $conversation = $creator->save();
            $creator->sendNotifications();

            $output->writeln("  ✓ Created conversation: <comment>{$conversationTitle}</comment>");
            $output->writeln("  ✓ Conversation ID: <comment>{$conversation->conversation_id}</comment>");
            $output->writeln("");

            // Generate messages
            $output->writeln("<info>Generating messages...</info>");
            $messageTemplates = [
                "That's a great point! I agree with what you're saying.",
                "I have a different perspective on this. Let me share my thoughts...",
                "Thanks for bringing that up. It's something we should consider.",
                "I think we should discuss this further. What do others think?",
                "This is really interesting. Can you elaborate more?",
                "I've been thinking about this too. Here's my take on it...",
                "That makes sense. I hadn't considered that angle before.",
                "I'm not sure I fully understand. Could you clarify?",
                "This is an important topic. We should make sure everyone is on the same page.",
                "I have a question about this. Maybe someone can help?",
                "Let's explore this idea more deeply. There's a lot to unpack here.",
                "I appreciate your input. This is helpful for the discussion.",
                "We should probably consider the implications of this.",
                "That's a valid concern. We need to address it properly.",
                "I'm excited to see where this conversation goes!",
                "This is getting interesting. Keep the ideas coming!",
                "I think we're making good progress on this topic.",
                "Let me add my two cents to the discussion...",
                "I see what you mean. That's a good observation.",
                "We should definitely keep this conversation going.",
            ];

            $messageCount = 0;
            $baseTimestamp = time();
            $timestampCounter = 0;

            for ($i = 0; $i < $numMessages; $i++) {
                // Randomly pick a participant
                $sender = $users[array_rand($users)];
                
                // Pick a random message template
                $messageText = $messageTemplates[array_rand($messageTemplates)];
                
                // Add some variation
                if (rand(0, 3) == 0) {
                    $messageText .= "\n\nMessage #" . ($i + 2) . " in this conversation.";
                }
                
                if (rand(0, 5) == 0) {
                    $messageText .= "\n\nLet me know what you think!";
                }

                // Get unique timestamp for this message
                $messageTimestamp = $baseTimestamp + $timestampCounter;
                $timestampCounter++;

                try {
                    \XF::asVisitor($sender, function() use ($conversation, $sender, $messageText, $messageTimestamp, &$messageCount) {
                        $replier = XF::app()->service('XF:Conversation\Replier', $conversation, $sender);
                        $replier->setIsAutomated();
                        $replier->setMessageContent($messageText);

                        $errors = [];
                        if ($replier->validate($errors)) {
                            $message = $replier->getMessage();
                            $message->set('message_date', $messageTimestamp, ['forceSet' => true]);
                            
                            $replier->save();
                            $messageCount++;
                        }
                    });
                } catch (\Exception $e) {
                    // Continue on error
                    $output->writeln("  <comment>Warning: Failed to create message " . ($i + 1) . ": " . $e->getMessage() . "</comment>");
                }

                // Progress indicator
                if (($i + 1) % 10 == 0 || $i == 0) {
                    $output->writeln("  ✓ Created " . ($i + 1) . " / {$numMessages} messages");
                }
            }

            $output->writeln("");
            $output->writeln("<info>=== Summary ===</info>");
            $output->writeln("Conversation ID: <comment>{$conversation->conversation_id}</comment>");
            $output->writeln("Title: <comment>{$conversationTitle}</comment>");
            $output->writeln("Participants: <comment>" . count($users) . "</comment>");
            $output->writeln("Messages created: <comment>{$messageCount}</comment>");
            $output->writeln("Admin participated: <comment>Yes</comment>");
            $output->writeln("");
            $output->writeln("<info>Conversation created successfully!</info>");

            return 0;
        } catch (\Exception $e) {
            $output->writeln("<error>Error: " . $e->getMessage() . "</error>");
            $output->writeln("<error>Stack trace: " . $e->getTraceAsString() . "</error>");
            return 1;
        }
    }

    protected function getOrCreateUsers($numMembers, $createUsers, OutputInterface $output)
    {
        $app = XF::app();
        $users = [];

        // First, try to get existing users
        $existingUsers = $app->finder('XF:User')
            ->where('user_state', 'valid')
            ->order('user_id', 'ASC')
            ->fetch($numMembers * 2); // Get more than needed to have options

        foreach ($existingUsers as $user) {
            if (count($users) >= $numMembers) {
                break;
            }
            $users[] = $user;
        }

        $output->writeln("  Found " . count($users) . " existing users");

        // If we need more users and creation is enabled, create them
        if (count($users) < $numMembers && $createUsers) {
            $needed = $numMembers - count($users);
            $output->writeln("  Creating {$needed} new users...");

            $firstNames = ['John', 'Jane', 'Michael', 'Sarah', 'David', 'Emily', 'Chris', 'Amanda', 'Daniel', 'Jessica',
                'James', 'Jennifer', 'Robert', 'Linda', 'William', 'Patricia', 'Richard', 'Barbara', 'Thomas', 'Elizabeth',
                'Matthew', 'Lisa', 'Mark', 'Nancy', 'Paul', 'Karen', 'Steven', 'Betty', 'Andrew', 'Helen'];
            $lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez',
                'Anderson', 'Taylor', 'Thomas', 'Moore', 'Jackson', 'Martin', 'Lee', 'Thompson', 'White', 'Harris',
                'Clark', 'Lewis', 'Walker', 'Hall', 'Allen', 'Young', 'King', 'Wright', 'Lopez', 'Hill'];

            for ($i = 0; $i < $needed; $i++) {
                $firstName = $firstNames[array_rand($firstNames)];
                $lastName = $lastNames[array_rand($lastNames)];
                $username = $firstName . $lastName . rand(100, 999);
                $email = strtolower($username) . '@example.com';

                // Check if username already exists
                $existing = $app->em()->findOne('XF:User', ['username' => $username]);
                if ($existing) {
                    continue;
                }

                try {
                    $userService = XF::service('XF:User\Registration');
                    $userService->setFromInput([
                        'username' => $username,
                        'email' => $email,
                    ]);
                    $userService->setPassword('password123', 'password123', null, true);

                    if ($userService->validate($errors)) {
                        $user = $userService->save();
                        $user->fastUpdate([
                            'user_state' => 'valid',
                        ]);
                        $users[] = $user;
                        $output->writeln("    ✓ Created user: {$username}");
                    }
                } catch (\Exception $e) {
                    $output->writeln("    ✗ Failed to create user {$username}: " . $e->getMessage());
                }
            }
        }

        return array_slice($users, 0, $numMembers);
    }

    protected function getUser($username)
    {
        return XF::app()->finder('XF:User')
            ->where('username', $username)
            ->fetchOne();
    }
}

<?php

namespace ForumCopilot\Cli\Command;

use Symfony\Component\Console\Formatter\OutputFormatterStyle;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

if (class_exists(\XF\Cli\Command\AbstractCommand::class))
{
    abstract class AbstractCommand extends \XF\Cli\Command\AbstractCommand
    {
    }
}
else
{
    abstract class AbstractCommand extends \Symfony\Component\Console\Command\Command
    {
        protected function initialize(InputInterface $input, OutputInterface $output)
        {
            foreach (['red', 'green', 'yellow', 'blue', 'magenta', 'cyan'] as $color)
            {
                $output->getFormatter()->setStyle($color, new OutputFormatterStyle($color));
            }

            return parent::initialize($input, $output);
        }
    }
}

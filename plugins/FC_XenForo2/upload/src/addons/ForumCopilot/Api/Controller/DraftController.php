<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;

/**
 * The signed-in member's drafts, in XenForo's own draft store (xf_draft), so a
 * reply started in the app is there in the forum's editor on the web and the
 * other way round, as between two browsers.
 *
 * Draft keys are XenForo's:
 *   thread-{id}               a reply in a thread
 *   forum-{id}                a new thread in a forum (extra: title, prefix_id)
 *   conversation-reply-{id}   a reply in a direct message
 *   conversation              a new direct message (extra: title, recipients)
 */
class DraftController extends AbstractController
{
    /** Extra fields kept with a draft, as XenForo's own editors keep them. */
    protected const EXTRA_KEYS = ['title', 'prefix_id', 'recipients'];

    public function actionGetDraft(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }
        $key = $this->validDraftKey($params->get('draftKey', ''));
        if ($key === null) {
            return $this->apiError('Unknown draft key');
        }

        $draft = \XF\Draft::createFromKey($key);
        $entity = $draft->getDraftEntity();
        if (!$entity || !$entity->exists()) {
            return $this->apiSuccess(['draft' => null]);
        }
        return $this->apiSuccess(['draft' => $this->draftData($entity)]);
    }

    public function actionSaveDraft(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }
        $key = $this->validDraftKey($params->get('draftKey', ''));
        if ($key === null) {
            return $this->apiError('Unknown draft key');
        }
        if (!$this->canDraftFor($key)) {
            return $this->apiError('You cannot post there');
        }

        $message = (string)$params->get('message', '');
        $extra = $params->get('extra', []);
        $extra = is_array($extra) ? array_intersect_key($extra, array_flip(self::EXTRA_KEYS)) : [];

        $draft = \XF\Draft::createFromKey($key);
        if (trim($message) === '' && !array_filter($extra)) {
            // Nothing left: no draft, as XenForo's editor does.
            $draft->delete();
            return $this->apiSuccess(['draft' => null]);
        }

        $draft->message = $message;
        $draft->extra_data = $extra;
        if (!$draft->save()) {
            return $this->apiError('The draft could not be saved');
        }
        return $this->apiSuccess(['draft' => $this->draftData($draft->getDraftEntity())]);
    }

    public function actionDeleteDraft(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }
        $key = $this->validDraftKey($params->get('draftKey', ''));
        if ($key === null) {
            return $this->apiError('Unknown draft key');
        }
        \XF\Draft::createFromKey($key)->delete();
        return $this->apiSuccess([]);
    }

    /**
     * The member's drafts, newest first, 20 a page from page 0.
     */
    public function actionGetDrafts(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }
        $page = max(0, (int)$params->get('page', 0));
        $perPage = 20;

        $finder = $this->finder('XF:Draft')
            ->where('user_id', \XF::visitor()->user_id)
            ->order('last_update', 'DESC');
        $total = $finder->total();
        $drafts = $finder->limit($perPage, $page * $perPage)->fetch();

        $items = [];
        foreach ($drafts AS $draft) {
            if ($this->validDraftKey($draft->draft_key) !== null) {
                $items[] = $this->draftData($draft);
            }
        }
        return $this->apiSuccess(['total' => $total, 'drafts' => $items]);
    }

    protected function validDraftKey($key): ?string
    {
        $key = is_string($key) ? trim($key) : '';
        return preg_match('/^(thread-\d+|forum-\d+|conversation-reply-\d+|conversation)$/', $key) ? $key : null;
    }

    /**
     * Only for a thread, forum or direct message the member can see.
     */
    protected function canDraftFor(string $key): bool
    {
        if ($key === 'conversation') {
            return \XF::visitor()->canStartConversation();
        }
        [$kind, $id] = [preg_replace('/-\d+$/', '', $key), (int)substr(strrchr($key, '-'), 1)];
        switch ($kind) {
            case 'thread':
                $thread = $this->em()->find('XF:Thread', $id);
                return $thread && $thread->canView();
            case 'forum':
                $forum = $this->em()->find('XF:Forum', $id);
                return $forum && $forum->canView();
            case 'conversation-reply':
                return (bool)$this->finder('XF:ConversationUser')
                    ->where('conversation_id', $id)
                    ->where('owner_user_id', \XF::visitor()->user_id)
                    ->fetchOne();
        }
        return false;
    }

    protected function draftData(\XF\Entity\Draft $draft): array
    {
        $extra = is_array($draft->extra_data) ? $draft->extra_data : [];
        return [
            'draftKey' => $draft->draft_key,
            'message' => (string)$draft->message,
            'extra' => (object)array_intersect_key($extra, array_flip(self::EXTRA_KEYS)),
            'lastUpdate' => (int)$draft->last_update,
        ];
    }
}

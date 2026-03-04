<?php

namespace ForumCopilot\Result;

use ForumCopilot\Entity\FCCustomFieldDefinition;

/**
 * ForumCopilot Signin Result
 * Maps from SigninData_Output
 */
class FCSigninResult extends FCResult
{
    public $userId;
    public $email;
    public $userType;
    public $username;
    public $login;
    public $usergroupId;
    public $iconUrl;
    public $postCount;
    public $canPm;
    public $canSendPm;
    public $canModerate;
    public $canSearch;
    public $canWhosonline;
    public $canProfile;
    public $canUploadAvatar;
    public $maxAttachment;
    public $maxPngSize;
    public $maxJpgSize;
    public $register;
    public $status;

    public function __construct($result = true, $resultText = 'success', $userId = null, $email = null, $userType = null, $username = null, $login = null, $usergroupId = null, $iconUrl = null, $postCount = 0, $canPm = false, $canSendPm = false, $canModerate = false, $canSearch = false, $canWhosonline = false, $canProfile = false, $canUploadAvatar = false, $maxAttachment = 0, $maxPngSize = 0, $maxJpgSize = 0, $register = false, $status = '')
    {
        parent::__construct($result, $resultText);
        $this->userId = $userId;
        $this->email = $email;
        $this->userType = $userType;
        $this->username = $username;
        $this->login = $login;
        $this->usergroupId = $usergroupId;
        $this->iconUrl = $iconUrl;
        $this->postCount = $postCount;
        $this->canPm = $canPm;
        $this->canSendPm = $canSendPm;
        $this->canModerate = $canModerate;
        $this->canSearch = $canSearch;
        $this->canWhosonline = $canWhosonline;
        $this->canProfile = $canProfile;
        $this->canUploadAvatar = $canUploadAvatar;
        $this->maxAttachment = $maxAttachment;
        $this->maxPngSize = $maxPngSize;
        $this->maxJpgSize = $maxJpgSize;
        $this->register = $register;
        $this->status = $status;
    }

    public function toArray()
    {
        $data = parent::toArray();
        if ($this->userId !== null) $data['userId'] = $this->userId;
        if ($this->email !== null) $data['email'] = $this->email;
        if ($this->userType !== null) $data['userType'] = $this->userType;
        if ($this->username !== null) $data['username'] = $this->username;
        if ($this->login !== null) $data['login'] = $this->login;
        if ($this->usergroupId !== null) $data['usergroupId'] = $this->usergroupId;
        if ($this->iconUrl !== null) $data['iconUrl'] = $this->iconUrl;
        $data['postCount'] = $this->postCount;
        $data['canPm'] = $this->canPm;
        $data['canSendPm'] = $this->canSendPm;
        $data['canModerate'] = $this->canModerate;
        $data['canSearch'] = $this->canSearch;
        $data['canWhosonline'] = $this->canWhosonline;
        $data['canProfile'] = $this->canProfile;
        $data['canUploadAvatar'] = $this->canUploadAvatar;
        $data['maxAttachment'] = $this->maxAttachment;
        $data['maxPngSize'] = $this->maxPngSize;
        $data['maxJpgSize'] = $this->maxJpgSize;
        $data['register'] = $this->register;
        $data['status'] = $this->status;
        return $data;
    }
}

/**
 * ForumCopilot Forget Password Result
 * Maps from ForgetPasswordData_Output
 */
class FCForgetPasswordResult extends FCResult
{
    public $verified;

    public function __construct($result = true, $resultText = 'success', $verified = false)
    {
        parent::__construct($result, $resultText);
        $this->verified = $verified;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['verified'] = $this->verified;
        return $data;
    }
}

/**
 * ForumCopilot Update Password Result
 * Maps from UpdatePasswordData_Output
 */
class FCUpdatePasswordResult extends FCResult
{
    public function __construct($result = true, $resultText = 'success')
    {
        parent::__construct($result, $resultText);
    }

    public function toArray()
    {
        return parent::toArray();
    }
}

/**
 * ForumCopilot Update Profile Result
 * Maps from UpdateProfileData_Output
 */
class FCUpdateProfileResult extends FCResult
{
    public function __construct($result = true, $resultText = 'success')
    {
        parent::__construct($result, $resultText);
    }

    public function toArray()
    {
        return parent::toArray();
    }
}

/**
 * ForumCopilot Update Password SSO Result
 * Maps from UpdatePasswordSSOData_Output
 */
class FCUpdatePasswordSSOResult extends FCResult
{
    public function __construct($result = true, $resultText = 'success')
    {
        parent::__construct($result, $resultText);
    }

    public function toArray()
    {
        return parent::toArray();
    }
}

/**
 * ForumCopilot Update Email Result
 * Maps from UpdateEmailData_Output
 */
class FCUpdateEmailResult extends FCResult
{
    public $confirmationRequired;

    public function __construct($result = true, $resultText = 'success', $confirmationRequired = false)
    {
        parent::__construct($result, $resultText);
        $this->confirmationRequired = (bool)$confirmationRequired;
    }

    public function toArray()
    {
        $array = parent::toArray();
        $array['confirmationRequired'] = $this->confirmationRequired;
        return $array;
    }
}

/**
 * ForumCopilot Register Result
 * Maps from RegisterData_Output
 */
class FCRegisterResult extends FCResult
{
    public $previewTopicId;
    public $userId;
    public $username;
    public $userState;
    public $requiresEmailConfirmation;
    public $requiresManualApproval;
    public $message;

    public function __construct(
        $result = true, 
        $resultText = 'success', 
        $previewTopicId = '',
        $userId = null,
        $username = null,
        $userState = null,
        $requiresEmailConfirmation = false,
        $requiresManualApproval = false,
        $message = null
    ) {
        parent::__construct($result, $resultText);
        $this->previewTopicId = $previewTopicId;
        $this->userId = $userId;
        $this->username = $username;
        $this->userState = $userState;
        $this->requiresEmailConfirmation = $requiresEmailConfirmation;
        $this->requiresManualApproval = $requiresManualApproval;
        $this->message = $message;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['previewTopicId'] = $this->previewTopicId;
        if ($this->userId !== null) $data['userId'] = $this->userId;
        if ($this->username !== null) $data['username'] = $this->username;
        if ($this->userState !== null) $data['userState'] = $this->userState;
        if ($this->requiresEmailConfirmation) $data['requiresEmailConfirmation'] = $this->requiresEmailConfirmation;
        if ($this->requiresManualApproval) $data['requiresManualApproval'] = $this->requiresManualApproval;
        if ($this->message !== null) $data['message'] = $this->message;
        return $data;
    }
}

/**
 * ForumCopilot Prefetch Account Result
 * Maps from PrefetchAccountData_Output
 */
class FCPrefetchAccountResult extends FCResult
{
    public $accountExists;
    public $username;
    public $email;
    public $customRegisterFields;
    public $canRegisterViaAPI;
    public $registrationRequirements;
    public $registerViaWebUrl;
    public $registrationOpen;

    public function __construct(
        $result = true, 
        $resultText = 'success', 
        $accountExists = false, 
        $username = null, 
        $email = null, 
        $customRegisterFields = [],
        $canRegisterViaAPI = true,
        $registrationRequirements = null,
        $registerViaWebUrl = null,
        $registrationOpen = true
    ) {
        parent::__construct($result, $resultText);
        $this->accountExists = $accountExists;
        $this->username = $username;
        $this->email = $email;
        $this->customRegisterFields = $customRegisterFields;
        $this->canRegisterViaAPI = $canRegisterViaAPI;
        $this->registrationRequirements = $registrationRequirements;
        $this->registerViaWebUrl = $registerViaWebUrl;
        $this->registrationOpen = $registrationOpen;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['accountExists'] = $this->accountExists;
        if ($this->username !== null) $data['username'] = $this->username;
        if ($this->email !== null) $data['email'] = $this->email;
        $data['customRegisterFields'] = array_map(function($field) {
            return is_object($field) ? $field->toArray() : $field;
        }, $this->customRegisterFields);
        $data['canRegisterViaAPI'] = $this->canRegisterViaAPI;
        if ($this->registrationRequirements !== null) {
            $data['registrationRequirements'] = $this->registrationRequirements;
        }
        if ($this->registerViaWebUrl !== null) {
            $data['registerViaWebUrl'] = $this->registerViaWebUrl;
        }
        $data['registrationOpen'] = $this->registrationOpen;
        return $data;
    }
}


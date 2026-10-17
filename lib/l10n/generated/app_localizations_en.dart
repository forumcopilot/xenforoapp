// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'Login';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get pleaseEnterUsername => 'Please enter your username';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String credentialsSentToDomain(String domain) {
    return 'Your username and password will be sent to $domain';
  }

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get logIn => 'Log In';

  @override
  String get continueButton => 'Continue';

  @override
  String get registrationNotAvailable => 'Registration Not Available';

  @override
  String get registrationNotAvailableMessage =>
      'Registration is currently not available. The forum may be closed or registration may be disabled.';

  @override
  String get webRegistrationRequired => 'Web Registration Required';

  @override
  String get webRegistrationRequiredMessage =>
      'This forum requires registration through the web browser. Please click the button below to open the registration page.';

  @override
  String get openRegistrationPage => 'Open Registration Page';

  @override
  String get loadingAdditionalFields => 'Loading additional fields...';

  @override
  String get pleaseSelectDateOfBirth => 'Please select your date of birth';

  @override
  String get pleaseEnterLocation => 'Please enter your location';

  @override
  String get pleaseIndicateEmailPreference =>
      'Please indicate your email preference';

  @override
  String get pleaseFillAllRequiredFields =>
      'Please fill in all required fields';

  @override
  String get pleaseAcceptTermsOfService => 'Please accept the Terms of Service';

  @override
  String get pleaseAcceptPrivacyPolicy => 'Please accept the Privacy Policy';

  @override
  String get registrationError => 'Registration Error';

  @override
  String get registrationFailed =>
      'Registration failed. Please check your information.';

  @override
  String get registrationFailedTryAgain =>
      'Registration failed. Please try again.';

  @override
  String get registrationInfo => 'Registration Info';

  @override
  String get openWebsite => 'Open Website';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'Could not open the forum website. Please try visiting: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      'Registration successful! Please check your email to confirm your account before logging in.';

  @override
  String get registrationSuccessfulPendingApproval =>
      'Registration successful! Your account is pending approval. You will be notified when your account is approved.';

  @override
  String get registrationSuccessfulAutoLogin =>
      'Registration successful! You have been automatically logged in.';

  @override
  String get welcome => 'Welcome!';

  @override
  String get registrationSuccessful => 'Registration Successful';

  @override
  String get pleaseLoginWithNewAccount =>
      'Please log in with your new account.';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get usernameOrEmailLabel => 'Username or Email';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Please enter your username or email';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Reset Link Sent';

  @override
  String get passwordResetInstructionsSent =>
      'Password reset instructions have been sent to your registered email address.';

  @override
  String get resetFailed => 'Reset Failed';

  @override
  String get unableToSendResetLink =>
      'Unable to send reset link. Please try again.';

  @override
  String get errorSendingResetLink =>
      'An error occurred while sending the reset link. Please check your connection and try again.';

  @override
  String get errorTitle => 'Error';

  @override
  String get okButton => 'OK';

  @override
  String get retryButton => 'Retry';

  @override
  String get copyToClipboard => 'Copy to Clipboard';

  @override
  String get copied => 'Copied';

  @override
  String get errorMessageCopiedToClipboard =>
      'Error message copied to clipboard';

  @override
  String get cancel => 'Cancel';

  @override
  String get getHelp => 'Get Help';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get unexpectedErrorOccurred =>
      'An unexpected error occurred. Please try again.';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get checkInternetConnection =>
      'Please check your internet connection and try again.';

  @override
  String get authenticationRequired => 'Authentication Required';

  @override
  String get pleaseLoginToContinue => 'Please log in to continue.';

  @override
  String get forumError => 'Forum Error';

  @override
  String get anErrorOccurred => 'An error occurred';

  @override
  String get accountPendingApproval =>
      'Your account is pending approval. You can browse the forum but cannot post until a moderator approves your account.';

  @override
  String get checkEmailToConfirm =>
      'Please check your email to confirm your account. Click the confirmation link in the email we sent you.';

  @override
  String get checkNewEmailToConfirm =>
      'Please check your new email address to confirm the change. Your old email will remain active until you confirm the new one.';

  @override
  String get emailAddressInvalid =>
      'Your email address appears to be invalid or is bouncing emails. Please update your email address in account settings.';

  @override
  String get accountDisabled =>
      'Your account has been disabled. Please contact an administrator for assistance.';

  @override
  String get accountRegistrationRejected =>
      'Your account registration was rejected. Please contact an administrator for more information.';

  @override
  String get welcomeToForumCopilot => 'Welcome to Forum Copilot!';

  @override
  String get successfullyLoggedOut => 'You have been successfully logged out';

  @override
  String get accountStatusRequiresAttention =>
      'Your account status requires attention. Please contact an administrator if you have questions.';

  @override
  String get updateEmail => 'Update Email';

  @override
  String get resend => 'Resend';

  @override
  String get noLatestTopics => 'No Latest Topics';

  @override
  String get noRecentTopicsToDisplay =>
      'There are no recent topics to display. Check back later for new discussions.';

  @override
  String get noUnreadTopics => 'No Unread Topics';

  @override
  String get thereAreNoUnreadTopics =>
      'There are no unread topics. Check back later for new discussions.';

  @override
  String get youAreAllCaughtUp => 'You\'re all caught up!';

  @override
  String get noSubscribedTopics => 'No Subscribed Topics';

  @override
  String get noSubscribedTopicsMessage =>
      'You did not subscribe to any topics. Tap the star button on a topic to subscribe and receive notifications for new updates.';

  @override
  String get noParticipatedTopics => 'No Participated Topics';

  @override
  String get topicsYouParticipatedIn =>
      'Topics that you have participated in will be shown here.';

  @override
  String get latest => 'Latest';

  @override
  String get unread => 'Unread';

  @override
  String get subscribed => 'Subscribed';

  @override
  String get participated => 'Participated';

  @override
  String get connectionTimedOut =>
      'Connection timed out. The site may be down or unreachable.';

  @override
  String get failedToConnectToSite =>
      'Failed to connect to site. The site may be down or unreachable.';

  @override
  String get connectionFailed => 'Connection Failed';

  @override
  String failedToConnectToSiteName(String siteName) {
    return 'Failed to connect to $siteName';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get newConversation => 'New Conversation';

  @override
  String get newMessage => 'New Message';

  @override
  String get appSettings => 'App Settings';

  @override
  String get searchSites => 'Search Sites';

  @override
  String get all => 'All';

  @override
  String get topicsOnly => 'Topics Only';

  @override
  String get titlesOnly => 'Titles Only';

  @override
  String failedToShareTopic(String error) {
    return 'Failed to share topic: $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'Please login to $action this thread';
  }

  @override
  String get subscribeTo => 'subscribe to';

  @override
  String get unsubscribeFrom => 'unsubscribe from';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get unsubscribe => 'Unsubscribe';

  @override
  String failedToSubscribeToThread(String action) {
    return 'Failed to $action thread';
  }

  @override
  String get youCannotReplyToThisThread => 'You cannot reply to this thread';

  @override
  String get pleaseWaitForThreadToLoad => 'Please wait for the thread to load';

  @override
  String get postCanBeRestoredLater => 'Post can be restored later';

  @override
  String get postWillBePermanentlyDeleted => 'Post will be permanently deleted';

  @override
  String get enterReasonForDeletingPost =>
      'Enter the reason for deleting this post';

  @override
  String get reportPost => 'Report Post';

  @override
  String get pleaseProvideReasonForReporting =>
      'Please provide a reason for reporting this post.';

  @override
  String get reason => 'Reason';

  @override
  String get enterReasonForReportingPost =>
      'Enter the reason for reporting this post';

  @override
  String get pleaseEnterReason => 'Please enter a reason';

  @override
  String get selectedActions => 'Selected actions:';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get participantsLabel => 'Participants';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username has been invited to the conversation';
  }

  @override
  String errorInvitingUser(String error) {
    return 'Error inviting user: $error';
  }

  @override
  String get newTopic => 'New Topic';

  @override
  String get markRead => 'Mark Read';

  @override
  String get pleaseSelectReasonForReportingUser =>
      'Please select a reason for reporting this user.';

  @override
  String get spamOrAdvertising => 'Spam or advertising';

  @override
  String get harassmentOrBullying => 'Harassment or bullying';

  @override
  String get inappropriateContent => 'Inappropriate content';

  @override
  String get impersonationOrFakeAccount => 'Impersonation or fake account';

  @override
  String get otherPleaseSpecify => 'Other (please specify)';

  @override
  String get pleaseSpecifyReason => 'Please specify the reason';

  @override
  String get enterReasonForReportingUser =>
      'Enter the reason for reporting this user';

  @override
  String get pleaseSelectReason => 'Please select a reason';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return 'Please select a reason for banning $username';
  }

  @override
  String get violationOfCommunityGuidelines =>
      'Violation of community guidelines';

  @override
  String get harassmentOrAbusiveBehavior => 'Harassment or abusive behavior';

  @override
  String get postingInappropriateContent => 'Posting inappropriate content';

  @override
  String get accountCompromiseOrSecurityIssue =>
      'Account compromise or security issue';

  @override
  String get enterReasonForBanningUser =>
      'Enter the reason for banning this user';

  @override
  String get banUntil => 'Ban until';

  @override
  String get selectDate => 'Select date';

  @override
  String get unbanUser => 'Unban User';

  @override
  String get leaveConversation => 'Leave conversation';

  @override
  String get reportConversation => 'Report conversation';

  @override
  String get topicClosed => 'Topic closed';

  @override
  String get topicOpened => 'Topic opened';

  @override
  String get topicStickied => 'Topic stickied';

  @override
  String get topicUnstickied => 'Topic unstickied';

  @override
  String cannotEditMessage(String error) {
    return 'Cannot edit this message: $error';
  }

  @override
  String get confirmSpamClean => 'Confirm Spam Clean';

  @override
  String get myForums => 'My Forums';

  @override
  String get recentlyVisited => 'Recently Visited';

  @override
  String get explore => 'Explore';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => 'No conversations';

  @override
  String get noConversationsMessage =>
      'You have no conversations yet. Start a new conversation to begin messaging.';

  @override
  String get imageSavedToGallery => 'Image saved to gallery!';

  @override
  String failedToSaveImage(String error) {
    return 'Failed to save image: $error';
  }

  @override
  String get userProfile => 'User Profile';

  @override
  String get deletePost => 'Delete Post';

  @override
  String get loginRequired => 'Login Required';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get memberSince => 'Member Since';

  @override
  String get lastActivity => 'Last Activity';

  @override
  String get likesReceived => 'Likes Received';

  @override
  String get likesGiven => 'Likes Given';

  @override
  String get failedToSaveMessage => 'Failed to save message';

  @override
  String get failedToSaveSetting => 'Failed to save setting';

  @override
  String get failedToSavePost => 'Failed to save post';

  @override
  String errorLoadingSites(String error) {
    return 'Error loading sites: $error';
  }

  @override
  String connectingTo(String domainName) {
    return 'Connecting to $domainName...';
  }

  @override
  String get members => 'Members';

  @override
  String get allMembers => 'All Members';

  @override
  String get online => 'Online';

  @override
  String get noMembersFound => 'No members found';

  @override
  String get searchForMembers => 'Search for members';

  @override
  String get enterUsernameToFindMembers =>
      'Enter a username to find forum members';

  @override
  String get noMembersOnline => 'No members are currently online';

  @override
  String get lookupMembers => 'Lookup Members';

  @override
  String get addMembers => 'Add Members';

  @override
  String get membersAddedSuccessfully => 'Members added successfully';

  @override
  String errorAddingMembers(String error) {
    return 'Error adding members: $error';
  }

  @override
  String get failedToLoadOnlineUsers => 'Failed to load online users';

  @override
  String get noUsersOnline => 'No users online';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Members';
  }

  @override
  String get noSubject => 'No subject';

  @override
  String get search => 'Search';

  @override
  String get moreOptions => 'More options';

  @override
  String get logout => 'Logout';

  @override
  String get areYouSureYouWantToLogout => 'Are you sure you want to logout?';

  @override
  String get register => 'Register';

  @override
  String get signIn => 'Sign In';

  @override
  String get markForumRead => 'Mark Forum Read';

  @override
  String get notificationTest => 'Notification Test';

  @override
  String get forum => 'Forum';

  @override
  String get profile => 'Profile';

  @override
  String get messages => 'Messages';

  @override
  String get add => 'Add';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get retry => 'Retry';

  @override
  String get delete => 'Delete';

  @override
  String get deleteMessage => 'Delete Message';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'Are you sure you want to delete this message?';

  @override
  String failedToDeleteMessage(String error) {
    return 'Failed to delete message: $error';
  }

  @override
  String get deletingPost => 'Deleting post...';

  @override
  String failedToUnlikePost(String error) {
    return 'Failed to unlike post: $error';
  }

  @override
  String failedToLikePost(String error) {
    return 'Failed to like post: $error';
  }

  @override
  String get youNeedToBeSignedInToViewConversations =>
      'You need to be signed in to view your conversations.';

  @override
  String errorLoadingConversations(String error) {
    return 'Error loading conversations: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return 'Failed to leave conversation: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return 'Error loading more conversations: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'Error loading more messages: $error';
  }

  @override
  String get inviteMessageOptional => 'Invite Message (optional)';

  @override
  String get iWouldLikeToAddYouToThisConversation =>
      'I would like to add you to this conversation.';

  @override
  String get searchFailed => 'Search failed';

  @override
  String get trySearchingWithDifferentUsername =>
      'Try searching with a different username';

  @override
  String get enterUsernameToSearch => 'Enter username to search...';

  @override
  String get noSitesFound => 'No sites found.';

  @override
  String get userInformationNotAvailable => 'User information not available';

  @override
  String get birthday => 'Birthday';

  @override
  String get posts => 'Posts';

  @override
  String get following => 'Following';

  @override
  String get followers => 'Followers';

  @override
  String get about => 'About';

  @override
  String get location => 'Location';

  @override
  String get website => 'Website';

  @override
  String get signature => 'Signature';

  @override
  String get next => 'Next';

  @override
  String get permanent => 'Permanent';

  @override
  String get temporary => 'Temporary';

  @override
  String setBanDurationFor(String username) {
    return 'Set the ban duration for $username';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan =>
      'Please select an end date for temporary ban';

  @override
  String get back => 'Back';

  @override
  String get unban => 'Unban';

  @override
  String get confirm => 'Confirm';

  @override
  String spamClean(String username) {
    return 'Spam Clean $username';
  }

  @override
  String get selectActionsToPerform => 'Select the actions to perform:';

  @override
  String get handleThreads => 'Handle Threads';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Move or delete threads based on admin settings';

  @override
  String get deleteMessages => 'Delete Messages';

  @override
  String get deleteConversations => 'Delete Conversations';

  @override
  String get messageUpdatedSuccessfully => 'Message updated successfully';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return 'Failed to remove attachment: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'Failed to load message: $error';
  }

  @override
  String get editMessage => 'Edit Message';

  @override
  String get removeAttachment => 'Remove Attachment';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      'Are you sure you want to remove this attachment?';

  @override
  String get none => 'None';

  @override
  String get formatting => 'Formatting';

  @override
  String get bold => 'Bold';

  @override
  String get italic => 'Italic';

  @override
  String get underline => 'Underline';

  @override
  String get strikethrough => 'Strikethrough';

  @override
  String get link => 'Link';

  @override
  String get image => 'Image';

  @override
  String get video => 'Video';

  @override
  String get quote => 'Quote';

  @override
  String get code => 'Code';

  @override
  String get spoiler => 'Spoiler';

  @override
  String get bulletList => 'Bullet List';

  @override
  String get numberedList => 'Numbered List';

  @override
  String get listItem => 'List Item';

  @override
  String participants(int count) {
    return 'Participants ($count)';
  }

  @override
  String get enterKeywordsToSearchTopics =>
      'Enter keywords to search topics...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Please fill in all required fields';

  @override
  String get undelete => 'Undelete';

  @override
  String get signInToViewUnreadTopics => 'Sign in to view unread topics';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'You need to be signed in to view your unread topics.';

  @override
  String get signInToViewSubscribedTopics =>
      'Sign in to view subscribed topics';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'You need to be signed in to view your subscribed topics.';

  @override
  String get signInToViewParticipatedTopics =>
      'Sign in to view participated topics';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'You need to be signed in to view topics you have participated in.';

  @override
  String get signInToViewLatestTopics => 'Sign in to view latest topics';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'You need to be signed in to view latest topics.';

  @override
  String get markAsUnread => 'Mark as unread';

  @override
  String get invite => 'Invite';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToAccessYourProfile =>
      'Sign in to access your profile and manage your account';

  @override
  String get enterYourUsername => 'Enter your username';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get refresh => 'Refresh';

  @override
  String get share => 'Share';

  @override
  String get viewOnWeb => 'View on Web';

  @override
  String get unlock => 'Unlock';

  @override
  String get lock => 'Lock';

  @override
  String get stick => 'Stick';

  @override
  String get unstick => 'Unstick';

  @override
  String get reply => 'Reply';

  @override
  String get vote => 'Vote';

  @override
  String votesCount(int count) {
    return '$count votes';
  }

  @override
  String get pollClosed => 'Poll closed';

  @override
  String pollEndsOn(String date) {
    return 'Ends $date';
  }

  @override
  String get voteToSeeResults => 'Vote to see results';

  @override
  String get viewFullPoll => 'View full poll';

  @override
  String pollOptionsCount(int count) {
    return '$count options';
  }

  @override
  String get reactedBy => 'Reacted by';

  @override
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count likes',
      one: '$count like',
    );
    return '$_temp0';
  }

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reactions',
      one: '$count reaction',
    );
    return '$_temp0';
  }

  @override
  String get showWhoReacted => 'Tap to see who reacted.';

  @override
  String get react => 'React';

  @override
  String get changeYourReaction => 'Change your reaction';

  @override
  String get reactionsAll => 'All';

  @override
  String get reactionYou => 'You';

  @override
  String reactionFilterSemantics(String reaction, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$reaction, $count people',
      one: '$reaction, $count person',
    );
    return '$_temp0';
  }

  @override
  String viewProfileOfUser(String username) {
    return 'View profile of $username';
  }

  @override
  String get enterKeywordsToFindTopicsAndPosts =>
      'Enter keywords to find topics and posts';

  @override
  String get enterKeywordsOrDomainToFindForums =>
      'Enter keywords or domain to find forums';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'Enter keywords or domain names to find forums';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get followSystemLanguage => 'Follow system language';

  @override
  String get appearance => 'Appearance';

  @override
  String get followSystemTheme => 'Follow system theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String version(String version, String buildNumber) {
    return 'version $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'Forum Settings';

  @override
  String get noSettingsAvailable => 'No settings available';

  @override
  String get settingsCategoriesWillAppearHere =>
      'Settings categories will appear here when available.';

  @override
  String get spamCleaner => 'Spam Cleaner';

  @override
  String get unableToLoadProfile => 'Unable to Load Profile';

  @override
  String get banned => 'BANNED';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get showMore => 'Show More';

  @override
  String get reportUser => 'Report User';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get reportSubmittedSuccessfully => 'Report submitted successfully';

  @override
  String get failedToSubmitReport => 'Failed to submit report';

  @override
  String get searchForForums => 'Search for forums';

  @override
  String get searchForums => 'Search Forums';

  @override
  String get deleteTopic => 'Delete Topic';

  @override
  String get softDelete => 'Soft Delete';

  @override
  String get topicCanBeRestoredLater => 'Topic can be restored later';

  @override
  String get hardDelete => 'Hard Delete';

  @override
  String get topicWillBePermanentlyDeleted =>
      'Topic will be permanently deleted';

  @override
  String get reasonForDeletion => 'Reason for deletion';

  @override
  String get enterReasonForDeletingTopic =>
      'Enter the reason for deleting this topic';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Please enter a reason for deletion';

  @override
  String get pleaseSelectEndDate => 'Please select an end date';

  @override
  String get banUser => 'Ban User';

  @override
  String get userBannedSuccessfully => 'User banned successfully';

  @override
  String get failedToBanUser => 'Failed to ban user';

  @override
  String get userUnbannedSuccessfully => 'User unbanned successfully';

  @override
  String get failedToUnbanUser => 'Failed to unban user';

  @override
  String get spamCleanUser => 'Spam Clean User';

  @override
  String get deletePrivateConversations => 'Delete private conversations';

  @override
  String get banTheUserAccount => 'Ban the user account';

  @override
  String get cleanSpam => 'Clean Spam';

  @override
  String get handledThreads => 'Handled threads';

  @override
  String get deletedMessages => 'Deleted messages';

  @override
  String get deletedConversations => 'Deleted conversations';

  @override
  String get bannedUser => 'Banned user';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return 'Successfully cleaned spam for $username. Actions: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'Error loading message: $error';
  }

  @override
  String get messageNotFound => 'Message not found';

  @override
  String get home => 'Home';

  @override
  String get notifications => 'Notifications';

  @override
  String get forums => 'Forums';

  @override
  String get markAllForumsAsRead => 'Mark All Forums as Read?';

  @override
  String get markAllForumsAsReadMessage =>
      'This will mark all forums and topics as read. This action cannot be undone.';

  @override
  String get markAsRead => 'Mark as Read';

  @override
  String get content => 'Content';

  @override
  String get insertImage => 'Insert Image';

  @override
  String get howWouldYouLikeToInsertImage =>
      'How would you like to insert this image?';

  @override
  String get thumbnail => 'Thumbnail';

  @override
  String get fullSize => 'Full Size';

  @override
  String get alignLeft => 'Align Left';

  @override
  String get alignCenter => 'Align Center';

  @override
  String get alignRight => 'Align Right';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get pleaseEnterContent => 'Please enter some content';

  @override
  String get uploading => 'Uploading...';

  @override
  String get uploaded => 'Uploaded';

  @override
  String get mentionUser => 'Mention User';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get submittingReport => 'Submitting report...';

  @override
  String get banningUser => 'Banning user...';

  @override
  String get unbanningUser => 'Unbanning user...';

  @override
  String get cleaningSpam => 'Cleaning spam...';

  @override
  String get enterSubject => 'Enter subject';

  @override
  String get typeYourMessageHere => 'Type your message here';

  @override
  String get writeYourMessage => 'Write your message...';

  @override
  String get writeYourReply => 'Write your reply...';

  @override
  String get messageSentSuccessfully => 'Message sent successfully';

  @override
  String get replySentSuccessfully => 'Reply sent successfully';

  @override
  String get conversationCreatedSuccessfully =>
      'Conversation created successfully';

  @override
  String get conversationMarkedAsUnread => 'Conversation marked as unread';

  @override
  String get messageMarkedAsUnread => 'Message marked as unread';

  @override
  String get conversationClosed => 'Conversation closed';

  @override
  String get conversationOpened => 'Conversation opened';

  @override
  String get pleaseLoginToLikeMessages => 'Please login to like messages';

  @override
  String get loadEarlierMessages => 'Load Earlier Messages';

  @override
  String failedToLoadQuote(String error) {
    return 'Failed to load quote: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'Failed to upload file: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Failed to upload image: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'Failed to send message: $error';
  }

  @override
  String failedToSendReply(String error) {
    return 'Failed to send reply: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'Failed to mark message as unread: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return 'Failed to mark conversation as unread: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return 'Failed to close conversation: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return 'Failed to open conversation: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'Failed to jump to message: $error';
  }

  @override
  String get goToTop => 'Go to top';

  @override
  String get goToBottom => 'Go to bottom';

  @override
  String get replyAll => 'Reply All';

  @override
  String get forward => 'Forward';

  @override
  String get noForumsFound => 'No forums found.';

  @override
  String get pleaseSelectPrefix => 'Please select a prefix';

  @override
  String get pleaseLoginToAccessContent =>
      'Please login to access this content and interact with posts.';

  @override
  String get searchUsers => 'Search users...';

  @override
  String get writeYourTitle => 'Write your title...';

  @override
  String get writeYourContent => 'Write your content...';

  @override
  String get selectAnOption => 'Select an option';

  @override
  String get enterConversationTitle => 'Enter conversation title';

  @override
  String enterCode(int count) {
    return 'Enter $count-digit code';
  }

  @override
  String get edit => 'Edit';

  @override
  String get report => 'Report';

  @override
  String get unfollow => 'Unfollow';

  @override
  String get follow => 'Follow';

  @override
  String get remove => 'Remove';

  @override
  String get subject => 'Subject';

  @override
  String get message => 'Message';

  @override
  String get titleCannotBeEmpty => 'Title cannot be empty';

  @override
  String get conversationUpdatedSuccessfully =>
      'Conversation updated successfully';

  @override
  String get goBack => 'Go Back';

  @override
  String get signInToViewMessages => 'Sign in to view messages';

  @override
  String get privateMessagesNotAvailable => 'Private messages not available';

  @override
  String failedToLoadPost(String error) {
    return 'Failed to load post: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'Failed to $action message: $error';
  }

  @override
  String get like => 'like';

  @override
  String get unlike => 'unlike';

  @override
  String get optimizeImage => 'Optimize Image';

  @override
  String get optimizeAndUpload => 'Optimize and Upload';

  @override
  String downloading(String filename) {
    return 'Downloading $filename...';
  }

  @override
  String openingShareSheet(String filename) {
    return 'Opening share sheet for $filename';
  }

  @override
  String errorDownloading(String filename, String error) {
    return 'Error downloading $filename: $error';
  }

  @override
  String get enterANumber => 'Enter a number';

  @override
  String get failedToNavigateToForum => 'Failed to navigate to forum';

  @override
  String failedToNavigateToForumName(String forumName) {
    return 'Failed to navigate to $forumName';
  }

  @override
  String get failedToSaveConversation => 'Failed to save conversation';

  @override
  String forumNotFound(String forumName) {
    return 'Forum not found: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'Forum not found: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'Could not open link: $error';
  }

  @override
  String get likePost => 'Like post';

  @override
  String get unlikePost => 'Unlike post';

  @override
  String get showLikes => 'Show likes';

  @override
  String get quotePost => 'Quote post';

  @override
  String get attachFile => 'Attach file';

  @override
  String get uploadImage => 'Upload image';

  @override
  String get translate => 'Translate';

  @override
  String get showOriginal => 'Show Original';

  @override
  String get translating => 'Translating...';

  @override
  String get translated => 'Translated';

  @override
  String get translatedContent => 'Translated content';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get translateTo => 'Translate to:';

  @override
  String get deviceLanguage => 'Device language';

  @override
  String get noPostsToTranslate => 'No posts to translate';

  @override
  String get translationFailed => 'Translation failed';

  @override
  String get twoFactorAuthentication => 'Two-Factor Authentication';

  @override
  String get authenticationCodeLabel => 'Authentication Code';

  @override
  String get pleaseEnterYourAuthenticationCode =>
      'Please enter your authentication code';

  @override
  String codeMustBeDigits(int count) {
    return 'Code must be $count digits';
  }

  @override
  String get codeMustContainOnlyNumbers => 'Code must contain only numbers';

  @override
  String get verifyButton => 'Verify';

  @override
  String get attachments => 'Attachments';

  @override
  String get replyOptions => 'Reply Options';

  @override
  String get replyWithQuote => 'Reply with Quote';

  @override
  String fileSavedToDownloads(String filename) {
    return 'File saved to Downloads: $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'File saved to Documents: $filename';
  }

  @override
  String get discardPostQuestion => 'Do you want to discard your post?';

  @override
  String get discardChangesQuestion => 'Do you want to discard your changes?';

  @override
  String get discard => 'Discard';

  @override
  String get discardChanges => 'Discard changes';

  @override
  String get notificationsTab => 'Alerts';

  @override
  String get postAwaitingApproval =>
      'Your post will appear once a moderator approves it.';

  @override
  String get reactionHoldHint => 'Long press for more reactions';

  @override
  String get turnOnNotifications => 'Turn on notifications';

  @override
  String get notNow => 'Not now';

  @override
  String neverMissAReplyOn(Object forumName) {
    return 'Never miss a reply on $forumName';
  }

  @override
  String get notificationPreviewNow => 'now';

  @override
  String get notificationPreviewEarlier => '5m ago';

  @override
  String get notificationPreviewReply =>
      'Jane replied to you: Welcome aboard! Glad you found us.';

  @override
  String get notificationPreviewMessage =>
      'Sam sent you a message: Are you coming on Friday?';

  @override
  String get notificationsAreTurnedOffForThisApp =>
      'Notifications are turned off for this app';

  @override
  String get deviceWillNotShowAlertsUntilAllowedInSettings =>
      'Your device will not show alerts until you allow notifications in Settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get notificationsPitchForum =>
      'Replies, mentions and direct messages, on your lock screen as they happen.';

  @override
  String get viewProfile => 'View profile';

  @override
  String get settings => 'Settings';

  @override
  String get signOut => 'Sign out';

  @override
  String get changeEmail => 'Change email';

  @override
  String get changePassword => 'Change password';

  @override
  String get save => 'Save';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get newEmailAddress => 'New email address';

  @override
  String get emailChanged => 'Email address changed';

  @override
  String get emailChangeConfirm =>
      'Check your inbox: the new address takes effect once you confirm it.';

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get account => 'Account';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get connectionErrorTitle => 'Connection Error';

  @override
  String get authenticationErrorTitle => 'Authentication Error';

  @override
  String get permissionErrorTitle => 'Permission Error';

  @override
  String get errorNoConnection =>
      'No internet connection. Please check your network settings.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorServer => 'Server error occurred. Please try again later.';

  @override
  String get errorNetwork => 'Network error occurred. Please try again.';

  @override
  String get errorInvalidCredentials => 'Invalid username or password.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get errorAccountLocked =>
      'Your account has been locked. Please contact support.';

  @override
  String get errorAuthFailed => 'Authentication failed. Please try again.';

  @override
  String get errorForumNotFound => 'Forum not found.';

  @override
  String get errorForumAccessDenied =>
      'You do not have permission to access this forum.';

  @override
  String get errorForumUnavailable =>
      'Forum is currently unavailable. Please try again later.';

  @override
  String get errorForumGeneric => 'Forum error occurred. Please try again.';

  @override
  String get errorDataNotFound => 'Requested data not found.';

  @override
  String get errorDataCorrupted =>
      'Data appears to be corrupted. Please refresh the page.';

  @override
  String get errorCache => 'Failed to load cached data. Please try again.';

  @override
  String get errorInvalidInput => 'Something you entered is not valid.';

  @override
  String get errorRequiredField => 'Please fill in all required fields.';

  @override
  String get errorPermissionDenied => 'You do not have permission to do that.';

  @override
  String errorFeatureNotAvailable(String feature) {
    return '$feature is not available on this forum.';
  }

  @override
  String get errorStorageFull => 'Storage is full. Please free up some space.';

  @override
  String get errorStorageAccessDenied =>
      'Storage access denied. Please check app permissions.';

  @override
  String get loginInfo => 'Login Info';

  @override
  String get loginFailed => 'Login Failed';

  @override
  String get topicAnnouncement => 'Announcement';

  @override
  String get topicPinned => 'Pinned';

  @override
  String get topicLocked => 'Locked';

  @override
  String get topicPoll => 'Poll';

  @override
  String get deletedBadge => 'DELETED';

  @override
  String get protectedBadge => 'Protected';

  @override
  String get lockTopic => 'Lock Topic';

  @override
  String get unlockTopic => 'Unlock Topic';

  @override
  String get lockTopicConfirm =>
      'Are you sure you want to lock this topic? Other users will not be able to reply or interact with it.';

  @override
  String get unlockTopicConfirm =>
      'Are you sure you want to unlock this topic? Other users will be able to reply and interact with it again.';

  @override
  String get stickTopic => 'Stick Topic';

  @override
  String get unstickTopic => 'Unstick Topic';

  @override
  String get stickTopicConfirm =>
      'Are you sure you want to stick this topic? It will appear at the top of the forum for all users.';

  @override
  String get unstickTopicConfirm =>
      'Are you sure you want to unstick this topic? It will no longer appear at the top of the forum.';

  @override
  String get undeleteTopic => 'Undelete Topic';

  @override
  String get undeleteTopicConfirm =>
      'Are you sure you want to undelete this topic? It will be visible to other users again.';

  @override
  String get additionalInformation => 'Additional Information';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get selectDateOfBirth => 'Select date of birth';

  @override
  String minimumAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Minimum age: $age years',
      one: 'Minimum age: $age year',
    );
    return '$_temp0';
  }

  @override
  String get locationIsRequired => 'Location is required';

  @override
  String get receiveSiteMailings => 'Receive site mailings';

  @override
  String iAcceptTheDocument(String document) {
    return 'I accept the $document';
  }

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get imageExceedsUploadLimits =>
      'This image exceeds the upload limits and needs to be optimized:';

  @override
  String get originalSize => 'Original Size';

  @override
  String get originalDimensions => 'Original Dimensions';

  @override
  String get optimizationsToBeApplied => 'Optimizations to be applied:';

  @override
  String get resizeImage => 'Resize';

  @override
  String get convertFormat => 'Convert Format';

  @override
  String get smallerFileSize => 'smaller file size';

  @override
  String get formatNotSupported => 'format not supported';

  @override
  String get convertToJpgReason =>
      'Convert to JPG (format not supported or for size reduction)';

  @override
  String get compressImage => 'Compress';

  @override
  String compressQuality(int quality) {
    return 'Quality: $quality% to meet size limit';
  }

  @override
  String get estimatedFinalSize => 'Estimated Final Size';

  @override
  String sizeReduction(String percent) {
    return 'Reduction: $percent%';
  }

  @override
  String get pleaseLoginToCreateTopic => 'Please log in to create a new topic';

  @override
  String get pleaseLoginToSubscribeForums =>
      'Please log in to subscribe to forums';

  @override
  String get pleaseLoginToUnsubscribeForums =>
      'Please log in to unsubscribe from forums';

  @override
  String errorLoadingContent(String error) {
    return 'Error loading content: $error';
  }

  @override
  String get noPermissionToViewSubforumTopics =>
      'You do not have permission to view topics in this subforum.';

  @override
  String get noDiscussionsYet => 'No discussions yet.';

  @override
  String get unableToLoadForums => 'Unable to Load Forums';

  @override
  String get noForumsAvailable => 'No Forums Available';

  @override
  String get noForumsToDisplay =>
      'There are no forums to display. This might be due to permissions or the forum structure.';

  @override
  String get subscribedForums => 'Subscribed Forums';

  @override
  String get allForumTopicsMarkedRead =>
      'All forum topics have been marked as read';

  @override
  String postsCountFormatted(String count) {
    return '$count Posts';
  }

  @override
  String get jumpToPost => 'Jump to Post';

  @override
  String get jump => 'Jump';

  @override
  String get endOfDiscussion => 'End of the discussion';

  @override
  String refreshFailed(String error) {
    return 'Refresh failed: $error';
  }

  @override
  String get topicDeletedHidden =>
      'This topic is deleted and hidden from other users';

  @override
  String get topicClosedNoReplies =>
      'This topic is closed and no longer accepting replies';

  @override
  String get youAreSubscribedToTopic => 'You are subscribed to this topic';

  @override
  String get refreshing => 'Refreshing...';

  @override
  String get unableToLoadForumsTryAgain =>
      'Unable to load forums. Please try again.';

  @override
  String get noPostableForums => 'No postable forums are available.';

  @override
  String get changeForumQuestion => 'Change forum?';

  @override
  String get changeForumRemovesAttachments =>
      'Changing the forum will remove your uploaded attachments because attachments are tied to the selected forum.';

  @override
  String get changeForum => 'Change Forum';

  @override
  String get chooseForumBeforePosting => 'Please choose a forum before posting';

  @override
  String get accountCannotUploadAttachments =>
      'Your account cannot upload attachments on this site.';

  @override
  String get forumNoAttachments => 'This forum does not allow attachments.';

  @override
  String get forumNoAttachmentsChooseAnother =>
      'This forum does not allow attachments. Choose a different forum to upload the shared files.';

  @override
  String get forumNoAttachmentsSharedPending =>
      'This forum does not allow attachments. Shared files will stay pending until you choose another forum.';

  @override
  String get tapToChangeForum => 'Tap to change forum';

  @override
  String get chooseWhichForum => 'Choose which forum to post to';

  @override
  String get selectAForum => 'Select a forum';

  @override
  String get unableToLoadForumsNow => 'Unable to load forums right now.';

  @override
  String get pickForumBeforeUploading =>
      'Pick a forum before uploading attachments or posting.';

  @override
  String get uploadingSharedFiles => 'Uploading shared files...';

  @override
  String get selectForum => 'Select Forum';

  @override
  String get noForumsMatchSearch => 'No forums match your search.';

  @override
  String get unknown => 'Unknown';

  @override
  String get closeConversationConfirm =>
      'Are you sure you want to close this conversation? This will prevent new replies from being posted.';

  @override
  String get openConversationConfirm =>
      'Are you sure you want to open this conversation? This will allow new replies to be posted.';

  @override
  String get leaveConversationConfirm =>
      'Are you sure you want to leave this conversation? This will hide it from your inbox.';

  @override
  String get close => 'Close';

  @override
  String get open => 'Open';

  @override
  String get leave => 'Leave';

  @override
  String errorLoadingConversation(String error) {
    return 'Error loading conversation: $error';
  }

  @override
  String get conversationNotFound => 'Conversation not found';

  @override
  String get conversationClosedNoReplies =>
      'This conversation is closed and no longer accepting replies';

  @override
  String get noMessagesFound => 'No messages found';

  @override
  String get endOfConversation => 'End of conversation';

  @override
  String get jumpToMessage => 'Jump to Message';

  @override
  String get jumpToFirstMessage => 'Jump to first message';

  @override
  String get jumpToLastMessage => 'Jump to last message';

  @override
  String messagePositionOf(int position, int total) {
    return 'Message $position of $total';
  }

  @override
  String get tapToJumpToMessage => 'Tap to jump to a specific message';

  @override
  String failedToReact(String error) {
    return 'Failed to react: $error';
  }

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants',
      one: '$count participant',
    );
    return '$_temp0';
  }

  @override
  String get noImagesToDisplay => 'No images found to display.';

  @override
  String get pleaseLoginToViewAttachment =>
      'Please log in to view this attachment';

  @override
  String get inbox => 'Inbox';

  @override
  String get sent => 'Sent';

  @override
  String errorLoadingMessages(String error) {
    return 'Error loading messages: $error';
  }

  @override
  String get noInboxMessages => 'No inbox messages';

  @override
  String get noSentMessages => 'No sent messages';

  @override
  String get unknownDate => 'Unknown date';

  @override
  String get searchForTopics => 'Search for topics';

  @override
  String get noTopicsFound => 'No topics found';

  @override
  String get noPostsFound => 'No posts found';

  @override
  String get trySearchingDifferentKeywords =>
      'Try searching with different keywords';

  @override
  String errorLoadingSettings(String error) {
    return 'Error loading settings: $error';
  }

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String valueMustBeAtLeast(String min) {
    return 'Value must be at least $min';
  }

  @override
  String valueMustBeAtMost(String max) {
    return 'Value must be at most $max';
  }

  @override
  String maximumLengthCharacters(int max) {
    return 'Maximum length is $max characters';
  }

  @override
  String get invalidFormat => 'Invalid format';

  @override
  String get shareToForumCopilot => 'Share to Forum Copilot';

  @override
  String get noSavedForumAccounts => 'No saved forum accounts found.';

  @override
  String get addForumAccountFirst =>
      'Add a forum account in Forum Copilot first, then try sharing again.';

  @override
  String filesReadyToAttach(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files ready to attach',
      one: '$count file ready to attach',
    );
    return '$_temp0';
  }

  @override
  String get sharedTextWillBePrefilled => 'Shared text will be prefilled';

  @override
  String errorSearchingForums(String error) {
    return 'Error searching forums: $error';
  }

  @override
  String failedToLoadUserInfo(String error) {
    return 'Failed to load user info: $error';
  }

  @override
  String areYouSureUnban(String username) {
    return 'Are you sure you want to unban $username?';
  }

  @override
  String get deletePostsProfilePostsComments =>
      'Delete posts, profile posts, and comments';

  @override
  String areYouSureSpamClean(String username) {
    return 'Are you sure you want to spam clean $username?';
  }

  @override
  String successfullyCleanedSpamFor(String username) {
    return 'Successfully cleaned spam for $username';
  }

  @override
  String get failedToCleanSpam => 'Failed to clean spam';

  @override
  String imagesCount(int count) {
    return 'Images ($count)';
  }

  @override
  String get pleaseLoginToViewProfiles =>
      'Please log in to view user profiles.';

  @override
  String get tapToOpen => 'Tap to open';

  @override
  String get imageNotAvailable => 'Image not available';

  @override
  String get tapToViewFullSizeImage => 'Tap to view full size image';

  @override
  String get loadingImage => 'Loading image...';

  @override
  String loadingImageFrom(String host) {
    return 'Loading image from $host';
  }

  @override
  String get tapToReveal => '(tap to reveal)';

  @override
  String get inlineAttachments => 'Inline Attachments';

  @override
  String get thisFieldIsRequired => 'This field is required';

  @override
  String get pleaseEnterValidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get pleaseEnterValidUrl => 'Please enter a valid URL';

  @override
  String get permissionDeniedToSaveImage => 'Permission denied to save image';

  @override
  String get postNotFound => 'Post not found.';

  @override
  String get failedToUploadFileTryAgain =>
      'Failed to upload file. Please try again.';

  @override
  String get failedToPickFile => 'Failed to pick file';

  @override
  String onlyMoreAttachmentsAllowed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Only $count more attachments allowed. Using the first $count images.',
      one: 'Only 1 more attachment allowed. Using the first image.',
    );
    return '$_temp0';
  }

  @override
  String get attachmentLimitReachedSkipping =>
      'Attachment limit reached. Skipping remaining images.';

  @override
  String get imageValidationFailed => 'Image validation failed';

  @override
  String get imageUploadFailed => 'Failed to upload image';

  @override
  String get failedToUploadImageTryAgain =>
      'Failed to upload image. Please try again.';

  @override
  String get failedToPickImage => 'Failed to pick image';

  @override
  String get prefix => 'Prefix';

  @override
  String get failedToLoadPrefixes => 'Failed to load prefixes';

  @override
  String get attachFileHint => 'Attach a file to this message';

  @override
  String get uploadImageHint => 'Upload an image to this message';

  @override
  String get openFormattingOptions => 'Open formatting options';

  @override
  String get failedToPostReply => 'Failed to post reply. Please try again.';

  @override
  String get failedToUpdatePost => 'Failed to update post. Please try again.';

  @override
  String get postDeletedSuccessfully => 'Post deleted successfully';

  @override
  String failedToDeletePost(String error) {
    return 'Failed to delete post: $error';
  }

  @override
  String get noPermissionToUploadAvatars =>
      'You do not have permission to upload avatars';

  @override
  String get avatarUploadedSuccessfully => 'Avatar uploaded successfully';

  @override
  String get unknownTopic => 'Unknown Topic';

  @override
  String get connectionTimeoutTitle => 'Connection Timeout';

  @override
  String connectionTimedOutTo(String siteName) {
    return 'The connection to $siteName timed out. Please check your internet connection and try again.';
  }

  @override
  String failedToConnectCheckPlugin(String siteName) {
    return 'Failed to connect to $siteName. Please check if the forum is available and the plugin is installed.';
  }

  @override
  String get voteFailedTryAgain => 'Vote failed. Please try again.';

  @override
  String get noUserSpecified => 'No user specified';

  @override
  String get failedToLoadRecentPosts => 'Failed to load recent posts';

  @override
  String failedToLoadPreview(String error) {
    return 'Failed to load preview: $error';
  }

  @override
  String thanksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Thanked by $count people',
      one: 'Thanked by $count person',
    );
    return '$_temp0';
  }

  @override
  String get thankedBy => 'Thanked By';

  @override
  String maximumAttachmentsAllowed(int count) {
    return 'Maximum of $count attachment(s) allowed';
  }

  @override
  String get toLabel => 'To';

  @override
  String get closeConversation => 'Close conversation';

  @override
  String get openConversation => 'Open conversation';

  @override
  String get loginSucceeded => 'Login succeeded';

  @override
  String get verificationErrorTryAgain =>
      'An error occurred during verification. Please try again.';

  @override
  String get passkeyChallengeFailed => 'Passkey sign-in could not be started.';

  @override
  String get passkeyNotSetUp =>
      'This forum is not yet set up for passkey access on this app. Please sign in with your username and password.';

  @override
  String get noPasskeyForForum =>
      'No passkey found for this forum. Sign in with your password, or create a passkey on the forum website first.';

  @override
  String get pushNotificationsNotReady =>
      'Push notifications are not ready yet';

  @override
  String pushEnabledFor(String siteName) {
    return 'Push notifications enabled for $siteName';
  }

  @override
  String get failedToEnablePush => 'Failed to enable push notifications';

  @override
  String get failedToRegisterPush =>
      'Failed to register for push notifications';

  @override
  String translatedFromTo(String source, String target) {
    return 'Translated from $source to $target';
  }

  @override
  String get unableToOpenNotification => 'Unable to open notification';

  @override
  String get notificationMissingInfo =>
      'This notification is missing information.';

  @override
  String get couldNotOpenForum => 'Could not open the forum.';

  @override
  String get notificationChannelName => 'Forum Copilot Notifications';

  @override
  String get notificationChannelDescription =>
      'Notifications for Forum Copilot app';

  @override
  String fileTypeNotAllowed(String extension, String allowed) {
    return 'File type .$extension is not allowed. Allowed types: $allowed';
  }

  @override
  String fileSizeExceedsMaximum(String size, String max) {
    return 'File size ($size) exceeds the maximum of $max';
  }

  @override
  String get fileTypeAudio => 'Audio';

  @override
  String get fileTypeText => 'Text';

  @override
  String get fileTypeArchive => 'Archive';

  @override
  String get fileTypeFile => 'File';

  @override
  String get imageFileNotFound =>
      'Image file not found. The file may have been moved or deleted.';

  @override
  String get imagePermissionDenied =>
      'Permission denied. Cannot read the image file.';

  @override
  String get imageInsufficientSpace =>
      'Insufficient disk space to optimize the image.';

  @override
  String cannotAccessImageFile(String error) {
    return 'Cannot access image file: $error';
  }

  @override
  String get imageFormatUnsupported =>
      'Image format is corrupted or not supported. Please try a different image.';

  @override
  String get failedToResizeImage =>
      'Failed to resize image. The image may be corrupted or in an unsupported format.';

  @override
  String get failedToConvertImageToJpg =>
      'Failed to convert image to JPG format. The image may be corrupted.';

  @override
  String get failedToCompressImage =>
      'Failed to compress image. There may be insufficient disk space or the image is corrupted.';

  @override
  String get cannotDecodeImage =>
      'Cannot decode image. The file may be corrupted or in an unsupported format.';

  @override
  String get cannotReadImageFile =>
      'Cannot read image file. The file may have been moved or deleted.';

  @override
  String failedToOptimizeImage(String error) {
    return 'Failed to optimize image: $error';
  }

  @override
  String emailCopiedToClipboard(String email) {
    return 'Email copied to clipboard: $email';
  }

  @override
  String couldNotOpenEmail(String email) {
    return 'Could not open email: $email';
  }

  @override
  String get editPost => 'Edit Post';

  @override
  String get thisTopicIsPinnedToTopOfForum =>
      'This topic is pinned to the top of the forum';

  @override
  String get editConversation => 'Edit conversation';

  @override
  String get failedToLoadConversation => 'Failed to load conversation';

  @override
  String get cannotEditConversation => 'Cannot edit this conversation';

  @override
  String get titleLabel => 'Title';

  @override
  String get options => 'Options';

  @override
  String get openInvite => 'Open Invite';

  @override
  String get allowAnyParticipantToInviteOthers =>
      'Allow any participant to invite others';

  @override
  String get conversationOpen => 'Conversation Open';

  @override
  String failedToCreateConversation(String error) {
    return 'Failed to create conversation: $error';
  }

  @override
  String get lockConversation => 'Lock Conversation';

  @override
  String get createConversationAsClosed =>
      'Create conversation as closed (no replies allowed)';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountDescription => 'Remove your account from this forum.';

  @override
  String get deleteAccountContactForumMessage =>
      'Your account is managed by the forum. Please contact the forum directly for account removal. Use the Contact Us button at the bottom of the forum home page.';

  @override
  String get forumUrlUnavailable => 'Forum URL is unavailable.';

  @override
  String get couldNotOpenForumUrl => 'Could not open forum URL.';

  @override
  String get noActionUrlAvailableForThisNotificationType =>
      'No action URL available for this notification type.';

  @override
  String get signInToViewNotifications => 'Sign in to view notifications';

  @override
  String get youNeedToBeSignedInToViewYourNotifications =>
      'You need to be signed in to view your notifications.';

  @override
  String get errorLoadingNotifications => 'Error loading notifications';

  @override
  String get pullDownToRefresh => 'Pull down to refresh';

  @override
  String get youHaveNoNewNotificationsCheckBackLater =>
      'You have no new notifications. Check back later for updates on topics you\'re following.';

  @override
  String get signInToViewProfile => 'Sign in to view profile';

  @override
  String get youNeedToBeSignedInToViewYourProfile =>
      'You need to be signed in to view your profile.';

  @override
  String get emailLabel => 'Email';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get protectedForum => 'Protected Forum';

  @override
  String forumIsPasswordProtected(String forumName) {
    return '$forumName is password protected.';
  }

  @override
  String get enterButton => 'Enter';

  @override
  String get recentPosts => 'Recent Posts';

  @override
  String passkeyNotAvailableInForum(int code) {
    return 'Passkey is currently not available in this forum (code: $code)';
  }

  @override
  String get initializingForum => 'Initializing forum…';

  @override
  String get retryConnection => 'Retry Connection';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get pleaseEnterTheForumPassword => 'Please enter the forum password';

  @override
  String get editYourPost => 'Edit your post...';

  @override
  String get topicIdIsMissingCannotNavigateToThePost =>
      'Topic ID is missing. Cannot navigate to the post.';

  @override
  String get conversationIsOpenForReplies => 'Conversation is open for replies';

  @override
  String get conversationIsClosedNoRepliesAllowed =>
      'Conversation is closed (no replies allowed)';

  @override
  String get pleaseEnterAUsername => 'Please enter a username';

  @override
  String usernameMinLength(int count) {
    return 'Username must be at least $count characters';
  }

  @override
  String get pleaseEnterAPassword => 'Please enter a password';

  @override
  String passwordMinLength(int count) {
    return 'Password must be at least $count characters';
  }

  @override
  String get writeYourTopicTitle => 'Write your topic title...';

  @override
  String get writeYourTopicContent => 'Write your topic content...';

  @override
  String pushDisabledFor(String siteName) {
    return 'Push notifications disabled for $siteName';
  }

  @override
  String get failedToDisablePush => 'Failed to disable push notifications';

  @override
  String get thisForum => 'this forum';
}

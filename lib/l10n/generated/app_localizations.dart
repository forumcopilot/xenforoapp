import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Forum App'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @signInWithPasskey.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Passkey'**
  String get signInWithPasskey;

  /// No description provided for @usePasskey.
  ///
  /// In en, this message translates to:
  /// **'Use Passkey'**
  String get usePasskey;

  /// No description provided for @passkeyContinuePrompt.
  ///
  /// In en, this message translates to:
  /// **'Use your passkey to continue'**
  String get passkeyContinuePrompt;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get pleaseEnterUsername;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Message about credentials being sent to forum domain
  ///
  /// In en, this message translates to:
  /// **'Your username and password will be sent to {domain}'**
  String credentialsSentToDomain(String domain);

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @registrationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Registration Not Available'**
  String get registrationNotAvailable;

  /// No description provided for @registrationNotAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Registration is currently not available. The forum may be closed or registration may be disabled.'**
  String get registrationNotAvailableMessage;

  /// No description provided for @webRegistrationRequired.
  ///
  /// In en, this message translates to:
  /// **'Web Registration Required'**
  String get webRegistrationRequired;

  /// No description provided for @webRegistrationRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'This forum requires registration through the web browser. Please click the button below to open the registration page.'**
  String get webRegistrationRequiredMessage;

  /// No description provided for @openRegistrationPage.
  ///
  /// In en, this message translates to:
  /// **'Open Registration Page'**
  String get openRegistrationPage;

  /// No description provided for @loadingAdditionalFields.
  ///
  /// In en, this message translates to:
  /// **'Loading additional fields...'**
  String get loadingAdditionalFields;

  /// No description provided for @pleaseSelectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get pleaseSelectDateOfBirth;

  /// No description provided for @pleaseEnterLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your location'**
  String get pleaseEnterLocation;

  /// No description provided for @pleaseIndicateEmailPreference.
  ///
  /// In en, this message translates to:
  /// **'Please indicate your email preference'**
  String get pleaseIndicateEmailPreference;

  /// No description provided for @pleaseFillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get pleaseFillAllRequiredFields;

  /// No description provided for @pleaseAcceptTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms of Service'**
  String get pleaseAcceptTermsOfService;

  /// No description provided for @pleaseAcceptPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Privacy Policy'**
  String get pleaseAcceptPrivacyPolicy;

  /// No description provided for @registrationError.
  ///
  /// In en, this message translates to:
  /// **'Registration Error'**
  String get registrationError;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please check your information.'**
  String get registrationFailed;

  /// No description provided for @registrationFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailedTryAgain;

  /// No description provided for @registrationInfo.
  ///
  /// In en, this message translates to:
  /// **'Registration Info'**
  String get registrationInfo;

  /// No description provided for @openWebsite.
  ///
  /// In en, this message translates to:
  /// **'Open Website'**
  String get openWebsite;

  /// Error message when cannot open forum website
  ///
  /// In en, this message translates to:
  /// **'Could not open the forum website. Please try visiting: {url}'**
  String couldNotOpenForumWebsite(String url);

  /// No description provided for @registrationSuccessfulEmailConfirm.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please check your email to confirm your account before logging in.'**
  String get registrationSuccessfulEmailConfirm;

  /// No description provided for @registrationSuccessfulPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Your account is pending approval. You will be notified when your account is approved.'**
  String get registrationSuccessfulPendingApproval;

  /// No description provided for @registrationSuccessfulAutoLogin.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! You have been automatically logged in.'**
  String get registrationSuccessfulAutoLogin;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registrationSuccessful;

  /// No description provided for @pleaseLoginWithNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Please log in with your new account.'**
  String get pleaseLoginWithNewAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @usernameOrEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get usernameOrEmailLabel;

  /// No description provided for @pleaseEnterUsernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username or email'**
  String get pleaseEnterUsernameOrEmail;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset Link Sent'**
  String get resetLinkSent;

  /// No description provided for @passwordResetInstructionsSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset instructions have been sent to your registered email address.'**
  String get passwordResetInstructionsSent;

  /// No description provided for @resetFailed.
  ///
  /// In en, this message translates to:
  /// **'Reset Failed'**
  String get resetFailed;

  /// No description provided for @unableToSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Unable to send reset link. Please try again.'**
  String get unableToSendResetLink;

  /// No description provided for @errorSendingResetLink.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sending the reset link. Please check your connection and try again.'**
  String get errorSendingResetLink;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @errorMessageCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Error message copied to clipboard'**
  String get errorMessageCopiedToClipboard;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @getHelp.
  ///
  /// In en, this message translates to:
  /// **'Get Help'**
  String get getHelp;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @unexpectedErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpectedErrorOccurred;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @checkInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get checkInternetConnection;

  /// No description provided for @authenticationRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// No description provided for @pleaseLoginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue.'**
  String get pleaseLoginToContinue;

  /// No description provided for @forumError.
  ///
  /// In en, this message translates to:
  /// **'Forum Error'**
  String get forumError;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @accountPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Your account is pending approval. You can browse the forum but cannot post until a moderator approves your account.'**
  String get accountPendingApproval;

  /// No description provided for @checkEmailToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please check your email to confirm your account. Click the confirmation link in the email we sent you.'**
  String get checkEmailToConfirm;

  /// No description provided for @checkNewEmailToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please check your new email address to confirm the change. Your old email will remain active until you confirm the new one.'**
  String get checkNewEmailToConfirm;

  /// No description provided for @emailAddressInvalid.
  ///
  /// In en, this message translates to:
  /// **'Your email address appears to be invalid or is bouncing emails. Please update your email address in account settings.'**
  String get emailAddressInvalid;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled. Please contact an administrator for assistance.'**
  String get accountDisabled;

  /// No description provided for @accountRegistrationRejected.
  ///
  /// In en, this message translates to:
  /// **'Your account registration was rejected. Please contact an administrator for more information.'**
  String get accountRegistrationRejected;

  /// No description provided for @welcomeToForumCopilot.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Forum Copilot!'**
  String get welcomeToForumCopilot;

  /// No description provided for @successfullyLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'You have been successfully logged out'**
  String get successfullyLoggedOut;

  /// No description provided for @accountStatusRequiresAttention.
  ///
  /// In en, this message translates to:
  /// **'Your account status requires attention. Please contact an administrator if you have questions.'**
  String get accountStatusRequiresAttention;

  /// No description provided for @updateEmail.
  ///
  /// In en, this message translates to:
  /// **'Update Email'**
  String get updateEmail;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @noLatestTopics.
  ///
  /// In en, this message translates to:
  /// **'No Latest Topics'**
  String get noLatestTopics;

  /// No description provided for @noRecentTopicsToDisplay.
  ///
  /// In en, this message translates to:
  /// **'There are no recent topics to display. Check back later for new discussions.'**
  String get noRecentTopicsToDisplay;

  /// No description provided for @noUnreadTopics.
  ///
  /// In en, this message translates to:
  /// **'No Unread Topics'**
  String get noUnreadTopics;

  /// No description provided for @thereAreNoUnreadTopics.
  ///
  /// In en, this message translates to:
  /// **'There are no unread topics. Check back later for new discussions.'**
  String get thereAreNoUnreadTopics;

  /// No description provided for @youAreAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get youAreAllCaughtUp;

  /// No description provided for @noSubscribedTopics.
  ///
  /// In en, this message translates to:
  /// **'No Subscribed Topics'**
  String get noSubscribedTopics;

  /// No description provided for @noSubscribedTopicsMessage.
  ///
  /// In en, this message translates to:
  /// **'You aren\'t subscribed to any topics yet. Open a topic and choose Subscribe in its ⋮ menu to be notified of new replies.'**
  String get noSubscribedTopicsMessage;

  /// No description provided for @noParticipatedTopics.
  ///
  /// In en, this message translates to:
  /// **'No Participated Topics'**
  String get noParticipatedTopics;

  /// No description provided for @topicsYouParticipatedIn.
  ///
  /// In en, this message translates to:
  /// **'Topics that you have participated in will be shown here.'**
  String get topicsYouParticipatedIn;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @subscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get subscribed;

  /// No description provided for @participated.
  ///
  /// In en, this message translates to:
  /// **'Participated'**
  String get participated;

  /// No description provided for @connectionTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. The site may be down or unreachable.'**
  String get connectionTimedOut;

  /// No description provided for @failedToConnectToSite.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to site. The site may be down or unreachable.'**
  String get failedToConnectToSite;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection Failed'**
  String get connectionFailed;

  /// Error message when failed to connect to a site
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to {siteName}'**
  String failedToConnectToSiteName(String siteName);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @newConversation.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get newConversation;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get newMessage;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @searchSites.
  ///
  /// In en, this message translates to:
  /// **'Search Sites'**
  String get searchSites;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @topicsOnly.
  ///
  /// In en, this message translates to:
  /// **'Topics Only'**
  String get topicsOnly;

  /// No description provided for @titlesOnly.
  ///
  /// In en, this message translates to:
  /// **'Titles Only'**
  String get titlesOnly;

  /// Error message when sharing topic fails
  ///
  /// In en, this message translates to:
  /// **'Failed to share topic: {error}'**
  String failedToShareTopic(String error);

  /// Message asking user to login to subscribe/unsubscribe
  ///
  /// In en, this message translates to:
  /// **'Please login to {action} this thread'**
  String pleaseLoginToSubscribe(String action);

  /// No description provided for @subscribeTo.
  ///
  /// In en, this message translates to:
  /// **'subscribe to'**
  String get subscribeTo;

  /// No description provided for @unsubscribeFrom.
  ///
  /// In en, this message translates to:
  /// **'unsubscribe from'**
  String get unsubscribeFrom;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @unsubscribe.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get unsubscribe;

  /// Error message when subscribe/unsubscribe fails
  ///
  /// In en, this message translates to:
  /// **'Failed to {action} thread'**
  String failedToSubscribeToThread(String action);

  /// No description provided for @youCannotReplyToThisThread.
  ///
  /// In en, this message translates to:
  /// **'You cannot reply to this thread'**
  String get youCannotReplyToThisThread;

  /// No description provided for @pleaseWaitForThreadToLoad.
  ///
  /// In en, this message translates to:
  /// **'Please wait for the thread to load'**
  String get pleaseWaitForThreadToLoad;

  /// No description provided for @postCanBeRestoredLater.
  ///
  /// In en, this message translates to:
  /// **'Post can be restored later'**
  String get postCanBeRestoredLater;

  /// No description provided for @postWillBePermanentlyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post will be permanently deleted'**
  String get postWillBePermanentlyDeleted;

  /// No description provided for @enterReasonForDeletingPost.
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for deleting this post'**
  String get enterReasonForDeletingPost;

  /// No description provided for @reportPost.
  ///
  /// In en, this message translates to:
  /// **'Report Post'**
  String get reportPost;

  /// No description provided for @pleaseProvideReasonForReporting.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for reporting this post.'**
  String get pleaseProvideReasonForReporting;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @enterReasonForReportingPost.
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for reporting this post'**
  String get enterReasonForReportingPost;

  /// No description provided for @pleaseEnterReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason'**
  String get pleaseEnterReason;

  /// No description provided for @selectedActions.
  ///
  /// In en, this message translates to:
  /// **'Selected actions:'**
  String get selectedActions;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// Label for participants (without count)
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participantsLabel;

  /// Message when user is invited to conversation
  ///
  /// In en, this message translates to:
  /// **'{username} has been invited to the conversation'**
  String usernameHasBeenInvited(String username);

  /// Error message when inviting user fails
  ///
  /// In en, this message translates to:
  /// **'Error inviting user: {error}'**
  String errorInvitingUser(String error);

  /// No description provided for @newTopic.
  ///
  /// In en, this message translates to:
  /// **'New Topic'**
  String get newTopic;

  /// No description provided for @markRead.
  ///
  /// In en, this message translates to:
  /// **'Mark Read'**
  String get markRead;

  /// No description provided for @pleaseSelectReasonForReportingUser.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for reporting this user.'**
  String get pleaseSelectReasonForReportingUser;

  /// No description provided for @spamOrAdvertising.
  ///
  /// In en, this message translates to:
  /// **'Spam or advertising'**
  String get spamOrAdvertising;

  /// No description provided for @harassmentOrBullying.
  ///
  /// In en, this message translates to:
  /// **'Harassment or bullying'**
  String get harassmentOrBullying;

  /// No description provided for @inappropriateContent.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get inappropriateContent;

  /// No description provided for @impersonationOrFakeAccount.
  ///
  /// In en, this message translates to:
  /// **'Impersonation or fake account'**
  String get impersonationOrFakeAccount;

  /// No description provided for @otherPleaseSpecify.
  ///
  /// In en, this message translates to:
  /// **'Other (please specify)'**
  String get otherPleaseSpecify;

  /// No description provided for @pleaseSpecifyReason.
  ///
  /// In en, this message translates to:
  /// **'Please specify the reason'**
  String get pleaseSpecifyReason;

  /// No description provided for @enterReasonForReportingUser.
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for reporting this user'**
  String get enterReasonForReportingUser;

  /// No description provided for @pleaseSelectReason.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason'**
  String get pleaseSelectReason;

  /// Message asking to select reason for banning user
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for banning {username}'**
  String pleaseSelectReasonForBanningUser(String username);

  /// No description provided for @violationOfCommunityGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Violation of community guidelines'**
  String get violationOfCommunityGuidelines;

  /// No description provided for @harassmentOrAbusiveBehavior.
  ///
  /// In en, this message translates to:
  /// **'Harassment or abusive behavior'**
  String get harassmentOrAbusiveBehavior;

  /// No description provided for @postingInappropriateContent.
  ///
  /// In en, this message translates to:
  /// **'Posting inappropriate content'**
  String get postingInappropriateContent;

  /// No description provided for @accountCompromiseOrSecurityIssue.
  ///
  /// In en, this message translates to:
  /// **'Account compromise or security issue'**
  String get accountCompromiseOrSecurityIssue;

  /// No description provided for @enterReasonForBanningUser.
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for banning this user'**
  String get enterReasonForBanningUser;

  /// No description provided for @banUntil.
  ///
  /// In en, this message translates to:
  /// **'Ban until'**
  String get banUntil;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @unbanUser.
  ///
  /// In en, this message translates to:
  /// **'Unban User'**
  String get unbanUser;

  /// No description provided for @leaveConversation.
  ///
  /// In en, this message translates to:
  /// **'Leave conversation'**
  String get leaveConversation;

  /// No description provided for @reportConversation.
  ///
  /// In en, this message translates to:
  /// **'Report conversation'**
  String get reportConversation;

  /// No description provided for @topicClosed.
  ///
  /// In en, this message translates to:
  /// **'Topic closed'**
  String get topicClosed;

  /// No description provided for @topicOpened.
  ///
  /// In en, this message translates to:
  /// **'Topic opened'**
  String get topicOpened;

  /// No description provided for @topicStickied.
  ///
  /// In en, this message translates to:
  /// **'Topic stickied'**
  String get topicStickied;

  /// No description provided for @topicUnstickied.
  ///
  /// In en, this message translates to:
  /// **'Topic unstickied'**
  String get topicUnstickied;

  /// Error message when cannot edit message
  ///
  /// In en, this message translates to:
  /// **'Cannot edit this message: {error}'**
  String cannotEditMessage(String error);

  /// No description provided for @confirmSpamClean.
  ///
  /// In en, this message translates to:
  /// **'Confirm Spam Clean'**
  String get confirmSpamClean;

  /// No description provided for @myForums.
  ///
  /// In en, this message translates to:
  /// **'My Forums'**
  String get myForums;

  /// No description provided for @recentlyVisited.
  ///
  /// In en, this message translates to:
  /// **'Recently Visited'**
  String get recentlyVisited;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @forumCopilot.
  ///
  /// In en, this message translates to:
  /// **'Forum Copilot'**
  String get forumCopilot;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations'**
  String get noConversations;

  /// No description provided for @noConversationsMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no conversations yet. Start a new conversation to begin messaging.'**
  String get noConversationsMessage;

  /// No description provided for @imageSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery!'**
  String get imageSavedToGallery;

  /// Error message when saving image fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save image: {error}'**
  String failedToSaveImage(String error);

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get deletePost;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequired;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @lastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get lastActivity;

  /// No description provided for @likesReceived.
  ///
  /// In en, this message translates to:
  /// **'Likes Received'**
  String get likesReceived;

  /// No description provided for @likesGiven.
  ///
  /// In en, this message translates to:
  /// **'Likes Given'**
  String get likesGiven;

  /// No description provided for @failedToSaveMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save message'**
  String get failedToSaveMessage;

  /// No description provided for @failedToSaveSetting.
  ///
  /// In en, this message translates to:
  /// **'Failed to save setting'**
  String get failedToSaveSetting;

  /// No description provided for @failedToSavePost.
  ///
  /// In en, this message translates to:
  /// **'Failed to save post'**
  String get failedToSavePost;

  /// Error message when loading explore sites fails
  ///
  /// In en, this message translates to:
  /// **'Error loading sites: {error}'**
  String errorLoadingSites(String error);

  /// Message shown when connecting to a site
  ///
  /// In en, this message translates to:
  /// **'Connecting to {domainName}...'**
  String connectingTo(String domainName);

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @allMembers.
  ///
  /// In en, this message translates to:
  /// **'All Members'**
  String get allMembers;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @noMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get noMembersFound;

  /// No description provided for @searchForMembers.
  ///
  /// In en, this message translates to:
  /// **'Search for members'**
  String get searchForMembers;

  /// No description provided for @enterUsernameToFindMembers.
  ///
  /// In en, this message translates to:
  /// **'Enter a username to find forum members'**
  String get enterUsernameToFindMembers;

  /// No description provided for @noMembersOnline.
  ///
  /// In en, this message translates to:
  /// **'No members are currently online'**
  String get noMembersOnline;

  /// No description provided for @lookupMembers.
  ///
  /// In en, this message translates to:
  /// **'Lookup Members'**
  String get lookupMembers;

  /// No description provided for @addMembers.
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get addMembers;

  /// No description provided for @membersAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Members added successfully'**
  String get membersAddedSuccessfully;

  /// Error message when adding members fails
  ///
  /// In en, this message translates to:
  /// **'Error adding members: {error}'**
  String errorAddingMembers(String error);

  /// No description provided for @failedToLoadOnlineUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load online users'**
  String get failedToLoadOnlineUsers;

  /// No description provided for @noUsersOnline.
  ///
  /// In en, this message translates to:
  /// **'No users online'**
  String get noUsersOnline;

  /// Number of members with label
  ///
  /// In en, this message translates to:
  /// **'{count} Members'**
  String membersCount(int count);

  /// No description provided for @noSubject.
  ///
  /// In en, this message translates to:
  /// **'No subject'**
  String get noSubject;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @markForumRead.
  ///
  /// In en, this message translates to:
  /// **'Mark Forum Read'**
  String get markForumRead;

  /// No description provided for @notificationTest.
  ///
  /// In en, this message translates to:
  /// **'Notification Test'**
  String get notificationTest;

  /// No description provided for @forum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get forum;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get deleteMessage;

  /// No description provided for @areYouSureYouWantToDeleteThisMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get areYouSureYouWantToDeleteThisMessage;

  /// Error message when deleting message fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete message: {error}'**
  String failedToDeleteMessage(String error);

  /// No description provided for @deletingPost.
  ///
  /// In en, this message translates to:
  /// **'Deleting post...'**
  String get deletingPost;

  /// Error message when unliking post fails
  ///
  /// In en, this message translates to:
  /// **'Failed to unlike post: {error}'**
  String failedToUnlikePost(String error);

  /// Error message when liking post fails
  ///
  /// In en, this message translates to:
  /// **'Failed to like post: {error}'**
  String failedToLikePost(String error);

  /// No description provided for @youNeedToBeSignedInToViewConversations.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to view your conversations.'**
  String get youNeedToBeSignedInToViewConversations;

  /// Error message when loading conversations fails
  ///
  /// In en, this message translates to:
  /// **'Error loading conversations: {error}'**
  String errorLoadingConversations(String error);

  /// Error message when leaving conversation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to leave conversation: {error}'**
  String failedToLeaveConversation(String error);

  /// Error message when loading more conversations fails
  ///
  /// In en, this message translates to:
  /// **'Error loading more conversations: {error}'**
  String errorLoadingMoreConversations(String error);

  /// Error message when loading more messages fails
  ///
  /// In en, this message translates to:
  /// **'Error loading more messages: {error}'**
  String errorLoadingMoreMessages(String error);

  /// No description provided for @inviteMessageOptional.
  ///
  /// In en, this message translates to:
  /// **'Invite Message (optional)'**
  String get inviteMessageOptional;

  /// No description provided for @iWouldLikeToAddYouToThisConversation.
  ///
  /// In en, this message translates to:
  /// **'I would like to add you to this conversation.'**
  String get iWouldLikeToAddYouToThisConversation;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get searchFailed;

  /// No description provided for @trySearchingWithDifferentUsername.
  ///
  /// In en, this message translates to:
  /// **'Try searching with a different username'**
  String get trySearchingWithDifferentUsername;

  /// No description provided for @enterUsernameToSearch.
  ///
  /// In en, this message translates to:
  /// **'Enter username to search...'**
  String get enterUsernameToSearch;

  /// No description provided for @noSitesFound.
  ///
  /// In en, this message translates to:
  /// **'No sites found.'**
  String get noSitesFound;

  /// No description provided for @userInformationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'User information not available'**
  String get userInformationNotAvailable;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @permanent.
  ///
  /// In en, this message translates to:
  /// **'Permanent'**
  String get permanent;

  /// No description provided for @temporary.
  ///
  /// In en, this message translates to:
  /// **'Temporary'**
  String get temporary;

  /// Message asking to set ban duration
  ///
  /// In en, this message translates to:
  /// **'Set the ban duration for {username}'**
  String setBanDurationFor(String username);

  /// No description provided for @pleaseSelectEndDateForTemporaryBan.
  ///
  /// In en, this message translates to:
  /// **'Please select an end date for temporary ban'**
  String get pleaseSelectEndDateForTemporaryBan;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @unban.
  ///
  /// In en, this message translates to:
  /// **'Unban'**
  String get unban;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Title for spam clean dialog
  ///
  /// In en, this message translates to:
  /// **'Spam Clean {username}'**
  String spamClean(String username);

  /// No description provided for @selectActionsToPerform.
  ///
  /// In en, this message translates to:
  /// **'Select the actions to perform:'**
  String get selectActionsToPerform;

  /// No description provided for @handleThreads.
  ///
  /// In en, this message translates to:
  /// **'Handle Threads'**
  String get handleThreads;

  /// No description provided for @moveOrDeleteThreadsBasedOnAdminSettings.
  ///
  /// In en, this message translates to:
  /// **'Move or delete threads based on admin settings'**
  String get moveOrDeleteThreadsBasedOnAdminSettings;

  /// No description provided for @deleteMessages.
  ///
  /// In en, this message translates to:
  /// **'Delete Messages'**
  String get deleteMessages;

  /// No description provided for @deleteConversations.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversations'**
  String get deleteConversations;

  /// No description provided for @messageUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Message updated successfully'**
  String get messageUpdatedSuccessfully;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(String error);

  /// Error message when removing attachment fails
  ///
  /// In en, this message translates to:
  /// **'Failed to remove attachment: {error}'**
  String failedToRemoveAttachment(String error);

  /// Error message when loading message fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load message: {error}'**
  String failedToLoadMessage(String error);

  /// No description provided for @editMessage.
  ///
  /// In en, this message translates to:
  /// **'Edit Message'**
  String get editMessage;

  /// No description provided for @removeAttachment.
  ///
  /// In en, this message translates to:
  /// **'Remove Attachment'**
  String get removeAttachment;

  /// No description provided for @areYouSureYouWantToRemoveThisAttachment.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this attachment?'**
  String get areYouSureYouWantToRemoveThisAttachment;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @formatting.
  ///
  /// In en, this message translates to:
  /// **'Formatting'**
  String get formatting;

  /// No description provided for @bold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// No description provided for @italic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get italic;

  /// No description provided for @underline.
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get underline;

  /// No description provided for @strikethrough.
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get strikethrough;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @quote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get quote;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @spoiler.
  ///
  /// In en, this message translates to:
  /// **'Spoiler'**
  String get spoiler;

  /// No description provided for @bulletList.
  ///
  /// In en, this message translates to:
  /// **'Bullet List'**
  String get bulletList;

  /// No description provided for @numberedList.
  ///
  /// In en, this message translates to:
  /// **'Numbered List'**
  String get numberedList;

  /// No description provided for @listItem.
  ///
  /// In en, this message translates to:
  /// **'List Item'**
  String get listItem;

  /// Participants count with label
  ///
  /// In en, this message translates to:
  /// **'Participants ({count})'**
  String participants(int count);

  /// No description provided for @enterKeywordsToSearchTopics.
  ///
  /// In en, this message translates to:
  /// **'Enter keywords to search topics...'**
  String get enterKeywordsToSearchTopics;

  /// No description provided for @pleaseFillInAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get pleaseFillInAllRequiredFields;

  /// No description provided for @undelete.
  ///
  /// In en, this message translates to:
  /// **'Undelete'**
  String get undelete;

  /// No description provided for @signInToViewUnreadTopics.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view unread topics'**
  String get signInToViewUnreadTopics;

  /// No description provided for @youNeedToBeSignedInToViewUnreadTopics.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to view your unread topics.'**
  String get youNeedToBeSignedInToViewUnreadTopics;

  /// No description provided for @signInToViewSubscribedTopics.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view subscribed topics'**
  String get signInToViewSubscribedTopics;

  /// No description provided for @youNeedToBeSignedInToViewSubscribedTopics.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to view your subscribed topics.'**
  String get youNeedToBeSignedInToViewSubscribedTopics;

  /// No description provided for @signInToViewParticipatedTopics.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view participated topics'**
  String get signInToViewParticipatedTopics;

  /// No description provided for @youNeedToBeSignedInToViewParticipatedTopics.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to view topics you have participated in.'**
  String get youNeedToBeSignedInToViewParticipatedTopics;

  /// No description provided for @signInToViewLatestTopics.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view latest topics'**
  String get signInToViewLatestTopics;

  /// No description provided for @youNeedToBeSignedInToViewLatestTopics.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to view latest topics.'**
  String get youNeedToBeSignedInToViewLatestTopics;

  /// No description provided for @markAsUnread.
  ///
  /// In en, this message translates to:
  /// **'Mark as unread'**
  String get markAsUnread;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToAccessYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your profile and manage your account'**
  String get signInToAccessYourProfile;

  /// No description provided for @enterYourUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterYourUsername;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// Menu item to refresh content
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Menu item to share content
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Menu item to view content on web browser
  ///
  /// In en, this message translates to:
  /// **'View on Web'**
  String get viewOnWeb;

  /// Menu item to unlock a topic
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// Menu item to lock a topic
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// Menu item to stick/pin a topic
  ///
  /// In en, this message translates to:
  /// **'Stick'**
  String get stick;

  /// Menu item to unstick/unpin a topic
  ///
  /// In en, this message translates to:
  /// **'Unstick'**
  String get unstick;

  /// Button to reply to a post or message
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// Button to submit poll vote
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get vote;

  /// Poll footer showing total vote count
  ///
  /// In en, this message translates to:
  /// **'{count} votes'**
  String votesCount(int count);

  /// Poll footer when poll is closed
  ///
  /// In en, this message translates to:
  /// **'Poll closed'**
  String get pollClosed;

  /// Poll footer showing close date
  ///
  /// In en, this message translates to:
  /// **'Ends {date}'**
  String pollEndsOn(String date);

  /// Hint when results are hidden until user votes
  ///
  /// In en, this message translates to:
  /// **'Vote to see results'**
  String get voteToSeeResults;

  /// Mini poll bar: tap to scroll to first post and see full poll
  ///
  /// In en, this message translates to:
  /// **'View full poll'**
  String get viewFullPoll;

  /// Mini poll bar subtitle when no votes yet
  ///
  /// In en, this message translates to:
  /// **'{count} options'**
  String pollOptionsCount(int count);

  /// Label showing who reacted to a post or message
  ///
  /// In en, this message translates to:
  /// **'Reacted by'**
  String get reactedBy;

  /// Number of likes on a post or message, on forums without a reaction set (single Like)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} like} other{{count} likes}}'**
  String likesCount(int count);

  /// Number of reactions (Like, Love, Wow…) on a post or message, on forums with a reaction set
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} reaction} other{{count} reactions}}'**
  String reactionsCount(int count);

  /// Screen-reader hint on the reaction summary under a post or message (its label is the count)
  ///
  /// In en, this message translates to:
  /// **'Tap to see who reacted.'**
  String get showWhoReacted;

  /// Button at the bottom of the who-reacted sheet that opens the reaction picker
  ///
  /// In en, this message translates to:
  /// **'React'**
  String get react;

  /// The same button once the reader has reacted
  ///
  /// In en, this message translates to:
  /// **'Change your reaction'**
  String get changeYourReaction;

  /// Filter chip in the who-reacted sheet that shows every reaction; followed by the total
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reactionsAll;

  /// Badge on the reader's own row in the who-reacted sheet
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get reactionYou;

  /// Screen-reader label of a reaction filter chip in the who-reacted sheet: the reaction's name and how many people used it
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{reaction}, {count} person} other{{reaction}, {count} people}}'**
  String reactionFilterSemantics(String reaction, int count);

  /// Screen-reader label of a user row in the who-reacted sheet
  ///
  /// In en, this message translates to:
  /// **'View profile of {username}'**
  String viewProfileOfUser(String username);

  /// Hint text for searching topics and posts
  ///
  /// In en, this message translates to:
  /// **'Enter keywords to find topics and posts'**
  String get enterKeywordsToFindTopicsAndPosts;

  /// Hint text for searching forums by keywords or domain
  ///
  /// In en, this message translates to:
  /// **'Enter keywords or domain to find forums'**
  String get enterKeywordsOrDomainToFindForums;

  /// Description text for searching forums
  ///
  /// In en, this message translates to:
  /// **'Enter keywords or domain names to find forums'**
  String get enterKeywordsOrDomainNamesToFindForums;

  /// Settings section title for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Option to use system default settings
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Description for system default language option
  ///
  /// In en, this message translates to:
  /// **'Follow system language'**
  String get followSystemLanguage;

  /// Settings section title for appearance/theme
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Description for system default theme option
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get followSystemTheme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// App version display
  ///
  /// In en, this message translates to:
  /// **'version {version} ({buildNumber})'**
  String version(String version, String buildNumber);

  /// Title for forum settings page
  ///
  /// In en, this message translates to:
  /// **'Forum Settings'**
  String get forumSettings;

  /// Message when no settings are available
  ///
  /// In en, this message translates to:
  /// **'No settings available'**
  String get noSettingsAvailable;

  /// Message explaining when settings categories will appear
  ///
  /// In en, this message translates to:
  /// **'Settings categories will appear here when available.'**
  String get settingsCategoriesWillAppearHere;

  /// Menu item for spam cleaner tool
  ///
  /// In en, this message translates to:
  /// **'Spam Cleaner'**
  String get spamCleaner;

  /// Error message when profile cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Unable to Load Profile'**
  String get unableToLoadProfile;

  /// Badge text for banned users
  ///
  /// In en, this message translates to:
  /// **'BANNED'**
  String get banned;

  /// Button to send a message to a user
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// Button to show more content
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// Title for report user dialog
  ///
  /// In en, this message translates to:
  /// **'Report User'**
  String get reportUser;

  /// Button to submit a report
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// Success message after submitting a report
  ///
  /// In en, this message translates to:
  /// **'Report submitted successfully'**
  String get reportSubmittedSuccessfully;

  /// Error message when report submission fails
  ///
  /// In en, this message translates to:
  /// **'Failed to submit report'**
  String get failedToSubmitReport;

  /// Placeholder text for forum search
  ///
  /// In en, this message translates to:
  /// **'Search for forums'**
  String get searchForForums;

  /// Title for the search forums page
  ///
  /// In en, this message translates to:
  /// **'Search Forums'**
  String get searchForums;

  /// Title for delete topic dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Topic'**
  String get deleteTopic;

  /// Option for soft delete (can be restored)
  ///
  /// In en, this message translates to:
  /// **'Soft Delete'**
  String get softDelete;

  /// Description for soft delete option
  ///
  /// In en, this message translates to:
  /// **'Topic can be restored later'**
  String get topicCanBeRestoredLater;

  /// Option for hard delete (permanent)
  ///
  /// In en, this message translates to:
  /// **'Hard Delete'**
  String get hardDelete;

  /// Description for hard delete option
  ///
  /// In en, this message translates to:
  /// **'Topic will be permanently deleted'**
  String get topicWillBePermanentlyDeleted;

  /// Label for deletion reason field
  ///
  /// In en, this message translates to:
  /// **'Reason for deletion'**
  String get reasonForDeletion;

  /// Hint text for deletion reason field
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for deleting this topic'**
  String get enterReasonForDeletingTopic;

  /// Validation message for deletion reason
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason for deletion'**
  String get pleaseEnterReasonForDeletion;

  /// Error message when end date is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select an end date'**
  String get pleaseSelectEndDate;

  /// Button to ban a user
  ///
  /// In en, this message translates to:
  /// **'Ban User'**
  String get banUser;

  /// Success message after banning a user
  ///
  /// In en, this message translates to:
  /// **'User banned successfully'**
  String get userBannedSuccessfully;

  /// Error message when banning user fails
  ///
  /// In en, this message translates to:
  /// **'Failed to ban user'**
  String get failedToBanUser;

  /// Success message after unbanning a user
  ///
  /// In en, this message translates to:
  /// **'User unbanned successfully'**
  String get userUnbannedSuccessfully;

  /// Error message when unbanning user fails
  ///
  /// In en, this message translates to:
  /// **'Failed to unban user'**
  String get failedToUnbanUser;

  /// Title for spam clean user dialog
  ///
  /// In en, this message translates to:
  /// **'Spam Clean User'**
  String get spamCleanUser;

  /// Option to delete private conversations in spam clean
  ///
  /// In en, this message translates to:
  /// **'Delete private conversations'**
  String get deletePrivateConversations;

  /// Option to ban user account in spam clean
  ///
  /// In en, this message translates to:
  /// **'Ban the user account'**
  String get banTheUserAccount;

  /// Button to execute spam clean
  ///
  /// In en, this message translates to:
  /// **'Clean Spam'**
  String get cleanSpam;

  /// Action performed: handled threads
  ///
  /// In en, this message translates to:
  /// **'Handled threads'**
  String get handledThreads;

  /// Action performed: deleted messages
  ///
  /// In en, this message translates to:
  /// **'Deleted messages'**
  String get deletedMessages;

  /// Action performed: deleted conversations
  ///
  /// In en, this message translates to:
  /// **'Deleted conversations'**
  String get deletedConversations;

  /// Action performed: banned user
  ///
  /// In en, this message translates to:
  /// **'Banned user'**
  String get bannedUser;

  /// Success message after spam clean
  ///
  /// In en, this message translates to:
  /// **'Successfully cleaned spam for {username}. Actions: {actions}'**
  String successfullyCleanedSpam(String username, String actions);

  /// Error message when loading message fails
  ///
  /// In en, this message translates to:
  /// **'Error loading message: {error}'**
  String errorLoadingMessage(String error);

  /// Message when message is not found
  ///
  /// In en, this message translates to:
  /// **'Message not found'**
  String get messageNotFound;

  /// Home tab title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Notifications tab title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Forums tab title (plural)
  ///
  /// In en, this message translates to:
  /// **'Forums'**
  String get forums;

  /// Dialog title for marking all forums as read
  ///
  /// In en, this message translates to:
  /// **'Mark All Forums as Read?'**
  String get markAllForumsAsRead;

  /// Message explaining mark all forums as read action
  ///
  /// In en, this message translates to:
  /// **'This will mark all forums and topics as read. This action cannot be undone.'**
  String get markAllForumsAsReadMessage;

  /// Button text to mark as read
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// Content label for message compose
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// Dialog title for inserting image
  ///
  /// In en, this message translates to:
  /// **'Insert Image'**
  String get insertImage;

  /// Question asking how to insert image
  ///
  /// In en, this message translates to:
  /// **'How would you like to insert this image?'**
  String get howWouldYouLikeToInsertImage;

  /// Option to insert image as thumbnail
  ///
  /// In en, this message translates to:
  /// **'Thumbnail'**
  String get thumbnail;

  /// Option to insert image at full size
  ///
  /// In en, this message translates to:
  /// **'Full Size'**
  String get fullSize;

  /// Text alignment option: left
  ///
  /// In en, this message translates to:
  /// **'Align Left'**
  String get alignLeft;

  /// Text alignment option: center
  ///
  /// In en, this message translates to:
  /// **'Align Center'**
  String get alignCenter;

  /// Text alignment option: right
  ///
  /// In en, this message translates to:
  /// **'Align Right'**
  String get alignRight;

  /// Validation message when title is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// Validation message when content is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter some content'**
  String get pleaseEnterContent;

  /// Status message when uploading file
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// Status message when file is uploaded
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// Tooltip for mention user button
  ///
  /// In en, this message translates to:
  /// **'Mention User'**
  String get mentionUser;

  /// Status message when logging in
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// Status message when submitting report
  ///
  /// In en, this message translates to:
  /// **'Submitting report...'**
  String get submittingReport;

  /// Status message when banning user
  ///
  /// In en, this message translates to:
  /// **'Banning user...'**
  String get banningUser;

  /// Status message when unbanning user
  ///
  /// In en, this message translates to:
  /// **'Unbanning user...'**
  String get unbanningUser;

  /// Status message when cleaning spam
  ///
  /// In en, this message translates to:
  /// **'Cleaning spam...'**
  String get cleaningSpam;

  /// Hint text for subject field
  ///
  /// In en, this message translates to:
  /// **'Enter subject'**
  String get enterSubject;

  /// Hint text for message field
  ///
  /// In en, this message translates to:
  /// **'Type your message here'**
  String get typeYourMessageHere;

  /// Hint text for writing message
  ///
  /// In en, this message translates to:
  /// **'Write your message...'**
  String get writeYourMessage;

  /// Hint text for writing reply
  ///
  /// In en, this message translates to:
  /// **'Write your reply...'**
  String get writeYourReply;

  /// Success message after sending message
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully'**
  String get messageSentSuccessfully;

  /// Success message after sending reply
  ///
  /// In en, this message translates to:
  /// **'Reply sent successfully'**
  String get replySentSuccessfully;

  /// Success message after creating conversation
  ///
  /// In en, this message translates to:
  /// **'Conversation created successfully'**
  String get conversationCreatedSuccessfully;

  /// Success message when marking conversation as unread
  ///
  /// In en, this message translates to:
  /// **'Conversation marked as unread'**
  String get conversationMarkedAsUnread;

  /// Success message when marking message as unread
  ///
  /// In en, this message translates to:
  /// **'Message marked as unread'**
  String get messageMarkedAsUnread;

  /// Success message when closing conversation
  ///
  /// In en, this message translates to:
  /// **'Conversation closed'**
  String get conversationClosed;

  /// Success message when opening conversation
  ///
  /// In en, this message translates to:
  /// **'Conversation opened'**
  String get conversationOpened;

  /// Message asking user to login to like messages
  ///
  /// In en, this message translates to:
  /// **'Please login to like messages'**
  String get pleaseLoginToLikeMessages;

  /// Button to load earlier messages
  ///
  /// In en, this message translates to:
  /// **'Load Earlier Messages'**
  String get loadEarlierMessages;

  /// Error message when loading quote fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load quote: \n{error}'**
  String failedToLoadQuote(String error);

  /// Error message when uploading file fails
  ///
  /// In en, this message translates to:
  /// **'Failed to upload file: {error}'**
  String failedToUploadFile(String error);

  /// Error message when uploading image fails
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image: {error}'**
  String failedToUploadImage(String error);

  /// Error message when sending message fails
  ///
  /// In en, this message translates to:
  /// **'Failed to send message: {error}'**
  String failedToSendMessage(String error);

  /// Error message when sending reply fails
  ///
  /// In en, this message translates to:
  /// **'Failed to send reply: {error}'**
  String failedToSendReply(String error);

  /// Error message when marking message as unread fails
  ///
  /// In en, this message translates to:
  /// **'Failed to mark message as unread: {error}'**
  String failedToMarkAsUnread(String error);

  /// Error message when marking conversation as unread fails
  ///
  /// In en, this message translates to:
  /// **'Failed to mark conversation as unread: {error}'**
  String failedToMarkConversationAsUnread(String error);

  /// Error message when closing conversation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to close conversation: {error}'**
  String failedToCloseConversation(String error);

  /// Error message when opening conversation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to open conversation: {error}'**
  String failedToOpenConversation(String error);

  /// Error message when jumping to message fails
  ///
  /// In en, this message translates to:
  /// **'Failed to jump to message: {error}'**
  String failedToJumpToMessage(String error);

  /// Tooltip for go to top button
  ///
  /// In en, this message translates to:
  /// **'Go to top'**
  String get goToTop;

  /// Tooltip for go to bottom button
  ///
  /// In en, this message translates to:
  /// **'Go to bottom'**
  String get goToBottom;

  /// Tooltip for reply all button
  ///
  /// In en, this message translates to:
  /// **'Reply All'**
  String get replyAll;

  /// Tooltip for forward button
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// Message when no forums are found
  ///
  /// In en, this message translates to:
  /// **'No forums found.'**
  String get noForumsFound;

  /// Validation message when prefix is required but not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a prefix'**
  String get pleaseSelectPrefix;

  /// Message asking user to login to access content
  ///
  /// In en, this message translates to:
  /// **'Please login to access this content and interact with posts.'**
  String get pleaseLoginToAccessContent;

  /// Hint text for searching users
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// Hint text for title field
  ///
  /// In en, this message translates to:
  /// **'Write your title...'**
  String get writeYourTitle;

  /// Hint text for content field
  ///
  /// In en, this message translates to:
  /// **'Write your content...'**
  String get writeYourContent;

  /// Hint text for select field
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get selectAnOption;

  /// Hint text for conversation title field
  ///
  /// In en, this message translates to:
  /// **'Enter conversation title'**
  String get enterConversationTitle;

  /// Hint text for code input field
  ///
  /// In en, this message translates to:
  /// **'Enter {count}-digit code'**
  String enterCode(int count);

  /// Button text to edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Button text to report
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// Button text to unfollow
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// Button text to follow
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// Button text to remove
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Label for subject field
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// Label for message field
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// Validation message when title is empty
  ///
  /// In en, this message translates to:
  /// **'Title cannot be empty'**
  String get titleCannotBeEmpty;

  /// Success message when conversation is updated
  ///
  /// In en, this message translates to:
  /// **'Conversation updated successfully'**
  String get conversationUpdatedSuccessfully;

  /// Button text to go back
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Message asking user to sign in to view messages
  ///
  /// In en, this message translates to:
  /// **'Sign in to view messages'**
  String get signInToViewMessages;

  /// Message when private messages are not available
  ///
  /// In en, this message translates to:
  /// **'Private messages not available'**
  String get privateMessagesNotAvailable;

  /// Error message when loading post fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load post: \n{error}'**
  String failedToLoadPost(String error);

  /// Error message when liking/unliking message fails
  ///
  /// In en, this message translates to:
  /// **'Failed to {action} message: {error}'**
  String failedToLikeOrUnlikeMessage(String action, String error);

  /// Action verb: like
  ///
  /// In en, this message translates to:
  /// **'like'**
  String get like;

  /// Action verb: unlike
  ///
  /// In en, this message translates to:
  /// **'unlike'**
  String get unlike;

  /// Title for image optimization dialog
  ///
  /// In en, this message translates to:
  /// **'Optimize Image'**
  String get optimizeImage;

  /// Button text to optimize and upload image
  ///
  /// In en, this message translates to:
  /// **'Optimize and Upload'**
  String get optimizeAndUpload;

  /// Status message when downloading file
  ///
  /// In en, this message translates to:
  /// **'Downloading {filename}...'**
  String downloading(String filename);

  /// Status message when opening share sheet
  ///
  /// In en, this message translates to:
  /// **'Opening share sheet for {filename}'**
  String openingShareSheet(String filename);

  /// Error message when downloading file fails
  ///
  /// In en, this message translates to:
  /// **'Error downloading {filename}: {error}'**
  String errorDownloading(String filename, String error);

  /// Hint text for number input field
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get enterANumber;

  /// Error message when navigation to forum fails
  ///
  /// In en, this message translates to:
  /// **'Failed to navigate to forum'**
  String get failedToNavigateToForum;

  /// Error message when navigation to specific forum fails
  ///
  /// In en, this message translates to:
  /// **'Failed to navigate to {forumName}'**
  String failedToNavigateToForumName(String forumName);

  /// Error message when saving conversation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save conversation'**
  String get failedToSaveConversation;

  /// Error message when forum is not found
  ///
  /// In en, this message translates to:
  /// **'Forum not found: {forumName}'**
  String forumNotFound(String forumName);

  /// Error message when forum is not found by ID
  ///
  /// In en, this message translates to:
  /// **'Forum not found: {forumId}'**
  String forumNotFoundById(String forumId);

  /// Error message when opening link fails
  ///
  /// In en, this message translates to:
  /// **'Could not open link: {error}'**
  String couldNotOpenLink(String error);

  /// Accessibility label for like button
  ///
  /// In en, this message translates to:
  /// **'Like post'**
  String get likePost;

  /// Accessibility label for unlike button
  ///
  /// In en, this message translates to:
  /// **'Unlike post'**
  String get unlikePost;

  /// Accessibility hint for showing likes list
  ///
  /// In en, this message translates to:
  /// **'Show likes'**
  String get showLikes;

  /// Accessibility label for quote button
  ///
  /// In en, this message translates to:
  /// **'Quote post'**
  String get quotePost;

  /// Accessibility label for attach file button
  ///
  /// In en, this message translates to:
  /// **'Attach file'**
  String get attachFile;

  /// Accessibility label for upload image button
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get uploadImage;

  /// Menu item to translate thread content
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// Button to show original content instead of translation
  ///
  /// In en, this message translates to:
  /// **'Show Original'**
  String get showOriginal;

  /// Loading indicator while translating
  ///
  /// In en, this message translates to:
  /// **'Translating...'**
  String get translating;

  /// Badge shown on translated content
  ///
  /// In en, this message translates to:
  /// **'Translated'**
  String get translated;

  /// Label for translated content
  ///
  /// In en, this message translates to:
  /// **'Translated content'**
  String get translatedContent;

  /// Title for language selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Label for target language selection
  ///
  /// In en, this message translates to:
  /// **'Translate to:'**
  String get translateTo;

  /// Indicator that a language is the device default
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get deviceLanguage;

  /// Message when there are no posts available for translation
  ///
  /// In en, this message translates to:
  /// **'No posts to translate'**
  String get noPostsToTranslate;

  /// Error message when translation fails
  ///
  /// In en, this message translates to:
  /// **'Translation failed'**
  String get translationFailed;

  /// Title for the two-factor auth dialog
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuthentication;

  /// Label for the auth code input field
  ///
  /// In en, this message translates to:
  /// **'Authentication Code'**
  String get authenticationCodeLabel;

  /// Validation message when auth code is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your authentication code'**
  String get pleaseEnterYourAuthenticationCode;

  /// Validation message when code does not match required digits
  ///
  /// In en, this message translates to:
  /// **'Code must be {count} digits'**
  String codeMustBeDigits(int count);

  /// Validation message when code has non-digit characters
  ///
  /// In en, this message translates to:
  /// **'Code must contain only numbers'**
  String get codeMustContainOnlyNumbers;

  /// Verify action label on the TFA dialog
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// Attachments label
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// Title for the reply options menu
  ///
  /// In en, this message translates to:
  /// **'Reply Options'**
  String get replyOptions;

  /// Reply-with-quote action label
  ///
  /// In en, this message translates to:
  /// **'Reply with Quote'**
  String get replyWithQuote;

  /// Success message when file is saved to Downloads
  ///
  /// In en, this message translates to:
  /// **'File saved to Downloads: {filename}'**
  String fileSavedToDownloads(String filename);

  /// Success message when file is saved to Documents
  ///
  /// In en, this message translates to:
  /// **'File saved to Documents: {filename}'**
  String fileSavedToDocuments(String filename);

  /// Asked when a composer with unsent text is closed
  ///
  /// In en, this message translates to:
  /// **'Do you want to discard your post?'**
  String get discardPostQuestion;

  /// Asked when an edit form with unsaved changes is closed
  ///
  /// In en, this message translates to:
  /// **'Do you want to discard your changes?'**
  String get discardChangesQuestion;

  /// Button that closes a composer and throws away what was typed
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// Button that closes an edit form and throws away the changes
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get discardChanges;

  /// Short bottom navigation label for Notifications. Keep concise so it fits on narrow phones with larger text.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get notificationsTab;

  /// Shown after posting a reply or a new topic that the forum holds for moderator approval
  ///
  /// In en, this message translates to:
  /// **'Your post will appear once a moderator approves it.'**
  String get postAwaitingApproval;

  /// Screen-reader hint on the react button: a long press opens the reaction picker
  ///
  /// In en, this message translates to:
  /// **'Long press for more reactions'**
  String get reactionHoldHint;

  /// UI text: Turn on notifications
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications'**
  String get turnOnNotifications;

  /// UI text: Not now
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// Enable-notifications page
  ///
  /// In en, this message translates to:
  /// **'Never miss a reply on {forumName}'**
  String neverMissAReplyOn(Object forumName);

  /// Enable-notifications page (a sample notification shown as a preview)
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get notificationPreviewNow;

  /// Enable-notifications page (a sample notification shown as a preview)
  ///
  /// In en, this message translates to:
  /// **'5m ago'**
  String get notificationPreviewEarlier;

  /// Enable-notifications page (a sample notification shown as a preview)
  ///
  /// In en, this message translates to:
  /// **'Jane replied to you: Welcome aboard! Glad you found us.'**
  String get notificationPreviewReply;

  /// Enable-notifications page (a sample notification shown as a preview)
  ///
  /// In en, this message translates to:
  /// **'Sam sent you a message: Are you coming on Friday?'**
  String get notificationPreviewMessage;

  /// UI text: Notifications are turned off for this app
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for this app'**
  String get notificationsAreTurnedOffForThisApp;

  /// Grant page banner, shown when the OS notification permission was refused
  ///
  /// In en, this message translates to:
  /// **'Your device will not show alerts until you allow notifications in Settings.'**
  String get deviceWillNotShowAlertsUntilAllowedInSettings;

  /// Button: open the app's page in the system settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Shown under the title on the page that asks to turn on notifications after sign-in
  ///
  /// In en, this message translates to:
  /// **'Replies, mentions and direct messages, on your lock screen as they happen.'**
  String get notificationsPitchForum;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get viewProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @newEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'New email address'**
  String get newEmailAddress;

  /// No description provided for @emailChanged.
  ///
  /// In en, this message translates to:
  /// **'Email address changed'**
  String get emailChanged;

  /// After changing the email address, when the forum sends a confirmation link first
  ///
  /// In en, this message translates to:
  /// **'Check your inbox: the new address takes effect once you confirm it.'**
  String get emailChangeConfirm;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get passwordChanged;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @connectionErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionErrorTitle;

  /// No description provided for @authenticationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication Error'**
  String get authenticationErrorTitle;

  /// No description provided for @permissionErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Error'**
  String get permissionErrorTitle;

  /// No description provided for @errorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network settings.'**
  String get errorNoConnection;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error occurred. Please try again.'**
  String get errorNetwork;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorAccountLocked.
  ///
  /// In en, this message translates to:
  /// **'Your account has been locked. Please contact support.'**
  String get errorAccountLocked;

  /// No description provided for @errorAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get errorAuthFailed;

  /// No description provided for @errorForumNotFound.
  ///
  /// In en, this message translates to:
  /// **'Forum not found.'**
  String get errorForumNotFound;

  /// No description provided for @errorForumAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to access this forum.'**
  String get errorForumAccessDenied;

  /// No description provided for @errorForumUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Forum is currently unavailable. Please try again later.'**
  String get errorForumUnavailable;

  /// No description provided for @errorForumGeneric.
  ///
  /// In en, this message translates to:
  /// **'Forum error occurred. Please try again.'**
  String get errorForumGeneric;

  /// No description provided for @errorDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Requested data not found.'**
  String get errorDataNotFound;

  /// No description provided for @errorDataCorrupted.
  ///
  /// In en, this message translates to:
  /// **'Data appears to be corrupted. Please refresh the page.'**
  String get errorDataCorrupted;

  /// No description provided for @errorCache.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cached data. Please try again.'**
  String get errorCache;

  /// No description provided for @errorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Something you entered is not valid.'**
  String get errorInvalidInput;

  /// No description provided for @errorRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields.'**
  String get errorRequiredField;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to do that.'**
  String get errorPermissionDenied;

  /// A feature the forum does not offer, e.g. Passkeys
  ///
  /// In en, this message translates to:
  /// **'{feature} is not available on this forum.'**
  String errorFeatureNotAvailable(String feature);

  /// No description provided for @errorStorageFull.
  ///
  /// In en, this message translates to:
  /// **'Storage is full. Please free up some space.'**
  String get errorStorageFull;

  /// No description provided for @errorStorageAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage access denied. Please check app permissions.'**
  String get errorStorageAccessDenied;

  /// No description provided for @loginInfo.
  ///
  /// In en, this message translates to:
  /// **'Login Info'**
  String get loginInfo;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @topicAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get topicAnnouncement;

  /// No description provided for @topicPinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get topicPinned;

  /// No description provided for @topicLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get topicLocked;

  /// No description provided for @topicPoll.
  ///
  /// In en, this message translates to:
  /// **'Poll'**
  String get topicPoll;

  /// Badge on a deleted post or topic, upper case where the language has it
  ///
  /// In en, this message translates to:
  /// **'DELETED'**
  String get deletedBadge;

  /// Badge on a password-protected forum
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get protectedBadge;

  /// No description provided for @lockTopic.
  ///
  /// In en, this message translates to:
  /// **'Lock Topic'**
  String get lockTopic;

  /// No description provided for @unlockTopic.
  ///
  /// In en, this message translates to:
  /// **'Unlock Topic'**
  String get unlockTopic;

  /// No description provided for @lockTopicConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to lock this topic? Other users will not be able to reply or interact with it.'**
  String get lockTopicConfirm;

  /// No description provided for @unlockTopicConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unlock this topic? Other users will be able to reply and interact with it again.'**
  String get unlockTopicConfirm;

  /// No description provided for @stickTopic.
  ///
  /// In en, this message translates to:
  /// **'Stick Topic'**
  String get stickTopic;

  /// No description provided for @unstickTopic.
  ///
  /// In en, this message translates to:
  /// **'Unstick Topic'**
  String get unstickTopic;

  /// No description provided for @stickTopicConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stick this topic? It will appear at the top of the forum for all users.'**
  String get stickTopicConfirm;

  /// No description provided for @unstickTopicConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unstick this topic? It will no longer appear at the top of the forum.'**
  String get unstickTopicConfirm;

  /// No description provided for @undeleteTopic.
  ///
  /// In en, this message translates to:
  /// **'Undelete Topic'**
  String get undeleteTopic;

  /// No description provided for @undeleteTopicConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to undelete this topic? It will be visible to other users again.'**
  String get undeleteTopicConfirm;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get selectDateOfBirth;

  /// No description provided for @minimumAge.
  ///
  /// In en, this message translates to:
  /// **'{age, plural, one{Minimum age: {age} year} other{Minimum age: {age} years}}'**
  String minimumAge(int age);

  /// No description provided for @locationIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get locationIsRequired;

  /// No description provided for @receiveSiteMailings.
  ///
  /// In en, this message translates to:
  /// **'Receive site mailings'**
  String get receiveSiteMailings;

  /// Registration checkbox; {document} is the linked Terms of Service or Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'I accept the {document}'**
  String iAcceptTheDocument(String document);

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @imageExceedsUploadLimits.
  ///
  /// In en, this message translates to:
  /// **'This image exceeds the upload limits and needs to be optimized:'**
  String get imageExceedsUploadLimits;

  /// No description provided for @originalSize.
  ///
  /// In en, this message translates to:
  /// **'Original Size'**
  String get originalSize;

  /// No description provided for @originalDimensions.
  ///
  /// In en, this message translates to:
  /// **'Original Dimensions'**
  String get originalDimensions;

  /// No description provided for @optimizationsToBeApplied.
  ///
  /// In en, this message translates to:
  /// **'Optimizations to be applied:'**
  String get optimizationsToBeApplied;

  /// No description provided for @resizeImage.
  ///
  /// In en, this message translates to:
  /// **'Resize'**
  String get resizeImage;

  /// No description provided for @convertFormat.
  ///
  /// In en, this message translates to:
  /// **'Convert Format'**
  String get convertFormat;

  /// No description provided for @smallerFileSize.
  ///
  /// In en, this message translates to:
  /// **'smaller file size'**
  String get smallerFileSize;

  /// No description provided for @formatNotSupported.
  ///
  /// In en, this message translates to:
  /// **'format not supported'**
  String get formatNotSupported;

  /// No description provided for @convertToJpgReason.
  ///
  /// In en, this message translates to:
  /// **'Convert to JPG (format not supported or for size reduction)'**
  String get convertToJpgReason;

  /// No description provided for @compressImage.
  ///
  /// In en, this message translates to:
  /// **'Compress'**
  String get compressImage;

  /// No description provided for @compressQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality: {quality}% to meet size limit'**
  String compressQuality(int quality);

  /// No description provided for @estimatedFinalSize.
  ///
  /// In en, this message translates to:
  /// **'Estimated Final Size'**
  String get estimatedFinalSize;

  /// No description provided for @sizeReduction.
  ///
  /// In en, this message translates to:
  /// **'Reduction: {percent}%'**
  String sizeReduction(String percent);

  /// No description provided for @pleaseLoginToCreateTopic.
  ///
  /// In en, this message translates to:
  /// **'Please log in to create a new topic'**
  String get pleaseLoginToCreateTopic;

  /// No description provided for @pleaseLoginToSubscribeForums.
  ///
  /// In en, this message translates to:
  /// **'Please log in to subscribe to forums'**
  String get pleaseLoginToSubscribeForums;

  /// No description provided for @pleaseLoginToUnsubscribeForums.
  ///
  /// In en, this message translates to:
  /// **'Please log in to unsubscribe from forums'**
  String get pleaseLoginToUnsubscribeForums;

  /// No description provided for @errorLoadingContent.
  ///
  /// In en, this message translates to:
  /// **'Error loading content: {error}'**
  String errorLoadingContent(String error);

  /// No description provided for @noPermissionToViewSubforumTopics.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view topics in this subforum.'**
  String get noPermissionToViewSubforumTopics;

  /// No description provided for @noDiscussionsYet.
  ///
  /// In en, this message translates to:
  /// **'No discussions yet.'**
  String get noDiscussionsYet;

  /// No description provided for @unableToLoadForums.
  ///
  /// In en, this message translates to:
  /// **'Unable to Load Forums'**
  String get unableToLoadForums;

  /// No description provided for @noForumsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Forums Available'**
  String get noForumsAvailable;

  /// No description provided for @noForumsToDisplay.
  ///
  /// In en, this message translates to:
  /// **'There are no forums to display. This might be due to permissions or the forum structure.'**
  String get noForumsToDisplay;

  /// No description provided for @subscribedForums.
  ///
  /// In en, this message translates to:
  /// **'Subscribed Forums'**
  String get subscribedForums;

  /// No description provided for @allForumTopicsMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'All forum topics have been marked as read'**
  String get allForumTopicsMarkedRead;

  /// Forum post total; {count} is already formatted (e.g. 12.3K)
  ///
  /// In en, this message translates to:
  /// **'{count} Posts'**
  String postsCountFormatted(String count);

  /// No description provided for @jumpToPost.
  ///
  /// In en, this message translates to:
  /// **'Jump to Post'**
  String get jumpToPost;

  /// No description provided for @jump.
  ///
  /// In en, this message translates to:
  /// **'Jump'**
  String get jump;

  /// No description provided for @endOfDiscussion.
  ///
  /// In en, this message translates to:
  /// **'End of the discussion'**
  String get endOfDiscussion;

  /// No description provided for @refreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Refresh failed: {error}'**
  String refreshFailed(String error);

  /// No description provided for @topicDeletedHidden.
  ///
  /// In en, this message translates to:
  /// **'This topic is deleted and hidden from other users'**
  String get topicDeletedHidden;

  /// No description provided for @topicClosedNoReplies.
  ///
  /// In en, this message translates to:
  /// **'This topic is closed and no longer accepting replies'**
  String get topicClosedNoReplies;

  /// No description provided for @youAreSubscribedToTopic.
  ///
  /// In en, this message translates to:
  /// **'You are subscribed to this topic'**
  String get youAreSubscribedToTopic;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// No description provided for @unableToLoadForumsTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Unable to load forums. Please try again.'**
  String get unableToLoadForumsTryAgain;

  /// No description provided for @noPostableForums.
  ///
  /// In en, this message translates to:
  /// **'No postable forums are available.'**
  String get noPostableForums;

  /// No description provided for @changeForumQuestion.
  ///
  /// In en, this message translates to:
  /// **'Change forum?'**
  String get changeForumQuestion;

  /// No description provided for @changeForumRemovesAttachments.
  ///
  /// In en, this message translates to:
  /// **'Changing the forum will remove your uploaded attachments because attachments are tied to the selected forum.'**
  String get changeForumRemovesAttachments;

  /// No description provided for @changeForum.
  ///
  /// In en, this message translates to:
  /// **'Change Forum'**
  String get changeForum;

  /// No description provided for @chooseForumBeforePosting.
  ///
  /// In en, this message translates to:
  /// **'Please choose a forum before posting'**
  String get chooseForumBeforePosting;

  /// No description provided for @accountCannotUploadAttachments.
  ///
  /// In en, this message translates to:
  /// **'Your account cannot upload attachments on this site.'**
  String get accountCannotUploadAttachments;

  /// No description provided for @forumNoAttachments.
  ///
  /// In en, this message translates to:
  /// **'This forum does not allow attachments.'**
  String get forumNoAttachments;

  /// No description provided for @forumNoAttachmentsChooseAnother.
  ///
  /// In en, this message translates to:
  /// **'This forum does not allow attachments. Choose a different forum to upload the shared files.'**
  String get forumNoAttachmentsChooseAnother;

  /// No description provided for @forumNoAttachmentsSharedPending.
  ///
  /// In en, this message translates to:
  /// **'This forum does not allow attachments. Shared files will stay pending until you choose another forum.'**
  String get forumNoAttachmentsSharedPending;

  /// No description provided for @tapToChangeForum.
  ///
  /// In en, this message translates to:
  /// **'Tap to change forum'**
  String get tapToChangeForum;

  /// No description provided for @chooseWhichForum.
  ///
  /// In en, this message translates to:
  /// **'Choose which forum to post to'**
  String get chooseWhichForum;

  /// No description provided for @selectAForum.
  ///
  /// In en, this message translates to:
  /// **'Select a forum'**
  String get selectAForum;

  /// No description provided for @unableToLoadForumsNow.
  ///
  /// In en, this message translates to:
  /// **'Unable to load forums right now.'**
  String get unableToLoadForumsNow;

  /// No description provided for @pickForumBeforeUploading.
  ///
  /// In en, this message translates to:
  /// **'Pick a forum before uploading attachments or posting.'**
  String get pickForumBeforeUploading;

  /// No description provided for @uploadingSharedFiles.
  ///
  /// In en, this message translates to:
  /// **'Uploading shared files...'**
  String get uploadingSharedFiles;

  /// No description provided for @selectForum.
  ///
  /// In en, this message translates to:
  /// **'Select Forum'**
  String get selectForum;

  /// No description provided for @noForumsMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No forums match your search.'**
  String get noForumsMatchSearch;

  /// Stands in for a missing member name
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @closeConversationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close this conversation? This will prevent new replies from being posted.'**
  String get closeConversationConfirm;

  /// No description provided for @openConversationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to open this conversation? This will allow new replies to be posted.'**
  String get openConversationConfirm;

  /// No description provided for @leaveConversationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this conversation? This will hide it from your inbox.'**
  String get leaveConversationConfirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @errorLoadingConversation.
  ///
  /// In en, this message translates to:
  /// **'Error loading conversation: {error}'**
  String errorLoadingConversation(String error);

  /// No description provided for @conversationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Conversation not found'**
  String get conversationNotFound;

  /// No description provided for @conversationClosedNoReplies.
  ///
  /// In en, this message translates to:
  /// **'This conversation is closed and no longer accepting replies'**
  String get conversationClosedNoReplies;

  /// No description provided for @noMessagesFound.
  ///
  /// In en, this message translates to:
  /// **'No messages found'**
  String get noMessagesFound;

  /// No description provided for @endOfConversation.
  ///
  /// In en, this message translates to:
  /// **'End of conversation'**
  String get endOfConversation;

  /// No description provided for @jumpToMessage.
  ///
  /// In en, this message translates to:
  /// **'Jump to Message'**
  String get jumpToMessage;

  /// No description provided for @jumpToFirstMessage.
  ///
  /// In en, this message translates to:
  /// **'Jump to first message'**
  String get jumpToFirstMessage;

  /// No description provided for @jumpToLastMessage.
  ///
  /// In en, this message translates to:
  /// **'Jump to last message'**
  String get jumpToLastMessage;

  /// No description provided for @messagePositionOf.
  ///
  /// In en, this message translates to:
  /// **'Message {position} of {total}'**
  String messagePositionOf(int position, int total);

  /// No description provided for @tapToJumpToMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap to jump to a specific message'**
  String get tapToJumpToMessage;

  /// No description provided for @failedToReact.
  ///
  /// In en, this message translates to:
  /// **'Failed to react: {error}'**
  String failedToReact(String error);

  /// No description provided for @participantCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} participant} other{{count} participants}}'**
  String participantCount(int count);

  /// No description provided for @noImagesToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No images found to display.'**
  String get noImagesToDisplay;

  /// No description provided for @pleaseLoginToViewAttachment.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view this attachment'**
  String get pleaseLoginToViewAttachment;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @errorLoadingMessages.
  ///
  /// In en, this message translates to:
  /// **'Error loading messages: {error}'**
  String errorLoadingMessages(String error);

  /// No description provided for @noInboxMessages.
  ///
  /// In en, this message translates to:
  /// **'No inbox messages'**
  String get noInboxMessages;

  /// No description provided for @noSentMessages.
  ///
  /// In en, this message translates to:
  /// **'No sent messages'**
  String get noSentMessages;

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get unknownDate;

  /// No description provided for @searchForTopics.
  ///
  /// In en, this message translates to:
  /// **'Search for topics'**
  String get searchForTopics;

  /// No description provided for @noTopicsFound.
  ///
  /// In en, this message translates to:
  /// **'No topics found'**
  String get noTopicsFound;

  /// No description provided for @noPostsFound.
  ///
  /// In en, this message translates to:
  /// **'No posts found'**
  String get noPostsFound;

  /// No description provided for @trySearchingDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords'**
  String get trySearchingDifferentKeywords;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings: {error}'**
  String errorLoadingSettings(String error);

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @valueMustBeAtLeast.
  ///
  /// In en, this message translates to:
  /// **'Value must be at least {min}'**
  String valueMustBeAtLeast(String min);

  /// No description provided for @valueMustBeAtMost.
  ///
  /// In en, this message translates to:
  /// **'Value must be at most {max}'**
  String valueMustBeAtMost(String max);

  /// No description provided for @maximumLengthCharacters.
  ///
  /// In en, this message translates to:
  /// **'Maximum length is {max} characters'**
  String maximumLengthCharacters(int max);

  /// No description provided for @invalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get invalidFormat;

  /// No description provided for @shareToForumCopilot.
  ///
  /// In en, this message translates to:
  /// **'Share to Forum Copilot'**
  String get shareToForumCopilot;

  /// No description provided for @noSavedForumAccounts.
  ///
  /// In en, this message translates to:
  /// **'No saved forum accounts found.'**
  String get noSavedForumAccounts;

  /// No description provided for @addForumAccountFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a forum account in Forum Copilot first, then try sharing again.'**
  String get addForumAccountFirst;

  /// No description provided for @filesReadyToAttach.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} file ready to attach} other{{count} files ready to attach}}'**
  String filesReadyToAttach(int count);

  /// No description provided for @sharedTextWillBePrefilled.
  ///
  /// In en, this message translates to:
  /// **'Shared text will be prefilled'**
  String get sharedTextWillBePrefilled;

  /// No description provided for @errorSearchingForums.
  ///
  /// In en, this message translates to:
  /// **'Error searching forums: {error}'**
  String errorSearchingForums(String error);

  /// No description provided for @failedToLoadUserInfo.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user info: {error}'**
  String failedToLoadUserInfo(String error);

  /// No description provided for @areYouSureUnban.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unban {username}?'**
  String areYouSureUnban(String username);

  /// No description provided for @deletePostsProfilePostsComments.
  ///
  /// In en, this message translates to:
  /// **'Delete posts, profile posts, and comments'**
  String get deletePostsProfilePostsComments;

  /// No description provided for @areYouSureSpamClean.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to spam clean {username}?'**
  String areYouSureSpamClean(String username);

  /// No description provided for @successfullyCleanedSpamFor.
  ///
  /// In en, this message translates to:
  /// **'Successfully cleaned spam for {username}'**
  String successfullyCleanedSpamFor(String username);

  /// No description provided for @failedToCleanSpam.
  ///
  /// In en, this message translates to:
  /// **'Failed to clean spam'**
  String get failedToCleanSpam;

  /// No description provided for @imagesCount.
  ///
  /// In en, this message translates to:
  /// **'Images ({count})'**
  String imagesCount(int count);

  /// No description provided for @pleaseLoginToViewProfiles.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view user profiles.'**
  String get pleaseLoginToViewProfiles;

  /// No description provided for @tapToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to open'**
  String get tapToOpen;

  /// No description provided for @imageNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Image not available'**
  String get imageNotAvailable;

  /// No description provided for @tapToViewFullSizeImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to view full size image'**
  String get tapToViewFullSizeImage;

  /// No description provided for @loadingImage.
  ///
  /// In en, this message translates to:
  /// **'Loading image...'**
  String get loadingImage;

  /// No description provided for @loadingImageFrom.
  ///
  /// In en, this message translates to:
  /// **'Loading image from {host}'**
  String loadingImageFrom(String host);

  /// Under a spoiler title
  ///
  /// In en, this message translates to:
  /// **'(tap to reveal)'**
  String get tapToReveal;

  /// No description provided for @inlineAttachments.
  ///
  /// In en, this message translates to:
  /// **'Inline Attachments'**
  String get inlineAttachments;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @pleaseEnterValidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get pleaseEnterValidUrl;

  /// No description provided for @permissionDeniedToSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Permission denied to save image'**
  String get permissionDeniedToSaveImage;

  /// No description provided for @postNotFound.
  ///
  /// In en, this message translates to:
  /// **'Post not found.'**
  String get postNotFound;

  /// No description provided for @failedToUploadFileTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload file. Please try again.'**
  String get failedToUploadFileTryAgain;

  /// No description provided for @failedToPickFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick file'**
  String get failedToPickFile;

  /// No description provided for @onlyMoreAttachmentsAllowed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Only 1 more attachment allowed. Using the first image.} other{Only {count} more attachments allowed. Using the first {count} images.}}'**
  String onlyMoreAttachmentsAllowed(int count);

  /// No description provided for @attachmentLimitReachedSkipping.
  ///
  /// In en, this message translates to:
  /// **'Attachment limit reached. Skipping remaining images.'**
  String get attachmentLimitReachedSkipping;

  /// No description provided for @imageValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Image validation failed'**
  String get imageValidationFailed;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get imageUploadFailed;

  /// No description provided for @failedToUploadImageTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image. Please try again.'**
  String get failedToUploadImageTryAgain;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// Thread prefix (a label like [Solved] before the title)
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get prefix;

  /// No description provided for @failedToLoadPrefixes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load prefixes'**
  String get failedToLoadPrefixes;

  /// No description provided for @attachFileHint.
  ///
  /// In en, this message translates to:
  /// **'Attach a file to this message'**
  String get attachFileHint;

  /// No description provided for @uploadImageHint.
  ///
  /// In en, this message translates to:
  /// **'Upload an image to this message'**
  String get uploadImageHint;

  /// No description provided for @openFormattingOptions.
  ///
  /// In en, this message translates to:
  /// **'Open formatting options'**
  String get openFormattingOptions;

  /// No description provided for @failedToPostReply.
  ///
  /// In en, this message translates to:
  /// **'Failed to post reply. Please try again.'**
  String get failedToPostReply;

  /// No description provided for @failedToUpdatePost.
  ///
  /// In en, this message translates to:
  /// **'Failed to update post. Please try again.'**
  String get failedToUpdatePost;

  /// No description provided for @postDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Post deleted successfully'**
  String get postDeletedSuccessfully;

  /// No description provided for @failedToDeletePost.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete post: {error}'**
  String failedToDeletePost(String error);

  /// No description provided for @noPermissionToUploadAvatars.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to upload avatars'**
  String get noPermissionToUploadAvatars;

  /// No description provided for @avatarUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Avatar uploaded successfully'**
  String get avatarUploadedSuccessfully;

  /// No description provided for @unknownTopic.
  ///
  /// In en, this message translates to:
  /// **'Unknown Topic'**
  String get unknownTopic;

  /// No description provided for @connectionTimeoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Timeout'**
  String get connectionTimeoutTitle;

  /// No description provided for @connectionTimedOutTo.
  ///
  /// In en, this message translates to:
  /// **'The connection to {siteName} timed out. Please check your internet connection and try again.'**
  String connectionTimedOutTo(String siteName);

  /// No description provided for @failedToConnectCheckPlugin.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to {siteName}. Please check if the forum is available and the plugin is installed.'**
  String failedToConnectCheckPlugin(String siteName);

  /// No description provided for @voteFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Vote failed. Please try again.'**
  String get voteFailedTryAgain;

  /// No description provided for @noUserSpecified.
  ///
  /// In en, this message translates to:
  /// **'No user specified'**
  String get noUserSpecified;

  /// No description provided for @failedToLoadRecentPosts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recent posts'**
  String get failedToLoadRecentPosts;

  /// No description provided for @failedToLoadPreview.
  ///
  /// In en, this message translates to:
  /// **'Failed to load preview: {error}'**
  String failedToLoadPreview(String error);

  /// No description provided for @thanksCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Thanked by {count} person} other{Thanked by {count} people}}'**
  String thanksCountLabel(int count);

  /// No description provided for @thankedBy.
  ///
  /// In en, this message translates to:
  /// **'Thanked By'**
  String get thankedBy;

  /// Error message when attachment count exceeds limit
  ///
  /// In en, this message translates to:
  /// **'Maximum of {count} attachment(s) allowed'**
  String maximumAttachmentsAllowed(int count);

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @closeConversation.
  ///
  /// In en, this message translates to:
  /// **'Close conversation'**
  String get closeConversation;

  /// No description provided for @openConversation.
  ///
  /// In en, this message translates to:
  /// **'Open conversation'**
  String get openConversation;

  /// No description provided for @loginSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Login succeeded'**
  String get loginSucceeded;

  /// No description provided for @verificationErrorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during verification. Please try again.'**
  String get verificationErrorTryAgain;

  /// No description provided for @passkeyChallengeFailed.
  ///
  /// In en, this message translates to:
  /// **'Passkey sign-in could not be started.'**
  String get passkeyChallengeFailed;

  /// No description provided for @passkeyNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'This forum is not yet set up for passkey access on this app. Please sign in with your username and password.'**
  String get passkeyNotSetUp;

  /// No description provided for @noPasskeyForForum.
  ///
  /// In en, this message translates to:
  /// **'No passkey found for this forum. Sign in with your password, or create a passkey on the forum website first.'**
  String get noPasskeyForForum;

  /// No description provided for @pushNotificationsNotReady.
  ///
  /// In en, this message translates to:
  /// **'Push notifications are not ready yet'**
  String get pushNotificationsNotReady;

  /// No description provided for @pushEnabledFor.
  ///
  /// In en, this message translates to:
  /// **'Push notifications enabled for {siteName}'**
  String pushEnabledFor(String siteName);

  /// No description provided for @failedToEnablePush.
  ///
  /// In en, this message translates to:
  /// **'Failed to enable push notifications'**
  String get failedToEnablePush;

  /// No description provided for @failedToRegisterPush.
  ///
  /// In en, this message translates to:
  /// **'Failed to register for push notifications'**
  String get failedToRegisterPush;

  /// Language names are shown in their own language, e.g. Deutsch, 日本語
  ///
  /// In en, this message translates to:
  /// **'Translated from {source} to {target}'**
  String translatedFromTo(String source, String target);

  /// No description provided for @unableToOpenNotification.
  ///
  /// In en, this message translates to:
  /// **'Unable to open notification'**
  String get unableToOpenNotification;

  /// No description provided for @notificationMissingInfo.
  ///
  /// In en, this message translates to:
  /// **'This notification is missing information.'**
  String get notificationMissingInfo;

  /// No description provided for @couldNotOpenForum.
  ///
  /// In en, this message translates to:
  /// **'Could not open the forum.'**
  String get couldNotOpenForum;

  /// Android notification channel name, shown in the system settings
  ///
  /// In en, this message translates to:
  /// **'Forum Copilot Notifications'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications for Forum Copilot app'**
  String get notificationChannelDescription;

  /// No description provided for @fileTypeNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'File type .{extension} is not allowed. Allowed types: {allowed}'**
  String fileTypeNotAllowed(String extension, String allowed);

  /// No description provided for @fileSizeExceedsMaximum.
  ///
  /// In en, this message translates to:
  /// **'File size ({size}) exceeds the maximum of {max}'**
  String fileSizeExceedsMaximum(String size, String max);

  /// File type label next to an attachment
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get fileTypeAudio;

  /// File type label next to an attachment
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get fileTypeText;

  /// File type label next to an attachment
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get fileTypeArchive;

  /// File type label next to an attachment
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get fileTypeFile;

  /// No description provided for @imageFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Image file not found. The file may have been moved or deleted.'**
  String get imageFileNotFound;

  /// No description provided for @imagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Cannot read the image file.'**
  String get imagePermissionDenied;

  /// No description provided for @imageInsufficientSpace.
  ///
  /// In en, this message translates to:
  /// **'Insufficient disk space to optimize the image.'**
  String get imageInsufficientSpace;

  /// No description provided for @cannotAccessImageFile.
  ///
  /// In en, this message translates to:
  /// **'Cannot access image file: {error}'**
  String cannotAccessImageFile(String error);

  /// No description provided for @imageFormatUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Image format is corrupted or not supported. Please try a different image.'**
  String get imageFormatUnsupported;

  /// No description provided for @failedToResizeImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to resize image. The image may be corrupted or in an unsupported format.'**
  String get failedToResizeImage;

  /// No description provided for @failedToConvertImageToJpg.
  ///
  /// In en, this message translates to:
  /// **'Failed to convert image to JPG format. The image may be corrupted.'**
  String get failedToConvertImageToJpg;

  /// No description provided for @failedToCompressImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to compress image. There may be insufficient disk space or the image is corrupted.'**
  String get failedToCompressImage;

  /// No description provided for @cannotDecodeImage.
  ///
  /// In en, this message translates to:
  /// **'Cannot decode image. The file may be corrupted or in an unsupported format.'**
  String get cannotDecodeImage;

  /// No description provided for @cannotReadImageFile.
  ///
  /// In en, this message translates to:
  /// **'Cannot read image file. The file may have been moved or deleted.'**
  String get cannotReadImageFile;

  /// No description provided for @failedToOptimizeImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to optimize image: {error}'**
  String failedToOptimizeImage(String error);

  /// Message when email is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Email copied to clipboard: {email}'**
  String emailCopiedToClipboard(String email);

  /// Error message when email app cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open email: {email}'**
  String couldNotOpenEmail(String email);

  /// No description provided for @editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get editPost;

  /// No description provided for @thisTopicIsPinnedToTopOfForum.
  ///
  /// In en, this message translates to:
  /// **'This topic is pinned to the top of the forum'**
  String get thisTopicIsPinnedToTopOfForum;

  /// No description provided for @editConversation.
  ///
  /// In en, this message translates to:
  /// **'Edit conversation'**
  String get editConversation;

  /// No description provided for @failedToLoadConversation.
  ///
  /// In en, this message translates to:
  /// **'Failed to load conversation'**
  String get failedToLoadConversation;

  /// No description provided for @cannotEditConversation.
  ///
  /// In en, this message translates to:
  /// **'Cannot edit this conversation'**
  String get cannotEditConversation;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @openInvite.
  ///
  /// In en, this message translates to:
  /// **'Open Invite'**
  String get openInvite;

  /// No description provided for @allowAnyParticipantToInviteOthers.
  ///
  /// In en, this message translates to:
  /// **'Allow any participant to invite others'**
  String get allowAnyParticipantToInviteOthers;

  /// No description provided for @conversationOpen.
  ///
  /// In en, this message translates to:
  /// **'Conversation Open'**
  String get conversationOpen;

  /// Error message when creating conversation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create conversation: {error}'**
  String failedToCreateConversation(String error);

  /// No description provided for @lockConversation.
  ///
  /// In en, this message translates to:
  /// **'Lock Conversation'**
  String get lockConversation;

  /// No description provided for @createConversationAsClosed.
  ///
  /// In en, this message translates to:
  /// **'Create conversation as closed (no replies allowed)'**
  String get createConversationAsClosed;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Remove your account from this forum.'**
  String get deleteAccountDescription;

  /// No description provided for @deleteAccountContactForumMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is managed by the forum. Please contact the forum directly for account removal. Use the Contact Us button at the bottom of the forum home page.'**
  String get deleteAccountContactForumMessage;

  /// No description provided for @forumUrlUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Forum URL is unavailable.'**
  String get forumUrlUnavailable;

  /// No description provided for @couldNotOpenForumUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not open forum URL.'**
  String get couldNotOpenForumUrl;

  /// No description provided for @noActionUrlAvailableForThisNotificationType.
  ///
  /// In en, this message translates to:
  /// **'No action URL available for this notification type.'**
  String get noActionUrlAvailableForThisNotificationType;

  /// No description provided for @signInToViewNotifications.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view notifications'**
  String get signInToViewNotifications;

  /// No description provided for @youNeedToBeSignedInToViewYourNotifications.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to view your notifications.'**
  String get youNeedToBeSignedInToViewYourNotifications;

  /// No description provided for @errorLoadingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Error loading notifications'**
  String get errorLoadingNotifications;

  /// No description provided for @pullDownToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullDownToRefresh;

  /// No description provided for @youHaveNoNewNotificationsCheckBackLater.
  ///
  /// In en, this message translates to:
  /// **'You have no new notifications. Check back later for updates on topics you\'re following.'**
  String get youHaveNoNewNotificationsCheckBackLater;

  /// No description provided for @signInToViewProfile.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view profile'**
  String get signInToViewProfile;

  /// No description provided for @youNeedToBeSignedInToViewYourProfile.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to view your profile.'**
  String get youNeedToBeSignedInToViewYourProfile;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @protectedForum.
  ///
  /// In en, this message translates to:
  /// **'Protected Forum'**
  String get protectedForum;

  /// Message when forum requires a password
  ///
  /// In en, this message translates to:
  /// **'{forumName} is password protected.'**
  String forumIsPasswordProtected(String forumName);

  /// No description provided for @enterButton.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enterButton;

  /// No description provided for @recentPosts.
  ///
  /// In en, this message translates to:
  /// **'Recent Posts'**
  String get recentPosts;

  /// Message when passkey login is unavailable for current forum
  ///
  /// In en, this message translates to:
  /// **'Passkey is currently not available in this forum (code: {code})'**
  String passkeyNotAvailableInForum(int code);

  /// No description provided for @initializingForum.
  ///
  /// In en, this message translates to:
  /// **'Initializing forum…'**
  String get initializingForum;

  /// No description provided for @retryConnection.
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get retryConnection;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @pleaseEnterTheForumPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter the forum password'**
  String get pleaseEnterTheForumPassword;

  /// No description provided for @editYourPost.
  ///
  /// In en, this message translates to:
  /// **'Edit your post...'**
  String get editYourPost;

  /// No description provided for @topicIdIsMissingCannotNavigateToThePost.
  ///
  /// In en, this message translates to:
  /// **'Topic ID is missing. Cannot navigate to the post.'**
  String get topicIdIsMissingCannotNavigateToThePost;

  /// No description provided for @conversationIsOpenForReplies.
  ///
  /// In en, this message translates to:
  /// **'Conversation is open for replies'**
  String get conversationIsOpenForReplies;

  /// No description provided for @conversationIsClosedNoRepliesAllowed.
  ///
  /// In en, this message translates to:
  /// **'Conversation is closed (no replies allowed)'**
  String get conversationIsClosedNoRepliesAllowed;

  /// No description provided for @pleaseEnterAUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter a username'**
  String get pleaseEnterAUsername;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least {count} characters'**
  String usernameMinLength(int count);

  /// No description provided for @pleaseEnterAPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseEnterAPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {count} characters'**
  String passwordMinLength(int count);

  /// No description provided for @writeYourTopicTitle.
  ///
  /// In en, this message translates to:
  /// **'Write your topic title...'**
  String get writeYourTopicTitle;

  /// No description provided for @writeYourTopicContent.
  ///
  /// In en, this message translates to:
  /// **'Write your topic content...'**
  String get writeYourTopicContent;

  /// No description provided for @pushDisabledFor.
  ///
  /// In en, this message translates to:
  /// **'Push notifications disabled for {siteName}'**
  String pushDisabledFor(String siteName);

  /// No description provided for @failedToDisablePush.
  ///
  /// In en, this message translates to:
  /// **'Failed to disable push notifications'**
  String get failedToDisablePush;

  /// Stands in for the forum address in "Your username and password will be sent to {domain}"
  ///
  /// In en, this message translates to:
  /// **'this forum'**
  String get thisForum;

  /// Button next to the quick-reply field of a conversation: opens the full Reply page (attachments, formatting) with the text typed so far
  ///
  /// In en, this message translates to:
  /// **'Full editor'**
  String get openFullEditor;

  /// Forum home header stats, joined with " · "; the number is compact (56.8K)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} member} other{{count} members}}'**
  String statsMembers(int count);

  /// Forum home header stats, joined with " · "; the number is compact (18.5K)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} topic} other{{count} topics}}'**
  String statsTopics(int count);

  /// Forum home header stats, joined with " · "; the number is compact (1.2M)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} post} other{{count} posts}}'**
  String statsPosts(int count);

  /// The search field in the forum home header
  ///
  /// In en, this message translates to:
  /// **'Search {forumName}'**
  String searchForumName(String forumName);

  /// Post menu: copies a link to the post
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// After files shared into the app were attached to a new topic
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Attached 1 shared file.} other{Attached {count} shared files.}}'**
  String sharedFilesAttached(int count);

  /// After files shared into the app were attached to a new topic, some failed; names lists them
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Attached 1 file. Not attached: {names}} other{Attached {count} files. Not attached: {names}}}'**
  String sharedFilesPartlyAttached(int count, String names);

  /// Android notification channel name: direct messages
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get notificationChannelMessages;

  /// No description provided for @notificationChannelMessagesDescription.
  ///
  /// In en, this message translates to:
  /// **'New direct messages and replies to them'**
  String get notificationChannelMessagesDescription;

  /// Android notification channel name
  ///
  /// In en, this message translates to:
  /// **'Replies and mentions'**
  String get notificationChannelReplies;

  /// No description provided for @notificationChannelRepliesDescription.
  ///
  /// In en, this message translates to:
  /// **'Replies in threads you watch, quotes and mentions'**
  String get notificationChannelRepliesDescription;

  /// Android notification channel name
  ///
  /// In en, this message translates to:
  /// **'Likes and reactions'**
  String get notificationChannelReactions;

  /// No description provided for @notificationChannelReactionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Likes and reactions to your posts and messages'**
  String get notificationChannelReactionsDescription;

  /// Android notification channel name
  ///
  /// In en, this message translates to:
  /// **'Other notifications'**
  String get notificationChannelOther;

  /// No description provided for @notificationChannelOtherDescription.
  ///
  /// In en, this message translates to:
  /// **'Follows, trophies and other forum alerts'**
  String get notificationChannelOtherDescription;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account on {forumName} will be deleted, with your profile and settings. Your posts stay, under your name. This cannot be undone.'**
  String deleteAccountConfirmMessage(String forumName);

  /// For members who signed up with Google or Facebook
  ///
  /// In en, this message translates to:
  /// **'No password? Confirm with your user name'**
  String get deleteAccountNoPassword;

  /// No description provided for @deleteAccountUsePassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm with your password'**
  String get deleteAccountUsePassword;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get accountDeleted;

  /// No description provided for @signInOnWebsite.
  ///
  /// In en, this message translates to:
  /// **'Sign in on the forum\'s website'**
  String get signInOnWebsite;

  /// No description provided for @signInOnWebsiteHint.
  ///
  /// In en, this message translates to:
  /// **'For Google, Facebook and the other ways you sign in there'**
  String get signInOnWebsiteHint;

  /// No description provided for @browserLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Signing in on the website didn\'t work. Please try again.'**
  String get browserLoginFailed;

  /// Heading above a forum's sub-forums, before its topics
  ///
  /// In en, this message translates to:
  /// **'Sub-forums'**
  String get subForums;

  /// Screen reader: where the reader is in a thread, on its navigator
  ///
  /// In en, this message translates to:
  /// **'Post {position} of {total}'**
  String postPositionOf(int position, int total);

  /// Screen-reader hint on the thread navigator's position
  ///
  /// In en, this message translates to:
  /// **'Tap to jump to a specific post'**
  String get tapToJumpToPost;

  /// No description provided for @jumpToFirstPost.
  ///
  /// In en, this message translates to:
  /// **'Jump to first post'**
  String get jumpToFirstPost;

  /// No description provided for @jumpToLastPost.
  ///
  /// In en, this message translates to:
  /// **'Jump to last post'**
  String get jumpToLastPost;

  /// Label of a send button: a direct message, a quick reply in a conversation
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Label of the button that posts a reply or a new topic
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postAction;

  /// Screen reader: how many messages a conversation has
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} message} other{{count} messages}}'**
  String messageCountLabel(int count);

  /// Screen reader: how many replies a topic has
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} reply} other{{count} replies}}'**
  String replyCountLabel(int count);

  /// Screen reader: how many sub-forums a forum row lists
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} sub-forum} other{{count} sub-forums}}'**
  String subForumCountLabel(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'ja',
        'ko',
        'nl',
        'pt',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

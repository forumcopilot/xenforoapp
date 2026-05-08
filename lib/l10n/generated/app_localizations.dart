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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

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

  /// No description provided for @noSubscribedTopics.
  ///
  /// In en, this message translates to:
  /// **'No Subscribed Topics'**
  String get noSubscribedTopics;

  /// No description provided for @noSubscribedTopicsMessage.
  ///
  /// In en, this message translates to:
  /// **'You did not subscribe to any topics. Tap the star button on a topic to subscribe and receive notifications for new updates.'**
  String get noSubscribedTopicsMessage;

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

  /// Option for soft delete (can be restored)
  ///
  /// In en, this message translates to:
  /// **'Soft Delete'**
  String get softDelete;

  /// No description provided for @postCanBeRestoredLater.
  ///
  /// In en, this message translates to:
  /// **'Post can be restored later'**
  String get postCanBeRestoredLater;

  /// Option for hard delete (permanent)
  ///
  /// In en, this message translates to:
  /// **'Hard Delete'**
  String get hardDelete;

  /// No description provided for @postWillBePermanentlyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post will be permanently deleted'**
  String get postWillBePermanentlyDeleted;

  /// Label for deletion reason field
  ///
  /// In en, this message translates to:
  /// **'Reason for deletion'**
  String get reasonForDeletion;

  /// No description provided for @enterReasonForDeletingPost.
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for deleting this post'**
  String get enterReasonForDeletingPost;

  /// Validation message for deletion reason
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason for deletion'**
  String get pleaseEnterReasonForDeletion;

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

  /// Button to submit a report
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

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

  /// Title for report user dialog
  ///
  /// In en, this message translates to:
  /// **'Report User'**
  String get reportUser;

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

  /// Button to ban a user
  ///
  /// In en, this message translates to:
  /// **'Ban User'**
  String get banUser;

  /// No description provided for @unbanUser.
  ///
  /// In en, this message translates to:
  /// **'Unban User'**
  String get unbanUser;

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

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

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

  /// No description provided for @handleThreads.
  ///
  /// In en, this message translates to:
  /// **'Handle Threads'**
  String get handleThreads;

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

  /// Menu item for spam cleaner tool
  ///
  /// In en, this message translates to:
  /// **'Spam Cleaner'**
  String get spamCleaner;

  /// Button to send a message to a user
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

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

  /// Button to show more content
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// Button to execute spam clean
  ///
  /// In en, this message translates to:
  /// **'Clean Spam'**
  String get cleanSpam;

  /// No description provided for @failedToSaveMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save message'**
  String get failedToSaveMessage;

  /// Error message when saving conversation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save conversation'**
  String get failedToSaveConversation;

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

  /// No description provided for @enterUsernameToSearch.
  ///
  /// In en, this message translates to:
  /// **'Enter username to search...'**
  String get enterUsernameToSearch;

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

  /// Error message when thanking post fails
  ///
  /// In en, this message translates to:
  /// **'Failed to thank post: {error}'**
  String failedToThankPost(String error);

  /// Message asking user to sign in to view messages
  ///
  /// In en, this message translates to:
  /// **'Sign in to view messages'**
  String get signInToViewMessages;

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

  /// No description provided for @moveOrDeleteThreadsBasedOnAdminSettings.
  ///
  /// In en, this message translates to:
  /// **'Move or delete threads based on admin settings'**
  String get moveOrDeleteThreadsBasedOnAdminSettings;

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

  /// Description for soft delete option
  ///
  /// In en, this message translates to:
  /// **'Topic can be restored later'**
  String get topicCanBeRestoredLater;

  /// Description for hard delete option
  ///
  /// In en, this message translates to:
  /// **'Topic will be permanently deleted'**
  String get topicWillBePermanentlyDeleted;

  /// Hint text for deletion reason field
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for deleting this topic'**
  String get enterReasonForDeletingTopic;

  /// Error message when end date is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select an end date'**
  String get pleaseSelectEndDate;

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

  /// Button text to go to forums
  ///
  /// In en, this message translates to:
  /// **'Go to Forums'**
  String get goToForums;

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

  /// Accessibility label for thank button
  ///
  /// In en, this message translates to:
  /// **'Thank post'**
  String get thankPost;

  /// Accessibility hint for showing likes list
  ///
  /// In en, this message translates to:
  /// **'Show likes'**
  String get showLikes;

  /// Accessibility hint for showing thanks list
  ///
  /// In en, this message translates to:
  /// **'Show thanks'**
  String get showThanks;

  /// Accessibility label for quote button
  ///
  /// In en, this message translates to:
  /// **'Quote post'**
  String get quotePost;

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

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'Inloggen';

  @override
  String get usernameLabel => 'Gebruikersnaam';

  @override
  String get passwordLabel => 'Wachtwoord';

  @override
  String get loginButton => 'Inloggen';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get pleaseEnterUsername => 'Voer uw gebruikersnaam in';

  @override
  String get pleaseEnterPassword => 'Voer uw wachtwoord in';

  @override
  String credentialsSentToDomain(String domain) {
    return 'Uw gebruikersnaam en wachtwoord worden naar $domain gestuurd';
  }

  @override
  String get createAccount => 'Account aanmaken';

  @override
  String get alreadyHaveAccount => 'Heeft u al een account? ';

  @override
  String get logIn => 'Inloggen';

  @override
  String get continueButton => 'Doorgaan';

  @override
  String get registrationNotAvailable => 'Registratie niet beschikbaar';

  @override
  String get registrationNotAvailableMessage =>
      'Registratie is momenteel niet beschikbaar. Het forum kan gesloten zijn of registratie kan zijn uitgeschakeld.';

  @override
  String get webRegistrationRequired => 'Webregistratie vereist';

  @override
  String get webRegistrationRequiredMessage =>
      'Dit forum vereist registratie via de webbrowser. Klik op de knop hieronder om de registratiepagina te openen.';

  @override
  String get openRegistrationPage => 'Registratiepagina openen';

  @override
  String get loadingAdditionalFields => 'Extra velden laden...';

  @override
  String get pleaseSelectDateOfBirth => 'Selecteer uw geboortedatum';

  @override
  String get pleaseEnterLocation => 'Voer uw locatie in';

  @override
  String get pleaseIndicateEmailPreference => 'Geef uw e-mailvoorkeur op';

  @override
  String get pleaseFillAllRequiredFields => 'Vul alle verplichte velden in';

  @override
  String get pleaseAcceptTermsOfService => 'Accepteer de servicevoorwaarden';

  @override
  String get pleaseAcceptPrivacyPolicy => 'Accepteer het privacybeleid';

  @override
  String get registrationError => 'Registratiefout';

  @override
  String get registrationFailed =>
      'Registratie mislukt. Controleer uw gegevens.';

  @override
  String get registrationFailedTryAgain =>
      'Registratie mislukt. Probeer het opnieuw.';

  @override
  String get registrationInfo => 'Registratiegegevens';

  @override
  String get openWebsite => 'Website openen';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'Kon de forumwebsite niet openen. Probeer: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      'Registratie geslaagd! Controleer uw e-mail om uw account te bevestigen voordat u inlogt.';

  @override
  String get registrationSuccessfulPendingApproval =>
      'Registratie geslaagd! Uw account wacht op goedkeuring. U wordt op de hoogte gesteld wanneer uw account is goedgekeurd.';

  @override
  String get registrationSuccessfulAutoLogin =>
      'Registratie geslaagd! U bent automatisch ingelogd.';

  @override
  String get welcome => 'Welkom!';

  @override
  String get registrationSuccessful => 'Registratie geslaagd';

  @override
  String get pleaseLoginWithNewAccount => 'Log in met uw nieuwe account.';

  @override
  String get forgotPasswordTitle => 'Wachtwoord vergeten';

  @override
  String get usernameOrEmailLabel => 'Gebruikersnaam of e-mail';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Voer uw gebruikersnaam of e-mail in';

  @override
  String get sendResetLink => 'Resetlink verzenden';

  @override
  String get resetLinkSent => 'Resetlink verzonden';

  @override
  String get passwordResetInstructionsSent =>
      'Instructies voor het resetten van uw wachtwoord zijn naar uw geregistreerde e-mailadres gestuurd.';

  @override
  String get resetFailed => 'Reset mislukt';

  @override
  String get unableToSendResetLink =>
      'Kon resetlink niet verzenden. Probeer het opnieuw.';

  @override
  String get errorSendingResetLink =>
      'Er is een fout opgetreden bij het verzenden van de resetlink. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get errorTitle => 'Fout';

  @override
  String get okButton => 'OK';

  @override
  String get retryButton => 'Opnieuw';

  @override
  String get copyToClipboard => 'Kopiëren naar klembord';

  @override
  String get copied => 'Gekopieerd';

  @override
  String get errorMessageCopiedToClipboard =>
      'Foutbericht gekopieerd naar klembord';

  @override
  String get cancel => 'Annuleren';

  @override
  String get getHelp => 'Hulp krijgen';

  @override
  String get somethingWentWrong => 'Er is iets misgegaan';

  @override
  String get unexpectedErrorOccurred =>
      'Er is een onverwachte fout opgetreden. Probeer het opnieuw.';

  @override
  String get noInternetConnection => 'Geen internetverbinding';

  @override
  String get checkInternetConnection =>
      'Controleer uw internetverbinding en probeer het opnieuw.';

  @override
  String get authenticationRequired => 'Authenticatie vereist';

  @override
  String get pleaseLoginToContinue => 'Log in om door te gaan.';

  @override
  String get forumError => 'Forumfout';

  @override
  String get anErrorOccurred => 'Er is een fout opgetreden';

  @override
  String get accountPendingApproval =>
      'Uw account wacht op goedkeuring. U kunt het forum bekijken maar niet posten tot een moderator uw account goedkeurt.';

  @override
  String get checkEmailToConfirm =>
      'Controleer uw e-mail om uw account te bevestigen. Klik op de bevestigingslink in de e-mail die we u hebben gestuurd.';

  @override
  String get checkNewEmailToConfirm =>
      'Controleer uw nieuwe e-mailadres om de wijziging te bevestigen. Uw oude e-mail blijft actief tot u de nieuwe bevestigt.';

  @override
  String get emailAddressInvalid =>
      'Uw e-mailadres lijkt ongeldig of weigert e-mails. Werk uw e-mailadres bij in de accountinstellingen.';

  @override
  String get accountDisabled =>
      'Uw account is uitgeschakeld. Neem contact op met een beheerder voor hulp.';

  @override
  String get accountRegistrationRejected =>
      'Uw registratie is afgewezen. Neem contact op met een beheerder voor meer informatie.';

  @override
  String get welcomeToForumCopilot => 'Welkom bij Forum Copilot!';

  @override
  String get successfullyLoggedOut => 'U bent succesvol uitgelogd';

  @override
  String get accountStatusRequiresAttention =>
      'Uw accountstatus vereist aandacht. Neem contact op met een beheerder bij vragen.';

  @override
  String get updateEmail => 'E-mail bijwerken';

  @override
  String get resend => 'Opnieuw verzenden';

  @override
  String get noLatestTopics => 'Geen nieuwste onderwerpen';

  @override
  String get noRecentTopicsToDisplay =>
      'Er zijn geen recente onderwerpen om weer te geven. Kom later terug voor nieuwe discussies.';

  @override
  String get noUnreadTopics => 'Geen ongelezen onderwerpen';

  @override
  String get thereAreNoUnreadTopics =>
      'Er zijn geen ongelezen onderwerpen. Kom later terug voor nieuwe discussies.';

  @override
  String get youAreAllCaughtUp => 'U bent helemaal bij!';

  @override
  String get noSubscribedTopics => 'Geen geabonneerde onderwerpen';

  @override
  String get noSubscribedTopicsMessage =>
      'Je bent nog op geen onderwerpen geabonneerd. Open een onderwerp en kies Abonneren in het ⋮-menu om meldingen van nieuwe reacties te krijgen.';

  @override
  String get noParticipatedTopics =>
      'Geen onderwerpen waaraan u hebt deelgenomen';

  @override
  String get topicsYouParticipatedIn =>
      'Onderwerpen waaraan u hebt deelgenomen worden hier getoond.';

  @override
  String get latest => 'Nieuwste';

  @override
  String get unread => 'Ongelezen';

  @override
  String get subscribed => 'Geabonneerd';

  @override
  String get participated => 'Deelgenomen';

  @override
  String get connectionTimedOut =>
      'Verbinding time-out. De site kan offline of onbereikbaar zijn.';

  @override
  String get failedToConnectToSite =>
      'Kon geen verbinding maken met de site. De site kan offline of onbereikbaar zijn.';

  @override
  String get connectionFailed => 'Verbinding mislukt';

  @override
  String failedToConnectToSiteName(String siteName) {
    return 'Kon geen verbinding maken met $siteName';
  }

  @override
  String get loading => 'Laden...';

  @override
  String get newConversation => 'Nieuw gesprek';

  @override
  String get newMessage => 'Nieuw bericht';

  @override
  String get appSettings => 'App-instellingen';

  @override
  String get searchSites => 'Sites zoeken';

  @override
  String get all => 'Alles';

  @override
  String get topicsOnly => 'Alleen onderwerpen';

  @override
  String get titlesOnly => 'Alleen titels';

  @override
  String failedToShareTopic(String error) {
    return 'Kon onderwerp niet delen: $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'Log in om $action dit onderwerp';
  }

  @override
  String get subscribeTo => 'abonneren op';

  @override
  String get unsubscribeFrom => 'abonnement opzeggen van';

  @override
  String get subscribe => 'Abonneren';

  @override
  String get unsubscribe => 'Afmelden';

  @override
  String failedToSubscribeToThread(String action) {
    return 'Kon $action onderwerp niet';
  }

  @override
  String get youCannotReplyToThisThread =>
      'U kunt niet op dit onderwerp reageren';

  @override
  String get pleaseWaitForThreadToLoad => 'Wacht tot het onderwerp is geladen';

  @override
  String get postCanBeRestoredLater => 'Bericht kan later worden hersteld';

  @override
  String get postWillBePermanentlyDeleted =>
      'Bericht wordt permanent verwijderd';

  @override
  String get enterReasonForDeletingPost =>
      'Voer de reden voor het verwijderen van dit bericht in';

  @override
  String get reportPost => 'Bericht melden';

  @override
  String get pleaseProvideReasonForReporting =>
      'Geef een reden op voor het melden van dit bericht.';

  @override
  String get reason => 'Reden';

  @override
  String get enterReasonForReportingPost =>
      'Voer de reden voor het melden van dit bericht in';

  @override
  String get pleaseEnterReason => 'Voer een reden in';

  @override
  String get selectedActions => 'Geselecteerde acties:';

  @override
  String get thisActionCannotBeUndone =>
      'Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get participantsLabel => 'Deelnemers';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username is uitgenodigd voor het gesprek';
  }

  @override
  String errorInvitingUser(String error) {
    return 'Fout bij uitnodigen van gebruiker: $error';
  }

  @override
  String get newTopic => 'Nieuw onderwerp';

  @override
  String get markRead => 'Als gelezen markeren';

  @override
  String get pleaseSelectReasonForReportingUser =>
      'Selecteer een reden voor het melden van deze gebruiker.';

  @override
  String get spamOrAdvertising => 'Spam of reclame';

  @override
  String get harassmentOrBullying => 'Intimidatie of pesten';

  @override
  String get inappropriateContent => 'Ongepaste inhoud';

  @override
  String get impersonationOrFakeAccount => 'Impersonatie of nepaccount';

  @override
  String get otherPleaseSpecify => 'Anders (geef op)';

  @override
  String get pleaseSpecifyReason => 'Geef de reden op';

  @override
  String get enterReasonForReportingUser =>
      'Voer de reden voor het melden van deze gebruiker in';

  @override
  String get pleaseSelectReason => 'Selecteer een reden';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return 'Selecteer een reden voor het blokkeren van $username';
  }

  @override
  String get violationOfCommunityGuidelines =>
      'Overtreding van de communityrichtlijnen';

  @override
  String get harassmentOrAbusiveBehavior => 'Intimidatie of misbruik';

  @override
  String get postingInappropriateContent => 'Plaatsen van ongepaste inhoud';

  @override
  String get accountCompromiseOrSecurityIssue =>
      'Accountcompromittering of beveiligingsprobleem';

  @override
  String get enterReasonForBanningUser =>
      'Voer de reden voor het blokkeren van deze gebruiker in';

  @override
  String get banUntil => 'Blokkeren tot';

  @override
  String get selectDate => 'Selecteer datum';

  @override
  String get unbanUser => 'Blokkering opheffen';

  @override
  String get leaveConversation => 'Gesprek verlaten';

  @override
  String get reportConversation => 'Gesprek melden';

  @override
  String get topicClosed => 'Onderwerp gesloten';

  @override
  String get topicOpened => 'Onderwerp geopend';

  @override
  String get topicStickied => 'Onderwerp vastgezet';

  @override
  String get topicUnstickied => 'Onderwerp losgemaakt';

  @override
  String cannotEditMessage(String error) {
    return 'Dit bericht kan niet worden bewerkt: $error';
  }

  @override
  String get confirmSpamClean => 'Spam opruimen bevestigen';

  @override
  String get myForums => 'Mijn forums';

  @override
  String get recentlyVisited => 'Recent bezocht';

  @override
  String get explore => 'Ontdekken';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => 'Geen gesprekken';

  @override
  String get noConversationsMessage =>
      'U heeft nog geen gesprekken. Start een nieuw gesprek om te beginnen.';

  @override
  String get imageSavedToGallery => 'Afbeelding opgeslagen in galerij!';

  @override
  String failedToSaveImage(String error) {
    return 'Kon afbeelding niet opslaan: $error';
  }

  @override
  String get userProfile => 'Gebruikersprofiel';

  @override
  String get deletePost => 'Bericht verwijderen';

  @override
  String get loginRequired => 'Inloggen vereist';

  @override
  String get tryAgain => 'Opnieuw proberen';

  @override
  String get memberSince => 'Lid sinds';

  @override
  String get lastActivity => 'Laatste activiteit';

  @override
  String get likesReceived => 'Ontvangen likes';

  @override
  String get likesGiven => 'Gegeven likes';

  @override
  String get failedToSaveMessage => 'Kon bericht niet opslaan';

  @override
  String get failedToSaveSetting => 'Kon instelling niet opslaan';

  @override
  String get failedToSavePost => 'Kon bericht niet opslaan';

  @override
  String errorLoadingSites(String error) {
    return 'Fout bij laden van sites: $error';
  }

  @override
  String connectingTo(String domainName) {
    return 'Verbinden met $domainName...';
  }

  @override
  String get members => 'Leden';

  @override
  String get allMembers => 'Alle leden';

  @override
  String get online => 'Online';

  @override
  String get noMembersFound => 'Geen leden gevonden';

  @override
  String get searchForMembers => 'Leden zoeken';

  @override
  String get enterUsernameToFindMembers =>
      'Voer een gebruikersnaam in om forumleden te vinden';

  @override
  String get noMembersOnline => 'Er zijn momenteel geen leden online';

  @override
  String get lookupMembers => 'Leden opzoeken';

  @override
  String get addMembers => 'Leden toevoegen';

  @override
  String get membersAddedSuccessfully => 'Leden succesvol toegevoegd';

  @override
  String errorAddingMembers(String error) {
    return 'Fout bij toevoegen van leden: $error';
  }

  @override
  String get failedToLoadOnlineUsers => 'Kon online gebruikers niet laden';

  @override
  String get noUsersOnline => 'Geen gebruikers online';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString leden';
  }

  @override
  String get noSubject => 'Geen onderwerp';

  @override
  String get search => 'Zoeken';

  @override
  String get moreOptions => 'Meer opties';

  @override
  String get logout => 'Uitloggen';

  @override
  String get areYouSureYouWantToLogout => 'Weet u zeker dat u wilt uitloggen?';

  @override
  String get register => 'Registreren';

  @override
  String get signIn => 'Inloggen';

  @override
  String get markForumRead => 'Forum als gelezen markeren';

  @override
  String get notificationTest => 'Meldingstest';

  @override
  String get forum => 'Forum';

  @override
  String get profile => 'Profiel';

  @override
  String get messages => 'Berichten';

  @override
  String get add => 'Toevoegen';

  @override
  String get dismiss => 'Sluiten';

  @override
  String get retry => 'Opnieuw';

  @override
  String get delete => 'Verwijderen';

  @override
  String get deleteMessage => 'Bericht verwijderen';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'Weet u zeker dat u dit bericht wilt verwijderen?';

  @override
  String failedToDeleteMessage(String error) {
    return 'Kon bericht niet verwijderen: $error';
  }

  @override
  String get deletingPost => 'Bericht verwijderen...';

  @override
  String failedToUnlikePost(String error) {
    return 'Kon bericht niet unliken: $error';
  }

  @override
  String failedToLikePost(String error) {
    return 'Kon bericht niet liken: $error';
  }

  @override
  String get youNeedToBeSignedInToViewConversations =>
      'U moet ingelogd zijn om uw gesprekken te bekijken.';

  @override
  String errorLoadingConversations(String error) {
    return 'Fout bij laden van gesprekken: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return 'Kon gesprek niet verlaten: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return 'Fout bij laden van meer gesprekken: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'Fout bij laden van meer berichten: $error';
  }

  @override
  String get inviteMessageOptional => 'Uitnodigingsbericht (optioneel)';

  @override
  String get iWouldLikeToAddYouToThisConversation =>
      'Ik wil u aan dit gesprek toevoegen.';

  @override
  String get searchFailed => 'Zoeken mislukt';

  @override
  String get trySearchingWithDifferentUsername =>
      'Probeer te zoeken met een andere gebruikersnaam';

  @override
  String get enterUsernameToSearch => 'Voer gebruikersnaam in om te zoeken...';

  @override
  String get noSitesFound => 'Geen sites gevonden.';

  @override
  String get userInformationNotAvailable =>
      'Gebruikersinformatie niet beschikbaar';

  @override
  String get birthday => 'Verjaardag';

  @override
  String get posts => 'Berichten';

  @override
  String get following => 'Volgend';

  @override
  String get followers => 'Volgers';

  @override
  String get about => 'Over';

  @override
  String get location => 'Locatie';

  @override
  String get website => 'Website';

  @override
  String get signature => 'Handtekening';

  @override
  String get next => 'Volgende';

  @override
  String get permanent => 'Permanent';

  @override
  String get temporary => 'Tijdelijk';

  @override
  String setBanDurationFor(String username) {
    return 'Stel de blokkeerduur in voor $username';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan =>
      'Selecteer een einddatum voor tijdelijke blokkering';

  @override
  String get back => 'Terug';

  @override
  String get unban => 'Blokkering opheffen';

  @override
  String get confirm => 'Bevestigen';

  @override
  String spamClean(String username) {
    return 'Spam opruimen $username';
  }

  @override
  String get selectActionsToPerform => 'Selecteer de uit te voeren acties:';

  @override
  String get handleThreads => 'Onderwerpen afhandelen';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Verplaats of verwijder onderwerpen op basis van beheerderinstellingen';

  @override
  String get deleteMessages => 'Berichten verwijderen';

  @override
  String get deleteConversations => 'Gesprekken verwijderen';

  @override
  String get messageUpdatedSuccessfully => 'Bericht succesvol bijgewerkt';

  @override
  String error(String error) {
    return 'Fout: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return 'Kon bijlage niet verwijderen: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'Kon bericht niet laden: $error';
  }

  @override
  String get editMessage => 'Bericht bewerken';

  @override
  String get removeAttachment => 'Bijlage verwijderen';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      'Weet u zeker dat u deze bijlage wilt verwijderen?';

  @override
  String get none => 'Geen';

  @override
  String get formatting => 'Opmaak';

  @override
  String get bold => 'Vet';

  @override
  String get italic => 'Cursief';

  @override
  String get underline => 'Onderstreept';

  @override
  String get strikethrough => 'Doorgehaald';

  @override
  String get link => 'Link';

  @override
  String get image => 'Afbeelding';

  @override
  String get video => 'Video';

  @override
  String get quote => 'Citaat';

  @override
  String get code => 'Code';

  @override
  String get spoiler => 'Spoiler';

  @override
  String get bulletList => 'Opsomming';

  @override
  String get numberedList => 'Genummerde lijst';

  @override
  String get listItem => 'Lijstitem';

  @override
  String participants(int count) {
    return 'Deelnemers ($count)';
  }

  @override
  String get enterKeywordsToSearchTopics =>
      'Voer zoekwoorden in om onderwerpen te zoeken...';

  @override
  String get pleaseFillInAllRequiredFields => 'Vul alle verplichte velden in';

  @override
  String get undelete => 'Verwijdering ongedaan maken';

  @override
  String get signInToViewUnreadTopics =>
      'Log in om ongelezen onderwerpen te bekijken';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'U moet ingelogd zijn om uw ongelezen onderwerpen te bekijken.';

  @override
  String get signInToViewSubscribedTopics =>
      'Log in om geabonneerde onderwerpen te bekijken';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'U moet ingelogd zijn om uw geabonneerde onderwerpen te bekijken.';

  @override
  String get signInToViewParticipatedTopics =>
      'Log in om onderwerpen waaraan u hebt deelgenomen te bekijken';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'U moet ingelogd zijn om onderwerpen waaraan u hebt deelgenomen te bekijken.';

  @override
  String get signInToViewLatestTopics =>
      'Log in om nieuwste onderwerpen te bekijken';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'U moet ingelogd zijn om nieuwste onderwerpen te bekijken.';

  @override
  String get markAsUnread => 'Als ongelezen markeren';

  @override
  String get invite => 'Uitnodigen';

  @override
  String get welcomeBack => 'Welkom terug';

  @override
  String get signInToAccessYourProfile =>
      'Log in om uw profiel te openen en uw account te beheren';

  @override
  String get enterYourUsername => 'Voer uw gebruikersnaam in';

  @override
  String get enterYourPassword => 'Voer uw wachtwoord in';

  @override
  String get dontHaveAnAccount => 'Heeft u geen account?';

  @override
  String get refresh => 'Vernieuwen';

  @override
  String get share => 'Delen';

  @override
  String get viewOnWeb => 'Bekijken op web';

  @override
  String get unlock => 'Ontgrendelen';

  @override
  String get lock => 'Vergrendelen';

  @override
  String get stick => 'Vastzetten';

  @override
  String get unstick => 'Losmaken';

  @override
  String get reply => 'Beantwoorden';

  @override
  String get vote => 'Stemmen';

  @override
  String votesCount(int count) {
    return '$count stemmen';
  }

  @override
  String get pollClosed => 'Peiling gesloten';

  @override
  String pollEndsOn(String date) {
    return 'Eindigt op $date';
  }

  @override
  String get voteToSeeResults => 'Stem om resultaten te zien';

  @override
  String get viewFullPoll => 'Volledige peiling bekijken';

  @override
  String pollOptionsCount(int count) {
    return '$count opties';
  }

  @override
  String get reactedBy => 'Gereageerd door';

  @override
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vind-ik-leuks',
      one: '$count vind-ik-leuk',
    );
    return '$_temp0';
  }

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reacties',
      one: '$count reactie',
    );
    return '$_temp0';
  }

  @override
  String get showWhoReacted => 'Tik om te zien wie er reageerde.';

  @override
  String get react => 'Reageren';

  @override
  String get changeYourReaction => 'Je reactie wijzigen';

  @override
  String get reactionsAll => 'Alle';

  @override
  String get reactionYou => 'Jij';

  @override
  String reactionFilterSemantics(String reaction, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$reaction, $count personen',
      one: '$reaction, $count persoon',
    );
    return '$_temp0';
  }

  @override
  String viewProfileOfUser(String username) {
    return 'Profiel van $username bekijken';
  }

  @override
  String get enterKeywordsToFindTopicsAndPosts =>
      'Voer zoekwoorden in om onderwerpen en berichten te vinden';

  @override
  String get enterKeywordsOrDomainToFindForums =>
      'Voer zoekwoorden of domein in om forums te vinden';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'Voer zoekwoorden of domeinnamen in om forums te vinden';

  @override
  String get language => 'Taal';

  @override
  String get systemDefault => 'Systeemstandaard';

  @override
  String get followSystemLanguage => 'Systeemtaal volgen';

  @override
  String get appearance => 'Weergave';

  @override
  String get followSystemTheme => 'Systeemthema volgen';

  @override
  String get light => 'Licht';

  @override
  String get dark => 'Donker';

  @override
  String version(String version, String buildNumber) {
    return 'versie $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'Foruminstellingen';

  @override
  String get noSettingsAvailable => 'Geen instellingen beschikbaar';

  @override
  String get settingsCategoriesWillAppearHere =>
      'Instellingcategorieën verschijnen hier wanneer beschikbaar.';

  @override
  String get spamCleaner => 'Spam opruimer';

  @override
  String get unableToLoadProfile => 'Kon profiel niet laden';

  @override
  String get banned => 'GEBLOKKEERD';

  @override
  String get sendMessage => 'Bericht verzenden';

  @override
  String get showMore => 'Meer tonen';

  @override
  String get reportUser => 'Gebruiker melden';

  @override
  String get submitReport => 'Melding verzenden';

  @override
  String get reportSubmittedSuccessfully => 'Melding succesvol verzonden';

  @override
  String get failedToSubmitReport => 'Kon melding niet verzenden';

  @override
  String get searchForForums => 'Forums zoeken';

  @override
  String get searchForums => 'Forums zoeken';

  @override
  String get deleteTopic => 'Onderwerp verwijderen';

  @override
  String get softDelete => 'Zacht verwijderen';

  @override
  String get topicCanBeRestoredLater => 'Onderwerp kan later worden hersteld';

  @override
  String get hardDelete => 'Definitief verwijderen';

  @override
  String get topicWillBePermanentlyDeleted =>
      'Onderwerp wordt permanent verwijderd';

  @override
  String get reasonForDeletion => 'Reden voor verwijdering';

  @override
  String get enterReasonForDeletingTopic =>
      'Voer de reden voor het verwijderen van dit onderwerp in';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Voer een reden voor verwijdering in';

  @override
  String get pleaseSelectEndDate => 'Selecteer een einddatum';

  @override
  String get banUser => 'Gebruiker blokkeren';

  @override
  String get userBannedSuccessfully => 'Gebruiker succesvol geblokkeerd';

  @override
  String get failedToBanUser => 'Kon gebruiker niet blokkeren';

  @override
  String get userUnbannedSuccessfully => 'Gebruiker succesvol gedeblokkeerd';

  @override
  String get failedToUnbanUser => 'Kon blokkering niet opheffen';

  @override
  String get spamCleanUser => 'Spam opruimen gebruiker';

  @override
  String get deletePrivateConversations => 'Privégesprekken verwijderen';

  @override
  String get banTheUserAccount => 'Gebruikersaccount blokkeren';

  @override
  String get cleanSpam => 'Spam opruimen';

  @override
  String get handledThreads => 'Onderwerpen afgehandeld';

  @override
  String get deletedMessages => 'Berichten verwijderd';

  @override
  String get deletedConversations => 'Gesprekken verwijderd';

  @override
  String get bannedUser => 'Gebruiker geblokkeerd';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return 'Spam succesvol opgeruimd voor $username. Acties: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'Fout bij laden van bericht: $error';
  }

  @override
  String get messageNotFound => 'Bericht niet gevonden';

  @override
  String get home => 'Start';

  @override
  String get notifications => 'Meldingen';

  @override
  String get forums => 'Forums';

  @override
  String get markAllForumsAsRead => 'Alle forums als gelezen markeren?';

  @override
  String get markAllForumsAsReadMessage =>
      'Dit markeert alle forums en onderwerpen als gelezen. Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get markAsRead => 'Als gelezen markeren';

  @override
  String get content => 'Inhoud';

  @override
  String get insertImage => 'Afbeelding invoegen';

  @override
  String get howWouldYouLikeToInsertImage =>
      'Hoe wilt u deze afbeelding invoegen?';

  @override
  String get thumbnail => 'Miniatuur';

  @override
  String get fullSize => 'Volledige grootte';

  @override
  String get alignLeft => 'Links uitlijnen';

  @override
  String get alignCenter => 'Centreren';

  @override
  String get alignRight => 'Rechts uitlijnen';

  @override
  String get pleaseEnterTitle => 'Voer een titel in';

  @override
  String get pleaseEnterContent => 'Voer inhoud in';

  @override
  String get uploading => 'Uploaden...';

  @override
  String get uploaded => 'Geüpload';

  @override
  String get mentionUser => 'Gebruiker vermelden';

  @override
  String get loggingIn => 'Inloggen...';

  @override
  String get submittingReport => 'Melding verzenden...';

  @override
  String get banningUser => 'Gebruiker blokkeren...';

  @override
  String get unbanningUser => 'Blokkering opheffen...';

  @override
  String get cleaningSpam => 'Spam opruimen...';

  @override
  String get enterSubject => 'Voer onderwerp in';

  @override
  String get typeYourMessageHere => 'Typ hier uw bericht';

  @override
  String get writeYourMessage => 'Schrijf uw bericht...';

  @override
  String get writeYourReply => 'Schrijf uw antwoord...';

  @override
  String get messageSentSuccessfully => 'Bericht succesvol verzonden';

  @override
  String get replySentSuccessfully => 'Antwoord succesvol verzonden';

  @override
  String get conversationCreatedSuccessfully => 'Gesprek succesvol aangemaakt';

  @override
  String get conversationMarkedAsUnread => 'Gesprek als ongelezen gemarkeerd';

  @override
  String get messageMarkedAsUnread => 'Bericht als ongelezen gemarkeerd';

  @override
  String get conversationClosed => 'Gesprek gesloten';

  @override
  String get conversationOpened => 'Gesprek geopend';

  @override
  String get pleaseLoginToLikeMessages => 'Log in om berichten te liken';

  @override
  String get loadEarlierMessages => 'Eerdere berichten laden';

  @override
  String failedToLoadQuote(String error) {
    return 'Failed to load quote: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'Kon bestand niet uploaden: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Kon afbeelding niet uploaden: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'Kon bericht niet verzenden: $error';
  }

  @override
  String failedToSendReply(String error) {
    return 'Kon antwoord niet verzenden: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'Kon bericht niet als ongelezen markeren: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return 'Kon gesprek niet als ongelezen markeren: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return 'Kon gesprek niet sluiten: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return 'Kon gesprek niet openen: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'Kon niet naar bericht springen: $error';
  }

  @override
  String get goToTop => 'Naar boven';

  @override
  String get goToBottom => 'Naar beneden';

  @override
  String get replyAll => 'Allen beantwoorden';

  @override
  String get forward => 'Doorsturen';

  @override
  String get noForumsFound => 'Geen forums gevonden.';

  @override
  String get pleaseSelectPrefix => 'Selecteer een voorvoegsel';

  @override
  String get pleaseLoginToAccessContent =>
      'Log in om deze inhoud te bekijken en te reageren op berichten.';

  @override
  String get searchUsers => 'Gebruikers zoeken...';

  @override
  String get writeYourTitle => 'Schrijf uw titel...';

  @override
  String get writeYourContent => 'Schrijf uw inhoud...';

  @override
  String get selectAnOption => 'Selecteer een optie';

  @override
  String get enterConversationTitle => 'Voer gesprekstitel in';

  @override
  String enterCode(int count) {
    return 'Voer $count-cijferige code in';
  }

  @override
  String get edit => 'Bewerken';

  @override
  String get report => 'Melden';

  @override
  String get unfollow => 'Ontvolgen';

  @override
  String get follow => 'Volgen';

  @override
  String get remove => 'Verwijderen';

  @override
  String get subject => 'Onderwerp';

  @override
  String get message => 'Bericht';

  @override
  String get titleCannotBeEmpty => 'Titel mag niet leeg zijn';

  @override
  String get conversationUpdatedSuccessfully => 'Gesprek succesvol bijgewerkt';

  @override
  String get goBack => 'Terug';

  @override
  String get signInToViewMessages => 'Log in om berichten te bekijken';

  @override
  String get privateMessagesNotAvailable => 'Privéberichten niet beschikbaar';

  @override
  String failedToLoadPost(String error) {
    return 'Failed to load post: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'Kon bericht niet $action: $error';
  }

  @override
  String get like => 'liken';

  @override
  String get unlike => 'unliken';

  @override
  String get optimizeImage => 'Afbeelding optimaliseren';

  @override
  String get optimizeAndUpload => 'Optimaliseren en uploaden';

  @override
  String downloading(String filename) {
    return 'Downloaden $filename...';
  }

  @override
  String openingShareSheet(String filename) {
    return 'Deelmenu openen voor $filename';
  }

  @override
  String errorDownloading(String filename, String error) {
    return 'Fout bij downloaden $filename: $error';
  }

  @override
  String get enterANumber => 'Voer een getal in';

  @override
  String get failedToNavigateToForum => 'Kon niet naar forum navigeren';

  @override
  String failedToNavigateToForumName(String forumName) {
    return 'Kon niet navigeren naar $forumName';
  }

  @override
  String get failedToSaveConversation => 'Kon gesprek niet opslaan';

  @override
  String forumNotFound(String forumName) {
    return 'Forum niet gevonden: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'Forum niet gevonden: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'Kon link niet openen: $error';
  }

  @override
  String get likePost => 'Bericht liken';

  @override
  String get unlikePost => 'Bericht unliken';

  @override
  String get showLikes => 'Likes tonen';

  @override
  String get quotePost => 'Bericht citeren';

  @override
  String get attachFile => 'Bestand bijvoegen';

  @override
  String get uploadImage => 'Afbeelding uploaden';

  @override
  String get translate => 'Vertalen';

  @override
  String get showOriginal => 'Origineel tonen';

  @override
  String get translating => 'Vertalen...';

  @override
  String get translated => 'Vertaald';

  @override
  String get translatedContent => 'Vertaalde inhoud';

  @override
  String get selectLanguage => 'Taal selecteren';

  @override
  String get translateTo => 'Vertalen naar:';

  @override
  String get deviceLanguage => 'Apparaattaal';

  @override
  String get noPostsToTranslate => 'Geen berichten om te vertalen';

  @override
  String get translationFailed => 'Vertalen mislukt';

  @override
  String get twoFactorAuthentication => 'Tweefactorauthenticatie';

  @override
  String get authenticationCodeLabel => 'Authenticatiecode';

  @override
  String get pleaseEnterYourAuthenticationCode =>
      'Voer uw authenticatiecode in';

  @override
  String codeMustBeDigits(int count) {
    return 'Code moet $count cijfers bevatten';
  }

  @override
  String get codeMustContainOnlyNumbers => 'Code mag alleen cijfers bevatten';

  @override
  String get verifyButton => 'Verifiëren';

  @override
  String get attachments => 'Bijlagen';

  @override
  String get replyOptions => 'Antwoordopties';

  @override
  String get replyWithQuote => 'Antwoord met citaat';

  @override
  String fileSavedToDownloads(String filename) {
    return 'Bestand opgeslagen in Downloads: $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'Bestand opgeslagen in Documenten: $filename';
  }

  @override
  String get discardPostQuestion => 'Wil je je bericht weggooien?';

  @override
  String get discardChangesQuestion => 'Wil je je wijzigingen negeren?';

  @override
  String get discard => 'Verwerpen';

  @override
  String get discardChanges => 'Wijzigingen negeren';

  @override
  String get saveDraft => 'Concept opslaan';

  @override
  String get notificationsTab => 'Meldingen';

  @override
  String get postAwaitingApproval =>
      'Je bericht verschijnt zodra een moderator het heeft goedgekeurd.';

  @override
  String get reactionHoldHint => 'Houd ingedrukt voor meer reacties';

  @override
  String get turnOnNotifications => 'Meldingen inschakelen';

  @override
  String get notNow => 'Niet nu';

  @override
  String neverMissAReplyOn(Object forumName) {
    return 'Mis geen antwoord op $forumName';
  }

  @override
  String get notificationPreviewNow => 'nu';

  @override
  String get notificationPreviewEarlier => '5 min geleden';

  @override
  String get notificationPreviewReply =>
      'Jane heeft je geantwoord: Welkom! Fijn dat je ons gevonden hebt.';

  @override
  String get notificationPreviewMessage =>
      'Sam heeft je een bericht gestuurd: Kom je vrijdag?';

  @override
  String get notificationsAreTurnedOffForThisApp =>
      'Meldingen zijn uitgeschakeld voor deze app';

  @override
  String get deviceWillNotShowAlertsUntilAllowedInSettings =>
      'Je apparaat toont geen meldingen totdat je notificaties toestaat in Instellingen.';

  @override
  String get openSettings => 'Instellingen openen';

  @override
  String get notificationsPitchForum =>
      'Reacties, vermeldingen en privéberichten op je vergrendelscherm, zodra ze binnenkomen.';

  @override
  String get viewProfile => 'Profiel bekijken';

  @override
  String get settings => 'Instellingen';

  @override
  String get signOut => 'Afmelden';

  @override
  String get changeEmail => 'E-mailadres wijzigen';

  @override
  String get changePassword => 'Wachtwoord wijzigen';

  @override
  String get save => 'Opslaan';

  @override
  String get currentPassword => 'Huidig wachtwoord';

  @override
  String get newPassword => 'Nieuw wachtwoord';

  @override
  String get confirmNewPassword => 'Bevestig nieuw wachtwoord';

  @override
  String get newEmailAddress => 'Nieuw e-mailadres';

  @override
  String get emailChanged => 'E-mailadres gewijzigd';

  @override
  String get emailChangeConfirm =>
      'Kijk in je inbox: het nieuwe adres geldt zodra je het bevestigt.';

  @override
  String get passwordChanged => 'Wachtwoord gewijzigd';

  @override
  String get account => 'Account';

  @override
  String get pleaseEnterEmail => 'Voer uw e-mailadres in';

  @override
  String get pleaseEnterValidEmail => 'Voer een geldig e-mailadres in';

  @override
  String get passwordsDoNotMatch => 'Wachtwoorden komen niet overeen';

  @override
  String get connectionErrorTitle => 'Verbindingsfout';

  @override
  String get authenticationErrorTitle => 'Authenticatiefout';

  @override
  String get permissionErrorTitle => 'Machtigingsfout';

  @override
  String get errorNoConnection =>
      'Geen internetverbinding. Controleer uw netwerkinstellingen.';

  @override
  String get errorTimeout =>
      'Er is een time-out opgetreden. Probeer het opnieuw.';

  @override
  String get errorServer =>
      'Er is een serverfout opgetreden. Probeer het later opnieuw.';

  @override
  String get errorNetwork =>
      'Er is een netwerkfout opgetreden. Probeer het opnieuw.';

  @override
  String get errorInvalidCredentials =>
      'Ongeldige gebruikersnaam of wachtwoord.';

  @override
  String get errorSessionExpired => 'Uw sessie is verlopen. Log opnieuw in.';

  @override
  String get errorAccountLocked =>
      'Uw account is vergrendeld. Neem contact op met de ondersteuning.';

  @override
  String get errorAuthFailed => 'Authenticatie mislukt. Probeer het opnieuw.';

  @override
  String get errorForumNotFound => 'Forum niet gevonden.';

  @override
  String get errorForumAccessDenied =>
      'U hebt geen toestemming om dit forum te openen.';

  @override
  String get errorForumUnavailable =>
      'Het forum is momenteel niet beschikbaar. Probeer het later opnieuw.';

  @override
  String get errorForumGeneric =>
      'Er is een forumfout opgetreden. Probeer het opnieuw.';

  @override
  String get errorDataNotFound => 'De opgevraagde gegevens zijn niet gevonden.';

  @override
  String get errorDataCorrupted =>
      'De gegevens lijken beschadigd. Vernieuw de pagina.';

  @override
  String get errorCache =>
      'Kan opgeslagen gegevens niet laden. Probeer het opnieuw.';

  @override
  String get errorInvalidInput => 'Iets wat u hebt ingevoerd is ongeldig.';

  @override
  String get errorRequiredField => 'Vul alle verplichte velden in.';

  @override
  String get errorPermissionDenied => 'U hebt geen toestemming om dat te doen.';

  @override
  String errorFeatureNotAvailable(String feature) {
    return '$feature is niet beschikbaar op dit forum.';
  }

  @override
  String get errorStorageFull => 'De opslag is vol. Maak wat ruimte vrij.';

  @override
  String get errorStorageAccessDenied =>
      'Toegang tot opslag geweigerd. Controleer de app-machtigingen.';

  @override
  String get loginInfo => 'Inloginformatie';

  @override
  String get loginFailed => 'Inloggen mislukt';

  @override
  String get topicAnnouncement => 'Aankondiging';

  @override
  String get topicPinned => 'Vastgezet';

  @override
  String get topicLocked => 'Gesloten';

  @override
  String get topicPoll => 'Peiling';

  @override
  String get deletedBadge => 'VERWIJDERD';

  @override
  String get protectedBadge => 'Beveiligd';

  @override
  String get lockTopic => 'Onderwerp sluiten';

  @override
  String get unlockTopic => 'Onderwerp heropenen';

  @override
  String get lockTopicConfirm =>
      'Weet u zeker dat u dit onderwerp wilt sluiten? Andere gebruikers kunnen er dan niet meer op reageren.';

  @override
  String get unlockTopicConfirm =>
      'Weet u zeker dat u dit onderwerp wilt heropenen? Andere gebruikers kunnen er dan weer op reageren.';

  @override
  String get stickTopic => 'Onderwerp vastzetten';

  @override
  String get unstickTopic => 'Onderwerp losmaken';

  @override
  String get stickTopicConfirm =>
      'Weet u zeker dat u dit onderwerp wilt vastzetten? Het verschijnt bovenaan het forum voor alle gebruikers.';

  @override
  String get unstickTopicConfirm =>
      'Weet u zeker dat u dit onderwerp wilt losmaken? Het verschijnt dan niet meer bovenaan het forum.';

  @override
  String get undeleteTopic => 'Onderwerp herstellen';

  @override
  String get undeleteTopicConfirm =>
      'Weet u zeker dat u dit onderwerp wilt herstellen? Het is dan weer zichtbaar voor andere gebruikers.';

  @override
  String get additionalInformation => 'Aanvullende informatie';

  @override
  String get dateOfBirth => 'Geboortedatum';

  @override
  String get selectDateOfBirth => 'Kies uw geboortedatum';

  @override
  String minimumAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Minimumleeftijd: $age jaar',
      one: 'Minimumleeftijd: $age jaar',
    );
    return '$_temp0';
  }

  @override
  String get locationIsRequired => 'Locatie is verplicht';

  @override
  String get receiveSiteMailings => 'E-mails van de site ontvangen';

  @override
  String iAcceptTheDocument(String document) {
    return 'Ik ga akkoord met de $document';
  }

  @override
  String get termsOfService => 'Gebruiksvoorwaarden';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get imageExceedsUploadLimits =>
      'Deze afbeelding overschrijdt de uploadlimieten en moet worden geoptimaliseerd:';

  @override
  String get originalSize => 'Oorspronkelijke grootte';

  @override
  String get originalDimensions => 'Oorspronkelijke afmetingen';

  @override
  String get optimizationsToBeApplied => 'Toe te passen optimalisaties:';

  @override
  String get resizeImage => 'Formaat wijzigen';

  @override
  String get convertFormat => 'Formaat omzetten';

  @override
  String get smallerFileSize => 'kleiner bestand';

  @override
  String get formatNotSupported => 'formaat niet ondersteund';

  @override
  String get convertToJpgReason =>
      'Omzetten naar JPG (formaat niet ondersteund of om te verkleinen)';

  @override
  String get compressImage => 'Comprimeren';

  @override
  String compressQuality(int quality) {
    return 'Kwaliteit: $quality% om binnen de limiet te blijven';
  }

  @override
  String get estimatedFinalSize => 'Geschatte uiteindelijke grootte';

  @override
  String sizeReduction(String percent) {
    return 'Verkleining: $percent%';
  }

  @override
  String get pleaseLoginToCreateTopic =>
      'Log in om een nieuw onderwerp te maken';

  @override
  String get pleaseLoginToSubscribeForums =>
      'Log in om u op forums te abonneren';

  @override
  String get pleaseLoginToUnsubscribeForums =>
      'Log in om u af te melden voor forums';

  @override
  String errorLoadingContent(String error) {
    return 'Fout bij laden van inhoud: $error';
  }

  @override
  String get noPermissionToViewSubforumTopics =>
      'U hebt geen toestemming om onderwerpen in dit subforum te bekijken.';

  @override
  String get noDiscussionsYet => 'Nog geen discussies.';

  @override
  String get unableToLoadForums => 'Kan forums niet laden';

  @override
  String get noForumsAvailable => 'Geen forums beschikbaar';

  @override
  String get noForumsToDisplay =>
      'Er zijn geen forums om weer te geven. Dit kan aan machtigingen of de forumstructuur liggen.';

  @override
  String get subscribedForums => 'Geabonneerde forums';

  @override
  String get allForumTopicsMarkedRead =>
      'Alle onderwerpen in het forum zijn als gelezen gemarkeerd';

  @override
  String postsCountFormatted(String count) {
    return '$count berichten';
  }

  @override
  String get jumpToPost => 'Naar bericht gaan';

  @override
  String get jump => 'Ga';

  @override
  String get endOfDiscussion => 'Einde van de discussie';

  @override
  String refreshFailed(String error) {
    return 'Vernieuwen mislukt: $error';
  }

  @override
  String get topicDeletedHidden =>
      'Dit onderwerp is verwijderd en verborgen voor andere gebruikers';

  @override
  String get topicClosedNoReplies =>
      'Dit onderwerp is gesloten en accepteert geen reacties meer';

  @override
  String get youAreSubscribedToTopic => 'U bent geabonneerd op dit onderwerp';

  @override
  String get refreshing => 'Vernieuwen...';

  @override
  String get unableToLoadForumsTryAgain =>
      'Kan forums niet laden. Probeer het opnieuw.';

  @override
  String get noPostableForums => 'Er zijn geen forums waarin u kunt posten.';

  @override
  String get changeForumQuestion => 'Ander forum kiezen?';

  @override
  String get changeForumRemovesAttachments =>
      'Als u een ander forum kiest, worden uw geüploade bijlagen verwijderd, omdat bijlagen aan het gekozen forum gekoppeld zijn.';

  @override
  String get changeForum => 'Ander forum';

  @override
  String get chooseForumBeforePosting => 'Kies een forum voordat u post';

  @override
  String get accountCannotUploadAttachments =>
      'Uw account kan op deze site geen bijlagen uploaden.';

  @override
  String get forumNoAttachments => 'Dit forum staat geen bijlagen toe.';

  @override
  String get forumNoAttachmentsChooseAnother =>
      'Dit forum staat geen bijlagen toe. Kies een ander forum om de gedeelde bestanden te uploaden.';

  @override
  String get forumNoAttachmentsSharedPending =>
      'Dit forum staat geen bijlagen toe. Gedeelde bestanden blijven wachten tot u een ander forum kiest.';

  @override
  String get tapToChangeForum => 'Tik om een ander forum te kiezen';

  @override
  String get chooseWhichForum => 'Kies in welk forum u wilt posten';

  @override
  String get selectAForum => 'Kies een forum';

  @override
  String get unableToLoadForumsNow => 'Forums kunnen nu niet worden geladen.';

  @override
  String get pickForumBeforeUploading =>
      'Kies een forum voordat u bijlagen uploadt of post.';

  @override
  String get uploadingSharedFiles => 'Gedeelde bestanden uploaden...';

  @override
  String get selectForum => 'Forum kiezen';

  @override
  String get noForumsMatchSearch =>
      'Geen forums gevonden voor uw zoekopdracht.';

  @override
  String get unknown => 'Onbekend';

  @override
  String get closeConversationConfirm =>
      'Weet u zeker dat u dit gesprek wilt sluiten? Er kunnen dan geen nieuwe reacties meer worden geplaatst.';

  @override
  String get openConversationConfirm =>
      'Weet u zeker dat u dit gesprek wilt heropenen? Er kunnen dan weer nieuwe reacties worden geplaatst.';

  @override
  String get leaveConversationConfirm =>
      'Weet u zeker dat u dit gesprek wilt verlaten? Het wordt dan verborgen in uw inbox.';

  @override
  String get close => 'Sluiten';

  @override
  String get open => 'Openen';

  @override
  String get leave => 'Verlaten';

  @override
  String errorLoadingConversation(String error) {
    return 'Fout bij laden van gesprek: $error';
  }

  @override
  String get conversationNotFound => 'Gesprek niet gevonden';

  @override
  String get conversationClosedNoReplies =>
      'Dit gesprek is gesloten en accepteert geen reacties meer';

  @override
  String get noMessagesFound => 'Geen berichten gevonden';

  @override
  String get endOfConversation => 'Einde van het gesprek';

  @override
  String get jumpToMessage => 'Naar bericht gaan';

  @override
  String get jumpToFirstMessage => 'Naar eerste bericht gaan';

  @override
  String get jumpToLastMessage => 'Naar laatste bericht gaan';

  @override
  String messagePositionOf(int position, int total) {
    return 'Bericht $position van $total';
  }

  @override
  String get tapToJumpToMessage => 'Tik om naar een bepaald bericht te gaan';

  @override
  String failedToReact(String error) {
    return 'Reageren mislukt: $error';
  }

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deelnemers',
      one: '$count deelnemer',
    );
    return '$_temp0';
  }

  @override
  String get noImagesToDisplay => 'Geen afbeeldingen om weer te geven.';

  @override
  String get pleaseLoginToViewAttachment =>
      'Log in om deze bijlage te bekijken';

  @override
  String get inbox => 'Inbox';

  @override
  String get sent => 'Verzonden';

  @override
  String errorLoadingMessages(String error) {
    return 'Fout bij laden van berichten: $error';
  }

  @override
  String get noInboxMessages => 'Geen berichten in uw inbox';

  @override
  String get noSentMessages => 'Geen verzonden berichten';

  @override
  String get unknownDate => 'Onbekende datum';

  @override
  String get searchForTopics => 'Zoeken naar onderwerpen';

  @override
  String get noTopicsFound => 'Geen onderwerpen gevonden';

  @override
  String get noPostsFound => 'Geen berichten gevonden';

  @override
  String get trySearchingDifferentKeywords => 'Probeer andere zoekwoorden';

  @override
  String errorLoadingSettings(String error) {
    return 'Fout bij laden van instellingen: $error';
  }

  @override
  String get pleaseEnterValidNumber => 'Voer een geldig getal in';

  @override
  String valueMustBeAtLeast(String min) {
    return 'De waarde moet minstens $min zijn';
  }

  @override
  String valueMustBeAtMost(String max) {
    return 'De waarde mag hoogstens $max zijn';
  }

  @override
  String maximumLengthCharacters(int max) {
    return 'De maximale lengte is $max tekens';
  }

  @override
  String get invalidFormat => 'Ongeldige notatie';

  @override
  String get shareToForumCopilot => 'Delen met Forum Copilot';

  @override
  String get noSavedForumAccounts => 'Geen opgeslagen forumaccounts gevonden.';

  @override
  String get addForumAccountFirst =>
      'Voeg eerst een forumaccount toe in Forum Copilot en probeer daarna opnieuw te delen.';

  @override
  String filesReadyToAttach(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bestanden klaar om bij te voegen',
      one: '$count bestand klaar om bij te voegen',
    );
    return '$_temp0';
  }

  @override
  String get sharedTextWillBePrefilled =>
      'Gedeelde tekst wordt vooraf ingevuld';

  @override
  String errorSearchingForums(String error) {
    return 'Fout bij zoeken naar forums: $error';
  }

  @override
  String failedToLoadUserInfo(String error) {
    return 'Kan gebruikersgegevens niet laden: $error';
  }

  @override
  String areYouSureUnban(String username) {
    return 'Weet u zeker dat u de blokkering van $username wilt opheffen?';
  }

  @override
  String get deletePostsProfilePostsComments =>
      'Berichten, profielberichten en reacties verwijderen';

  @override
  String areYouSureSpamClean(String username) {
    return 'Weet u zeker dat u de spam van $username wilt opruimen?';
  }

  @override
  String successfullyCleanedSpamFor(String username) {
    return 'De spam van $username is opgeruimd';
  }

  @override
  String get failedToCleanSpam => 'Kan spam niet opruimen';

  @override
  String imagesCount(int count) {
    return 'Afbeeldingen ($count)';
  }

  @override
  String get pleaseLoginToViewProfiles =>
      'Log in om gebruikersprofielen te bekijken.';

  @override
  String get tapToOpen => 'Tik om te openen';

  @override
  String get imageNotAvailable => 'Afbeelding niet beschikbaar';

  @override
  String get tapToViewFullSizeImage =>
      'Tik om de afbeelding op volledige grootte te bekijken';

  @override
  String get loadingImage => 'Afbeelding laden...';

  @override
  String loadingImageFrom(String host) {
    return 'Afbeelding laden van $host';
  }

  @override
  String get tapToReveal => '(tik om te tonen)';

  @override
  String get inlineAttachments => 'Ingevoegde bijlagen';

  @override
  String get thisFieldIsRequired => 'Dit veld is verplicht';

  @override
  String get pleaseEnterValidPhoneNumber => 'Voer een geldig telefoonnummer in';

  @override
  String get pleaseEnterValidUrl => 'Voer een geldige URL in';

  @override
  String get permissionDeniedToSaveImage =>
      'Geen toestemming om de afbeelding op te slaan';

  @override
  String get postNotFound => 'Bericht niet gevonden.';

  @override
  String get failedToUploadFileTryAgain =>
      'Kan bestand niet uploaden. Probeer het opnieuw.';

  @override
  String get failedToPickFile => 'Kan bestand niet kiezen';

  @override
  String onlyMoreAttachmentsAllowed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Nog maar $count bijlagen toegestaan. De eerste $count afbeeldingen worden gebruikt.',
      one:
          'Nog maar 1 bijlage toegestaan. De eerste afbeelding wordt gebruikt.',
    );
    return '$_temp0';
  }

  @override
  String get attachmentLimitReachedSkipping =>
      'Bijlagelimiet bereikt. De overige afbeeldingen worden overgeslagen.';

  @override
  String get imageValidationFailed => 'Afbeeldingscontrole mislukt';

  @override
  String get imageUploadFailed => 'Kan afbeelding niet uploaden';

  @override
  String get failedToUploadImageTryAgain =>
      'Kan afbeelding niet uploaden. Probeer het opnieuw.';

  @override
  String get failedToPickImage => 'Kan afbeelding niet kiezen';

  @override
  String get prefix => 'Voorvoegsel';

  @override
  String get failedToLoadPrefixes => 'Kan voorvoegsels niet laden';

  @override
  String get attachFileHint => 'Een bestand aan dit bericht toevoegen';

  @override
  String get uploadImageHint => 'Een afbeelding aan dit bericht toevoegen';

  @override
  String get openFormattingOptions => 'Opmaakopties openen';

  @override
  String get failedToPostReply =>
      'Kan reactie niet plaatsen. Probeer het opnieuw.';

  @override
  String get failedToUpdatePost =>
      'Kan bericht niet bijwerken. Probeer het opnieuw.';

  @override
  String get postDeletedSuccessfully => 'Bericht verwijderd';

  @override
  String failedToDeletePost(String error) {
    return 'Kan bericht niet verwijderen: $error';
  }

  @override
  String get noPermissionToUploadAvatars =>
      'U hebt geen toestemming om avatars te uploaden';

  @override
  String get avatarUploadedSuccessfully => 'Avatar geüpload';

  @override
  String get unknownTopic => 'Onbekend onderwerp';

  @override
  String get connectionTimeoutTitle => 'Verbindingstime-out';

  @override
  String connectionTimedOutTo(String siteName) {
    return 'De verbinding met $siteName is verlopen. Controleer uw internetverbinding en probeer het opnieuw.';
  }

  @override
  String failedToConnectCheckPlugin(String siteName) {
    return 'Kan geen verbinding maken met $siteName. Controleer of het forum beschikbaar is en de plug-in is geïnstalleerd.';
  }

  @override
  String get voteFailedTryAgain => 'Stemmen mislukt. Probeer het opnieuw.';

  @override
  String get noUserSpecified => 'Geen gebruiker opgegeven';

  @override
  String get failedToLoadRecentPosts => 'Kan recente berichten niet laden';

  @override
  String failedToLoadPreview(String error) {
    return 'Kan voorbeeld niet laden: $error';
  }

  @override
  String thanksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bedankt door $count personen',
      one: 'Bedankt door $count persoon',
    );
    return '$_temp0';
  }

  @override
  String get thankedBy => 'Bedankt door';

  @override
  String maximumAttachmentsAllowed(int count) {
    return 'Maximaal $count bijlage(n) toegestaan';
  }

  @override
  String get toLabel => 'Aan';

  @override
  String get closeConversation => 'Gesprek sluiten';

  @override
  String get openConversation => 'Gesprek openen';

  @override
  String get loginSucceeded => 'Ingelogd';

  @override
  String get verificationErrorTryAgain =>
      'Er is een fout opgetreden bij de verificatie. Probeer het opnieuw.';

  @override
  String get passkeyChallengeFailed =>
      'Inloggen met passkey kon niet worden gestart.';

  @override
  String get passkeyNotSetUp =>
      'Dit forum is nog niet ingesteld voor passkeys in deze app. Log in met uw gebruikersnaam en wachtwoord.';

  @override
  String get noPasskeyForForum =>
      'Geen passkey gevonden voor dit forum. Log in met uw wachtwoord of maak eerst een passkey aan op de website van het forum.';

  @override
  String get pushNotificationsNotReady => 'Pushmeldingen zijn nog niet klaar';

  @override
  String pushEnabledFor(String siteName) {
    return 'Pushmeldingen ingeschakeld voor $siteName';
  }

  @override
  String get failedToEnablePush => 'Kan pushmeldingen niet inschakelen';

  @override
  String get failedToRegisterPush => 'Aanmelden voor pushmeldingen mislukt';

  @override
  String translatedFromTo(String source, String target) {
    return 'Vertaald uit $source naar $target';
  }

  @override
  String get unableToOpenNotification => 'Kan melding niet openen';

  @override
  String get notificationMissingInfo =>
      'Er ontbreekt informatie in deze melding.';

  @override
  String get couldNotOpenForum => 'Kan het forum niet openen.';

  @override
  String get notificationChannelName => 'Forum Copilot-meldingen';

  @override
  String get notificationChannelDescription =>
      'Meldingen van de Forum Copilot-app';

  @override
  String fileTypeNotAllowed(String extension, String allowed) {
    return 'Bestandstype .$extension is niet toegestaan. Toegestane types: $allowed';
  }

  @override
  String fileSizeExceedsMaximum(String size, String max) {
    return 'Bestandsgrootte ($size) is groter dan het maximum van $max';
  }

  @override
  String get fileTypeAudio => 'Audio';

  @override
  String get fileTypeText => 'Tekst';

  @override
  String get fileTypeArchive => 'Archief';

  @override
  String get fileTypeFile => 'Bestand';

  @override
  String get imageFileNotFound =>
      'Afbeeldingsbestand niet gevonden. Het is mogelijk verplaatst of verwijderd.';

  @override
  String get imagePermissionDenied =>
      'Geen toestemming. Kan het afbeeldingsbestand niet lezen.';

  @override
  String get imageInsufficientSpace =>
      'Onvoldoende schijfruimte om de afbeelding te optimaliseren.';

  @override
  String cannotAccessImageFile(String error) {
    return 'Kan afbeeldingsbestand niet openen: $error';
  }

  @override
  String get imageFormatUnsupported =>
      'Het afbeeldingsformaat is beschadigd of wordt niet ondersteund. Probeer een andere afbeelding.';

  @override
  String get failedToResizeImage =>
      'Kan het formaat van de afbeelding niet wijzigen. De afbeelding is mogelijk beschadigd of heeft een niet-ondersteund formaat.';

  @override
  String get failedToConvertImageToJpg =>
      'Kan de afbeelding niet naar JPG omzetten. De afbeelding is mogelijk beschadigd.';

  @override
  String get failedToCompressImage =>
      'Kan de afbeelding niet comprimeren. Er is mogelijk te weinig ruimte of de afbeelding is beschadigd.';

  @override
  String get cannotDecodeImage =>
      'Kan de afbeelding niet decoderen. Het bestand is mogelijk beschadigd of heeft een niet-ondersteund formaat.';

  @override
  String get cannotReadImageFile =>
      'Kan het afbeeldingsbestand niet lezen. Het is mogelijk verplaatst of verwijderd.';

  @override
  String failedToOptimizeImage(String error) {
    return 'Kan afbeelding niet optimaliseren: $error';
  }

  @override
  String emailCopiedToClipboard(String email) {
    return 'E-mail gekopieerd naar klembord: $email';
  }

  @override
  String couldNotOpenEmail(String email) {
    return 'Kon e-mail niet openen: $email';
  }

  @override
  String get editPost => 'Bericht bewerken';

  @override
  String get thisTopicIsPinnedToTopOfForum =>
      'Dit onderwerp is vastgezet bovenaan het forum';

  @override
  String get editConversation => 'Gesprek bewerken';

  @override
  String get failedToLoadConversation => 'Kon gesprek niet laden';

  @override
  String get cannotEditConversation => 'Kan dit gesprek niet bewerken';

  @override
  String get titleLabel => 'Titel';

  @override
  String get options => 'Opties';

  @override
  String get openInvite => 'Open uitnodigen';

  @override
  String get allowAnyParticipantToInviteOthers =>
      'Sta toe dat elke deelnemer anderen uitnodigt';

  @override
  String get conversationOpen => 'Gesprek open';

  @override
  String failedToCreateConversation(String error) {
    return 'Kon gesprek niet aanmaken: $error';
  }

  @override
  String get lockConversation => 'Gesprek vergrendelen';

  @override
  String get createConversationAsClosed =>
      'Gesprek als gesloten maken (geen reacties toegestaan)';

  @override
  String get deleteAccount => 'Account verwijderen';

  @override
  String get deleteAccountDescription => 'Verwijder uw account van dit forum.';

  @override
  String get deleteAccountContactForumMessage =>
      'Uw account wordt beheerd door het forum. Neem direct contact op met het forum voor accountverwijdering. Gebruik de knop Contact onderaan de forumhomepage.';

  @override
  String get forumUrlUnavailable => 'Forum-URL is niet beschikbaar.';

  @override
  String get couldNotOpenForumUrl => 'Kon forum-URL niet openen.';

  @override
  String get noActionUrlAvailableForThisNotificationType =>
      'Geen actie-URL beschikbaar voor dit meldingstype.';

  @override
  String get signInToViewNotifications => 'Meld u aan om meldingen te bekijken';

  @override
  String get youNeedToBeSignedInToViewYourNotifications =>
      'U moet aangemeld zijn om uw meldingen te bekijken.';

  @override
  String get errorLoadingNotifications => 'Fout bij laden van meldingen';

  @override
  String get pullDownToRefresh => 'Trek omlaag om te vernieuwen';

  @override
  String get youHaveNoNewNotificationsCheckBackLater =>
      'U heeft geen nieuwe meldingen. Kom later terug voor updates over onderwerpen die u volgt.';

  @override
  String get signInToViewProfile => 'Meld u aan om profiel te bekijken';

  @override
  String get youNeedToBeSignedInToViewYourProfile =>
      'U moet aangemeld zijn om uw profiel te bekijken.';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get confirmPasswordLabel => 'Bevestig wachtwoord';

  @override
  String get protectedForum => 'Beveiligd forum';

  @override
  String forumIsPasswordProtected(String forumName) {
    return '$forumName is met een wachtwoord beveiligd.';
  }

  @override
  String get enterButton => 'Invoeren';

  @override
  String get recentPosts => 'Recente berichten';

  @override
  String passkeyNotAvailableInForum(int code) {
    return 'Passkey is momenteel niet beschikbaar op dit forum (code: $code)';
  }

  @override
  String get initializingForum => 'Forum wordt gestart…';

  @override
  String get retryConnection => 'Opnieuw verbinden';

  @override
  String get pleaseConfirmPassword => 'Bevestig uw wachtwoord';

  @override
  String get pleaseEnterTheForumPassword => 'Voer het forumwachtwoord in';

  @override
  String get editYourPost => 'Bewerk uw bericht...';

  @override
  String get topicIdIsMissingCannotNavigateToThePost =>
      'Onderwerp-ID ontbreekt. Kan niet naar het bericht navigeren.';

  @override
  String get conversationIsOpenForReplies => 'Gesprek is open voor reacties';

  @override
  String get conversationIsClosedNoRepliesAllowed =>
      'Gesprek is gesloten (geen reacties toegestaan)';

  @override
  String get pleaseEnterAUsername => 'Voer een gebruikersnaam in';

  @override
  String usernameMinLength(int count) {
    return 'De gebruikersnaam moet minstens $count tekens lang zijn';
  }

  @override
  String get pleaseEnterAPassword => 'Voer een wachtwoord in';

  @override
  String passwordMinLength(int count) {
    return 'Het wachtwoord moet minstens $count tekens lang zijn';
  }

  @override
  String get writeYourTopicTitle => 'Titel van uw onderwerp...';

  @override
  String get writeYourTopicContent => 'Inhoud van uw onderwerp...';

  @override
  String pushDisabledFor(String siteName) {
    return 'Pushmeldingen uitgeschakeld voor $siteName';
  }

  @override
  String get failedToDisablePush => 'Kan pushmeldingen niet uitschakelen';

  @override
  String get thisForum => 'dit forum';

  @override
  String get openFullEditor => 'Volledige editor';

  @override
  String statsMembers(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString leden',
      one: '$countString lid',
    );
    return '$_temp0';
  }

  @override
  String statsTopics(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString onderwerpen',
      one: '$countString onderwerp',
    );
    return '$_temp0';
  }

  @override
  String statsPosts(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString berichten',
      one: '$countString bericht',
    );
    return '$_temp0';
  }

  @override
  String searchForumName(String forumName) {
    return 'Zoeken in $forumName';
  }

  @override
  String get copyLink => 'Link kopiëren';

  @override
  String get linkCopied => 'Link gekopieerd';

  @override
  String sharedFilesAttached(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gedeelde bestanden bijgevoegd.',
      one: '1 gedeeld bestand bijgevoegd.',
    );
    return '$_temp0';
  }

  @override
  String sharedFilesPartlyAttached(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bestanden bijgevoegd. Niet bijgevoegd: $names',
      one: '1 bestand bijgevoegd. Niet bijgevoegd: $names',
    );
    return '$_temp0';
  }

  @override
  String get notificationChannelMessages => 'Berichten';

  @override
  String get notificationChannelMessagesDescription =>
      'Nieuwe privéberichten en antwoorden daarop';

  @override
  String get notificationChannelReplies => 'Reacties en vermeldingen';

  @override
  String get notificationChannelRepliesDescription =>
      'Reacties in gevolgde onderwerpen, citaten en vermeldingen';

  @override
  String get notificationChannelReactions => 'Likes en reacties';

  @override
  String get notificationChannelReactionsDescription =>
      'Likes en reacties op je berichten';

  @override
  String get notificationChannelOther => 'Overige meldingen';

  @override
  String get notificationChannelOtherDescription =>
      'Volgers, trofeeën en andere forummeldingen';

  @override
  String get deleteAccountConfirmTitle => 'Je account verwijderen?';

  @override
  String deleteAccountConfirmMessage(String forumName) {
    return 'Je account op $forumName wordt verwijderd, met je profiel en instellingen. Je berichten blijven staan, onder je naam. Dit kan niet ongedaan worden gemaakt.';
  }

  @override
  String get deleteAccountNoPassword =>
      'Geen wachtwoord? Bevestig met je gebruikersnaam';

  @override
  String get deleteAccountUsePassword => 'Bevestig met je wachtwoord';

  @override
  String get accountDeleted => 'Je account is verwijderd.';

  @override
  String get signInOnWebsite => 'Inloggen op de website van het forum';

  @override
  String get signInOnWebsiteHint =>
      'Voor Google, Facebook en de andere manieren waarop je daar inlogt';

  @override
  String get browserLoginFailed =>
      'Inloggen via de website is niet gelukt. Probeer het opnieuw.';

  @override
  String get subForums => 'Subforums';

  @override
  String postPositionOf(int position, int total) {
    return 'Bericht $position van $total';
  }

  @override
  String get tapToJumpToPost => 'Tik om naar een bepaald bericht te gaan';

  @override
  String get jumpToFirstPost => 'Naar eerste bericht gaan';

  @override
  String get jumpToLastPost => 'Naar laatste bericht gaan';

  @override
  String get send => 'Versturen';

  @override
  String get postAction => 'Plaatsen';

  @override
  String messageCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count berichten',
      one: '$count bericht',
    );
    return '$_temp0';
  }

  @override
  String replyCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reacties',
      one: '$count reactie',
    );
    return '$_temp0';
  }

  @override
  String subForumCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subforums',
      one: '$count subforum',
    );
    return '$_temp0';
  }

  @override
  String get trustThisDevice => 'Dit apparaat vertrouwen';

  @override
  String get trustThisDeviceHint =>
      'Bij de volgende keer inloggen op dit apparaat niet om een code vragen';

  @override
  String get passkeyNotOnThisDevice =>
      'Er is op dit apparaat geen toegangssleutel voor dit forum. Kies een andere methode of voeg eerst een toegangssleutel toe op de website van het forum.';

  @override
  String get passkeyStepNotSetUp =>
      'Dit forum is in deze app nog niet ingesteld voor toegangssleutels. Kies een andere methode.';
}

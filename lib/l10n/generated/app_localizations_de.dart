// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get usernameLabel => 'Benutzername';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get pleaseEnterUsername => 'Bitte geben Sie Ihren Benutzernamen ein';

  @override
  String get pleaseEnterPassword => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String credentialsSentToDomain(String domain) {
    return 'Ihr Benutzername und Passwort werden an $domain gesendet';
  }

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get alreadyHaveAccount => 'Haben Sie bereits ein Konto? ';

  @override
  String get logIn => 'Anmelden';

  @override
  String get continueButton => 'Fortfahren';

  @override
  String get registrationNotAvailable => 'Registrierung nicht verfügbar';

  @override
  String get registrationNotAvailableMessage =>
      'Die Registrierung ist derzeit nicht verfügbar. Das Forum kann geschlossen sein oder die Registrierung kann deaktiviert sein.';

  @override
  String get webRegistrationRequired => 'Web-Registrierung erforderlich';

  @override
  String get webRegistrationRequiredMessage =>
      'Dieses Forum erfordert eine Registrierung über den Webbrowser. Bitte klicken Sie auf die Schaltfläche unten, um die Registrierungsseite zu öffnen.';

  @override
  String get openRegistrationPage => 'Registrierungsseite öffnen';

  @override
  String get loadingAdditionalFields => 'Zusätzliche Felder werden geladen...';

  @override
  String get pleaseSelectDateOfBirth => 'Bitte wählen Sie Ihr Geburtsdatum';

  @override
  String get pleaseEnterLocation => 'Bitte geben Sie Ihren Standort ein';

  @override
  String get pleaseIndicateEmailPreference =>
      'Bitte geben Sie Ihre E-Mail-Präferenz an';

  @override
  String get pleaseFillAllRequiredFields =>
      'Bitte füllen Sie alle erforderlichen Felder aus';

  @override
  String get pleaseAcceptTermsOfService =>
      'Bitte akzeptieren Sie die Nutzungsbedingungen';

  @override
  String get pleaseAcceptPrivacyPolicy =>
      'Bitte akzeptieren Sie die Datenschutzrichtlinie';

  @override
  String get registrationError => 'Registrierungsfehler';

  @override
  String get registrationFailed =>
      'Registrierung fehlgeschlagen. Bitte überprüfen Sie Ihre Informationen.';

  @override
  String get registrationFailedTryAgain =>
      'Registrierung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get registrationInfo => 'Registrierungsinformationen';

  @override
  String get openWebsite => 'Website öffnen';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'Die Forum-Website konnte nicht geöffnet werden. Bitte versuchen Sie: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      'Registrierung erfolgreich! Bitte überprüfen Sie Ihre E-Mail, um Ihr Konto zu bestätigen, bevor Sie sich anmelden.';

  @override
  String get registrationSuccessfulPendingApproval =>
      'Registrierung erfolgreich! Ihr Konto wartet auf Genehmigung. Sie werden benachrichtigt, wenn Ihr Konto genehmigt wurde.';

  @override
  String get registrationSuccessfulAutoLogin =>
      'Registrierung erfolgreich! Sie wurden automatisch angemeldet.';

  @override
  String get welcome => 'Willkommen!';

  @override
  String get registrationSuccessful => 'Registrierung erfolgreich';

  @override
  String get pleaseLoginWithNewAccount =>
      'Bitte melden Sie sich mit Ihrem neuen Konto an.';

  @override
  String get forgotPasswordTitle => 'Passwort vergessen';

  @override
  String get usernameOrEmailLabel => 'Benutzername oder E-Mail';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Bitte geben Sie Ihren Benutzernamen oder Ihre E-Mail ein';

  @override
  String get sendResetLink => 'Reset-Link senden';

  @override
  String get resetLinkSent => 'Reset-Link gesendet';

  @override
  String get passwordResetInstructionsSent =>
      'Anweisungen zum Zurücksetzen Ihres Passworts wurden an Ihre registrierte E-Mail-Adresse gesendet.';

  @override
  String get resetFailed => 'Zurücksetzung fehlgeschlagen';

  @override
  String get unableToSendResetLink =>
      'Reset-Link konnte nicht gesendet werden. Bitte versuchen Sie es erneut.';

  @override
  String get errorSendingResetLink =>
      'Beim Senden des Reset-Links ist ein Fehler aufgetreten. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get errorTitle => 'Fehler';

  @override
  String get okButton => 'OK';

  @override
  String get retryButton => 'Wiederholen';

  @override
  String get copyToClipboard => 'In Zwischenablage kopieren';

  @override
  String get copied => 'Kopiert';

  @override
  String get errorMessageCopiedToClipboard =>
      'Fehlermeldung in Zwischenablage kopiert';

  @override
  String get dismiss => 'Verwerfen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get tryAgain => 'Erneut Versuchen';

  @override
  String get getHelp => 'Hilfe erhalten';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get unexpectedErrorOccurred =>
      'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get noInternetConnection => 'Keine Internetverbindung';

  @override
  String get checkInternetConnection =>
      'Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get authenticationRequired => 'Authentifizierung erforderlich';

  @override
  String get pleaseLoginToContinue =>
      'Bitte melden Sie sich an, um fortzufahren.';

  @override
  String get forumError => 'Forum-Fehler';

  @override
  String get anErrorOccurred => 'Ein Fehler ist aufgetreten';

  @override
  String get accountPendingApproval =>
      'Ihr Konto wartet auf Genehmigung. Sie können das Forum durchsuchen, aber nicht posten, bis ein Moderator Ihr Konto genehmigt.';

  @override
  String get checkEmailToConfirm =>
      'Bitte überprüfen Sie Ihre E-Mail, um Ihr Konto zu bestätigen. Klicken Sie auf den Bestätigungslink in der E-Mail, die wir Ihnen gesendet haben.';

  @override
  String get checkNewEmailToConfirm =>
      'Bitte überprüfen Sie Ihre neue E-Mail-Adresse, um die Änderung zu bestätigen. Ihre alte E-Mail bleibt aktiv, bis Sie die neue bestätigen.';

  @override
  String get emailAddressInvalid =>
      'Ihre E-Mail-Adresse scheint ungültig zu sein oder lehnt E-Mails ab. Bitte aktualisieren Sie Ihre E-Mail-Adresse in den Kontoeinstellungen.';

  @override
  String get accountDisabled =>
      'Ihr Konto wurde deaktiviert. Bitte wenden Sie sich an einen Administrator für Hilfe.';

  @override
  String get accountRegistrationRejected =>
      'Ihre Kontoregistrierung wurde abgelehnt. Bitte wenden Sie sich an einen Administrator für weitere Informationen.';

  @override
  String get welcomeToForumCopilot => 'Willkommen bei Forum Copilot!';

  @override
  String get successfullyLoggedOut => 'Sie wurden erfolgreich abgemeldet';

  @override
  String get accountStatusRequiresAttention =>
      'Der Status Ihres Kontos erfordert Aufmerksamkeit. Bitte wenden Sie sich an einen Administrator, wenn Sie Fragen haben.';

  @override
  String get updateEmail => 'E-Mail aktualisieren';

  @override
  String get resend => 'Erneut senden';

  @override
  String get noLatestTopics => 'Keine neuesten Themen';

  @override
  String get noRecentTopicsToDisplay =>
      'Es gibt keine neuesten Themen zum Anzeigen. Kommen Sie später für neue Diskussionen zurück.';

  @override
  String get signInToViewLatestTopics =>
      'Melden Sie sich an, um neueste Themen anzuzeigen';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Sie müssen angemeldet sein, um neueste Themen anzuzeigen';

  @override
  String get noUnreadTopics => 'Keine ungelesenen Themen';

  @override
  String get thereAreNoUnreadTopics =>
      'Es gibt keine ungelesenen Themen. Kommen Sie später für neue Diskussionen zurück.';

  @override
  String get youAreAllCaughtUp => 'Sie sind auf dem neuesten Stand!';

  @override
  String get signInToViewUnreadTopics =>
      'Melden Sie sich an, um ungelesene Themen anzuzeigen';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Sie müssen angemeldet sein, um Ihre ungelesenen Themen anzuzeigen';

  @override
  String get noSubscribedTopics => 'Keine abonnierten Themen';

  @override
  String get noSubscribedTopicsMessage =>
      'Sie haben keine Themen abonniert. Tippen Sie auf die Stern-Schaltfläche bei einem Thema, um es zu abonnieren und Benachrichtigungen für neue Updates zu erhalten.';

  @override
  String get signInToViewSubscribedTopics =>
      'Melden Sie sich an, um abonnierte Themen anzuzeigen';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Sie müssen angemeldet sein, um Ihre abonnierten Themen anzuzeigen';

  @override
  String get noParticipatedTopics => 'Keine teilgenommenen Themen';

  @override
  String get topicsYouParticipatedIn =>
      'Themen, an denen Sie teilgenommen haben, werden hier angezeigt.';

  @override
  String get signInToViewParticipatedTopics =>
      'Melden Sie sich an, um teilgenommene Themen anzuzeigen';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Sie müssen angemeldet sein, um Themen anzuzeigen, an denen Sie teilgenommen haben';

  @override
  String get latest => 'Neueste';

  @override
  String get unread => 'Ungelesen';

  @override
  String get subscribed => 'Abonniert';

  @override
  String get participated => 'Teilgenommen';

  @override
  String get connectionTimedOut =>
      'Verbindungszeitüberschreitung. Die Website kann offline oder nicht erreichbar sein.';

  @override
  String get failedToConnectToSite =>
      'Verbindung zur Website fehlgeschlagen. Die Website kann offline oder nicht erreichbar sein.';

  @override
  String get connectionFailed => 'Verbindungsfehler';

  @override
  String failedToConnectToSiteName(String siteName) {
    return 'Verbindung zu $siteName fehlgeschlagen';
  }

  @override
  String get loading => 'Wird geladen...';

  @override
  String get newConversation => 'Neue Unterhaltung';

  @override
  String get newMessage => 'Neue Nachricht';

  @override
  String get appSettings => 'App-Einstellungen';

  @override
  String get searchSites => 'Websites suchen';

  @override
  String get language => 'Sprache';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get followSystemLanguage => 'Systemsprache verwenden';

  @override
  String get all => 'Alle';

  @override
  String get topicsOnly => 'Nur Themen';

  @override
  String get titlesOnly => 'Nur Titel';

  @override
  String failedToShareTopic(String error) {
    return 'Thema konnte nicht geteilt werden: $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'Bitte melden Sie sich an, um $action diesen Thread';
  }

  @override
  String get subscribeTo => 'zu abonnieren';

  @override
  String get unsubscribeFrom => 'das Abonnement zu kündigen';

  @override
  String get subscribe => 'Abonnieren';

  @override
  String get unsubscribe => 'Abbestellen';

  @override
  String failedToSubscribeToThread(String action) {
    return 'Thread $action fehlgeschlagen';
  }

  @override
  String get youCannotReplyToThisThread =>
      'Sie können nicht auf diesen Thread antworten';

  @override
  String get pleaseWaitForThreadToLoad =>
      'Bitte warten Sie, bis der Thread geladen ist';

  @override
  String get softDelete => 'Sanftes Löschen';

  @override
  String get postCanBeRestoredLater =>
      'Beitrag kann später wiederhergestellt werden';

  @override
  String get hardDelete => 'Endgültiges Löschen';

  @override
  String get postWillBePermanentlyDeleted => 'Beitrag wird endgültig gelöscht';

  @override
  String get reasonForDeletion => 'Grund für die Löschung';

  @override
  String get enterReasonForDeletingPost =>
      'Geben Sie den Grund für die Löschung dieses Beitrags ein';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Bitte geben Sie einen Grund für die Löschung ein';

  @override
  String get reportPost => 'Beitrag melden';

  @override
  String get pleaseProvideReasonForReporting =>
      'Bitte geben Sie einen Grund für die Meldung dieses Beitrags an.';

  @override
  String get reason => 'Grund';

  @override
  String get enterReasonForReportingPost =>
      'Geben Sie den Grund für die Meldung dieses Beitrags ein';

  @override
  String get pleaseEnterReason => 'Bitte geben Sie einen Grund ein';

  @override
  String get submitReport => 'Meldung absenden';

  @override
  String get selectedActions => 'Ausgewählte Aktionen:';

  @override
  String get thisActionCannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get participantsLabel => 'Teilnehmer';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username wurde zur Unterhaltung eingeladen';
  }

  @override
  String errorInvitingUser(String error) {
    return 'Fehler beim Einladen des Benutzers: $error';
  }

  @override
  String get newTopic => 'Neues Thema';

  @override
  String get markRead => 'Als gelesen markieren';

  @override
  String get reportUser => 'Benutzer melden';

  @override
  String get pleaseSelectReasonForReportingUser =>
      'Bitte wählen Sie einen Grund für die Meldung dieses Benutzers.';

  @override
  String get spamOrAdvertising => 'Spam oder Werbung';

  @override
  String get harassmentOrBullying => 'Belästigung oder Mobbing';

  @override
  String get inappropriateContent => 'Unangemessener Inhalt';

  @override
  String get impersonationOrFakeAccount =>
      'Identitätsbetrug oder gefälschtes Konto';

  @override
  String get otherPleaseSpecify => 'Andere (bitte angeben)';

  @override
  String get pleaseSpecifyReason => 'Bitte geben Sie den Grund an';

  @override
  String get enterReasonForReportingUser =>
      'Geben Sie den Grund für die Meldung dieses Benutzers ein';

  @override
  String get pleaseSelectReason => 'Bitte wählen Sie einen Grund';

  @override
  String get banUser => 'Benutzer sperren';

  @override
  String get unbanUser => 'Benutzer entsperren';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return 'Bitte wählen Sie einen Grund für die Sperrung von $username';
  }

  @override
  String get violationOfCommunityGuidelines =>
      'Verstoß gegen die Community-Richtlinien';

  @override
  String get harassmentOrAbusiveBehavior =>
      'Belästigung oder missbräuchliches Verhalten';

  @override
  String get postingInappropriateContent =>
      'Veröffentlichung unangemessener Inhalte';

  @override
  String get accountCompromiseOrSecurityIssue =>
      'Kontokompromittierung oder Sicherheitsproblem';

  @override
  String get enterReasonForBanningUser =>
      'Geben Sie den Grund für die Sperrung dieses Benutzers ein';

  @override
  String get banUntil => 'Sperren bis';

  @override
  String get selectDate => 'Datum auswählen';

  @override
  String get moreOptions => 'Weitere Optionen';

  @override
  String get leaveConversation => 'Unterhaltung verlassen';

  @override
  String get reportConversation => 'Unterhaltung melden';

  @override
  String get topicClosed => 'Thema geschlossen';

  @override
  String get topicOpened => 'Thema geöffnet';

  @override
  String get topicStickied => 'Thema angeheftet';

  @override
  String get topicUnstickied => 'Thema nicht mehr angeheftet';

  @override
  String cannotEditMessage(String error) {
    return 'Diese Nachricht kann nicht bearbeitet werden: $error';
  }

  @override
  String get confirmSpamClean => 'Spam-Bereinigung bestätigen';

  @override
  String get handleThreads => 'Threads verwalten';

  @override
  String get deleteMessages => 'Nachrichten löschen';

  @override
  String get deleteConversations => 'Unterhaltungen löschen';

  @override
  String get myForums => 'Meine Foren';

  @override
  String get recentlyVisited => 'Kürzlich Besucht';

  @override
  String get explore => 'Erkunden';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => 'Keine Unterhaltungen';

  @override
  String get noConversationsMessage =>
      'Sie haben noch keine Unterhaltungen. Starten Sie eine neue Unterhaltung, um mit dem Messaging zu beginnen.';

  @override
  String get imageSavedToGallery => 'Bild in Galerie gespeichert!';

  @override
  String failedToSaveImage(String error) {
    return 'Fehler beim Speichern des Bildes: $error';
  }

  @override
  String get userProfile => 'Benutzerprofil';

  @override
  String get deletePost => 'Beitrag Löschen';

  @override
  String get loginRequired => 'Anmeldung Erforderlich';

  @override
  String get spamCleaner => 'Spam-Bereinigung';

  @override
  String get sendMessage => 'Nachricht senden';

  @override
  String get memberSince => 'Mitglied Seit';

  @override
  String get lastActivity => 'Letzte Aktivität';

  @override
  String get likesReceived => 'Erhaltene Likes';

  @override
  String get likesGiven => 'Gegebene Likes';

  @override
  String get showMore => 'Mehr anzeigen';

  @override
  String get cleanSpam => 'Spam bereinigen';

  @override
  String get failedToSaveMessage => 'Fehler beim Speichern der Nachricht';

  @override
  String get failedToSaveConversation =>
      'Speichern der Unterhaltung fehlgeschlagen';

  @override
  String get failedToSaveSetting => 'Fehler beim Speichern der Einstellung';

  @override
  String get failedToSavePost => 'Fehler beim Speichern des Beitrags';

  @override
  String errorLoadingSites(String error) {
    return 'Fehler beim Laden der Websites: $error';
  }

  @override
  String connectingTo(String domainName) {
    return 'Verbinde mit $domainName...';
  }

  @override
  String get members => 'Mitglieder';

  @override
  String get allMembers => 'Alle Mitglieder';

  @override
  String get online => 'Online';

  @override
  String get noMembersFound => 'Keine Mitglieder gefunden';

  @override
  String get searchForMembers => 'Mitglieder suchen';

  @override
  String get enterUsernameToFindMembers =>
      'Geben Sie einen Benutzernamen ein, um Forumsmitglieder zu finden';

  @override
  String get noMembersOnline => 'Derzeit sind keine Mitglieder online';

  @override
  String get enterUsernameToSearch => 'Benutzernamen zum Suchen eingeben...';

  @override
  String get lookupMembers => 'Mitglieder Suchen';

  @override
  String get addMembers => 'Mitglieder Hinzufügen';

  @override
  String get membersAddedSuccessfully => 'Mitglieder erfolgreich hinzugefügt';

  @override
  String errorAddingMembers(String error) {
    return 'Fehler beim Hinzufügen von Mitgliedern: $error';
  }

  @override
  String get failedToLoadOnlineUsers => 'Fehler beim Laden der Online-Benutzer';

  @override
  String get noUsersOnline => 'Keine Benutzer online';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Mitglieder';
  }

  @override
  String get noSubject => 'Kein Betreff';

  @override
  String get search => 'Suchen';

  @override
  String get logout => 'Abmelden';

  @override
  String get areYouSureYouWantToLogout => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get register => 'Registrieren';

  @override
  String get signIn => 'Anmelden';

  @override
  String get markForumRead => 'Forum als Gelesen Markieren';

  @override
  String get notificationTest => 'Benachrichtigungstest';

  @override
  String get forum => 'Forum';

  @override
  String get profile => 'Profil';

  @override
  String get messages => 'Nachrichten';

  @override
  String get add => 'Hinzufügen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteMessage => 'Nachricht Löschen';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'Möchten Sie diese Nachricht wirklich löschen?';

  @override
  String failedToDeleteMessage(String error) {
    return 'Fehler beim Löschen der Nachricht: $error';
  }

  @override
  String get deletingPost => 'Beitrag wird gelöscht...';

  @override
  String failedToUnlikePost(String error) {
    return 'Fehler beim Entfernen des Likes vom Beitrag: $error';
  }

  @override
  String failedToLikePost(String error) {
    return 'Fehler beim Liken des Beitrags: $error';
  }

  @override
  String failedToThankPost(String error) {
    return 'Fehler beim Danken des Beitrags: $error';
  }

  @override
  String get signInToViewMessages =>
      'Melden Sie sich an, um Nachrichten anzuzeigen';

  @override
  String get youNeedToBeSignedInToViewConversations =>
      'Sie müssen angemeldet sein, um Ihre Unterhaltungen anzuzeigen.';

  @override
  String errorLoadingConversations(String error) {
    return 'Fehler beim Laden der Unterhaltungen: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return 'Fehler beim Verlassen der Unterhaltung: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return 'Fehler beim Laden weiterer Unterhaltungen: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'Fehler beim Laden weiterer Nachrichten: $error';
  }

  @override
  String get inviteMessageOptional => 'Einladungsnachricht (optional)';

  @override
  String get iWouldLikeToAddYouToThisConversation =>
      'Ich möchte Sie zu dieser Unterhaltung hinzufügen.';

  @override
  String get searchFailed => 'Suche fehlgeschlagen';

  @override
  String get trySearchingWithDifferentUsername =>
      'Versuchen Sie es mit einem anderen Benutzernamen';

  @override
  String get noSitesFound => 'Keine Websites gefunden.';

  @override
  String get userInformationNotAvailable =>
      'Benutzerinformationen nicht verfügbar';

  @override
  String get birthday => 'Geburtstag';

  @override
  String get posts => 'Beiträge';

  @override
  String get following => 'Folgt';

  @override
  String get followers => 'Follower';

  @override
  String get about => 'Über';

  @override
  String get location => 'Standort';

  @override
  String get website => 'Website';

  @override
  String get signature => 'Signatur';

  @override
  String get next => 'Weiter';

  @override
  String get permanent => 'Permanent';

  @override
  String get temporary => 'Temporär';

  @override
  String setBanDurationFor(String username) {
    return 'Bann-Dauer für $username festlegen';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan =>
      'Bitte wählen Sie ein Enddatum für den temporären Bann';

  @override
  String get back => 'Zurück';

  @override
  String get unban => 'Entbannen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String spamClean(String username) {
    return 'Spam von $username Bereinigen';
  }

  @override
  String get selectActionsToPerform =>
      'Wählen Sie die auszuführenden Aktionen:';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Threads basierend auf Admin-Einstellungen verschieben oder löschen';

  @override
  String get messageUpdatedSuccessfully => 'Nachricht erfolgreich aktualisiert';

  @override
  String error(String error) {
    return 'Fehler: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return 'Fehler beim Entfernen des Anhangs: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'Fehler beim Laden der Nachricht: $error';
  }

  @override
  String get editMessage => 'Nachricht Bearbeiten';

  @override
  String get removeAttachment => 'Anhang Entfernen';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      'Möchten Sie diesen Anhang wirklich entfernen?';

  @override
  String get none => 'Keine';

  @override
  String get attachFile => 'Datei Anhängen';

  @override
  String get uploadImage => 'Bild Hochladen';

  @override
  String get formatting => 'Formatierung';

  @override
  String get bold => 'Fett';

  @override
  String get italic => 'Kursiv';

  @override
  String get underline => 'Unterstrichen';

  @override
  String get strikethrough => 'Durchgestrichen';

  @override
  String get link => 'Link';

  @override
  String get image => 'Bild';

  @override
  String get video => 'Video';

  @override
  String get quote => 'Zitat';

  @override
  String get code => 'Code';

  @override
  String get spoiler => 'Spoiler';

  @override
  String get bulletList => 'Aufzählungsliste';

  @override
  String get numberedList => 'Nummerierte Liste';

  @override
  String get listItem => 'Listenelement';

  @override
  String participants(int count) {
    return 'Teilnehmer ($count)';
  }

  @override
  String get markAsUnread => 'Als ungelesen markieren';

  @override
  String get invite => 'Einladen';

  @override
  String get welcomeBack => 'Willkommen zurück!';

  @override
  String get signInToAccessYourProfile =>
      'Melden Sie sich an, um auf Ihr Profil zuzugreifen und Ihr Konto zu verwalten';

  @override
  String get enterYourUsername => 'Geben Sie Ihren Benutzernamen ein';

  @override
  String get enterYourPassword => 'Geben Sie Ihr Passwort ein';

  @override
  String get dontHaveAnAccount => 'Haben Sie kein Konto?';

  @override
  String get enterKeywordsToSearchTopics =>
      'Geben Sie Schlüsselwörter ein, um Themen zu suchen...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Bitte füllen Sie alle erforderlichen Felder aus';

  @override
  String get undelete => 'Wiederherstellen';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get share => 'Teilen';

  @override
  String get viewOnWeb => 'Im Web anzeigen';

  @override
  String get unlock => 'Entsperren';

  @override
  String get lock => 'Sperren';

  @override
  String get stick => 'Anheften';

  @override
  String get unstick => 'Loslösen';

  @override
  String get reply => 'Antworten';

  @override
  String get vote => 'Abstimmen';

  @override
  String votesCount(int count) {
    return '$count Stimmen';
  }

  @override
  String get pollClosed => 'Umfrage geschlossen';

  @override
  String pollEndsOn(String date) {
    return 'Endet am $date';
  }

  @override
  String get voteToSeeResults => 'Abstimmen, um Ergebnisse zu sehen';

  @override
  String get viewFullPoll => 'Umfrage anzeigen';

  @override
  String pollOptionsCount(int count) {
    return '$count Optionen';
  }

  @override
  String get reactedBy => 'Reagiert von';

  @override
  String get enterKeywordsToFindTopicsAndPosts =>
      'Geben Sie Schlüsselwörter ein, um Themen und Beiträge zu finden';

  @override
  String get enterKeywordsOrDomainToFindForums =>
      'Geben Sie Schlüsselwörter oder eine Domain ein, um Foren zu finden';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'Geben Sie Schlüsselwörter oder Domänennamen ein, um Foren zu finden';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get followSystemTheme => 'Systemdesign verwenden';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String version(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'Foren-Einstellungen';

  @override
  String get noSettingsAvailable => 'Keine Einstellungen verfügbar';

  @override
  String get settingsCategoriesWillAppearHere =>
      'Einstellungskategorien werden hier angezeigt, wenn sie verfügbar sind.';

  @override
  String get unableToLoadProfile => 'Profil konnte nicht geladen werden';

  @override
  String get banned => 'GESPERRT';

  @override
  String get reportSubmittedSuccessfully => 'Meldung erfolgreich abgesendet';

  @override
  String get failedToSubmitReport => 'Meldung konnte nicht abgesendet werden';

  @override
  String get searchForForums => 'Foren suchen';

  @override
  String get searchForums => 'Foren suchen';

  @override
  String get deleteTopic => 'Thema löschen';

  @override
  String get topicCanBeRestoredLater =>
      'Thema kann später wiederhergestellt werden';

  @override
  String get topicWillBePermanentlyDeleted => 'Thema wird endgültig gelöscht';

  @override
  String get enterReasonForDeletingTopic =>
      'Geben Sie den Grund für die Löschung dieses Themas ein';

  @override
  String get pleaseSelectEndDate => 'Bitte wählen Sie ein Enddatum';

  @override
  String get userBannedSuccessfully => 'Benutzer erfolgreich gesperrt';

  @override
  String get failedToBanUser => 'Benutzer konnte nicht gesperrt werden';

  @override
  String get userUnbannedSuccessfully => 'Benutzer erfolgreich entsperrt';

  @override
  String get failedToUnbanUser => 'Benutzer konnte nicht entsperrt werden';

  @override
  String get spamCleanUser => 'Spam des Benutzers bereinigen';

  @override
  String get deletePrivateConversations => 'Private Unterhaltungen löschen';

  @override
  String get banTheUserAccount => 'Benutzerkonto sperren';

  @override
  String get handledThreads => 'Behandelte Themen';

  @override
  String get deletedMessages => 'Gelöschte Nachrichten';

  @override
  String get deletedConversations => 'Gelöschte Unterhaltungen';

  @override
  String get bannedUser => 'Gesperrter Benutzer';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return 'Spam erfolgreich bereinigt für $username. Aktionen: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'Fehler beim Laden der Nachricht: $error';
  }

  @override
  String get messageNotFound => 'Nachricht nicht gefunden';

  @override
  String get home => 'Startseite';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get forums => 'Foren';

  @override
  String get markAllForumsAsRead => 'Alle Foren als gelesen markieren?';

  @override
  String get markAllForumsAsReadMessage =>
      'Dies markiert alle Foren und Themen als gelesen. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get markAsRead => 'Als gelesen markieren';

  @override
  String get content => 'Inhalt';

  @override
  String get insertImage => 'Bild einfügen';

  @override
  String get howWouldYouLikeToInsertImage =>
      'Wie möchten Sie dieses Bild einfügen?';

  @override
  String get thumbnail => 'Miniaturansicht';

  @override
  String get fullSize => 'Vollständige Größe';

  @override
  String get alignLeft => 'Links ausrichten';

  @override
  String get alignCenter => 'Zentriert ausrichten';

  @override
  String get alignRight => 'Rechts ausrichten';

  @override
  String get pleaseEnterTitle => 'Bitte geben Sie einen Titel ein';

  @override
  String get pleaseEnterContent => 'Bitte geben Sie einen Inhalt ein';

  @override
  String get uploading => 'Hochladen...';

  @override
  String get uploaded => 'Hochgeladen';

  @override
  String get mentionUser => 'Benutzer erwähnen';

  @override
  String get loggingIn => 'Anmelden...';

  @override
  String get submittingReport => 'Bericht senden...';

  @override
  String get banningUser => 'Benutzer sperren...';

  @override
  String get unbanningUser => 'Benutzersperre aufheben...';

  @override
  String get cleaningSpam => 'Spam bereinigen...';

  @override
  String get enterSubject => 'Betreff eingeben';

  @override
  String get typeYourMessageHere => 'Geben Sie hier Ihre Nachricht ein';

  @override
  String get writeYourMessage => 'Schreiben Sie Ihre Nachricht...';

  @override
  String get writeYourReply => 'Schreiben Sie Ihre Antwort...';

  @override
  String get messageSentSuccessfully => 'Nachricht erfolgreich gesendet';

  @override
  String get replySentSuccessfully => 'Antwort erfolgreich gesendet';

  @override
  String get conversationCreatedSuccessfully =>
      'Unterhaltung erfolgreich erstellt';

  @override
  String get conversationMarkedAsUnread =>
      'Unterhaltung als ungelesen markiert';

  @override
  String get messageMarkedAsUnread => 'Nachricht als ungelesen markiert';

  @override
  String get conversationClosed => 'Unterhaltung geschlossen';

  @override
  String get conversationOpened => 'Unterhaltung geöffnet';

  @override
  String get pleaseLoginToLikeMessages =>
      'Bitte melden Sie sich an, um Nachrichten zu mögen';

  @override
  String get loadEarlierMessages => 'Frühere Nachrichten laden';

  @override
  String failedToLoadQuote(String error) {
    return 'Zitat konnte nicht geladen werden: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'Datei konnte nicht hochgeladen werden: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Bild konnte nicht hochgeladen werden: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'Nachricht konnte nicht gesendet werden: $error';
  }

  @override
  String failedToSendReply(String error) {
    return 'Antwort konnte nicht gesendet werden: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'Nachricht konnte nicht als ungelesen markiert werden: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return 'Unterhaltung konnte nicht als ungelesen markiert werden: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return 'Unterhaltung konnte nicht geschlossen werden: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return 'Unterhaltung konnte nicht geöffnet werden: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'Zu Nachricht springen fehlgeschlagen: $error';
  }

  @override
  String get goToTop => 'Nach oben';

  @override
  String get goToBottom => 'Nach unten';

  @override
  String get replyAll => 'Allen antworten';

  @override
  String get forward => 'Weiterleiten';

  @override
  String get noForumsFound => 'Keine Foren gefunden.';

  @override
  String get pleaseSelectPrefix => 'Bitte wählen Sie ein Präfix';

  @override
  String get pleaseLoginToAccessContent =>
      'Bitte melden Sie sich an, um auf diesen Inhalt zuzugreifen und mit Beiträgen zu interagieren.';

  @override
  String get searchUsers => 'Benutzer suchen...';

  @override
  String get writeYourTitle => 'Schreiben Sie Ihren Titel...';

  @override
  String get writeYourContent => 'Schreiben Sie Ihren Inhalt...';

  @override
  String get selectAnOption => 'Option auswählen';

  @override
  String get enterConversationTitle =>
      'Geben Sie den Titel der Unterhaltung ein';

  @override
  String enterCode(int count) {
    return 'Geben Sie den $count-stelligen Code ein';
  }

  @override
  String get edit => 'Bearbeiten';

  @override
  String get report => 'Melden';

  @override
  String get unfollow => 'Nicht mehr folgen';

  @override
  String get follow => 'Folgen';

  @override
  String get goToForums => 'Zu Foren gehen';

  @override
  String get remove => 'Entfernen';

  @override
  String get subject => 'Betreff';

  @override
  String get message => 'Nachricht';

  @override
  String get titleCannotBeEmpty => 'Der Titel darf nicht leer sein';

  @override
  String get conversationUpdatedSuccessfully =>
      'Unterhaltung erfolgreich aktualisiert';

  @override
  String get goBack => 'Zurück';

  @override
  String get privateMessagesNotAvailable =>
      'Private Nachrichten nicht verfügbar';

  @override
  String failedToLoadPost(String error) {
    return 'Beitrag konnte nicht geladen werden: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'Nachricht konnte nicht $action werden: $error';
  }

  @override
  String get like => 'mögen';

  @override
  String get unlike => 'nicht mehr mögen';

  @override
  String get optimizeImage => 'Bild optimieren';

  @override
  String get optimizeAndUpload => 'Optimieren und hochladen';

  @override
  String downloading(String filename) {
    return 'Lade $filename herunter...';
  }

  @override
  String openingShareSheet(String filename) {
    return 'Öffne Freigabeblatt für $filename';
  }

  @override
  String errorDownloading(String filename, String error) {
    return 'Fehler beim Herunterladen von $filename: $error';
  }

  @override
  String get enterANumber => 'Geben Sie eine Zahl ein';

  @override
  String get failedToNavigateToForum => 'Navigation zum Forum fehlgeschlagen';

  @override
  String failedToNavigateToForumName(String forumName) {
    return 'Navigation zu $forumName fehlgeschlagen';
  }

  @override
  String forumNotFound(String forumName) {
    return 'Forum nicht gefunden: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'Forum nicht gefunden: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'Link konnte nicht geöffnet werden: $error';
  }

  @override
  String get likePost => 'Beitrag liken';

  @override
  String get unlikePost => 'Like entfernen';

  @override
  String get thankPost => 'Beitrag danken';

  @override
  String get showLikes => 'Likes anzeigen';

  @override
  String get showThanks => 'Danksagungen anzeigen';

  @override
  String get quotePost => 'Beitrag zitieren';

  @override
  String get translate => 'Übersetzen';

  @override
  String get showOriginal => 'Original anzeigen';

  @override
  String get translating => 'Übersetze...';

  @override
  String get translated => 'Übersetzt';

  @override
  String get translatedContent => 'Übersetzter Inhalt';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get translateTo => 'Übersetzen nach:';

  @override
  String get deviceLanguage => 'Gerätesprache';

  @override
  String get noPostsToTranslate => 'Keine Beiträge zum Übersetzen';

  @override
  String get translationFailed => 'Übersetzung fehlgeschlagen';

  @override
  String get twoFactorAuthentication => 'Zwei-Faktor-Authentifizierung';

  @override
  String get authenticationCodeLabel => 'Authentifizierungscode';

  @override
  String get pleaseEnterYourAuthenticationCode =>
      'Bitte geben Sie Ihren Authentifizierungscode ein';

  @override
  String codeMustBeDigits(int count) {
    return 'Der Code muss $count Ziffern enthalten';
  }

  @override
  String get codeMustContainOnlyNumbers => 'Der Code darf nur Zahlen enthalten';

  @override
  String get verifyButton => 'Bestätigen';

  @override
  String get attachments => 'Anhänge';

  @override
  String get replyOptions => 'Antwortoptionen';

  @override
  String get replyWithQuote => 'Mit Zitat antworten';

  @override
  String fileSavedToDownloads(String filename) {
    return 'Datei in Downloads gespeichert: $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'Datei in Dokumente gespeichert: $filename';
  }
}

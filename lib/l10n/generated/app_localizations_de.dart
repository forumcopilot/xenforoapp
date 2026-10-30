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
  String get cancel => 'Abbrechen';

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
  String get noUnreadTopics => 'Keine ungelesenen Themen';

  @override
  String get thereAreNoUnreadTopics =>
      'Es gibt keine ungelesenen Themen. Kommen Sie später für neue Diskussionen zurück.';

  @override
  String get youAreAllCaughtUp => 'Sie sind auf dem neuesten Stand!';

  @override
  String get noSubscribedTopics => 'Keine beobachteten Themen';

  @override
  String get noSubscribedTopicsMessage =>
      'Du beobachtest noch keine Themen. Öffne ein Thema und wähle im ⋮-Menü „Beobachten“, um über neue Antworten benachrichtigt zu werden.';

  @override
  String get noParticipatedTopics => 'Keine teilgenommenen Themen';

  @override
  String get topicsYouParticipatedIn =>
      'Themen, an denen Sie teilgenommen haben, werden hier angezeigt.';

  @override
  String get latest => 'Neueste';

  @override
  String get unread => 'Ungelesen';

  @override
  String get subscribed => 'Beobachtet';

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
  String get subscribe => 'Beobachten';

  @override
  String get unsubscribe => 'Nicht mehr beobachten';

  @override
  String get youCannotReplyToThisThread =>
      'Sie können nicht auf diesen Thread antworten';

  @override
  String get pleaseWaitForThreadToLoad =>
      'Bitte warten Sie, bis der Thread geladen ist';

  @override
  String get postCanBeRestoredLater =>
      'Beitrag kann später wiederhergestellt werden';

  @override
  String get postWillBePermanentlyDeleted => 'Beitrag wird endgültig gelöscht';

  @override
  String get enterReasonForDeletingPost =>
      'Geben Sie den Grund für die Löschung dieses Beitrags ein';

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
  String get unbanUser => 'Benutzer entsperren';

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
  String get tryAgain => 'Erneut Versuchen';

  @override
  String get memberSince => 'Mitglied Seit';

  @override
  String get lastActivity => 'Letzte Aktivität';

  @override
  String get likesReceived => 'Erhaltene Likes';

  @override
  String get likesGiven => 'Gegebene Likes';

  @override
  String get failedToSaveMessage => 'Fehler beim Speichern der Nachricht';

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
  String get moreOptions => 'Weitere Optionen';

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
  String get dismiss => 'Verwerfen';

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
  String get enterUsernameToSearch => 'Benutzernamen zum Suchen eingeben...';

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
  String get handleThreads => 'Threads verwalten';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Threads basierend auf Admin-Einstellungen verschieben oder löschen';

  @override
  String get deleteMessages => 'Nachrichten löschen';

  @override
  String get deleteConversations => 'Unterhaltungen löschen';

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
  String get enterKeywordsToSearchTopics =>
      'Geben Sie Schlüsselwörter ein, um Themen zu suchen...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Bitte füllen Sie alle erforderlichen Felder aus';

  @override
  String get undelete => 'Wiederherstellen';

  @override
  String get signInToViewUnreadTopics =>
      'Melden Sie sich an, um ungelesene Themen anzuzeigen';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Sie müssen angemeldet sein, um Ihre ungelesenen Themen anzuzeigen';

  @override
  String get signInToViewSubscribedTopics =>
      'Melden Sie sich an, um beobachtete Themen anzuzeigen';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Sie müssen angemeldet sein, um Ihre beobachteten Themen anzuzeigen';

  @override
  String get signInToViewParticipatedTopics =>
      'Melden Sie sich an, um teilgenommene Themen anzuzeigen';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Sie müssen angemeldet sein, um Themen anzuzeigen, an denen Sie teilgenommen haben';

  @override
  String get signInToViewLatestTopics =>
      'Melden Sie sich an, um neueste Themen anzuzeigen';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Sie müssen angemeldet sein, um neueste Themen anzuzeigen';

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
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gefällt mir',
    );
    return '$_temp0';
  }

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Reaktionen',
      one: '$count Reaktion',
    );
    return '$_temp0';
  }

  @override
  String get showWhoReacted => 'Tippen, um zu sehen, wer reagiert hat.';

  @override
  String get react => 'Reagieren';

  @override
  String get changeYourReaction => 'Reaktion ändern';

  @override
  String get reactionsAll => 'Alle';

  @override
  String get reactionYou => 'Du';

  @override
  String reactionFilterSemantics(String reaction, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$reaction, $count Personen',
      one: '$reaction, $count Person',
    );
    return '$_temp0';
  }

  @override
  String viewProfileOfUser(String username) {
    return 'Profil von $username ansehen';
  }

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
  String get language => 'Sprache';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get followSystemLanguage => 'Systemsprache verwenden';

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
  String get spamCleaner => 'Spam-Bereinigung';

  @override
  String get unableToLoadProfile => 'Profil konnte nicht geladen werden';

  @override
  String get banned => 'GESPERRT';

  @override
  String get sendMessage => 'Nachricht senden';

  @override
  String get showMore => 'Mehr anzeigen';

  @override
  String get reportUser => 'Benutzer melden';

  @override
  String get submitReport => 'Meldung absenden';

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
  String get softDelete => 'Sanftes Löschen';

  @override
  String get topicCanBeRestoredLater =>
      'Thema kann später wiederhergestellt werden';

  @override
  String get hardDelete => 'Endgültiges Löschen';

  @override
  String get topicWillBePermanentlyDeleted => 'Thema wird endgültig gelöscht';

  @override
  String get reasonForDeletion => 'Grund für die Löschung';

  @override
  String get enterReasonForDeletingTopic =>
      'Geben Sie den Grund für die Löschung dieses Themas ein';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Bitte geben Sie einen Grund für die Löschung ein';

  @override
  String get pleaseSelectEndDate => 'Bitte wählen Sie ein Enddatum';

  @override
  String get banUser => 'Benutzer sperren';

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
  String get cleanSpam => 'Spam bereinigen';

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
  String get notifications => 'Mitteilungen';

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
  String get signInToViewMessages =>
      'Melden Sie sich an, um Ihre Unterhaltungen anzuzeigen';

  @override
  String get privateMessagesNotAvailable =>
      'Unterhaltungen sind nicht verfügbar';

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
  String get failedToSaveConversation =>
      'Speichern der Unterhaltung fehlgeschlagen';

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
  String get showLikes => 'Likes anzeigen';

  @override
  String get quotePost => 'Beitrag zitieren';

  @override
  String get attachFile => 'Datei Anhängen';

  @override
  String get uploadImage => 'Bild Hochladen';

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

  @override
  String get discardPostQuestion => 'Willst du deinen Beitrag verwerfen?';

  @override
  String get discardChangesQuestion =>
      'Möchtest du deine Änderungen verwerfen?';

  @override
  String get discard => 'Verwerfen';

  @override
  String get discardChanges => 'Änderungen verwerfen';

  @override
  String get saveDraft => 'Entwurf speichern';

  @override
  String get notificationsTab => 'Mitteilungen';

  @override
  String get postAwaitingApproval =>
      'Dein Beitrag erscheint, sobald ein Moderator ihn freigegeben hat.';

  @override
  String get reactionHoldHint => 'Lange drücken für weitere Reaktionen';

  @override
  String get turnOnNotifications => 'Benachrichtigungen einschalten';

  @override
  String get notNow => 'Nicht jetzt';

  @override
  String neverMissAReplyOn(Object forumName) {
    return 'Verpasse keine Antwort auf $forumName';
  }

  @override
  String get notificationPreviewNow => 'jetzt';

  @override
  String get notificationPreviewEarlier => 'vor 5 Min.';

  @override
  String get notificationPreviewReply =>
      'Jane hat dir geantwortet: Willkommen an Bord! Schön, dass du uns gefunden hast.';

  @override
  String get notificationPreviewMessage =>
      'Sam hat dir eine Nachricht geschickt: Kommst du am Freitag?';

  @override
  String get notificationsAreTurnedOffForThisApp =>
      'Benachrichtigungen sind für diese App deaktiviert';

  @override
  String get deviceWillNotShowAlertsUntilAllowedInSettings =>
      'Dein Gerät zeigt keine Hinweise an, bis du Benachrichtigungen in den Einstellungen erlaubst.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get notificationsPitchForum =>
      'Antworten, Erwähnungen und Direktnachrichten auf dem Sperrbildschirm, sobald sie eintreffen.';

  @override
  String get viewProfile => 'Profil ansehen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get changeEmail => 'E-Mail ändern';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get save => 'Speichern';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get newEmailAddress => 'Neue E-Mail-Adresse';

  @override
  String get emailChanged => 'E-Mail-Adresse geändert';

  @override
  String get emailChangeConfirm =>
      'Sieh in deinem Posteingang nach: Die neue Adresse gilt, sobald du sie bestätigst.';

  @override
  String get passwordChanged => 'Passwort geändert';

  @override
  String get account => 'Konto';

  @override
  String get pleaseEnterEmail => 'Bitte geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get pleaseEnterValidEmail =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get connectionErrorTitle => 'Verbindungsfehler';

  @override
  String get authenticationErrorTitle => 'Authentifizierungsfehler';

  @override
  String get permissionErrorTitle => 'Berechtigungsfehler';

  @override
  String get errorNoConnection =>
      'Keine Internetverbindung. Bitte überprüfen Sie Ihre Netzwerkeinstellungen.';

  @override
  String get errorTimeout =>
      'Zeitüberschreitung der Anfrage. Bitte versuchen Sie es erneut.';

  @override
  String get errorServer =>
      'Serverfehler. Bitte versuchen Sie es später erneut.';

  @override
  String get errorNetwork => 'Netzwerkfehler. Bitte versuchen Sie es erneut.';

  @override
  String get errorInvalidCredentials =>
      'Ungültiger Benutzername oder ungültiges Passwort.';

  @override
  String get errorSessionExpired =>
      'Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.';

  @override
  String get errorAccountLocked =>
      'Ihr Konto wurde gesperrt. Bitte wenden Sie sich an den Support.';

  @override
  String get errorAuthFailed =>
      'Authentifizierung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get errorForumNotFound => 'Forum nicht gefunden.';

  @override
  String get errorForumAccessDenied =>
      'Sie haben keine Berechtigung, auf dieses Forum zuzugreifen.';

  @override
  String get errorForumUnavailable =>
      'Das Forum ist derzeit nicht verfügbar. Bitte versuchen Sie es später erneut.';

  @override
  String get errorForumGeneric =>
      'Im Forum ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get errorDataNotFound =>
      'Die angeforderten Daten wurden nicht gefunden.';

  @override
  String get errorDataCorrupted =>
      'Die Daten scheinen beschädigt zu sein. Bitte aktualisieren Sie die Seite.';

  @override
  String get errorCache =>
      'Zwischengespeicherte Daten konnten nicht geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get errorInvalidInput => 'Eine Eingabe ist ungültig.';

  @override
  String get errorRequiredField => 'Bitte füllen Sie alle Pflichtfelder aus.';

  @override
  String get errorPermissionDenied => 'Dazu haben Sie keine Berechtigung.';

  @override
  String errorFeatureNotAvailable(String feature) {
    return '$feature ist in diesem Forum nicht verfügbar.';
  }

  @override
  String get errorStorageFull =>
      'Der Speicher ist voll. Bitte geben Sie Speicherplatz frei.';

  @override
  String get errorStorageAccessDenied =>
      'Zugriff auf den Speicher verweigert. Bitte überprüfen Sie die App-Berechtigungen.';

  @override
  String get loginInfo => 'Anmeldeinformation';

  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen';

  @override
  String get topicAnnouncement => 'Ankündigung';

  @override
  String get topicPinned => 'Angeheftet';

  @override
  String get topicLocked => 'Gesperrt';

  @override
  String get topicPoll => 'Umfrage';

  @override
  String get deletedBadge => 'GELÖSCHT';

  @override
  String get protectedBadge => 'Geschützt';

  @override
  String get lockTopic => 'Thema sperren';

  @override
  String get unlockTopic => 'Thema entsperren';

  @override
  String get lockTopicConfirm =>
      'Möchten Sie dieses Thema wirklich sperren? Andere Benutzer können dann nicht mehr antworten oder damit interagieren.';

  @override
  String get unlockTopicConfirm =>
      'Möchten Sie dieses Thema wirklich entsperren? Andere Benutzer können dann wieder antworten und damit interagieren.';

  @override
  String get stickTopic => 'Thema anheften';

  @override
  String get unstickTopic => 'Thema lösen';

  @override
  String get stickTopicConfirm =>
      'Möchten Sie dieses Thema wirklich anheften? Es wird für alle Benutzer oben im Forum angezeigt.';

  @override
  String get unstickTopicConfirm =>
      'Möchten Sie dieses Thema wirklich lösen? Es wird nicht mehr oben im Forum angezeigt.';

  @override
  String get undeleteTopic => 'Thema wiederherstellen';

  @override
  String get undeleteTopicConfirm =>
      'Möchten Sie dieses Thema wirklich wiederherstellen? Es ist dann wieder für andere Benutzer sichtbar.';

  @override
  String get additionalInformation => 'Weitere Angaben';

  @override
  String get dateOfBirth => 'Geburtsdatum';

  @override
  String get selectDateOfBirth => 'Geburtsdatum auswählen';

  @override
  String minimumAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Mindestalter: $age Jahre',
      one: 'Mindestalter: $age Jahr',
    );
    return '$_temp0';
  }

  @override
  String get locationIsRequired => 'Der Ort ist erforderlich';

  @override
  String get receiveSiteMailings => 'E-Mails der Website erhalten';

  @override
  String iAcceptTheDocument(String document) {
    return 'Ich akzeptiere die $document';
  }

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get imageExceedsUploadLimits =>
      'Dieses Bild überschreitet die Upload-Grenzen und muss optimiert werden:';

  @override
  String get originalSize => 'Originalgröße';

  @override
  String get originalDimensions => 'Originalabmessungen';

  @override
  String get optimizationsToBeApplied => 'Anzuwendende Optimierungen:';

  @override
  String get resizeImage => 'Größe ändern';

  @override
  String get convertFormat => 'Format umwandeln';

  @override
  String get smallerFileSize => 'kleinere Datei';

  @override
  String get formatNotSupported => 'Format nicht unterstützt';

  @override
  String get convertToJpgReason =>
      'In JPG umwandeln (Format nicht unterstützt oder zur Verkleinerung)';

  @override
  String get compressImage => 'Komprimieren';

  @override
  String compressQuality(int quality) {
    return 'Qualität: $quality %, um die Größengrenze einzuhalten';
  }

  @override
  String get estimatedFinalSize => 'Geschätzte Endgröße';

  @override
  String sizeReduction(String percent) {
    return 'Verkleinerung: $percent %';
  }

  @override
  String get pleaseLoginToCreateTopic =>
      'Bitte melden Sie sich an, um ein neues Thema zu erstellen';

  @override
  String get pleaseLoginToSubscribeForums =>
      'Bitte melden Sie sich an, um Foren zu beobachten';

  @override
  String get pleaseLoginToUnsubscribeForums =>
      'Bitte melden Sie sich an, um Foren nicht mehr zu beobachten';

  @override
  String errorLoadingContent(String error) {
    return 'Fehler beim Laden der Inhalte: $error';
  }

  @override
  String get noPermissionToViewSubforumTopics =>
      'Sie haben keine Berechtigung, Themen in diesem Unterforum anzuzeigen.';

  @override
  String get noDiscussionsYet => 'Noch keine Diskussionen.';

  @override
  String get unableToLoadForums => 'Foren konnten nicht geladen werden';

  @override
  String get noForumsAvailable => 'Keine Foren verfügbar';

  @override
  String get noForumsToDisplay =>
      'Es gibt keine Foren zum Anzeigen. Das kann an Berechtigungen oder der Forenstruktur liegen.';

  @override
  String get subscribedForums => 'Beobachtete Foren';

  @override
  String get allForumTopicsMarkedRead =>
      'Alle Themen des Forums wurden als gelesen markiert';

  @override
  String postsCountFormatted(String count) {
    return '$count Beiträge';
  }

  @override
  String get jumpToPost => 'Zu Beitrag springen';

  @override
  String get jump => 'Springen';

  @override
  String get endOfDiscussion => 'Ende der Diskussion';

  @override
  String refreshFailed(String error) {
    return 'Aktualisierung fehlgeschlagen: $error';
  }

  @override
  String get topicDeletedHidden =>
      'Dieses Thema ist gelöscht und für andere Benutzer verborgen';

  @override
  String get topicClosedNoReplies =>
      'Dieses Thema ist geschlossen und nimmt keine Antworten mehr an';

  @override
  String get youAreSubscribedToTopic => 'Sie beobachten dieses Thema';

  @override
  String get refreshing => 'Wird aktualisiert...';

  @override
  String get unableToLoadForumsTryAgain =>
      'Foren konnten nicht geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get noPostableForums =>
      'Es gibt keine Foren, in denen Sie schreiben können.';

  @override
  String get changeForumQuestion => 'Forum wechseln?';

  @override
  String get changeForumRemovesAttachments =>
      'Wenn Sie das Forum wechseln, werden Ihre hochgeladenen Anhänge entfernt, da Anhänge an das gewählte Forum gebunden sind.';

  @override
  String get changeForum => 'Forum wechseln';

  @override
  String get chooseForumBeforePosting =>
      'Bitte wählen Sie vor dem Posten ein Forum aus';

  @override
  String get accountCannotUploadAttachments =>
      'Ihr Konto kann auf dieser Website keine Anhänge hochladen.';

  @override
  String get forumNoAttachments => 'Dieses Forum erlaubt keine Anhänge.';

  @override
  String get forumNoAttachmentsChooseAnother =>
      'Dieses Forum erlaubt keine Anhänge. Wählen Sie ein anderes Forum, um die geteilten Dateien hochzuladen.';

  @override
  String get forumNoAttachmentsSharedPending =>
      'Dieses Forum erlaubt keine Anhänge. Geteilte Dateien warten, bis Sie ein anderes Forum wählen.';

  @override
  String get tapToChangeForum => 'Tippen, um das Forum zu wechseln';

  @override
  String get chooseWhichForum => 'Wählen Sie das Forum für Ihren Beitrag';

  @override
  String get selectAForum => 'Forum auswählen';

  @override
  String get unableToLoadForumsNow =>
      'Foren können gerade nicht geladen werden.';

  @override
  String get pickForumBeforeUploading =>
      'Wählen Sie ein Forum, bevor Sie Anhänge hochladen oder posten.';

  @override
  String get uploadingSharedFiles => 'Geteilte Dateien werden hochgeladen...';

  @override
  String get selectForum => 'Forum auswählen';

  @override
  String get noForumsMatchSearch => 'Keine Foren entsprechen Ihrer Suche.';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get closeConversationConfirm =>
      'Möchten Sie diese Unterhaltung wirklich schließen? Danach können keine neuen Antworten mehr gesendet werden.';

  @override
  String get openConversationConfirm =>
      'Möchten Sie diese Unterhaltung wirklich öffnen? Danach können wieder neue Antworten gesendet werden.';

  @override
  String get leaveConversationConfirm =>
      'Möchten Sie diese Unterhaltung wirklich verlassen? Sie wird dann in Ihrem Posteingang ausgeblendet.';

  @override
  String get close => 'Schließen';

  @override
  String get open => 'Öffnen';

  @override
  String get leave => 'Verlassen';

  @override
  String errorLoadingConversation(String error) {
    return 'Fehler beim Laden der Unterhaltung: $error';
  }

  @override
  String get conversationNotFound => 'Unterhaltung nicht gefunden';

  @override
  String get conversationClosedNoReplies =>
      'Diese Unterhaltung ist geschlossen und nimmt keine Antworten mehr an';

  @override
  String get noMessagesFound => 'Keine Nachrichten gefunden';

  @override
  String get endOfConversation => 'Ende der Unterhaltung';

  @override
  String get jumpToMessage => 'Zu Nachricht springen';

  @override
  String get jumpToFirstMessage => 'Zur ersten Nachricht springen';

  @override
  String get jumpToLastMessage => 'Zur letzten Nachricht springen';

  @override
  String messagePositionOf(int position, int total) {
    return 'Nachricht $position von $total';
  }

  @override
  String get tapToJumpToMessage =>
      'Tippen, um zu einer bestimmten Nachricht zu springen';

  @override
  String failedToReact(String error) {
    return 'Reaktion fehlgeschlagen: $error';
  }

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Teilnehmer',
      one: '$count Teilnehmer',
    );
    return '$_temp0';
  }

  @override
  String get noImagesToDisplay => 'Keine Bilder zum Anzeigen gefunden.';

  @override
  String get pleaseLoginToViewAttachment =>
      'Bitte melden Sie sich an, um diesen Anhang anzuzeigen';

  @override
  String get inbox => 'Posteingang';

  @override
  String get sent => 'Gesendet';

  @override
  String errorLoadingMessages(String error) {
    return 'Fehler beim Laden der Nachrichten: $error';
  }

  @override
  String get noInboxMessages => 'Keine Nachrichten im Posteingang';

  @override
  String get noSentMessages => 'Keine gesendeten Nachrichten';

  @override
  String get unknownDate => 'Unbekanntes Datum';

  @override
  String get searchForTopics => 'Nach Themen suchen';

  @override
  String get noTopicsFound => 'Keine Themen gefunden';

  @override
  String get noPostsFound => 'Keine Beiträge gefunden';

  @override
  String get trySearchingDifferentKeywords =>
      'Versuchen Sie es mit anderen Suchbegriffen';

  @override
  String errorLoadingSettings(String error) {
    return 'Fehler beim Laden der Einstellungen: $error';
  }

  @override
  String get pleaseEnterValidNumber => 'Bitte geben Sie eine gültige Zahl ein';

  @override
  String valueMustBeAtLeast(String min) {
    return 'Der Wert muss mindestens $min sein';
  }

  @override
  String valueMustBeAtMost(String max) {
    return 'Der Wert darf höchstens $max sein';
  }

  @override
  String maximumLengthCharacters(int max) {
    return 'Die maximale Länge beträgt $max Zeichen';
  }

  @override
  String get invalidFormat => 'Ungültiges Format';

  @override
  String get shareToForumCopilot => 'Mit Forum Copilot teilen';

  @override
  String get noSavedForumAccounts =>
      'Keine gespeicherten Forenkonten gefunden.';

  @override
  String get addForumAccountFirst =>
      'Fügen Sie zuerst in Forum Copilot ein Forenkonto hinzu und teilen Sie dann erneut.';

  @override
  String filesReadyToAttach(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien bereit zum Anhängen',
      one: '$count Datei bereit zum Anhängen',
    );
    return '$_temp0';
  }

  @override
  String get sharedTextWillBePrefilled => 'Geteilter Text wird vorausgefüllt';

  @override
  String errorSearchingForums(String error) {
    return 'Fehler bei der Forensuche: $error';
  }

  @override
  String failedToLoadUserInfo(String error) {
    return 'Benutzerinformationen konnten nicht geladen werden: $error';
  }

  @override
  String areYouSureUnban(String username) {
    return 'Möchten Sie die Sperre von $username wirklich aufheben?';
  }

  @override
  String get deletePostsProfilePostsComments =>
      'Beiträge, Profilnachrichten und Kommentare löschen';

  @override
  String areYouSureSpamClean(String username) {
    return 'Möchten Sie $username wirklich als Spam bereinigen?';
  }

  @override
  String successfullyCleanedSpamFor(String username) {
    return 'Spam von $username wurde bereinigt';
  }

  @override
  String get failedToCleanSpam => 'Spam konnte nicht bereinigt werden';

  @override
  String imagesCount(int count) {
    return 'Bilder ($count)';
  }

  @override
  String get pleaseLoginToViewProfiles =>
      'Bitte melden Sie sich an, um Benutzerprofile anzuzeigen.';

  @override
  String get tapToOpen => 'Zum Öffnen tippen';

  @override
  String get imageNotAvailable => 'Bild nicht verfügbar';

  @override
  String get tapToViewFullSizeImage =>
      'Tippen, um das Bild in voller Größe anzuzeigen';

  @override
  String get loadingImage => 'Bild wird geladen...';

  @override
  String loadingImageFrom(String host) {
    return 'Bild wird von $host geladen';
  }

  @override
  String get tapToReveal => '(zum Anzeigen tippen)';

  @override
  String get inlineAttachments => 'Eingebettete Anhänge';

  @override
  String get thisFieldIsRequired => 'Dieses Feld ist erforderlich';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'Bitte geben Sie eine gültige Telefonnummer ein';

  @override
  String get pleaseEnterValidUrl => 'Bitte geben Sie eine gültige URL ein';

  @override
  String get permissionDeniedToSaveImage =>
      'Keine Berechtigung zum Speichern des Bildes';

  @override
  String get postNotFound => 'Beitrag nicht gefunden.';

  @override
  String get failedToUploadFileTryAgain =>
      'Datei konnte nicht hochgeladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get failedToPickFile => 'Datei konnte nicht ausgewählt werden';

  @override
  String onlyMoreAttachmentsAllowed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Nur noch $count Anhänge erlaubt. Die ersten $count Bilder werden verwendet.',
      one: 'Nur noch 1 Anhang erlaubt. Das erste Bild wird verwendet.',
    );
    return '$_temp0';
  }

  @override
  String get attachmentLimitReachedSkipping =>
      'Anhangsgrenze erreicht. Die übrigen Bilder werden übersprungen.';

  @override
  String get imageValidationFailed => 'Bildprüfung fehlgeschlagen';

  @override
  String get imageUploadFailed => 'Bild konnte nicht hochgeladen werden';

  @override
  String get failedToUploadImageTryAgain =>
      'Bild konnte nicht hochgeladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get failedToPickImage => 'Bild konnte nicht ausgewählt werden';

  @override
  String get prefix => 'Präfix';

  @override
  String get failedToLoadPrefixes => 'Präfixe konnten nicht geladen werden';

  @override
  String get attachFileHint => 'Eine Datei an diese Nachricht anhängen';

  @override
  String get uploadImageHint => 'Ein Bild zu dieser Nachricht hochladen';

  @override
  String get openFormattingOptions => 'Formatierungsoptionen öffnen';

  @override
  String get failedToPostReply =>
      'Antwort konnte nicht gesendet werden. Bitte versuchen Sie es erneut.';

  @override
  String get failedToUpdatePost =>
      'Beitrag konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.';

  @override
  String get postDeletedSuccessfully => 'Beitrag gelöscht';

  @override
  String failedToDeletePost(String error) {
    return 'Beitrag konnte nicht gelöscht werden: $error';
  }

  @override
  String get noPermissionToUploadAvatars =>
      'Sie haben keine Berechtigung, Avatare hochzuladen';

  @override
  String get avatarUploadedSuccessfully => 'Avatar hochgeladen';

  @override
  String get unknownTopic => 'Unbekanntes Thema';

  @override
  String get connectionTimeoutTitle => 'Zeitüberschreitung der Verbindung';

  @override
  String connectionTimedOutTo(String siteName) {
    return 'Die Verbindung zu $siteName hat das Zeitlimit überschritten. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';
  }

  @override
  String failedToConnectCheckPlugin(String siteName) {
    return 'Verbindung zu $siteName fehlgeschlagen. Bitte prüfen Sie, ob das Forum erreichbar und das Plugin installiert ist.';
  }

  @override
  String get voteFailedTryAgain =>
      'Abstimmung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get noUserSpecified => 'Kein Benutzer angegeben';

  @override
  String get failedToLoadRecentPosts =>
      'Neueste Beiträge konnten nicht geladen werden';

  @override
  String failedToLoadPreview(String error) {
    return 'Vorschau konnte nicht geladen werden: $error';
  }

  @override
  String thanksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Von $count Personen bedankt',
      one: 'Von $count Person bedankt',
    );
    return '$_temp0';
  }

  @override
  String get thankedBy => 'Bedankt von';

  @override
  String maximumAttachmentsAllowed(int count) {
    return 'Maximal $count Anhang/Anhänge erlaubt';
  }

  @override
  String get toLabel => 'An';

  @override
  String get closeConversation => 'Unterhaltung schließen';

  @override
  String get openConversation => 'Unterhaltung öffnen';

  @override
  String get loginSucceeded => 'Anmeldung erfolgreich';

  @override
  String get verificationErrorTryAgain =>
      'Bei der Bestätigung ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get passkeyChallengeFailed =>
      'Die Anmeldung mit Passkey konnte nicht gestartet werden.';

  @override
  String get passkeyNotSetUp =>
      'Dieses Forum ist für die Anmeldung mit Passkey in dieser App noch nicht eingerichtet. Bitte melden Sie sich mit Benutzername und Passwort an.';

  @override
  String get noPasskeyForForum =>
      'Für dieses Forum wurde kein Passkey gefunden. Melden Sie sich mit Ihrem Passwort an oder erstellen Sie zuerst einen Passkey auf der Website des Forums.';

  @override
  String get pushNotificationsNotReady =>
      'Push-Benachrichtigungen sind noch nicht bereit';

  @override
  String pushEnabledFor(String siteName) {
    return 'Push-Benachrichtigungen für $siteName aktiviert';
  }

  @override
  String get failedToEnablePush =>
      'Push-Benachrichtigungen konnten nicht aktiviert werden';

  @override
  String get failedToRegisterPush =>
      'Registrierung für Push-Benachrichtigungen fehlgeschlagen';

  @override
  String translatedFromTo(String source, String target) {
    return 'Übersetzt aus $source in $target';
  }

  @override
  String get unableToOpenNotification =>
      'Benachrichtigung kann nicht geöffnet werden';

  @override
  String get notificationMissingInfo =>
      'Dieser Benachrichtigung fehlen Angaben.';

  @override
  String get couldNotOpenForum => 'Das Forum konnte nicht geöffnet werden.';

  @override
  String get notificationChannelName => 'Forum Copilot-Benachrichtigungen';

  @override
  String get notificationChannelDescription =>
      'Benachrichtigungen der Forum Copilot-App';

  @override
  String fileTypeNotAllowed(String extension, String allowed) {
    return 'Der Dateityp .$extension ist nicht erlaubt. Erlaubte Typen: $allowed';
  }

  @override
  String fileSizeExceedsMaximum(String size, String max) {
    return 'Die Dateigröße ($size) überschreitet das Maximum von $max';
  }

  @override
  String get fileTypeAudio => 'Audio';

  @override
  String get fileTypeText => 'Text';

  @override
  String get fileTypeArchive => 'Archiv';

  @override
  String get fileTypeFile => 'Datei';

  @override
  String get imageFileNotFound =>
      'Bilddatei nicht gefunden. Die Datei wurde möglicherweise verschoben oder gelöscht.';

  @override
  String get imagePermissionDenied =>
      'Zugriff verweigert. Die Bilddatei kann nicht gelesen werden.';

  @override
  String get imageInsufficientSpace =>
      'Nicht genügend Speicherplatz, um das Bild zu optimieren.';

  @override
  String cannotAccessImageFile(String error) {
    return 'Auf die Bilddatei kann nicht zugegriffen werden: $error';
  }

  @override
  String get imageFormatUnsupported =>
      'Das Bildformat ist beschädigt oder wird nicht unterstützt. Bitte versuchen Sie ein anderes Bild.';

  @override
  String get failedToResizeImage =>
      'Die Bildgröße konnte nicht geändert werden. Das Bild ist möglicherweise beschädigt oder hat ein nicht unterstütztes Format.';

  @override
  String get failedToConvertImageToJpg =>
      'Das Bild konnte nicht in JPG umgewandelt werden. Es ist möglicherweise beschädigt.';

  @override
  String get failedToCompressImage =>
      'Das Bild konnte nicht komprimiert werden. Möglicherweise fehlt Speicherplatz oder das Bild ist beschädigt.';

  @override
  String get cannotDecodeImage =>
      'Das Bild kann nicht gelesen werden. Die Datei ist möglicherweise beschädigt oder hat ein nicht unterstütztes Format.';

  @override
  String get cannotReadImageFile =>
      'Die Bilddatei kann nicht gelesen werden. Sie wurde möglicherweise verschoben oder gelöscht.';

  @override
  String failedToOptimizeImage(String error) {
    return 'Bild konnte nicht optimiert werden: $error';
  }

  @override
  String emailCopiedToClipboard(String email) {
    return 'E-Mail in Zwischenablage kopiert: $email';
  }

  @override
  String couldNotOpenEmail(String email) {
    return 'E-Mail konnte nicht geoeffnet werden: $email';
  }

  @override
  String get editPost => 'Beitrag bearbeiten';

  @override
  String get thisTopicIsPinnedToTopOfForum =>
      'Dieses Thema ist oben im Forum angeheftet';

  @override
  String get editConversation => 'Unterhaltung bearbeiten';

  @override
  String get failedToLoadConversation =>
      'Unterhaltung konnte nicht geladen werden';

  @override
  String get cannotEditConversation =>
      'Diese Unterhaltung kann nicht bearbeitet werden';

  @override
  String get titleLabel => 'Titel';

  @override
  String get options => 'Optionen';

  @override
  String get openInvite => 'Offene Einladung';

  @override
  String get allowAnyParticipantToInviteOthers =>
      'Allen Teilnehmern erlauben, weitere Personen einzuladen';

  @override
  String get conversationOpen => 'Unterhaltung offen';

  @override
  String failedToCreateConversation(String error) {
    return 'Unterhaltung konnte nicht erstellt werden: $error';
  }

  @override
  String get lockConversation => 'Unterhaltung sperren';

  @override
  String get createConversationAsClosed =>
      'Unterhaltung als geschlossen erstellen (keine Antworten erlaubt)';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountDescription =>
      'Entfernen Sie Ihr Konto aus diesem Forum.';

  @override
  String get deleteAccountContactForumMessage =>
      'Ihr Konto wird vom Forum verwaltet. Bitte wenden Sie sich direkt an das Forum, um das Konto zu löschen. Nutzen Sie die Schaltfläche „Kontakt“ unten auf der Forums-Startseite.';

  @override
  String get forumUrlUnavailable => 'Forum-URL ist nicht verfügbar.';

  @override
  String get couldNotOpenForumUrl => 'Forum-URL konnte nicht geöffnet werden.';

  @override
  String get noActionUrlAvailableForThisNotificationType =>
      'Diese Mitteilung hat keinen Link zum Öffnen.';

  @override
  String get signInToViewNotifications =>
      'Melden Sie sich an, um Mitteilungen zu sehen';

  @override
  String get youNeedToBeSignedInToViewYourNotifications =>
      'Sie müssen angemeldet sein, um Ihre Mitteilungen anzusehen.';

  @override
  String get errorLoadingNotifications => 'Fehler beim Laden der Mitteilungen';

  @override
  String get pullDownToRefresh => 'Zum Aktualisieren nach unten ziehen';

  @override
  String get youHaveNoNewNotificationsCheckBackLater =>
      'Sie haben keine neuen Mitteilungen. Schauen Sie später wieder vorbei.';

  @override
  String get signInToViewProfile =>
      'Melden Sie sich an, um das Profil anzusehen';

  @override
  String get youNeedToBeSignedInToViewYourProfile =>
      'Sie müssen angemeldet sein, um Ihr Profil anzusehen.';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get confirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get protectedForum => 'Geschuetztes Forum';

  @override
  String forumIsPasswordProtected(String forumName) {
    return '$forumName ist passwortgeschuetzt.';
  }

  @override
  String get enterButton => 'Eingeben';

  @override
  String get recentPosts => 'Neueste Beiträge';

  @override
  String passkeyNotAvailableInForum(int code) {
    return 'Passkey ist in diesem Forum derzeit nicht verfügbar (Code: $code)';
  }

  @override
  String get initializingForum => 'Forum wird gestartet…';

  @override
  String get retryConnection => 'Erneut verbinden';

  @override
  String get pleaseConfirmPassword => 'Bitte bestätigen Sie Ihr Passwort';

  @override
  String get pleaseEnterTheForumPassword =>
      'Bitte geben Sie das Forum-Passwort ein';

  @override
  String get editYourPost => 'Bearbeiten Sie Ihren Beitrag...';

  @override
  String get topicIdIsMissingCannotNavigateToThePost =>
      'Themen-ID fehlt. Navigation zum Beitrag nicht möglich.';

  @override
  String get conversationIsOpenForReplies =>
      'Unterhaltung ist für Antworten geöffnet';

  @override
  String get conversationIsClosedNoRepliesAllowed =>
      'Unterhaltung ist geschlossen (keine Antworten erlaubt)';

  @override
  String get pleaseEnterAUsername => 'Bitte geben Sie einen Benutzernamen ein';

  @override
  String usernameMinLength(int count) {
    return 'Der Benutzername muss mindestens $count Zeichen lang sein';
  }

  @override
  String get pleaseEnterAPassword => 'Bitte geben Sie ein Passwort ein';

  @override
  String passwordMinLength(int count) {
    return 'Das Passwort muss mindestens $count Zeichen lang sein';
  }

  @override
  String get writeYourTopicTitle => 'Titel Ihres Themas...';

  @override
  String get writeYourTopicContent => 'Inhalt Ihres Themas...';

  @override
  String pushDisabledFor(String siteName) {
    return 'Push-Benachrichtigungen für $siteName deaktiviert';
  }

  @override
  String get failedToDisablePush =>
      'Push-Benachrichtigungen konnten nicht deaktiviert werden';

  @override
  String get thisForumInSentence => 'dieses Forum';

  @override
  String get openFullEditor => 'Vollständiger Editor';

  @override
  String statsMembers(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Mitglieder',
      one: '$countString Mitglied',
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
      other: '$countString Themen',
      one: '$countString Thema',
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
      other: '$countString Beiträge',
      one: '$countString Beitrag',
    );
    return '$_temp0';
  }

  @override
  String searchForumName(String forumName) {
    return '$forumName durchsuchen';
  }

  @override
  String get copyLink => 'Link kopieren';

  @override
  String get linkCopied => 'Link kopiert';

  @override
  String sharedFilesAttached(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geteilte Dateien angehängt.',
      one: '1 geteilte Datei angehängt.',
    );
    return '$_temp0';
  }

  @override
  String sharedFilesPartlyAttached(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien angehängt. Nicht angehängt: $names',
      one: '1 Datei angehängt. Nicht angehängt: $names',
    );
    return '$_temp0';
  }

  @override
  String get notificationChannelMessages => 'Nachrichten';

  @override
  String get notificationChannelMessagesDescription =>
      'Neue Direktnachrichten und Antworten darauf';

  @override
  String get notificationChannelReplies => 'Antworten und Erwähnungen';

  @override
  String get notificationChannelRepliesDescription =>
      'Antworten in beobachteten Themen, Zitate und Erwähnungen';

  @override
  String get notificationChannelReactions => 'Likes und Reaktionen';

  @override
  String get notificationChannelReactionsDescription =>
      'Likes und Reaktionen auf deine Beiträge und Nachrichten';

  @override
  String get notificationChannelOther => 'Weitere Benachrichtigungen';

  @override
  String get notificationChannelOtherDescription =>
      'Folgen, Trophäen und andere Forenbenachrichtigungen';

  @override
  String get deleteAccountConfirmTitle => 'Konto löschen?';

  @override
  String deleteAccountConfirmMessage(String forumName) {
    return 'Dein Konto bei $forumName wird mit Profil und Einstellungen gelöscht. Deine Beiträge bleiben unter deinem Namen erhalten. Das lässt sich nicht rückgängig machen.';
  }

  @override
  String get deleteAccountNoPassword =>
      'Kein Passwort? Mit Benutzernamen bestätigen';

  @override
  String get deleteAccountUsePassword => 'Mit Passwort bestätigen';

  @override
  String get accountDeleted => 'Dein Konto wurde gelöscht.';

  @override
  String get signInOnWebsite => 'Auf der Website des Forums anmelden';

  @override
  String get signInOnWebsiteHint =>
      'Für Google, Facebook und andere Anmeldearten dort';

  @override
  String get browserLoginFailed =>
      'Die Anmeldung über die Website hat nicht geklappt. Bitte versuche es erneut.';

  @override
  String get subForums => 'Unterforen';

  @override
  String postPositionOf(int position, int total) {
    return 'Beitrag $position von $total';
  }

  @override
  String get tapToJumpToPost =>
      'Tippen, um zu einem bestimmten Beitrag zu springen';

  @override
  String get jumpToFirstPost => 'Zum ersten Beitrag springen';

  @override
  String get jumpToLastPost => 'Zum letzten Beitrag springen';

  @override
  String get send => 'Senden';

  @override
  String get postAction => 'Veröffentlichen';

  @override
  String messageCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Nachrichten',
      one: '$count Nachricht',
    );
    return '$_temp0';
  }

  @override
  String replyCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Antworten',
      one: '$count Antwort',
    );
    return '$_temp0';
  }

  @override
  String subForumCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Unterforen',
      one: '$count Unterforum',
    );
    return '$_temp0';
  }

  @override
  String get trustThisDevice => 'Diesem Gerät vertrauen';

  @override
  String get trustThisDeviceHint =>
      'Beim nächsten Anmelden auf diesem Gerät nicht nach einem Code fragen';

  @override
  String get passkeyNotOnThisDevice =>
      'Auf diesem Gerät gibt es keinen Passkey für dieses Forum. Wähle eine andere Methode oder füge zuerst auf der Website des Forums einen Passkey hinzu.';

  @override
  String get passkeyStepNotSetUp =>
      'Dieses Forum ist in dieser App noch nicht für Passkeys eingerichtet. Wähle eine andere Methode.';

  @override
  String get ignoreMember => 'Mitglied ignorieren';

  @override
  String get stopIgnoringMember => 'Nicht mehr ignorieren';

  @override
  String memberIgnored(String name) {
    return 'Du ignorierst jetzt $name.';
  }

  @override
  String memberNoLongerIgnored(String name) {
    return 'Du ignorierst $name nicht mehr.';
  }

  @override
  String get ignoredMembers => 'Ignorierte Mitglieder';

  @override
  String get ignoredMembersExplanation =>
      'Inhalte von Mitgliedern, die du ignorierst, werden ausgeblendet, und sie können keine Unterhaltungen mit dir beginnen.';

  @override
  String get noIgnoredMembers => 'Du ignorierst niemanden.';

  @override
  String youAreIgnoringMember(String name) {
    return 'Du ignorierst $name.';
  }

  @override
  String get showIgnoredContent => 'Anzeigen';

  @override
  String get markAllAlertsRead => 'Alle als gelesen markieren';

  @override
  String get topicSolved => 'Gelöst';

  @override
  String get topicQuestion => 'Frage';

  @override
  String get solutionBadge => 'LÖSUNG';

  @override
  String get forumClosedTitle => 'Das Forum ist geschlossen';

  @override
  String get updatedTermsTitle => 'Aktualisierte Bedingungen';

  @override
  String get updatedTermsMessage =>
      'Das Forum hat seine Bedingungen oder Datenschutzerklärung aktualisiert. Bitte lies und akzeptiere sie auf der Website.';

  @override
  String get reviewTerms => 'Ansehen';

  @override
  String get forumTerms => 'Nutzungsbedingungen und Regeln';

  @override
  String get contactForum => 'Kontakt';

  @override
  String get notifyMeOf => 'Benachrichtige mich über';

  @override
  String get watchNewThreads => 'Neuen Themen';

  @override
  String get watchNewMessages => 'Neuen Beiträgen';

  @override
  String get watchSendAlerts => 'Mitteilungen';

  @override
  String get watchSendEmails => 'E-Mails';

  @override
  String get logInToWatchThread =>
      'Bitte melden Sie sich an, um dieses Thema zu beobachten';

  @override
  String get failedToWatchThread => 'Das Thema konnte nicht beobachtet werden';

  @override
  String get failedToUnwatchThread =>
      'Die Beobachtung des Themas konnte nicht beendet werden';

  @override
  String get watchThreadAlertsNote =>
      'Du erhältst eine Mitteilung, wenn jemand antwortet.';

  @override
  String get threadFilters => 'Filter';

  @override
  String get anyPrefix => '(Beliebig)';

  @override
  String get startedBy => 'Erstellt von';

  @override
  String get lastUpdated => 'Zuletzt aktualisiert';

  @override
  String get anyTime => 'Jederzeit';

  @override
  String periodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String periodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Monate',
      one: '1 Monat',
    );
    return '$_temp0';
  }

  @override
  String periodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jahre',
      one: '1 Jahr',
    );
    return '$_temp0';
  }

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortAscending => 'Aufsteigend';

  @override
  String get sortDescending => 'Absteigend';

  @override
  String get clearFilters => 'Filter zurücksetzen';

  @override
  String get applyFilters => 'Filtern';

  @override
  String get noThreadsMatchFilters =>
      'Keine Themen entsprechen diesen Filtern.';

  @override
  String get threadTypeLabel => 'Thementyp';

  @override
  String get pollQuestion => 'Umfragefrage';

  @override
  String get pollResponses => 'Mögliche Antworten';

  @override
  String pollResponseNumber(int number) {
    return 'Antwort $number';
  }

  @override
  String get addPollResponse => 'Antwort hinzufügen';

  @override
  String get removePollResponse => 'Antwort entfernen';

  @override
  String get pollMultipleChoice => 'Mehrere Antworten erlauben';

  @override
  String get pollChangeVote => 'Ändern der Stimme erlauben';

  @override
  String get pollPublicVotes => 'Stimmen öffentlich anzeigen';

  @override
  String get pollViewResultsUnvoted => 'Ergebnisse ohne Abstimmung anzeigen';

  @override
  String get pollCloseAfter => 'Umfrage schließen nach';

  @override
  String get pollNeverCloses => 'Nie';

  @override
  String get noneOption => '(Keine)';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get tagsHint => 'Tags durch Kommas trennen';

  @override
  String addAtLeastTags(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mindestens $count Tags hinzufügen',
      one: 'Mindestens 1 Tag hinzufügen',
    );
    return '$_temp0';
  }

  @override
  String threadFieldRequired(String field) {
    return 'Bitte $field ausfüllen.';
  }

  @override
  String get pollNeedsQuestionAndResponses =>
      'Gib eine Umfragefrage und mindestens zwei Antworten ein.';

  @override
  String get awaitingApprovalBadge => 'WARTET AUF FREIGABE';

  @override
  String get approve => 'Freigeben';

  @override
  String get postApproved => 'Beitrag freigegeben';

  @override
  String get postUndeleted => 'Beitrag wiederhergestellt';

  @override
  String quoteSaid(String name) {
    return '$name sagte:';
  }

  @override
  String timeGapDaysLater(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage später',
      one: '1 Tag später',
    );
    return '$_temp0';
  }

  @override
  String timeGapMonthsLater(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Monate später',
      one: '1 Monat später',
    );
    return '$_temp0';
  }

  @override
  String timeGapYearsLater(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jahre später',
      one: '1 Jahr später',
    );
    return '$_temp0';
  }

  @override
  String topicMapViews(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aufrufe',
      one: 'Aufruf',
    );
    return '$_temp0';
  }

  @override
  String topicMapReplies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Antworten',
      one: 'Antwort',
    );
    return '$_temp0';
  }

  @override
  String get thisForum => 'Dieses Forum';

  @override
  String postLastEdited(String date) {
    return 'Zuletzt bearbeitet: $date';
  }

  @override
  String postLastEditedByModerator(String date) {
    return 'Zuletzt von einem Moderator bearbeitet: $date';
  }
}

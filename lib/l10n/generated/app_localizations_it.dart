// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'Accedi';

  @override
  String get usernameLabel => 'Nome utente';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Accedi';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get pleaseEnterUsername => 'Inserisci il tuo nome utente';

  @override
  String get pleaseEnterPassword => 'Inserisci la tua password';

  @override
  String credentialsSentToDomain(String domain) {
    return 'Il tuo nome utente e password saranno inviati a $domain';
  }

  @override
  String get createAccount => 'Crea account';

  @override
  String get alreadyHaveAccount => 'Hai già un account? ';

  @override
  String get logIn => 'Accedi';

  @override
  String get continueButton => 'Continua';

  @override
  String get registrationNotAvailable => 'Registrazione non disponibile';

  @override
  String get registrationNotAvailableMessage =>
      'La registrazione non è attualmente disponibile. Il forum potrebbe essere chiuso o la registrazione potrebbe essere disabilitata.';

  @override
  String get webRegistrationRequired => 'Registrazione web richiesta';

  @override
  String get webRegistrationRequiredMessage =>
      'Questo forum richiede la registrazione tramite il browser web. Fai clic sul pulsante qui sotto per aprire la pagina di registrazione.';

  @override
  String get openRegistrationPage => 'Apri pagina di registrazione';

  @override
  String get loadingAdditionalFields => 'Caricamento campi aggiuntivi...';

  @override
  String get pleaseSelectDateOfBirth => 'Seleziona la tua data di nascita';

  @override
  String get pleaseEnterLocation => 'Inserisci la tua posizione';

  @override
  String get pleaseIndicateEmailPreference => 'Indica la tua preferenza email';

  @override
  String get pleaseFillAllRequiredFields => 'Compila tutti i campi obbligatori';

  @override
  String get pleaseAcceptTermsOfService => 'Accetta i Termini di Servizio';

  @override
  String get pleaseAcceptPrivacyPolicy =>
      'Accetta l\'Informativa sulla Privacy';

  @override
  String get registrationError => 'Errore di registrazione';

  @override
  String get registrationFailed =>
      'Registrazione fallita. Controlla le tue informazioni.';

  @override
  String get registrationFailedTryAgain => 'Registrazione fallita. Riprova.';

  @override
  String get registrationInfo => 'Informazioni di registrazione';

  @override
  String get openWebsite => 'Apri sito web';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'Impossibile aprire il sito web del forum. Prova a visitare: $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      'Registrazione completata! Controlla la tua email per confermare il tuo account prima di accedere.';

  @override
  String get registrationSuccessfulPendingApproval =>
      'Registrazione completata! Il tuo account è in attesa di approvazione. Riceverai una notifica quando il tuo account sarà approvato.';

  @override
  String get registrationSuccessfulAutoLogin =>
      'Registrazione completata! Sei stato automaticamente connesso.';

  @override
  String get welcome => 'Benvenuto!';

  @override
  String get registrationSuccessful => 'Registrazione completata';

  @override
  String get pleaseLoginWithNewAccount => 'Accedi con il tuo nuovo account.';

  @override
  String get forgotPasswordTitle => 'Password dimenticata';

  @override
  String get usernameOrEmailLabel => 'Nome utente o email';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Inserisci il tuo nome utente o email';

  @override
  String get sendResetLink => 'Invia link di reset';

  @override
  String get resetLinkSent => 'Link di reset inviato';

  @override
  String get passwordResetInstructionsSent =>
      'Le istruzioni per reimpostare la password sono state inviate al tuo indirizzo email registrato.';

  @override
  String get resetFailed => 'Reset fallito';

  @override
  String get unableToSendResetLink =>
      'Impossibile inviare il link di reset. Riprova.';

  @override
  String get errorSendingResetLink =>
      'Si è verificato un errore durante l\'invio del link di reset. Controlla la tua connessione e riprova.';

  @override
  String get errorTitle => 'Errore';

  @override
  String get okButton => 'OK';

  @override
  String get retryButton => 'Riprova';

  @override
  String get copyToClipboard => 'Copia negli appunti';

  @override
  String get copied => 'Copiato';

  @override
  String get errorMessageCopiedToClipboard =>
      'Messaggio di errore copiato negli appunti';

  @override
  String get dismiss => 'Chiudi';

  @override
  String get cancel => 'Annulla';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get getHelp => 'Ottieni aiuto';

  @override
  String get somethingWentWrong => 'Qualcosa è andato storto';

  @override
  String get unexpectedErrorOccurred =>
      'Si è verificato un errore imprevisto. Riprova.';

  @override
  String get noInternetConnection => 'Nessuna connessione Internet';

  @override
  String get checkInternetConnection =>
      'Controlla la tua connessione Internet e riprova.';

  @override
  String get authenticationRequired => 'Autenticazione richiesta';

  @override
  String get pleaseLoginToContinue => 'Accedi per continuare.';

  @override
  String get forumError => 'Errore del forum';

  @override
  String get anErrorOccurred => 'Si è verificato un errore';

  @override
  String get accountPendingApproval =>
      'Il tuo account è in attesa di approvazione. Puoi navigare nel forum ma non puoi pubblicare finché un moderatore non approva il tuo account.';

  @override
  String get checkEmailToConfirm =>
      'Controlla la tua email per confermare il tuo account. Fai clic sul link di conferma nell\'email che ti abbiamo inviato.';

  @override
  String get checkNewEmailToConfirm =>
      'Controlla il tuo nuovo indirizzo email per confermare la modifica. La tua vecchia email rimarrà attiva finché non confermi la nuova.';

  @override
  String get emailAddressInvalid =>
      'Il tuo indirizzo email sembra essere non valido o sta rimbalzando le email. Aggiorna il tuo indirizzo email nelle impostazioni dell\'account.';

  @override
  String get accountDisabled =>
      'Il tuo account è stato disabilitato. Contatta un amministratore per assistenza.';

  @override
  String get accountRegistrationRejected =>
      'La registrazione del tuo account è stata rifiutata. Contatta un amministratore per maggiori informazioni.';

  @override
  String get welcomeToForumCopilot => 'Benvenuto in Forum Copilot!';

  @override
  String get successfullyLoggedOut => 'Hai effettuato il logout con successo';

  @override
  String get accountStatusRequiresAttention =>
      'Lo stato del tuo account richiede attenzione. Contatta un amministratore se hai domande.';

  @override
  String get updateEmail => 'Aggiorna email';

  @override
  String get resend => 'Invia di nuovo';

  @override
  String get noLatestTopics => 'Nessun argomento recente';

  @override
  String get noRecentTopicsToDisplay =>
      'Non ci sono argomenti recenti da visualizzare. Torna più tardi per nuove discussioni.';

  @override
  String get signInToViewLatestTopics =>
      'Accedi per visualizzare gli argomenti recenti';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Devi accedere per visualizzare gli argomenti recenti';

  @override
  String get noUnreadTopics => 'Nessun argomento non letto';

  @override
  String get thereAreNoUnreadTopics =>
      'Non ci sono argomenti non letti. Torna più tardi per nuove discussioni.';

  @override
  String get youAreAllCaughtUp => 'Sei aggiornato!';

  @override
  String get signInToViewUnreadTopics =>
      'Accedi per visualizzare gli argomenti non letti';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Devi accedere per visualizzare i tuoi argomenti non letti';

  @override
  String get noSubscribedTopics => 'Nessun argomento sottoscritto';

  @override
  String get noSubscribedTopicsMessage =>
      'Non ti sei iscritto ad alcun argomento. Tocca il pulsante stella su un argomento per iscriverti e ricevere notifiche per nuovi aggiornamenti.';

  @override
  String get signInToViewSubscribedTopics =>
      'Accedi per visualizzare gli argomenti sottoscritti';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Devi accedere per visualizzare i tuoi argomenti sottoscritti';

  @override
  String get noParticipatedTopics => 'Nessun argomento partecipato';

  @override
  String get topicsYouParticipatedIn =>
      'Gli argomenti a cui hai partecipato verranno mostrati qui.';

  @override
  String get signInToViewParticipatedTopics =>
      'Accedi per visualizzare gli argomenti partecipati';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Devi accedere per visualizzare gli argomenti a cui hai partecipato';

  @override
  String get latest => 'Recenti';

  @override
  String get unread => 'Non letti';

  @override
  String get subscribed => 'Sottoscritti';

  @override
  String get participated => 'Partecipati';

  @override
  String get connectionTimedOut =>
      'Connessione scaduta. Il sito potrebbe essere offline o irraggiungibile.';

  @override
  String get failedToConnectToSite =>
      'Impossibile connettersi al sito. Il sito potrebbe essere offline o irraggiungibile.';

  @override
  String get connectionFailed => 'Connessione fallita';

  @override
  String failedToConnectToSiteName(String siteName) {
    return 'Impossibile connettersi a $siteName';
  }

  @override
  String get loading => 'Caricamento...';

  @override
  String get newConversation => 'Nuova conversazione';

  @override
  String get newMessage => 'Nuovo messaggio';

  @override
  String get appSettings => 'Impostazioni app';

  @override
  String get searchSites => 'Cerca siti';

  @override
  String get language => 'Lingua';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String get followSystemLanguage => 'Segui la lingua di sistema';

  @override
  String get all => 'Tutti';

  @override
  String get topicsOnly => 'Solo argomenti';

  @override
  String get titlesOnly => 'Solo titoli';

  @override
  String failedToShareTopic(String error) {
    return 'Impossibile condividere l\'argomento: $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'Accedi per $action questo thread';
  }

  @override
  String get subscribeTo => 'iscriverti a';

  @override
  String get unsubscribeFrom => 'disiscriverti da';

  @override
  String get subscribe => 'Iscriviti';

  @override
  String get unsubscribe => 'Disiscriviti';

  @override
  String failedToSubscribeToThread(String action) {
    return 'Impossibile $action thread';
  }

  @override
  String get youCannotReplyToThisThread =>
      'Non puoi rispondere a questo thread';

  @override
  String get pleaseWaitForThreadToLoad => 'Attendi che il thread si carichi';

  @override
  String get softDelete => 'Eliminazione soft';

  @override
  String get postCanBeRestoredLater =>
      'Il post può essere ripristinato in seguito';

  @override
  String get hardDelete => 'Eliminazione permanente';

  @override
  String get postWillBePermanentlyDeleted =>
      'Il post verrà eliminato permanentemente';

  @override
  String get reasonForDeletion => 'Motivo dell\'eliminazione';

  @override
  String get enterReasonForDeletingPost =>
      'Inserisci il motivo per eliminare questo post';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Inserisci un motivo per l\'eliminazione';

  @override
  String get reportPost => 'Segnala post';

  @override
  String get pleaseProvideReasonForReporting =>
      'Fornisci un motivo per segnalare questo post.';

  @override
  String get reason => 'Motivo';

  @override
  String get enterReasonForReportingPost =>
      'Inserisci il motivo per segnalare questo post';

  @override
  String get pleaseEnterReason => 'Inserisci un motivo';

  @override
  String get submitReport => 'Invia segnalazione';

  @override
  String get selectedActions => 'Azioni selezionate:';

  @override
  String get thisActionCannotBeUndone =>
      'Questa azione non può essere annullata.';

  @override
  String get participantsLabel => 'Partecipanti';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username è stato invitato alla conversazione';
  }

  @override
  String errorInvitingUser(String error) {
    return 'Errore nell\'invitare l\'utente: $error';
  }

  @override
  String get newTopic => 'Nuovo argomento';

  @override
  String get markRead => 'Segna come letto';

  @override
  String get reportUser => 'Segnala utente';

  @override
  String get pleaseSelectReasonForReportingUser =>
      'Seleziona un motivo per segnalare questo utente.';

  @override
  String get spamOrAdvertising => 'Spam o pubblicità';

  @override
  String get harassmentOrBullying => 'Molestie o bullismo';

  @override
  String get inappropriateContent => 'Contenuto inappropriato';

  @override
  String get impersonationOrFakeAccount => 'Impersonificazione o account falso';

  @override
  String get otherPleaseSpecify => 'Altro (specifica)';

  @override
  String get pleaseSpecifyReason => 'Specifica il motivo';

  @override
  String get enterReasonForReportingUser =>
      'Inserisci il motivo per segnalare questo utente';

  @override
  String get pleaseSelectReason => 'Seleziona un motivo';

  @override
  String get banUser => 'Banna utente';

  @override
  String get unbanUser => 'Sbanna Utente';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return 'Seleziona un motivo per bannare $username';
  }

  @override
  String get violationOfCommunityGuidelines =>
      'Violazione delle linee guida della comunità';

  @override
  String get harassmentOrAbusiveBehavior => 'Molestie o comportamento abusivo';

  @override
  String get postingInappropriateContent =>
      'Pubblicazione di contenuto inappropriato';

  @override
  String get accountCompromiseOrSecurityIssue =>
      'Compromissione dell\'account o problema di sicurezza';

  @override
  String get enterReasonForBanningUser =>
      'Inserisci il motivo per bannare questo utente';

  @override
  String get banUntil => 'Banna fino a';

  @override
  String get selectDate => 'Seleziona data';

  @override
  String get moreOptions => 'Altre opzioni';

  @override
  String get leaveConversation => 'Lascia conversazione';

  @override
  String get reportConversation => 'Segnala conversazione';

  @override
  String get topicClosed => 'Argomento chiuso';

  @override
  String get topicOpened => 'Argomento aperto';

  @override
  String get topicStickied => 'Argomento in evidenza';

  @override
  String get topicUnstickied => 'Argomento rimosso da evidenza';

  @override
  String cannotEditMessage(String error) {
    return 'Impossibile modificare questo messaggio: $error';
  }

  @override
  String get confirmSpamClean => 'Conferma Pulizia Spam';

  @override
  String get handleThreads => 'Gestisci Thread';

  @override
  String get deleteMessages => 'Elimina Messaggi';

  @override
  String get deleteConversations => 'Elimina Conversazioni';

  @override
  String get myForums => 'I Miei Forum';

  @override
  String get recentlyVisited => 'Visitati di Recente';

  @override
  String get explore => 'Esplora';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => 'Nessuna conversazione';

  @override
  String get noConversationsMessage =>
      'Non hai ancora conversazioni. Avvia una nuova conversazione per iniziare a inviare messaggi.';

  @override
  String get imageSavedToGallery => 'Immagine salvata nella galleria!';

  @override
  String failedToSaveImage(String error) {
    return 'Impossibile salvare l\'immagine: $error';
  }

  @override
  String get userProfile => 'Profilo Utente';

  @override
  String get deletePost => 'Elimina Post';

  @override
  String get loginRequired => 'Accesso Richiesto';

  @override
  String get spamCleaner => 'Pulizia Spam';

  @override
  String get sendMessage => 'Invia messaggio';

  @override
  String get memberSince => 'Membro Dal';

  @override
  String get lastActivity => 'Ultima Attività';

  @override
  String get likesReceived => 'Mi Piace Ricevuti';

  @override
  String get likesGiven => 'Mi Piace Dati';

  @override
  String get showMore => 'Mostra di più';

  @override
  String get cleanSpam => 'Pulisci spam';

  @override
  String get failedToSaveMessage => 'Impossibile salvare il messaggio';

  @override
  String get failedToSaveConversation =>
      'Errore nel salvataggio della conversazione';

  @override
  String get failedToSaveSetting => 'Impossibile salvare l\'impostazione';

  @override
  String get failedToSavePost => 'Impossibile salvare il post';

  @override
  String errorLoadingSites(String error) {
    return 'Errore nel caricamento dei siti: $error';
  }

  @override
  String connectingTo(String domainName) {
    return 'Connessione a $domainName...';
  }

  @override
  String get members => 'Membri';

  @override
  String get allMembers => 'Tutti i Membri';

  @override
  String get online => 'Online';

  @override
  String get noMembersFound => 'Nessun membro trovato';

  @override
  String get searchForMembers => 'Cerca membri';

  @override
  String get enterUsernameToFindMembers =>
      'Inserisci un nome utente per trovare membri del forum';

  @override
  String get noMembersOnline => 'Al momento non ci sono membri online';

  @override
  String get enterUsernameToSearch => 'Inserisci nome utente per cercare...';

  @override
  String get lookupMembers => 'Cerca Membri';

  @override
  String get addMembers => 'Aggiungi Membri';

  @override
  String get membersAddedSuccessfully => 'Membri aggiunti con successo';

  @override
  String errorAddingMembers(String error) {
    return 'Errore nell\'aggiunta di membri: $error';
  }

  @override
  String get failedToLoadOnlineUsers =>
      'Impossibile caricare gli utenti online';

  @override
  String get noUsersOnline => 'Nessun utente online';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Membri';
  }

  @override
  String get noSubject => 'Nessun oggetto';

  @override
  String get search => 'Cerca';

  @override
  String get logout => 'Esci';

  @override
  String get areYouSureYouWantToLogout => 'Sei sicuro di voler uscire?';

  @override
  String get register => 'Registrati';

  @override
  String get signIn => 'Accedi';

  @override
  String get markForumRead => 'Segna Forum come Letto';

  @override
  String get notificationTest => 'Test Notifiche';

  @override
  String get forum => 'Forum';

  @override
  String get profile => 'Profilo';

  @override
  String get messages => 'Messaggi';

  @override
  String get add => 'Aggiungi';

  @override
  String get retry => 'Riprova';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteMessage => 'Elimina Messaggio';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'Sei sicuro di voler eliminare questo messaggio?';

  @override
  String failedToDeleteMessage(String error) {
    return 'Impossibile eliminare il messaggio: $error';
  }

  @override
  String get deletingPost => 'Eliminazione post...';

  @override
  String failedToUnlikePost(String error) {
    return 'Impossibile rimuovere il like dal post: $error';
  }

  @override
  String failedToLikePost(String error) {
    return 'Impossibile mettere like al post: $error';
  }

  @override
  String failedToThankPost(String error) {
    return 'Impossibile ringraziare il post: $error';
  }

  @override
  String get signInToViewMessages => 'Accedi per visualizzare i messaggi';

  @override
  String get youNeedToBeSignedInToViewConversations =>
      'Devi accedere per visualizzare le tue conversazioni.';

  @override
  String errorLoadingConversations(String error) {
    return 'Errore nel caricamento delle conversazioni: $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return 'Impossibile lasciare la conversazione: $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return 'Errore nel caricamento di altre conversazioni: $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'Errore nel caricamento di altri messaggi: $error';
  }

  @override
  String get inviteMessageOptional => 'Messaggio di Invito (opzionale)';

  @override
  String get iWouldLikeToAddYouToThisConversation =>
      'Vorrei aggiungerti a questa conversazione.';

  @override
  String get searchFailed => 'Ricerca fallita';

  @override
  String get trySearchingWithDifferentUsername =>
      'Prova a cercare con un nome utente diverso';

  @override
  String get noSitesFound => 'Nessun sito trovato.';

  @override
  String get userInformationNotAvailable =>
      'Informazioni utente non disponibili';

  @override
  String get birthday => 'Compleanno';

  @override
  String get posts => 'Post';

  @override
  String get following => 'Seguiti';

  @override
  String get followers => 'Follower';

  @override
  String get about => 'Informazioni';

  @override
  String get location => 'Posizione';

  @override
  String get website => 'Sito web';

  @override
  String get signature => 'Firma';

  @override
  String get next => 'Avanti';

  @override
  String get permanent => 'Permanente';

  @override
  String get temporary => 'Temporaneo';

  @override
  String setBanDurationFor(String username) {
    return 'Imposta la durata del ban per $username';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan =>
      'Seleziona una data di fine per il ban temporaneo';

  @override
  String get back => 'Indietro';

  @override
  String get unban => 'Rimuovi Ban';

  @override
  String get confirm => 'Conferma';

  @override
  String spamClean(String username) {
    return 'Pulisci Spam di $username';
  }

  @override
  String get selectActionsToPerform => 'Seleziona le azioni da eseguire:';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Sposta o elimina thread in base alle impostazioni dell\'amministratore';

  @override
  String get messageUpdatedSuccessfully => 'Messaggio aggiornato con successo';

  @override
  String error(String error) {
    return 'Errore: $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return 'Impossibile rimuovere l\'allegato: $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'Impossibile caricare il messaggio: $error';
  }

  @override
  String get editMessage => 'Modifica Messaggio';

  @override
  String get removeAttachment => 'Rimuovi Allegato';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      'Sei sicuro di voler rimuovere questo allegato?';

  @override
  String get none => 'Nessuno';

  @override
  String get attachFile => 'Allega File';

  @override
  String get uploadImage => 'Carica Immagine';

  @override
  String get formatting => 'Formattazione';

  @override
  String get bold => 'Grassetto';

  @override
  String get italic => 'Corsivo';

  @override
  String get underline => 'Sottolineato';

  @override
  String get strikethrough => 'Barrato';

  @override
  String get link => 'Collegamento';

  @override
  String get image => 'Immagine';

  @override
  String get video => 'Video';

  @override
  String get quote => 'Citazione';

  @override
  String get code => 'Codice';

  @override
  String get spoiler => 'Spoiler';

  @override
  String get bulletList => 'Elenco Puntato';

  @override
  String get numberedList => 'Elenco Numerato';

  @override
  String get listItem => 'Elemento Elenco';

  @override
  String participants(int count) {
    return 'Partecipanti ($count)';
  }

  @override
  String get markAsUnread => 'Segna come non letto';

  @override
  String get invite => 'Invita';

  @override
  String get welcomeBack => 'Bentornato!';

  @override
  String get signInToAccessYourProfile =>
      'Accedi per accedere al tuo profilo e gestire il tuo account';

  @override
  String get enterYourUsername => 'Inserisci il tuo nome utente';

  @override
  String get enterYourPassword => 'Inserisci la tua password';

  @override
  String get dontHaveAnAccount => 'Non hai un account?';

  @override
  String get enterKeywordsToSearchTopics =>
      'Inserisci parole chiave per cercare argomenti...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Compila tutti i campi obbligatori';

  @override
  String get undelete => 'Ripristina';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get share => 'Condividi';

  @override
  String get viewOnWeb => 'Visualizza sul Web';

  @override
  String get unlock => 'Sblocca';

  @override
  String get lock => 'Blocca';

  @override
  String get stick => 'Appunta';

  @override
  String get unstick => 'Rimuovi appuntamento';

  @override
  String get reply => 'Rispondi';

  @override
  String get vote => 'Vota';

  @override
  String votesCount(int count) {
    return '$count voti';
  }

  @override
  String get pollClosed => 'Sondaggio chiuso';

  @override
  String pollEndsOn(String date) {
    return 'Scade il $date';
  }

  @override
  String get voteToSeeResults => 'Vota per vedere i risultati';

  @override
  String get viewFullPoll => 'Sondaggio completo';

  @override
  String pollOptionsCount(int count) {
    return '$count opzioni';
  }

  @override
  String get reactedBy => 'Reagito da';

  @override
  String get enterKeywordsToFindTopicsAndPosts =>
      'Inserisci parole chiave per trovare argomenti e post';

  @override
  String get enterKeywordsOrDomainToFindForums =>
      'Inserisci parole chiave o dominio per trovare forum';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'Inserisci parole chiave o nomi di dominio per trovare forum';

  @override
  String get appearance => 'Aspetto';

  @override
  String get followSystemTheme => 'Segui il tema di sistema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String version(String version, String buildNumber) {
    return 'versione $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'Impostazioni Forum';

  @override
  String get noSettingsAvailable => 'Nessuna impostazione disponibile';

  @override
  String get settingsCategoriesWillAppearHere =>
      'Le categorie di impostazioni appariranno qui quando disponibili.';

  @override
  String get unableToLoadProfile => 'Impossibile caricare il profilo';

  @override
  String get banned => 'BANNITO';

  @override
  String get reportSubmittedSuccessfully => 'Segnalazione inviata con successo';

  @override
  String get failedToSubmitReport => 'Invio segnalazione fallito';

  @override
  String get searchForForums => 'Cerca forum';

  @override
  String get searchForums => 'Cerca Forum';

  @override
  String get deleteTopic => 'Elimina argomento';

  @override
  String get topicCanBeRestoredLater =>
      'L\'argomento può essere ripristinato in seguito';

  @override
  String get topicWillBePermanentlyDeleted =>
      'L\'argomento sarà eliminato permanentemente';

  @override
  String get enterReasonForDeletingTopic =>
      'Inserisci il motivo per eliminare questo argomento';

  @override
  String get pleaseSelectEndDate => 'Seleziona una data di fine';

  @override
  String get userBannedSuccessfully => 'Utente bannato con successo';

  @override
  String get failedToBanUser => 'Impossibile bannare l\'utente';

  @override
  String get userUnbannedSuccessfully => 'Utente sbannato con successo';

  @override
  String get failedToUnbanUser => 'Impossibile sbannare l\'utente';

  @override
  String get spamCleanUser => 'Pulisci spam utente';

  @override
  String get deletePrivateConversations => 'Elimina conversazioni private';

  @override
  String get banTheUserAccount => 'Banna l\'account utente';

  @override
  String get handledThreads => 'Argomenti gestiti';

  @override
  String get deletedMessages => 'Messaggi eliminati';

  @override
  String get deletedConversations => 'Conversazioni eliminate';

  @override
  String get bannedUser => 'Utente bannato';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return 'Spam pulito con successo per $username. Azioni: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'Errore nel caricamento del messaggio: $error';
  }

  @override
  String get messageNotFound => 'Messaggio non trovato';

  @override
  String get home => 'Home';

  @override
  String get notifications => 'Notifiche';

  @override
  String get forums => 'Forum';

  @override
  String get markAllForumsAsRead => 'Segnare tutti i forum come letti?';

  @override
  String get markAllForumsAsReadMessage =>
      'Questo segnerà tutti i forum e gli argomenti come letti. Questa azione non può essere annullata.';

  @override
  String get markAsRead => 'Segna come letto';

  @override
  String get content => 'Contenuto';

  @override
  String get insertImage => 'Inserisci immagine';

  @override
  String get howWouldYouLikeToInsertImage =>
      'Come vorresti inserire questa immagine?';

  @override
  String get thumbnail => 'Miniatura';

  @override
  String get fullSize => 'Dimensione piena';

  @override
  String get alignLeft => 'Allinea a sinistra';

  @override
  String get alignCenter => 'Allinea al centro';

  @override
  String get alignRight => 'Allinea a destra';

  @override
  String get pleaseEnterTitle => 'Inserisci un titolo';

  @override
  String get pleaseEnterContent => 'Inserisci del contenuto';

  @override
  String get uploading => 'Caricamento...';

  @override
  String get uploaded => 'Caricato';

  @override
  String get mentionUser => 'Menziona utente';

  @override
  String get loggingIn => 'Accesso in corso...';

  @override
  String get submittingReport => 'Invio report...';

  @override
  String get banningUser => 'Ban utente...';

  @override
  String get unbanningUser => 'Rimozione ban utente...';

  @override
  String get cleaningSpam => 'Pulizia spam...';

  @override
  String get enterSubject => 'Inserisci oggetto';

  @override
  String get typeYourMessageHere => 'Scrivi il tuo messaggio qui';

  @override
  String get writeYourMessage => 'Scrivi il tuo messaggio...';

  @override
  String get writeYourReply => 'Scrivi la tua risposta...';

  @override
  String get messageSentSuccessfully => 'Messaggio inviato con successo';

  @override
  String get replySentSuccessfully => 'Risposta inviata con successo';

  @override
  String get conversationCreatedSuccessfully =>
      'Conversazione creata con successo';

  @override
  String get conversationMarkedAsUnread =>
      'Conversazione segnata come non letta';

  @override
  String get messageMarkedAsUnread => 'Messaggio segnato come non letto';

  @override
  String get conversationClosed => 'Conversazione chiusa';

  @override
  String get conversationOpened => 'Conversazione aperta';

  @override
  String get pleaseLoginToLikeMessages =>
      'Accedi per mettere mi piace ai messaggi';

  @override
  String get loadEarlierMessages => 'Carica messaggi precedenti';

  @override
  String failedToLoadQuote(String error) {
    return 'Errore nel caricamento della citazione: \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'Errore nel caricamento del file: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Errore nel caricamento dell\'immagine: $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'Errore nell\'invio del messaggio: $error';
  }

  @override
  String failedToSendReply(String error) {
    return 'Errore nell\'invio della risposta: $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'Errore nel segnare il messaggio come non letto: $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return 'Errore nel segnare la conversazione come non letta: $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return 'Errore nella chiusura della conversazione: $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return 'Errore nell\'apertura della conversazione: $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'Errore nel saltare al messaggio: $error';
  }

  @override
  String get goToTop => 'Vai in alto';

  @override
  String get goToBottom => 'Vai in basso';

  @override
  String get replyAll => 'Rispondi a tutti';

  @override
  String get forward => 'Inoltra';

  @override
  String get noForumsFound => 'Nessun forum trovato.';

  @override
  String get pleaseSelectPrefix => 'Seleziona un prefisso';

  @override
  String get pleaseLoginToAccessContent =>
      'Accedi per accedere a questo contenuto e interagire con i post.';

  @override
  String get searchUsers => 'Cerca utenti...';

  @override
  String get writeYourTitle => 'Scrivi il tuo titolo...';

  @override
  String get writeYourContent => 'Scrivi il tuo contenuto...';

  @override
  String get selectAnOption => 'Seleziona un\'opzione';

  @override
  String get enterConversationTitle =>
      'Inserisci il titolo della conversazione';

  @override
  String enterCode(int count) {
    return 'Inserisci codice a $count cifre';
  }

  @override
  String get edit => 'Modifica';

  @override
  String get report => 'Segnala';

  @override
  String get unfollow => 'Smetti di seguire';

  @override
  String get follow => 'Segui';

  @override
  String get goToForums => 'Vai ai Forum';

  @override
  String get remove => 'Rimuovi';

  @override
  String get subject => 'Oggetto';

  @override
  String get message => 'Messaggio';

  @override
  String get titleCannotBeEmpty => 'Il titolo non può essere vuoto';

  @override
  String get conversationUpdatedSuccessfully =>
      'Conversazione aggiornata con successo';

  @override
  String get goBack => 'Indietro';

  @override
  String get privateMessagesNotAvailable =>
      'I messaggi privati non sono disponibili';

  @override
  String failedToLoadPost(String error) {
    return 'Errore nel caricamento del post: \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'Errore nel $action messaggio: $error';
  }

  @override
  String get like => 'mettere mi piace a';

  @override
  String get unlike => 'togliere mi piace a';

  @override
  String get optimizeImage => 'Ottimizza immagine';

  @override
  String get optimizeAndUpload => 'Ottimizza e carica';

  @override
  String downloading(String filename) {
    return 'Download di $filename...';
  }

  @override
  String openingShareSheet(String filename) {
    return 'Apertura foglio di condivisione per $filename';
  }

  @override
  String errorDownloading(String filename, String error) {
    return 'Errore nel download di $filename: $error';
  }

  @override
  String get enterANumber => 'Inserisci un numero';

  @override
  String get failedToNavigateToForum => 'Errore nella navigazione al forum';

  @override
  String failedToNavigateToForumName(String forumName) {
    return 'Errore nella navigazione a $forumName';
  }

  @override
  String forumNotFound(String forumName) {
    return 'Forum non trovato: $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'Forum non trovato: $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'Impossibile aprire il link: $error';
  }

  @override
  String get likePost => 'Mi piace';

  @override
  String get unlikePost => 'Non mi piace più';

  @override
  String get thankPost => 'Ringrazia post';

  @override
  String get showLikes => 'Mostra mi piace';

  @override
  String get showThanks => 'Mostra ringraziamenti';

  @override
  String get quotePost => 'Cita post';

  @override
  String get translate => 'Traduci';

  @override
  String get showOriginal => 'Mostra originale';

  @override
  String get translating => 'Traduzione in corso...';

  @override
  String get translated => 'Tradotto';

  @override
  String get translatedContent => 'Contenuto tradotto';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get translateTo => 'Traduci in:';

  @override
  String get deviceLanguage => 'Lingua del dispositivo';

  @override
  String get noPostsToTranslate => 'Nessun post da tradurre';

  @override
  String get translationFailed => 'Traduzione fallita';

  @override
  String get twoFactorAuthentication => 'Autenticazione a due fattori';

  @override
  String get authenticationCodeLabel => 'Codice di autenticazione';

  @override
  String get pleaseEnterYourAuthenticationCode =>
      'Inserisci il tuo codice di autenticazione';

  @override
  String codeMustBeDigits(int count) {
    return 'Il codice deve contenere $count cifre';
  }

  @override
  String get codeMustContainOnlyNumbers =>
      'Il codice deve contenere solo numeri';

  @override
  String get verifyButton => 'Verifica';

  @override
  String get attachments => 'Allegati';

  @override
  String get replyOptions => 'Opzioni di risposta';

  @override
  String get replyWithQuote => 'Rispondi con citazione';

  @override
  String fileSavedToDownloads(String filename) {
    return 'File salvato in Download: $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'File salvato in Documenti: $filename';
  }
}

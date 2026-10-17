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
  String get cancel => 'Annulla';

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
  String get noUnreadTopics => 'Nessun argomento non letto';

  @override
  String get thereAreNoUnreadTopics =>
      'Non ci sono argomenti non letti. Torna più tardi per nuove discussioni.';

  @override
  String get youAreAllCaughtUp => 'Sei aggiornato!';

  @override
  String get noSubscribedTopics => 'Nessun argomento sottoscritto';

  @override
  String get noSubscribedTopicsMessage =>
      'Non ti sei iscritto ad alcun argomento. Tocca il pulsante stella su un argomento per iscriverti e ricevere notifiche per nuovi aggiornamenti.';

  @override
  String get noParticipatedTopics => 'Nessun argomento partecipato';

  @override
  String get topicsYouParticipatedIn =>
      'Gli argomenti a cui hai partecipato verranno mostrati qui.';

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
  String get postCanBeRestoredLater =>
      'Il post può essere ripristinato in seguito';

  @override
  String get postWillBePermanentlyDeleted =>
      'Il post verrà eliminato permanentemente';

  @override
  String get enterReasonForDeletingPost =>
      'Inserisci il motivo per eliminare questo post';

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
  String get unbanUser => 'Sbanna Utente';

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
  String get tryAgain => 'Riprova';

  @override
  String get memberSince => 'Membro Dal';

  @override
  String get lastActivity => 'Ultima Attività';

  @override
  String get likesReceived => 'Mi Piace Ricevuti';

  @override
  String get likesGiven => 'Mi Piace Dati';

  @override
  String get failedToSaveMessage => 'Impossibile salvare il messaggio';

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
  String get moreOptions => 'Altre opzioni';

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
  String get dismiss => 'Chiudi';

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
  String get enterUsernameToSearch => 'Inserisci nome utente per cercare...';

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
  String get handleThreads => 'Gestisci Thread';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Sposta o elimina thread in base alle impostazioni dell\'amministratore';

  @override
  String get deleteMessages => 'Elimina Messaggi';

  @override
  String get deleteConversations => 'Elimina Conversazioni';

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
  String get enterKeywordsToSearchTopics =>
      'Inserisci parole chiave per cercare argomenti...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Compila tutti i campi obbligatori';

  @override
  String get undelete => 'Ripristina';

  @override
  String get signInToViewUnreadTopics =>
      'Accedi per visualizzare gli argomenti non letti';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Devi accedere per visualizzare i tuoi argomenti non letti';

  @override
  String get signInToViewSubscribedTopics =>
      'Accedi per visualizzare gli argomenti sottoscritti';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Devi accedere per visualizzare i tuoi argomenti sottoscritti';

  @override
  String get signInToViewParticipatedTopics =>
      'Accedi per visualizzare gli argomenti partecipati';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Devi accedere per visualizzare gli argomenti a cui hai partecipato';

  @override
  String get signInToViewLatestTopics =>
      'Accedi per visualizzare gli argomenti recenti';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Devi accedere per visualizzare gli argomenti recenti';

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
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mi piace',
      one: '$count Mi piace',
    );
    return '$_temp0';
  }

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reazioni',
      one: '$count reazione',
    );
    return '$_temp0';
  }

  @override
  String get showWhoReacted => 'Tocca per vedere chi ha reagito.';

  @override
  String get react => 'Reagisci';

  @override
  String get changeYourReaction => 'Cambia la tua reazione';

  @override
  String get reactionsAll => 'Tutte';

  @override
  String get reactionYou => 'Tu';

  @override
  String reactionFilterSemantics(String reaction, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$reaction, $count persone',
      one: '$reaction, $count persona',
    );
    return '$_temp0';
  }

  @override
  String viewProfileOfUser(String username) {
    return 'Vedi il profilo di $username';
  }

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
  String get language => 'Lingua';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String get followSystemLanguage => 'Segui la lingua di sistema';

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
  String get spamCleaner => 'Pulizia Spam';

  @override
  String get unableToLoadProfile => 'Impossibile caricare il profilo';

  @override
  String get banned => 'BANNITO';

  @override
  String get sendMessage => 'Invia messaggio';

  @override
  String get showMore => 'Mostra di più';

  @override
  String get reportUser => 'Segnala utente';

  @override
  String get submitReport => 'Invia segnalazione';

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
  String get softDelete => 'Eliminazione soft';

  @override
  String get topicCanBeRestoredLater =>
      'L\'argomento può essere ripristinato in seguito';

  @override
  String get hardDelete => 'Eliminazione permanente';

  @override
  String get topicWillBePermanentlyDeleted =>
      'L\'argomento sarà eliminato permanentemente';

  @override
  String get reasonForDeletion => 'Motivo dell\'eliminazione';

  @override
  String get enterReasonForDeletingTopic =>
      'Inserisci il motivo per eliminare questo argomento';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Inserisci un motivo per l\'eliminazione';

  @override
  String get pleaseSelectEndDate => 'Seleziona una data di fine';

  @override
  String get banUser => 'Banna utente';

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
  String get cleanSpam => 'Pulisci spam';

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
  String get signInToViewMessages => 'Accedi per visualizzare i messaggi';

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
  String get failedToSaveConversation =>
      'Errore nel salvataggio della conversazione';

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
  String get showLikes => 'Mostra mi piace';

  @override
  String get quotePost => 'Cita post';

  @override
  String get attachFile => 'Allega File';

  @override
  String get uploadImage => 'Carica Immagine';

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

  @override
  String get discardPostQuestion => 'Vuoi eliminare il tuo messaggio?';

  @override
  String get discardChangesQuestion => 'Vuoi annullare le modifiche?';

  @override
  String get discard => 'Scarta';

  @override
  String get discardChanges => 'Annulla modifiche';

  @override
  String get notificationsTab => 'Avvisi';

  @override
  String get postAwaitingApproval =>
      'Il tuo messaggio apparirà quando un moderatore lo avrà approvato.';

  @override
  String get reactionHoldHint => 'Tieni premuto per altre reazioni';

  @override
  String get turnOnNotifications => 'Attiva le notifiche';

  @override
  String get notNow => 'Non ora';

  @override
  String neverMissAReplyOn(Object forumName) {
    return 'Non perdere nessuna risposta su $forumName';
  }

  @override
  String get notificationPreviewNow => 'ora';

  @override
  String get notificationPreviewEarlier => '5 min fa';

  @override
  String get notificationPreviewReply =>
      'Jane ti ha risposto: Benvenuto! Siamo felici che ci hai trovati.';

  @override
  String get notificationPreviewMessage =>
      'Sam ti ha inviato un messaggio: Vieni venerdì?';

  @override
  String get notificationsAreTurnedOffForThisApp =>
      'Le notifiche sono disattivate per questa app';

  @override
  String get deviceWillNotShowAlertsUntilAllowedInSettings =>
      'Il dispositivo non mostrerà avvisi finché non consenti le notifiche nelle Impostazioni.';

  @override
  String get openSettings => 'Apri impostazioni';

  @override
  String get notificationsPitchForum =>
      'Risposte, menzioni e messaggi diretti sulla schermata di blocco, appena arrivano.';

  @override
  String get viewProfile => 'Vedi profilo';

  @override
  String get settings => 'Impostazioni';

  @override
  String get signOut => 'Esci';

  @override
  String get changeEmail => 'Cambia e-mail';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get save => 'Salva';

  @override
  String get currentPassword => 'Password attuale';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get confirmNewPassword => 'Conferma la nuova password';

  @override
  String get newEmailAddress => 'Nuovo indirizzo email';

  @override
  String get emailChanged => 'Indirizzo email modificato';

  @override
  String get emailChangeConfirm =>
      'Controlla la posta: il nuovo indirizzo sarà attivo quando lo confermerai.';

  @override
  String get passwordChanged => 'Password modificata';

  @override
  String get account => 'Account';

  @override
  String get pleaseEnterEmail => 'Inserisci la tua email';

  @override
  String get pleaseEnterValidEmail => 'Inserisci un\'email valida';

  @override
  String get passwordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get connectionErrorTitle => 'Errore di connessione';

  @override
  String get authenticationErrorTitle => 'Errore di autenticazione';

  @override
  String get permissionErrorTitle => 'Errore di autorizzazione';

  @override
  String get errorNoConnection =>
      'Nessuna connessione a internet. Controlla le impostazioni di rete.';

  @override
  String get errorTimeout => 'La richiesta è scaduta. Riprova.';

  @override
  String get errorServer => 'Errore del server. Riprova più tardi.';

  @override
  String get errorNetwork => 'Errore di rete. Riprova.';

  @override
  String get errorInvalidCredentials => 'Nome utente o password non validi.';

  @override
  String get errorSessionExpired => 'La sessione è scaduta. Accedi di nuovo.';

  @override
  String get errorAccountLocked =>
      'Il tuo account è stato bloccato. Contatta l\'assistenza.';

  @override
  String get errorAuthFailed => 'Autenticazione non riuscita. Riprova.';

  @override
  String get errorForumNotFound => 'Forum non trovato.';

  @override
  String get errorForumAccessDenied =>
      'Non hai il permesso di accedere a questo forum.';

  @override
  String get errorForumUnavailable =>
      'Il forum non è al momento disponibile. Riprova più tardi.';

  @override
  String get errorForumGeneric =>
      'Si è verificato un errore nel forum. Riprova.';

  @override
  String get errorDataNotFound => 'Dati richiesti non trovati.';

  @override
  String get errorDataCorrupted =>
      'I dati sembrano danneggiati. Aggiorna la pagina.';

  @override
  String get errorCache => 'Impossibile caricare i dati memorizzati. Riprova.';

  @override
  String get errorInvalidInput => 'Uno dei valori inseriti non è valido.';

  @override
  String get errorRequiredField => 'Compila tutti i campi obbligatori.';

  @override
  String get errorPermissionDenied => 'Non hai il permesso di farlo.';

  @override
  String errorFeatureNotAvailable(String feature) {
    return '$feature non è disponibile su questo forum.';
  }

  @override
  String get errorStorageFull =>
      'Lo spazio di archiviazione è pieno. Libera un po’ di spazio.';

  @override
  String get errorStorageAccessDenied =>
      'Accesso all\'archiviazione negato. Controlla i permessi dell\'app.';

  @override
  String get loginInfo => 'Informazioni di accesso';

  @override
  String get loginFailed => 'Accesso non riuscito';

  @override
  String get topicAnnouncement => 'Annuncio';

  @override
  String get topicPinned => 'In evidenza';

  @override
  String get topicLocked => 'Chiuso';

  @override
  String get topicPoll => 'Sondaggio';

  @override
  String get deletedBadge => 'ELIMINATO';

  @override
  String get protectedBadge => 'Protetto';

  @override
  String get lockTopic => 'Chiudi argomento';

  @override
  String get unlockTopic => 'Riapri argomento';

  @override
  String get lockTopicConfirm =>
      'Vuoi davvero chiudere questo argomento? Gli altri utenti non potranno rispondere né interagire.';

  @override
  String get unlockTopicConfirm =>
      'Vuoi davvero riaprire questo argomento? Gli altri utenti potranno di nuovo rispondere e interagire.';

  @override
  String get stickTopic => 'Metti in evidenza';

  @override
  String get unstickTopic => 'Rimuovi dall’evidenza';

  @override
  String get stickTopicConfirm =>
      'Vuoi davvero mettere in evidenza questo argomento? Apparirà in cima al forum per tutti gli utenti.';

  @override
  String get unstickTopicConfirm =>
      'Vuoi davvero rimuovere questo argomento dall’evidenza? Non apparirà più in cima al forum.';

  @override
  String get undeleteTopic => 'Ripristina argomento';

  @override
  String get undeleteTopicConfirm =>
      'Vuoi davvero ripristinare questo argomento? Sarà di nuovo visibile agli altri utenti.';

  @override
  String get additionalInformation => 'Informazioni aggiuntive';

  @override
  String get dateOfBirth => 'Data di nascita';

  @override
  String get selectDateOfBirth => 'Seleziona la data di nascita';

  @override
  String minimumAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Età minima: $age anni',
      one: 'Età minima: $age anno',
    );
    return '$_temp0';
  }

  @override
  String get locationIsRequired => 'La località è obbligatoria';

  @override
  String get receiveSiteMailings => 'Ricevi le email del sito';

  @override
  String iAcceptTheDocument(String document) {
    return 'Accetto i $document';
  }

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get imageExceedsUploadLimits =>
      'Questa immagine supera i limiti di caricamento e deve essere ottimizzata:';

  @override
  String get originalSize => 'Dimensione originale';

  @override
  String get originalDimensions => 'Dimensioni originali';

  @override
  String get optimizationsToBeApplied => 'Ottimizzazioni da applicare:';

  @override
  String get resizeImage => 'Ridimensiona';

  @override
  String get convertFormat => 'Converti formato';

  @override
  String get smallerFileSize => 'file più piccolo';

  @override
  String get formatNotSupported => 'formato non supportato';

  @override
  String get convertToJpgReason =>
      'Converti in JPG (formato non supportato o per ridurre le dimensioni)';

  @override
  String get compressImage => 'Comprimi';

  @override
  String compressQuality(int quality) {
    return 'Qualità: $quality% per rispettare il limite di dimensione';
  }

  @override
  String get estimatedFinalSize => 'Dimensione finale stimata';

  @override
  String sizeReduction(String percent) {
    return 'Riduzione: $percent%';
  }

  @override
  String get pleaseLoginToCreateTopic => 'Accedi per creare un nuovo argomento';

  @override
  String get pleaseLoginToSubscribeForums => 'Accedi per iscriverti ai forum';

  @override
  String get pleaseLoginToUnsubscribeForums =>
      'Accedi per annullare l\'iscrizione ai forum';

  @override
  String errorLoadingContent(String error) {
    return 'Errore nel caricamento dei contenuti: $error';
  }

  @override
  String get noPermissionToViewSubforumTopics =>
      'Non hai il permesso di vedere gli argomenti di questo sottoforum.';

  @override
  String get noDiscussionsYet => 'Ancora nessuna discussione.';

  @override
  String get unableToLoadForums => 'Impossibile caricare i forum';

  @override
  String get noForumsAvailable => 'Nessun forum disponibile';

  @override
  String get noForumsToDisplay =>
      'Non ci sono forum da mostrare. Potrebbe dipendere dai permessi o dalla struttura del forum.';

  @override
  String get subscribedForums => 'Forum seguiti';

  @override
  String get allForumTopicsMarkedRead =>
      'Tutti gli argomenti del forum sono stati segnati come letti';

  @override
  String postsCountFormatted(String count) {
    return '$count messaggi';
  }

  @override
  String get jumpToPost => 'Vai al messaggio';

  @override
  String get jump => 'Vai';

  @override
  String get endOfDiscussion => 'Fine della discussione';

  @override
  String refreshFailed(String error) {
    return 'Aggiornamento non riuscito: $error';
  }

  @override
  String get topicDeletedHidden =>
      'Questo argomento è eliminato e nascosto agli altri utenti';

  @override
  String get topicClosedNoReplies =>
      'Questo argomento è chiuso e non accetta più risposte';

  @override
  String get youAreSubscribedToTopic => 'Sei iscritto a questo argomento';

  @override
  String get refreshing => 'Aggiornamento...';

  @override
  String get unableToLoadForumsTryAgain =>
      'Impossibile caricare i forum. Riprova.';

  @override
  String get noPostableForums => 'Non ci sono forum in cui puoi pubblicare.';

  @override
  String get changeForumQuestion => 'Cambiare forum?';

  @override
  String get changeForumRemovesAttachments =>
      'Cambiando forum verranno rimossi gli allegati caricati, perché sono legati al forum selezionato.';

  @override
  String get changeForum => 'Cambia forum';

  @override
  String get chooseForumBeforePosting => 'Scegli un forum prima di pubblicare';

  @override
  String get accountCannotUploadAttachments =>
      'Il tuo account non può caricare allegati su questo sito.';

  @override
  String get forumNoAttachments => 'Questo forum non consente allegati.';

  @override
  String get forumNoAttachmentsChooseAnother =>
      'Questo forum non consente allegati. Scegli un altro forum per caricare i file condivisi.';

  @override
  String get forumNoAttachmentsSharedPending =>
      'Questo forum non consente allegati. I file condivisi resteranno in attesa finché non scegli un altro forum.';

  @override
  String get tapToChangeForum => 'Tocca per cambiare forum';

  @override
  String get chooseWhichForum => 'Scegli in quale forum pubblicare';

  @override
  String get selectAForum => 'Seleziona un forum';

  @override
  String get unableToLoadForumsNow =>
      'Impossibile caricare i forum in questo momento.';

  @override
  String get pickForumBeforeUploading =>
      'Scegli un forum prima di caricare allegati o pubblicare.';

  @override
  String get uploadingSharedFiles => 'Caricamento dei file condivisi...';

  @override
  String get selectForum => 'Seleziona forum';

  @override
  String get noForumsMatchSearch => 'Nessun forum corrisponde alla ricerca.';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get closeConversationConfirm =>
      'Vuoi davvero chiudere questa conversazione? Non sarà più possibile inviare risposte.';

  @override
  String get openConversationConfirm =>
      'Vuoi davvero riaprire questa conversazione? Sarà di nuovo possibile inviare risposte.';

  @override
  String get leaveConversationConfirm =>
      'Vuoi davvero lasciare questa conversazione? Verrà nascosta dalla tua posta in arrivo.';

  @override
  String get close => 'Chiudi';

  @override
  String get open => 'Apri';

  @override
  String get leave => 'Lascia';

  @override
  String errorLoadingConversation(String error) {
    return 'Errore nel caricamento della conversazione: $error';
  }

  @override
  String get conversationNotFound => 'Conversazione non trovata';

  @override
  String get conversationClosedNoReplies =>
      'Questa conversazione è chiusa e non accetta più risposte';

  @override
  String get noMessagesFound => 'Nessun messaggio trovato';

  @override
  String get endOfConversation => 'Fine della conversazione';

  @override
  String get jumpToMessage => 'Vai al messaggio';

  @override
  String get jumpToFirstMessage => 'Vai al primo messaggio';

  @override
  String get jumpToLastMessage => 'Vai all\'ultimo messaggio';

  @override
  String messagePositionOf(int position, int total) {
    return 'Messaggio $position di $total';
  }

  @override
  String get tapToJumpToMessage => 'Tocca per andare a un messaggio specifico';

  @override
  String failedToReact(String error) {
    return 'Impossibile reagire: $error';
  }

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partecipanti',
      one: '$count partecipante',
    );
    return '$_temp0';
  }

  @override
  String get noImagesToDisplay => 'Nessuna immagine da mostrare.';

  @override
  String get pleaseLoginToViewAttachment => 'Accedi per vedere questo allegato';

  @override
  String get inbox => 'Posta in arrivo';

  @override
  String get sent => 'Inviati';

  @override
  String errorLoadingMessages(String error) {
    return 'Errore nel caricamento dei messaggi: $error';
  }

  @override
  String get noInboxMessages => 'Nessun messaggio in arrivo';

  @override
  String get noSentMessages => 'Nessun messaggio inviato';

  @override
  String get unknownDate => 'Data sconosciuta';

  @override
  String get searchForTopics => 'Cerca argomenti';

  @override
  String get noTopicsFound => 'Nessun argomento trovato';

  @override
  String get noPostsFound => 'Nessun messaggio trovato';

  @override
  String get trySearchingDifferentKeywords => 'Prova con parole chiave diverse';

  @override
  String errorLoadingSettings(String error) {
    return 'Errore nel caricamento delle impostazioni: $error';
  }

  @override
  String get pleaseEnterValidNumber => 'Inserisci un numero valido';

  @override
  String valueMustBeAtLeast(String min) {
    return 'Il valore deve essere almeno $min';
  }

  @override
  String valueMustBeAtMost(String max) {
    return 'Il valore deve essere al massimo $max';
  }

  @override
  String maximumLengthCharacters(int max) {
    return 'La lunghezza massima è di $max caratteri';
  }

  @override
  String get invalidFormat => 'Formato non valido';

  @override
  String get shareToForumCopilot => 'Condividi su Forum Copilot';

  @override
  String get noSavedForumAccounts => 'Nessun account del forum salvato.';

  @override
  String get addForumAccountFirst =>
      'Aggiungi prima un account del forum in Forum Copilot, poi riprova a condividere.';

  @override
  String filesReadyToAttach(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file pronti da allegare',
      one: '$count file pronto da allegare',
    );
    return '$_temp0';
  }

  @override
  String get sharedTextWillBePrefilled =>
      'Il testo condiviso verrà precompilato';

  @override
  String errorSearchingForums(String error) {
    return 'Errore nella ricerca dei forum: $error';
  }

  @override
  String failedToLoadUserInfo(String error) {
    return 'Impossibile caricare le informazioni dell\'utente: $error';
  }

  @override
  String areYouSureUnban(String username) {
    return 'Vuoi davvero rimuovere il ban a $username?';
  }

  @override
  String get deletePostsProfilePostsComments =>
      'Elimina messaggi, messaggi del profilo e commenti';

  @override
  String areYouSureSpamClean(String username) {
    return 'Vuoi davvero ripulire lo spam di $username?';
  }

  @override
  String successfullyCleanedSpamFor(String username) {
    return 'Lo spam di $username è stato ripulito';
  }

  @override
  String get failedToCleanSpam => 'Impossibile ripulire lo spam';

  @override
  String imagesCount(int count) {
    return 'Immagini ($count)';
  }

  @override
  String get pleaseLoginToViewProfiles =>
      'Accedi per vedere i profili degli utenti.';

  @override
  String get tapToOpen => 'Tocca per aprire';

  @override
  String get imageNotAvailable => 'Immagine non disponibile';

  @override
  String get tapToViewFullSizeImage =>
      'Tocca per vedere l\'immagine a grandezza intera';

  @override
  String get loadingImage => 'Caricamento immagine...';

  @override
  String loadingImageFrom(String host) {
    return 'Caricamento immagine da $host';
  }

  @override
  String get tapToReveal => '(tocca per mostrare)';

  @override
  String get inlineAttachments => 'Allegati incorporati';

  @override
  String get thisFieldIsRequired => 'Questo campo è obbligatorio';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'Inserisci un numero di telefono valido';

  @override
  String get pleaseEnterValidUrl => 'Inserisci un URL valido';

  @override
  String get permissionDeniedToSaveImage =>
      'Permesso negato per salvare l\'immagine';

  @override
  String get postNotFound => 'Messaggio non trovato.';

  @override
  String get failedToUploadFileTryAgain =>
      'Impossibile caricare il file. Riprova.';

  @override
  String get failedToPickFile => 'Impossibile selezionare il file';

  @override
  String onlyMoreAttachmentsAllowed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Sono consentiti solo altri $count allegati. Verranno usate le prime $count immagini.',
      one: 'È consentito solo 1 altro allegato. Verrà usata la prima immagine.',
    );
    return '$_temp0';
  }

  @override
  String get attachmentLimitReachedSkipping =>
      'Limite di allegati raggiunto. Le immagini rimanenti vengono saltate.';

  @override
  String get imageValidationFailed => 'Verifica dell\'immagine non riuscita';

  @override
  String get imageUploadFailed => 'Impossibile caricare l\'immagine';

  @override
  String get failedToUploadImageTryAgain =>
      'Impossibile caricare l\'immagine. Riprova.';

  @override
  String get failedToPickImage => 'Impossibile selezionare l\'immagine';

  @override
  String get prefix => 'Prefisso';

  @override
  String get failedToLoadPrefixes => 'Impossibile caricare i prefissi';

  @override
  String get attachFileHint => 'Allega un file a questo messaggio';

  @override
  String get uploadImageHint => 'Carica un’immagine in questo messaggio';

  @override
  String get openFormattingOptions => 'Apri le opzioni di formattazione';

  @override
  String get failedToPostReply =>
      'Impossibile pubblicare la risposta. Riprova.';

  @override
  String get failedToUpdatePost =>
      'Impossibile aggiornare il messaggio. Riprova.';

  @override
  String get postDeletedSuccessfully => 'Messaggio eliminato';

  @override
  String failedToDeletePost(String error) {
    return 'Impossibile eliminare il messaggio: $error';
  }

  @override
  String get noPermissionToUploadAvatars =>
      'Non hai il permesso di caricare avatar';

  @override
  String get avatarUploadedSuccessfully => 'Avatar caricato';

  @override
  String get unknownTopic => 'Argomento sconosciuto';

  @override
  String get connectionTimeoutTitle => 'Connessione scaduta';

  @override
  String connectionTimedOutTo(String siteName) {
    return 'La connessione a $siteName è scaduta. Controlla la connessione a internet e riprova.';
  }

  @override
  String failedToConnectCheckPlugin(String siteName) {
    return 'Impossibile connettersi a $siteName. Verifica che il forum sia disponibile e che il plugin sia installato.';
  }

  @override
  String get voteFailedTryAgain => 'Voto non riuscito. Riprova.';

  @override
  String get noUserSpecified => 'Nessun utente specificato';

  @override
  String get failedToLoadRecentPosts =>
      'Impossibile caricare i messaggi recenti';

  @override
  String failedToLoadPreview(String error) {
    return 'Impossibile caricare l\'anteprima: $error';
  }

  @override
  String thanksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ringraziato da $count persone',
      one: 'Ringraziato da $count persona',
    );
    return '$_temp0';
  }

  @override
  String get thankedBy => 'Ringraziato da';

  @override
  String maximumAttachmentsAllowed(int count) {
    return 'Massimo $count allegato/i consentito/i';
  }

  @override
  String get toLabel => 'A';

  @override
  String get closeConversation => 'Chiudi conversazione';

  @override
  String get openConversation => 'Apri conversazione';

  @override
  String get loginSucceeded => 'Accesso riuscito';

  @override
  String get verificationErrorTryAgain =>
      'Si è verificato un errore durante la verifica. Riprova.';

  @override
  String get passkeyChallengeFailed =>
      'Impossibile avviare l\'accesso con passkey.';

  @override
  String get passkeyNotSetUp =>
      'Questo forum non è ancora configurato per l\'accesso con passkey in questa app. Accedi con nome utente e password.';

  @override
  String get noPasskeyForForum =>
      'Nessuna passkey trovata per questo forum. Accedi con la password oppure crea prima una passkey sul sito del forum.';

  @override
  String get pushNotificationsNotReady =>
      'Le notifiche push non sono ancora pronte';

  @override
  String pushEnabledFor(String siteName) {
    return 'Notifiche push attivate per $siteName';
  }

  @override
  String get failedToEnablePush => 'Impossibile attivare le notifiche push';

  @override
  String get failedToRegisterPush =>
      'Impossibile registrarsi alle notifiche push';

  @override
  String translatedFromTo(String source, String target) {
    return 'Tradotto da $source a $target';
  }

  @override
  String get unableToOpenNotification => 'Impossibile aprire la notifica';

  @override
  String get notificationMissingInfo =>
      'In questa notifica mancano delle informazioni.';

  @override
  String get couldNotOpenForum => 'Impossibile aprire il forum.';

  @override
  String get notificationChannelName => 'Notifiche di Forum Copilot';

  @override
  String get notificationChannelDescription =>
      'Notifiche dell\'app Forum Copilot';

  @override
  String fileTypeNotAllowed(String extension, String allowed) {
    return 'Il tipo di file .$extension non è consentito. Tipi consentiti: $allowed';
  }

  @override
  String fileSizeExceedsMaximum(String size, String max) {
    return 'La dimensione del file ($size) supera il massimo di $max';
  }

  @override
  String get fileTypeAudio => 'Audio';

  @override
  String get fileTypeText => 'Testo';

  @override
  String get fileTypeArchive => 'Archivio';

  @override
  String get fileTypeFile => 'File';

  @override
  String get imageFileNotFound =>
      'File immagine non trovato. Potrebbe essere stato spostato o eliminato.';

  @override
  String get imagePermissionDenied =>
      'Permesso negato. Impossibile leggere il file dell\'immagine.';

  @override
  String get imageInsufficientSpace =>
      'Spazio su disco insufficiente per ottimizzare l\'immagine.';

  @override
  String cannotAccessImageFile(String error) {
    return 'Impossibile accedere al file dell\'immagine: $error';
  }

  @override
  String get imageFormatUnsupported =>
      'Il formato dell\'immagine è danneggiato o non supportato. Prova con un\'altra immagine.';

  @override
  String get failedToResizeImage =>
      'Impossibile ridimensionare l\'immagine. Potrebbe essere danneggiata o in un formato non supportato.';

  @override
  String get failedToConvertImageToJpg =>
      'Impossibile convertire l\'immagine in JPG. Potrebbe essere danneggiata.';

  @override
  String get failedToCompressImage =>
      'Impossibile comprimere l\'immagine. Lo spazio potrebbe essere insufficiente o l\'immagine danneggiata.';

  @override
  String get cannotDecodeImage =>
      'Impossibile decodificare l\'immagine. Il file potrebbe essere danneggiato o in un formato non supportato.';

  @override
  String get cannotReadImageFile =>
      'Impossibile leggere il file dell\'immagine. Potrebbe essere stato spostato o eliminato.';

  @override
  String failedToOptimizeImage(String error) {
    return 'Impossibile ottimizzare l\'immagine: $error';
  }

  @override
  String emailCopiedToClipboard(String email) {
    return 'Email copiata negli appunti: $email';
  }

  @override
  String couldNotOpenEmail(String email) {
    return 'Impossibile aprire l email: $email';
  }

  @override
  String get editPost => 'Modifica post';

  @override
  String get thisTopicIsPinnedToTopOfForum =>
      'Questo argomento e fissato in alto nel forum';

  @override
  String get editConversation => 'Modifica conversazione';

  @override
  String get failedToLoadConversation =>
      'Impossibile caricare la conversazione';

  @override
  String get cannotEditConversation =>
      'Impossibile modificare questa conversazione';

  @override
  String get titleLabel => 'Titolo';

  @override
  String get options => 'Opzioni';

  @override
  String get openInvite => 'Invito aperto';

  @override
  String get allowAnyParticipantToInviteOthers =>
      'Consenti a qualsiasi partecipante di invitare altri';

  @override
  String get conversationOpen => 'Conversazione aperta';

  @override
  String failedToCreateConversation(String error) {
    return 'Impossibile creare la conversazione: $error';
  }

  @override
  String get lockConversation => 'Blocca conversazione';

  @override
  String get createConversationAsClosed =>
      'Crea conversazione come chiusa (nessuna risposta consentita)';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountDescription =>
      'Rimuovi il tuo account da questo forum.';

  @override
  String get deleteAccountContactForumMessage =>
      'Il tuo account è gestito dal forum. Contatta direttamente il forum per la rimozione dell\'account. Usa il pulsante “Contattaci” in fondo alla home del forum.';

  @override
  String get forumUrlUnavailable => 'L\'URL del forum non è disponibile.';

  @override
  String get couldNotOpenForumUrl => 'Impossibile aprire l\'URL del forum.';

  @override
  String get noActionUrlAvailableForThisNotificationType =>
      'Nessun URL di azione disponibile per questo tipo di notifica.';

  @override
  String get signInToViewNotifications =>
      'Accedi per visualizzare le notifiche';

  @override
  String get youNeedToBeSignedInToViewYourNotifications =>
      'Devi effettuare l\'accesso per visualizzare le tue notifiche.';

  @override
  String get errorLoadingNotifications =>
      'Errore durante il caricamento delle notifiche';

  @override
  String get pullDownToRefresh => 'Scorri verso il basso per aggiornare';

  @override
  String get youHaveNoNewNotificationsCheckBackLater =>
      'Non hai nuove notifiche. Ricontrolla più tardi.';

  @override
  String get signInToViewProfile => 'Accedi per visualizzare il profilo';

  @override
  String get youNeedToBeSignedInToViewYourProfile =>
      'Devi effettuare l\'accesso per visualizzare il tuo profilo.';

  @override
  String get emailLabel => 'Email';

  @override
  String get confirmPasswordLabel => 'Conferma password';

  @override
  String get protectedForum => 'Forum protetto';

  @override
  String forumIsPasswordProtected(String forumName) {
    return '$forumName e protetto da password.';
  }

  @override
  String get enterButton => 'Entra';

  @override
  String get recentPosts => 'Post recenti';

  @override
  String passkeyNotAvailableInForum(int code) {
    return 'La passkey non è attualmente disponibile in questo forum (codice: $code)';
  }

  @override
  String get initializingForum => 'Avvio del forum…';

  @override
  String get retryConnection => 'Riprova la connessione';

  @override
  String get pleaseConfirmPassword => 'Conferma la tua password';

  @override
  String get pleaseEnterTheForumPassword => 'Inserisci la password del forum';

  @override
  String get editYourPost => 'Modifica il tuo post...';

  @override
  String get topicIdIsMissingCannotNavigateToThePost =>
      'ID della discussione mancante. Impossibile aprire il post.';

  @override
  String get conversationIsOpenForReplies =>
      'La conversazione è aperta alle risposte';

  @override
  String get conversationIsClosedNoRepliesAllowed =>
      'La conversazione è chiusa (risposte non consentite)';

  @override
  String get pleaseEnterAUsername => 'Inserisci un nome utente';

  @override
  String usernameMinLength(int count) {
    return 'Il nome utente deve avere almeno $count caratteri';
  }

  @override
  String get pleaseEnterAPassword => 'Inserisci una password';

  @override
  String passwordMinLength(int count) {
    return 'La password deve avere almeno $count caratteri';
  }

  @override
  String get writeYourTopicTitle => 'Scrivi il titolo dell’argomento...';

  @override
  String get writeYourTopicContent => 'Scrivi il contenuto dell’argomento...';

  @override
  String pushDisabledFor(String siteName) {
    return 'Notifiche push disattivate per $siteName';
  }

  @override
  String get failedToDisablePush => 'Impossibile disattivare le notifiche push';

  @override
  String get thisForum => 'questo forum';

  @override
  String get openFullEditor => 'Editor completo';

  @override
  String statsMembers(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString membri',
      one: '$countString membro',
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
      other: '$countString discussioni',
      one: '$countString discussione',
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
      other: '$countString messaggi',
      one: '$countString messaggio',
    );
    return '$_temp0';
  }

  @override
  String searchForumName(String forumName) {
    return 'Cerca in $forumName';
  }

  @override
  String get copyLink => 'Copia link';

  @override
  String get linkCopied => 'Link copiato';

  @override
  String sharedFilesAttached(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file condivisi allegati.',
      one: '1 file condiviso allegato.',
    );
    return '$_temp0';
  }

  @override
  String sharedFilesPartlyAttached(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file allegati. Non allegati: $names',
      one: '1 file allegato. Non allegati: $names',
    );
    return '$_temp0';
  }

  @override
  String get notificationChannelMessages => 'Messaggi';

  @override
  String get notificationChannelMessagesDescription =>
      'Nuovi messaggi diretti e le risposte';

  @override
  String get notificationChannelReplies => 'Risposte e menzioni';

  @override
  String get notificationChannelRepliesDescription =>
      'Risposte nelle discussioni che segui, citazioni e menzioni';

  @override
  String get notificationChannelReactions => 'Mi piace e reazioni';

  @override
  String get notificationChannelReactionsDescription =>
      'Mi piace e reazioni ai tuoi messaggi';

  @override
  String get notificationChannelOther => 'Altre notifiche';

  @override
  String get notificationChannelOtherDescription =>
      'Follower, trofei e altri avvisi del forum';

  @override
  String get deleteAccountConfirmTitle => 'Eliminare il tuo account?';

  @override
  String deleteAccountConfirmMessage(String forumName) {
    return 'Il tuo account su $forumName verrà eliminato, con profilo e impostazioni. I tuoi messaggi restano, con il tuo nome. Non si può annullare.';
  }

  @override
  String get deleteAccountNoPassword =>
      'Nessuna password? Conferma con il nome utente';

  @override
  String get deleteAccountUsePassword => 'Conferma con la password';

  @override
  String get accountDeleted => 'Il tuo account è stato eliminato.';
}

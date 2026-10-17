// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Forum App';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get signInWithPasskey => 'Sign in with Passkey';

  @override
  String get usePasskey => 'Use Passkey';

  @override
  String get passkeyContinuePrompt => 'Use your passkey to continue';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get pleaseEnterUsername => 'Veuillez entrer votre nom d\'utilisateur';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String credentialsSentToDomain(String domain) {
    return 'Votre nom d\'utilisateur et mot de passe seront envoyés à $domain';
  }

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get logIn => 'Se connecter';

  @override
  String get continueButton => 'Continuer';

  @override
  String get registrationNotAvailable => 'Inscription non disponible';

  @override
  String get registrationNotAvailableMessage =>
      'L\'inscription n\'est actuellement pas disponible. Le forum peut être fermé ou l\'inscription peut être désactivée.';

  @override
  String get webRegistrationRequired => 'Inscription web requise';

  @override
  String get webRegistrationRequiredMessage =>
      'Ce forum nécessite une inscription via le navigateur web. Veuillez cliquer sur le bouton ci-dessous pour ouvrir la page d\'inscription.';

  @override
  String get openRegistrationPage => 'Ouvrir la page d\'inscription';

  @override
  String get loadingAdditionalFields =>
      'Chargement des champs supplémentaires...';

  @override
  String get pleaseSelectDateOfBirth =>
      'Veuillez sélectionner votre date de naissance';

  @override
  String get pleaseEnterLocation => 'Veuillez entrer votre localisation';

  @override
  String get pleaseIndicateEmailPreference =>
      'Veuillez indiquer votre préférence d\'e-mail';

  @override
  String get pleaseFillAllRequiredFields =>
      'Veuillez remplir tous les champs obligatoires';

  @override
  String get pleaseAcceptTermsOfService =>
      'Veuillez accepter les Conditions d\'utilisation';

  @override
  String get pleaseAcceptPrivacyPolicy =>
      'Veuillez accepter la Politique de confidentialité';

  @override
  String get registrationError => 'Erreur d\'inscription';

  @override
  String get registrationFailed =>
      'L\'inscription a échoué. Veuillez vérifier vos informations.';

  @override
  String get registrationFailedTryAgain =>
      'L\'inscription a échoué. Veuillez réessayer.';

  @override
  String get registrationInfo => 'Informations d\'inscription';

  @override
  String get openWebsite => 'Ouvrir le site web';

  @override
  String couldNotOpenForumWebsite(String url) {
    return 'Impossible d\'ouvrir le site web du forum. Veuillez essayer de visiter : $url';
  }

  @override
  String get registrationSuccessfulEmailConfirm =>
      'Inscription réussie ! Veuillez vérifier votre e-mail pour confirmer votre compte avant de vous connecter.';

  @override
  String get registrationSuccessfulPendingApproval =>
      'Inscription réussie ! Votre compte est en attente d\'approbation. Vous serez notifié lorsque votre compte sera approuvé.';

  @override
  String get registrationSuccessfulAutoLogin =>
      'Inscription réussie ! Vous avez été automatiquement connecté.';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String get registrationSuccessful => 'Inscription réussie';

  @override
  String get pleaseLoginWithNewAccount =>
      'Veuillez vous connecter avec votre nouveau compte.';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get usernameOrEmailLabel => 'Nom d\'utilisateur ou e-mail';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Veuillez entrer votre nom d\'utilisateur ou e-mail';

  @override
  String get sendResetLink => 'Envoyer le lien de réinitialisation';

  @override
  String get resetLinkSent => 'Lien de réinitialisation envoyé';

  @override
  String get passwordResetInstructionsSent =>
      'Les instructions pour réinitialiser votre mot de passe ont été envoyées à votre adresse e-mail enregistrée.';

  @override
  String get resetFailed => 'Échec de la réinitialisation';

  @override
  String get unableToSendResetLink =>
      'Impossible d\'envoyer le lien de réinitialisation. Veuillez réessayer.';

  @override
  String get errorSendingResetLink =>
      'Une erreur s\'est produite lors de l\'envoi du lien de réinitialisation. Veuillez vérifier votre connexion et réessayer.';

  @override
  String get errorTitle => 'Erreur';

  @override
  String get okButton => 'OK';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get copyToClipboard => 'Copier dans le presse-papiers';

  @override
  String get copied => 'Copié';

  @override
  String get errorMessageCopiedToClipboard =>
      'Message d\'erreur copié dans le presse-papiers';

  @override
  String get cancel => 'Annuler';

  @override
  String get getHelp => 'Obtenir de l\'aide';

  @override
  String get somethingWentWrong => 'Quelque chose s\'est mal passé';

  @override
  String get unexpectedErrorOccurred =>
      'Une erreur inattendue s\'est produite. Veuillez réessayer.';

  @override
  String get noInternetConnection => 'Pas de connexion Internet';

  @override
  String get checkInternetConnection =>
      'Veuillez vérifier votre connexion Internet et réessayer.';

  @override
  String get authenticationRequired => 'Authentification requise';

  @override
  String get pleaseLoginToContinue => 'Veuillez vous connecter pour continuer.';

  @override
  String get forumError => 'Erreur du forum';

  @override
  String get anErrorOccurred => 'Une erreur s\'est produite';

  @override
  String get accountPendingApproval =>
      'Votre compte est en attente d\'approbation. Vous pouvez parcourir le forum mais ne pouvez pas publier jusqu\'à ce qu\'un modérateur approuve votre compte.';

  @override
  String get checkEmailToConfirm =>
      'Veuillez vérifier votre e-mail pour confirmer votre compte. Cliquez sur le lien de confirmation dans l\'e-mail que nous vous avons envoyé.';

  @override
  String get checkNewEmailToConfirm =>
      'Veuillez vérifier votre nouvelle adresse e-mail pour confirmer le changement. Votre ancien e-mail restera actif jusqu\'à ce que vous confirmiez le nouveau.';

  @override
  String get emailAddressInvalid =>
      'Votre adresse e-mail semble invalide ou rejette les e-mails. Veuillez mettre à jour votre adresse e-mail dans les paramètres du compte.';

  @override
  String get accountDisabled =>
      'Votre compte a été désactivé. Veuillez contacter un administrateur pour obtenir de l\'aide.';

  @override
  String get accountRegistrationRejected =>
      'L\'inscription de votre compte a été rejetée. Veuillez contacter un administrateur pour plus d\'informations.';

  @override
  String get welcomeToForumCopilot => 'Bienvenue sur Forum Copilot !';

  @override
  String get successfullyLoggedOut => 'Vous avez été déconnecté avec succès';

  @override
  String get accountStatusRequiresAttention =>
      'Le statut de votre compte nécessite une attention. Veuillez contacter un administrateur si vous avez des questions.';

  @override
  String get updateEmail => 'Mettre à jour l\'e-mail';

  @override
  String get resend => 'Renvoyer';

  @override
  String get noLatestTopics => 'Aucun sujet récent';

  @override
  String get noRecentTopicsToDisplay =>
      'Il n\'y a pas de sujets récents à afficher. Revenez plus tard pour de nouvelles discussions.';

  @override
  String get noUnreadTopics => 'Aucun sujet non lu';

  @override
  String get thereAreNoUnreadTopics =>
      'Il n\'y a pas de sujets non lus. Revenez plus tard pour de nouvelles discussions.';

  @override
  String get youAreAllCaughtUp => 'Vous êtes à jour !';

  @override
  String get noSubscribedTopics => 'Aucun sujet abonné';

  @override
  String get noSubscribedTopicsMessage =>
      'Vous ne vous êtes abonné à aucun sujet. Appuyez sur le bouton étoile sur un sujet pour vous abonner et recevoir des notifications pour les nouvelles mises à jour.';

  @override
  String get noParticipatedTopics => 'Aucun sujet participé';

  @override
  String get topicsYouParticipatedIn =>
      'Les sujets auxquels vous avez participé seront affichés ici.';

  @override
  String get latest => 'Récent';

  @override
  String get unread => 'Non lu';

  @override
  String get subscribed => 'Abonné';

  @override
  String get participated => 'Participé';

  @override
  String get connectionTimedOut =>
      'Délai de connexion expiré. Le site peut être hors ligne ou inaccessible.';

  @override
  String get failedToConnectToSite =>
      'Échec de la connexion au site. Le site peut être hors ligne ou inaccessible.';

  @override
  String get connectionFailed => 'Échec de la connexion';

  @override
  String failedToConnectToSiteName(String siteName) {
    return 'Échec de la connexion à $siteName';
  }

  @override
  String get loading => 'Chargement...';

  @override
  String get newConversation => 'Nouvelle conversation';

  @override
  String get newMessage => 'Nouveau message';

  @override
  String get appSettings => 'Paramètres de l\'application';

  @override
  String get searchSites => 'Rechercher des sites';

  @override
  String get all => 'Tout';

  @override
  String get topicsOnly => 'Sujets uniquement';

  @override
  String get titlesOnly => 'Titres uniquement';

  @override
  String failedToShareTopic(String error) {
    return 'Échec du partage du sujet : $error';
  }

  @override
  String pleaseLoginToSubscribe(String action) {
    return 'Veuillez vous connecter pour $action ce fil';
  }

  @override
  String get subscribeTo => 's\'abonner à';

  @override
  String get unsubscribeFrom => 'se désabonner de';

  @override
  String get subscribe => 'S\'abonner';

  @override
  String get unsubscribe => 'Se désabonner';

  @override
  String failedToSubscribeToThread(String action) {
    return 'Échec de $action du fil';
  }

  @override
  String get youCannotReplyToThisThread =>
      'Vous ne pouvez pas répondre à ce fil';

  @override
  String get pleaseWaitForThreadToLoad =>
      'Veuillez attendre le chargement du fil';

  @override
  String get postCanBeRestoredLater =>
      'Le message peut être restauré plus tard';

  @override
  String get postWillBePermanentlyDeleted =>
      'Le message sera définitivement supprimé';

  @override
  String get enterReasonForDeletingPost =>
      'Entrez la raison de la suppression de ce message';

  @override
  String get reportPost => 'Signaler le message';

  @override
  String get pleaseProvideReasonForReporting =>
      'Veuillez fournir une raison pour signaler ce message.';

  @override
  String get reason => 'Raison';

  @override
  String get enterReasonForReportingPost =>
      'Entrez la raison de signalement de ce message';

  @override
  String get pleaseEnterReason => 'Veuillez entrer une raison';

  @override
  String get selectedActions => 'Actions sélectionnées :';

  @override
  String get thisActionCannotBeUndone =>
      'Cette action ne peut pas être annulée.';

  @override
  String get participantsLabel => 'Participants';

  @override
  String usernameHasBeenInvited(String username) {
    return '$username a été invité à la conversation';
  }

  @override
  String errorInvitingUser(String error) {
    return 'Erreur lors de l\'invitation de l\'utilisateur : $error';
  }

  @override
  String get newTopic => 'Nouveau sujet';

  @override
  String get markRead => 'Marquer comme lu';

  @override
  String get pleaseSelectReasonForReportingUser =>
      'Veuillez sélectionner une raison pour signaler cet utilisateur.';

  @override
  String get spamOrAdvertising => 'Spam ou publicité';

  @override
  String get harassmentOrBullying => 'Harcèlement ou intimidation';

  @override
  String get inappropriateContent => 'Contenu inapproprié';

  @override
  String get impersonationOrFakeAccount =>
      'Usurpation d\'identité ou compte faux';

  @override
  String get otherPleaseSpecify => 'Autre (veuillez préciser)';

  @override
  String get pleaseSpecifyReason => 'Veuillez préciser la raison';

  @override
  String get enterReasonForReportingUser =>
      'Entrez la raison de signalement de cet utilisateur';

  @override
  String get pleaseSelectReason => 'Veuillez sélectionner une raison';

  @override
  String pleaseSelectReasonForBanningUser(String username) {
    return 'Veuillez sélectionner une raison pour bannir $username';
  }

  @override
  String get violationOfCommunityGuidelines =>
      'Violation des directives de la communauté';

  @override
  String get harassmentOrAbusiveBehavior =>
      'Harcèlement ou comportement abusif';

  @override
  String get postingInappropriateContent =>
      'Publication de contenu inapproprié';

  @override
  String get accountCompromiseOrSecurityIssue =>
      'Compromission du compte ou problème de sécurité';

  @override
  String get enterReasonForBanningUser =>
      'Entrez la raison de bannissement de cet utilisateur';

  @override
  String get banUntil => 'Bannir jusqu\'au';

  @override
  String get selectDate => 'Sélectionner la date';

  @override
  String get unbanUser => 'Débannir l\'utilisateur';

  @override
  String get leaveConversation => 'Quitter la conversation';

  @override
  String get reportConversation => 'Signaler la conversation';

  @override
  String get topicClosed => 'Sujet fermé';

  @override
  String get topicOpened => 'Sujet ouvert';

  @override
  String get topicStickied => 'Sujet épinglé';

  @override
  String get topicUnstickied => 'Sujet désépinglé';

  @override
  String cannotEditMessage(String error) {
    return 'Impossible d\'éditer ce message : $error';
  }

  @override
  String get confirmSpamClean => 'Confirmer le nettoyage du spam';

  @override
  String get myForums => 'Mes Forums';

  @override
  String get recentlyVisited => 'Récemment Visités';

  @override
  String get explore => 'Explorer';

  @override
  String get forumCopilot => 'Forum Copilot';

  @override
  String get noConversations => 'Aucune conversation';

  @override
  String get noConversationsMessage =>
      'Vous n\'avez pas encore de conversations. Démarrez une nouvelle conversation pour commencer à envoyer des messages.';

  @override
  String get imageSavedToGallery => 'Image enregistrée dans la galerie !';

  @override
  String failedToSaveImage(String error) {
    return 'Échec de l\'enregistrement de l\'image : $error';
  }

  @override
  String get userProfile => 'Profil Utilisateur';

  @override
  String get deletePost => 'Supprimer le Message';

  @override
  String get loginRequired => 'Connexion Requise';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get memberSince => 'Membre Depuis';

  @override
  String get lastActivity => 'Dernière Activité';

  @override
  String get likesReceived => 'J\'aime Reçus';

  @override
  String get likesGiven => 'J\'aime Donnés';

  @override
  String get failedToSaveMessage => 'Échec de l\'enregistrement du message';

  @override
  String get failedToSaveSetting => 'Échec de l\'enregistrement du paramètre';

  @override
  String get failedToSavePost => 'Échec de l\'enregistrement du message';

  @override
  String errorLoadingSites(String error) {
    return 'Erreur lors du chargement des sites : $error';
  }

  @override
  String connectingTo(String domainName) {
    return 'Connexion à $domainName...';
  }

  @override
  String get members => 'Membres';

  @override
  String get allMembers => 'Tous les Membres';

  @override
  String get online => 'En Ligne';

  @override
  String get noMembersFound => 'Aucun membre trouvé';

  @override
  String get searchForMembers => 'Rechercher des membres';

  @override
  String get enterUsernameToFindMembers =>
      'Entrez un nom d\'utilisateur pour trouver des membres du forum';

  @override
  String get noMembersOnline => 'Aucun membre n\'est actuellement en ligne';

  @override
  String get lookupMembers => 'Rechercher des Membres';

  @override
  String get addMembers => 'Ajouter des Membres';

  @override
  String get membersAddedSuccessfully => 'Membres ajoutés avec succès';

  @override
  String errorAddingMembers(String error) {
    return 'Erreur lors de l\'ajout de membres : $error';
  }

  @override
  String get failedToLoadOnlineUsers =>
      'Échec du chargement des utilisateurs en ligne';

  @override
  String get noUsersOnline => 'Aucun utilisateur en ligne';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString Membres';
  }

  @override
  String get noSubject => 'Sans objet';

  @override
  String get search => 'Rechercher';

  @override
  String get moreOptions => 'Plus d\'options';

  @override
  String get logout => 'Déconnexion';

  @override
  String get areYouSureYouWantToLogout =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get register => 'S\'inscrire';

  @override
  String get signIn => 'Se connecter';

  @override
  String get markForumRead => 'Marquer le Forum comme Lu';

  @override
  String get notificationTest => 'Test de Notification';

  @override
  String get forum => 'Forum';

  @override
  String get profile => 'Profil';

  @override
  String get messages => 'Messages';

  @override
  String get add => 'Ajouter';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get retry => 'Réessayer';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteMessage => 'Supprimer le Message';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'Êtes-vous sûr de vouloir supprimer ce message ?';

  @override
  String failedToDeleteMessage(String error) {
    return 'Échec de la suppression du message : $error';
  }

  @override
  String get deletingPost => 'Suppression du message...';

  @override
  String failedToUnlikePost(String error) {
    return 'Échec du retrait du j\'aime du message : $error';
  }

  @override
  String failedToLikePost(String error) {
    return 'Échec du j\'aime du message : $error';
  }

  @override
  String get youNeedToBeSignedInToViewConversations =>
      'Vous devez être connecté pour voir vos conversations.';

  @override
  String errorLoadingConversations(String error) {
    return 'Erreur lors du chargement des conversations : $error';
  }

  @override
  String failedToLeaveConversation(String error) {
    return 'Échec de la sortie de la conversation : $error';
  }

  @override
  String errorLoadingMoreConversations(String error) {
    return 'Erreur lors du chargement de plus de conversations : $error';
  }

  @override
  String errorLoadingMoreMessages(String error) {
    return 'Erreur lors du chargement de plus de messages : $error';
  }

  @override
  String get inviteMessageOptional => 'Message d\'Invitation (optionnel)';

  @override
  String get iWouldLikeToAddYouToThisConversation =>
      'J\'aimerais vous ajouter à cette conversation.';

  @override
  String get searchFailed => 'Recherche échouée';

  @override
  String get trySearchingWithDifferentUsername =>
      'Essayez de rechercher avec un nom d\'utilisateur différent';

  @override
  String get enterUsernameToSearch =>
      'Entrez le nom d\'utilisateur pour rechercher...';

  @override
  String get noSitesFound => 'Aucun site trouvé.';

  @override
  String get userInformationNotAvailable =>
      'Informations utilisateur non disponibles';

  @override
  String get birthday => 'Anniversaire';

  @override
  String get posts => 'Messages';

  @override
  String get following => 'Abonnements';

  @override
  String get followers => 'Abonnés';

  @override
  String get about => 'À propos';

  @override
  String get location => 'Localisation';

  @override
  String get website => 'Site web';

  @override
  String get signature => 'Signature';

  @override
  String get next => 'Suivant';

  @override
  String get permanent => 'Permanent';

  @override
  String get temporary => 'Temporaire';

  @override
  String setBanDurationFor(String username) {
    return 'Définir la durée du bannissement pour $username';
  }

  @override
  String get pleaseSelectEndDateForTemporaryBan =>
      'Veuillez sélectionner une date de fin pour le bannissement temporaire';

  @override
  String get back => 'Retour';

  @override
  String get unban => 'Débannir';

  @override
  String get confirm => 'Confirmer';

  @override
  String spamClean(String username) {
    return 'Nettoyer le Spam de $username';
  }

  @override
  String get selectActionsToPerform => 'Sélectionnez les actions à effectuer :';

  @override
  String get handleThreads => 'Gérer les fils';

  @override
  String get moveOrDeleteThreadsBasedOnAdminSettings =>
      'Déplacer ou supprimer les fils selon les paramètres de l\'administrateur';

  @override
  String get deleteMessages => 'Supprimer les messages';

  @override
  String get deleteConversations => 'Supprimer les conversations';

  @override
  String get messageUpdatedSuccessfully => 'Message mis à jour avec succès';

  @override
  String error(String error) {
    return 'Erreur : $error';
  }

  @override
  String failedToRemoveAttachment(String error) {
    return 'Échec de la suppression de la pièce jointe : $error';
  }

  @override
  String failedToLoadMessage(String error) {
    return 'Échec du chargement du message : $error';
  }

  @override
  String get editMessage => 'Modifier le Message';

  @override
  String get removeAttachment => 'Supprimer la Pièce Jointe';

  @override
  String get areYouSureYouWantToRemoveThisAttachment =>
      'Êtes-vous sûr de vouloir supprimer cette pièce jointe ?';

  @override
  String get none => 'Aucun';

  @override
  String get formatting => 'Formatage';

  @override
  String get bold => 'Gras';

  @override
  String get italic => 'Italique';

  @override
  String get underline => 'Souligné';

  @override
  String get strikethrough => 'Barré';

  @override
  String get link => 'Lien';

  @override
  String get image => 'Image';

  @override
  String get video => 'Vidéo';

  @override
  String get quote => 'Citation';

  @override
  String get code => 'Code';

  @override
  String get spoiler => 'Spoiler';

  @override
  String get bulletList => 'Liste à Puces';

  @override
  String get numberedList => 'Liste Numérotée';

  @override
  String get listItem => 'Élément de Liste';

  @override
  String participants(int count) {
    return 'Participants ($count)';
  }

  @override
  String get enterKeywordsToSearchTopics =>
      'Entrez des mots-clés pour rechercher des sujets...';

  @override
  String get pleaseFillInAllRequiredFields =>
      'Veuillez remplir tous les champs obligatoires';

  @override
  String get undelete => 'Restaurer';

  @override
  String get signInToViewUnreadTopics =>
      'Connectez-vous pour voir les sujets non lus';

  @override
  String get youNeedToBeSignedInToViewUnreadTopics =>
      'Vous devez être connecté pour voir vos sujets non lus';

  @override
  String get signInToViewSubscribedTopics =>
      'Connectez-vous pour voir les sujets abonnés';

  @override
  String get youNeedToBeSignedInToViewSubscribedTopics =>
      'Vous devez être connecté pour voir vos sujets abonnés';

  @override
  String get signInToViewParticipatedTopics =>
      'Connectez-vous pour voir les sujets participés';

  @override
  String get youNeedToBeSignedInToViewParticipatedTopics =>
      'Vous devez être connecté pour voir les sujets auxquels vous avez participé';

  @override
  String get signInToViewLatestTopics =>
      'Connectez-vous pour voir les sujets récents';

  @override
  String get youNeedToBeSignedInToViewLatestTopics =>
      'Vous devez être connecté pour voir les sujets récents';

  @override
  String get markAsUnread => 'Marquer comme non lu';

  @override
  String get invite => 'Inviter';

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String get signInToAccessYourProfile =>
      'Connectez-vous pour accéder à votre profil et gérer votre compte';

  @override
  String get enterYourUsername => 'Entrez votre nom d\'utilisateur';

  @override
  String get enterYourPassword => 'Entrez votre mot de passe';

  @override
  String get dontHaveAnAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get refresh => 'Actualiser';

  @override
  String get share => 'Partager';

  @override
  String get viewOnWeb => 'Voir sur le Web';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get lock => 'Verrouiller';

  @override
  String get stick => 'Épingler';

  @override
  String get unstick => 'Désépingler';

  @override
  String get reply => 'Répondre';

  @override
  String get vote => 'Voter';

  @override
  String votesCount(int count) {
    return '$count votes';
  }

  @override
  String get pollClosed => 'Sondage fermé';

  @override
  String pollEndsOn(String date) {
    return 'Se termine le $date';
  }

  @override
  String get voteToSeeResults => 'Votez pour voir les résultats';

  @override
  String get viewFullPoll => 'Voir le sondage';

  @override
  String pollOptionsCount(int count) {
    return '$count options';
  }

  @override
  String get reactedBy => 'Réagi par';

  @override
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count J\'aime',
      one: '$count J\'aime',
    );
    return '$_temp0';
  }

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count réactions',
      one: '$count réaction',
    );
    return '$_temp0';
  }

  @override
  String get showWhoReacted => 'Touchez pour voir qui a réagi.';

  @override
  String get react => 'Réagir';

  @override
  String get changeYourReaction => 'Modifier votre réaction';

  @override
  String get reactionsAll => 'Toutes';

  @override
  String get reactionYou => 'Vous';

  @override
  String reactionFilterSemantics(String reaction, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$reaction, $count personnes',
      one: '$reaction, $count personne',
    );
    return '$_temp0';
  }

  @override
  String viewProfileOfUser(String username) {
    return 'Voir le profil de $username';
  }

  @override
  String get enterKeywordsToFindTopicsAndPosts =>
      'Entrez des mots-clés pour trouver des sujets et des messages';

  @override
  String get enterKeywordsOrDomainToFindForums =>
      'Entrez des mots-clés ou un domaine pour trouver des forums';

  @override
  String get enterKeywordsOrDomainNamesToFindForums =>
      'Entrez des mots-clés ou des noms de domaine pour trouver des forums';

  @override
  String get language => 'Langue';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get followSystemLanguage => 'Suivre la langue du système';

  @override
  String get appearance => 'Apparence';

  @override
  String get followSystemTheme => 'Suivre le thème du système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String version(String version, String buildNumber) {
    return 'version $version ($buildNumber)';
  }

  @override
  String get forumSettings => 'Paramètres du forum';

  @override
  String get noSettingsAvailable => 'Aucun paramètre disponible';

  @override
  String get settingsCategoriesWillAppearHere =>
      'Les catégories de paramètres apparaîtront ici lorsqu\'elles seront disponibles.';

  @override
  String get spamCleaner => 'Nettoyeur de spam';

  @override
  String get unableToLoadProfile => 'Impossible de charger le profil';

  @override
  String get banned => 'BANNI';

  @override
  String get sendMessage => 'Envoyer un message';

  @override
  String get showMore => 'Afficher plus';

  @override
  String get reportUser => 'Signaler l\'utilisateur';

  @override
  String get submitReport => 'Soumettre le rapport';

  @override
  String get reportSubmittedSuccessfully => 'Rapport soumis avec succès';

  @override
  String get failedToSubmitReport => 'Échec de la soumission du rapport';

  @override
  String get searchForForums => 'Rechercher des forums';

  @override
  String get searchForums => 'Rechercher des Forums';

  @override
  String get deleteTopic => 'Supprimer le sujet';

  @override
  String get softDelete => 'Suppression douce';

  @override
  String get topicCanBeRestoredLater => 'Le sujet peut être restauré plus tard';

  @override
  String get hardDelete => 'Suppression définitive';

  @override
  String get topicWillBePermanentlyDeleted =>
      'Le sujet sera supprimé définitivement';

  @override
  String get reasonForDeletion => 'Raison de la suppression';

  @override
  String get enterReasonForDeletingTopic =>
      'Entrez la raison de la suppression de ce sujet';

  @override
  String get pleaseEnterReasonForDeletion =>
      'Veuillez entrer une raison pour la suppression';

  @override
  String get pleaseSelectEndDate => 'Veuillez sélectionner une date de fin';

  @override
  String get banUser => 'Bannir l\'utilisateur';

  @override
  String get userBannedSuccessfully => 'Utilisateur banni avec succès';

  @override
  String get failedToBanUser => 'Échec du bannissement de l\'utilisateur';

  @override
  String get userUnbannedSuccessfully => 'Utilisateur débanni avec succès';

  @override
  String get failedToUnbanUser => 'Échec du débannissement de l\'utilisateur';

  @override
  String get spamCleanUser => 'Nettoyer le spam de l\'utilisateur';

  @override
  String get deletePrivateConversations =>
      'Supprimer les conversations privées';

  @override
  String get banTheUserAccount => 'Bannir le compte utilisateur';

  @override
  String get cleanSpam => 'Nettoyer le spam';

  @override
  String get handledThreads => 'Sujets traités';

  @override
  String get deletedMessages => 'Messages supprimés';

  @override
  String get deletedConversations => 'Conversations supprimées';

  @override
  String get bannedUser => 'Utilisateur banni';

  @override
  String successfullyCleanedSpam(String username, String actions) {
    return 'Spam nettoyé avec succès pour $username. Actions: $actions';
  }

  @override
  String errorLoadingMessage(String error) {
    return 'Erreur lors du chargement du message: $error';
  }

  @override
  String get messageNotFound => 'Message introuvable';

  @override
  String get home => 'Accueil';

  @override
  String get notifications => 'Notifications';

  @override
  String get forums => 'Forums';

  @override
  String get markAllForumsAsRead => 'Marquer tous les forums comme lus ?';

  @override
  String get markAllForumsAsReadMessage =>
      'Cela marquera tous les forums et sujets comme lus. Cette action ne peut pas être annulée.';

  @override
  String get markAsRead => 'Marquer comme lu';

  @override
  String get content => 'Contenu';

  @override
  String get insertImage => 'Insérer une image';

  @override
  String get howWouldYouLikeToInsertImage =>
      'Comment souhaitez-vous insérer cette image ?';

  @override
  String get thumbnail => 'Miniature';

  @override
  String get fullSize => 'Taille réelle';

  @override
  String get alignLeft => 'Aligner à gauche';

  @override
  String get alignCenter => 'Aligner au centre';

  @override
  String get alignRight => 'Aligner à droite';

  @override
  String get pleaseEnterTitle => 'Veuillez entrer un titre';

  @override
  String get pleaseEnterContent => 'Veuillez entrer du contenu';

  @override
  String get uploading => 'Téléchargement...';

  @override
  String get uploaded => 'Téléchargé';

  @override
  String get mentionUser => 'Mentionner un utilisateur';

  @override
  String get loggingIn => 'Connexion en cours...';

  @override
  String get submittingReport => 'Envoi du rapport...';

  @override
  String get banningUser => 'Bannissement de l\'utilisateur...';

  @override
  String get unbanningUser => 'Débannissement de l\'utilisateur...';

  @override
  String get cleaningSpam => 'Nettoyage du spam...';

  @override
  String get enterSubject => 'Entrez le sujet';

  @override
  String get typeYourMessageHere => 'Tapez votre message ici';

  @override
  String get writeYourMessage => 'Écrivez votre message...';

  @override
  String get writeYourReply => 'Écrivez votre réponse...';

  @override
  String get messageSentSuccessfully => 'Message envoyé avec succès';

  @override
  String get replySentSuccessfully => 'Réponse envoyée avec succès';

  @override
  String get conversationCreatedSuccessfully =>
      'Conversation créée avec succès';

  @override
  String get conversationMarkedAsUnread => 'Conversation marquée comme non lue';

  @override
  String get messageMarkedAsUnread => 'Message marqué comme non lu';

  @override
  String get conversationClosed => 'Conversation fermée';

  @override
  String get conversationOpened => 'Conversation ouverte';

  @override
  String get pleaseLoginToLikeMessages =>
      'Veuillez vous connecter pour aimer les messages';

  @override
  String get loadEarlierMessages => 'Charger les messages précédents';

  @override
  String failedToLoadQuote(String error) {
    return 'Échec du chargement de la citation : \n$error';
  }

  @override
  String failedToUploadFile(String error) {
    return 'Échec du téléchargement du fichier : $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Échec du téléchargement de l\'image : $error';
  }

  @override
  String failedToSendMessage(String error) {
    return 'Échec de l\'envoi du message : $error';
  }

  @override
  String failedToSendReply(String error) {
    return 'Échec de l\'envoi de la réponse : $error';
  }

  @override
  String failedToMarkAsUnread(String error) {
    return 'Échec du marquage du message comme non lu : $error';
  }

  @override
  String failedToMarkConversationAsUnread(String error) {
    return 'Échec du marquage de la conversation comme non lue : $error';
  }

  @override
  String failedToCloseConversation(String error) {
    return 'Échec de la fermeture de la conversation : $error';
  }

  @override
  String failedToOpenConversation(String error) {
    return 'Échec de l\'ouverture de la conversation : $error';
  }

  @override
  String failedToJumpToMessage(String error) {
    return 'Échec du saut au message : $error';
  }

  @override
  String get goToTop => 'Aller en haut';

  @override
  String get goToBottom => 'Aller en bas';

  @override
  String get replyAll => 'Répondre à tous';

  @override
  String get forward => 'Transférer';

  @override
  String get noForumsFound => 'Aucun forum trouvé.';

  @override
  String get pleaseSelectPrefix => 'Veuillez sélectionner un préfixe';

  @override
  String get pleaseLoginToAccessContent =>
      'Veuillez vous connecter pour accéder à ce contenu et interagir avec les publications.';

  @override
  String get searchUsers => 'Rechercher des utilisateurs...';

  @override
  String get writeYourTitle => 'Écrivez votre titre...';

  @override
  String get writeYourContent => 'Écrivez votre contenu...';

  @override
  String get selectAnOption => 'Sélectionnez une option';

  @override
  String get enterConversationTitle => 'Entrez le titre de la conversation';

  @override
  String enterCode(int count) {
    return 'Entrez le code à $count chiffres';
  }

  @override
  String get edit => 'Modifier';

  @override
  String get report => 'Signaler';

  @override
  String get unfollow => 'Ne plus suivre';

  @override
  String get follow => 'Suivre';

  @override
  String get remove => 'Supprimer';

  @override
  String get subject => 'Sujet';

  @override
  String get message => 'Message';

  @override
  String get titleCannotBeEmpty => 'Le titre ne peut pas être vide';

  @override
  String get conversationUpdatedSuccessfully =>
      'Conversation mise à jour avec succès';

  @override
  String get goBack => 'Retour';

  @override
  String get signInToViewMessages => 'Connectez-vous pour voir les messages';

  @override
  String get privateMessagesNotAvailable => 'Messages privés non disponibles';

  @override
  String failedToLoadPost(String error) {
    return 'Échec du chargement de la publication : \n$error';
  }

  @override
  String failedToLikeOrUnlikeMessage(String action, String error) {
    return 'Échec du $action message : $error';
  }

  @override
  String get like => 'aimer';

  @override
  String get unlike => 'ne plus aimer';

  @override
  String get optimizeImage => 'Optimiser l\'image';

  @override
  String get optimizeAndUpload => 'Optimiser et télécharger';

  @override
  String downloading(String filename) {
    return 'Téléchargement de $filename...';
  }

  @override
  String openingShareSheet(String filename) {
    return 'Ouverture de la feuille de partage pour $filename';
  }

  @override
  String errorDownloading(String filename, String error) {
    return 'Erreur lors du téléchargement de $filename : $error';
  }

  @override
  String get enterANumber => 'Entrez un nombre';

  @override
  String get failedToNavigateToForum => 'Échec de la navigation vers le forum';

  @override
  String failedToNavigateToForumName(String forumName) {
    return 'Échec de la navigation vers $forumName';
  }

  @override
  String get failedToSaveConversation =>
      'Échec de l\'enregistrement de la conversation';

  @override
  String forumNotFound(String forumName) {
    return 'Forum introuvable : $forumName';
  }

  @override
  String forumNotFoundById(String forumId) {
    return 'Forum introuvable : $forumId';
  }

  @override
  String couldNotOpenLink(String error) {
    return 'Impossible d\'ouvrir le lien : $error';
  }

  @override
  String get likePost => 'Aimer le message';

  @override
  String get unlikePost => 'Ne plus aimer';

  @override
  String get showLikes => 'Afficher les j\'aime';

  @override
  String get quotePost => 'Citer le message';

  @override
  String get attachFile => 'Joindre un Fichier';

  @override
  String get uploadImage => 'Télécharger une Image';

  @override
  String get translate => 'Traduire';

  @override
  String get showOriginal => 'Afficher l\'original';

  @override
  String get translating => 'Traduction en cours...';

  @override
  String get translated => 'Traduit';

  @override
  String get translatedContent => 'Contenu traduit';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get translateTo => 'Traduire vers :';

  @override
  String get deviceLanguage => 'Langue de l\'appareil';

  @override
  String get noPostsToTranslate => 'Aucun message à traduire';

  @override
  String get translationFailed => 'Échec de la traduction';

  @override
  String get twoFactorAuthentication => 'Authentification à deux facteurs';

  @override
  String get authenticationCodeLabel => 'Code d\'authentification';

  @override
  String get pleaseEnterYourAuthenticationCode =>
      'Veuillez saisir votre code d\'authentification';

  @override
  String codeMustBeDigits(int count) {
    return 'Le code doit contenir $count chiffres';
  }

  @override
  String get codeMustContainOnlyNumbers =>
      'Le code doit contenir uniquement des chiffres';

  @override
  String get verifyButton => 'Vérifier';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get replyOptions => 'Options de reponse';

  @override
  String get replyWithQuote => 'Repondre avec citation';

  @override
  String fileSavedToDownloads(String filename) {
    return 'Fichier enregistré dans Téléchargements : $filename';
  }

  @override
  String fileSavedToDocuments(String filename) {
    return 'Fichier enregistré dans Documents : $filename';
  }

  @override
  String get discardPostQuestion => 'Voulez-vous abandonner votre message ?';

  @override
  String get discardChangesQuestion =>
      'Voulez-vous annuler vos modifications ?';

  @override
  String get discard => 'Abandonner';

  @override
  String get discardChanges => 'Annuler les modifications';

  @override
  String get notificationsTab => 'Alertes';

  @override
  String get postAwaitingApproval =>
      'Votre message apparaîtra dès qu’un modérateur l’aura approuvé.';

  @override
  String get reactionHoldHint => 'Appui long pour plus de réactions';

  @override
  String get turnOnNotifications => 'Activer les notifications';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String neverMissAReplyOn(Object forumName) {
    return 'Ne manquez aucune réponse sur $forumName';
  }

  @override
  String get notificationPreviewNow => 'maintenant';

  @override
  String get notificationPreviewEarlier => 'il y a 5 min';

  @override
  String get notificationPreviewReply =>
      'Jane vous a répondu : Bienvenue ! Ravis que vous nous ayez trouvés.';

  @override
  String get notificationPreviewMessage =>
      'Sam vous a envoyé un message : Tu viens vendredi ?';

  @override
  String get notificationsAreTurnedOffForThisApp =>
      'Les notifications sont désactivées pour cette application';

  @override
  String get deviceWillNotShowAlertsUntilAllowedInSettings =>
      'Votre appareil n\'affichera aucune alerte tant que vous n\'autorisez pas les notifications dans les Réglages.';

  @override
  String get openSettings => 'Ouvrir les réglages';

  @override
  String get notificationsPitchForum =>
      'Les réponses, mentions et messages privés sur votre écran de verrouillage, dès qu’ils arrivent.';

  @override
  String get viewProfile => 'Voir le profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get changeEmail => 'Changer l’adresse e-mail';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get save => 'Enregistrer';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmez le nouveau mot de passe';

  @override
  String get newEmailAddress => 'Nouvelle adresse e-mail';

  @override
  String get emailChanged => 'Adresse e-mail modifiée';

  @override
  String get emailChangeConfirm =>
      'Consultez votre boîte de réception : la nouvelle adresse prend effet dès que vous la confirmez.';

  @override
  String get passwordChanged => 'Mot de passe modifié';

  @override
  String get account => 'Compte';

  @override
  String get pleaseEnterEmail => 'Veuillez saisir votre e-mail';

  @override
  String get pleaseEnterValidEmail =>
      'Veuillez saisir une adresse e-mail valide';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get connectionErrorTitle => 'Erreur de connexion';

  @override
  String get authenticationErrorTitle => 'Erreur d\'authentification';

  @override
  String get permissionErrorTitle => 'Erreur d\'autorisation';

  @override
  String get errorNoConnection =>
      'Aucune connexion Internet. Veuillez vérifier vos paramètres réseau.';

  @override
  String get errorTimeout => 'La requête a expiré. Veuillez réessayer.';

  @override
  String get errorServer => 'Erreur du serveur. Veuillez réessayer plus tard.';

  @override
  String get errorNetwork => 'Erreur réseau. Veuillez réessayer.';

  @override
  String get errorInvalidCredentials =>
      'Nom d\'utilisateur ou mot de passe incorrect.';

  @override
  String get errorSessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get errorAccountLocked =>
      'Votre compte a été verrouillé. Veuillez contacter le support.';

  @override
  String get errorAuthFailed =>
      'Échec de l\'authentification. Veuillez réessayer.';

  @override
  String get errorForumNotFound => 'Forum introuvable.';

  @override
  String get errorForumAccessDenied =>
      'Vous n\'avez pas l\'autorisation d\'accéder à ce forum.';

  @override
  String get errorForumUnavailable =>
      'Le forum est actuellement indisponible. Veuillez réessayer plus tard.';

  @override
  String get errorForumGeneric =>
      'Une erreur s\'est produite sur le forum. Veuillez réessayer.';

  @override
  String get errorDataNotFound => 'Données demandées introuvables.';

  @override
  String get errorDataCorrupted =>
      'Les données semblent corrompues. Veuillez actualiser la page.';

  @override
  String get errorCache =>
      'Impossible de charger les données en cache. Veuillez réessayer.';

  @override
  String get errorInvalidInput => 'Une des valeurs saisies n\'est pas valide.';

  @override
  String get errorRequiredField =>
      'Veuillez remplir tous les champs obligatoires.';

  @override
  String get errorPermissionDenied =>
      'Vous n\'avez pas l\'autorisation de faire cela.';

  @override
  String errorFeatureNotAvailable(String feature) {
    return '$feature n\'est pas disponible sur ce forum.';
  }

  @override
  String get errorStorageFull =>
      'L\'espace de stockage est plein. Veuillez libérer de l\'espace.';

  @override
  String get errorStorageAccessDenied =>
      'Accès au stockage refusé. Veuillez vérifier les autorisations de l\'app.';

  @override
  String get loginInfo => 'Informations de connexion';

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String get topicAnnouncement => 'Annonce';

  @override
  String get topicPinned => 'Épinglé';

  @override
  String get topicLocked => 'Verrouillé';

  @override
  String get topicPoll => 'Sondage';

  @override
  String get deletedBadge => 'SUPPRIMÉ';

  @override
  String get protectedBadge => 'Protégé';

  @override
  String get lockTopic => 'Verrouiller le sujet';

  @override
  String get unlockTopic => 'Déverrouiller le sujet';

  @override
  String get lockTopicConfirm =>
      'Voulez-vous vraiment verrouiller ce sujet ? Les autres utilisateurs ne pourront plus y répondre ni interagir avec.';

  @override
  String get unlockTopicConfirm =>
      'Voulez-vous vraiment déverrouiller ce sujet ? Les autres utilisateurs pourront à nouveau y répondre et interagir avec.';

  @override
  String get stickTopic => 'Épingler le sujet';

  @override
  String get unstickTopic => 'Désépingler le sujet';

  @override
  String get stickTopicConfirm =>
      'Voulez-vous vraiment épingler ce sujet ? Il apparaîtra en haut du forum pour tous les utilisateurs.';

  @override
  String get unstickTopicConfirm =>
      'Voulez-vous vraiment désépingler ce sujet ? Il n\'apparaîtra plus en haut du forum.';

  @override
  String get undeleteTopic => 'Restaurer le sujet';

  @override
  String get undeleteTopicConfirm =>
      'Voulez-vous vraiment restaurer ce sujet ? Il sera de nouveau visible par les autres utilisateurs.';

  @override
  String get additionalInformation => 'Informations complémentaires';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get selectDateOfBirth => 'Sélectionnez votre date de naissance';

  @override
  String minimumAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Âge minimum : $age ans',
      one: 'Âge minimum : $age an',
    );
    return '$_temp0';
  }

  @override
  String get locationIsRequired => 'La localisation est obligatoire';

  @override
  String get receiveSiteMailings => 'Recevoir les e-mails du site';

  @override
  String iAcceptTheDocument(String document) {
    return 'J\'accepte les $document';
  }

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get imageExceedsUploadLimits =>
      'Cette image dépasse les limites d\'envoi et doit être optimisée :';

  @override
  String get originalSize => 'Taille d\'origine';

  @override
  String get originalDimensions => 'Dimensions d\'origine';

  @override
  String get optimizationsToBeApplied => 'Optimisations à appliquer :';

  @override
  String get resizeImage => 'Redimensionner';

  @override
  String get convertFormat => 'Convertir le format';

  @override
  String get smallerFileSize => 'fichier plus léger';

  @override
  String get formatNotSupported => 'format non pris en charge';

  @override
  String get convertToJpgReason =>
      'Convertir en JPG (format non pris en charge ou pour réduire la taille)';

  @override
  String get compressImage => 'Compresser';

  @override
  String compressQuality(int quality) {
    return 'Qualité : $quality % pour respecter la limite de taille';
  }

  @override
  String get estimatedFinalSize => 'Taille finale estimée';

  @override
  String sizeReduction(String percent) {
    return 'Réduction : $percent %';
  }

  @override
  String get pleaseLoginToCreateTopic =>
      'Veuillez vous connecter pour créer un nouveau sujet';

  @override
  String get pleaseLoginToSubscribeForums =>
      'Veuillez vous connecter pour vous abonner aux forums';

  @override
  String get pleaseLoginToUnsubscribeForums =>
      'Veuillez vous connecter pour vous désabonner des forums';

  @override
  String errorLoadingContent(String error) {
    return 'Erreur lors du chargement du contenu : $error';
  }

  @override
  String get noPermissionToViewSubforumTopics =>
      'Vous n\'avez pas l\'autorisation de voir les sujets de ce sous-forum.';

  @override
  String get noDiscussionsYet => 'Aucune discussion pour le moment.';

  @override
  String get unableToLoadForums => 'Impossible de charger les forums';

  @override
  String get noForumsAvailable => 'Aucun forum disponible';

  @override
  String get noForumsToDisplay =>
      'Aucun forum à afficher. Cela peut être dû aux autorisations ou à la structure du forum.';

  @override
  String get subscribedForums => 'Forums suivis';

  @override
  String get allForumTopicsMarkedRead =>
      'Tous les sujets du forum ont été marqués comme lus';

  @override
  String postsCountFormatted(String count) {
    return '$count messages';
  }

  @override
  String get jumpToPost => 'Aller au message';

  @override
  String get jump => 'Aller';

  @override
  String get endOfDiscussion => 'Fin de la discussion';

  @override
  String refreshFailed(String error) {
    return 'Échec de l\'actualisation : $error';
  }

  @override
  String get topicDeletedHidden =>
      'Ce sujet est supprimé et masqué aux autres utilisateurs';

  @override
  String get topicClosedNoReplies =>
      'Ce sujet est fermé et n\'accepte plus de réponses';

  @override
  String get youAreSubscribedToTopic => 'Vous suivez ce sujet';

  @override
  String get refreshing => 'Actualisation...';

  @override
  String get unableToLoadForumsTryAgain =>
      'Impossible de charger les forums. Veuillez réessayer.';

  @override
  String get noPostableForums => 'Aucun forum ne permet de publier.';

  @override
  String get changeForumQuestion => 'Changer de forum ?';

  @override
  String get changeForumRemovesAttachments =>
      'Changer de forum supprimera vos pièces jointes envoyées, car elles sont liées au forum choisi.';

  @override
  String get changeForum => 'Changer de forum';

  @override
  String get chooseForumBeforePosting =>
      'Veuillez choisir un forum avant de publier';

  @override
  String get accountCannotUploadAttachments =>
      'Votre compte ne peut pas envoyer de pièces jointes sur ce site.';

  @override
  String get forumNoAttachments =>
      'Ce forum n\'accepte pas les pièces jointes.';

  @override
  String get forumNoAttachmentsChooseAnother =>
      'Ce forum n\'accepte pas les pièces jointes. Choisissez un autre forum pour envoyer les fichiers partagés.';

  @override
  String get forumNoAttachmentsSharedPending =>
      'Ce forum n\'accepte pas les pièces jointes. Les fichiers partagés resteront en attente jusqu\'à ce que vous choisissiez un autre forum.';

  @override
  String get tapToChangeForum => 'Touchez pour changer de forum';

  @override
  String get chooseWhichForum => 'Choisissez le forum où publier';

  @override
  String get selectAForum => 'Sélectionnez un forum';

  @override
  String get unableToLoadForumsNow =>
      'Impossible de charger les forums pour le moment.';

  @override
  String get pickForumBeforeUploading =>
      'Choisissez un forum avant d\'envoyer des pièces jointes ou de publier.';

  @override
  String get uploadingSharedFiles => 'Envoi des fichiers partagés...';

  @override
  String get selectForum => 'Choisir un forum';

  @override
  String get noForumsMatchSearch =>
      'Aucun forum ne correspond à votre recherche.';

  @override
  String get unknown => 'Inconnu';

  @override
  String get closeConversationConfirm =>
      'Voulez-vous vraiment fermer cette conversation ? Plus aucune réponse ne pourra être envoyée.';

  @override
  String get openConversationConfirm =>
      'Voulez-vous vraiment rouvrir cette conversation ? De nouvelles réponses pourront être envoyées.';

  @override
  String get leaveConversationConfirm =>
      'Voulez-vous vraiment quitter cette conversation ? Elle sera masquée de votre boîte de réception.';

  @override
  String get close => 'Fermer';

  @override
  String get open => 'Ouvrir';

  @override
  String get leave => 'Quitter';

  @override
  String errorLoadingConversation(String error) {
    return 'Erreur lors du chargement de la conversation : $error';
  }

  @override
  String get conversationNotFound => 'Conversation introuvable';

  @override
  String get conversationClosedNoReplies =>
      'Cette conversation est fermée et n\'accepte plus de réponses';

  @override
  String get noMessagesFound => 'Aucun message trouvé';

  @override
  String get endOfConversation => 'Fin de la conversation';

  @override
  String get jumpToMessage => 'Aller au message';

  @override
  String get jumpToFirstMessage => 'Aller au premier message';

  @override
  String get jumpToLastMessage => 'Aller au dernier message';

  @override
  String messagePositionOf(int position, int total) {
    return 'Message $position sur $total';
  }

  @override
  String get tapToJumpToMessage => 'Touchez pour aller à un message précis';

  @override
  String failedToReact(String error) {
    return 'Impossible de réagir : $error';
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
  String get noImagesToDisplay => 'Aucune image à afficher.';

  @override
  String get pleaseLoginToViewAttachment =>
      'Veuillez vous connecter pour voir cette pièce jointe';

  @override
  String get inbox => 'Boîte de réception';

  @override
  String get sent => 'Envoyés';

  @override
  String errorLoadingMessages(String error) {
    return 'Erreur lors du chargement des messages : $error';
  }

  @override
  String get noInboxMessages => 'Aucun message reçu';

  @override
  String get noSentMessages => 'Aucun message envoyé';

  @override
  String get unknownDate => 'Date inconnue';

  @override
  String get searchForTopics => 'Rechercher des sujets';

  @override
  String get noTopicsFound => 'Aucun sujet trouvé';

  @override
  String get noPostsFound => 'Aucun message trouvé';

  @override
  String get trySearchingDifferentKeywords =>
      'Essayez avec d\'autres mots-clés';

  @override
  String errorLoadingSettings(String error) {
    return 'Erreur lors du chargement des paramètres : $error';
  }

  @override
  String get pleaseEnterValidNumber => 'Veuillez saisir un nombre valide';

  @override
  String valueMustBeAtLeast(String min) {
    return 'La valeur doit être au moins $min';
  }

  @override
  String valueMustBeAtMost(String max) {
    return 'La valeur doit être au plus $max';
  }

  @override
  String maximumLengthCharacters(int max) {
    return 'La longueur maximale est de $max caractères';
  }

  @override
  String get invalidFormat => 'Format non valide';

  @override
  String get shareToForumCopilot => 'Partager vers Forum Copilot';

  @override
  String get noSavedForumAccounts => 'Aucun compte de forum enregistré.';

  @override
  String get addForumAccountFirst =>
      'Ajoutez d\'abord un compte de forum dans Forum Copilot, puis réessayez de partager.';

  @override
  String filesReadyToAttach(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers prêts à joindre',
      one: '$count fichier prêt à joindre',
    );
    return '$_temp0';
  }

  @override
  String get sharedTextWillBePrefilled => 'Le texte partagé sera prérempli';

  @override
  String errorSearchingForums(String error) {
    return 'Erreur lors de la recherche de forums : $error';
  }

  @override
  String failedToLoadUserInfo(String error) {
    return 'Impossible de charger les informations de l\'utilisateur : $error';
  }

  @override
  String areYouSureUnban(String username) {
    return 'Voulez-vous vraiment débannir $username ?';
  }

  @override
  String get deletePostsProfilePostsComments =>
      'Supprimer les messages, messages de profil et commentaires';

  @override
  String areYouSureSpamClean(String username) {
    return 'Voulez-vous vraiment nettoyer le spam de $username ?';
  }

  @override
  String successfullyCleanedSpamFor(String username) {
    return 'Le spam de $username a été nettoyé';
  }

  @override
  String get failedToCleanSpam => 'Impossible de nettoyer le spam';

  @override
  String imagesCount(int count) {
    return 'Images ($count)';
  }

  @override
  String get pleaseLoginToViewProfiles =>
      'Veuillez vous connecter pour voir les profils des utilisateurs.';

  @override
  String get tapToOpen => 'Touchez pour ouvrir';

  @override
  String get imageNotAvailable => 'Image non disponible';

  @override
  String get tapToViewFullSizeImage =>
      'Touchez pour voir l\'image en taille réelle';

  @override
  String get loadingImage => 'Chargement de l\'image...';

  @override
  String loadingImageFrom(String host) {
    return 'Chargement de l\'image depuis $host';
  }

  @override
  String get tapToReveal => '(touchez pour afficher)';

  @override
  String get inlineAttachments => 'Pièces jointes intégrées';

  @override
  String get thisFieldIsRequired => 'Ce champ est obligatoire';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'Veuillez saisir un numéro de téléphone valide';

  @override
  String get pleaseEnterValidUrl => 'Veuillez saisir une URL valide';

  @override
  String get permissionDeniedToSaveImage =>
      'Autorisation refusée pour enregistrer l\'image';

  @override
  String get postNotFound => 'Message introuvable.';

  @override
  String get failedToUploadFileTryAgain =>
      'Impossible d\'envoyer le fichier. Veuillez réessayer.';

  @override
  String get failedToPickFile => 'Impossible de sélectionner le fichier';

  @override
  String onlyMoreAttachmentsAllowed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Plus que $count pièces jointes autorisées. Les $count premières images seront utilisées.',
      one:
          'Plus qu\'une pièce jointe autorisée. La première image sera utilisée.',
    );
    return '$_temp0';
  }

  @override
  String get attachmentLimitReachedSkipping =>
      'Limite de pièces jointes atteinte. Les images restantes sont ignorées.';

  @override
  String get imageValidationFailed => 'La vérification de l\'image a échoué';

  @override
  String get imageUploadFailed => 'Impossible d\'envoyer l\'image';

  @override
  String get failedToUploadImageTryAgain =>
      'Impossible d\'envoyer l\'image. Veuillez réessayer.';

  @override
  String get failedToPickImage => 'Impossible de sélectionner l\'image';

  @override
  String get prefix => 'Préfixe';

  @override
  String get failedToLoadPrefixes => 'Impossible de charger les préfixes';

  @override
  String get attachFileHint => 'Joindre un fichier à ce message';

  @override
  String get uploadImageHint => 'Ajouter une image à ce message';

  @override
  String get openFormattingOptions => 'Ouvrir les options de mise en forme';

  @override
  String get failedToPostReply =>
      'Impossible de publier la réponse. Veuillez réessayer.';

  @override
  String get failedToUpdatePost =>
      'Impossible de modifier le message. Veuillez réessayer.';

  @override
  String get postDeletedSuccessfully => 'Message supprimé';

  @override
  String failedToDeletePost(String error) {
    return 'Impossible de supprimer le message : $error';
  }

  @override
  String get noPermissionToUploadAvatars =>
      'Vous n\'avez pas l\'autorisation d\'envoyer des avatars';

  @override
  String get avatarUploadedSuccessfully => 'Avatar envoyé';

  @override
  String get unknownTopic => 'Sujet inconnu';

  @override
  String get connectionTimeoutTitle => 'Délai de connexion dépassé';

  @override
  String connectionTimedOutTo(String siteName) {
    return 'La connexion à $siteName a expiré. Veuillez vérifier votre connexion Internet et réessayer.';
  }

  @override
  String failedToConnectCheckPlugin(String siteName) {
    return 'Impossible de se connecter à $siteName. Vérifiez que le forum est disponible et que le plugin est installé.';
  }

  @override
  String get voteFailedTryAgain => 'Le vote a échoué. Veuillez réessayer.';

  @override
  String get noUserSpecified => 'Aucun utilisateur indiqué';

  @override
  String get failedToLoadRecentPosts =>
      'Impossible de charger les messages récents';

  @override
  String failedToLoadPreview(String error) {
    return 'Impossible de charger l\'aperçu : $error';
  }

  @override
  String thanksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Remercié par $count personnes',
      one: 'Remercié par $count personne',
    );
    return '$_temp0';
  }

  @override
  String get thankedBy => 'Remercié par';

  @override
  String maximumAttachmentsAllowed(int count) {
    return 'Maximum de $count pièce(s) jointe(s) autorisée(s)';
  }

  @override
  String get toLabel => 'À';

  @override
  String get closeConversation => 'Fermer la conversation';

  @override
  String get openConversation => 'Ouvrir la conversation';

  @override
  String get loginSucceeded => 'Connexion réussie';

  @override
  String get verificationErrorTryAgain =>
      'Une erreur s\'est produite lors de la vérification. Veuillez réessayer.';

  @override
  String get passkeyChallengeFailed =>
      'Impossible de lancer la connexion par clé d’accès.';

  @override
  String get passkeyNotSetUp =>
      'Ce forum n\'est pas encore configuré pour les clés d’accès dans cette app. Veuillez vous connecter avec votre nom d\'utilisateur et votre mot de passe.';

  @override
  String get noPasskeyForForum =>
      'Aucune clé d’accès trouvée pour ce forum. Connectez-vous avec votre mot de passe ou créez d\'abord une clé d’accès sur le site du forum.';

  @override
  String get pushNotificationsNotReady =>
      'Les notifications push ne sont pas encore prêtes';

  @override
  String pushEnabledFor(String siteName) {
    return 'Notifications push activées pour $siteName';
  }

  @override
  String get failedToEnablePush =>
      'Impossible d\'activer les notifications push';

  @override
  String get failedToRegisterPush =>
      'Impossible de s\'inscrire aux notifications push';

  @override
  String translatedFromTo(String source, String target) {
    return 'Traduit de $source vers $target';
  }

  @override
  String get unableToOpenNotification => 'Impossible d\'ouvrir la notification';

  @override
  String get notificationMissingInfo =>
      'Il manque des informations à cette notification.';

  @override
  String get couldNotOpenForum => 'Impossible d\'ouvrir le forum.';

  @override
  String get notificationChannelName => 'Notifications Forum Copilot';

  @override
  String get notificationChannelDescription =>
      'Notifications de l\'app Forum Copilot';

  @override
  String fileTypeNotAllowed(String extension, String allowed) {
    return 'Le type de fichier .$extension n’est pas autorisé. Types autorisés : $allowed';
  }

  @override
  String fileSizeExceedsMaximum(String size, String max) {
    return 'La taille du fichier ($size) dépasse le maximum de $max';
  }

  @override
  String get fileTypeAudio => 'Audio';

  @override
  String get fileTypeText => 'Texte';

  @override
  String get fileTypeArchive => 'Archive';

  @override
  String get fileTypeFile => 'Fichier';

  @override
  String get imageFileNotFound =>
      'Fichier image introuvable. Il a peut-être été déplacé ou supprimé.';

  @override
  String get imagePermissionDenied =>
      'Autorisation refusée. Impossible de lire le fichier image.';

  @override
  String get imageInsufficientSpace =>
      'Espace disque insuffisant pour optimiser l\'image.';

  @override
  String cannotAccessImageFile(String error) {
    return 'Impossible d\'accéder au fichier image : $error';
  }

  @override
  String get imageFormatUnsupported =>
      'Le format de l\'image est corrompu ou non pris en charge. Veuillez essayer une autre image.';

  @override
  String get failedToResizeImage =>
      'Impossible de redimensionner l\'image. Elle est peut-être corrompue ou dans un format non pris en charge.';

  @override
  String get failedToConvertImageToJpg =>
      'Impossible de convertir l\'image en JPG. Elle est peut-être corrompue.';

  @override
  String get failedToCompressImage =>
      'Impossible de compresser l\'image. L\'espace disque est peut-être insuffisant ou l\'image corrompue.';

  @override
  String get cannotDecodeImage =>
      'Impossible de décoder l\'image. Le fichier est peut-être corrompu ou dans un format non pris en charge.';

  @override
  String get cannotReadImageFile =>
      'Impossible de lire le fichier image. Il a peut-être été déplacé ou supprimé.';

  @override
  String failedToOptimizeImage(String error) {
    return 'Impossible d\'optimiser l\'image : $error';
  }

  @override
  String emailCopiedToClipboard(String email) {
    return 'E-mail copie dans le presse-papiers : $email';
  }

  @override
  String couldNotOpenEmail(String email) {
    return 'Impossible d ouvrir l e-mail : $email';
  }

  @override
  String get editPost => 'Modifier le message';

  @override
  String get thisTopicIsPinnedToTopOfForum =>
      'Ce sujet est epingle en haut du forum';

  @override
  String get editConversation => 'Modifier la conversation';

  @override
  String get failedToLoadConversation =>
      'Impossible de charger la conversation';

  @override
  String get cannotEditConversation =>
      'Impossible de modifier cette conversation';

  @override
  String get titleLabel => 'Titre';

  @override
  String get options => 'Options';

  @override
  String get openInvite => 'Invitation ouverte';

  @override
  String get allowAnyParticipantToInviteOthers =>
      'Autoriser tout participant à inviter d\'autres personnes';

  @override
  String get conversationOpen => 'Conversation ouverte';

  @override
  String failedToCreateConversation(String error) {
    return 'Échec de la création de la conversation : $error';
  }

  @override
  String get lockConversation => 'Verrouiller la conversation';

  @override
  String get createConversationAsClosed =>
      'Créer la conversation comme fermée (réponses non autorisées)';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountDescription => 'Supprimez votre compte de ce forum.';

  @override
  String get deleteAccountContactForumMessage =>
      'Votre compte est géré par le forum. Veuillez contacter directement le forum pour la suppression du compte. Utilisez le bouton « Nous contacter » en bas de la page d\'accueil du forum.';

  @override
  String get forumUrlUnavailable => 'L\'URL du forum est indisponible.';

  @override
  String get couldNotOpenForumUrl => 'Impossible d\'ouvrir l\'URL du forum.';

  @override
  String get noActionUrlAvailableForThisNotificationType =>
      'Aucune URL d\'action disponible pour ce type de notification.';

  @override
  String get signInToViewNotifications =>
      'Connectez-vous pour voir les notifications';

  @override
  String get youNeedToBeSignedInToViewYourNotifications =>
      'Vous devez être connecté pour voir vos notifications.';

  @override
  String get errorLoadingNotifications =>
      'Erreur lors du chargement des notifications';

  @override
  String get pullDownToRefresh => 'Tirez vers le bas pour actualiser';

  @override
  String get youHaveNoNewNotificationsCheckBackLater =>
      'Vous n\'avez aucune nouvelle notification. Revenez plus tard.';

  @override
  String get signInToViewProfile => 'Connectez-vous pour voir le profil';

  @override
  String get youNeedToBeSignedInToViewYourProfile =>
      'Vous devez etre connecte pour voir votre profil.';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get protectedForum => 'Forum protege';

  @override
  String forumIsPasswordProtected(String forumName) {
    return '$forumName est protege par mot de passe.';
  }

  @override
  String get enterButton => 'Entrer';

  @override
  String get recentPosts => 'Publications récentes';

  @override
  String passkeyNotAvailableInForum(int code) {
    return 'La clé d\'accès n\'est actuellement pas disponible sur ce forum (code : $code)';
  }

  @override
  String get initializingForum => 'Initialisation du forum…';

  @override
  String get retryConnection => 'Réessayer la connexion';

  @override
  String get pleaseConfirmPassword => 'Veuillez confirmer votre mot de passe';

  @override
  String get pleaseEnterTheForumPassword =>
      'Veuillez saisir le mot de passe du forum';

  @override
  String get editYourPost => 'Modifiez votre message...';

  @override
  String get topicIdIsMissingCannotNavigateToThePost =>
      'L\'ID du sujet est manquant. Navigation impossible vers le message.';

  @override
  String get conversationIsOpenForReplies =>
      'La conversation est ouverte aux réponses';

  @override
  String get conversationIsClosedNoRepliesAllowed =>
      'La conversation est fermée (réponses non autorisées)';

  @override
  String get pleaseEnterAUsername => 'Veuillez saisir un nom d\'utilisateur';

  @override
  String usernameMinLength(int count) {
    return 'Le nom d\'utilisateur doit comporter au moins $count caractères';
  }

  @override
  String get pleaseEnterAPassword => 'Veuillez saisir un mot de passe';

  @override
  String passwordMinLength(int count) {
    return 'Le mot de passe doit comporter au moins $count caractères';
  }

  @override
  String get writeYourTopicTitle => 'Titre de votre sujet...';

  @override
  String get writeYourTopicContent => 'Contenu de votre sujet...';

  @override
  String pushDisabledFor(String siteName) {
    return 'Notifications push désactivées pour $siteName';
  }

  @override
  String get failedToDisablePush =>
      'Impossible de désactiver les notifications push';

  @override
  String get thisForum => 'ce forum';
}
